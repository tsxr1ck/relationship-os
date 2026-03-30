import { redirect } from 'next/navigation';
import { getCoupleStatus } from '@/app/(dashboard)/dashboard/questionnaire/actions';
import { getOnboardingStatus } from '@/app/(dashboard)/onboarding/actions';

/**
 * Ensures the user has basic access to the Dashboard features.
 * They must have:
 * 1. Completed personal onboarding
 * 2. Joined a couple (with partner linked)
 *
 * The couple questionnaire is voluntary and does NOT gate access.
 */
export async function requireDashboardAccess() {
  const [coupleStatus, onboardingStatus] = await Promise.all([
    getCoupleStatus(),
    getOnboardingStatus(),
  ]);

  // 1. Must finish personal onboarding
  if (onboardingStatus.status !== 'completed') {
    redirect('/onboarding');
  }

  // 2. Must join a couple
  if (!coupleStatus.hasCouple || (coupleStatus.memberCount || 0) < 2) {
    redirect('/onboarding');
  }

  return {
    coupleStatus,
    onboardingStatus,
  };
}
