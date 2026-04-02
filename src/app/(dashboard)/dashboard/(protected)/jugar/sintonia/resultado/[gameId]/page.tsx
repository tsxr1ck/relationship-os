// app/sintonia/resultado/[gameId]/page.tsx
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { generateSintoniaInsight } from "./actions";
import { ShareAction } from "./_components/ShareAction";
import { 
    Sparkles, 
    Heart, 
    Scale, 
    CheckCircle2, 
    Coins, 
    Users, 
    Flame, 
    Target,
    Layers,
    Activity
} from "lucide-react";

type GameRow = {
    id: string;
    couple_id: string;
    total_rounds: number;
    match_count: number | null;
    score_pct: number | null;
    status: "playing" | "finished" | "abandoned";
    created_at: string;
    finished_at: string | null;
    couples: {
        id: string;
        shared_nickname: string | null;
    } | null;
};

type RoundRow = {
    id: string;
    game_id: string;
    dilemma_id: string;
    round_number: number;
    user_a_id: string;
    user_b_id: string;
    user_a_vote: "A" | "B" | null;
    user_b_vote: "A" | "B" | null;
    is_match: boolean | null;
    created_at: string;
    dilemma: {
        id: string;
        scenario: string;
        option_a: string;
        option_b: string;
        category:
        | "moral"
        | "practico"
        | "emocional"
        | "financiero"
        | "social"
        | "aventura"
        | "general";
    } | null;
};

type CoupleMemberRow = {
    user_id: string;
    role: "self" | "partner";
};

type ProfileRow = {
    id: string;
    full_name: string | null;
    nickname: string | null;
    avatar_url: string | null;
};

type RoundView = {
    id: string;
    roundNumber: number;
    scenario: string;
    optionA: string;
    optionB: string;
    category: string;
    userAId: string;
    userBId: string;
    userAVote: "A" | "B" | null;
    userBVote: "A" | "B" | null;
    isMatch: boolean;
};

function normalizeRounds(rows: RoundRow[]): RoundView[] {
    const latest = new Map<string, RoundRow>();

    for (const row of rows) {
        const key = `${row.round_number}:${row.dilemma_id}`;
        const prev = latest.get(key);

        if (!prev) {
            latest.set(key, row);
            continue;
        }

        if (
            new Date(row.created_at).getTime() >= new Date(prev.created_at).getTime()
        ) {
            latest.set(key, row);
        }
    }

    return Array.from(latest.values())
        .sort((a, b) => a.round_number - b.round_number)
        .map((row) => ({
            id: row.id,
            roundNumber: row.round_number,
            scenario: row.dilemma?.scenario ?? "Sin escenario",
            optionA: row.dilemma?.option_a ?? "Opción A",
            optionB: row.dilemma?.option_b ?? "Opción B",
            category: row.dilemma?.category ?? "general",
            userAId: row.user_a_id,
            userBId: row.user_b_id,
            userAVote: row.user_a_vote,
            userBVote: row.user_b_vote,
            isMatch:
                typeof row.is_match === "boolean"
                    ? row.is_match
                    : row.user_a_vote != null &&
                    row.user_b_vote != null &&
                    row.user_a_vote === row.user_b_vote,
        }));
}

function percent(value: number, total: number) {
    if (!total) return 0;
    return Math.round((value / total) * 100);
}

function buildCategoryStats(rounds: RoundView[]) {
    const bucket = new Map<
        string,
        { total: number; matches: number; misses: number }
    >();

    for (const round of rounds) {
        const current = bucket.get(round.category) ?? {
            total: 0,
            matches: 0,
            misses: 0,
        };

        current.total += 1;
        if (round.isMatch) current.matches += 1;
        else current.misses += 1;

        bucket.set(round.category, current);
    }

    const stats = Array.from(bucket.entries()).map(([category, value]) => ({
        category,
        total: value.total,
        matches: value.matches,
        misses: value.misses,
        rate: percent(value.matches, value.total),
    }));

    const bestCategory = [...stats].sort((a, b) => b.rate - a.rate)[0] ?? null;
    const hardestCategory = [...stats].sort((a, b) => a.rate - b.rate)[0] ?? null;

    return { stats, bestCategory, hardestCategory };
}

function getLongestMatchStreak(rounds: RoundView[]) {
    let current = 0;
    let best = 0;

    for (const round of rounds) {
        if (round.isMatch) {
            current += 1;
            best = Math.max(best, current);
        } else {
            current = 0;
        }
    }

    return best;
}

function displayName(profile?: ProfileRow | null, fallback = "Jugador") {
    if (!profile) return fallback;
    return profile.nickname || profile.full_name?.split(" ")[0] || fallback;
}

function selectedOptionLabel(
    vote: "A" | "B" | null,
    optionA: string,
    optionB: string,
) {
    if (vote === "A") return optionA;
    if (vote === "B") return optionB;
    return "Sin responder";
}

// Map generic categories to Warm Intimate Dark '4C' semantics
function categoryMeta(category: string) {
    const map: Record<string, { label: string, color: string, bg: string, ring: string, Icon: any, fill: string }> = {
        moral: { label: "Moral", color: "text-choque", bg: "bg-choque-dim", ring: "ring-choque/30", Icon: Scale, fill: "bg-choque" },
        practico: { label: "Práctico", color: "text-cuidado", bg: "bg-cuidado-dim", ring: "ring-cuidado/30", Icon: CheckCircle2, fill: "bg-cuidado" },
        emocional: { label: "Emocional", color: "text-conexion", bg: "bg-conexion-dim", ring: "ring-conexion/30", Icon: Heart, fill: "bg-conexion" },
        financiero: { label: "Financiero", color: "text-camino", bg: "bg-camino-dim", ring: "ring-camino/30", Icon: Coins, fill: "bg-camino" },
        social: { label: "Social", color: "text-conexion", bg: "bg-conexion-dim", ring: "ring-conexion/30", Icon: Users, fill: "bg-conexion" },
        aventura: { label: "Aventura", color: "text-ai", bg: "bg-ai-dim", ring: "ring-ai/30", Icon: Flame, fill: "bg-ai" },
        general: { label: "General", color: "text-text-secondary", bg: "bg-surface-2", ring: "ring-border", Icon: Target, fill: "bg-text-tertiary" },
    };
    return map[category] ?? map.general;
}

function statusBadgeClasses(isMatch: boolean) {
    return isMatch
        ? "bg-conexion-dim text-conexion ring-conexion/30 animate-pulse-once"
        : "bg-surface-2 text-text-tertiary ring-border";
}

function voteCardClasses(active: boolean) {
    return active
        ? "border-conexion glow-border-conexion bg-conexion-dim/50"
        : "border-border bg-surface-1 text-text-tertiary opacity-60";
}

export default async function SintoniaResultadoPage({
    params,
}: {
    params: Promise<{ gameId: string }>;
}) {
    const { gameId } = await params;
    const supabase = await createClient();

    const { data: game } = await supabase
        .from("sintonia_games")
        .select(`
      id,
      couple_id,
      total_rounds,
      match_count,
      score_pct,
      status,
      created_at,
      finished_at,
      couples!sintonia_games_couple_id_fkey (
        id,
        shared_nickname
      )
    `)
        .eq("id", gameId)
        .maybeSingle<GameRow>();

    if (!game) notFound();

    const [{ data: roundsRaw }, { data: members }] = await Promise.all([
        supabase
            .from("sintonia_game_rounds")
            .select(`
        id,
        game_id,
        dilemma_id,
        round_number,
        user_a_id,
        user_b_id,
        user_a_vote,
        user_b_vote,
        is_match,
        created_at,
        dilemma:sintonia_dilemmas!sintonia_game_rounds_dilemma_id_fkey (
          id,
          scenario,
          option_a,
          option_b,
          category
        )
      `)
            .eq("game_id", gameId)
            .order("round_number", { ascending: true })
            .order("created_at", { ascending: true }),
        supabase
            .from("couple_members")
            .select("user_id, role")
            .eq("couple_id", game.couple_id),
    ]);

    const memberIds = (members ?? []).map((m: CoupleMemberRow) => m.user_id);

    const { data: profiles } = memberIds.length
        ? await supabase
            .from("profiles")
            .select("id, full_name, nickname, avatar_url")
            .in("id", memberIds)
        : { data: [] as ProfileRow[] };

    const profilesById = new Map<string, ProfileRow>((profiles as ProfileRow[] ?? []).map((p) => [p.id, p]));
    const rounds = normalizeRounds((roundsRaw as unknown as RoundRow[]) ?? []);

    const firstRound = rounds[0];
    const userAProfile = firstRound ? profilesById.get(firstRound.userAId) : null;
    const userBProfile = firstRound ? profilesById.get(firstRound.userBId) : null;

    const userAName = displayName(userAProfile, "Jugador A");
    const userBName = displayName(userBProfile, "Jugador B");

    const resolvedMatchCount =
        typeof game.match_count === "number"
            ? game.match_count
            : rounds.filter((r) => r.isMatch).length;

    const resolvedScorePct =
        typeof game.score_pct === "number"
            ? Math.round(Number(game.score_pct))
            : percent(resolvedMatchCount, game.total_rounds || rounds.length);

    const longestMatchStreak = getLongestMatchStreak(rounds);
    const splitCount = rounds.filter((r) => !r.isMatch).length;
    const { stats: categoryStats, bestCategory, hardestCategory } =
        buildCategoryStats(rounds);

    const insight = await generateSintoniaInsight({
        coupleNickname: game.couples?.shared_nickname ?? null,
        scorePct: resolvedScorePct,
        matchCount: resolvedMatchCount,
        totalRounds: game.total_rounds,
        bestCategory: bestCategory?.category ?? null,
        hardestCategory: hardestCategory?.category ?? null,
        longestMatchStreak,
        rounds: rounds.map((r) => ({
            roundNumber: r.roundNumber,
            category: r.category,
            scenario: r.scenario,
            isMatch: r.isMatch,
            userAVote: r.userAVote,
            userBVote: r.userBVote,
        })),
    });

    return (
        <main className="min-h-screen bg-base text-primary font-body pb-24">
            <div className="mx-auto max-w-4xl px-4 pt-10 sm:px-6 lg:px-8">
                
                {/* Header Subtitle */}
                <div className="mb-8 text-center animate-memory-rise" style={{ animationDelay: '0.1s' }}>
                    <p className="text-sm font-medium tracking-[0.18em] uppercase text-text-tertiary flex items-center justify-center gap-2">
                        <Target className="w-4 h-4 text-ai" />
                        Resultados Sintonía
                    </p>
                </div>

                {/* AI Insight Hero */}
                <section className="relative overflow-hidden rounded-[32px] bg-surface-1 border border-border shadow-2xl p-6 sm:p-10 mb-8 animate-memory-rise" style={{ animationDelay: '0.2s' }}>
                    <div className="absolute inset-0 bg-ai-glow opacity-30 animate-ai-pulse" />
                    <div className="absolute top-0 right-0 w-64 h-64 bg-ai/10 blur-[100px] rounded-full translate-x-1/2 -translate-y-1/2" />
                    <div className="absolute bottom-0 left-0 w-64 h-64 bg-conexion/10 blur-[100px] rounded-full -translate-x-1/2 translate-y-1/2" />
                    
                    <div className="relative z-10 flex flex-col items-center justify-center text-center">
                        <div className="inline-flex items-center gap-2 px-3 py-1 mb-6 rounded-full bg-ai-dim border border-ai/20">
                            <Sparkles className="w-3.5 h-3.5 text-ai" />
                            <span className="text-xs uppercase tracking-[0.2em] text-ai font-medium">Copiloto IA</span>
                        </div>
                        <h1 className="font-display text-3xl sm:text-4xl text-ai mb-6 leading-tight tracking-tight">
                            {insight.headline}
                        </h1>
                        <p className="text-lg sm:text-xl text-text-secondary leading-relaxed max-w-2xl font-light mb-8">
                            {insight.body}
                        </p>

                        <ShareAction 
                            scorePct={resolvedScorePct}
                            matchCount={resolvedMatchCount}
                            totalRounds={game.total_rounds}
                            headline={insight.headline}
                            body={insight.body}
                            playerNames={game.couples?.shared_nickname 
                                ? `Partida de ${game.couples.shared_nickname}`
                                : `${userAName} + ${userBName}`
                            }
                        />
                    </div>
                </section>

                <section className="grid gap-4 lg:grid-cols-1 mb-8 animate-memory-rise" style={{ animationDelay: '0.3s' }}>
                    {/* Primary Stats Card */}
                    <div className="rounded-[32px] border border-border bg-surface-1 p-6 sm:p-8">
                        <div className="flex flex-col sm:flex-row items-center gap-6 sm:gap-8 justify-center sm:justify-start pb-6 border-b border-border text-center sm:text-left">
                            <div className="relative shrink-0">
                                <div
                                    className="relative h-28 w-28 rounded-full p-2 flex items-center justify-center"
                                    style={{
                                        background: `conic-gradient(var(--color-conexion) ${resolvedScorePct * 3.6}deg, var(--color-surface-3) 0deg)`,
                                    }}
                                >
                                    <div className="flex h-full w-full items-center justify-center rounded-full bg-base border border-surface-3">
                                        <div className="text-center">
                                            <div className="text-3xl font-display font-medium text-text-primary">{resolvedScorePct}%</div>
                                        </div>
                                    </div>
                                </div>
                                <div className="absolute -bottom-2 -right-2 bg-conexion text-base text-xs font-bold uppercase tracking-widest px-3 py-1 rounded-full shadow-[0_0_15px_rgba(232,116,138,0.4)]">
                                    Match
                                </div>
                            </div>

                            <div>
                                <h2 className="text-2xl font-medium font-display mb-2">
                                    {resolvedMatchCount} de {game.total_rounds} coincidencias
                                </h2>
                                <p className="text-text-secondary flex items-center justify-center sm:justify-start gap-2">
                                    <Users className="w-4 h-4 text-text-tertiary" />
                                    {game.couples?.shared_nickname
                                        ? `Partida de ${game.couples.shared_nickname}`
                                        : `${userAName} + ${userBName}`}
                                </p>
                            </div>
                        </div>

                        {/* Secondary Stats Grid */}
                        <div className="mt-6 grid grid-cols-2 gap-3 sm:grid-cols-4">
                            <div className="flex flex-col items-center justify-center rounded-2xl bg-surface-2 p-4 text-center">
                                <Layers className="w-5 h-5 text-text-tertiary mb-2" />
                                <p className="text-[11px] uppercase tracking-[0.2em] text-text-tertiary mb-1">Rondas</p>
                                <p className="text-xl font-medium text-text-primary">{game.total_rounds}</p>
                            </div>

                            <div className="flex flex-col items-center justify-center rounded-2xl bg-surface-2 p-4 text-center">
                                <Activity className="w-5 h-5 text-text-tertiary mb-2" />
                                <p className="text-[11px] uppercase tracking-[0.2em] text-text-tertiary mb-1">Diferencias</p>
                                <p className="text-xl font-medium text-text-primary">{splitCount}</p>
                            </div>

                            <div className="flex flex-col items-center justify-center rounded-2xl bg-surface-2 p-4 text-center">
                                <Flame className="w-5 h-5 text-text-tertiary mb-2" />
                                <p className="text-[11px] uppercase tracking-[0.2em] text-text-tertiary mb-1">Racha Match</p>
                                <p className="text-xl font-medium text-text-primary">{longestMatchStreak}</p>
                            </div>

                            <div className="flex flex-col items-center justify-center rounded-2xl bg-surface-2 p-4 text-center">
                                <div className="mb-2">
                                    {bestCategory ? (
                                        <div className="text-text-tertiary">
                                            {(() => { const BestIcon = categoryMeta(bestCategory.category).Icon; return <BestIcon className="w-5 h-5" />; })()}
                                        </div>
                                    ) : <Target className="w-5 h-5 text-text-tertiary" />}
                                </div>
                                <p className="text-[11px] uppercase tracking-[0.2em] text-text-tertiary mb-1">Mejor Zona</p>
                                <p className="text-sm font-medium text-text-primary truncate w-full px-2">
                                    {bestCategory ? categoryMeta(bestCategory.category).label : "—"}
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <section className="mb-10 animate-memory-rise" style={{ animationDelay: '0.4s' }}>
                    <div className="mb-6 px-2">
                        <h2 className="text-2xl font-display font-medium">Bajo la lupa</h2>
                        <p className="mt-1 text-sm text-text-secondary">
                            Flujo por categoría y áreas de oportunidad.
                        </p>
                    </div>

                    <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                        {categoryStats.map((item) => {
                            const meta = categoryMeta(item.category);
                            const Icon = meta.Icon;
                            return (
                                <article
                                    key={item.category}
                                    className={`relative overflow-hidden rounded-[24px] border border-border bg-surface-1 p-5`}
                                >
                                    <div className={`absolute top-0 right-0 w-32 h-32 ${meta.bg} rounded-full blur-[40px] translate-x-1/2 -translate-y-1/2 opacity-50`} />
                                    
                                    <div className="relative z-10">
                                        <div className="flex items-center justify-between gap-3 mb-4">
                                            <div className="flex items-center gap-2">
                                                <div className={`p-2 rounded-xl ${meta.bg} ${meta.color}`}>
                                                    <Icon className="w-4 h-4" />
                                                </div>
                                                <h3 className="font-medium">{meta.label}</h3>
                                            </div>
                                            <span className="text-sm font-semibold font-display text-text-primary">
                                                {item.rate}%
                                            </span>
                                        </div>

                                        <div className="h-1.5 overflow-hidden rounded-full bg-surface-3">
                                            <div
                                                className={`h-full rounded-full ${meta.fill} ${item.rate === 100 ? 'animate-ai-pulse glow-border-' + meta.color.replace('text-', '') : ''}`}
                                                style={{ width: `${item.rate}%` }}
                                            />
                                        </div>

                                        <div className="mt-4 flex justify-between text-xs text-text-tertiary">
                                            <span>{item.matches} match</span>
                                            <span>{item.misses} dif</span>
                                        </div>
                                    </div>
                                </article>
                            )
                        })}
                    </div>
                </section>

                <section className="animate-memory-rise" style={{ animationDelay: '0.5s' }}>
                    <div className="mb-6 px-2">
                        <h2 className="text-2xl font-display font-medium">Radiografía ronda a ronda</h2>
                        <p className="mt-1 text-sm text-text-secondary">
                            Toca revisar dónde las neuronas hicieron chispa (o cortocircuito).
                        </p>
                    </div>

                    <div className="grid gap-4 lg:grid-cols-2">
                        {rounds.map((round, idx) => {
                            const meta = categoryMeta(round.category);
                            return (
                                <article
                                    key={round.id}
                                    className="relative overflow-hidden rounded-[28px] border border-border bg-surface-1 shadow-sm p-6 flex flex-col h-full"
                                >
                                    <div className="flex items-start justify-between gap-3 mb-5">
                                        <div>
                                            <div className="flex items-center gap-2 mb-2">
                                                <span className="text-[10px] sm:text-xs font-bold uppercase tracking-[0.2em] text-text-tertiary">
                                                    Ronda {round.roundNumber}
                                                </span>
                                                <span className="w-1 h-1 rounded-full bg-border" />
                                                <span className={`text-[10px] sm:text-xs font-bold uppercase tracking-[0.2em] ${meta.color}`}>
                                                    {meta.label}
                                                </span>
                                            </div>
                                        </div>

                                        <span
                                            className={`flex items-center gap-1 rounded-full px-3 py-1.5 text-[10px] sm:text-xs font-bold uppercase tracking-widest ring-1 ${statusBadgeClasses(
                                                round.isMatch,
                                            )}`}
                                        >
                                            {round.isMatch ? <Heart className="w-3.5 h-3.5 fill-conexion opacity-90" /> : null}
                                            {round.isMatch ? "Match" : "No match"}
                                        </span>
                                    </div>

                                    <h3 className="text-base sm:text-lg font-medium leading-relaxed text-text-primary mb-6 grow">
                                        "{round.scenario}"
                                    </h3>

                                    <div className="grid gap-3 sm:grid-cols-2 mt-auto">
                                        {/* Jugador A Vote Card */}
                                        <div
                                            className={`rounded-[20px] border p-4 flex flex-col justify-between ${voteCardClasses(
                                                round.userAVote != null,
                                            )}`}
                                        >
                                            <div className="mb-3">
                                                <p className="text-[10px] uppercase tracking-[0.2em] mb-1 font-semibold text-text-secondary opacity-70">
                                                    {userAName}
                                                </p>
                                                <p className="text-sm font-medium text-text-primary leading-snug">
                                                    {selectedOptionLabel(
                                                        round.userAVote,
                                                        round.optionA,
                                                        round.optionB,
                                                    )}
                                                </p>
                                            </div>
                                            <div className="flex justify-start">
                                                <span
                                                    className={`w-6 h-6 flex items-center justify-center rounded-full text-[10px] font-bold ${round.userAVote === "A"
                                                        ? "bg-conexion text-base shadow-[0_0_10px_rgba(232,116,138,0.3)]"
                                                        : "bg-surface-2 text-text-tertiary"
                                                        }`}
                                                >
                                                    A
                                                </span>
                                                <span
                                                    className={`w-6 h-6 flex items-center justify-center rounded-full text-[10px] font-bold -ml-1 ${round.userAVote === "B"
                                                        ? "bg-conexion text-base shadow-[0_0_10px_rgba(232,116,138,0.3)]"
                                                        : "bg-surface-2 text-text-tertiary"
                                                        }`}
                                                >
                                                    B
                                                </span>
                                            </div>
                                        </div>

                                        {/* Jugador B Vote Card */}
                                        <div
                                            className={`rounded-[20px] border p-4 flex flex-col justify-between ${voteCardClasses(
                                                round.userBVote != null,
                                            )}`}
                                        >
                                            <div className="mb-3">
                                                <p className="text-[10px] uppercase tracking-[0.2em] mb-1 font-semibold text-text-secondary opacity-70">
                                                    {userBName}
                                                </p>
                                                <p className="text-sm font-medium text-text-primary leading-snug">
                                                    {selectedOptionLabel(
                                                        round.userBVote,
                                                        round.optionA,
                                                        round.optionB,
                                                    )}
                                                </p>
                                            </div>
                                            <div className="flex justify-start">
                                                <span
                                                    className={`w-6 h-6 flex items-center justify-center rounded-full text-[10px] font-bold ${round.userBVote === "A"
                                                        ? "bg-conexion text-base shadow-[0_0_10px_rgba(232,116,138,0.3)]"
                                                        : "bg-surface-2 text-text-tertiary"
                                                        }`}
                                                >
                                                    A
                                                </span>
                                                <span
                                                    className={`w-6 h-6 flex items-center justify-center rounded-full text-[10px] font-bold -ml-1 ${round.userBVote === "B"
                                                        ? "bg-conexion text-base shadow-[0_0_10px_rgba(232,116,138,0.3)]"
                                                        : "bg-surface-2 text-text-tertiary"
                                                        }`}
                                                >
                                                    B
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    {/* Playful mini recap depending on match */}
                                    <div className="mt-4 pt-4 border-t border-border flex items-center gap-3">
                                        <div className={`shrink-0 w-8 h-8 rounded-full flex items-center justify-center ${round.isMatch ? 'bg-conexion/10' : 'bg-surface-2'}`}>
                                            {round.isMatch ? 
                                                <Sparkles className="w-4 h-4 text-conexion" /> : 
                                                <div className="text-xs font-medium text-text-tertiary text-center leading-none">VS</div>
                                            }
                                        </div>
                                        <p className="text-xs text-text-secondary">
                                            {round.isMatch ? "Conexión perfecta. Sus mentes jugaron en equipo." : "Cada quien su ruta. Buen pretexto para debatir."}
                                        </p>
                                    </div>

                                </article>
                            )
                        })}
                    </div>
                </section>
            </div>
        </main>
    );
}