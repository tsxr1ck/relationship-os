'use client';

import { motion } from 'framer-motion';
import { Clock, BookOpen } from 'lucide-react';

interface MemoryResurfaceCardProps {
  title: string;
  description: string;
  occurredAt: string; // ISO date
  type: 'challenge' | 'question' | 'milestone' | 'saved_plan';
}

function getTimeSince(isoDate: string): string {
  const now = new Date();
  const then = new Date(isoDate);
  const diffMs = now.getTime() - then.getTime();
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
  const diffWeeks = Math.floor(diffDays / 7);
  const diffMonths = Math.floor(diffDays / 30);

  if (diffDays < 7) return `Hace ${diffDays} días`;
  if (diffWeeks === 1) return 'Hace una semana';
  if (diffWeeks < 5) return `Hace ${diffWeeks} semanas`;
  if (diffMonths === 1) return 'Hace un mes';
  if (diffMonths < 12) return `Hace ${diffMonths} meses`;
  return 'Hace más de un año';
}

export function MemoryResurfaceCard({
  title,
  description,
  occurredAt,
  type,
}: MemoryResurfaceCardProps) {
  const timeSince = getTimeSince(occurredAt);

  return (
    <motion.div
      initial={{ opacity: 0, filter: 'blur(8px)', y: 12 }}
      animate={{ opacity: 1, filter: 'blur(0px)', y: 0 }}
      transition={{ duration: 0.8, ease: 'easeOut', delay: 0.3 }}
    >
      <div
        className="rounded-[20px] p-6 relative overflow-hidden"
        style={{
          background: `linear-gradient(145deg, var(--color-memory-tint) 0%, var(--color-surface-1) 100%)`,
          border: '1px solid var(--color-border)',
        }}
      >
        {/* Archival overlay — gives a "memory" feel */}
        <div
          className="absolute inset-0 opacity-[0.03] pointer-events-none"
          style={{
            backgroundImage: `url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E")`,
          }}
        />

        <div className="relative z-10">
          {/* Header */}
          <div className="flex items-center gap-2 mb-3">
            <BookOpen className="h-3.5 w-3.5" style={{ color: 'var(--color-accent-rose)' }} />
            <span
              className="text-[11px] font-medium tracking-wide"
              style={{ color: 'var(--color-accent-rose)' }}
            >
              Un momento para volver
            </span>
          </div>

          {/* Memory content */}
          <p
            className="text-[15px] leading-relaxed mb-3 font-display italic"
            style={{ color: 'var(--color-text-primary)', opacity: 0.9 }}
          >
            &ldquo;{title}&rdquo;
          </p>

          {description && (
            <p
              className="text-sm leading-relaxed mb-3"
              style={{ color: 'var(--color-text-secondary)', opacity: 0.8 }}
            >
              {description}
            </p>
          )}

          {/* Timestamp */}
          <div className="flex items-center gap-1.5">
            <Clock className="h-3 w-3" style={{ color: 'var(--color-text-tertiary)' }} />
            <span
              className="text-[11px] font-medium"
              style={{ color: 'var(--color-text-tertiary)' }}
            >
              {timeSince}
            </span>
          </div>
        </div>
      </div>
    </motion.div>
  );
}
