'use client';

import { useState, useEffect, useCallback, useRef, use } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { motion } from 'framer-motion';
import { ArrowLeft, Users, Check, X, Loader2, Trophy } from 'lucide-react';
import { useAuth } from '@/lib/supabase/hooks';
import { createClient } from '@/lib/supabase/client';
import {
  finishGameSession,
  saveRoundResult,
  getGameDetails,
  getActiveGame,
  type SintoniaDilemma,
  type SintoniaGameHistory,
} from '../actions';

type GamePhase =
  | 'loading'
  | 'lobby'
  | 'ready'
  | 'countdown'
  | 'reading'
  | 'voting'
  | 'reveal'
  | 'finished';

const READING_TIME = 3;
const VOTING_TIME = 10;
const REVEAL_TIME = 4;
const COUNTDOWN_TIME = 3;

export default function SintoniaGamePage({ params }: { params: Promise<{ gameId: string }> }) {
  const { gameId } = use(params);
  const router = useRouter();
  const { user } = useAuth();
  
  const supabaseRef = useRef<ReturnType<typeof createClient> | null>(null);
  if (!supabaseRef.current) {
    supabaseRef.current = createClient();
  }

  // Stable refs for mutable state
  const phaseRef = useRef<GamePhase>('loading');
  const roundRef = useRef(0);
  const myVoteRef = useRef<'A' | 'B' | null>(null);
  const partnerVoteRef = useRef<'A' | 'B' | null>(null);
  const myReadyRef = useRef(false);
  const partnerReadyRef = useRef(false);
  const partnerConnectedRef = useRef(false);
  const dilemmasRef = useRef<SintoniaDilemma[]>([]);
  const channelRef = useRef<ReturnType<typeof createClient>['channel'] | null>(null);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  const finishingRoundRef = useRef(false);

  // React state for rendering
  const [phase, setPhase] = useState<GamePhase>('loading');
  const [dilemmas, setDilemmas] = useState<SintoniaDilemma[]>([]);
  const [currentRound, setCurrentRound] = useState(0);
  const [timeLeft, setTimeLeft] = useState(0);
  const [myVote, setMyVote] = useState<'A' | 'B' | null>(null);
  const [partnerConnected, setPartnerConnected] = useState(false);
  const [myReady, setMyReady] = useState(false);
  const [partnerReady, setPartnerReady] = useState(false);
  const [revealData, setRevealData] = useState<{ a: string | null; b: string | null; match: boolean } | null>(null);
  const [roundResults, setRoundResults] = useState<any[]>([]);
  const [gameHistory, setGameHistory] = useState<SintoniaGameHistory | null>(null);

  const clearTimer = useCallback(() => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }
  }, []);

  const setPhaseSafe = useCallback((p: GamePhase) => {
    phaseRef.current = p;
    setPhase(p);
  }, []);

  const broadcast = useCallback((event: string, payload: any) => {
    if (!channelRef.current) return;

    channelRef.current.send({
      type: 'broadcast',
      event,
      payload,
    });
  }, []);

  const markPartnerConnected = useCallback(() => {
    if (!partnerConnectedRef.current) {
      partnerConnectedRef.current = true;
      setPartnerConnected(true);
    }

    if (phaseRef.current === 'lobby') {
      setPhaseSafe('ready');
    }
  }, [setPhaseSafe]);

  const markPartnerDisconnected = useCallback(() => {
    partnerConnectedRef.current = false;
    setPartnerConnected(false);

    if (phaseRef.current === 'lobby' || phaseRef.current === 'ready') {
      partnerReadyRef.current = false;
      myReadyRef.current = false;
      setPartnerReady(false);
      setMyReady(false);
      setPhaseSafe('lobby');
    }
  }, [setPhaseSafe]);

  const startTimer = useCallback(
    (seconds: number, onComplete: () => void) => {
      clearTimer();
      setTimeLeft(seconds);

      let remaining = seconds;
      timerRef.current = setInterval(() => {
        remaining -= 1;
        setTimeLeft(remaining);

        if (remaining <= 0) {
          clearTimer();
          onComplete();
        }
      }, 1000);
    },
    [clearTimer]
  );

  const advanceRound = useCallback(() => {
    const nextRound = roundRef.current + 1;

    if (nextRound >= dilemmasRef.current.length) {
      setPhaseSafe('finished');
      finishGameSession(gameId);
      setTimeout(() => {
        getGameDetails(gameId).then((h) => setGameHistory(h));
      }, 500);
      return;
    }

    roundRef.current = nextRound;
    myVoteRef.current = null;
    partnerVoteRef.current = null;
    finishingRoundRef.current = false;

    setMyVote(null);
    setRevealData(null);
    setCurrentRound(nextRound);

    broadcast('start_round', { round: nextRound });
    setPhaseSafe('countdown');
    startTimer(COUNTDOWN_TIME, () => {
      setPhaseSafe('reading');
      startTimer(READING_TIME, () => {
        setPhaseSafe('voting');
        startTimer(VOTING_TIME, () => {
          handleVotingComplete();
        });
      });
    });
  }, [gameId, broadcast, setPhaseSafe, startTimer]);

  const handleVotingComplete = useCallback(async () => {
    if (finishingRoundRef.current) return;
    finishingRoundRef.current = true;

    const dilemma = dilemmasRef.current[roundRef.current];
    if (!user || !dilemma) return;

    const voteA = myVoteRef.current;
    const voteB = partnerVoteRef.current;
    const match = voteA !== null && voteB !== null && voteA === voteB;

    await saveRoundResult(gameId, roundRef.current + 1, dilemma.id, user.id, user.id, voteA, voteB);

    setRevealData({ a: voteA, b: voteB, match });
    setRoundResults((prev) => [
      ...prev,
      {
        dilemma,
        userAVote: voteA,
        userBVote: voteB,
        isMatch: match,
        roundNumber: roundRef.current + 1,
      },
    ]);

    setPhaseSafe('reveal');
    startTimer(REVEAL_TIME, advanceRound);
  }, [user, gameId, setPhaseSafe, startTimer, advanceRound]);

  const startGameSequence = useCallback(() => {
    clearTimer();
    finishingRoundRef.current = false;

    setPhaseSafe('countdown');
    startTimer(COUNTDOWN_TIME, () => {
      setPhaseSafe('reading');
      startTimer(READING_TIME, () => {
        setPhaseSafe('voting');
        startTimer(VOTING_TIME, () => {
          handleVotingComplete();
        });
      });
    });
  }, [clearTimer, setPhaseSafe, startTimer, handleVotingComplete]);

  const castReady = useCallback(() => {
    if (phaseRef.current !== 'ready' || myReadyRef.current) return;

    myReadyRef.current = true;
    setMyReady(true);

    broadcast('player_ready', { userId: user?.id });

    if (partnerReadyRef.current) {
      startGameSequence();
    }
  }, [user, broadcast, startGameSequence]);

  const castVote = useCallback(
    (vote: 'A' | 'B') => {
      if (phaseRef.current !== 'voting' || myVoteRef.current) return;

      myVoteRef.current = vote;
      setMyVote(vote);

      broadcast('vote_cast', { userId: user?.id, vote });

      if (partnerVoteRef.current) {
        handleVotingComplete();
      }
    },
    [user, broadcast, handleVotingComplete]
  );

  // Load game data
  useEffect(() => {
    async function load() {
      const active = await getActiveGame();

      if (!active) {
        router.push('/dashboard/jugar/sintonia');
        return;
      }

      setDilemmas(active.dilemmas);
      dilemmasRef.current = active.dilemmas;
      setPhaseSafe(partnerConnectedRef.current ? 'ready' : 'lobby');
    }

    load();
  }, [gameId, router, setPhaseSafe]);

  // Setup realtime channel
  useEffect(() => {
    if (!user) return;

    const supabase = supabaseRef.current;
    const channelName = `sintonia_${gameId}`;
    const channel = supabase.channel(channelName, {
      config: {
        presence: {
          key: user.id,
        },
      },
    });

    channel
      .on('presence', { event: 'sync' }, () => {
        const state = channel.presenceState();
        const otherUsers = Object.keys(state).filter((key) => key !== user.id);

        if (otherUsers.length > 0) {
          markPartnerConnected();
          // Bulletproof fallback: manually ping back in case the remote client missed our presence!
          if (phaseRef.current === 'lobby' || phaseRef.current === 'ready') {
            channel.send({
              type: 'broadcast',
              event: 'presence_ack',
              payload: { userId: user.id }
            });
          }
        } else {
          markPartnerDisconnected();
        }
      })
      .on('broadcast', { event: 'presence_ack' }, (data: any) => {
        if (data.payload?.userId !== user.id) {
          markPartnerConnected();
        }
      })
      .on('broadcast', { event: 'player_ready' }, (data: any) => {
        if (data.payload?.userId === user.id) return;

        partnerReadyRef.current = true;
        setPartnerReady(true);

        if (myReadyRef.current && phaseRef.current === 'ready') {
          startGameSequence();
        }
      })
      .on('broadcast', { event: 'vote_cast' }, (data: any) => {
        if (data.payload?.userId === user.id) return;

        partnerVoteRef.current = data.payload?.vote ?? null;

        if (myVoteRef.current && phaseRef.current === 'voting') {
          handleVotingComplete();
        }
      })
      .on('broadcast', { event: 'start_round' }, (data: any) => {
        const incomingRound =
          typeof data.payload?.round === 'number' ? data.payload.round : roundRef.current;

        roundRef.current = incomingRound;
        setCurrentRound(incomingRound);
        myVoteRef.current = null;
        partnerVoteRef.current = null;
        finishingRoundRef.current = false;
        setMyVote(null);
        setRevealData(null);

        startGameSequence();
      })
      .subscribe(async (status: string) => {
        if (status === 'SUBSCRIBED') {
          await channel.track({
            userId: user.id,
            onlineAt: new Date().toISOString(),
          });
        }
      });

    channelRef.current = channel;

    return () => {
      // Don't clear timer here because removing channel shouldn't cancel active timers
      supabase.removeChannel(channel);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gameId, user?.id]);

  const currentDilemma = dilemmas[currentRound];

  if (phase === 'loading') {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[70vh]">
          <Loader2 className="h-10 w-10 animate-spin" style={{ color: 'var(--color-choque)' }} />
        </div>
      </AppShell>
    );
  }

  if (phase === 'finished' && gameHistory) {
    return (
      <AppShell showNav={false}>
        <div className="max-w-lg mx-auto px-4 py-6 space-y-6">
          <div className="flex items-center gap-3">
            <button
              onClick={() => router.push('/dashboard/jugar/sintonia')}
              className="p-2 rounded-xl transition-colors hover:bg-surface-3"
              style={{ color: 'var(--color-text-secondary)' }}
            >
              <ArrowLeft className="w-5 h-5" />
            </button>
            <h1 className="font-display text-xl" style={{ color: 'var(--color-text-primary)' }}>
              Resultado Final
            </h1>
          </div>

          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="rounded-2xl p-6 text-center"
            style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
          >
            <Trophy className="w-12 h-12 mx-auto mb-3" style={{ color: 'var(--color-camino)' }} />
            <p className="text-4xl font-bold mb-1" style={{ color: 'var(--color-text-primary)' }}>
              {gameHistory.game.scorePct}%
            </p>
            <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>Sintonía</p>
            <div
              className="w-full h-3 rounded-full overflow-hidden mt-4"
              style={{ background: 'var(--color-surface-3)' }}
            >
              <motion.div
                className="h-full rounded-full"
                style={{
                  background:
                    (gameHistory.game.scorePct || 0) >= 80
                      ? 'var(--color-success)'
                      : (gameHistory.game.scorePct || 0) >= 50
                        ? 'var(--color-warning)'
                        : 'var(--color-choque)',
                }}
                initial={{ width: 0 }}
                animate={{ width: `${gameHistory.game.scorePct}%` }}
                transition={{ duration: 1, delay: 0.3 }}
              />
            </div>
            <p className="text-xs mt-2" style={{ color: 'var(--color-text-tertiary)' }}>
              {gameHistory.game.matchCount}/{gameHistory.game.totalRounds} coincidencias
            </p>
          </motion.div>

          <div className="space-y-3">
            {roundResults.map((r, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 12 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.1 }}
                className="rounded-2xl p-4"
                style={{
                  background: 'var(--color-surface-1)',
                  border: `1px solid ${r.isMatch ? 'var(--color-success)' : 'var(--color-border)'}`,
                }}
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-xs font-medium" style={{ color: 'var(--color-text-tertiary)' }}>
                    Ronda {r.roundNumber}
                  </span>
                  {r.isMatch ? (
                    <Check className="w-4 h-4" style={{ color: 'var(--color-success)' }} />
                  ) : (
                    <X className="w-4 h-4" style={{ color: 'var(--color-choque)' }} />
                  )}
                </div>
                <p className="text-sm mb-2" style={{ color: 'var(--color-text-primary)' }}>
                  {r.dilemma.scenario}
                </p>
                <div className="flex items-center gap-2 text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                  <span>Tú: {r.userAVote || '—'}</span>
                  <span>·</span>
                  <span>Pareja: {r.userBVote || '—'}</span>
                </div>
              </motion.div>
            ))}
          </div>

          <button
            onClick={() => router.push('/dashboard/jugar/sintonia')}
            className="w-full py-3.5 rounded-xl text-sm font-semibold transition-all"
            style={{ background: 'var(--color-choque)', color: 'var(--color-base)' }}
          >
            Jugar de nuevo
          </button>
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell showNav={false}>
      <div className="max-w-lg mx-auto px-4 py-6 space-y-6">
        <div className="flex items-center justify-between">
          <button
            onClick={() => router.push('/dashboard/jugar/sintonia')}
            className="p-2 rounded-xl transition-colors hover:bg-surface-3"
            style={{ color: 'var(--color-text-secondary)' }}
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div className="flex items-center gap-2">
            <span className="text-xs font-medium" style={{ color: 'var(--color-text-tertiary)' }}>
              Ronda {currentRound + 1}/{dilemmas.length}
            </span>
            {phase === 'voting' && (
              <div className="w-24 h-2 rounded-full overflow-hidden" style={{ background: 'var(--color-surface-3)' }}>
                <motion.div
                  className="h-full rounded-full"
                  style={{
                    background:
                      timeLeft > 5
                        ? 'var(--color-success)'
                        : timeLeft > 2
                          ? 'var(--color-warning)'
                          : 'var(--color-choque)',
                  }}
                  initial={{ width: '100%' }}
                  animate={{ width: `${(timeLeft / VOTING_TIME) * 100}%` }}
                  transition={{ duration: 1, ease: 'linear' }}
                />
              </div>
            )}
          </div>
        </div>

        {phase === 'lobby' && (
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="rounded-2xl p-8 text-center"
            style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
          >
            <div
              className="w-16 h-16 rounded-full mx-auto mb-4 flex items-center justify-center"
              style={{ background: 'var(--color-choque)' }}
            >
              <Users className="w-8 h-8" style={{ color: 'var(--color-base)' }} />
            </div>
            <h2 className="text-xl font-semibold mb-2" style={{ color: 'var(--color-text-primary)' }}>
              Esperando a tu pareja...
            </h2>
            <p className="text-sm" style={{ color: 'var(--color-text-tertiary)' }}>
              Ambos deben estar conectados para empezar
            </p>
            <div className="flex items-center justify-center gap-2 mt-4">
              <div className="w-2 h-2 rounded-full animate-pulse" style={{ background: 'var(--color-choque)' }} />
              <span className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                {partnerConnected ? 'Conectado' : 'Conectando...'}
              </span>
            </div>
          </motion.div>
        )}

        {phase === 'ready' && (
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="rounded-2xl p-8 text-center"
            style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
          >
            <div
              className="w-16 h-16 rounded-full mx-auto mb-4 flex items-center justify-center"
              style={{ background: 'var(--color-success)' }}
            >
              <Users className="w-8 h-8" style={{ color: 'var(--color-base)' }} />
            </div>
            <h2 className="text-xl font-semibold mb-2" style={{ color: 'var(--color-text-primary)' }}>
              Tu pareja se ha conectado
            </h2>
            <p className="text-sm mb-6" style={{ color: 'var(--color-text-tertiary)' }}>
              Avisen cuando estén listos para el primer dilema.
            </p>

            <div className="flex items-center justify-between gap-4 mb-6">
              <div
                className="flex-1 rounded-xl p-3"
                style={{ background: myReady ? 'var(--color-success)' : 'var(--color-surface-2)' }}
              >
                <p
                  className="text-xs font-semibold"
                  style={{ color: myReady ? 'var(--color-base)' : 'var(--color-text-primary)' }}
                >
                  Tú
                </p>
                <p
                  className="text-xs"
                  style={{ color: myReady ? 'var(--color-base)' : 'var(--color-text-tertiary)' }}
                >
                  {myReady ? '¡Listo!' : 'Esperando...'}
                </p>
              </div>
              <div
                className="flex-1 rounded-xl p-3"
                style={{ background: partnerReady ? 'var(--color-success)' : 'var(--color-surface-2)' }}
              >
                <p
                  className="text-xs font-semibold"
                  style={{ color: partnerReady ? 'var(--color-base)' : 'var(--color-text-primary)' }}
                >
                  Tu pareja
                </p>
                <p
                  className="text-xs"
                  style={{ color: partnerReady ? 'var(--color-base)' : 'var(--color-text-tertiary)' }}
                >
                  {partnerReady ? '¡Listo!' : 'Esperando...'}
                </p>
              </div>
            </div>

            <button
              onClick={castReady}
              disabled={myReady}
              className="w-full py-4 rounded-xl font-bold transition-all disabled:opacity-50"
              style={{
                background: myReady ? 'var(--color-surface-3)' : 'var(--color-conexion)',
                color: myReady ? 'var(--color-text-tertiary)' : 'var(--color-base)',
              }}
            >
              {myReady ? 'Esperando a tu pareja...' : '¡Estoy List@!'}
            </button>
          </motion.div>
        )}

        {phase === 'countdown' && (
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="rounded-2xl p-12 text-center"
            style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
          >
            <motion.p
              key={timeLeft}
              initial={{ scale: 1.5, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              className="text-6xl font-bold"
              style={{ color: 'var(--color-choque)' }}
            >
              {timeLeft}
            </motion.p>
          </motion.div>
        )}

        {phase === 'reading' && currentDilemma && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="rounded-2xl p-6 text-center"
            style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
          >
            <p className="text-xs font-bold uppercase tracking-widest mb-4" style={{ color: 'var(--color-text-tertiary)' }}>
              Lee el dilema...
            </p>
            <h2 className="text-xl font-semibold mb-6" style={{ color: 'var(--color-text-primary)' }}>
              {currentDilemma.scenario}
            </h2>
            <div className="flex items-center justify-center gap-2">
              <Loader2 className="w-4 h-4 animate-spin" style={{ color: 'var(--color-text-tertiary)' }} />
              <span className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                Las opciones aparecen en {timeLeft}s
              </span>
            </div>
          </motion.div>
        )}

        {phase === 'voting' && currentDilemma && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div
              className="rounded-2xl p-5 text-center"
              style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
            >
              <h2 className="text-lg font-semibold mb-1" style={{ color: 'var(--color-text-primary)' }}>
                {currentDilemma.scenario}
              </h2>
              <p className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
                Elige rápido — {timeLeft}s restantes
              </p>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={() => castVote('A')}
                disabled={!!myVote}
                className="py-6 rounded-2xl text-sm font-semibold transition-all disabled:opacity-50"
                style={{
                  background: myVote === 'A' ? 'var(--color-conexion)' : 'var(--color-surface-2)',
                  color: myVote === 'A' ? 'var(--color-base)' : 'var(--color-text-primary)',
                  border: `2px solid ${myVote === 'A' ? 'var(--color-conexion)' : 'var(--color-border)'}`,
                }}
              >
                <span className="text-xs font-bold block mb-1">A</span>
                {currentDilemma.optionA}
              </button>

              <button
                onClick={() => castVote('B')}
                disabled={!!myVote}
                className="py-6 rounded-2xl text-sm font-semibold transition-all disabled:opacity-50"
                style={{
                  background: myVote === 'B' ? 'var(--color-camino)' : 'var(--color-surface-2)',
                  color: myVote === 'B' ? 'var(--color-base)' : 'var(--color-text-primary)',
                  border: `2px solid ${myVote === 'B' ? 'var(--color-camino)' : 'var(--color-border)'}`,
                }}
              >
                <span className="text-xs font-bold block mb-1">B</span>
                {currentDilemma.optionB}
              </button>
            </div>

            {myVote && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="rounded-2xl p-4 text-center"
                style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
              >
                <div className="flex items-center justify-center gap-2">
                  <Loader2 className="w-4 h-4 animate-spin" style={{ color: 'var(--color-text-tertiary)' }} />
                  <span className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
                    Esperando a tu pareja...
                  </span>
                </div>
              </motion.div>
            )}
          </motion.div>
        )}

        {phase === 'reveal' && revealData && currentDilemma && (
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="rounded-2xl p-6 text-center"
            style={{
              background: revealData.match ? 'rgba(127, 163, 106, 0.1)' : 'rgba(207, 107, 107, 0.1)',
              border: `1px solid ${revealData.match ? 'var(--color-success)' : 'var(--color-choque)'}`,
            }}
          >
            {revealData.match ? (
              <>
                <div className="text-4xl mb-3">🤜🤛</div>
                <h2 className="text-xl font-bold mb-1" style={{ color: 'var(--color-success)' }}>
                  ¡Sintonía!
                </h2>
                <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
                  Ambos eligieron lo mismo
                </p>
              </>
            ) : (
              <>
                <div className="text-4xl mb-3">⚡</div>
                <h2 className="text-xl font-bold mb-1" style={{ color: 'var(--color-choque)' }}>
                  Cortocircuito
                </h2>
                <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
                  Eligieron diferente
                </p>
              </>
            )}

            <div className="grid grid-cols-2 gap-4 mt-6">
              <div className="rounded-xl p-3" style={{ background: 'var(--color-surface-2)' }}>
                <p className="text-xs font-medium mb-1" style={{ color: 'var(--color-text-tertiary)' }}>
                  Tú
                </p>
                <p className="text-sm font-semibold" style={{ color: 'var(--color-text-primary)' }}>
                  {revealData.a === 'A' ? currentDilemma.optionA : revealData.a === 'B' ? currentDilemma.optionB : '—'}
                </p>
              </div>
              <div className="rounded-xl p-3" style={{ background: 'var(--color-surface-2)' }}>
                <p className="text-xs font-medium mb-1" style={{ color: 'var(--color-text-tertiary)' }}>
                  Tu pareja
                </p>
                <p className="text-sm font-semibold" style={{ color: 'var(--color-text-primary)' }}>
                  {revealData.b === 'A' ? currentDilemma.optionA : revealData.b === 'B' ? currentDilemma.optionB : '—'}
                </p>
              </div>
            </div>
          </motion.div>
        )}
      </div>
    </AppShell>
  );
}