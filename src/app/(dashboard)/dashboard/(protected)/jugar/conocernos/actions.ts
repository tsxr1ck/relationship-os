'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { logActivityEvent } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';

/* ══════════════════════════════════════
   CONOCERNOS — Server Actions
   Daily question game for couples
   ══════════════════════════════════════ */

export interface ConocenosDaily {
  id: string;
  questionText: string;
  questionDate: string;
  revealAt: string;
  dimension: string;
  tone: string;
  hasAnswered: boolean;
  partnerHasAnswered: boolean;
  isRevealed: boolean;
  userAnswer: string | null;
  partnerAnswer: string | null;
  userReaction: { emoji: string | null; comment: string | null } | null;
  partnerReaction: { emoji: string | null; comment: string | null } | null;
}

export interface ConocenosHistoryItem {
  id: string;
  questionText: string;
  questionDate: string;
  dimension: string;
  userAnswer: string | null;
  partnerAnswer: string | null;
}

// ── Get or Create Today's Question ──
export async function getOrCreateDailyQuestion(): Promise<ConocenosDaily | null> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  const admin = createAdminClient();

  // Get couple ID
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return null;
  const coupleId = membership.couple_id;

  // Get couple timezone
  const { data: couple } = await supabase
    .from('couples')
    .select('timezone')
    .eq('id', coupleId)
    .single();

  const tz = couple?.timezone || 'America/Mexico_City';
  const today = new Date().toISOString().split('T')[0];

  // Check if question exists for today
  let { data: daily } = await supabase
    .from('conocernos_daily')
    .select('id, question_id, question_date, reveal_at')
    .eq('couple_id', coupleId)
    .eq('question_date', today)
    .single();

  // If no question for today, create one
  if (!daily) {
    // Get IDs of questions already used by this couple in the last 90 days
    const ninetyDaysAgo = new Date();
    ninetyDaysAgo.setDate(ninetyDaysAgo.getDate() - 90);

    const { data: recentDailies } = await supabase
      .from('conocernos_daily')
      .select('question_id')
      .eq('couple_id', coupleId)
      .gte('question_date', ninetyDaysAgo.toISOString().split('T')[0]);

    const usedIds = recentDailies?.map(d => d.question_id) || [];

    // Pick a random unused question
    let query = admin
      .from('conocernos_questions')
      .select('id')
      .eq('active', true);

    if (usedIds.length > 0) {
      query = query.not('id', 'in', `(${usedIds.join(',')})`);
    }

    const { data: availableQuestions } = await query;

    if (!availableQuestions || availableQuestions.length === 0) {
      // All questions used — reset by picking any active question
      const { data: anyQ } = await admin
        .from('conocernos_questions')
        .select('id')
        .eq('active', true)
        .limit(1);
      if (!anyQ || anyQ.length === 0) return null;
      availableQuestions?.push(anyQ[0]);
    }

    const pool = availableQuestions || [];
    const randomQ = pool[Math.floor(Math.random() * pool.length)];

    // Calculate reveal time: today at 8PM in couple's timezone
    // Simple approach: set reveal_at to today 20:00 UTC-6 for Mexico City
    const revealDate = new Date(`${today}T20:00:00`);
    // Adjust based on timezone offset (simple for common MX timezones)
    const offsetHours = tz === 'America/Mexico_City' ? 6 :
      tz === 'America/Tijuana' ? 8 :
        tz === 'America/Hermosillo' ? 4 : 6;
    revealDate.setHours(20 + offsetHours, 0, 0, 0);

    const { data: newDaily, error } = await admin
      .from('conocernos_daily')
      .insert({
        couple_id: coupleId,
        question_id: randomQ.id,
        question_date: today,
        reveal_at: revealDate.toISOString(),
      })
      .select('id, question_id, question_date, reveal_at')
      .single();

    if (error) {
      console.error('Failed to create daily question:', error);
      return null;
    }
    daily = newDaily;
  }

  if (!daily) return null;

  // Get the question text
  const { data: question } = await admin
    .from('conocernos_questions')
    .select('question_text, dimension, tone')
    .eq('id', daily.question_id)
    .single();

  if (!question) return null;

  // Get user's answer
  const { data: userAnswer } = await supabase
    .from('conocernos_answers')
    .select('answer_text')
    .eq('daily_id', daily.id)
    .eq('user_id', user.id)
    .single();

  // Get partner info
  const { data: partnerMembers } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', coupleId)
    .neq('user_id', user.id);

  const partnerId = partnerMembers?.[0]?.user_id;
  let partnerHasAnswered = false;
  let partnerAnswerText: string | null = null;

  if (partnerId) {
    const { data: partnerAns } = await admin
      .from('conocernos_answers')
      .select('answer_text')
      .eq('daily_id', daily.id)
      .eq('user_id', partnerId)
      .single();

    partnerHasAnswered = !!partnerAns;
    partnerAnswerText = partnerAns?.answer_text || null;
  }

  const now = new Date();
  const revealTime = new Date(daily.reveal_at);
  const isRevealed = now >= revealTime;

  // Get reactions if revealed
  let userReaction = null;
  let partnerReaction = null;

  if (isRevealed && partnerId) {
    const { data: myReaction } = await supabase
      .from('conocernos_reactions')
      .select('emoji, comment')
      .eq('daily_id', daily.id)
      .eq('user_id', user.id)
      .eq('target_user_id', partnerId)
      .single();

    if (myReaction) userReaction = myReaction;

    const { data: theirReaction } = await admin
      .from('conocernos_reactions')
      .select('emoji, comment')
      .eq('daily_id', daily.id)
      .eq('user_id', partnerId)
      .eq('target_user_id', user.id)
      .single();

    if (theirReaction) partnerReaction = theirReaction;
  }

  return {
    id: daily.id,
    questionText: question.question_text,
    questionDate: daily.question_date,
    revealAt: daily.reveal_at,
    dimension: question.dimension,
    tone: question.tone,
    hasAnswered: !!userAnswer,
    partnerHasAnswered,
    isRevealed,
    userAnswer: userAnswer?.answer_text || null,
    partnerAnswer: isRevealed ? partnerAnswerText : null,
    userReaction,
    partnerReaction,
  };
}

// ── Submit Answer ──
export async function submitConocenosAnswer(dailyId: string, answerText: string): Promise<{ success: boolean; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false, error: 'No autenticado' };

  if (!answerText.trim()) return { success: false, error: 'La respuesta no puede estar vacía' };
  if (answerText.length > 500) return { success: false, error: 'Máximo 500 caracteres' };

  const admin = createAdminClient();

  const { error } = await admin
    .from('conocernos_answers')
    .insert({
      daily_id: dailyId,
      user_id: user.id,
      answer_text: answerText.trim(),
    });

  if (error) {
    if (error.code === '23505') return { success: false, error: 'Ya respondiste esta pregunta' };
    console.error('Submit answer error:', error);
    return { success: false, error: 'Error al guardar tu respuesta' };
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  await logActivityEvent('conocernos.answered', 'conocernos_answer', dailyId, {
    partner_name: profile?.full_name || 'Tu pareja',
  });

  return { success: true };
}

// ── React to Answer ──
export async function reactToAnswer(
  dailyId: string,
  targetUserId: string,
  emoji: string | null,
  comment: string | null
): Promise<{ success: boolean; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false, error: 'No autenticado' };

  const admin = createAdminClient();

  const { error } = await admin
    .from('conocernos_reactions')
    .upsert(
      {
        daily_id: dailyId,
        user_id: user.id,
        target_user_id: targetUserId,
        emoji,
        comment: comment?.slice(0, 280) || null,
      },
      { onConflict: 'daily_id,user_id,target_user_id' }
    );

  if (error) {
    console.error('React error:', error);
    return { success: false, error: 'Error al guardar reacción' };
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  await logActivityEvent('conocernos.reacted', 'conocernos_reaction', dailyId, {
    partner_name: profile?.full_name || 'Tu pareja',
  });

  return { success: true };
}

// ── Get History ──
export async function getConocenosHistory(page: number = 0): Promise<ConocenosHistoryItem[]> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return [];

  const admin = createAdminClient();

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return [];

  const { data: partnerMembers } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', membership.couple_id)
    .neq('user_id', user.id);

  const partnerId = partnerMembers?.[0]?.user_id;

  const limit = 10;
  const offset = page * limit;

  const { data: dailies } = await supabase
    .from('conocernos_daily')
    .select('id, question_id, question_date, reveal_at')
    .eq('couple_id', membership.couple_id)
    .lt('question_date', new Date().toISOString().split('T')[0]) // only past days
    .order('question_date', { ascending: false })
    .range(offset, offset + limit - 1);

  if (!dailies || dailies.length === 0) return [];

  const results: ConocenosHistoryItem[] = [];

  for (const d of dailies) {
    const { data: q } = await admin
      .from('conocernos_questions')
      .select('question_text, dimension')
      .eq('id', d.question_id)
      .single();

    const { data: myAns } = await admin
      .from('conocernos_answers')
      .select('answer_text')
      .eq('daily_id', d.id)
      .eq('user_id', user.id)
      .single();

    let partnerAns = null;
    if (partnerId) {
      const { data: pAns } = await admin
        .from('conocernos_answers')
        .select('answer_text')
        .eq('daily_id', d.id)
        .eq('user_id', partnerId)
        .single();
      partnerAns = pAns?.answer_text || null;
    }

    results.push({
      id: d.id,
      questionText: q?.question_text || '',
      questionDate: d.question_date,
      dimension: q?.dimension || 'general',
      userAnswer: myAns?.answer_text || null,
      partnerAnswer: partnerAns,
    });
  }

  return results;
}
