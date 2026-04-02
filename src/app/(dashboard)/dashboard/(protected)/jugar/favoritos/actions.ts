'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';

/* ══════════════════════════════════════
   FAVORITOS (QUIZZES) — Server Actions
   Synced 5-question playful quizzes
   ══════════════════════════════════════ */

export interface QuizCategory {
  id: string;
  label: string;
  count: number;
}

export interface QuizSession {
  id: string;
  categoryId: string;
  questions: any[];
  currentQuestionIndex: number;
  answers: Record<string, Record<string, string>>; // { "0": { "user1": "A", "user2": "B" } }
  status: 'waiting' | 'playing' | 'completed' | 'cancelled';
  user1Id: string | null;
  user2Id: string | null;
}

const CATEGORY_LABELS: Record<string, string> = {
  comida: 'Comida & Antojos',
  viajes: 'Estilos de Viaje',
  entretenimiento: 'Películas & Series',
  intimidad: 'Intimidad & Detalles',
  random: 'Escenarios Random',
  futuro: 'Nuestro Futuro',
};

// ── Get Categories ──
export async function getQuizCategories(): Promise<QuizCategory[]> {
  const admin = createAdminClient();
  
  // Group by category to get counts
  // (In a real app, you might use an RPC or do grouping. Here we fetch all active questions)
  const { data: questions } = await admin
    .from('favoritos_questions')
    .select('category')
    .eq('active', true);

  if (!questions) return [];

  const counts: Record<string, number> = {};
  questions.forEach(q => {
    counts[q.category] = (counts[q.category] || 0) + 1;
  });

  return Object.keys(counts).map(key => ({
    id: key,
    label: CATEGORY_LABELS[key] || key,
    count: counts[key],
  }));
}

// ── Create or Join Active Session ──
export async function createQuizSession(categoryId: string): Promise<{ success: boolean; sessionId?: string; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false, error: 'No autenticado' };

  const admin = createAdminClient();

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return { success: false, error: 'Sin pareja vinculada' };
  const coupleId = membership.couple_id;

  // Check for existing active session
  const { data: existing } = await supabase
    .from('favoritos_sessions')
    .select('id')
    .eq('couple_id', coupleId)
    .in('status', ['waiting', 'playing'])
    .limit(1)
    .single();

  if (existing) {
    return { success: true, sessionId: existing.id };
  }

  // Get 5 random questions for this category
  const { data: queryPool } = await admin
    .from('favoritos_questions')
    .select('id, question_text, options')
    .eq('category', categoryId)
    .eq('active', true);

  if (!queryPool || queryPool.length < 3) {
    return { success: false, error: 'No hay suficientes preguntas en esta categoría' };
  }

  // Shuffle and pick 5 (or max available if < 5)
  const shuffled = queryPool.sort(() => 0.5 - Math.random());
  const selectedQuestions = shuffled.slice(0, 5);

  const { data: session, error } = await admin
    .from('favoritos_sessions')
    .insert({
      couple_id: coupleId,
      category: categoryId,
      questions: selectedQuestions,
      current_question_index: 0,
      user1_id: user.id, // The initiator
      answers: {},
      status: 'playing', // Auto-start for MVP
    })
    .select('id')
    .single();

  if (error || !session) {
    console.error('Failed to create session:', error);
    return { success: false, error: 'Error al iniciar sesión' };
  }

  return { success: true, sessionId: session.id };
}

// ── Get Active Session (Polling Target) ──
export async function getQuizSession(sessionId: string): Promise<QuizSession | null> {
  const admin = createAdminClient();
  
  const { data: session } = await admin
    .from('favoritos_sessions')
    .select('*')
    .eq('id', sessionId)
    .single();

  if (!session) return null;

  return {
    id: session.id,
    categoryId: session.category,
    questions: session.questions,
    currentQuestionIndex: session.current_question_index,
    answers: session.answers || {},
    status: session.status,
    user1Id: session.user1_id,
    user2Id: session.user2_id,
  };
}

// ── Submit Answer ──
export async function submitQuizAnswer(
  sessionId: string,
  questionIndex: number,
  answerText: string
): Promise<{ success: boolean; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false, error: 'No autenticado' };

  const admin = createAdminClient();

  // 1. Fetch current session state
  const { data: session } = await admin
    .from('favoritos_sessions')
    .select('answers, couple_id, questions, current_question_index')
    .eq('id', sessionId)
    .single();

  if (!session) return { success: false, error: 'Sesión no encontrada' };

  const partnerId = await getPartnerId(session.couple_id, user.id);
  
  // 2. Clone answers object and inject new answer
  const answersObj = session.answers || {};
  const qStr = questionIndex.toString();
  
  if (!answersObj[qStr]) {
    answersObj[qStr] = {};
  }
  
  // Important: if already answered, ignore (prevent double submit)
  if (answersObj[qStr][user.id] === answerText) {
    return { success: true };
  }
  
  answersObj[qStr][user.id] = answerText;

  // 3. Check if we should advance to the next question
  // Did partner already answer this same index?
  const partnerAnswer = partnerId ? answersObj[qStr][partnerId] : null;
  const bothAnswered = !!partnerAnswer;
  
  let newIndex = session.current_question_index;
  let newStatus = 'playing';

  // If both answered, advance index. If we reached the end, complete.
  if (bothAnswered && questionIndex === session.current_question_index) {
    if (newIndex + 1 < (session.questions as any[]).length) {
      newIndex++;
    } else {
      newStatus = 'completed';
    }
  }

  // 4. Update the record
  const { error } = await admin
    .from('favoritos_sessions')
    .update({ 
      answers: answersObj,
      current_question_index: newIndex,
      status: newStatus,
      updated_at: new Date().toISOString()
    })
    .eq('id', sessionId);

  if (error) {
    console.error('Failed submitting answer:', error);
    return { success: false, error: 'Error al enviar respuesta' };
  }

  return { success: true };
}

async function getPartnerId(coupleId: string, myUserId: string): Promise<string | null> {
  const admin = createAdminClient();
  const { data: partnerMembers } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', coupleId)
    .neq('user_id', myUserId)
    .limit(1)
    .single();
  
  return partnerMembers?.user_id || null;
}
