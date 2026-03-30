'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import {
  Check, MessageCircle, Heart, Target, Sparkles, Clock, Loader2, Plus,
  ChevronDown, ChevronUp, SkipForward, StickyNote, Users, User,
  CalendarDays, Trophy, ArrowRight, RefreshCw,
} from 'lucide-react';
import { motion, AnimatePresence, type Variants } from 'framer-motion';
import {
  getWeeklyPlan,
  togglePlanItem,
  skipPlanItem,
  addPlanItemNote,
  generateWeeklyPlan,
  type WeeklyPlanData,
  type PlanItem,
} from './actions';

// ─── Animation Variants ───────────────────────────────────────

const containerVariants: Variants = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { staggerChildren: 0.06 } },
};

const itemVariants: Variants = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0, transition: { type: 'spring', stiffness: 280, damping: 22 } },
};

// ─── Constants ────────────────────────────────────────────────

const ACTIVITY_ICONS: Record<string, typeof Heart> = {
  ritual: Heart,
  conversacion: MessageCircle,
  microaccion: Target,
  reflexion: Sparkles,
  reto: Trophy,
  check_in: Check,
};

const LAYER_COLORS: Record<string, { bg: string; text: string; ring: string; pill: string; color: string; dim: string }> = {
  conexion: {
    bg: 'bg-conexion-dim',
    text: 'text-conexion',
    ring: 'stroke-conexion',
    pill: 'bg-conexion-dim text-conexion',
    color: 'var(--color-conexion)',
    dim: 'var(--color-conexion-dim)',
  },
  cuidado: {
    bg: 'bg-cuidado-dim',
    text: 'text-cuidado',
    ring: 'stroke-cuidado',
    pill: 'bg-cuidado-dim text-cuidado',
    color: 'var(--color-cuidado)',
    dim: 'var(--color-cuidado-dim)',
  },
  choque: {
    bg: 'bg-choque-dim',
    text: 'text-choque',
    ring: 'stroke-choque',
    pill: 'bg-choque-dim text-choque',
    color: 'var(--color-choque)',
    dim: 'var(--color-choque-dim)',
  },
  camino: {
    bg: 'bg-camino-dim',
    text: 'text-camino',
    ring: 'stroke-camino',
    pill: 'bg-camino-dim text-camino',
    color: 'var(--color-camino)',
    dim: 'var(--color-camino-dim)',
  },
};

const DIFFICULTY_LABELS: Record<string, { label: string; color: string }> = {
  easy: { label: 'Fácil', color: 'bg-choque-dim text-choque' },
  medium: { label: 'Medio', color: 'bg-cuidado-dim text-cuidado' },
  deep: { label: 'Profundo', color: 'bg-conexion-dim text-conexion' },
};

const ACTIVITY_LABELS: Record<string, string> = {
  ritual: 'Ritual',
  conversacion: 'Conversación',
  microaccion: 'Microacción',
  reflexion: 'Reflexión',
  reto: 'Reto',
  check_in: 'Check-in',
};

// ─── Progress Ring ────────────────────────────────────────────

function ProgressRing({ progress, size = 120, strokeWidth = 8 }: {
  progress: number;
  size?: number;
  strokeWidth?: number;
}) {
  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference - (progress / 100) * circumference;

  return (
    <div className="relative" style={{ width: size, height: size }}>
      <svg viewBox={`0 0 ${size} ${size}`} className="w-full h-full -rotate-90">
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke="currentColor"
          className="text-surface-3"
          strokeWidth={strokeWidth}
        />
        <motion.circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke="url(#progressGradient)"
          strokeWidth={strokeWidth}
          strokeLinecap="round"
          strokeDasharray={circumference}
          initial={{ strokeDashoffset: circumference }}
          animate={{ strokeDashoffset: offset }}
          transition={{ duration: 1, ease: 'easeOut', delay: 0.3 }}
        />
        <defs>
          <linearGradient id="progressGradient" x1="0%" y1="0%" x2="100%" y2="0%">
            <stop offset="0%" stopColor="var(--color-conexion)" />
            <stop offset="100%" stopColor="var(--color-ai)" />
          </linearGradient>
        </defs>
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="text-2xl font-bold" style={{ color: 'var(--color-text-primary)' }}>{progress}%</span>
        <span className="text-[10px]" style={{ color: 'var(--color-text-tertiary)' }}>completado</span>
      </div>
    </div>
  );
}

// ─── Plan Item Card ───────────────────────────────────────────

interface PlanItemCardProps {
  item: PlanItem;
  isToday: boolean;
  isExpanded: boolean;
  onToggle: () => void;
  onExpand: () => void;
  onSkip: () => void;
  onSaveNote: (note: string) => void;
  toggling: boolean;
  skipping: boolean;
}

function PlanItemCard({
  item,
  isToday,
  isExpanded,
  onToggle,
  onExpand,
  onSkip,
  onSaveNote,
  toggling,
  skipping,
}: PlanItemCardProps) {
  const [noteText, setNoteText] = useState(item.notes || '');
  const [showNote, setShowNote] = useState(false);
  const [savingNote, setSavingNote] = useState(false);

  const Icon = ACTIVITY_ICONS[item.activityType] || Sparkles;
  const layerStyle = LAYER_COLORS[item.dimension] || LAYER_COLORS.conexion;
  const diffStyle = DIFFICULTY_LABELS[item.difficulty] || DIFFICULTY_LABELS.easy;
  const isCompleted = item.status === 'completed';
  const isSkipped = item.status === 'skipped';

  const handleSaveNote = async () => {
    setSavingNote(true);
    await onSaveNote(noteText);
    setSavingNote(false);
    setShowNote(false);
  };

  return (
    <motion.div variants={itemVariants}>
      <Card
        className={`overflow-hidden transition-all ${
          isToday && !isCompleted && !isSkipped
            ? 'ring-2 ring-primary/30 shadow-md shadow-primary/10'
            : ''
        } ${isCompleted ? 'opacity-60' : ''} ${isSkipped ? 'opacity-40' : ''}`}
      >
        <CardContent className="pt-0 pb-0">
          {/* Today indicator */}
          {isToday && !isCompleted && !isSkipped && (
            <div className="bg-gradient-to-r from-primary/10 to-purple-500/10 px-4 py-1.5 -mx-6 mb-0">
              <span className="text-xs font-medium text-primary">📍 Hoy</span>
            </div>
          )}

          {/* Main row */}
          <button
            className="w-full flex items-center gap-3 py-4 text-left"
            onClick={onExpand}
          >
            {/* Checkbox */}
            <button
              onClick={(e) => { e.stopPropagation(); onToggle(); }}
              disabled={toggling || isSkipped}
              className={`w-7 h-7 rounded-full border-2 flex items-center justify-center transition-all shrink-0 ${
                isCompleted
                  ? 'bg-primary border-primary'
                  : isSkipped
                    ? 'bg-surface_container_low border-outline_variant'
                    : 'border-outline_variant hover:border-primary'
              } ${toggling ? 'opacity-50' : ''}`}
            >
              {toggling ? (
                <Loader2 className="h-3.5 w-3.5 animate-spin text-primary" />
              ) : isCompleted ? (
                <Check className="h-4 w-4 text-white" />
              ) : isSkipped ? (
                <SkipForward className="h-3 w-3 text-on_surface_variant" />
              ) : null}
            </button>

            {/* Content */}
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 mb-0.5">
                <span className="text-xs font-medium text-on_surface_variant">
                  {item.dayLabel}
                </span>
                <span className="flex items-center gap-0.5 text-[10px] text-on_surface_variant">
                  <Clock className="h-2.5 w-2.5" />
                  {item.durationMinutes}m
                </span>
                {item.requiresBoth ? (
                  <Users className="h-3 w-3 text-on_surface_variant" title="Ambos" />
                ) : (
                  <User className="h-3 w-3 text-on_surface_variant" title="Individual" />
                )}
              </div>
              <h3 className={`font-semibold text-on_surface text-sm ${isCompleted ? 'line-through' : ''}`}>
                {item.title}
              </h3>
            </div>

            {/* Right side */}
            <div className="flex items-center gap-2 shrink-0">
              <div className={`w-8 h-8 rounded-lg ${layerStyle.bg} flex items-center justify-center`}>
                <Icon className={`h-4 w-4 ${layerStyle.text}`} />
              </div>
              {isExpanded ? (
                <ChevronUp className="h-4 w-4 text-on_surface_variant" />
              ) : (
                <ChevronDown className="h-4 w-4 text-on_surface_variant" />
              )}
            </div>
          </button>

          {/* Expanded content */}
          <AnimatePresence>
            {isExpanded && (
              <motion.div
                initial={{ height: 0, opacity: 0 }}
                animate={{ height: 'auto', opacity: 1, transition: { duration: 0.3 } }}
                exit={{ height: 0, opacity: 0, transition: { duration: 0.2 } }}
                className="overflow-hidden"
              >
                <div className="pb-4 space-y-3 border-t border-outline_variant/20 pt-3">
                  {/* Description */}
                  <p className="text-sm text-on_surface_variant leading-relaxed">
                    {item.description}
                  </p>

                  {/* Tags */}
                  <div className="flex flex-wrap gap-2">
                    <span className={`px-2 py-0.5 rounded-full text-[10px] font-medium ${layerStyle.pill}`}>
                      {item.dimensionLabel}
                    </span>
                    <span className={`px-2 py-0.5 rounded-full text-[10px] font-medium ${diffStyle.color}`}>
                      {diffStyle.label}
                    </span>
                    <span className="px-2 py-0.5 rounded-full text-[10px] font-medium bg-gray-100 text-gray-600">
                      {ACTIVITY_LABELS[item.activityType] || item.activityType}
                    </span>
                  </div>

                  {/* Actions */}
                  {!isCompleted && !isSkipped && (
                    <div className="flex gap-2 pt-1">
                      <Button
                        size="sm"
                        onClick={(e) => { e.stopPropagation(); onToggle(); }}
                        disabled={toggling}
                        className="flex-1"
                      >
                        {toggling ? (
                          <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" />
                        ) : (
                          <Check className="mr-1.5 h-3.5 w-3.5" />
                        )}
                        Completar
                      </Button>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={(e) => { e.stopPropagation(); onSkip(); }}
                        disabled={skipping}
                        className="text-on_surface_variant"
                      >
                        {skipping ? (
                          <Loader2 className="h-3.5 w-3.5 animate-spin" />
                        ) : (
                          <SkipForward className="h-3.5 w-3.5" />
                        )}
                      </Button>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={(e) => { e.stopPropagation(); setShowNote(!showNote); }}
                        className="text-on_surface_variant"
                      >
                        <StickyNote className="h-3.5 w-3.5" />
                      </Button>
                    </div>
                  )}

                  {/* Completed badge */}
                  {isCompleted && item.completedAt && (
                    <div className="flex items-center gap-2 text-xs text-primary">
                      <Check className="h-3.5 w-3.5" />
                      Completado el {new Date(item.completedAt).toLocaleDateString('es-MX', {
                        day: 'numeric',
                        month: 'short',
                        hour: '2-digit',
                        minute: '2-digit',
                      })}
                    </div>
                  )}

                  {/* Note area */}
                  <AnimatePresence>
                    {showNote && (
                      <motion.div
                        initial={{ height: 0, opacity: 0 }}
                        animate={{ height: 'auto', opacity: 1 }}
                        exit={{ height: 0, opacity: 0 }}
                        className="overflow-hidden"
                      >
                        <div className="bg-surface_container_low rounded-lg p-3">
                          <textarea
                            value={noteText}
                            onChange={(e) => setNoteText(e.target.value)}
                            placeholder="¿Cómo les fue? ¿Qué descubrieron?"
                            className="w-full bg-transparent text-sm text-on_surface resize-none border-none outline-none placeholder:text-on_surface_variant/50"
                            rows={3}
                          />
                          <div className="flex justify-end mt-2">
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={handleSaveNote}
                              disabled={savingNote}
                            >
                              {savingNote ? (
                                <Loader2 className="h-3 w-3 animate-spin mr-1" />
                              ) : null}
                              Guardar nota
                            </Button>
                          </div>
                        </div>
                      </motion.div>
                    )}
                  </AnimatePresence>

                  {/* Existing note */}
                  {item.notes && !showNote && (
                    <div className="bg-surface_container_low rounded-lg p-3">
                      <div className="flex items-center gap-1.5 mb-1">
                        <StickyNote className="h-3 w-3 text-on_surface_variant" />
                        <span className="text-[10px] font-medium text-on_surface_variant">Nota</span>
                      </div>
                      <p className="text-xs text-on_surface_variant">{item.notes}</p>
                    </div>
                  )}
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </CardContent>
      </Card>
    </motion.div>
  );
}

// ─── Main Page ────────────────────────────────────────────────

export default function PlanPage() {
  const router = useRouter();
  const [data, setData] = useState<WeeklyPlanData | null>(null);
  const [loading, setLoading] = useState(true);
  const [generating, setGenerating] = useState(false);
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [togglingId, setTogglingId] = useState<string | null>(null);
  const [skippingId, setSkippingId] = useState<string | null>(null);

  // Load data
  useEffect(() => {
    async function load() {
      try {
        const result = await getWeeklyPlan();
        setData(result);

        // Auto-expand today's item
        if (result) {
          const today = new Date().getDay();
          const todayNum = today === 0 ? 7 : today; // Convert Sun=0 to Sun=7
          const todayItem = result.items.find(i => i.dayOfWeek === todayNum && i.status === 'pending');
          if (todayItem) setExpandedId(todayItem.id);
        }
      } catch (err) {
        console.error('Error loading plan:', err);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  const handleToggle = useCallback(async (itemId: string) => {
    setTogglingId(itemId);
    try {
      const result = await togglePlanItem(itemId);
      setData(prev => {
        if (!prev) return prev;
        const newItems = prev.items.map(i =>
          i.id === itemId
            ? { ...i, status: result.newStatus as PlanItem['status'], completedAt: result.newStatus === 'completed' ? new Date().toISOString() : null }
            : i
        );
        const completed = newItems.filter(i => i.status === 'completed').length;
        return {
          ...prev,
          items: newItems,
          completedCount: completed,
          progress: Math.round((completed / newItems.length) * 100),
        };
      });
    } catch (err) {
      console.error('Toggle error:', err);
    } finally {
      setTogglingId(null);
    }
  }, []);

  const handleSkip = useCallback(async (itemId: string) => {
    setSkippingId(itemId);
    try {
      await skipPlanItem(itemId);
      setData(prev => {
        if (!prev) return prev;
        return {
          ...prev,
          items: prev.items.map(i =>
            i.id === itemId ? { ...i, status: 'skipped' as const } : i
          ),
        };
      });
    } catch (err) {
      console.error('Skip error:', err);
    } finally {
      setSkippingId(null);
    }
  }, []);

  const handleSaveNote = useCallback(async (itemId: string, note: string) => {
    try {
      await addPlanItemNote(itemId, note);
      setData(prev => {
        if (!prev) return prev;
        return {
          ...prev,
          items: prev.items.map(i =>
            i.id === itemId ? { ...i, notes: note } : i
          ),
        };
      });
    } catch (err) {
      console.error('Note save error:', err);
    }
  }, []);

  const handleGenerate = useCallback(async () => {
    setGenerating(true);
    try {
      await generateWeeklyPlan();
      const result = await getWeeklyPlan();
      setData(result);
    } catch (err: any) {
      console.error('Generate error:', err);
    } finally {
      setGenerating(false);
    }
  }, []);

  // Get today's day number
  const todayNum = (() => {
    const d = new Date().getDay();
    return d === 0 ? 7 : d;
  })();

  // ─── Loading ──────────────────────────────────────────────

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="flex flex-col items-center gap-3">
            <Loader2 className="h-12 w-12 animate-spin" style={{ color: 'var(--color-ai)' }} />
            <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>Cargando tu plan...</p>
          </div>
        </div>
      </AppShell>
    );
  }

  // ─── No plan ──────────────────────────────────────────────

  if (!data) {
    return (
      <AppShell>
        <div className="space-y-8">
          <div>
            <h1 className="font-display text-3xl md:text-4xl mb-2" style={{ color: 'var(--color-text-primary)' }}>
              Plan Semanal
            </h1>
            <p style={{ color: 'var(--color-text-secondary)' }}>
              Tu plan personalizado de actividades para la semana
            </p>
          </div>

          <Card>
            <CardContent className="text-center py-14">
              <motion.div
                initial={{ scale: 0.8, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                transition={{ duration: 0.5 }}
              >
                <CalendarDays className="h-16 w-16 mx-auto mb-4" style={{ color: 'var(--color-cuidado)' }} />
                <h2 className="text-2xl font-semibold mb-2" style={{ color: 'var(--color-text-primary)' }}>Genera tu primer plan</h2>
                <p className="mb-6 max-w-md mx-auto" style={{ color: 'var(--color-text-secondary)' }}>
                  Tu plan semanal incluirá 7 actividades personalizadas basadas en tu perfil relacional.
                  Generadas con IA para enfocarse en tus áreas de crecimiento.
                </p>
                <Button
                  size="lg"
                  onClick={handleGenerate}
                  loading={generating}
                >
                  <Sparkles className="mr-2 h-5 w-5" />
                  Generar plan con IA
                </Button>
              </motion.div>
            </CardContent>
          </Card>
        </div>
      </AppShell>
    );
  }

  // ─── Plan view ────────────────────────────────────────────

  // Stats
  const pendingCount = data.items.filter(i => i.status === 'pending').length;
  const skippedCount = data.items.filter(i => i.status === 'skipped').length;
  const isAI = data.plan.aiModelUsed !== 'template' && data.plan.aiModelUsed !== 'template-fallback';

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
          <div className="flex items-start justify-between">
            <div>
              <h1 className="font-display text-3xl md:text-4xl mb-1" style={{ color: 'var(--color-text-primary)' }}>
                Plan Semanal
              </h1>
              <p className="flex items-center gap-2" style={{ color: 'var(--color-text-secondary)' }}>
                {data.plan.weekLabel}
                {isAI && (
                  <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-medium" style={{ background: 'var(--color-ai-dim)', color: 'var(--color-ai)' }}>
                    <Sparkles className="h-3 w-3" /> IA
                  </span>
                )}
              </p>
            </div>
            <Button
              variant="ghost"
              size="sm"
              className="text-on_surface_variant hover:text-primary"
              onClick={handleGenerate}
              disabled={generating}
            >
              {generating ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <RefreshCw className="h-4 w-4" />
              )}
            </Button>
          </div>
        </motion.div>

        {/* ═══ Progress Section ═══ */}
        <motion.div variants={itemVariants}>
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-6">
                <ProgressRing progress={data.progress} />
                <div className="flex-1 space-y-3">
                  <div>
                    <p className="text-sm text-on_surface_variant mb-1">Progreso de la semana</p>
                    <div className="flex items-baseline gap-1">
                      <span className="text-3xl font-bold text-on_surface">{data.completedCount}</span>
                      <span className="text-on_surface_variant">/ {data.totalCount}</span>
                    </div>
                  </div>

                  <div className="grid grid-cols-3 gap-2">
                    <div className="bg-primary/5 rounded-lg px-2.5 py-1.5 text-center">
                      <p className="text-lg font-bold text-primary">{data.completedCount}</p>
                      <p className="text-[10px] text-on_surface_variant">Hechas</p>
                    </div>
                    <div className="bg-surface_container_low rounded-lg px-2.5 py-1.5 text-center">
                      <p className="text-lg font-bold text-on_surface">{pendingCount}</p>
                      <p className="text-[10px] text-on_surface_variant">Pendientes</p>
                    </div>
                    <div className="bg-surface_container_low rounded-lg px-2.5 py-1.5 text-center">
                      <p className="text-lg font-bold text-on_surface_variant">{skippedCount}</p>
                      <p className="text-[10px] text-on_surface_variant">Omitidas</p>
                    </div>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </motion.div>

        {/* ═══ Day Timeline ═══ */}
        <motion.div variants={itemVariants}>
          <div className="flex gap-1.5 overflow-x-auto pb-2 -mx-1 px-1">
            {data.items.map(item => {
              const isToday = item.dayOfWeek === todayNum;
              const isCompleted = item.status === 'completed';
              const isSkipped = item.status === 'skipped';
              return (
                <button
                  key={item.id}
                  className={`shrink-0 w-11 flex flex-col items-center gap-1 py-2 rounded-xl transition-all`}
                  style={{
                    background: isToday
                      ? 'var(--color-ai)'
                      : isCompleted
                        ? 'var(--color-choque-dim)'
                        : 'var(--color-surface-2)',
                    color: isToday
                      ? 'var(--color-base)'
                      : isCompleted
                        ? 'var(--color-choque)'
                        : 'var(--color-text-tertiary)',
                  }}
                  onClick={() => setExpandedId(prev => prev === item.id ? null : item.id)}
                >
                  <span className="text-[10px] font-medium">{item.dayLabel.slice(0, 3)}</span>
                  {isCompleted ? (
                    <Check className="h-3.5 w-3.5" />
                  ) : isSkipped ? (
                    <SkipForward className="h-3 w-3" />
                  ) : (
                    <span className="text-xs font-bold">{item.dayOfWeek}</span>
                  )}
                </button>
              );
            })}
          </div>
        </motion.div>

        {/* ═══ Activity Cards ═══ */}
        <motion.div className="space-y-3" variants={containerVariants}>
          {data.items.map(item => (
            <PlanItemCard
              key={item.id}
              item={item}
              isToday={item.dayOfWeek === todayNum}
              isExpanded={expandedId === item.id}
              onExpand={() => setExpandedId(prev => prev === item.id ? null : item.id)}
              onToggle={() => handleToggle(item.id)}
              onSkip={() => handleSkip(item.id)}
              onSaveNote={(note) => handleSaveNote(item.id, note)}
              toggling={togglingId === item.id}
              skipping={skippingId === item.id}
            />
          ))}
        </motion.div>

        {/* ═══ Completion celebration ═══ */}
        {data.progress === 100 && (
          <motion.div
            variants={itemVariants}
            initial={{ scale: 0.9, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
          >
            <Card className="overflow-hidden relative" style={{ background: 'var(--color-choque-dim)', border: '1px solid var(--color-border)' }}>
              <CardContent className="pt-8 pb-8 text-center">
                <motion.div
                  animate={{ rotate: [0, 10, -10, 0] }}
                  transition={{ repeat: Infinity, duration: 2, repeatDelay: 3 }}
                >
                  <Trophy className="h-14 w-14 mx-auto mb-3" style={{ color: 'var(--color-success)' }} />
                </motion.div>
                <h2 className="text-2xl font-bold mb-2" style={{ color: 'var(--color-text-primary)' }}>¡Semana completada! 🎉</h2>
                <p className="mb-4 max-w-sm mx-auto" style={{ color: 'var(--color-text-secondary)' }}>
                  Completaron todas las actividades. Su relación agradece este esfuerzo.
                </p>
                <Button
                  onClick={handleGenerate}
                  loading={generating}
                >
                  <RefreshCw className="mr-2 h-4 w-4" />
                  Generar nuevo plan
                </Button>
              </CardContent>
            </Card>
          </motion.div>
        )}

        {/* ═══ Bottom CTA ═══ */}
        <motion.div variants={itemVariants}>
          <Card className="overflow-hidden cursor-pointer transition-all hover:scale-[1.01]" style={{ background: 'var(--color-conexion-dim)', border: '1px solid var(--color-border)' }}>
            <CardContent className="pt-5 pb-5">
              <div className="flex items-center justify-between flex-wrap gap-3">
                <div>
                  <h3 className="font-semibold mb-0.5" style={{ color: 'var(--color-text-primary)' }}>Explora tus dimensiones</h3>
                  <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
                    Ve cómo estas actividades impactan tu mapa de relación.
                  </p>
                </div>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => router.push('/dashboard/nosotros')}
                >
                  Ver Nosotros
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
