'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { GoogleGenAI } from '@google/genai';
import { revalidatePath } from 'next/cache';
import { logActivityEvent } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';

const QUESTIONS_PER_ROUND = 5;
const MAX_POINTS_PER_QUESTION = 3;

export interface MeConocesQuestion {
  id: string;
  questionText: string;
  answerPrompt: string;
  questionType: 'LIKERT-5' | 'MULTIPLE_CHOICE' | 'SHORT_TEXT' | 'RANK';
  dimension: string;
  options: any[] | null;
}

export interface MeConocesRound {
  id: string;
  answererId: string;
  guesserId: string;
  status: 'pending_answers' | 'pending_guesses' | 'completed';
  score: number | null;
  scorePct: number | null;
  dimensionScores: Record<string, number>;
  startedAt: string;
  completedAt: string | null;
  answererName: string;
  guesserName: string;
}

export interface MeConocesEntry {
  id: string;
  questionId: string;
  sortOrder: number;
  questionText: string;
  questionType: string;
  dimension: string;
  options: any[] | null;
  realAnswer: any;
  guessedAnswer: any;
  pointsAwarded: number;
  matchLevel: string | null;
  aiJudgment: string | null;
}

export interface MeConocesScore {
  dimension: string;
  knowledgeScore: number;
  roundsPlayed: number;
  lastPlayed: string | null;
}

export async function getRandomQuestions(count: number = QUESTIONS_PER_ROUND): Promise<MeConocesQuestion[]> {
  const supabase = await createClient();
  const { data } = await supabase
    .from('meconoces_questions')
    .select('*')
    .eq('active', true)
    .order('created_at')
    .limit(count * 3);

  if (!data || data.length === 0) return [];

  const shuffled = [...data].sort(() => Math.random() - 0.5);
  const selected = shuffled.slice(0, count);

  return selected.map(q => ({
    id: q.id,
    questionText: q.question_text,
    answerPrompt: q.answer_prompt,
    questionType: q.question_type,
    dimension: q.dimension,
    options: q.options,
  }));
}

export async function startMeConocesRound(): Promise<{ roundId: string } | { error: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { error: 'No autenticado' };

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return { error: 'No tienes pareja' };

  const admin = createAdminClient();
  const { data: members } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', membership.couple_id)
    .neq('user_id', user.id);

  if (!members || members.length === 0) return { error: 'No se encontró tu pareja' };

  const partnerId = members[0].user_id;

  const { data: existingRound } = await supabase
    .from('meconoces_rounds')
    .select('id')
    .eq('couple_id', membership.couple_id)
    .in('status', ['pending_answers', 'pending_guesses'])
    .limit(1)
    .single();

  if (existingRound) return { error: 'Ya hay una ronda en curso' };

  const questions = await getRandomQuestions(QUESTIONS_PER_ROUND);
  if (questions.length < QUESTIONS_PER_ROUND) {
    return { error: 'No hay suficientes preguntas disponibles' };
  }

  const { data: round, error: roundError } = await supabase
    .from('meconoces_rounds')
    .insert({
      couple_id: membership.couple_id,
      answerer_id: user.id,
      guesser_id: partnerId,
      status: 'pending_answers',
    })
    .select()
    .single();

  if (roundError) return { error: 'Error al crear la ronda' };

  const entries = questions.map((q, i) => ({
    round_id: round.id,
    question_id: q.id,
    sort_order: i,
  }));

  const { error: entriesError } = await supabase
    .from('meconoces_entries')
    .insert(entries);

  if (entriesError) return { error: 'Error al crear las preguntas' };

  revalidatePath('/dashboard/jugar/meconoces');

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  await logActivityEvent('meconoces.started', 'meconoces_round', round.id, {
    partner_name: profile?.full_name || 'Tu pareja',
  });

  return { roundId: round.id };
}

export async function submitRoundAnswers(roundId: string, answers: { entryId: string; answer: any }[]): Promise<{ success: boolean; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false, error: 'No autenticado' };

  const { data: round } = await supabase
    .from('meconoces_rounds')
    .select('answerer_id, status')
    .eq('id', roundId)
    .single();

  if (!round) return { success: false, error: 'Ronda no encontrada' };
  if (round.answerer_id !== user.id) return { success: false, error: 'No eres el respondiente' };
  if (round.status !== 'pending_answers') return { success: false, error: 'La ronda no está en estado de respuestas' };

  for (const a of answers) {
    await supabase
      .from('meconoces_entries')
      .update({ real_answer: a.answer })
      .eq('id', a.entryId);
  }

  await supabase
    .from('meconoces_rounds')
    .update({ status: 'pending_guesses' })
    .eq('id', roundId);

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  await logActivityEvent('meconoces.answers_submitted', 'meconoces_round', roundId, {
    partner_name: profile?.full_name || 'Tu pareja',
  });

  revalidatePath('/dashboard/jugar/meconoces');
  return { success: true };
}

export async function submitRoundGuesses(roundId: string, guesses: { entryId: string; guess: any }[]): Promise<{ success: boolean; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false, error: 'No autenticado' };

  const { data: round } = await supabase
    .from('meconoces_rounds')
    .select('guesser_id, status')
    .eq('id', roundId)
    .single();

  if (!round) return { success: false, error: 'Ronda no encontrada' };
  if (round.guesser_id !== user.id) return { success: false, error: 'No eres el adivinador' };
  if (round.status !== 'pending_guesses') return { success: false, error: 'La ronda no está en estado de adivinanza' };

  for (const g of guesses) {
    await supabase
      .from('meconoces_entries')
      .update({ guessed_answer: g.guess })
      .eq('id', g.entryId);
  }

  await scoreRound(roundId);

  revalidatePath('/dashboard/jugar/meconoces');
  return { success: true };
}

export async function scoreRound(roundId: string): Promise<{ success: boolean; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false, error: 'No autenticado' };

  const { data: round } = await supabase
    .from('meconoces_rounds')
    .select('*')
    .eq('id', roundId)
    .single();

  if (!round) return { success: false, error: 'Ronda no encontrada' };
  if (round.status !== 'pending_guesses') return { success: false, error: 'La ronda no está lista para puntuar' };

  const { data: entries } = await supabase
    .from('meconoces_entries')
    .select(`
      id,
      question_id,
      real_answer,
      guessed_answer,
      meconoces_questions(question_type, dimension)
    `)
    .eq('round_id', roundId);

  if (!entries || entries.length === 0) return { success: false, error: 'No hay entradas' };

  let totalScore = 0;
  const dimensionTotals: Record<string, number> = {};
  const dimensionCounts: Record<string, number> = {};

  const admin = createAdminClient();
  const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

  for (const entry of entries) {
    const qType = (entry.meconoces_questions as any).question_type;
    const dimension = (entry.meconoces_questions as any).dimension;
    const real = entry.real_answer;
    const guessed = entry.guessed_answer;

    let points = 0;
    let matchLevel = 'wrong';
    let aiJudgment = null;

    if (qType === 'LIKERT-5') {
      const realNum = typeof real === 'number' ? real : parseInt(real);
      const guessedNum = typeof guessed === 'number' ? guessed : parseInt(guessed);
      const diff = Math.abs(realNum - guessedNum);
      if (diff === 0) { points = 3; matchLevel = 'exact'; }
      else if (diff === 1) { points = 2; matchLevel = 'close'; }
      else { points = 0; matchLevel = 'wrong'; }
    } else if (qType === 'MULTIPLE_CHOICE') {
      if (JSON.stringify(real) === JSON.stringify(guessed)) {
        points = 3; matchLevel = 'exact';
      } else {
        points = 0; matchLevel = 'wrong';
      }
    } else if (qType === 'SHORT_TEXT') {
      try {
        const result = await ai.models.generateContent({
          model: 'gemini-2.0-flash',
          contents: `Given the real answer is: "${real}" and the guess was: "${guessed}", are these the same, similar, or different? Respond with JSON only: {"match": "exact" | "close" | "wrong", "reason": "one sentence"}`,
          config: { responseMimeType: 'application/json' },
        });
        const judgment = JSON.parse(result.text || '{}');
        matchLevel = judgment.match || 'wrong';
        aiJudgment = judgment.reason || '';
        points = matchLevel === 'exact' ? 3 : matchLevel === 'close' ? 2 : 0;
      } catch {
        matchLevel = 'wrong';
        points = 0;
      }
    } else if (qType === 'RANK') {
      const realArr = Array.isArray(real) ? real : [];
      const guessedArr = Array.isArray(guessed) ? guessed : [];
      if (JSON.stringify(realArr) === JSON.stringify(guessedArr)) {
        points = 3; matchLevel = 'exact';
      } else {
        let correct = 0;
        for (let i = 0; i < Math.min(realArr.length, guessedArr.length); i++) {
          if (realArr[i] === guessedArr[i]) correct++;
        }
        const pct = correct / realArr.length;
        if (pct >= 0.8) { points = 3; matchLevel = 'exact'; }
        else if (pct >= 0.5) { points = 2; matchLevel = 'close'; }
        else { points = 0; matchLevel = 'wrong'; }
      }
    }

    await supabase
      .from('meconoces_entries')
      .update({ points_awarded: points, match_level: matchLevel, ai_judgment: aiJudgment })
      .eq('id', entry.id);

    totalScore += points;
    dimensionTotals[dimension] = (dimensionTotals[dimension] || 0) + points;
    dimensionCounts[dimension] = (dimensionCounts[dimension] || 0) + 1;
  }

  const maxScore = entries.length * MAX_POINTS_PER_QUESTION;
  const scorePct = Math.round((totalScore / maxScore) * 100);

  const dimScores: Record<string, number> = {};
  for (const dim of Object.keys(dimensionTotals)) {
    dimScores[dim] = Math.round((dimensionTotals[dim] / (dimensionCounts[dim] * MAX_POINTS_PER_QUESTION)) * 100);
  }

  await supabase
    .from('meconoces_rounds')
    .update({
      status: 'completed',
      score: totalScore,
      score_pct: scorePct,
      dimension_scores: dimScores,
      completed_at: new Date().toISOString(),
    })
    .eq('id', roundId);

  for (const dim of Object.keys(dimScores)) {
    await updateKnowledgeScore(supabase, round.couple_id, dim, round.answerer_id, round.guesser_id, dimScores[dim]);
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  await logActivityEvent('meconoces.completed', 'meconoces_round', roundId, {
    partner_name: profile?.full_name || 'Tu pareja',
    score: totalScore,
    scorePct,
  });

  revalidatePath('/dashboard/jugar/meconoces');
  return { success: true };
}

async function updateKnowledgeScore(
  supabase: any,
  coupleId: string,
  dimension: string,
  aboutUserId: string,
  guesserId: string,
  roundScore: number
) {
  const { data: existing } = await supabase
    .from('meconoces_scores')
    .select('*')
    .eq('couple_id', coupleId)
    .eq('dimension', dimension)
    .eq('about_user_id', aboutUserId)
    .eq('guesser_id', guesserId)
    .single();

  if (existing) {
    const newScore = Math.round((existing.knowledge_score * existing.rounds_played + roundScore) / (existing.rounds_played + 1));
    await supabase
      .from('meconoces_scores')
      .update({
        knowledge_score: newScore,
        rounds_played: existing.rounds_played + 1,
        last_played: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq('id', existing.id);
  } else {
    await supabase
      .from('meconoces_scores')
      .insert({
        couple_id: coupleId,
        dimension,
        about_user_id: aboutUserId,
        guesser_id: guesserId,
        knowledge_score: roundScore,
        rounds_played: 1,
        last_played: new Date().toISOString(),
      });
  }
}

export async function getActiveRound(): Promise<MeConocesRound | null> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return null;

  const { data: round } = await supabase
    .from('meconoces_rounds')
    .select('*')
    .eq('couple_id', membership.couple_id)
    .in('status', ['pending_answers', 'pending_guesses'])
    .order('created_at', { ascending: false })
    .limit(1)
    .single();

  if (!round) return null;

  const admin = createAdminClient();
  const [answererResult, guesserResult] = await Promise.all([
    admin.from('profiles').select('full_name').eq('id', round.answerer_id).single(),
    admin.from('profiles').select('full_name').eq('id', round.guesser_id).single(),
  ]);

  return {
    id: round.id,
    answererId: round.answerer_id,
    guesserId: round.guesser_id,
    status: round.status,
    score: round.score,
    scorePct: round.score_pct,
    dimensionScores: round.dimension_scores || {},
    startedAt: round.started_at,
    completedAt: round.completed_at,
    answererName: answererResult.data?.full_name || 'Tu pareja',
    guesserName: guesserResult.data?.full_name || 'Tu pareja',
  };
}

export async function getRoundDetails(roundId: string): Promise<{ round: MeConocesRound | null; entries: MeConocesEntry[] }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { round: null, entries: [] };

  const { data: round } = await supabase
    .from('meconoces_rounds')
    .select('*')
    .eq('id', roundId)
    .single();

  if (!round) return { round: null, entries: [] };

  const admin = createAdminClient();
  const [answererResult, guesserResult] = await Promise.all([
    admin.from('profiles').select('full_name').eq('id', round.answerer_id).single(),
    admin.from('profiles').select('full_name').eq('id', round.guesser_id).single(),
  ]);

  const roundData: MeConocesRound = {
    id: round.id,
    answererId: round.answerer_id,
    guesserId: round.guesser_id,
    status: round.status,
    score: round.score,
    scorePct: round.score_pct,
    dimensionScores: round.dimension_scores || {},
    startedAt: round.started_at,
    completedAt: round.completed_at,
    answererName: answererResult.data?.full_name || 'Tu pareja',
    guesserName: guesserResult.data?.full_name || 'Tu pareja',
  };

  const { data: entries } = await supabase
    .from('meconoces_entries')
    .select(`
      id,
      question_id,
      sort_order,
      real_answer,
      guessed_answer,
      points_awarded,
      match_level,
      ai_judgment,
      meconoces_questions(question_text, question_type, dimension, options)
    `)
    .eq('round_id', roundId)
    .order('sort_order', { ascending: true });

  const entryData: MeConocesEntry[] = (entries || []).map((e: any) => ({
    id: e.id,
    questionId: e.question_id,
    sortOrder: e.sort_order,
    questionText: (e.meconoces_questions as any).question_text,
    questionType: (e.meconoces_questions as any).question_type,
    dimension: (e.meconoces_questions as any).dimension,
    options: (e.meconoces_questions as any).options,
    realAnswer: e.real_answer,
    guessedAnswer: e.guessed_answer,
    pointsAwarded: e.points_awarded,
    matchLevel: e.match_level,
    aiJudgment: e.ai_judgment,
  }));

  return { round: roundData, entries: entryData };
}

export async function getMeConocesScores(): Promise<MeConocesScore[]> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return [];

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return [];

  const { data: scores } = await supabase
    .from('meconoces_scores')
    .select('dimension, knowledge_score, rounds_played, last_played')
    .eq('couple_id', membership.couple_id)
    .eq('guesser_id', user.id);

  return (scores || []).map(s => ({
    dimension: s.dimension,
    knowledgeScore: s.knowledge_score,
    roundsPlayed: s.rounds_played,
    lastPlayed: s.last_played,
  }));
}

export async function getMyRoundEntries(roundId: string, userId: string): Promise<MeConocesEntry[]> {
  const supabase = await createClient();
  const { data: entries } = await supabase
    .from('meconoces_entries')
    .select(`
      id,
      question_id,
      sort_order,
      real_answer,
      guessed_answer,
      points_awarded,
      match_level,
      ai_judgment,
      meconoces_questions(question_text, question_type, dimension, options)
    `)
    .eq('round_id', roundId)
    .order('sort_order', { ascending: true });

  return (entries || []).map((e: any) => ({
    id: e.id,
    questionId: e.question_id,
    sortOrder: e.sort_order,
    questionText: (e.meconoces_questions as any).question_text,
    questionType: (e.meconoces_questions as any).question_type,
    dimension: (e.meconoces_questions as any).dimension,
    options: (e.meconoces_questions as any).options,
    realAnswer: e.real_answer,
    guessedAnswer: e.guessed_answer,
    pointsAwarded: e.points_awarded,
    matchLevel: e.match_level,
    aiJudgment: e.ai_judgment,
  }));
}
