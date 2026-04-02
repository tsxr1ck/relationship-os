'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { getDailyTip } from './(protected)/profile/actions';
import { getDashboardInsight } from './actions';
import { V2_DIMENSION_MAP } from '@/lib/scoring';

const AI_TIMEOUT_MS = 3000;

function withTimeout<T>(promise: Promise<T>, ms: number): Promise<T | null> {
  return Promise.race([
    promise,
    new Promise<null>((_, reject) => setTimeout(() => reject(new Error('timeout')), ms)),
  ]).catch(() => null);
}

export interface DashboardCoreData {
  user: {
    id: string;
    email: string;
    displayName: string;
    avatarUrl: string | null;
  };
  couple: {
    id: string;
    createdAt: string;
    inviteCode: string;
    durationText: string;
  } | null;
  partner: {
    id: string;
    displayName: string;
    avatarUrl: string | null;
    lastSeenAt: string | null;
    isOnline: boolean;
  } | null;
  scores: {
    conexion: number;
    cuidado: number;
    choque: number;
    camino: number;
  } | null;
  questionnaireStatus: 'not_started' | 'in_progress' | 'completed';
  questionnaireProgress: number;
  partnerQuestionnaireCompleted: boolean;
  onboardingCompleted: boolean;
  weeklyPlan: {
    id: string;
    weekLabel: string;
    items: any[];
    completedCount: number;
    totalCount: number;
  } | null;
  weeksActive: number;
}

export interface DashboardEnrichmentData {
  dailyTip: { tip: string | null; dimension: string | null } | null;
  dashboardInsight: { title: string; body: string } | null;
  activeChallenge: { id: string; title: string; dimension: string } | null;
  upcomingMilestones: any[];
  conocernos: {
    dailyId: string;
    questionText: string;
    hasAnswered: boolean;
    partnerHasAnswered: boolean;
    isRevealed: boolean;
    revealAt: string;
  } | null;
}

export interface DashboardData extends DashboardCoreData, DashboardEnrichmentData {}

function getRelativeDuration(dateStr: string): string {
  const created = new Date(dateStr);
  const now = new Date();
  const diffMs = now.getTime() - created.getTime();
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

  if (diffDays < 7) return `${diffDays} días juntos`;
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} semanas juntos`;
  if (diffDays < 365) return `${Math.floor(diffDays / 30)} meses juntos`;
  const years = Math.floor(diffDays / 365);
  const months = Math.floor((diffDays % 365) / 30);
  return months > 0 ? `${years} año${years > 1 ? 's' : ''} y ${months} mes${months > 1 ? 'es' : ''}` : `${years} año${years > 1 ? 's' : ''}`;
}

export async function getDashboardCore(): Promise<DashboardCoreData> {
  const supabase = await createClient();
  const admin = createAdminClient();

  // Phase 0: Auth
  const { data: { user }, error: authError } = await supabase.auth.getUser();
  if (!user || authError) {
    throw new Error('No autenticado');
  }

  // Phase 1: Identity queries — parallelized
  const [profileResult, membershipResult] = await Promise.all([
    supabase.from('profiles').select('*').eq('id', user.id).single(),
    supabase.from('couple_members').select('couple_id, role').eq('user_id', user.id).limit(1).single(),
  ]);

  const profile = profileResult.data;
  const membership = membershipResult.data;

  // Phase 2: Couple + Partner resolution
  let couple = null;
  let partner = null;
  let partnerId: string | null = null;
  let partnerQuestionnaireCompleted = false;
  let partnerVectors: any[] = [];

  if (membership) {
    const { data: coupleData } = await supabase
      .from('couples')
      .select('*')
      .eq('id', membership.couple_id)
      .single();

    if (coupleData) {
      couple = {
        id: coupleData.id,
        createdAt: coupleData.created_at,
        inviteCode: coupleData.invite_code,
        durationText: getRelativeDuration(coupleData.created_at),
      };
    }

    const { data: members } = await admin
      .from('couple_members')
      .select('user_id')
      .eq('couple_id', membership.couple_id)
      .neq('user_id', user.id);

    if (members && members.length > 0) {
      partnerId = members[0].user_id;

      // Parallelize partner profile + vectors
      const [partnerProfileResult, partnerVectorsResult] = await Promise.all([
        admin.from('profiles').select('id, full_name, avatar_url, last_seen_at').eq('id', partnerId).single(),
        admin.from('profile_vectors').select('dimension_slug, normalized_score').eq('user_id', partnerId),
      ]);

      const partnerProfile = partnerProfileResult.data;
      partnerVectors = partnerVectorsResult.data || [];

      if (partnerProfile) {
        const lastSeen = partnerProfile.last_seen_at
          ? new Date(partnerProfile.last_seen_at)
          : null;
        const isOnline = lastSeen
          ? (Date.now() - lastSeen.getTime()) < 5 * 60 * 1000
          : false;

        partner = {
          id: partnerProfile.id,
          displayName: partnerProfile.full_name || 'Tu pareja',
          avatarUrl: partnerProfile.avatar_url,
          lastSeenAt: partnerProfile.last_seen_at,
          isOnline,
        };
      }

      partnerQuestionnaireCompleted = partnerVectors.length > 0;
    }
  }

  // Phase 3: Questionnaire state + user vectors — parallelized
  const [completedSessionResult, inProgressSessionResult, myVectorsResult] = await Promise.all([
    supabase.from('response_sessions').select('*').eq('user_id', user.id).eq('status', 'completed').order('completed_at', { ascending: false }).limit(1).maybeSingle(),
    supabase.from('response_sessions').select('*').eq('user_id', user.id).eq('status', 'in_progress').limit(1).maybeSingle(),
    supabase.from('profile_vectors').select('dimension_slug, normalized_score').eq('user_id', user.id),
  ]);

  const inProgressSession = inProgressSessionResult.data;
  const myVectors = myVectorsResult.data;

  let questionnaireStatus: 'not_started' | 'in_progress' | 'completed' = 'not_started';
  let questionnaireProgress = 0;

  if (myVectors && myVectors.length > 0) {
    questionnaireStatus = 'completed';
    questionnaireProgress = 100;
  } else if (inProgressSession) {
    questionnaireStatus = 'in_progress';
    questionnaireProgress = (inProgressSession as any).progress_percentage || 0;
  }

  // Reuse myVectors for onboarding check (no duplicate query)
  const onboardingCompleted = !!(myVectors && myVectors.length > 0);

  // Phase 4: Score calculation
  let scores: { conexion: number; cuidado: number; choque: number; camino: number } | null = null;

  if (myVectors && myVectors.length > 0) {
    const layerTotals: Record<string, number> = { conexion: 0, cuidado: 0, choque: 0, camino: 0 };
    const layerCounts: Record<string, number> = { conexion: 0, cuidado: 0, choque: 0, camino: 0 };

    const processVectors = (vectors: any[]) => {
      vectors.forEach(v => {
        const dimInfo = V2_DIMENSION_MAP[v.dimension_slug];
        if (dimInfo) {
          let score = v.normalized_score ?? 0;
          if (dimInfo.layer === 'choque') {
            score = 100 - score;
          }
          layerTotals[dimInfo.layer] += score;
          layerCounts[dimInfo.layer]++;
        }
      });
    };

    processVectors(myVectors);
    if (partnerVectors.length > 0) {
      processVectors(partnerVectors);
    }

    scores = {
      conexion: layerCounts.conexion > 0 ? (layerTotals.conexion / layerCounts.conexion) / 100 : 0.5,
      cuidado: layerCounts.cuidado > 0 ? (layerTotals.cuidado / layerCounts.cuidado) / 100 : 0.5,
      choque: layerCounts.choque > 0 ? (layerTotals.choque / layerCounts.choque) / 100 : 0.5,
      camino: layerCounts.camino > 0 ? (layerTotals.camino / layerCounts.camino) / 100 : 0.5,
    };
  }

  // Phase 5: Weekly plan
  let weeklyPlan = null;
  if (couple) {
    const { data: plan } = await supabase
      .from('weekly_plans')
      .select('*')
      .eq('couple_id', couple.id)
      .order('generated_at', { ascending: false })
      .limit(1)
      .single();

    if (plan) {
      const { data: items } = await supabase
        .from('weekly_plan_items')
        .select('*')
        .eq('plan_id', plan.id)
        .order('day_of_week', { ascending: true });

      const planItems = items || [];
      weeklyPlan = {
        id: plan.id,
        weekLabel: `Semana del ${new Date(plan.week_start).toLocaleDateString('es-MX', { day: 'numeric', month: 'long' })}`,
        items: planItems,
        completedCount: planItems.filter((i: any) => i.status === 'completed').length,
        totalCount: planItems.length,
      };
    }
  }

  const createdAt = profile?.created_at || user.created_at;
  const weeksActive = Math.max(1, Math.floor(
    (new Date().getTime() - new Date(createdAt).getTime()) / (1000 * 60 * 60 * 24 * 7)
  ));

  return {
    user: {
      id: user.id,
      email: user.email || '',
      displayName: profile?.full_name || user.email?.split('@')[0] || 'Usuario',
      avatarUrl: profile?.avatar_url || null,
    },
    couple,
    partner,
    scores,
    questionnaireStatus,
    questionnaireProgress,
    partnerQuestionnaireCompleted,
    onboardingCompleted,
    weeklyPlan,
    weeksActive,
  };
}

export async function getDashboardEnrichment(coupleId: string | null): Promise<DashboardEnrichmentData> {
  if (!coupleId) {
    return {
      dailyTip: null,
      dashboardInsight: null,
      activeChallenge: null,
      upcomingMilestones: [],
      conocernos: null,
    };
  }

  const supabase = await createClient();

  // All 5 enrichment calls are independent — fire in parallel with AI timeouts
  const [
    dailyTip,
    activeChallengeResult,
    milestonesResult,
    dashboardInsight,
    conocernosData,
  ] = await Promise.all([
    withTimeout(getDailyTip(), AI_TIMEOUT_MS),
    supabase
      .from('challenge_assignments')
      .select('challenge_id, status, weekly_challenges(title, dimension)')
      .eq('couple_id', coupleId)
      .eq('status', 'active')
      .limit(1)
      .single(),
    supabase
      .from('milestones')
      .select('id, title, date, milestone_type')
      .eq('couple_id', coupleId)
      .gte('date', new Date().toISOString().split('T')[0])
      .order('date', { ascending: true })
      .limit(2),
    withTimeout(getDashboardInsight(), AI_TIMEOUT_MS),
    (async () => {
      try {
        const { getOrCreateDailyQuestion } = await import('./(protected)/jugar/conocernos/actions');
        return await getOrCreateDailyQuestion();
      } catch {
        return null;
      }
    })(),
  ]);

  const activeChallenge = activeChallengeResult.data && (activeChallengeResult.data as any).weekly_challenges
    ? {
        id: (activeChallengeResult.data as any).challenge_id,
        title: (activeChallengeResult.data as any).weekly_challenges.title,
        dimension: (activeChallengeResult.data as any).weekly_challenges.dimension,
      }
    : null;

  const upcomingMilestones = milestonesResult.data || [];

  let conocernos = null;
  if (conocernosData) {
    conocernos = {
      dailyId: conocernosData.id,
      questionText: conocernosData.questionText,
      hasAnswered: conocernosData.hasAnswered,
      partnerHasAnswered: conocernosData.partnerHasAnswered,
      isRevealed: conocernosData.isRevealed,
      revealAt: conocernosData.revealAt,
    };
  }

  return {
    dailyTip,
    dashboardInsight,
    activeChallenge,
    upcomingMilestones,
    conocernos,
  };
}

/**
 * Legacy: get full dashboard data in one call (backwards compatibility)
 */
export async function getDashboardData(): Promise<DashboardData> {
  const core = await getDashboardCore();
  const enrichment = await getDashboardEnrichment(core.couple?.id ?? null);
  return { ...core, ...enrichment };
}
