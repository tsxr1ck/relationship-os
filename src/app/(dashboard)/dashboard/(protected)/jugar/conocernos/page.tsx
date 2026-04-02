'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { MessageCircle, Clock, Check, Eye, ArrowRight, ChevronRight } from 'lucide-react';
import { AppShell } from '@/components/layout/AppShell';
import { getOrCreateDailyQuestion, getConocenosHistory, type ConocenosDaily, type ConocenosHistoryItem } from './actions';

const DIMENSION_COLORS: Record<string, string> = {
  conexion: 'var(--color-conexion)',
  cuidado: 'var(--color-cuidado)',
  choque: 'var(--color-choque)',
  camino: 'var(--color-camino)',
  general: 'var(--color-ai)',
};

export default function ConocenosPage() {
  const router = useRouter();
  const [daily, setDaily] = useState<ConocenosDaily | null>(null);
  const [history, setHistory] = useState<ConocenosHistoryItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      getOrCreateDailyQuestion(),
      getConocenosHistory(0),
    ]).then(([d, h]) => {
      setDaily(d);
      setHistory(h);
    }).finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="w-8 h-8 rounded-full border-2 border-t-transparent animate-spin"
            style={{ borderColor: 'var(--color-conexion)', borderTopColor: 'transparent' }} />
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell>
      <div className="max-w-lg mx-auto lg:max-w-2xl pb-10">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-6"
        >
          <h1 className="font-display text-3xl mb-1" style={{ color: 'var(--color-text-primary)' }}>
            Conocernos
          </h1>
          <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
            Una pregunta al día. Sin prisa, sin puntaje.
          </p>
        </motion.div>

        {/* Today's Question Card */}
        {daily && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className="mb-8"
          >
            <TodayCard daily={daily} router={router} />
          </motion.div>
        )}

        {!daily && (
          <div
            className="rounded-[20px] p-8 text-center mb-8"
            style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
          >
            <MessageCircle className="h-10 w-10 mx-auto mb-3 opacity-30" style={{ color: 'var(--color-text-secondary)' }} />
            <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
              Necesitan estar vinculados como pareja para jugar Conocernos.
            </p>
          </div>
        )}

        {/* Past Questions */}
        {history.length > 0 && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.2 }}
          >
            <p
              className="text-[11px] font-bold uppercase tracking-[0.16em] mb-3 px-1"
              style={{ color: 'var(--color-text-tertiary)' }}
            >
              Preguntas anteriores
            </p>
            <div className="space-y-3">
              {history.map((item, idx) => (
                <motion.div
                  key={item.id}
                  initial={{ opacity: 0, y: 8 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.25 + idx * 0.05 }}
                >
                  <div
                    className="rounded-2xl p-4 cursor-pointer transition-all hover:scale-[1.01]"
                    style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
                    onClick={() => router.push(`/dashboard/jugar/conocernos/${item.id}/reveal`)}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium mb-1 line-clamp-2" style={{ color: 'var(--color-text-primary)' }}>
                          {item.questionText}
                        </p>
                        <p className="text-[11px]" style={{ color: 'var(--color-text-tertiary)' }}>
                          {new Date(item.questionDate).toLocaleDateString('es-MX', { day: 'numeric', month: 'short' })}
                        </p>
                      </div>
                      <div
                        className="w-2 h-2 rounded-full shrink-0 mt-2"
                        style={{ background: DIMENSION_COLORS[item.dimension] || 'var(--color-ai)' }}
                      />
                    </div>
                  </div>
                </motion.div>
              ))}
            </div>
          </motion.div>
        )}
      </div>
    </AppShell>
  );
}

/* ── Today's Question Card ── */
function TodayCard({ daily, router }: { daily: ConocenosDaily; router: any }) {
  const dimColor = DIMENSION_COLORS[daily.dimension] || 'var(--color-ai)';

  // State: Not answered yet
  if (!daily.hasAnswered) {
    return (
      <div
        className="rounded-[24px] p-7 relative overflow-hidden cursor-pointer group transition-all hover:scale-[1.01]"
        style={{
          background: `linear-gradient(145deg, var(--color-conexion-dim) 0%, var(--color-surface-1) 100%)`,
          border: '1px solid var(--color-border)',
        }}
        onClick={() => router.push(`/dashboard/jugar/conocernos/${daily.id}/answer`)}
      >
        <div className="flex items-center gap-2 mb-4">
          <MessageCircle className="h-4 w-4" style={{ color: 'var(--color-conexion)' }} />
          <span className="text-[11px] font-bold uppercase tracking-[0.16em]" style={{ color: 'var(--color-conexion)' }}>
            Pregunta del día
          </span>
        </div>

        <p className="font-display text-xl md:text-2xl leading-snug mb-6" style={{ color: 'var(--color-text-primary)' }}>
          {daily.questionText}
        </p>

        <button
          className="px-6 py-3 rounded-2xl text-sm font-bold flex items-center gap-2 transition-all active:scale-95"
          style={{ background: 'var(--color-conexion)', color: 'var(--color-base)' }}
        >
          Responder <ArrowRight className="h-4 w-4" />
        </button>
      </div>
    );
  }

  // State: Answered but not revealed
  if (!daily.isRevealed) {
    return (
      <div
        className="rounded-[24px] p-7 relative overflow-hidden"
        style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
      >
        <div className="flex items-center gap-2 mb-4">
          <Check className="h-4 w-4" style={{ color: 'var(--color-success-warm)' }} />
          <span className="text-[11px] font-bold uppercase tracking-[0.16em]" style={{ color: 'var(--color-success-warm)' }}>
            Respuesta guardada
          </span>
        </div>

        <p className="font-display text-lg mb-3 italic opacity-80" style={{ color: 'var(--color-text-primary)' }}>
          &ldquo;{daily.questionText}&rdquo;
        </p>

        <p className="text-sm mb-4" style={{ color: 'var(--color-text-secondary)' }}>
          {daily.partnerHasAnswered
            ? 'Ambos respondieron. Las respuestas se revelan pronto.'
            : 'Tu pareja aún no ha respondido.'}
        </p>

        <div className="flex items-center gap-2 text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
          <Clock className="h-3.5 w-3.5" />
          <span>
            Revelación: {new Date(daily.revealAt).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })}
          </span>
        </div>
      </div>
    );
  }

  // State: Revealed
  return (
    <div
      className="rounded-[24px] p-7 relative overflow-hidden cursor-pointer transition-all hover:scale-[1.01]"
      style={{
        background: `linear-gradient(145deg, var(--color-memory-tint) 0%, var(--color-surface-1) 100%)`,
        border: '1px solid var(--color-border)',
      }}
      onClick={() => router.push(`/dashboard/jugar/conocernos/${daily.id}/reveal`)}
    >
      <div className="flex items-center gap-2 mb-4">
        <Eye className="h-4 w-4" style={{ color: 'var(--color-accent-rose)' }} />
        <span className="text-[11px] font-bold uppercase tracking-[0.16em]" style={{ color: 'var(--color-accent-rose)' }}>
          Revelado
        </span>
      </div>

      <p className="font-display text-lg mb-4 italic" style={{ color: 'var(--color-text-primary)' }}>
        &ldquo;{daily.questionText}&rdquo;
      </p>

      <span className="text-sm font-medium flex items-center gap-1" style={{ color: 'var(--color-accent-rose)' }}>
        Ver respuestas <ChevronRight className="h-4 w-4" />
      </span>
    </div>
  );
}
