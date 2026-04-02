'use client';

import { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { motion } from 'framer-motion';
import { ArrowLeft, Trophy, Heart, Check, X, Loader2 } from 'lucide-react';
import { getRoundDetails, type MeConocesEntry, type MeConocesRound } from '../../actions';

const DIMENSION_META: Record<string, { label: string; color: string }> = {
  conexion: { label: 'Conexión', color: 'var(--color-conexion)' },
  cuidado: { label: 'Cuidado', color: 'var(--color-cuidado)' },
  choque: { label: 'Conflicto', color: 'var(--color-choque)' },
  camino: { label: 'Camino', color: 'var(--color-camino)' },
  general: { label: 'General', color: 'var(--color-ai)' },
};

function MatchBadge({ level }: { level: string }) {
  if (level === 'exact') {
    return (
      <span className="px-2 py-0.5 rounded-full text-[10px] font-bold" style={{ background: 'rgba(127, 163, 106, 0.2)', color: 'var(--color-success)' }}>
        Exacto
      </span>
    );
  }
  if (level === 'close') {
    return (
      <span className="px-2 py-0.5 rounded-full text-[10px] font-bold" style={{ background: 'rgba(216, 154, 91, 0.2)', color: 'var(--color-warning)' }}>
        Cercano
      </span>
    );
  }
  return (
    <span className="px-2 py-0.5 rounded-full text-[10px] font-bold" style={{ background: 'rgba(207, 107, 107, 0.2)', color: 'var(--color-danger)' }}>
      Diferente
    </span>
  );
}

export default function ResultsPage({ params }: { params: Promise<{ roundId: string }> }) {
  const { roundId } = use(params);
  const router = useRouter();
  const [round, setRound] = useState<MeConocesRound | null>(null);
  const [entries, setEntries] = useState<MeConocesEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [revealed, setRevealed] = useState<Record<number, boolean>>({});

  useEffect(() => {
    async function load() {
      const { round: r, entries: e } = await getRoundDetails(roundId);
      if (!r || r.status !== 'completed') {
        router.push('/dashboard/jugar/meconoces');
        return;
      }
      setRound(r);
      setEntries(e);
      setLoading(false);
    }
    load();
  }, [roundId, router]);

  const revealEntry = (index: number) => {
    setRevealed(prev => ({ ...prev, [index]: true }));
  };

  if (loading) {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[70vh]">
          <Loader2 className="h-10 w-10 animate-spin" style={{ color: 'var(--color-camino)' }} />
        </div>
      </AppShell>
    );
  }

  if (!round) return null;

  const maxScore = entries.length * 3;
  const scorePct = Math.round((round.score || 0) / maxScore * 100);

  return (
    <AppShell showNav={false}>
      <div className="max-w-lg mx-auto px-4 py-6 space-y-6">
        {/* Header */}
        <div className="flex items-center gap-3">
          <button
            onClick={() => router.push('/dashboard/jugar/meconoces')}
            className="p-2 rounded-xl transition-colors hover:bg-surface-3"
            style={{ color: 'var(--color-text-secondary)' }}
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h1 className="font-display text-xl" style={{ color: 'var(--color-text-primary)' }}>
            Resultados
          </h1>
        </div>

        {/* Score */}
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="rounded-2xl p-6 text-center"
          style={{
            background: 'var(--color-surface-1)',
            border: '1px solid var(--color-border)',
          }}
        >
          <Trophy className="w-12 h-12 mx-auto mb-3" style={{ color: 'var(--color-camino)' }} />
          <p className="text-4xl font-bold mb-1" style={{ color: 'var(--color-text-primary)' }}>
            {round.score}/{maxScore}
          </p>
          <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
            {scorePct >= 80 ? '¡Se conocen muy bien!' : scorePct >= 50 ? 'Buen intento, aún hay mucho por descubrir' : 'Tienen mucho por conocerse'}
          </p>
          <div className="w-full h-3 rounded-full overflow-hidden mt-4" style={{ background: 'var(--color-surface-3)' }}>
            <motion.div
              className="h-full rounded-full"
              style={{ background: scorePct >= 80 ? 'var(--color-success)' : scorePct >= 50 ? 'var(--color-warning)' : 'var(--color-danger)' }}
              initial={{ width: 0 }}
              animate={{ width: `${scorePct}%` }}
              transition={{ duration: 1, delay: 0.3 }}
            />
          </div>
        </motion.div>

        {/* Dimension Scores */}
        {Object.keys(round.dimensionScores).length > 0 && (
          <div
            className="rounded-2xl p-5"
            style={{
              background: 'var(--color-surface-1)',
              border: '1px solid var(--color-border)',
            }}
          >
            <h3 className="font-semibold text-sm mb-3" style={{ color: 'var(--color-text-primary)' }}>
              Por dimensión
            </h3>
            <div className="space-y-2">
              {Object.entries(round.dimensionScores).map(([dim, score]) => {
                const meta = DIMENSION_META[dim] || DIMENSION_META.general;
                return (
                  <div key={dim} className="flex items-center gap-3">
                    <span className="text-xs w-20" style={{ color: 'var(--color-text-secondary)' }}>{meta.label}</span>
                    <div className="flex-1 h-2 rounded-full overflow-hidden" style={{ background: 'var(--color-surface-3)' }}>
                      <motion.div
                        className="h-full rounded-full"
                        style={{ background: meta.color }}
                        initial={{ width: 0 }}
                        animate={{ width: `${score}%` }}
                        transition={{ duration: 0.8, delay: 0.5 }}
                      />
                    </div>
                    <span className="text-xs font-semibold w-10 text-right" style={{ color: meta.color }}>{score}%</span>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Entry-by-entry reveal */}
        <div className="space-y-3">
          {entries.map((entry, i) => (
            <motion.div
              key={entry.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
            >
              {!revealed[i] ? (
                <button
                  onClick={() => revealEntry(i)}
                  className="w-full rounded-2xl p-5 text-left transition-all hover:scale-[1.01]"
                  style={{
                    background: 'var(--color-surface-1)',
                    border: '1px solid var(--color-border)',
                  }}
                >
                  <p className="text-sm font-medium mb-2" style={{ color: 'var(--color-text-primary)' }}>
                    {entry.questionText}
                  </p>
                  <p className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                    Toca para ver la respuesta
                  </p>
                </button>
              ) : (
                <div
                  className="rounded-2xl p-5"
                  style={{
                    background: 'var(--color-surface-1)',
                    border: `1px solid ${entry.matchLevel === 'exact' ? 'var(--color-success)' : entry.matchLevel === 'close' ? 'var(--color-warning)' : 'var(--color-border)'}`,
                  }}
                >
                  <div className="flex items-center justify-between mb-3">
                    <p className="text-sm font-medium" style={{ color: 'var(--color-text-primary)' }}>
                      {entry.questionText}
                    </p>
                    <MatchBadge level={entry.matchLevel || 'wrong'} />
                  </div>

                  <div className="space-y-2">
                    <div className="flex items-start gap-2">
                      <Check className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: 'var(--color-success)' }} />
                      <div>
                        <p className="text-xs font-medium" style={{ color: 'var(--color-text-secondary)' }}>
                          Respuesta real:
                        </p>
                        <p className="text-sm" style={{ color: 'var(--color-text-primary)' }}>
                          {entry.questionType === 'LIKERT-5'
                            ? `${entry.realAnswer}/5`
                            : entry.questionType === 'MULTIPLE_CHOICE'
                            ? entry.realAnswer?.label || entry.realAnswer
                            : entry.realAnswer}
                        </p>
                      </div>
                    </div>
                    <div className="flex items-start gap-2">
                      {entry.matchLevel === 'exact' ? (
                        <Check className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: 'var(--color-success)' }} />
                      ) : (
                        <X className="w-4 h-4 mt-0.5 flex-shrink-0" style={{ color: 'var(--color-danger)' }} />
                      )}
                      <div>
                        <p className="text-xs font-medium" style={{ color: 'var(--color-text-secondary)' }}>
                          Tu respuesta:
                        </p>
                        <p className="text-sm" style={{ color: 'var(--color-text-primary)' }}>
                          {entry.questionType === 'LIKERT-5'
                            ? `${entry.guessedAnswer}/5`
                            : entry.questionType === 'MULTIPLE_CHOICE'
                            ? entry.guessedAnswer?.label || entry.guessedAnswer
                            : entry.guessedAnswer}
                        </p>
                      </div>
                    </div>
                  </div>

                  {entry.aiJudgment && (
                    <p className="text-xs mt-2 italic" style={{ color: 'var(--color-text-tertiary)' }}>
                      {entry.aiJudgment}
                    </p>
                  )}

                  <div className="flex items-center justify-between mt-3 pt-3" style={{ borderTop: '1px solid var(--color-border)' }}>
                    <span className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                      {DIMENSION_META[entry.dimension]?.label || entry.dimension}
                    </span>
                    <span className="text-sm font-bold" style={{ color: entry.pointsAwarded === 3 ? 'var(--color-success)' : entry.pointsAwarded === 2 ? 'var(--color-warning)' : 'var(--color-text-tertiary)' }}>
                      +{entry.pointsAwarded} pts
                    </span>
                  </div>
                </div>
              )}
            </motion.div>
          ))}
        </div>

        {/* Play again */}
        <button
          onClick={() => router.push('/dashboard/jugar/meconoces')}
          className="w-full py-3.5 rounded-xl text-sm font-semibold transition-all"
          style={{
            background: 'var(--color-surface-2)',
            color: 'var(--color-text-primary)',
            border: '1px solid var(--color-border)',
          }}
        >
          Jugar de nuevo
        </button>
      </div>
    </AppShell>
  );
}
