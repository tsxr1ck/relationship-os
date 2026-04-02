'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { EmotionalHeader } from '@/components/hoy/EmotionalHeader';
import { PrimaryActionCard, type ActionType } from '@/components/hoy/PrimaryActionCard';
import { SharedProgressCard } from '@/components/hoy/SharedProgressCard';
import { MemoryResurfaceCard } from '@/components/hoy/MemoryResurfaceCard';
import { AiNoteCard } from '@/components/hoy/AiNoteCard';
import { ConocenosCard } from '@/components/hoy/ConocenosCard';
import { PartnerPresenceCard } from '@/components/hoy/PartnerPresenceCard';
import { JugarCarouselCard } from '@/components/meconoces/JugarCarouselCard';
import { Loader2 } from 'lucide-react';
import { motion } from 'framer-motion';
import { getDashboardCore, getDashboardEnrichment, type DashboardCoreData, type DashboardEnrichmentData, type DashboardData } from '../queries';

/* ──────────────────────────────────────────────
   HOY — The Emotional Center
   A vertical feed telling the story of "us" today
   ────────────────────────────────────────────── */

function SkeletonCard() {
  return (
    <div
      className="rounded-[20px] p-5 animate-pulse"
      style={{
        background: 'var(--color-surface-1)',
        border: '1px solid var(--color-border)',
      }}
    >
      <div
        className="h-4 rounded-full mb-3"
        style={{ background: 'var(--color-surface-3)', width: '60%' }}
      />
      <div
        className="h-3 rounded-full mb-2"
        style={{ background: 'var(--color-surface-3)', width: '90%' }}
      />
      <div
        className="h-3 rounded-full"
        style={{ background: 'var(--color-surface-3)', width: '75%' }}
      />
    </div>
  );
}

export default function HoyPage() {
  const router = useRouter();
  const [coreData, setCoreData] = useState<DashboardCoreData | null>(null);
  const [enrichment, setEnrichment] = useState<DashboardEnrichmentData | null>(null);
  const [coreLoading, setCoreLoading] = useState(true);
  const [enrichmentLoading, setEnrichmentLoading] = useState(false);
  const [error, setError] = useState('');

  // Phase 1: Load core data (fast)
  useEffect(() => {
    async function loadCore() {
      try {
        const data = await getDashboardCore();
        setCoreData(data);
      } catch (err: any) {
        console.error('Dashboard core load error:', err);
        setError(err.message);
      } finally {
        setCoreLoading(false);
      }
    }
    loadCore();
  }, []);

  // Phase 2: Load enrichment data (slow, starts after core)
  useEffect(() => {
    if (!coreData) return;
    const coupleId = coreData.couple?.id ?? null;

    async function loadEnrichment() {
      setEnrichmentLoading(true);
      try {
        const data = await getDashboardEnrichment(coupleId);
        setEnrichment(data);
      } catch (err) {
        console.error('Dashboard enrichment load error:', err);
      } finally {
        setEnrichmentLoading(false);
      }
    }
    loadEnrichment();
  }, [coreData]);

  /* ── Core Loading State ── */
  if (coreLoading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[70vh]">
          <motion.div
            className="text-center"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.4 }}
          >
            <Loader2
              className="h-10 w-10 mx-auto mb-4 animate-spin"
              style={{ color: 'var(--color-ai)' }}
            />
            <p
              className="text-sm"
              style={{ color: 'var(--color-text-tertiary)' }}
            >
              Preparando tu espacio...
            </p>
          </motion.div>
        </div>
      </AppShell>
    );
  }

  /* ── Error State ── */
  if (error || !coreData) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[70vh]">
          <div className="text-center">
            <p className="mb-4 text-sm" style={{ color: 'var(--color-text-secondary)' }}>
              {error || 'Error cargando datos'}
            </p>
            <button
              className="px-6 py-2.5 rounded-2xl text-sm font-semibold transition-colors"
              style={{
                background: 'var(--color-surface-2)',
                color: 'var(--color-text-primary)',
                border: '1px solid var(--color-border)',
              }}
              onClick={() => window.location.reload()}
            >
              Reintentar
            </button>
          </div>
        </div>
      </AppShell>
    );
  }

  /* ── Feed Orchestration Logic ── */
  const hasCouple = coreData.couple !== null;
  const hasScores = !!(coreData.scores && Object.keys(coreData.scores).length > 0);

  const primaryAction = determinePrimaryAction(coreData);
  const weeklyProgress = coreData.weeklyPlan
    ? { completed: coreData.weeklyPlan.completedCount, total: coreData.weeklyPlan.totalCount }
    : null;
  const memory = deriveMemory({ ...coreData, ...enrichment } as DashboardData);
  const aiNote = enrichment?.dashboardInsight;
  const daysActive = coreData.weeksActive * 7;

  return (
    <AppShell>
      <div className="space-y-5 md:space-y-6 pb-10 max-w-lg mx-auto lg:max-w-2xl">

        {/* ═══ 1. EMOTIONAL HEADER ═══ */}
        <EmotionalHeader
          userName={coreData.user.displayName}
          partnerName={coreData.partner?.displayName ?? null}
          avatarUrl={coreData.user.avatarUrl}
          partnerAvatarUrl={coreData.partner?.avatarUrl ?? null}
          daysActive={daysActive}
          durationText={coreData.couple?.durationText ?? null}
          hasCouple={hasCouple}
          onAvatarClick={() => router.push('/dashboard/profile')}
          onPartnerAction={() => router.push('/couple/create')}
        />

        {/* ═══ 2. PRIMARY ACTION CARD ═══ */}
        <PrimaryActionCard
          type={primaryAction.type}
          title={primaryAction.title}
          subtitle={primaryAction.subtitle}
          ctaLabel={primaryAction.ctaLabel}
          onAction={() => router.push(primaryAction.route)}
        />

        {/* ═══ 3. CONOCERNOS — Daily Question ═══ */}
        {enrichmentLoading ? (
          <SkeletonCard />
        ) : enrichment?.conocernos ? (
          <ConocenosCard data={enrichment.conocernos} />
        ) : null}

        {/* ═══ 4. PARTNER PRESENCE CARD ═══ */}
        {hasCouple && coreData.partner && (
          <PartnerPresenceCard
            partnerName={coreData.partner.displayName}
            partnerAvatarUrl={coreData.partner.avatarUrl}
            lastActivity={coreData.partner.lastSeenAt}
            lastActivityType={coreData.partner.isOnline ? 'opened_app' : null}
          />
        )}

        {/* ═══ 5. JUGAR CAROUSEL ═══ */}
        {hasCouple && <JugarCarouselCard />}

        {/* ═══ 6. SHARED PROGRESS ═══ */}
        <SharedProgressCard
          challengeTitle={enrichment?.activeChallenge?.title ?? null}
          challengeDimension={enrichment?.activeChallenge?.dimension ?? null}
          weeklyPlanProgress={weeklyProgress}
          onNavigate={() => router.push(enrichment?.activeChallenge ? '/dashboard/retos' : '/dashboard/plan')}
        />

        {/* ═══ 6. RESURFACED MEMORY ═══ */}
        {enrichmentLoading ? (
          <SkeletonCard />
        ) : memory ? (
          <MemoryResurfaceCard
            title={memory.title}
            description={memory.description}
            occurredAt={memory.occurredAt}
            type={memory.type}
          />
        ) : null}

        {/* ═══ 7. AI NOTE ═══ */}
        {enrichmentLoading ? (
          <SkeletonCard />
        ) : aiNote ? (
          <AiNoteCard
            message={aiNote.body}
            title={aiNote.title}
            category="reflection"
          />
        ) : null}

        {/* ═══ DAILY TIP ═══ */}
        {enrichmentLoading ? null : enrichment?.dailyTip?.tip && !aiNote && (
          <AiNoteCard
            message={enrichment.dailyTip.tip}
            category="invitation"
          />
        )}

        {/* ═══ 4C MINI-SNAPSHOT ═══ */}
        {hasScores && coreData.scores && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.4 }}
          >
            <div
              className="rounded-[20px] p-5 cursor-pointer transition-all duration-300 hover:scale-[1.01]"
              style={{
                background: 'var(--color-surface-1)',
                border: '1px solid var(--color-border)',
              }}
              onClick={() => router.push('/dashboard/nosotros')}
            >
              <p
                className="text-[11px] font-bold uppercase tracking-[0.16em] mb-4"
                style={{ color: 'var(--color-text-tertiary)' }}
              >
                Lo que está vivo entre ustedes
              </p>

              <div className="grid grid-cols-4 gap-3">
                {[
                  { key: 'conexion', label: 'Conexión', color: 'var(--color-conexion)' },
                  { key: 'cuidado', label: 'Cuidado', color: 'var(--color-cuidado)' },
                  { key: 'choque', label: 'Conflicto', color: 'var(--color-choque)' },
                  { key: 'camino', label: 'Camino', color: 'var(--color-camino)' },
                ].map(({ key, label, color }) => {
                  const score = Math.round((coreData.scores![key as keyof typeof coreData.scores] || 0) * 100);
                  return (
                    <div key={key} className="text-center">
                      <motion.span
                        className="font-display text-2xl block mb-1"
                        style={{ color }}
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        transition={{ delay: 0.6, duration: 0.4 }}
                      >
                        {score}
                      </motion.span>
                      <p
                        className="text-[9px] font-medium uppercase tracking-wider"
                        style={{ color: 'var(--color-text-tertiary)' }}
                      >
                        {label}
                      </p>
                      <div
                        className="w-full h-1 rounded-full overflow-hidden mt-1.5"
                        style={{ background: 'var(--color-surface-3)' }}
                      >
                        <motion.div
                          className="h-full rounded-full"
                          style={{ background: color }}
                          initial={{ width: 0 }}
                          animate={{ width: `${score}%` }}
                          transition={{ duration: 1, delay: 0.7, ease: 'easeOut' }}
                        />
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          </motion.div>
        )}

      </div>
    </AppShell>
  );
}

/* ══════════════════════════════════════════════
   FEED ORCHESTRATION HELPERS
   ══════════════════════════════════════════════ */

interface PrimaryActionData {
  type: ActionType;
  title: string;
  subtitle: string;
  ctaLabel: string;
  route: string;
}

function determinePrimaryAction(data: DashboardCoreData): PrimaryActionData {
  if (!data.onboardingCompleted) {
    return {
      type: 'complete_onboarding',
      title: 'Cuéntanos quién eres',
      subtitle: 'Completa tu perfil para que podamos conocerte mejor y personalizar tu experiencia.',
      ctaLabel: 'Empezar',
      route: '/onboarding',
    };
  }

  if (!data.couple) {
    return {
      type: 'invite_partner',
      title: 'Invita a quien más quieres',
      subtitle: 'Este espacio cobra vida cuando lo comparten. Envía una invitación para empezar juntos.',
      ctaLabel: 'Invitar pareja',
      route: '/couple/create',
    };
  }

  if (data.questionnaireStatus !== 'completed') {
    return {
      type: 'continue_assessment',
      title: 'Tienen una conversación pendiente',
      subtitle: 'Completen su evaluación para descubrir las fuerzas que los unen y los retos que pueden superar.',
      ctaLabel: 'Continuar evaluación',
      route: '/dashboard/nosotros',
    };
  }

  return {
    type: 'suggested_reconnect',
    title: 'Hoy es un buen día para reconectar',
    subtitle: 'Exploren algo nuevo juntos o revisiten lo que han construido hasta ahora.',
    ctaLabel: 'Explorar juntos',
    route: '/dashboard/nosotros',
  };
}

function deriveMemory(data: DashboardData): {
  title: string;
  description: string;
  occurredAt: string;
  type: 'challenge' | 'question' | 'milestone' | 'saved_plan';
} | null {
  if (data.weeklyPlan && data.weeklyPlan.items?.length > 0) {
    const completed = data.weeklyPlan.items.filter((i: any) => i.status === 'completed');
    if (completed.length > 0) {
      const item = completed[completed.length - 1];
      return {
        title: item.title || 'Completaron una actividad juntos',
        description: item.description || 'Un paso más en su camino compartido.',
        occurredAt: item.completed_at || item.updated_at || data.couple?.createdAt || new Date().toISOString(),
        type: 'challenge',
      };
    }
  }

  if (data.upcomingMilestones?.length > 0) {
    const m = data.upcomingMilestones[0];
    return {
      title: m.title || 'Un momento importante se acerca',
      description: `Tipo: ${m.milestone_type || 'especial'}`,
      occurredAt: m.date,
      type: 'milestone',
    };
  }

  return null;
}
