import { requireDashboardAccess } from '@/lib/auth/require-access';

export default async function ProtectedDashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  // This will enforce that the user has completed onboarding, joined a couple, and finished the questionnaire.
  // If not, it will throw a redirect.
  await requireDashboardAccess();

  return (
    <>{children}</>
  );
}
