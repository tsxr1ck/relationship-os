'use client';

import { useState, useEffect, useRef, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { saveRoundResult, finishGameSession, type SintoniaDilemma, type SintoniaRoundResult } from '@/app/(dashboard)/dashboard/(protected)/jugar/sintonia/actions';

export type GamePhase = 'lobby' | 'countdown' | 'reading' | 'voting' | 'reveal' | 'finished';

export interface RoundState {
  dilemma: SintoniaDilemma;
  phase: GamePhase;
  timeLeft: number;
  myVote: string | null;
  partnerVoted: boolean;
  userAVote: string | null;
  userBVote: string | null;
  isMatch: boolean | null;
}

export interface UseSintoniaGameReturn {
  phase: GamePhase;
  currentRound: number;
  totalRounds: number;
  timeLeft: number;
  myVote: string | null;
  partnerVoted: boolean;
  partnerConnected: boolean;
  currentDilemma: SintoniaDilemma | null;
  userAVote: string | null;
  userBVote: string | null;
  isMatch: boolean | null;
  roundResults: RoundState[];
  castVote: (vote: 'A' | 'B') => void;
  startGame: () => void;
}

const READING_TIME = 3;
const VOTING_TIME = 10;
const REVEAL_TIME = 3;
const COUNTDOWN_TIME = 3;

export function useSintoniaGame(
  gameId: string,
  userId: string,
  partnerId: string,
  dilemmas: SintoniaDilemma[]
): UseSintoniaGameReturn {
  const [phase, setPhase] = useState<GamePhase>('lobby');
  const [currentRound, setCurrentRound] = useState(0);
  const [timeLeft, setTimeLeft] = useState(0);
  const [myVote, setMyVote] = useState<string | null>(null);
  const [partnerVoted, setPartnerVoted] = useState(false);
  const [partnerConnected, setPartnerConnected] = useState(false);
  const [currentDilemma, setCurrentDilemma] = useState<SintoniaDilemma | null>(null);
  const [userAVote, setUserAVote] = useState<string | null>(null);
  const [userBVote, setUserBVote] = useState<string | null>(null);
  const [isMatch, setIsMatch] = useState<boolean | null>(null);
  const [roundResults, setRoundResults] = useState<RoundState[]>([]);

  const channelRef = useRef<ReturnType<typeof createClient>['channel'] | null>(null);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  const isHostRef = useRef(false);
  const roundResultsRef = useRef<RoundState[]>([]);

  const supabase = createClient();

  const clearTimer = useCallback(() => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }
  }, []);

  const startTimer = useCallback((seconds: number, onTick: (t: number) => void, onComplete: () => void) => {
    clearTimer();
    setTimeLeft(seconds);
    onTick(seconds);
    let remaining = seconds;
    timerRef.current = setInterval(() => {
      remaining--;
      setTimeLeft(remaining);
      onTick(remaining);
      if (remaining <= 0) {
        clearTimer();
        onComplete();
      }
    }, 1000);
  }, [clearTimer]);

  const saveCurrentRound = useCallback(async (voteA: string | null, voteB: string | null) => {
    const dilemma = dilemmas[currentRound];
    if (!dilemma) return;

    const aVote = userId < partnerId ? voteA : voteB;
    const bVote = userId < partnerId ? voteB : voteA;
    const aId = userId < partnerId ? userId : partnerId;
    const bId = userId < partnerId ? partnerId : userId;

    await saveRoundResult(gameId, currentRound + 1, dilemma.id, aId, bId, aVote, bVote);

    const match = aVote !== null && bVote !== null && aVote === bVote;

    const result: RoundState = {
      dilemma,
      phase: 'reveal',
      timeLeft: 0,
      myVote: userId < partnerId ? voteA : voteB,
      partnerVoted: true,
      userAVote: aVote,
      userBVote: bVote,
      isMatch: match,
    };

    const newResults = [...roundResultsRef.current, result];
    roundResultsRef.current = newResults;
    setRoundResults(newResults);
  }, [gameId, currentRound, dilemmas, userId, partnerId]);

  const proceedToNextRound = useCallback(() => {
    if (currentRound + 1 >= dilemmas.length) {
      setPhase('finished');
      finishGameSession(gameId);
      return;
    }

    setCurrentRound(prev => prev + 1);
    setMyVote(null);
    setPartnerVoted(false);
    setUserAVote(null);
    setUserBVote(null);
    setIsMatch(null);
    setPhase('countdown');
  }, [currentRound, dilemmas.length, gameId]);

  const handleRevealComplete = useCallback(() => {
    proceedToNextRound();
  }, [proceedToNextRound]);

  const handleVotingComplete = useCallback(async () => {
    const voteA = userId < partnerId ? myVote : (partnerVoted ? (userId < partnerId ? null : myVote) : null);
    const voteB = userId < partnerId ? (partnerVoted ? myVote : null) : myVote;

    await saveCurrentRound(
      userId < partnerId ? myVote : null,
      userId < partnerId ? null : myVote
    );

    const aVote = userId < partnerId ? myVote : null;
    const bVote = userId < partnerId ? null : myVote;
    setUserAVote(aVote);
    setUserBVote(bVote);
    setIsMatch(aVote !== null && bVote !== null && aVote === bVote);

    setPhase('reveal');
    startTimer(REVEAL_TIME, () => {}, handleRevealComplete);
  }, [myVote, partnerVoted, userId, partnerId, saveCurrentRound, handleRevealComplete, startTimer]);

  const handleVoteCast = useCallback((data: any) => {
    if (data.userId !== userId) {
      setPartnerVoted(true);
      if (myVote) {
        handleVotingComplete();
      }
    }
  }, [userId, myVote, handleVotingComplete]);

  const startRound = useCallback(() => {
    const dilemma = dilemmas[currentRound];
    if (!dilemma) return;

    setCurrentDilemma(dilemma);
    setPhase('reading');
    startTimer(READING_TIME, () => {}, () => {
      setPhase('voting');
      startTimer(VOTING_TIME, () => {}, handleVotingComplete);
    });
  }, [currentRound, dilemmas, startTimer, handleVotingComplete]);

  const startGame = useCallback(() => {
    isHostRef.current = true;
    setPhase('countdown');
    startTimer(COUNTDOWN_TIME, () => {}, startRound);
  }, [startTimer, startRound]);

  useEffect(() => {
    const channelName = `sintonia_${gameId}`;
    const channel = supabase.channel(channelName);

    channel
      .on('broadcast', { event: 'player_joined' }, () => {
        setPartnerConnected(true);
        if (isHostRef.current && !partnerConnected) {
          startGame();
        }
      })
      .on('broadcast', { event: 'vote_cast' }, handleVoteCast)
      .on('broadcast', { event: 'start_round' }, () => {
        if (!isHostRef.current) {
          startRound();
        }
      })
      .on('broadcast', { event: 'phase_change' }, (data: any) => {
        if (!isHostRef.current) {
          setPhase(data.phase);
          if (data.phase === 'reveal') {
            setUserAVote(data.userAVote);
            setUserBVote(data.userBVote);
            setIsMatch(data.isMatch);
            startTimer(REVEAL_TIME, () => {}, handleRevealComplete);
          }
        }
      })
      .subscribe();

    channelRef.current = channel;

    channel.send({
      type: 'broadcast',
      event: 'player_joined',
      payload: { userId },
    });

    return () => {
      clearTimer();
      supabase.removeChannel(channel);
    };
  }, [gameId, userId, partnerConnected, startGame, startRound, handleVoteCast, handleRevealComplete, startTimer, clearTimer, supabase]);

  const castVote = useCallback((vote: 'A' | 'B') => {
    if (phase !== 'voting' || myVote) return;

    setMyVote(vote);

    if (channelRef.current) {
      channelRef.current.send({
        type: 'broadcast',
        event: 'vote_cast',
        payload: { userId, vote },
      });
    }

    if (partnerVoted) {
      handleVotingComplete();
    }
  }, [phase, myVote, partnerVoted, userId, handleVotingComplete]);

  return {
    phase,
    currentRound: currentRound + 1,
    totalRounds: dilemmas.length,
    timeLeft,
    myVote,
    partnerVoted,
    partnerConnected,
    currentDilemma,
    userAVote,
    userBVote,
    isMatch,
    roundResults,
    castVote,
    startGame,
  };
}
