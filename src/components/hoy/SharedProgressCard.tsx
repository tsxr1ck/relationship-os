'use client';

import { motion } from 'framer-motion';
import { Flame, TrendingUp, ArrowRight } from 'lucide-react';

interface SharedProgressCardProps {
  challengeTitle: string | null;
  challengeDimension: string | null;
  weeklyPlanProgress: { completed: number; total: number } | null;
  onNavigate: () => void;
}

function getProgressMessage(completed: number, total: number): string {
  const remaining = total - completed;
  if (remaining === 0) return '¡Completaron todo! Tómense un respiro juntos.';
  if (remaining === 1) return 'Les falta uno solo. Ya casi.';
  if (completed === 0) return 'Tienen un plan esperándolos esta semana.';
  if (completed / total > 0.7) return 'Van muy bien esta semana.';
  if (completed / total > 0.4) return 'Buen ritmo, sigan así.';
  return `Les faltan ${remaining} pasos para completar esto juntos.`;
}

export function SharedProgressCard({
  challengeTitle,
  challengeDimension,
  weeklyPlanProgress,
  onNavigate,
}: SharedProgressCardProps) {
  const hasChallenge = !!challengeTitle;
  const hasPlan = !!weeklyPlanProgress && weeklyPlanProgress.total > 0;

  if (!hasChallenge && !hasPlan) {
    return null;
  }

  const progressMessage = hasPlan
    ? getProgressMessage(weeklyPlanProgress!.completed, weeklyPlanProgress!.total)
    : null;

  const progressPercent = hasPlan
    ? Math.round((weeklyPlanProgress!.completed / weeklyPlanProgress!.total) * 100)
    : 0;

  return (
    <motion.div
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, ease: 'easeOut', delay: 0.25 }}
    >
      <div
        className="rounded-[20px] p-6 relative overflow-hidden group cursor-pointer transition-all duration-300 hover:scale-[1.01]"
        style={{
          background: hasChallenge
            ? 'linear-gradient(145deg, var(--color-camino-dim) 0%, var(--color-surface-1) 100%)'
            : 'var(--color-surface-1)',
          border: '1px solid var(--color-border)',
        }}
        onClick={onNavigate}
      >
        {/* Header */}
        <div className="flex items-center gap-2.5 mb-4">
          <div
            className="w-7 h-7 rounded-lg flex items-center justify-center"
            style={{
              background: hasChallenge ? 'var(--color-camino)' : 'var(--color-cuidado)',
              color: 'var(--color-base)',
            }}
          >
            {hasChallenge ? (
              <Flame className="h-3.5 w-3.5" />
            ) : (
              <TrendingUp className="h-3.5 w-3.5" />
            )}
          </div>
          <span
            className="text-[11px] font-bold uppercase tracking-[0.16em]"
            style={{
              color: hasChallenge ? 'var(--color-camino)' : 'var(--color-cuidado)',
            }}
          >
            {hasChallenge ? 'Reto activo' : 'Esta semana'}
          </span>
        </div>

        {/* Challenge or progress content */}
        {hasChallenge && (
          <>
            <h4
              className="font-display text-lg mb-1.5"
              style={{ color: 'var(--color-text-primary)' }}
            >
              {challengeTitle}
            </h4>
            {challengeDimension && (
              <p className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                Fortaleciendo &ldquo;{challengeDimension}&rdquo;
              </p>
            )}
          </>
        )}

        {hasPlan && !hasChallenge && (
          <>
            <p
              className="text-[15px] leading-relaxed mb-4"
              style={{ color: 'var(--color-text-primary)' }}
            >
              {progressMessage}
            </p>

            {/* Warm progress bar */}
            <div
              className="w-full h-1.5 rounded-full overflow-hidden"
              style={{ background: 'var(--color-surface-3)' }}
            >
              <motion.div
                className="h-full rounded-full"
                style={{ background: 'var(--color-cuidado)' }}
                initial={{ width: 0 }}
                animate={{ width: `${progressPercent}%` }}
                transition={{ duration: 1, ease: 'easeOut', delay: 0.3 }}
              />
            </div>
          </>
        )}

        {/* CTA hint */}
        <div
          className="flex items-center gap-1.5 mt-4 text-xs font-medium opacity-0 group-hover:opacity-100 transition-opacity duration-300"
          style={{ color: hasChallenge ? 'var(--color-camino)' : 'var(--color-cuidado)' }}
        >
          Ver detalles
          <ArrowRight className="h-3 w-3 group-hover:translate-x-0.5 transition-transform" />
        </div>
      </div>
    </motion.div>
  );
}
