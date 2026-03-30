'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { CustomEvaluationAI } from '@/lib/ai/CustomEvaluationAI';
import { revalidatePath } from 'next/cache';

export async function getEvaluations() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autorizado');

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .single();

  if (!membership?.couple_id) return [];

  const { data: evals, error } = await supabase
    .from('custom_evaluations')
    .select('*')
    .eq('couple_id', membership.couple_id)
    .neq('status', 'archived')
    .order('created_at', { ascending: false });

  if (error) throw error;
  return evals || [];
}

export async function getTopicSuggestions() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autorizado');

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .single();

  if (!membership?.couple_id) return [];

  const { data: coupleData } = await supabase
    .from('couples')
    .select('created_at')
    .eq('id', membership.couple_id)
    .single();

  let duration: string | null = null;
  if (coupleData) {
    const diffMs = Date.now() - new Date(coupleData.created_at).getTime();
    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
    duration = diffDays > 30 ? `${Math.floor(diffDays / 30)} meses` : `${diffDays} días`;
  }

  const ai = new CustomEvaluationAI();
  return await ai.suggestConnectionTopics({ duration });
}

export async function createEvaluation(topic: string) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autorizado');

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .single();

  if (!membership?.couple_id) throw new Error('Necesitas una pareja vinculada');

  // get couple context
  const { data: coupleData } = await supabase
    .from('couples')
    .select('created_at')
    .eq('id', membership.couple_id)
    .single();

  let duration: string | null = null;
  if (coupleData) {
    const diffMs = Date.now() - new Date(coupleData.created_at).getTime();
    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
    duration = diffDays > 30 ? `${Math.floor(diffDays/30)} meses` : `${diffDays} días`;
  }

  const ai = new CustomEvaluationAI();
  const evaluationPayload = await ai.generateEvaluation(topic, { duration });

  // Save to DB via Admin (or user if RLS permits, but admin is safer for multi-table transactions here)
  const admin = createAdminClient();

  const { data: newEval, error: evalError } = await admin
    .from('custom_evaluations')
    .insert({
      couple_id: membership.couple_id,
      created_by: user.id,
      topic,
      title: evaluationPayload.title,
      description: evaluationPayload.description,
      status: 'active',
      gemini_prompt_version: '2.5-flash',
    })
    .select('id')
    .single();

  if (evalError) throw evalError;

  const questionsToInsert = evaluationPayload.questions.map((q, idx) => ({
    evaluation_id: newEval.id,
    question_text: q.question_text,
    question_type: q.question_type,
    response_scale: q.response_scale || null,
    sort_order: idx,
  }));

  const { error: qError } = await admin
    .from('custom_evaluation_questions')
    .insert(questionsToInsert);

  if (qError) throw qError;

  revalidatePath('/dashboard/evaluaciones');
  return newEval.id;
}

export async function getEvaluation(id: string) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autorizado');

  const { data: evaluation, error } = await supabase
    .from('custom_evaluations')
    .select(`
      *,
      custom_evaluation_questions ( * )
    `)
    .eq('id', id)
    .single();

  if (error) throw error;

  // sort questions
  if (evaluation.custom_evaluation_questions) {
    evaluation.custom_evaluation_questions.sort((a: any, b: any) => a.sort_order - b.sort_order);
  }

  // fetch answers for ALL users to determine if both completed
  const admin = createAdminClient();
  const { data: allAnswers } = await admin
    .from('custom_evaluation_answers')
    .select('user_id, question_id, answer_value')
    .eq('evaluation_id', id);

  const numQuestions = evaluation.custom_evaluation_questions?.length || 0;
  const myAnswers = allAnswers?.filter((a: any) => a.user_id === user.id) || [];
  const completed = numQuestions > 0 && myAnswers.length === numQuestions;

  // find partner answers (any user_id that is not me)
  const partnerAnswers = allAnswers?.filter((a: any) => a.user_id !== user.id) || [];
  const partnerUserIds = [...new Set(partnerAnswers.map((a: any) => a.user_id))];
  // Assuming a couple is exactly 2 people, so if there's > 0 partner user ids and their answers >= numQuestions
  const partner_completed = numQuestions > 0 && partnerUserIds.some(pid => partnerAnswers.filter((a: any) => a.user_id === pid).length >= numQuestions);

  return {
    evaluation,
    questions: evaluation.custom_evaluation_questions || [],
    answers: myAnswers,
    completed,
    partner_completed
  };
}

export async function submitCustomEvaluationAnswers(evaluationId: string, answers: Record<string, any>) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autorizado');

  const admin = createAdminClient();

  const answersToInsert = Object.entries(answers).map(([qId, val]) => ({
    evaluation_id: evaluationId,
    user_id: user.id,
    question_id: qId,
    answer_value: val,
  }));

  // Upsert using rpc or direct insert with conflict resolution
  const { error } = await admin
    .from('custom_evaluation_answers')
    .upsert(answersToInsert, { onConflict: 'user_id, question_id' });

  if (error) throw error;

  revalidatePath(`/dashboard/evaluaciones/${evaluationId}`);
  return true;
}

export async function generateCustomInsights(evaluationId: string) {
  const admin = createAdminClient();
  const { data: { user } } = await (await createClient()).auth.getUser();
  if (!user) throw new Error('No autorizado');

  // get eval
  const { data: evaluation } = await admin
    .from('custom_evaluations')
    .select('topic')
    .eq('id', evaluationId)
    .single();

  if (!evaluation) throw new Error('Evaluación no encontrada');

  // get questions
  const { data: questions } = await admin
    .from('custom_evaluation_questions')
    .select('id, question_text, question_type, sort_order')
    .eq('evaluation_id', evaluationId)
    .order('sort_order', { ascending: true });

  if (!questions) throw new Error('Sin preguntas');

  // get all answers
  const { data: allAnswers } = await admin
    .from('custom_evaluation_answers')
    .select('user_id, question_id, answer_value')
    .eq('evaluation_id', evaluationId);

  // group answers by user
  const users = [...new Set((allAnswers || []).map(a => a.user_id))];
  if (users.length < 2) throw new Error('La pareja aún no ha completado.');

  const [uA, uB] = users;

  // get names
  const { data: profA } = await admin.from('profiles').select('full_name').eq('id', uA).single();
  const { data: profB } = await admin.from('profiles').select('full_name').eq('id', uB).single();

  const nameA = profA?.full_name || 'Participante 1';
  const nameB = profB?.full_name || 'Participante 2';

  // map answers strictly to questions order
  const getAns = (userId: string, qId: string) => {
    return allAnswers?.find(a => a.user_id === userId && a.question_id === qId)?.answer_value ?? 'Sin respuesta';
  };

  const ansA = questions.map(q => getAns(uA, q.id));
  const ansB = questions.map(q => getAns(uB, q.id));

  const qs = questions.map(q => ({ text: q.question_text, type: q.question_type }));

  const ai = new CustomEvaluationAI();
  const insights = await ai.analyzeResults(evaluation.topic, qs, ansA, ansB, { a: nameA, b: nameB });

  // Save to DB
  const { data: saved, error } = await admin
    .from('custom_evaluation_insights')
    .insert({
      evaluation_id: evaluationId,
      ai_summary: insights.ai_summary,
      ai_actions: insights.ai_actions,
    })
    .select('*')
    .single();

  // Mark eval as completed
  await admin
    .from('custom_evaluations')
    .update({ status: 'completed' })
    .eq('id', evaluationId);

  if (error) throw error;
  
  revalidatePath(`/dashboard/evaluaciones/${evaluationId}`);
  return saved;
}

export async function getInsights(evaluationId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from('custom_evaluation_insights')
    .select('*')
    .eq('evaluation_id', evaluationId)
    .limit(1)
    .single();
    
  if (error && error.code !== 'PGRST116') throw error; // ignore no rows
  return data || null;
}
