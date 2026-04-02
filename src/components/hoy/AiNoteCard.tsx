'use client';

import { motion } from 'framer-motion';
import { Sparkles } from 'lucide-react';

type AiNoteCategory = 'encouragement' | 'reflection' | 'pattern' | 'invitation';

interface AiNoteCardProps {
  message: string;
  category?: AiNoteCategory;
  title?: string;
}

const CATEGORY_LABELS: Record<AiNoteCategory, string> = {
  encouragement: 'Reconocimiento',
  reflection: 'Reflexión',
  pattern: 'Patrón observado',
  invitation: 'Una idea para hoy',
};

export function AiNoteCard({ message, category = 'reflection', title }: AiNoteCardProps) {
  const categoryLabel = CATEGORY_LABELS[category];

  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6, ease: 'easeOut', delay: 0.35 }}
    >
      <div
        className="rounded-[20px] p-6 relative overflow-hidden"
        style={{
          background: 'linear-gradient(150deg, var(--color-ai-dim) 0%, var(--color-surface-1) 100%)',
          border: '1px solid var(--color-border)',
        }}
      >
        {/* Subtle warm glow */}
        <div
          className="absolute -top-8 -right-8 w-24 h-24 rounded-full blur-3xl opacity-15 pointer-events-none"
          style={{ background: 'var(--color-ai)' }}
        />

        <div className="relative z-10">
          {/* Header */}
          <div className="flex items-center gap-2.5 mb-4">
            <div
              className="w-7 h-7 rounded-lg flex items-center justify-center"
              style={{ background: 'var(--color-ai)', color: 'var(--color-base)' }}
            >
              <Sparkles className="h-3.5 w-3.5" />
            </div>
            <span
              className="text-[11px] font-bold uppercase tracking-[0.16em]"
              style={{ color: 'var(--color-ai)' }}
            >
              {categoryLabel}
            </span>
          </div>

          {/* Title if provided */}
          {title && (
            <h4
              className="font-display text-lg mb-2"
              style={{ color: 'var(--color-text-primary)' }}
            >
              {title}
            </h4>
          )}

          {/* Message — the core. Reads like a warm note, not a report */}
          <motion.p
            className="text-[15px] leading-[1.7] italic"
            style={{ color: 'var(--color-text-primary)', opacity: 0.9 }}
            initial={{ opacity: 0, y: 6 }}
            animate={{ opacity: 0.9, y: 0 }}
            transition={{ duration: 0.6, delay: 0.5, ease: 'easeOut' }}
          >
            &ldquo;{message}&rdquo;
          </motion.p>
        </div>
      </div>
    </motion.div>
  );
}
