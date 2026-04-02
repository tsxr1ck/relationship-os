'use client';

import { motion } from 'framer-motion';
import { ArrowRight, MessageCircle, Flame, CalendarCheck, Sparkles, Heart } from 'lucide-react';

export type ActionType =
  | 'pending_question'
  | 'continue_challenge'
  | 'plan_today'
  | 'complete_onboarding'
  | 'invite_partner'
  | 'continue_assessment'
  | 'suggested_reconnect';

interface PrimaryActionCardProps {
  type: ActionType;
  title: string;
  subtitle: string;
  ctaLabel: string;
  onAction: () => void;
}

const ACTION_CONFIG: Record<ActionType, {
  icon: typeof Heart;
  accentColor: string;
  glowColor: string;
  bgGradient: string;
}> = {
  pending_question: {
    icon: MessageCircle,
    accentColor: 'var(--color-conexion)',
    glowColor: 'rgba(232, 116, 138, 0.12)',
    bgGradient: 'linear-gradient(145deg, var(--color-conexion-dim) 0%, var(--color-surface-1) 100%)',
  },
  continue_challenge: {
    icon: Flame,
    accentColor: 'var(--color-camino)',
    glowColor: 'rgba(201, 168, 76, 0.12)',
    bgGradient: 'linear-gradient(145deg, var(--color-camino-dim) 0%, var(--color-surface-1) 100%)',
  },
  plan_today: {
    icon: CalendarCheck,
    accentColor: 'var(--color-cuidado)',
    glowColor: 'rgba(242, 166, 90, 0.12)',
    bgGradient: 'linear-gradient(145deg, var(--color-cuidado-dim) 0%, var(--color-surface-1) 100%)',
  },
  complete_onboarding: {
    icon: Sparkles,
    accentColor: 'var(--color-ai)',
    glowColor: 'var(--color-ai-glow)',
    bgGradient: 'linear-gradient(145deg, var(--color-ai-dim) 0%, var(--color-surface-1) 100%)',
  },
  invite_partner: {
    icon: Heart,
    accentColor: 'var(--color-conexion)',
    glowColor: 'rgba(232, 116, 138, 0.12)',
    bgGradient: 'linear-gradient(145deg, var(--color-conexion-dim) 0%, var(--color-surface-1) 100%)',
  },
  continue_assessment: {
    icon: Sparkles,
    accentColor: 'var(--color-ai)',
    glowColor: 'var(--color-ai-glow)',
    bgGradient: 'linear-gradient(145deg, var(--color-ai-dim) 0%, var(--color-surface-1) 100%)',
  },
  suggested_reconnect: {
    icon: Heart,
    accentColor: 'var(--color-accent-rose)',
    glowColor: 'rgba(201, 140, 147, 0.12)',
    bgGradient: 'linear-gradient(145deg, var(--color-memory-tint) 0%, var(--color-surface-1) 100%)',
  },
};

export function PrimaryActionCard({ type, title, subtitle, ctaLabel, onAction }: PrimaryActionCardProps) {
  const config = ACTION_CONFIG[type];
  const Icon = config.icon;

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, ease: 'easeOut', delay: 0.1 }}
    >
      <div
        className="rounded-[24px] p-7 md:p-8 relative overflow-hidden group cursor-pointer transition-all duration-300 hover:scale-[1.01]"
        style={{
          background: config.bgGradient,
          boxShadow: `0 4px 24px ${config.glowColor}, 0 0 0 1px var(--color-border)`,
        }}
        onClick={onAction}
      >
        {/* Subtle decorative glow */}
        <div
          className="absolute -top-12 -right-12 w-32 h-32 rounded-full blur-3xl opacity-20 group-hover:opacity-30 transition-opacity duration-700"
          style={{ background: config.accentColor }}
        />

        {/* Label */}
        <div className="flex items-center gap-2.5 mb-5">
          <div
            className="w-8 h-8 rounded-xl flex items-center justify-center"
            style={{ background: config.accentColor, color: 'var(--color-base)' }}
          >
            <Icon className="h-4 w-4" />
          </div>
          <span
            className="text-[11px] font-bold uppercase tracking-[0.18em]"
            style={{ color: config.accentColor }}
          >
            Para hoy
          </span>
        </div>

        {/* Content */}
        <h3
          className="font-display text-xl md:text-2xl leading-snug mb-2"
          style={{ color: 'var(--color-text-primary)' }}
        >
          {title}
        </h3>
        <p
          className="text-sm leading-relaxed mb-7 max-w-sm"
          style={{ color: 'var(--color-text-secondary)' }}
        >
          {subtitle}
        </p>

        {/* CTA */}
        <button
          className="px-6 py-3 rounded-2xl text-sm font-bold transition-all active:scale-95 flex items-center gap-2 shadow-lg"
          style={{
            background: config.accentColor,
            color: 'var(--color-base)',
          }}
        >
          {ctaLabel}
          <ArrowRight className="h-4 w-4 group-hover:translate-x-0.5 transition-transform" />
        </button>
      </div>
    </motion.div>
  );
}
