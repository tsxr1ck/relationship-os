'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { revalidatePath } from 'next/cache';
import { logActivityEvent } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';

const ROUNDS_PER_GAME = 5;

export interface SintoniaDilemma {
  id: string;
  scenario: string;
  optionA: string;
  optionB: string;
  category: string;
}

export interface SintoniaGame {
  id: string;
  totalRounds: number;
  matchCount: number | null;
  scorePct: number | null;
  status: 'playing' | 'finished' | 'abandoned';
  createdAt: string;
  finishedAt: string | null;
}

export interface SintoniaRoundResult {
  id: string;
  roundNumber: number;
  scenario: string;
  optionA: string;
  optionB: string;
  category: string;
  userAVote: string | null;
  userBVote: string | null;
  isMatch: boolean | null;
  userAName: string;
  userBName: string;
}

export interface SintoniaGameHistory {
  game: SintoniaGame;
  rounds: SintoniaRoundResult[];
}

export async function startGameSession(): Promise<{ gameId: string; dilemmas: SintoniaDilemma[] } | { error: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { error: 'No autenticado' };

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return { error: 'No tienes pareja' };

  const { data: existingGame } = await supabase
    .from('sintonia_games')
    .select('id')
    .eq('couple_id', membership.couple_id)
    .eq('status', 'playing')
    .limit(1)
    .single();

  if (existingGame) return { error: 'Ya hay una partida en curso' };

  const { data: dilemmas } = await supabase
    .from('sintonia_dilemmas')
    .select('*')
    .eq('active', true)
    .limit(ROUNDS_PER_GAME * 3);

  if (!dilemmas || dilemmas.length < ROUNDS_PER_GAME) {
    return { error: 'No hay suficientes dilemas disponibles' };
  }

  const shuffled = [...dilemmas].sort(() => Math.random() - 0.5);
  const selected = shuffled.slice(0, ROUNDS_PER_GAME);

  const { data: game, error: gameError } = await supabase
    .from('sintonia_games')
    .insert({
      couple_id: membership.couple_id,
      total_rounds: ROUNDS_PER_GAME,
      status: 'playing',
    })
    .select()
    .single();

  if (gameError || !game) return { error: 'Error al crear la partida' };

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  await logActivityEvent('sintonia.started', 'sintonia_game', game.id, {
    partner_name: profile?.full_name || 'Tu pareja',
  });

  return {
    gameId: game.id,
    dilemmas: selected.map(d => ({
      id: d.id,
      scenario: d.scenario,
      optionA: d.option_a,
      optionB: d.option_b,
      category: d.category,
    })),
  };
}

export async function saveRoundResult(
  gameId: string,
  roundNumber: number,
  dilemmaId: string,
  userAId: string,
  userBId: string,
  userAVote: string | null,
  userBVote: string | null
): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const isMatch = userAVote !== null && userBVote !== null && userAVote === userBVote;

  const { error } = await supabase
    .from('sintonia_game_rounds')
    .insert({
      game_id: gameId,
      dilemma_id: dilemmaId,
      round_number: roundNumber,
      user_a_id: userAId,
      user_b_id: userBId,
      user_a_vote: userAVote,
      user_b_vote: userBVote,
      is_match: isMatch,
    });

  if (error) {
    console.error('Error saving round result:', error);
    return { success: false };
  }

  return { success: true };
}

export async function finishGameSession(gameId: string): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  const admin = createAdminClient();

  const { data: rounds } = await admin
    .from('sintonia_game_rounds')
    .select('is_match')
    .eq('game_id', gameId);

  const matchCount = rounds?.filter(r => r.is_match).length || 0;
  const totalRounds = rounds?.length || 1;
  const scorePct = Math.round((matchCount / totalRounds) * 100);

  const { error } = await supabase
    .from('sintonia_games')
    .update({
      status: 'finished',
      match_count: matchCount,
      score_pct: scorePct,
      finished_at: new Date().toISOString(),
    })
    .eq('id', gameId);

  if (error) {
    console.error('Error finishing game:', error);
    return { success: false };
  }

  if (user) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('full_name')
      .eq('id', user.id)
      .single();

    await logActivityEvent('sintonia.completed', 'sintonia_game', gameId, {
      partner_name: profile?.full_name || 'Tu pareja',
      matchCount,
      scorePct,
    });
  }

  revalidatePath('/dashboard/jugar/sintonia');
  return { success: true };
}

export async function getActiveGame(): Promise<{ gameId: string; dilemmas: SintoniaDilemma[] } | null> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return null;

  const { data: game } = await supabase
    .from('sintonia_games')
    .select('*')
    .eq('couple_id', membership.couple_id)
    .eq('status', 'playing')
    .limit(1)
    .single();

  if (!game) return null;

  const { data: rounds } = await supabase
    .from('sintonia_game_rounds')
    .select('dilemma_id')
    .eq('game_id', game.id);

  const playedDilemmaIds = new Set(rounds?.map(r => r.dilemma_id) || []);
  const remainingRounds = game.total_rounds - (rounds?.length || 0);

  if (remainingRounds <= 0) return null;

  const { data: dilemmas } = await supabase
    .from('sintonia_dilemmas')
    .select('*')
    .eq('active', true)
    .not('id', 'in', `(${[...playedDilemmaIds].map(id => `"${id}"`).join(',')})`)
    .limit(remainingRounds);

  if (!dilemmas || dilemmas.length < remainingRounds) return null;

  return {
    gameId: game.id,
    dilemmas: dilemmas.map(d => ({
      id: d.id,
      scenario: d.scenario,
      optionA: d.option_a,
      optionB: d.option_b,
      category: d.category,
    })),
  };
}

export async function getGameHistory(): Promise<SintoniaGameHistory[]> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return [];

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return [];

  const admin = createAdminClient();

  const { data: games } = await admin
    .from('sintonia_games')
    .select('*')
    .eq('couple_id', membership.couple_id)
    .eq('status', 'finished')
    .order('created_at', { ascending: false })
    .limit(20);

  if (!games || games.length === 0) return [];

  const history: SintoniaGameHistory[] = [];

  for (const game of games) {
    const { data: rounds } = await admin
      .from('sintonia_game_rounds')
      .select(`
        id,
        round_number,
        user_a_vote,
        user_b_vote,
        is_match,
        sintonia_dilemmas(scenario, option_a, option_b, category)
      `)
      .eq('game_id', game.id)
      .order('round_number', { ascending: true });

    const [userAName, userBName] = await Promise.all([
      admin.from('profiles').select('full_name').eq('id', game.created_by).single(),
      admin.from('profiles').select('full_name').eq('id', game.created_by).single(),
    ]);

    history.push({
      game: {
        id: game.id,
        totalRounds: game.total_rounds,
        matchCount: game.match_count,
        scorePct: game.score_pct,
        status: game.status,
        createdAt: game.created_at,
        finishedAt: game.finished_at,
      },
      rounds: (rounds || []).map((r: any) => ({
        id: r.id,
        roundNumber: r.round_number,
        scenario: (r.sintonia_dilemmas as any)?.scenario || '',
        optionA: (r.sintonia_dilemmas as any)?.option_a || '',
        optionB: (r.sintonia_dilemmas as any)?.option_b || '',
        category: (r.sintonia_dilemmas as any)?.category || 'general',
        userAVote: r.user_a_vote,
        userBVote: r.user_b_vote,
        isMatch: r.is_match,
        userAName: userAName.data?.full_name || 'Jugador A',
        userBName: userBName.data?.full_name || 'Jugador B',
      })),
    });
  }

  return history;
}

export async function getGameDetails(gameId: string): Promise<SintoniaGameHistory | null> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return null;

  const admin = createAdminClient();

  const { data: game } = await admin
    .from('sintonia_games')
    .select('*')
    .eq('id', gameId)
    .eq('couple_id', membership.couple_id)
    .single();

  if (!game) return null;

  const { data: rounds } = await admin
    .from('sintonia_game_rounds')
    .select(`
      id,
      round_number,
      user_a_vote,
      user_b_vote,
      is_match,
      sintonia_dilemmas(scenario, option_a, option_b, category)
    `)
    .eq('game_id', game.id)
    .order('round_number', { ascending: true });

  return {
    game: {
      id: game.id,
      totalRounds: game.total_rounds,
      matchCount: game.match_count,
      scorePct: game.score_pct,
      status: game.status,
      createdAt: game.created_at,
      finishedAt: game.finished_at,
    },
    rounds: (rounds || []).map((r: any) => ({
      id: r.id,
      roundNumber: r.round_number,
      scenario: (r.sintonia_dilemmas as any)?.scenario || '',
      optionA: (r.sintonia_dilemmas as any)?.option_a || '',
      optionB: (r.sintonia_dilemmas as any)?.option_b || '',
      category: (r.sintonia_dilemmas as any)?.category || 'general',
      userAVote: r.user_a_vote,
      userBVote: r.user_b_vote,
      isMatch: r.is_match,
      userAName: 'Jugador A',
      userBName: 'Jugador B',
    })),
  };
}
