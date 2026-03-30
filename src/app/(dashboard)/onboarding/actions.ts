'use server';

import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';
import { ONBOARDING_ITEMS, ONBOARDING_DIMENSIONS, SCENARIO_SCORING } from '@/data/onboarding-data';
import type { ProfileVector } from '@/types/questionnaire';

/**
 * Get onboarding items (uses hardcoded data for reliability)
 */
export async function getOnboardingItems() {
  return ONBOARDING_ITEMS;
}

/**
 * Check if the current user has completed onboarding
 */
export async function getOnboardingStatus() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return { status: 'not_started' as const, session: null, profileVectors: [] };
  }

  // Check for onboarding session
  const { data: session } = await supabase
    .from('onboarding_sessions')
    .select('*')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!session) {
    return { status: 'not_started' as const, session: null, profileVectors: [] };
  }

  if (session.status === 'completed') {
    // Also fetch profile vectors
    const { data: vectors } = await supabase
      .from('profile_vectors')
      .select('dimension_slug, raw_score, normalized_score, item_count')
      .eq('user_id', user.id);

    return {
      status: 'completed' as const,
      session,
      profileVectors: (vectors || []) as ProfileVector[],
    };
  }

  return {
    status: session.status as 'in_progress',
    session,
    profileVectors: [],
  };
}

/**
 * Start or resume an onboarding session
 */
export async function startOnboardingSession() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) throw new Error('No autenticado');

  // Check for existing session
  const { data: existing } = await supabase
    .from('onboarding_sessions')
    .select('*')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (existing) {
    // Load saved responses
    const { data: responses } = await supabase
      .from('onboarding_responses')
      .select('item_id, answer_value')
      .eq('session_id', existing.id);

    const savedAnswers: Record<string, any> = {};
    (responses || []).forEach((r) => {
      savedAnswers[r.item_id] = r.answer_value;
    });

    return { session: existing, answers: savedAnswers };
  }

  // Create new session
  const { data: newSession, error } = await supabase
    .from('onboarding_sessions')
    .insert({
      user_id: user.id,
      status: 'in_progress',
      current_question_index: 0,
      progress_pct: 0,
      responses: {},
    })
    .select()
    .single();

  if (error) {
    console.error('Error creating onboarding session:', error);
    throw new Error('Error al crear la sesión de onboarding');
  }

  return { session: newSession, answers: {} };
}

/**
 * Save a single onboarding answer
 */
export async function saveOnboardingAnswer(
  sessionId: string,
  itemId: string,
  answerValue: any,
  currentIndex: number,
  progressPct: number
) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) throw new Error('No autenticado');

  // Upsert the response
  const { error: responseError } = await supabase
    .from('onboarding_responses')
    .upsert(
      {
        session_id: sessionId,
        item_id: itemId,
        answer_value: typeof answerValue === 'object' ? answerValue : { value: answerValue },
        answered_at: new Date().toISOString(),
      },
      { onConflict: 'session_id,item_id' }
    );

  if (responseError) {
    console.error('Error saving onboarding answer:', responseError);
    // Fallback to insert
    await supabase
      .from('onboarding_responses')
      .insert({
        session_id: sessionId,
        item_id: itemId,
        answer_value: typeof answerValue === 'object' ? answerValue : { value: answerValue },
        answered_at: new Date().toISOString(),
      });
  }

  // Update session progress
  await supabase
    .from('onboarding_sessions')
    .update({
      current_question_index: currentIndex,
      progress_pct: progressPct,
      status: 'in_progress',
      updated_at: new Date().toISOString(),
    })
    .eq('id', sessionId);

  return { success: true };
}

/**
 * Complete onboarding — compute and store profile vectors
 */
export async function completeOnboarding(
  sessionId: string,
  answers: Record<string, any>
) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) throw new Error('No autenticado');

  // Compute profile vectors from answers
  const dimensionScores: Record<string, { total: number; count: number }> = {};

  // Initialize all dimensions
  ONBOARDING_DIMENSIONS.forEach((dim) => {
    dimensionScores[dim.slug] = { total: 0, count: 0 };
  });

  // Process each answer
  ONBOARDING_ITEMS.forEach((item) => {
    const answer = answers[item.id];
    if (answer === undefined || answer === null) return;

    // Extract numeric value
    const rawValue = typeof answer === 'object' && answer.value !== undefined
      ? answer.value
      : answer;

    if (item.question_type === 'LIKERT-5') {
      const numVal = parseFloat(String(rawValue));
      if (!isNaN(numVal)) {
        // Reverse score for conflict_avoidance
        const score = item.construct_slug === 'conflict_avoidance'
          ? (6 - numVal) // Invert: 5→1, 4→2, 3→3, 2→4, 1→5
          : numVal;
        dimensionScores[item.dimension_slug].total += score;
        dimensionScores[item.dimension_slug].count += 1;
      }
    } else if (item.question_type === 'ESCENARIO') {
      // Scenario scoring: apply cross-dimension weights
      const scenarioMap = SCENARIO_SCORING[item.construct_slug];
      if (scenarioMap && scenarioMap[String(rawValue)]) {
        const weights = scenarioMap[String(rawValue)];
        Object.entries(weights).forEach(([dimSlug, weight]) => {
          if (dimensionScores[dimSlug]) {
            dimensionScores[dimSlug].total += weight;
            dimensionScores[dimSlug].count += 1;
          }
        });
      }
    }
  });

  // Normalize to 0-100 and upsert profile vectors
  const vectors: ProfileVector[] = [];
  for (const [dimSlug, scores] of Object.entries(dimensionScores)) {
    if (scores.count === 0) continue;

    const rawScore = scores.total / scores.count;
    const normalizedScore = Math.round((rawScore / 5) * 100); // Normalize 1-5 → 0-100

    vectors.push({
      dimension_slug: dimSlug,
      raw_score: rawScore,
      normalized_score: normalizedScore,
      item_count: scores.count,
    });

    // Upsert into profile_vectors
    const { error } = await supabase
      .from('profile_vectors')
      .upsert(
        {
          user_id: user.id,
          dimension_slug: dimSlug,
          raw_score: rawScore,
          normalized_score: normalizedScore,
          item_count: scores.count,
          version: 1,
          updated_at: new Date().toISOString(),
        },
        { onConflict: 'user_id,dimension_slug' }
      );

    if (error) {
      console.error(`Error saving profile vector for ${dimSlug}:`, error);
    }
  }

  // Mark session as completed
  const { error: sessionError } = await supabase
    .from('onboarding_sessions')
    .update({
      status: 'completed',
      progress_pct: 100,
      completed_at: new Date().toISOString(),
      responses: answers,
      updated_at: new Date().toISOString(),
    })
    .eq('id', sessionId);

  if (sessionError) {
    console.error('Error completing onboarding session:', sessionError);
    throw new Error('Error al completar el onboarding');
  }

  revalidatePath('/dashboard');
  revalidatePath('/onboarding');

  return { success: true, vectors };
}

/**
 * Get profile vectors for a user
 */
export async function getProfileVectors(userId?: string) {
  const supabase = await createClient();

  if (!userId) {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return [];
    userId = user.id;
  }

  const { data } = await supabase
    .from('profile_vectors')
    .select('dimension_slug, raw_score, normalized_score, item_count')
    .eq('user_id', userId);

  return (data || []) as ProfileVector[];
}
