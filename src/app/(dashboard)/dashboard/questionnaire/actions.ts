'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { revalidatePath } from 'next/cache';
import { QuestionnaireSection, Question } from '@/types/questionnaire';
import { generateDynamicAssessment } from '@/lib/ai/orchestrator';

/**
 * Get questionnaire sections and questions from database
 */
/**
 * Get dynamic questionnaire data based on AI generated items
 */
export async function getQuestionnaireData() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('Not authenticated');

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .single();

  if (!membership) throw new Error('No couple found');

  // Load the AI generated assessment
  const admin = createAdminClient();
  const { data: assessment } = await admin
    .from('generated_assessments')
    .select('id')
    .eq('couple_id', membership.couple_id)
    .order('created_at', { ascending: false })
    .limit(1)
    .single();

  if (!assessment) {
    throw new Error('No assessment generated yet');
  }

  // Get dynamic items
  const { data: items } = await admin
    .from('generated_assessment_items')
    .select('*')
    .eq('assessment_id', assessment.id)
    .order('sort_order', { ascending: true });

  // Use a consistent slug as the section ID for the V2 flow
  const sectionId = 'assessment-v2';

  const sections: QuestionnaireSection[] = [{
    id: sectionId,
    slug: 'assessment-v2',
    name: 'Tu Evaluación de Pareja',
    description: 'Preguntas personalizadas diseñadas por IA',
    sort_order: 1,
    estimated_questions: items?.length || 28,
  }];

  const DEFAULT_LIKERT_5_OPTIONS = [
    { value: '1', label: 'Totalmente en desacuerdo', order: 1 },
    { value: '2', label: 'En desacuerdo', order: 2 },
    { value: '3', label: 'Neutral', order: 3 },
    { value: '4', label: 'De acuerdo', order: 4 },
    { value: '5', label: 'Totalmente de acuerdo', order: 5 },
  ];

  const questionsBySection: Record<string, Question[]> = {
    [sectionId]: (items || []).map((row) => {
      // Parse response_scale from DB (JSONB) into options array
      const rawScale = row.response_scale;
      const options = Array.isArray(rawScale) && rawScale.length > 0
        ? rawScale
        : DEFAULT_LIKERT_5_OPTIONS;

      return {
        id: row.item_bank_id || row.id,
        section_id: sectionId,
        question_number: row.sort_order,
        question_text: row.question_text,
        question_type: row.question_type,
        is_sensitive: false,
        is_required: true,
        is_opt_in: false,
        metadata: {
          dimension: row.target_dimension,
          options,
        } as any,
      };
    })
  };

  return { sections, questionsBySection, assessmentId: assessment.id };
}

/**
 * Check if BOTH partners completed onboarding to generate assessment
 */
export async function checkAssessmentPreconditions() {
  const supabase = await createClient();
  const admin = createAdminClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) return { status: 'error' };

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .single();

  if (!membership) return { status: 'waiting_for_partner' };

  const coupleId = membership.couple_id;

  // Check if assessment already exists
  const { data: assessment } = await admin
    .from('generated_assessments')
    .select('id')
    .eq('couple_id', coupleId)
    .order('created_at', { ascending: false })
    .limit(1)
    .single();

  if (assessment) return { status: 'ready', assessmentId: assessment.id };

  // Check onboarding statuses
  const { data: members } = await admin.from('couple_members').select('user_id').eq('couple_id', coupleId);
  if (!members || members.length < 2) return { status: 'waiting_for_partner' };

  const { data: sessions } = await admin
    .from('onboarding_sessions')
    .select('status')
    .in('user_id', members.map(m => m.user_id));

  const completeCount = sessions?.filter(s => s.status === 'completed').length || 0;

  if (completeCount === 2) {
    return { status: 'needs_generation', coupleId };
  }

  return { status: 'waiting_for_partner' };
}

/**
 * Server action to actually fire the Generation
 */
export async function generateCustomAssessment(coupleId: string) {
  try {
    const result = await generateDynamicAssessment({ coupleId });
    revalidatePath('/dashboard/questionnaire');
    return { success: true, ...result };
  } catch (err: any) {
    console.error('Generation err:', err);
    return { success: false, error: err.message };
  }
}

/**
 * Start a new questionnaire session or return existing in-progress session
 */
export async function startQuestionnaireSession() {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (!user || authError) {
    throw new Error('No autenticado');
  }

  // Check for already-completed session first
  const { data: completedSession } = await supabase
    .from('response_sessions')
    .select('*')
    .eq('user_id', user.id)
    .eq('status', 'completed')
    .order('completed_at', { ascending: false })
    .limit(1)
    .single();

  if (completedSession) {
    return { session: completedSession, answers: {} };
  }

  // Check for existing in-progress session
  const { data: existingSession } = await supabase
    .from('response_sessions')
    .select('*')
    .eq('user_id', user.id)
    .in('status', ['started', 'in_progress'])
    .order('started_at', { ascending: false })
    .limit(1)
    .single();

  if (existingSession) {
    // Fetch existing answers for this session
    const { data: existingAnswers } = await supabase
      .from('responses')
      .select('question_id, answer_value')
      .eq('session_id', existingSession.id);

    return {
      session: existingSession,
      answers: (existingAnswers || []).reduce((acc: Record<string, any>, a) => {
        acc[a.question_id] = a.answer_value;
        return acc;
      }, {}),
    };
  }

  // We must link the session to the generated_assessment_id for V2
  const admin = createAdminClient();
  const { data: membership } = await supabase.from('couple_members').select('couple_id').eq('user_id', user.id).single();
  const { data: assessment } = await admin.from('generated_assessments').select('id').eq('couple_id', membership?.couple_id).order('created_at', { ascending: false }).limit(1).single();

  const { data: fallbackQ } = await supabase.from('questionnaires').select('id').limit(1).single();

  if (!assessment) {
    throw new Error('Evaluación no generada aún.');
  }

  // Create new session
  const { data: newSession, error: sessionError } = await admin
    .from('response_sessions')
    .insert({
      user_id: user.id,
      questionnaire_id: fallbackQ?.id || '00000000-0000-0000-0000-000000000000', // Need to satisfy NOT NULL constraints if DB wasn't updated
      generated_assessment_id: assessment.id,
      stage: 'couple_v2',
      status: 'in_progress',
      progress_pct: 0,
    })
    .select()
    .single();

  if (sessionError) {
    console.error('Error creating session:', sessionError);
    throw new Error('Error al crear la sesión: ' + sessionError.message);
  }

  return { session: newSession, answers: {} };
}

/**
 * Save a single answer and update session progress
 */
export async function saveAnswer(
  sessionId: string,
  questionId: string,
  answerValue: any,
  _currentSection: string,
  currentQuestionIndex: number,
  progressPct: number
) {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (!user || authError) {
    throw new Error('No autenticado');
  }

  // Upsert the response (insert or update if exists for this session+question)
  // questionId is now the actual UUID from the database
  const { error: responseError } = await supabase
    .from('responses')
    .upsert(
      {
        session_id: sessionId,
        question_id: questionId,
        answer_value: typeof answerValue === 'object' ? answerValue : { value: answerValue },
        answered_at: new Date().toISOString(),
      },
      {
        onConflict: 'session_id,question_id',
      }
    );

  if (responseError) {
    console.error('Error saving answer:', responseError);
    // Fallback: try plain insert
    const { error: insertError } = await supabase
      .from('responses')
      .insert({
        session_id: sessionId,
        question_id: questionId,
        answer_value: typeof answerValue === 'object' ? answerValue : { value: answerValue },
        answered_at: new Date().toISOString(),
      });

    if (insertError) {
      console.error('Error inserting answer:', insertError);
    }
  }

  // Update session progress — only use columns that exist
  const { error: sessionError } = await supabase
    .from('response_sessions')
    .update({
      status: 'in_progress',
      progress_pct: progressPct,
    })
    .eq('id', sessionId);

  if (sessionError) {
    console.error('Error updating session:', sessionError);
  }

  return { success: true };
}

/**
 * Complete the questionnaire session
 */
export async function completeQuestionnaire(sessionId: string) {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (!user || authError) {
    throw new Error('No autenticado');
  }

  // Mark session as completed
  const { error: sessionError } = await supabase
    .from('response_sessions')
    .update({
      status: 'completed',
      progress_pct: 100,
      completed_at: new Date().toISOString(),
    })
    .eq('id', sessionId);

  if (sessionError) {
    console.error('Error completing session:', sessionError);
    throw new Error('Error al completar el cuestionario');
  }

  revalidatePath('/dashboard');
  revalidatePath('/dashboard/nosotros');

  return { success: true };
}

/**
 * Get the user's questionnaire status
 */
export async function getQuestionnaireStatus() {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (!user || authError) {
    return { status: 'not_started' as const, session: null };
  }

  // Check for completed session
  const { data: completedSession } = await supabase
    .from('response_sessions')
    .select('*')
    .eq('user_id', user.id)
    .eq('status', 'completed')
    .order('completed_at', { ascending: false })
    .limit(1)
    .single();

  if (completedSession) {
    return { status: 'completed' as const, session: completedSession };
  }

  // Check for in-progress session
  const { data: inProgressSession } = await supabase
    .from('response_sessions')
    .select('*')
    .eq('user_id', user.id)
    .in('status', ['started', 'in_progress'])
    .order('started_at', { ascending: false })
    .limit(1)
    .single();

  if (inProgressSession) {
    return { status: 'in_progress' as const, session: inProgressSession };
  }

  return { status: 'not_started' as const, session: null };
}

/**
 * Get couple status for the current user
 */
export async function getCoupleStatus() {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (!user || authError) {
    return { hasCouple: false, couple: null, partner: null, bothCompleted: false };
  }

  // Get user's couple membership
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id, role')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) {
    return { hasCouple: false, couple: null, partner: null, bothCompleted: false };
  }

  // Get couple details
  const { data: couple } = await supabase
    .from('couples')
    .select('*')
    .eq('id', membership.couple_id)
    .single();

  const admin = createAdminClient();

  // Get all members of this couple (use admin to bypass RLS)
  const { data: members } = await admin
    .from('couple_members')
    .select('user_id, role')
    .eq('couple_id', membership.couple_id);

  const partnerMember = members?.find((m) => m.user_id !== user.id);

  // Check if partner exists (use admin to bypass profiles RLS)
  let partner = null;
  if (partnerMember) {
    const { data: partnerProfile } = await admin
      .from('profiles')
      .select('id, full_name, avatar_url')
      .eq('id', partnerMember.user_id)
      .single();
    partner = partnerProfile;
  }

  // Check if both have completed questionnaires
  let bothCompleted = false;
  if (partnerMember) {
    const { data: partnerSession } = await admin
      .from('response_sessions')
      .select('id')
      .eq('user_id', partnerMember.user_id)
      .eq('status', 'completed')
      .limit(1)
      .single();

    const { data: mySession } = await admin
      .from('response_sessions')
      .select('id')
      .eq('user_id', user.id)
      .eq('status', 'completed')
      .limit(1)
      .single();

    bothCompleted = !!(partnerSession && mySession);
  }

  return {
    hasCouple: true,
    couple,
    partner,
    bothCompleted,
    memberCount: members?.length || 1,
  };
}
