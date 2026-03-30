'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import {
  Trophy, Flame, Star, Clock, Loader2, Play, CheckCircle2,
  ChevronDown, ChevronUp, Sparkles, ArrowRight, XCircle,
  Target, Zap, CalendarDays, BrainCircuit, RefreshCw,
} from 'lucide-react';
import { motion, AnimatePresence, type Variants } from 'framer-motion';
import {
  getChallenges,
  startChallenge,
  completeChallenge,
  abandonChallenge,
  generateCompletionReflection,
  type RetosData,
  type ChallengeRow,
  type AssignmentRow,
} from './actions';

// ─── Animation Variants ───────────────────────────────────────

const containerVariants: Variants = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { staggerChildren: 0.07 } },
};

const itemVariants: Variants = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0, transition: { type: 'spring', stiffness: 280, damping: 22 } },
};

// ─── Constants ────────────────────────────────────────────────

const LAYER_STYLES: Record<string, { bg: string; text: string; pill: string; color: string; dim: string }> = {
  conexion: {
    bg: 'bg-conexion-dim',
    text: 'text-conexion',
    pill: 'bg-conexion-dim text-conexion',
    color: 'var(--color-conexion)',
    dim: 'var(--color-conexion-dim)',
  },
  cuidado: {
    bg: 'bg-cuidado-dim',
    text: 'text-cuidado',
    pill: 'bg-cuidado-dim text-cuidado',
    color: 'var(--color-cuidado)',
    dim: 'var(--color-cuidado-dim)',
  },
  choque: {
    bg: 'bg-choque-dim',
    text: 'text-choque',
    pill: 'bg-choque-dim text-choque',
    color: 'var(--color-choque)',
    dim: 'var(--color-choque-dim)',
  },
  camino: {
    bg: 'bg-camino-dim',
    text: 'text-camino',
    pill: 'bg-camino-dim text-camino',
    color: 'var(--color-camino)',
    dim: 'var(--color-camino-dim)',
  },
};

const DIFFICULTY_LABELS: Record<string, { label: string; color: string; icon: typeof Zap }> = {
  easy: { label: 'Fácil', color: 'bg-choque-dim text-choque', icon: Star },
  medium: { label: 'Medio', color: 'bg-cuidado-dim text-cuidado', icon: Target },
  deep: { label: 'Profundo', color: 'bg-conexion-dim text-conexion', icon: Zap },
};

const DIMENSION_ICONS: Record<string, string> = {
  conexion: '💜',
  cuidado: '💚',
  choque: '⚡',
  camino: '🧭',
};

// ─── Active Challenge Card ────────────────────────────────────

function ActiveChallengeCard({
  assignment,
  onComplete,
  onAbandon,
  completing,
  abandoning,
}: {
  assignment: AssignmentRow;
  onComplete: () => void;
  onAbandon: () => void;
  completing: boolean;
  abandoning: boolean;
}) {
  const [showTips, setShowTips] = useState(false);
  const challenge = assignment.challenge;
  if (!challenge) return null;

  const daysSinceStart = Math.max(1, Math.floor(
    (Date.now() - new Date(assignment.startedAt).getTime()) / (1000 * 60 * 60 * 24)
  ));
  const totalDays = challenge.durationDays;
  const progressPct = Math.min(100, (daysSinceStart / totalDays) * 100);
  const currentDay = Math.min(daysSinceStart, totalDays);
  const layerStyle = LAYER_STYLES[challenge.dimension] || LAYER_STYLES.conexion;

  const todayTip = assignment.dailyTips[currentDay - 1] || null;

  return (
    <Card className="overflow-hidden p-0" style={{ background: 'transparent' }}>
      <div className="p-6" style={{ background: layerStyle.dim }}>
          {/* Header */}
          <div className="flex items-center gap-2 mb-3">
            <span className="text-2xl">{DIMENSION_ICONS[challenge.dimension]}</span>
            <div className="flex gap-2">
              <span className={`px-2 py-0.5 rounded text-[10px] font-medium bg-white/20`}>
                {challenge.dimensionLabel}
              </span>
              <span className={`px-2 py-0.5 rounded text-[10px] font-medium bg-white/20`}>
                {DIFFICULTY_LABELS[challenge.difficulty]?.label || 'Medio'}
              </span>
            </div>
          </div>

          <h3 className="text-xl font-bold mb-2">{challenge.title}</h3>
          <p className="text-white/80 text-sm mb-5">{challenge.description}</p>

          {/* Progress */}
          <div className="flex items-center justify-between text-sm mb-2">
            <div className="flex items-center gap-2">
              <CalendarDays className="h-4 w-4" />
              <span>Día {currentDay} de {totalDays}</span>
            </div>
            <span className="font-medium">{Math.round(progressPct)}%</span>
          </div>
          <div className="h-2.5 bg-white/20 rounded-full overflow-hidden">
            <motion.div
              className="h-full bg-white rounded-full"
              initial={{ width: 0 }}
              animate={{ width: `${progressPct}%` }}
              transition={{ duration: 0.8 }}
            />
          </div>

          {/* AI Coaching */}
          {assignment.aiCoaching && (
            <div className="mt-5 bg-white/10 rounded-xl p-4">
              <div className="flex items-center gap-1.5 mb-2">
                <Sparkles className="h-3.5 w-3.5" />
                <span className="text-xs font-medium">Coaching IA</span>
              </div>
              <p className="text-white/85 text-sm leading-relaxed">{assignment.aiCoaching}</p>
            </div>
          )}

          {/* Today's tip */}
          {todayTip && (
            <div className="mt-3 bg-white/10 rounded-xl p-3">
              <div className="flex items-center gap-1.5 mb-1">
                <Target className="h-3 w-3" />
                <span className="text-[10px] font-medium uppercase tracking-wide">Tip del día {currentDay}</span>
              </div>
              <p className="text-white/85 text-sm">{todayTip}</p>
            </div>
          )}

          {/* Daily tips toggle */}
          {assignment.dailyTips.length > 0 && (
            <button
              className="flex items-center gap-1 mt-3 text-xs text-white/60 hover:text-white/90 transition-colors"
              onClick={() => setShowTips(!showTips)}
            >
              {showTips ? <ChevronUp className="h-3 w-3" /> : <ChevronDown className="h-3 w-3" />}
              {showTips ? 'Ocultar todos los tips' : 'Ver todos los tips'}
            </button>
          )}

          <AnimatePresence>
            {showTips && (
              <motion.div
                initial={{ height: 0, opacity: 0 }}
                animate={{ height: 'auto', opacity: 1, transition: { duration: 0.3 } }}
                exit={{ height: 0, opacity: 0, transition: { duration: 0.2 } }}
                className="overflow-hidden"
              >
                <ul className="mt-3 space-y-2">
                  {assignment.dailyTips.map((tip, i) => (
                    <li
                      key={i}
                      className={`flex items-start gap-2 text-sm ${
                        i + 1 === currentDay ? 'text-white font-medium' : 'text-white/50'
                      }`}
                    >
                      <span className={`w-5 h-5 rounded-full text-[10px] font-bold flex items-center justify-center shrink-0 mt-0.5 ${
                        i + 1 < currentDay ? 'bg-white/30' :
                        i + 1 === currentDay ? 'bg-white text-purple-600' :
                        'bg-white/10'
                      }`}>
                        {i + 1 < currentDay ? '✓' : i + 1}
                      </span>
                      {tip}
                    </li>
                  ))}
                </ul>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Actions */}
          <div className="flex gap-3 mt-5">
            <Button
              className="flex-1" style={{ background: layerStyle.color, color: 'var(--color-base)' }}
              onClick={onComplete}
              loading={completing}
            >
              <CheckCircle2 className="mr-2 h-4 w-4" />
              Completar reto
            </Button>
            <Button
              variant="ghost"
              className="text-white/60 hover:text-white hover:bg-white/10"
              onClick={onAbandon}
              loading={abandoning}
            >
              <XCircle className="h-4 w-4" />
            </Button>
          </div>
      </div>
    </Card>
  );
}

// ─── Available Challenge Card ─────────────────────────────────

function AvailableChallengeCard({
  challenge,
  isRecommended,
  reason,
  isExpanded,
  onToggle,
  onStart,
  starting,
  disabled,
}: {
  challenge: ChallengeRow;
  isRecommended: boolean;
  reason: string | null;
  isExpanded: boolean;
  onToggle: () => void;
  onStart: () => void;
  starting: boolean;
  disabled: boolean;
}) {
  const layerStyle = LAYER_STYLES[challenge.dimension] || LAYER_STYLES.conexion;
  const diff = DIFFICULTY_LABELS[challenge.difficulty] || DIFFICULTY_LABELS.medium;

  return (
    <Card className={`overflow-hidden transition-all hover:shadow-md ${
      isRecommended ? 'ring-2 ring-primary/30 shadow-md shadow-primary/10' : ''
    }`}>
      <CardContent className="pt-0 pb-0">
        {isRecommended && (
          <div className="bg-gradient-to-r from-primary/10 to-purple-500/10 px-4 py-1.5 -mx-6">
            <span className="text-xs font-medium text-primary flex items-center gap-1">
              <Sparkles className="h-3 w-3" /> Recomendado para ti
            </span>
          </div>
        )}

        <button className="w-full flex items-start gap-3 py-4 text-left" onClick={onToggle}>
          <div className={`w-11 h-11 rounded-xl ${layerStyle.bg} flex items-center justify-center shrink-0`}>
            <span className="text-lg">{DIMENSION_ICONS[challenge.dimension]}</span>
          </div>
          <div className="flex-1 min-w-0">
            <h3 className="font-semibold text-on_surface text-sm">{challenge.title}</h3>
            <div className="flex items-center gap-2 mt-1.5">
              <span className={`px-1.5 py-0.5 rounded text-[10px] font-medium ${layerStyle.pill}`}>
                {challenge.dimensionLabel}
              </span>
              <span className={`px-1.5 py-0.5 rounded text-[10px] font-medium ${diff.color}`}>
                {diff.label}
              </span>
              <span className="text-[10px] text-on_surface_variant flex items-center gap-0.5">
                <Clock className="h-2.5 w-2.5" />
                {challenge.durationDays}d
              </span>
            </div>
          </div>
          {isExpanded ? (
            <ChevronUp className="h-4 w-4 text-on_surface_variant shrink-0 mt-1" />
          ) : (
            <ChevronDown className="h-4 w-4 text-on_surface_variant shrink-0 mt-1" />
          )}
        </button>

        <AnimatePresence>
          {isExpanded && (
            <motion.div
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: 'auto', opacity: 1, transition: { duration: 0.3 } }}
              exit={{ height: 0, opacity: 0, transition: { duration: 0.2 } }}
              className="overflow-hidden"
            >
              <div className="pb-4 space-y-3 border-t border-outline_variant/20 pt-3">
                <p className="text-sm text-on_surface_variant leading-relaxed">{challenge.description}</p>

                {isRecommended && reason && (
                  <div className="bg-primary/5 rounded-lg p-3 flex items-start gap-2">
                    <BrainCircuit className="h-4 w-4 text-primary shrink-0 mt-0.5" />
                    <p className="text-xs text-primary">{reason}</p>
                  </div>
                )}

                <Button
                  className="w-full"
                  onClick={(e) => { e.stopPropagation(); onStart(); }}
                  loading={starting}
                  disabled={disabled}
                >
                  <Play className="mr-2 h-4 w-4" />
                  {disabled ? 'Completa tu reto activo primero' : 'Comenzar reto'}
                </Button>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </CardContent>
    </Card>
  );
}

// ─── Main Page ────────────────────────────────────────────────

export default function RetosPage() {
  const router = useRouter();
  const [data, setData] = useState<RetosData | null>(null);
  const [loading, setLoading] = useState(true);
  const [starting, setStarting] = useState<string | null>(null);
  const [completing, setCompleting] = useState<string | null>(null);
  const [abandoning, setAbandoning] = useState<string | null>(null);
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [reflectionText, setReflectionText] = useState<string | null>(null);
  const [reflectionLoading, setReflectionLoading] = useState(false);

  useEffect(() => {
    async function load() {
      try {
        const retosData = await getChallenges();
        setData(retosData);
        // Auto-expand recommended
        if (retosData.recommendedChallenge) {
          setExpandedId(retosData.recommendedChallenge.id);
        }
      } catch (err) {
        console.error('Error loading retos:', err);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  const handleStartChallenge = useCallback(async (challengeId: string) => {
    setStarting(challengeId);
    try {
      await startChallenge(challengeId);
      const retosData = await getChallenges();
      setData(retosData);
    } catch (err: any) {
      console.error('Error starting challenge:', err);
    } finally {
      setStarting(null);
    }
  }, []);

  const handleComplete = useCallback(async (assignmentId: string) => {
    setCompleting(assignmentId);
    try {
      await completeChallenge(assignmentId);

      // Generate reflection
      setReflectionLoading(true);
      const result = await generateCompletionReflection(assignmentId);
      setReflectionText(result.reflection);
      setReflectionLoading(false);

      const retosData = await getChallenges();
      setData(retosData);
    } catch (err: any) {
      console.error('Error completing challenge:', err);
    } finally {
      setCompleting(null);
    }
  }, []);

  const handleAbandon = useCallback(async (assignmentId: string) => {
    setAbandoning(assignmentId);
    try {
      await abandonChallenge(assignmentId);
      const retosData = await getChallenges();
      setData(retosData);
    } catch (err: any) {
      console.error('Error abandoning challenge:', err);
    } finally {
      setAbandoning(null);
    }
  }, []);

  // ─── Loading ──────────────────────────────────────────────

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="flex flex-col items-center gap-3">
            <Loader2 className="h-12 w-12 animate-spin" style={{ color: 'var(--color-ai)' }} />
            <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>Cargando retos...</p>
          </div>
        </div>
      </AppShell>
    );
  }

  if (!data) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <p style={{ color: 'var(--color-text-secondary)' }}>Error cargando los retos</p>
        </div>
      </AppShell>
    );
  }

  const hasActiveReto = data.activeChallenges.length > 0;

  return (
    <AppShell>
      <motion.div
        className="space-y-8"
        variants={containerVariants}
        initial="hidden"
        animate="show"
      >
        {/* ═══ Header ═══ */}
        <motion.div variants={itemVariants}>
          <h1 className="font-display text-3xl md:text-4xl mb-1" style={{ color: 'var(--color-text-primary)' }}>Retos</h1>
          <p style={{ color: 'var(--color-text-secondary)' }}>
            Desafíos semanales para fortalecer tu relación
          </p>
        </motion.div>

        {/* ═══ Stats ═══ */}
        <motion.div className="grid grid-cols-3 gap-3" variants={containerVariants}>
          <motion.div variants={itemVariants}>
            <Card>
              <CardContent className="text-center pt-4 pb-4">
                <div className="w-10 h-10 rounded-xl flex items-center justify-center mx-auto mb-2" style={{ background: 'var(--color-cuidado-dim)' }}>
                  <Flame className="h-5 w-5" style={{ color: 'var(--color-cuidado)' }} />
                </div>
                <p className="text-2xl font-bold" style={{ color: 'var(--color-text-primary)' }}>{data.streak}</p>
                <p className="text-[10px]" style={{ color: 'var(--color-text-tertiary)' }}>Racha</p>
              </CardContent>
            </Card>
          </motion.div>
          <motion.div variants={itemVariants}>
            <Card>
              <CardContent className="text-center pt-4 pb-4">
                <div className="w-10 h-10 rounded-xl flex items-center justify-center mx-auto mb-2" style={{ background: 'var(--color-choque-dim)' }}>
                  <Trophy className="h-5 w-5" style={{ color: 'var(--color-success)' }} />
                </div>
                <p className="text-2xl font-bold" style={{ color: 'var(--color-text-primary)' }}>{data.completedCount}</p>
                <p className="text-[10px]" style={{ color: 'var(--color-text-tertiary)' }}>Completados</p>
              </CardContent>
            </Card>
          </motion.div>
          <motion.div variants={itemVariants}>
            <Card>
              <CardContent className="text-center pt-4 pb-4">
                <div className="w-10 h-10 rounded-xl flex items-center justify-center mx-auto mb-2" style={{ background: 'var(--color-conexion-dim)' }}>
                  <Star className="h-5 w-5" style={{ color: 'var(--color-conexion)' }} />
                </div>
                <p className="text-2xl font-bold" style={{ color: 'var(--color-text-primary)' }}>{data.totalPoints}</p>
                <p className="text-[10px]" style={{ color: 'var(--color-text-tertiary)' }}>Puntos</p>
              </CardContent>
            </Card>
          </motion.div>
        </motion.div>

        {/* ═══ Completion Reflection ═══ */}
        <AnimatePresence>
          {reflectionText && (
            <motion.div
              initial={{ scale: 0.95, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.95, opacity: 0 }}
            >
              <Card className="overflow-hidden">
                <div style={{ background: 'var(--color-choque-dim)', padding: '1.5rem' }}>
                    <div className="flex items-center gap-2 mb-3">
                      <Trophy className="h-5 w-5" style={{ color: 'var(--color-success)' }} />
                      <span className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>¡Reto completado! 🎉</span>
                    </div>
                    <p className="text-sm leading-relaxed" style={{ color: 'var(--color-text-secondary)' }}>{reflectionText}</p>
                    <button
                      className="mt-3 text-xs transition-colors"
                      style={{ color: 'var(--color-text-tertiary)' }}
                      onClick={() => setReflectionText(null)}
                    >
                      Cerrar
                    </button>
                </div>
              </Card>
            </motion.div>
          )}
        </AnimatePresence>

        {/* ═══ Active Challenge ═══ */}
        {data.activeChallenges.map(ac => (
          <motion.div key={ac.id} variants={itemVariants}>
            <h2 className="text-lg font-semibold text-on_surface mb-3 flex items-center gap-2">
              <Flame className="h-5 w-5 text-orange-500" />
              Reto activo
            </h2>
            <ActiveChallengeCard
              assignment={ac}
              onComplete={() => handleComplete(ac.id)}
              onAbandon={() => handleAbandon(ac.id)}
              completing={completing === ac.id}
              abandoning={abandoning === ac.id}
            />
          </motion.div>
        ))}

        {/* No active CTA */}
        {!hasActiveReto && data.availableChallenges.length > 0 && !reflectionText && (
          <motion.div variants={itemVariants}>
            <Card className="bg-surface_container_low border border-primary/10">
              <CardContent className="pt-5 text-center pb-5">
                <Trophy className="h-10 w-10 text-primary mx-auto mb-2 opacity-60" />
                <p className="font-semibold text-on_surface mb-0.5">Sin reto activo</p>
                <p className="text-sm text-on_surface_variant">
                  Elige un reto de la lista para comenzar tu próximo desafío
                </p>
              </CardContent>
            </Card>
          </motion.div>
        )}

        {/* ═══ Available Challenges ═══ */}
        {data.availableChallenges.length > 0 && (
          <motion.div variants={itemVariants}>
            <h2 className="text-lg font-semibold text-on_surface mb-3">
              {hasActiveReto ? 'Próximos retos' : 'Retos disponibles'}
            </h2>
            <div className="space-y-2">
              {/* Show recommended first */}
              {data.recommendedChallenge && data.availableChallenges.find(c => c.id === data.recommendedChallenge!.id) && (
                <AvailableChallengeCard
                  key={data.recommendedChallenge.id}
                  challenge={data.recommendedChallenge}
                  isRecommended={true}
                  reason={data.recommendationReason}
                  isExpanded={expandedId === data.recommendedChallenge.id}
                  onToggle={() => setExpandedId(prev => prev === data.recommendedChallenge!.id ? null : data.recommendedChallenge!.id)}
                  onStart={() => handleStartChallenge(data.recommendedChallenge!.id)}
                  starting={starting === data.recommendedChallenge.id}
                  disabled={hasActiveReto}
                />
              )}
              {/* Rest */}
              {data.availableChallenges
                .filter(c => c.id !== data.recommendedChallenge?.id)
                .map(challenge => (
                  <AvailableChallengeCard
                    key={challenge.id}
                    challenge={challenge}
                    isRecommended={false}
                    reason={null}
                    isExpanded={expandedId === challenge.id}
                    onToggle={() => setExpandedId(prev => prev === challenge.id ? null : challenge.id)}
                    onStart={() => handleStartChallenge(challenge.id)}
                    starting={starting === challenge.id}
                    disabled={hasActiveReto}
                  />
                ))}
            </div>
          </motion.div>
        )}

        {/* ═══ Completed Challenges ═══ */}
        {data.completedChallenges.length > 0 && (
          <motion.div variants={itemVariants}>
            <h2 className="text-lg font-semibold text-on_surface mb-3">Completados</h2>
            <div className="space-y-2">
              {data.completedChallenges.map(ac => (
                <Card key={ac.id} className="opacity-70">
                  <CardContent className="flex items-center gap-3 py-3.5">
                    <div className={`w-9 h-9 rounded-xl ${LAYER_STYLES[ac.challenge?.dimension || 'conexion']?.bg} flex items-center justify-center shrink-0`}>
                      <CheckCircle2 className="h-4 w-4 text-emerald-500" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="font-medium text-on_surface text-sm truncate">{ac.challenge?.title || 'Reto'}</p>
                      <p className="text-[10px] text-on_surface_variant">
                        {ac.completedAt ? new Date(ac.completedAt).toLocaleDateString('es-MX', { day: 'numeric', month: 'short' }) : ''}
                        {' · '}
                        +{DIFFICULTY_LABELS[ac.challenge?.difficulty || 'medium']?.label} · {ac.challenge?.durationDays}d
                      </p>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </motion.div>
        )}

        {/* ═══ Empty state ═══ */}
        {data.availableChallenges.length === 0 && !hasActiveReto && data.completedChallenges.length === 0 && (
          <motion.div variants={itemVariants}>
            <Card className="overflow-hidden relative">
              <div className="absolute inset-0 bg-gradient-to-br from-purple-600/90 to-blue-500/80" />
              <CardContent className="relative z-10 pt-10 text-center py-14 text-white">
                <Trophy className="h-16 w-16 mx-auto mb-4 opacity-80" />
                <h2 className="text-xl font-semibold mb-2">Los retos están en camino</h2>
                <p className="text-white/80 max-w-sm mx-auto mb-6">
                  Ejecuta la migración de seed data para desbloquear 12 retos personalizados en las 4 dimensiones.
                </p>
                <Button
                  className="bg-white text-purple-600 hover:bg-white/90"
                  onClick={() => router.push('/dashboard/nosotros')}
                >
                  Ver tu mapa de relación
                  <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </CardContent>
            </Card>
          </motion.div>
        )}

        {/* ═══ All challenges completed ═══ */}
        {data.availableChallenges.length === 0 && !hasActiveReto && data.completedChallenges.length > 0 && (
          <motion.div variants={itemVariants}>
            <Card className="overflow-hidden relative shadow-lg">
              <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/90 to-teal-500/80" />
              <CardContent className="relative z-10 pt-8 pb-8 text-white text-center">
                <motion.div
                  animate={{ rotate: [0, 10, -10, 0] }}
                  transition={{ repeat: Infinity, duration: 2, repeatDelay: 3 }}
                >
                  <Trophy className="h-14 w-14 mx-auto mb-3" />
                </motion.div>
                <h2 className="text-2xl font-bold mb-2">¡Todos los retos completados! 🏆</h2>
                <p className="text-white/80 mb-2">
                  {data.totalPoints} puntos acumulados · Racha de {data.streak}
                </p>
                <p className="text-white/60 text-sm max-w-sm mx-auto">
                  Pronto agregaremos nuevos retos. Mientras tanto, sigan cultivando sus hábitos de relación.
                </p>
              </CardContent>
            </Card>
          </motion.div>
        )}

        {/* ═══ Bottom CTA ═══ */}
        <motion.div variants={itemVariants}>
          <Card className="overflow-hidden cursor-pointer transition-all hover:scale-[1.01]" style={{ background: 'var(--color-cuidado-dim)', border: '1px solid var(--color-border)' }}>
            <CardContent className="pt-5 pb-5">
              <div className="flex items-center justify-between flex-wrap gap-3">
                <div>
                  <h3 className="font-semibold mb-0.5" style={{ color: 'var(--color-text-primary)' }}>Tu plan semanal</h3>
                  <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
                    Actividades diarias personalizadas para complementar tus retos.
                  </p>
                </div>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => router.push('/dashboard/plan')}
                >
                  Ver plan
                  <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </div>
            </CardContent>
          </Card>
        </motion.div>
      </motion.div>
    </AppShell>
  );
}
