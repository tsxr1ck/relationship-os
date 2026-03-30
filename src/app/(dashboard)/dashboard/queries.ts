'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';

export interface DashboardData {
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
  dailyTip: { tip: string | null; dimension: string | null } | null;
  dashboardInsight: { title: string; body: string } | null;
  activeChallenge: { id: string; title: string; dimension: string } | null;
  upcomingMilestones: any[];
}

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

import { getDailyTip } from './(protected)/profile/actions';
import { getDashboardInsight } from './actions';
import { V2_DIMENSION_MAP } from '@/lib/scoring';

export async function getDashboardData(): Promise<DashboardData> {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (!user || authError) {
    throw new Error('No autenticado');
  }

  const admin = createAdminClient();

  // Get user profile
  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single();

  // Get couple membership
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id, role')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  let couple = null;
  let partner = null;
  let partnerId: string | null = null;
  let partnerQuestionnaireCompleted = false;

  if (membership) {
    // Get couple info
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

    // Get partner (use admin to bypass RLS — couple_members only shows own rows)
    const { data: members } = await admin
      .from('couple_members')
      .select('user_id')
      .eq('couple_id', membership.couple_id)
      .neq('user_id', user.id);

    if (members && members.length > 0) {
      partnerId = members[0].user_id;
      const { data: partnerProfile } = await admin
        .from('profiles')
        .select('id, full_name, avatar_url')
        .eq('id', partnerId)
        .single();

      if (partnerProfile) {
        partner = {
          id: partnerProfile.id,
          displayName: partnerProfile.full_name || 'Tu pareja',
          avatarUrl: partnerProfile.avatar_url,
        };
      }

      // Check partner's questionnaire status (using profile_vectors presence for v2)
      const { data: pVectors } = await admin
        .from('profile_vectors')
        .select('id')
        .eq('user_id', partnerId)
        .limit(1);

      partnerQuestionnaireCompleted = !!(pVectors && pVectors.length > 0);
    }
  }

  // Get user's questionnaire status
  const { data: completedSession } = await supabase
    .from('response_sessions')
    .select('*')
    .eq('user_id', user.id)
    .eq('status', 'completed')
    .order('completed_at', { ascending: false })
    .limit(1)
    .maybeSingle();

  const { data: inProgressSession } = await supabase
    .from('response_sessions')
    .select('*')
    .eq('user_id', user.id)
    .eq('status', 'in_progress')
    .limit(1)
    .maybeSingle();

  // scores logic for V2
  const { data: myVectors } = await supabase
    .from('profile_vectors')
    .select('dimension_slug, normalized_score')
    .eq('user_id', user.id);

  let questionnaireStatus: 'not_started' | 'in_progress' | 'completed' = 'not_started';
  let questionnaireProgress = 0;

  if (myVectors && myVectors.length > 0) {
    questionnaireStatus = 'completed';
    questionnaireProgress = 100;
  } else if (inProgressSession) {
    questionnaireStatus = 'in_progress';
    questionnaireProgress = (inProgressSession as any).progress_percentage || 0;
  }

  // Calculate scores from profile_vectors (V2)
  let scores: { conexion: number; cuidado: number; choque: number; camino: number } | null = null;
  
  if (myVectors && myVectors.length > 0) {
    // 1. Fetch partner vectors if available
    let partnerVectors: any[] = [];
    if (partnerId) {
      const { data: pv } = await admin
        .from('profile_vectors')
        .select('dimension_slug, normalized_score')
        .eq('user_id', partnerId);
      partnerVectors = pv || [];
    }

    // 2. Aggregate both profiles
    const layerTotals: Record<string, number> = { conexion: 0, cuidado: 0, choque: 0, camino: 0 };
    const layerCounts: Record<string, number> = { conexion: 0, cuidado: 0, choque: 0, camino: 0 };

    const processVectors = (vectors: any[]) => {
      vectors.forEach(v => {
        const dimInfo = V2_DIMENSION_MAP[v.dimension_slug];
        if (dimInfo) {
          let score = v.normalized_score ?? 0;
          // Invert conflict (choque) logic: high score in DB = high tension = low health
          // So we invert it for the dashboard dashboard status display
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

  // Check V2 onboarding completion
  const { data: profileVectorRows } = await supabase
    .from('profile_vectors')
    .select('id')
    .eq('user_id', user.id)
    .limit(1);

  const onboardingCompleted = !!(profileVectorRows && profileVectorRows.length > 0);

  // Get weekly plan
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

  // Calculate weeks active
  const createdAt = profile?.created_at || user.created_at;
  const weeksActive = Math.max(1, Math.floor(
    (new Date().getTime() - new Date(createdAt).getTime()) / (1000 * 60 * 60 * 24 * 7)
  ));

  // 5. Get Daily Tip
  let dailyTip = null;
  if (couple) {
    dailyTip = await getDailyTip();
  }

  // 6. Get Active Challenge
  let activeChallenge = null;
  if (couple) {
    const { data: challengeAssoc } = await supabase
      .from('challenge_assignments')
      .select('challenge_id, status, weekly_challenges(title, dimension)')
      .eq('couple_id', couple.id)
      .eq('status', 'active')
      .limit(1)
      .single();

    if (challengeAssoc && challengeAssoc.weekly_challenges) {
      activeChallenge = {
        id: challengeAssoc.challenge_id,
        title: (challengeAssoc.weekly_challenges as any).title,
        dimension: (challengeAssoc.weekly_challenges as any).dimension,
      };
    }
  }

  // 7. Get Upcoming Milestones
  let upcomingMilestones: any[] = [];
  if (couple) {
    const { data: milestones } = await supabase
      .from('milestones')
      .select('id, title, date, milestone_type')
      .eq('couple_id', couple.id)
      .gte('date', new Date().toISOString().split('T')[0])
      .order('date', { ascending: true })
      .limit(2);
      
    if (milestones) {
      upcomingMilestones = milestones;
    }
  }

  // 8. Generate or Fetch Daily Insight (AI Summary)
  let dashboardInsight = null;
  if (couple) {
    try {
      dashboardInsight = await getDashboardInsight();
    } catch (err) {
      console.log('Failed to fetch dashboard insight', err);
    }
  }

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
    dailyTip,
    dashboardInsight,
    activeChallenge,
    upcomingMilestones,
  };
}
