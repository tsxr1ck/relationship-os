'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { Sparkles, ArrowRight, Loader2 } from 'lucide-react';
import { getActiveRound, startMeConocesRound } from '@/app/(dashboard)/dashboard/(protected)/jugar/meconoces/actions';

export function MeConocesCard() {
  const router = useRouter();
  const [activeRound, setActiveRound] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [starting, setStarting] = useState(false);

  useEffect(() => {
    getActiveRound().then(r => {
      setActiveRound(r);
      setLoading(false);
    });
  }, []);

  const handleStart = async () => {
    setStarting(true);
    const result = await startMeConocesRound();
    setStarting(false);
    if ('roundId' in result) {
      router.push(`/dashboard/jugar/meconoces/${result.roundId}/answer`);
    }
  };

  const handleContinue = () => {
    if (!activeRound) return;
    if (activeRound.status === 'pending_answers') {
      router.push(`/dashboard/jugar/meconoces/${activeRound.id}/answer`);
    } else if (activeRound.status === 'pending_guesses') {
      router.push(`/dashboard/jugar/meconoces/${activeRound.id}/guess`);
    }
  };

  if (loading) {
    return (
      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.15 }}
      >
        <div
          className="rounded-[20px] p-5 flex items-center gap-4"
          style={{
            background: 'var(--color-surface-1)',
            border: '1px solid var(--color-border)',
          }}
        >
          <div className="w-10 h-10 rounded-xl flex items-center justify-center" style={{ background: 'var(--color-camino-dim)' }}>
            <Sparkles className="w-5 h-5" style={{ color: 'var(--color-camino)' }} />
          </div>
          <div className="flex-1">
            <div className="h-4 rounded-full w-32 mb-2 animate-pulse" style={{ background: 'var(--color-surface-3)' }} />
            <div className="h-3 rounded-full w-48 animate-pulse" style={{ background: 'var(--color-surface-3)' }} />
          </div>
        </div>
      </motion.div>
    );
  }

  if (activeRound) {
    return (
      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.15 }}
      >
        <div
          className="rounded-[20px] p-5 cursor-pointer transition-all duration-300 hover:scale-[1.01]"
          style={{
            background: 'var(--color-camino-dim)',
            border: '1px solid var(--color-camino)',
            boxShadow: '0 0 12px rgba(201, 168, 76, 0.15)',
          }}
          onClick={handleContinue}
        >
          <div className="flex items-start gap-4">
            <div className="w-10 h-10 rounded-xl flex items-center justify-center shrink-0" style={{ background: 'var(--color-camino)' }}>
              <Sparkles className="w-5 h-5" style={{ color: 'var(--color-base)' }} />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 mb-1">
                <h3 className="font-display text-lg" style={{ color: 'var(--color-text-primary)' }}>
                  ¿Me conoces?
                </h3>
                <span
                  className="px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider"
                  style={{ background: 'var(--color-camino)', color: 'var(--color-base)' }}
                >
                  En curso
                </span>
              </div>
              <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
                {activeRound.status === 'pending_answers'
                  ? `${activeRound.answererName} está respondiendo...`
                  : `¡Es tu turno de adivinar!`}
              </p>
            </div>
            <ArrowRight className="h-5 w-5 shrink-0 mt-2" style={{ color: 'var(--color-text-tertiary)' }} />
          </div>
        </div>
      </motion.div>
    );
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.15 }}
    >
      <div
        className="rounded-[20px] p-5 cursor-pointer transition-all duration-300 hover:scale-[1.01]"
        style={{
          background: 'var(--color-camino-dim)',
          border: '1px solid var(--color-border)',
        }}
        onClick={handleStart}
      >
        <div className="flex items-start gap-4">
          <div className="w-10 h-10 rounded-xl flex items-center justify-center shrink-0" style={{ background: 'var(--color-camino)' }}>
            <Sparkles className="w-5 h-5" style={{ color: 'var(--color-base)' }} />
          </div>
          <div className="flex-1 min-w-0">
            <h3 className="font-display text-lg mb-1" style={{ color: 'var(--color-text-primary)' }}>
              ¿Me conoces?
            </h3>
            <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
              ¿Cuánto sabes de tu pareja? Jueguen a adivinar respuestas.
            </p>
          </div>
          {starting ? (
            <Loader2 className="h-5 w-5 shrink-0 mt-2 animate-spin" style={{ color: 'var(--color-text-tertiary)' }} />
          ) : (
            <ArrowRight className="h-5 w-5 shrink-0 mt-2" style={{ color: 'var(--color-text-tertiary)' }} />
          )}
        </div>
      </div>
    </motion.div>
  );
}
