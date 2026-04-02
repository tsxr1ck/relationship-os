'use client';

import { motion } from 'framer-motion';
import { Eye, Smartphone } from 'lucide-react';

interface PartnerPresenceCardProps {
  partnerName: string;
  partnerAvatarUrl: string | null;
  lastActivity: string | null;
  lastActivityType: string | null;
}

function getRelativeTime(isoDate: string): string {
  const now = new Date();
  const then = new Date(isoDate);
  const diffMs = now.getTime() - then.getTime();
  const diffMinutes = Math.floor(diffMs / (1000 * 60));
  const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

  if (diffMinutes < 5) return 'hace un momento';
  if (diffMinutes < 30) return 'hace unos minutos';
  if (diffMinutes < 60) return 'hace un rato';
  if (diffHours === 1) return 'hace una hora';
  if (diffHours < 4) return 'hace unas horas';
  if (diffHours < 12) return 'esta mañana';
  if (diffHours < 24) return 'hoy';
  if (diffDays === 1) return 'ayer';
  if (diffDays < 7) return `hace ${diffDays} días`;
  return 'hace tiempo';
}

function getActivityLabel(partnerName: string, type: string | null, relativeTime: string, isOnline: boolean): string {
  const firstName = partnerName.split(' ')[0];

  if (isOnline) {
    return `${firstName} está usando la app ahora mismo.`;
  }

  switch (type) {
    case 'completed_activity':
      return `${firstName} completó una actividad ${relativeTime}.`;
    case 'answered_prompt':
      return `${firstName} respondió a algo ${relativeTime}.`;
    case 'saved_plan':
      return `${firstName} guardó una idea para ustedes ${relativeTime}.`;
    case 'opened_app':
      return `${firstName} estuvo en la app ${relativeTime}.`;
    default:
      return `${firstName} estuvo aquí ${relativeTime}.`;
  }
}

export function PartnerPresenceCard({
  partnerName,
  partnerAvatarUrl,
  lastActivity,
  lastActivityType,
}: PartnerPresenceCardProps) {
  if (!lastActivity) {
    return null;
  }

  const firstName = partnerName.split(' ')[0];
  const relativeTime = getRelativeTime(lastActivity);
  const isOnline = (Date.now() - new Date(lastActivity).getTime()) < 5 * 60 * 1000;
  const label = getActivityLabel(partnerName, lastActivityType, relativeTime, isOnline);
  const initial = firstName.charAt(0).toUpperCase();

  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.97 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ duration: 0.5, ease: 'easeOut', delay: 0.2 }}
    >
      <div
        className="rounded-[20px] px-5 py-4 flex items-center gap-4"
        style={{
          background: 'var(--color-surface-1)',
          border: isOnline
            ? '1px solid var(--color-success)'
            : '1px solid var(--color-border)',
          boxShadow: isOnline
            ? '0 0 12px rgba(127, 163, 106, 0.15)'
            : 'none',
        }}
      >
        {/* Partner avatar with warm pulse */}
        <div className="relative shrink-0">
          <div
            className="w-10 h-10 rounded-full flex items-center justify-center text-sm font-semibold overflow-hidden"
            style={{
              background: 'var(--color-surface-2)',
              color: 'var(--color-text-primary)',
              border: isOnline
                ? '2px solid var(--color-success)'
                : '2px solid var(--color-accent-soft)',
            }}
          >
            {partnerAvatarUrl ? (
              <img src={partnerAvatarUrl} alt={firstName} className="w-full h-full object-cover" />
            ) : (
              initial
            )}
          </div>
          {/* Online indicator */}
          {isOnline && (
            <div
              className="absolute -bottom-0.5 -right-0.5 w-3.5 h-3.5 rounded-full border-2"
              style={{
                background: 'var(--color-success)',
                borderColor: 'var(--color-surface-1)',
              }}
            />
          )}
        </div>

        {/* Presence text */}
        <div className="flex-1 min-w-0">
          <p
            className="text-sm leading-relaxed"
            style={{ color: 'var(--color-text-secondary)' }}
          >
            {label}
          </p>
          {!isOnline && (
            <p
              className="text-xs mt-0.5"
              style={{ color: 'var(--color-text-tertiary)' }}
            >
              Última vez: {relativeTime}
            </p>
          )}
        </div>

        {/* Soft presence indicator */}
        <div className="shrink-0">
          {isOnline ? (
            <Smartphone
              className="w-4 h-4"
              style={{ color: 'var(--color-success)' }}
            />
          ) : (
            <div
              className="w-2 h-2 rounded-full"
              style={{
                background: 'var(--color-accent-rose)',
                boxShadow: '0 0 8px rgba(201, 140, 147, 0.4)',
              }}
            />
          )}
        </div>
      </div>
    </motion.div>
  );
}
