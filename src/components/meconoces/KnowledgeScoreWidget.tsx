'use client';

import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Trophy } from 'lucide-react';
import { getMeConocesScores, type MeConocesScore } from '@/app/(dashboard)/dashboard/(protected)/jugar/meconoces/actions';

const DIMENSION_META: Record<string, { label: string; color: string }> = {
  conexion: { label: 'Conexión', color: 'var(--color-conexion)' },
  cuidado: { label: 'Cuidado', color: 'var(--color-cuidado)' },
  choque: { label: 'Conflicto', color: 'var(--color-choque)' },
  camino: { label: 'Camino', color: 'var(--color-camino)' },
  general: { label: 'General', color: 'var(--color-ai)' },
};

export function KnowledgeScoreWidget() {
  const [scores, setScores] = useState<MeConocesScore[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getMeConocesScores().then(s => {
      setScores(s);
      setLoading(false);
    });
  }, []);

  if (loading || scores.length === 0) return null;

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.4 }}
    >
      <div
        className="rounded-[20px] p-5"
        style={{
          background: 'var(--color-surface-1)',
          border: '1px solid var(--color-border)',
        }}
      >
        <div className="flex items-center gap-2 mb-4">
          <Trophy className="w-4 h-4" style={{ color: 'var(--color-camino)' }} />
          <p className="text-[11px] font-bold uppercase tracking-[0.16em]" style={{ color: 'var(--color-text-tertiary)' }}>
            ¿Cuánto se conocen?
          </p>
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
      </div>
    </motion.div>
  );
}
