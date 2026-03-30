'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { GoogleGenAI } from '@google/genai';
import { V2_DIMENSION_MAP } from '@/lib/scoring';
import { revalidatePath } from 'next/cache';

// ─── Types ────────────────────────────────────────────────────

export interface ChallengeRow {
  id: string;
  slug: string;
  title: string;
  description: string;
  dimension: string;
  dimensionLabel: string;
  difficulty: string;
  durationDays: number;
}

export interface AssignmentRow {
  id: string;
  coupleId: string;
  challengeId: string;
  startedAt: string;
  completedAt: string | null;
  status: string;
  progress: any;
  challenge: ChallengeRow | null;
  aiCoaching: string | null;
  dailyTips: string[];
}

export interface RetosData {
  activeChallenges: AssignmentRow[];
  completedChallenges: AssignmentRow[];
  availableChallenges: ChallengeRow[];
  recommendedChallenge: ChallengeRow | null;
  recommendationReason: string | null;
  streak: number;
  completedCount: number;
  totalPoints: number;
  myName: string;
  partnerName: string | null;
}

// ─── Constants ────────────────────────────────────────────────

const LAYER_META: Record<string, { label: string; icon: string }> = {
  conexion: { label: 'Conexión', icon: '💜' },
  cuidado: { label: 'Cuidado', icon: '💚' },
  choque:  { label: 'Conflicto', icon: '⚡' },
  camino:  { label: 'Camino', icon: '🧭' },
};

const DIFFICULTY_POINTS: Record<string, number> = {
  easy: 10,
  medium: 20,
  deep: 35,
};

function getDimensionLabel(dim: string): string {
  return LAYER_META[dim]?.label || dim;
}

// ─── Get all challenge data ───────────────────────────────────

export async function getChallenges(): Promise<RetosData> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return {
      activeChallenges: [],
      completedChallenges: [],
      availableChallenges: [],
      recommendedChallenge: null,
      recommendationReason: null,
      streak: 0,
      completedCount: 0,
      totalPoints: 0,
      myName: 'Tú',
      partnerName: null,
    };
  }

  const admin = createAdminClient();

  // Profile
  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const myName = profile?.full_name || 'Tú';

  // Couple
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  let partnerName: string | null = null;
  if (membership) {
    const { data: members } = await admin
      .from('couple_members')
      .select('user_id')
      .eq('couple_id', membership.couple_id)
      .neq('user_id', user.id);

    if (members && members.length > 0) {
      const { data: pp } = await admin
        .from('profiles')
        .select('full_name')
        .eq('id', members[0].user_id)
        .single();
      partnerName = pp?.full_name || 'Tu pareja';
    }
  }

  // All available challenges from the bank
  const { data: allChallenges } = await supabase
    .from('weekly_challenges')
    .select('*')
    .order('created_at', { ascending: true });

  const challenges: ChallengeRow[] = (allChallenges || []).map((c: any) => ({
    id: c.id,
    slug: c.slug,
    title: c.title,
    description: c.description,
    dimension: c.dimension,
    dimensionLabel: getDimensionLabel(c.dimension),
    difficulty: c.difficulty || 'medium',
    durationDays: c.duration_days || 7,
  }));

  if (!membership) {
    return {
      activeChallenges: [],
      completedChallenges: [],
      availableChallenges: challenges,
      recommendedChallenge: challenges[0] || null,
      recommendationReason: null,
      streak: 0,
      completedCount: 0,
      totalPoints: 0,
      myName,
      partnerName,
    };
  }

  // Get assignments
  const { data: activeAssignments } = await supabase
    .from('challenge_assignments')
    .select('*')
    .eq('couple_id', membership.couple_id)
    .eq('status', 'active');

  const { data: completedAssignments } = await supabase
    .from('challenge_assignments')
    .select('*')
    .eq('couple_id', membership.couple_id)
    .eq('status', 'completed')
    .order('completed_at', { ascending: false });

  const challengeMap = new Map(challenges.map(c => [c.id, c]));

  // Get cached AI coaching for assignments
  const coachingMap: Record<string, string> = {};
  const dailyTipsMap: Record<string, string[]> = {};

  const allAssignmentIds = [
    ...(activeAssignments || []).map(a => a.id),
    ...(completedAssignments || []).map(a => a.id),
  ];

  if (allAssignmentIds.length > 0) {
    const { data: insights } = await admin
      .from('ai_insights')
      .select('dimension_slug, insight_text')
      .eq('user_id', user.id)
      .like('dimension_slug', 'reto_%');

    (insights || []).forEach(i => {
      if (i.dimension_slug.startsWith('reto_coaching_')) {
        const assignId = i.dimension_slug.replace('reto_coaching_', '');
        coachingMap[assignId] = i.insight_text;
      } else if (i.dimension_slug.startsWith('reto_tips_')) {
        const assignId = i.dimension_slug.replace('reto_tips_', '');
        try {
          dailyTipsMap[assignId] = JSON.parse(i.insight_text);
        } catch {
          dailyTipsMap[assignId] = [i.insight_text];
        }
      }
    });
  }

  const enrichActive: AssignmentRow[] = (activeAssignments || []).map((a: any) => ({
    id: a.id,
    coupleId: a.couple_id,
    challengeId: a.challenge_id,
    startedAt: a.started_at,
    completedAt: a.completed_at,
    status: a.status,
    progress: a.progress,
    challenge: challengeMap.get(a.challenge_id) || null,
    aiCoaching: coachingMap[a.id] || null,
    dailyTips: dailyTipsMap[a.id] || [],
  }));

  const enrichCompleted: AssignmentRow[] = (completedAssignments || []).map((a: any) => ({
    id: a.id,
    coupleId: a.couple_id,
    challengeId: a.challenge_id,
    startedAt: a.started_at,
    completedAt: a.completed_at,
    status: a.status,
    progress: a.progress,
    challenge: challengeMap.get(a.challenge_id) || null,
    aiCoaching: coachingMap[a.id] || null,
    dailyTips: dailyTipsMap[a.id] || [],
  }));

  // Filter available: not already assigned
  const assignedIds = new Set([
    ...(activeAssignments || []).map((a: any) => a.challenge_id),
    ...(completedAssignments || []).map((a: any) => a.challenge_id),
  ]);

  const availableChallenges = challenges.filter(c => !assignedIds.has(c.id));

  // Calculate streak
  let streak = 0;
  for (const ca of enrichCompleted) {
    if (ca.status === 'completed') streak++;
    else break;
  }

  // Calculate points
  const totalPoints = enrichCompleted.reduce((sum, a) => {
    const diff = a.challenge?.difficulty || 'medium';
    return sum + (DIFFICULTY_POINTS[diff] || 20);
  }, 0);

  // AI recommendation: pick the challenge in user's weakest dimension
  let recommendedChallenge: ChallengeRow | null = null;
  let recommendationReason: string | null = null;

  if (availableChallenges.length > 0) {
    // Get profile vectors to find weakest area
    const { data: myVectors } = await supabase
      .from('profile_vectors')
      .select('dimension_slug, normalized_score')
      .eq('user_id', user.id);

    if (myVectors && myVectors.length > 0) {
      const layerAvg: Record<string, number> = {};
      const layerCounts: Record<string, number> = {};

      myVectors.forEach(v => {
        const dimInfo = V2_DIMENSION_MAP[v.dimension_slug];
        if (dimInfo) {
          const layer = dimInfo.layer;
          layerAvg[layer] = (layerAvg[layer] || 0) + v.normalized_score;
          layerCounts[layer] = (layerCounts[layer] || 0) + 1;
        }
      });

      Object.keys(layerAvg).forEach(l => {
        layerAvg[l] = layerAvg[l] / (layerCounts[l] || 1);
      });

      // Find weakest layer
      const weakest = Object.entries(layerAvg).sort(([, a], [, b]) => a - b)[0];
      if (weakest) {
        const weakLayer = weakest[0];
        const match = availableChallenges.find(c => c.dimension === weakLayer);
        if (match) {
          recommendedChallenge = match;
          recommendationReason = `Tu área de ${LAYER_META[weakLayer]?.label || weakLayer} (${Math.round(weakest[1])}%) puede crecer con este reto.`;
        }
      }
    }

    // Fallback: just pick the first available
    if (!recommendedChallenge) {
      recommendedChallenge = availableChallenges[0];
      recommendationReason = 'Un buen reto para fortalecer su relación.';
    }
  }

  return {
    activeChallenges: enrichActive,
    completedChallenges: enrichCompleted,
    availableChallenges,
    recommendedChallenge,
    recommendationReason,
    streak,
    completedCount: enrichCompleted.length,
    totalPoints,
    myName,
    partnerName,
  };
}

// ─── Start a challenge with AI coaching ───────────────────────

export async function startChallenge(challengeId: string): Promise<{ success: boolean; coaching: string | null }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const admin = createAdminClient();

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) throw new Error('No tienes una pareja registrada');

  // Check active
  const { data: activeChallenges } = await supabase
    .from('challenge_assignments')
    .select('id')
    .eq('couple_id', membership.couple_id)
    .eq('status', 'active');

  if (activeChallenges && activeChallenges.length > 0) {
    throw new Error('Ya tienes un reto activo. Complétalo primero.');
  }

  // Create assignment
  const { data: assignment, error } = await supabase
    .from('challenge_assignments')
    .insert({
      couple_id: membership.couple_id,
      challenge_id: challengeId,
      status: 'active',
      started_at: new Date().toISOString(),
      progress: { day: 1, checkIns: [] },
    })
    .select()
    .single();

  if (error) throw new Error('Error al comenzar el reto: ' + error.message);

  // Generate AI coaching for this challenge
  let coaching: string | null = null;
  try {
    coaching = await generateChallengeCoaching(assignment.id, challengeId, user.id, membership.couple_id);
  } catch (err) {
    console.error('AI coaching generation error:', err);
  }

  revalidatePath('/dashboard/retos');
  revalidatePath('/dashboard');

  return { success: true, coaching };
}

// ─── Complete a challenge ─────────────────────────────────────

export async function completeChallenge(assignmentId: string): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const { error } = await supabase
    .from('challenge_assignments')
    .update({
      status: 'completed',
      completed_at: new Date().toISOString(),
    })
    .eq('id', assignmentId);

  if (error) throw new Error('Error al completar el reto');

  revalidatePath('/dashboard/retos');
  revalidatePath('/dashboard');

  return { success: true };
}

// ─── Abandon a challenge ──────────────────────────────────────

export async function abandonChallenge(assignmentId: string): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const { error } = await supabase
    .from('challenge_assignments')
    .update({ status: 'abandoned' })
    .eq('id', assignmentId);

  if (error) throw new Error('Error al abandonar el reto');

  revalidatePath('/dashboard/retos');
  revalidatePath('/dashboard');

  return { success: true };
}

// ─── Generate AI coaching for a challenge ─────────────────────

async function generateChallengeCoaching(
  assignmentId: string,
  challengeId: string,
  userId: string,
  coupleId: string
): Promise<string | null> {
  const admin = createAdminClient();
  const supabase = await createClient();

  // Check cache first
  const { data: cached } = await admin
    .from('ai_insights')
    .select('insight_text')
    .eq('user_id', userId)
    .eq('dimension_slug', `reto_coaching_${assignmentId}`)
    .limit(1)
    .single();

  if (cached?.insight_text) return cached.insight_text;

  // Get challenge details
  const { data: challenge } = await supabase
    .from('weekly_challenges')
    .select('*')
    .eq('id', challengeId)
    .single();

  if (!challenge) return null;

  // Get names
  const { data: myProfile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', userId)
    .single();

  const myName = myProfile?.full_name || 'Tú';

  const { data: members } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', coupleId)
    .neq('user_id', userId);

  let partnerName = 'Tu pareja';
  if (members && members.length > 0) {
    const { data: pp } = await admin.from('profiles').select('full_name').eq('id', members[0].user_id).single();
    partnerName = pp?.full_name || 'Tu pareja';
  }

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) return null;

  const ai = new GoogleGenAI({ apiKey });

  const prompt = `
Eres un coach de relaciones de pareja para "Relationship OS".
${myName} y ${partnerName} acaban de comenzar este reto:

RETO: ${challenge.title}
DESCRIPCIÓN: ${challenge.description}
DIMENSIÓN: ${LAYER_META[challenge.dimension]?.label || challenge.dimension}
DIFICULTAD: ${challenge.difficulty}
DURACIÓN: ${challenge.duration_days} días

Genera un JSON con esta estructura:
{
  "coaching": "Un mensaje motivacional de 3-4 oraciones personalizadas para ${myName} y ${partnerName}. Explica por qué este reto es valioso para su relación y da un consejo para aprovecharlo al máximo. Usa sus nombres.",
  "dailyTips": ["Exactamente ${challenge.duration_days} tips, uno para cada día del reto. Cada tip es una oración corta y concreta de qué hacer o tener en mente ese día específico."]
}

REGLAS:
- NO uses markdown. Texto plano.
- Español mexicano natural y cálido.
- Sé concreto y práctico, no genérico.
- Los daily tips deben ser progresivos (empezar suave, profundizar).
`;

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        temperature: 0.7,
      },
    });

    if (response.text) {
      const parsed = JSON.parse(response.text);
      const coaching = parsed.coaching || '';
      const tips = Array.isArray(parsed.dailyTips) ? parsed.dailyTips : [];

      // Save to ai_insights (coaching)
      await admin.from('ai_insights').insert({
        user_id: userId,
        couple_id: coupleId,
        dimension_slug: `reto_coaching_${assignmentId}`,
        insight_text: coaching,
      });

      // Save tips
      if (tips.length > 0) {
        await admin.from('ai_insights').insert({
          user_id: userId,
          couple_id: coupleId,
          dimension_slug: `reto_tips_${assignmentId}`,
          insight_text: JSON.stringify(tips),
        });
      }

      return coaching;
    }
  } catch (err) {
    console.error('Challenge coaching error:', err);
  }

  return null;
}

// ─── Generate AI reflection after completing ──────────────────

export async function generateCompletionReflection(
  assignmentId: string,
  forceRefresh: boolean = false
): Promise<{ reflection: string; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { reflection: '', error: 'No autorizado' };

  const admin = createAdminClient();

  // Check cache
  if (!forceRefresh) {
    const { data: cached } = await admin
      .from('ai_insights')
      .select('insight_text')
      .eq('user_id', user.id)
      .eq('dimension_slug', `reto_reflection_${assignmentId}`)
      .limit(1)
      .single();

    if (cached?.insight_text) return { reflection: cached.insight_text };
  }

  // Get assignment + challenge
  const { data: assignment } = await supabase
    .from('challenge_assignments')
    .select('*')
    .eq('id', assignmentId)
    .single();

  if (!assignment) return { reflection: '', error: 'Reto no encontrado' };

  const { data: challenge } = await supabase
    .from('weekly_challenges')
    .select('*')
    .eq('id', assignment.challenge_id)
    .single();

  if (!challenge) return { reflection: '', error: 'Reto no encontrado' };

  // Get couple
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  const coupleId = membership?.couple_id;

  // Get names
  const { data: myProfile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const myName = myProfile?.full_name || 'Tú';

  let partnerName = 'Tu pareja';
  if (coupleId) {
    const { data: members } = await admin
      .from('couple_members')
      .select('user_id')
      .eq('couple_id', coupleId)
      .neq('user_id', user.id);

    if (members && members.length > 0) {
      const { data: pp } = await admin.from('profiles').select('full_name').eq('id', members[0].user_id).single();
      partnerName = pp?.full_name || 'Tu pareja';
    }
  }

  // Days it took
  const started = new Date(assignment.started_at);
  const completed = assignment.completed_at ? new Date(assignment.completed_at) : new Date();
  const daysTaken = Math.max(1, Math.ceil((completed.getTime() - started.getTime()) / (1000 * 60 * 60 * 24)));

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) return { reflection: `¡Felicidades ${myName} y ${partnerName}! Completaron "${challenge.title}" en ${daysTaken} días. Este es un paso real hacia una relación más fuerte.` };

  const ai = new GoogleGenAI({ apiKey });

  const prompt = `
Eres un coach de relaciones de pareja. ${myName} y ${partnerName} acaban de completar un reto.

RETO COMPLETADO: ${challenge.title}
DESCRIPCIÓN: ${challenge.description}
DIMENSIÓN: ${LAYER_META[challenge.dimension]?.label || challenge.dimension}
DIFICULTAD: ${challenge.difficulty}
DURACIÓN REAL: ${daysTaken} días (de ${challenge.duration_days} planificados)

Escribe una reflexión de cierre de 3-4 oraciones:
1. Celebra su logro usando sus nombres.
2. Menciona qué habilidad relacional probablemente fortalecieron con este reto.
3. Sugiere cómo integrar lo aprendido en su día a día.
4. Si terminaron antes del tiempo planificado, reconoce su compromiso extra.

REGLAS:
- NO uses markdown. Texto plano.
- Español mexicano cálido.
- Sé concreto, no genérico.
`;

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: { temperature: 0.7 },
    });

    const text = response.text || '';

    if (text && coupleId) {
      // Delete old
      await admin
        .from('ai_insights')
        .delete()
        .eq('user_id', user.id)
        .eq('dimension_slug', `reto_reflection_${assignmentId}`);

      await admin.from('ai_insights').insert({
        user_id: user.id,
        couple_id: coupleId,
        dimension_slug: `reto_reflection_${assignmentId}`,
        insight_text: text,
      });
    }

    return { reflection: text };
  } catch (err) {
    console.error('Completion reflection error:', err);
    return { reflection: `¡Felicidades ${myName} y ${partnerName}! Completaron "${challenge.title}". Su relación crece con cada paso que dan juntos.` };
  }
}
