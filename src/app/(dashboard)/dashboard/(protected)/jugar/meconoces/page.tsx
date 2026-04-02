'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { motion } from 'framer-motion';
import { ArrowLeft, Play, Loader2, Users, Trophy, Heart } from 'lucide-react';
import { getActiveRound, startMeConocesRound, getMeConocesScores, type MeConocesRound, type MeConocesScore } from './actions';

const DIMENSION_META: Record<string, { label: string; color: string }> = {
  conexion: { label: 'Conexión', color: 'var(--color-conexion)' },
  cuidado: { label: 'Cuidado', color: 'var(--color-cuidado)' },
  choque: { label: 'Conflicto', color: 'var(--color-choque)' },
  camino: { label: 'Camino', color: 'var(--color-camino)' },
  general: { label: 'General', color: 'var(--color-ai)' },
};

export default function MeConocesPage() {
  const router = useRouter();
  const [activeRound, setActiveRound] = useState<MeConocesRound | null>(null);
  const [scores, setScores] = useState<MeConocesScore[]>([]);
  const [loading, setLoading] = useState(true);
  const [starting, setStarting] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    async function load() {
      const [round, sc] = await Promise.all([
        getActiveRound(),
        getMeConocesScores(),
      ]);
      setActiveRound(round);
      setScores(sc);
      setLoading(false);
    }
    load();
  }, []);

  const handleStart = async () => {
    setStarting(true);
    setError('');
    const result = await startMeConocesRound();
    setStarting(false);
    if ('error' in result) {
      setError(result.error);
    } else {
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
      <AppShell>
        <div className="flex items-center justify-center min-h-[70vh]">
          <Loader2 className="h-10 w-10 animate-spin" style={{ color: 'var(--color-ai)' }} />
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell>
      <div className="space-y-6 max-w-lg mx-auto pb-12">
        {/* Header */}
        <div className="flex items-center gap-3">
          <button
            onClick={() => router.push('/dashboard/jugar')}
            className="p-2 rounded-xl transition-colors hover:bg-surface-3"
            style={{ color: 'var(--color-text-secondary)' }}
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <h1 className="font-display text-2xl md:text-3xl" style={{ color: 'var(--color-text-primary)' }}>
              ¿Me conoces?
            </h1>
            <p className="text-sm mt-0.5" style={{ color: 'var(--color-text-tertiary)' }}>
              ¿Cuánto sabes de tu pareja?
            </p>
          </div>
        </div>

        {/* Active Round */}
        {activeRound && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            className="rounded-2xl p-5"
            style={{
              background: 'var(--color-surface-1)',
              border: '1px solid var(--color-ai)',
              boxShadow: '0 0 12px var(--color-ai-glow)',
            }}
          >
            <div className="flex items-center gap-3 mb-3">
              <div className="p-2 rounded-full" style={{ background: 'var(--color-ai-dim)' }}>
                <Play className="w-5 h-5" style={{ color: 'var(--color-ai)' }} />
              </div>
              <div>
                <h3 className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>
                  Ronda en curso
                </h3>
                <p className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                  {activeRound.status === 'pending_answers'
                    ? `${activeRound.answererName} está respondiendo...`
                    : `¡Es tu turno de adivinar!`}
                </p>
              </div>
            </div>
            <button
              onClick={handleContinue}
              className="w-full py-2.5 rounded-xl text-sm font-semibold transition-colors"
              style={{
                background: 'var(--color-ai)',
                color: 'var(--color-base)',
              }}
            >
              {activeRound.status === 'pending_answers' ? 'Ver estado' : 'Adivinar ahora'}
            </button>
          </motion.div>
        )}

        {/* Start New Round */}
        {!activeRound && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            className="rounded-2xl p-6 text-center"
            style={{
              background: 'var(--color-surface-1)',
              border: '1px solid var(--color-border)',
            }}
          >
            <div className="w-16 h-16 rounded-full mx-auto mb-4 flex items-center justify-center" style={{ background: 'var(--color-ai-dim)' }}>
              <Users className="w-8 h-8" style={{ color: 'var(--color-ai)' }} />
            </div>
            <h3 className="text-lg font-semibold mb-2" style={{ color: 'var(--color-text-primary)' }}>
              ¿Cuánto conoces a tu pareja?
            </h3>
            <p className="text-sm mb-5" style={{ color: 'var(--color-text-secondary)' }}>
              Responde preguntas sobre ti y deja que tu pareja adivine. Descubran cuánto se conocen realmente.
            </p>
            <button
              onClick={handleStart}
              disabled={starting}
              className="px-8 py-3 rounded-xl text-sm font-semibold transition-colors disabled:opacity-50"
              style={{
                background: 'var(--color-ai)',
                color: 'var(--color-base)',
              }}
            >
              {starting ? 'Creando ronda...' : 'Empezar ronda'}
            </button>
            {error && (
              <p className="text-sm mt-3" style={{ color: 'var(--color-danger)' }}>{error}</p>
            )}
          </motion.div>
        )}

        {/* Knowledge Scores */}
        {scores.length > 0 && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className="rounded-2xl p-5"
            style={{
              background: 'var(--color-surface-1)',
              border: '1px solid var(--color-border)',
            }}
          >
            <div className="flex items-center gap-2 mb-4">
              <Trophy className="w-4 h-4" style={{ color: 'var(--color-ai)' }} />
              <h3 className="font-semibold text-sm" style={{ color: 'var(--color-text-primary)' }}>
                ¿Cuánto se conocen?
              </h3>
            </div>
            <div className="space-y-3">
              {scores.map(s => {
                const meta = DIMENSION_META[s.dimension] || DIMENSION_META.general;
                return (
                  <div key={s.dimension}>
                    <div className="flex items-center justify-between mb-1">
                      <span className="text-xs font-medium" style={{ color: 'var(--color-text-secondary)' }}>
                        {meta.label}
                      </span>
                      <span className="text-xs font-semibold" style={{ color: meta.color }}>
                        {s.knowledgeScore}%
                      </span>
                    </div>
                    <div className="w-full h-2 rounded-full overflow-hidden" style={{ background: 'var(--color-surface-3)' }}>
                      <motion.div
                        className="h-full rounded-full"
                        style={{ background: meta.color }}
                        initial={{ width: 0 }}
                        animate={{ width: `${s.knowledgeScore}%` }}
                        transition={{ duration: 0.8, delay: 0.3 }}
                      />
                    </div>
                    <p className="text-[10px] mt-0.5" style={{ color: 'var(--color-text-tertiary)' }}>
                      {s.roundsPlayed} {s.roundsPlayed === 1 ? 'ronda' : 'rondas'}
                    </p>
                  </div>
                );
              })}
            </div>
          </motion.div>
        )}

        {/* How it works */}
        <div
          className="rounded-2xl p-5"
          style={{
            background: 'var(--color-surface-1)',
            border: '1px solid var(--color-border)',
          }}
        >
          <h3 className="font-semibold text-sm mb-3" style={{ color: 'var(--color-text-primary)' }}>
            Cómo funciona
          </h3>
          <div className="space-y-3">
            {[
              { icon: Heart, text: 'Tú respondes 5 preguntas sobre ti mismo/a' },
              { icon: Users, text: 'Tu pareja adivina tus respuestas' },
              { icon: Trophy, text: 'Descubren cuánto se conocen y ganan puntos' },
            ].map(({ icon: Icon, text }, i) => (
              <div key={i} className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0" style={{ background: 'var(--color-surface-3)' }}>
                  <Icon className="w-4 h-4" style={{ color: 'var(--color-text-tertiary)' }} />
                </div>
                <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>{text}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </AppShell>
  );
}
