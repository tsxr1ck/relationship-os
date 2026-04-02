'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { motion } from 'framer-motion';
import { ArrowLeft, Zap, Loader2, History, Play } from 'lucide-react';
import { startGameSession, getActiveGame, getGameHistory } from './actions';
import { formatDistanceToNow } from 'date-fns';
import { es } from 'date-fns/locale';

export default function SintoniaPage() {
  const router = useRouter();
  const [activeGame, setActiveGame] = useState<any>(null);
  const [history, setHistory] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [starting, setStarting] = useState(false);
  const [error, setError] = useState('');
  const [showHistory, setShowHistory] = useState(false);

  useEffect(() => {
    async function load() {
      const [game, hist] = await Promise.all([
        getActiveGame(),
        getGameHistory(),
      ]);
      setActiveGame(game);
      setHistory(hist);
      setLoading(false);
    }
    load();
  }, []);

  const handleStart = async () => {
    setStarting(true);
    setError('');
    const result = await startGameSession();
    setStarting(false);
    if ('error' in result) {
      setError(result.error);
    } else {
      router.push(`/dashboard/jugar/sintonia/${result.gameId}`);
    }
  };

  const handleContinue = () => {
    if (activeGame) {
      router.push(`/dashboard/jugar/sintonia/${activeGame.gameId}`);
    }
  };

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[70vh]">
          <Loader2 className="h-10 w-10 animate-spin" style={{ color: 'var(--color-choque)' }} />
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell>
      <div className="space-y-6 max-w-lg mx-auto pb-12">
        {/* Header */}
        <div className="flex items-center justify-between">
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
                Sintonía
              </h1>
              <p className="text-sm mt-0.5" style={{ color: 'var(--color-text-tertiary)' }}>
                Dilemas en tiempo real
              </p>
            </div>
          </div>
          {history.length > 0 && (
            <button
              onClick={() => setShowHistory(!showHistory)}
              className="p-2 rounded-xl transition-colors hover:bg-surface-3"
              style={{ color: 'var(--color-text-tertiary)' }}
              title="Historial"
            >
              <History className="w-5 h-5" />
            </button>
          )}
        </div>

        {/* Active Game */}
        {activeGame && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            className="rounded-2xl p-5"
            style={{
              background: 'var(--color-surface-1)',
              border: '1px solid var(--color-choque)',
              boxShadow: '0 0 12px rgba(207, 107, 107, 0.15)',
            }}
          >
            <div className="flex items-center gap-3 mb-3">
              <div className="p-2 rounded-full" style={{ background: 'rgba(207, 107, 107, 0.15)' }}>
                <Zap className="w-5 h-5" style={{ color: 'var(--color-choque)' }} />
              </div>
              <div>
                <h3 className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>
                  Partida en curso
                </h3>
                <p className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                  {activeGame.dilemmas.length} dilemas pendientes
                </p>
              </div>
            </div>
            <button
              onClick={handleContinue}
              className="w-full py-2.5 rounded-xl text-sm font-semibold transition-colors"
              style={{
                background: 'var(--color-choque)',
                color: 'var(--color-base)',
              }}
            >
              Continuar partida
            </button>
          </motion.div>
        )}

        {/* Start New Game */}
        {!activeGame && !showHistory && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            className="rounded-2xl p-6 text-center"
            style={{
              background: 'var(--color-surface-1)',
              border: '1px solid var(--color-border)',
            }}
          >
            <div className="w-16 h-16 rounded-full mx-auto mb-4 flex items-center justify-center" style={{ background: 'rgba(207, 107, 107, 0.15)' }}>
              <Zap className="w-8 h-8" style={{ color: 'var(--color-choque)' }} />
            </div>
            <h3 className="text-lg font-semibold mb-2" style={{ color: 'var(--color-text-primary)' }}>
              ¿Están en sintonía?
            </h3>
            <p className="text-sm mb-2" style={{ color: 'var(--color-text-secondary)' }}>
              Conéctense al mismo tiempo y respondan dilemas juntos. Tienen 10 segundos para elegir. Si coinciden, ¡hay sintonía!
            </p>
            <button
              onClick={handleStart}
              disabled={starting}
              className="px-8 py-3 rounded-xl text-sm font-semibold transition-colors disabled:opacity-50 flex items-center gap-2 mx-auto"
              style={{
                background: 'var(--color-choque)',
                color: 'var(--color-base)',
              }}
            >
              <Play className="w-4 h-4" />
              {starting ? 'Creando partida...' : 'Iniciar partida'}
            </button>
            {error && (
              <p className="text-sm mt-3" style={{ color: 'var(--color-danger)' }}>{error}</p>
            )}
          </motion.div>
        )}

        {/* History */}
        {showHistory && !activeGame && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            className="space-y-3"
          >
            {history.map(h => (
              <div
                key={h.game.id}
                className="rounded-2xl p-5"
                style={{
                  background: 'var(--color-surface-1)',
                  border: '1px solid var(--color-border)',
                }}
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-sm font-semibold" style={{ color: 'var(--color-text-primary)' }}>
                    Sintonía del {h.game.scorePct}%
                  </span>
                  <span className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                    {formatDistanceToNow(new Date(h.game.createdAt), { addSuffix: true, locale: es })}
                  </span>
                </div>
                <div className="w-full h-2 rounded-full overflow-hidden mb-3" style={{ background: 'var(--color-surface-3)' }}>
                  <div
                    className="h-full rounded-full"
                    style={{
                      width: `${h.game.scorePct}%`,
                      background: h.game.scorePct >= 80 ? 'var(--color-success)' : h.game.scorePct >= 50 ? 'var(--color-warning)' : 'var(--color-choque)',
                    }}
                  />
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                    {h.game.matchCount}/{h.game.totalRounds} coincidencias
                  </span>
                  <button
                    onClick={() => router.push(`/dashboard/jugar/sintonia/resultado/${h.game.id}`)}
                    className="text-xs font-medium"
                    style={{ color: 'var(--color-choque)' }}
                  >
                    Ver detalle
                  </button>
                </div>
              </div>
            ))}
          </motion.div>
        )}

        {/* How it works */}
        {!activeGame && !showHistory && (
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
                { icon: Zap, text: 'Ambos se conectan al mismo tiempo' },
                { icon: Play, text: 'Aparece un dilema con 2 opciones' },
                { icon: History, text: '10 segundos para elegir — si coinciden, hay sintonía' },
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
        )}
      </div>
    </AppShell>
  );
}
