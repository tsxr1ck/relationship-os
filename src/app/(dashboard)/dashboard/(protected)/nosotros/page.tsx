'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import {
  Heart, Loader2, ClipboardList, Sparkles, RefreshCw, ChevronDown,
  ChevronUp, Target, BrainCircuit, ShieldAlert, TrendingUp,
  Radar as RadarIcon, List, ArrowRight,
} from 'lucide-react';
import { motion, AnimatePresence, type Variants } from 'framer-motion';
import {
  getNosotrosData,
  generateNosotrosNarrative,
  generateDimensionDeepDive,
  type NosotrosData,
  type NosotrosDimension,
} from './actions';
import { KnowledgeScoreWidget } from '@/components/meconoces/KnowledgeScoreWidget';

// ─── Animation Variants ───────────────────────────────────────

const containerVariants: Variants = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { staggerChildren: 0.08 } },
};

const itemVariants: Variants = {
  hidden: { opacity: 0, y: 24 },
  show: { opacity: 1, y: 0, transition: { type: 'spring', stiffness: 260, damping: 22 } },
};

const expandVariants: Variants = {
  collapsed: { height: 0, opacity: 0 },
  expanded: { height: 'auto', opacity: 1, transition: { duration: 0.35, ease: 'easeOut' } },
};

// ─── Radar Chart Component ────────────────────────────────────

interface RadarChartProps {
  layers: { layer: string; label: string; avgMyScore: number; avgPartnerScore: number | null }[];
  partnerCompleted: boolean;
}

function RadarChart({ layers, partnerCompleted }: RadarChartProps) {
  const size = 280;
  const cx = size / 2;
  const cy = size / 2;
  const radius = 110;
  const levels = 4;
  const angleStep = (2 * Math.PI) / layers.length;

  const getPoint = (index: number, value: number) => {
    const angle = angleStep * index - Math.PI / 2;
    const r = (value / 100) * radius;
    return { x: cx + r * Math.cos(angle), y: cy + r * Math.sin(angle) };
  };

  const myPoints = layers.map((l, i) => getPoint(i, l.avgMyScore));
  const myPath = myPoints.map((p, i) => `${i === 0 ? 'M' : 'L'} ${p.x} ${p.y}`).join(' ') + ' Z';

  let partnerPath = '';
  if (partnerCompleted) {
    const partnerPoints = layers.map((l, i) => getPoint(i, l.avgPartnerScore ?? 50));
    partnerPath = partnerPoints.map((p, i) => `${i === 0 ? 'M' : 'L'} ${p.x} ${p.y}`).join(' ') + ' Z';
  }

  const layerColors: Record<string, string> = {
    conexion: '#E8748A',
    cuidado: '#F2A65A',
    choque: '#5EC4B6',
    camino: '#C9A84C',
  };

  return (
    <svg viewBox={`0 0 ${size} ${size}`} className="w-full max-w-[320px] mx-auto">
      {/* Grid levels */}
      {Array.from({ length: levels }).map((_, li) => {
        const r = ((li + 1) / levels) * radius;
        const points = layers
          .map((_, i) => {
            const angle = angleStep * i - Math.PI / 2;
            return `${cx + r * Math.cos(angle)},${cy + r * Math.sin(angle)}`;
          })
          .join(' ');
        return (
          <polygon
            key={li}
            points={points}
            fill="none"
            stroke="var(--color-border)"
            strokeWidth="0.5"
          />
        );
      })}

      {/* Axis lines */}
      {layers.map((_, i) => {
        const p = getPoint(i, 100);
        return (
          <line
            key={i}
            x1={cx}
            y1={cy}
            x2={p.x}
            y2={p.y}
            stroke="var(--color-border)"
            strokeOpacity={0.5}
            strokeWidth="0.5"
          />
        );
      })}

      {/* Partner polygon */}
      {partnerCompleted && partnerPath && (
        <motion.path
          d={partnerPath}
          fill="rgba(242,166,90,0.08)"
          stroke="rgba(242,166,90,0.5)"
          strokeWidth="1.5"
          strokeDasharray="6 3"
          initial={{ opacity: 0, scale: 0.3 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.8, delay: 0.4 }}
          style={{ transformOrigin: `${cx}px ${cy}px` }}
        />
      )}

      {/* My polygon */}
      <motion.path
        d={myPath}
        fill="rgba(232,116,138,0.15)"
        stroke="rgba(232,116,138,0.8)"
        strokeWidth="2"
        initial={{ opacity: 0, scale: 0.2 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.7, delay: 0.2 }}
        style={{ transformOrigin: `${cx}px ${cy}px` }}
      />

      {/* Score dots + labels */}
      {layers.map((l, i) => {
        const p = getPoint(i, l.avgMyScore);
        const labelP = getPoint(i, 118);
        const color = layerColors[l.layer] || '#a78bfa';
        return (
          <g key={l.layer}>
            <motion.circle
              cx={p.x}
              cy={p.y}
              r="4"
              fill={color}
              stroke="var(--color-surface-1)"
              strokeWidth="2"
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.5 + i * 0.1 }}
            />
            <text
              x={labelP.x}
              y={labelP.y}
              textAnchor="middle"
              dominantBaseline="middle"
              fill="var(--color-text-tertiary)"
              style={{ fontSize: '10px', fontWeight: 500 }}
            >
              {l.label}
            </text>
          </g>
        );
      })}

      {/* Center score */}
      <text
        x={cx}
        y={cy - 6}
        textAnchor="middle"
        dominantBaseline="middle"
        fill="var(--color-text-primary)"
        style={{ fontSize: '22px', fontWeight: 700 }}
      >
        {Math.round(layers.reduce((a, l) => a + l.avgMyScore, 0) / layers.length)}%
      </text>
      <text
        x={cx}
        y={cy + 12}
        textAnchor="middle"
        dominantBaseline="middle"
        fill="var(--color-text-tertiary)"
        style={{ fontSize: '9px' }}
      >
        salud general
      </text>
    </svg>
  );
}

// ─── Dimension Card Component ─────────────────────────────────

interface DimensionCardProps {
  dim: NosotrosDimension;
  partnerCompleted: boolean;
  isExpanded: boolean;
  onToggle: () => void;
  coaching: string | null;
  loadingCoaching: boolean;
  onGenerateCoaching: () => void;
}

const LAYER_COLORS_MAP: Record<string, { color: string; dim: string }> = {
  conexion: { color: 'var(--color-conexion)', dim: 'var(--color-conexion-dim)' },
  cuidado: { color: 'var(--color-cuidado)', dim: 'var(--color-cuidado-dim)' },
  choque: { color: 'var(--color-choque)', dim: 'var(--color-choque-dim)' },
  camino: { color: 'var(--color-camino)', dim: 'var(--color-camino-dim)' },
};

// Legacy compat - used by class-based references
const LAYER_COLORS: Record<string, string> = {
  conexion: 'bg-conexion',
  cuidado: 'bg-cuidado',
  choque: 'bg-choque',
  camino: 'bg-camino',
};

const LAYER_BG: Record<string, string> = {
  conexion: 'bg-conexion-dim',
  cuidado: 'bg-cuidado-dim',
  choque: 'bg-choque-dim',
  camino: 'bg-camino-dim',
};

const LAYER_TEXT: Record<string, string> = {
  conexion: 'text-conexion',
  cuidado: 'text-cuidado',
  choque: 'text-choque',
  camino: 'text-camino',
};

function DimensionCard({
  dim,
  partnerCompleted,
  isExpanded,
  onToggle,
  coaching,
  loadingCoaching,
  onGenerateCoaching,
}: DimensionCardProps) {
  return (
    <Card className="overflow-hidden transition-shadow hover:shadow-md">
      <CardContent className="pt-0 pb-0">
        {/* Header — always visible */}
        <button
          className="w-full flex items-center gap-3 py-4 text-left"
          onClick={onToggle}
        >
          <div className={`w-10 h-10 rounded-xl ${LAYER_BG[dim.layer]} flex items-center justify-center shrink-0`}>
            <div className={`w-3 h-3 rounded-full ${LAYER_COLORS[dim.layer]}`} />
          </div>
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2">
              <span className="font-semibold text-on_surface truncate">{dim.label}</span>
              {dim.riskFlag && (
                <span className="px-1.5 py-0.5 bg-red-100 text-red-600 rounded text-[10px] font-medium animate-pulse">
                  Riesgo
                </span>
              )}
              {dim.opportunityFlag && (
                <span className="px-1.5 py-0.5 bg-emerald-100 text-emerald-600 rounded text-[10px] font-medium">
                  Oportunidad
                </span>
              )}
            </div>
            {/* Mini score bar */}
            <div className="h-1.5 bg-surface_container_low rounded-full mt-2 overflow-hidden">
              <motion.div
                className={`h-full ${LAYER_COLORS[dim.layer]} rounded-full`}
                initial={{ width: 0 }}
                animate={{ width: `${dim.myScore}%` }}
                transition={{ duration: 0.6, delay: 0.1 }}
              />
            </div>
          </div>
          <span className="text-lg font-bold text-on_surface tabular-nums">{dim.myScore}%</span>
          {isExpanded ? (
            <ChevronUp className="h-5 w-5 text-on_surface_variant shrink-0" />
          ) : (
            <ChevronDown className="h-5 w-5 text-on_surface_variant shrink-0" />
          )}
        </button>

        {/* Expanded content */}
        <AnimatePresence>
          {isExpanded && (
            <motion.div
              variants={expandVariants}
              initial="collapsed"
              animate="expanded"
              exit="collapsed"
              className="overflow-hidden"
            >
              <div className="pb-5 pt-1 space-y-4 border-t border-outline_variant/20">
                {/* Score comparison */}
                <div className="space-y-2.5 pt-3">
                  <div>
                    <div className="flex justify-between text-sm mb-1">
                      <span className="text-on_surface_variant">Tú</span>
                      <span className="font-medium text-on_surface">{dim.myScore}%</span>
                    </div>
                    <div className="h-2.5 bg-surface_container_low rounded-full overflow-hidden">
                      <motion.div
                        className={`h-full ${LAYER_COLORS[dim.layer]} rounded-full`}
                        initial={{ width: 0 }}
                        animate={{ width: `${dim.myScore}%` }}
                        transition={{ duration: 0.5 }}
                      />
                    </div>
                  </div>

                  {partnerCompleted && dim.partnerScore !== null ? (
                    <div>
                      <div className="flex justify-between text-sm mb-1">
                        <span className="text-on_surface_variant">Tu pareja</span>
                        <span className="font-medium text-on_surface">{dim.partnerScore}%</span>
                      </div>
                      <div className="h-2.5 bg-surface_container_low rounded-full overflow-hidden">
                        <motion.div
                          className={`h-full ${LAYER_COLORS[dim.layer]}/50 rounded-full`}
                          initial={{ width: 0 }}
                          animate={{ width: `${dim.partnerScore}%` }}
                          transition={{ duration: 0.5, delay: 0.15 }}
                        />
                      </div>
                    </div>
                  ) : (
                    <p className="text-xs text-on_surface_variant italic">
                      Pareja aún no ha completado la evaluación
                    </p>
                  )}

                  {dim.mismatchDelta !== null && (
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-xs text-on_surface_variant">Diferencia:</span>
                      <span className={`text-xs font-medium ${
                        Math.abs(dim.mismatchDelta) > 30 ? 'text-red-500' :
                        Math.abs(dim.mismatchDelta) > 15 ? 'text-orange-500' :
                        'text-emerald-500'
                      }`}>
                        {Math.abs(dim.mismatchDelta).toFixed(0)} puntos
                      </span>
                    </div>
                  )}
                </div>

                {/* AI Coaching */}
                <div className="bg-surface_container_low/50 rounded-xl p-4">
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-1.5">
                      <Sparkles className="h-4 w-4 text-primary" />
                      <span className="text-xs font-medium text-primary">Coaching IA</span>
                    </div>
                    {coaching && !loadingCoaching && (
                      <button
                        className="flex items-center gap-1 text-xs text-on_surface_variant hover:text-primary transition-colors"
                        onClick={(e) => { e.stopPropagation(); onGenerateCoaching(); }}
                      >
                        <RefreshCw className="h-3 w-3" />
                        Regenerar
                      </button>
                    )}
                  </div>

                  {loadingCoaching ? (
                    <div className="flex items-center gap-2 py-3">
                      <Loader2 className="h-4 w-4 text-primary animate-spin" />
                      <span className="text-sm text-on_surface_variant">Generando coaching...</span>
                    </div>
                  ) : coaching ? (
                    <div className="text-sm text-on_surface_variant leading-relaxed space-y-2">
                      {coaching
                        .split('\n')
                        .filter(p => p.trim())
                        .map((paragraph, i) => (
                          <p key={i}>{paragraph}</p>
                        ))}
                    </div>
                  ) : (
                    <button
                      className="flex items-center gap-2 text-sm text-primary hover:underline"
                      onClick={(e) => { e.stopPropagation(); onGenerateCoaching(); }}
                    >
                      <BrainCircuit className="h-4 w-4" />
                      Generar análisis con IA
                    </button>
                  )}
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </CardContent>
    </Card>
  );
}

// ─── Main Page Component ──────────────────────────────────────

export default function NosotrosPage() {
  const router = useRouter();
  const [data, setData] = useState<NosotrosData | null>(null);
  const [loading, setLoading] = useState(true);
  const [viewMode, setViewMode] = useState<'radar' | 'list'>('radar');
  const [expandedDim, setExpandedDim] = useState<string | null>(null);

  // AI states
  const [narrativeLoading, setNarrativeLoading] = useState(false);
  const [coachingLoading, setCoachingLoading] = useState<Record<string, boolean>>({});
  const [coachingCache, setCoachingCache] = useState<Record<string, string>>({});

  // Load initial data
  useEffect(() => {
    async function load() {
      try {
        const result = await getNosotrosData();
        setData(result);

        // Pre-populate coaching cache from loaded data
        const cache: Record<string, string> = {};
        result.dimensions.forEach(d => {
          if (d.coaching) cache[d.slug] = d.coaching;
        });
        setCoachingCache(cache);
      } catch (err) {
        console.error('Error loading nosotros:', err);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  // Generate narrative
  const handleGenerateNarrative = useCallback(async (force = false) => {
    if (narrativeLoading) return;
    setNarrativeLoading(true);
    try {
      const result = await generateNosotrosNarrative(force);
      setData(prev => {
        if (!prev) return prev;
        return {
          ...prev,
          narrative: {
            relationshipStory: result.relationshipStory,
            layerSummaries: result.layerSummaries,
            growthTips: result.growthTips,
          },
          layers: prev.layers.map(l => ({
            ...l,
            aiSummary: result.layerSummaries[l.layer] ?? l.aiSummary,
          })),
        };
      });
    } catch (err) {
      console.error('Narrative generation error:', err);
    } finally {
      setNarrativeLoading(false);
    }
  }, [narrativeLoading]);

  // Generate per-dimension coaching
  const handleGenerateCoaching = useCallback(async (slug: string, force = false) => {
    if (coachingLoading[slug]) return;
    setCoachingLoading(prev => ({ ...prev, [slug]: true }));
    try {
      const result = await generateDimensionDeepDive(slug, force);
      if (result.coaching) {
        setCoachingCache(prev => ({ ...prev, [slug]: result.coaching }));
      }
    } catch (err) {
      console.error('Coaching generation error:', err);
    } finally {
      setCoachingLoading(prev => ({ ...prev, [slug]: false }));
    }
  }, [coachingLoading]);

  // ─── Loading state ────────────────────────────────────────

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="flex flex-col items-center gap-3">
            <Loader2 className="h-12 w-12 animate-spin" style={{ color: 'var(--color-ai)' }} />
            <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>Cargando tu mapa de relación...</p>
          </div>
        </div>
      </AppShell>
    );
  }

  // ─── No data state ────────────────────────────────────────

  if (!data || data.dimensions.length === 0) {
    return (
      <AppShell>
        <div className="space-y-8">
          <div>
            <h1 className="font-display text-3xl md:text-4xl mb-2" style={{ color: 'var(--color-text-primary)' }}>Nosotros</h1>
            <p style={{ color: 'var(--color-text-secondary)' }}>El mapa de tu relación</p>
          </div>
          <Card>
            <CardContent className="text-center py-12">
              <ClipboardList className="h-16 w-16 mx-auto mb-4" style={{ color: 'var(--color-text-tertiary)' }} />
              <h2 className="text-2xl font-semibold mb-2" style={{ color: 'var(--color-text-primary)' }}>Aún no tienes resultados</h2>
              <p className="mb-6 max-w-md mx-auto" style={{ color: 'var(--color-text-secondary)' }}>
                Completa la evaluación para ver tu mapa de conexión y las dimensiones de tu relación.
              </p>
              <Button
                onClick={() => router.push('/dashboard/questionnaire')}
              >
                Comenzar evaluación
              </Button>
            </CardContent>
          </Card>
        </div>
      </AppShell>
    );
  }

  // ─── Group dimensions by layer for list view ──────────────

  const dimsByLayer: Record<string, NosotrosDimension[]> = {};
  data.dimensions.forEach(d => {
    if (!dimsByLayer[d.layer]) dimsByLayer[d.layer] = [];
    dimsByLayer[d.layer].push(d);
  });

  return (
    <AppShell>
      <motion.div
        className="space-y-8"
        variants={containerVariants}
        initial="hidden"
        animate="show"
      >
        {/* ═══ Section 1: Hero Banner ═══ */}
        <motion.div variants={itemVariants}>
          <Card className="overflow-hidden relative" style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}>
            <div className="absolute inset-0" style={{ background: 'radial-gradient(ellipse at 20% 50%, var(--color-conexion-glow) 0%, transparent 60%), radial-gradient(ellipse at 80% 50%, var(--color-ai-glow) 0%, transparent 60%)' }} />
            <CardContent className="relative z-10 pt-8 pb-8">
              <div className="flex items-center justify-center gap-2 mb-2">
                <Heart className="h-5 w-5" style={{ color: 'var(--color-conexion)' }} />
                <span className="text-xs font-bold tracking-[0.15em] uppercase" style={{ color: 'var(--color-conexion)' }}>
                  Nosotros
                </span>
              </div>

              {data.partnerName ? (
                <h1 className="font-display text-2xl md:text-3xl text-center mb-1" style={{ color: 'var(--color-text-primary)' }}>
                  {data.myName} & {data.partnerName}
                </h1>
              ) : (
                <h1 className="font-display text-2xl md:text-3xl text-center mb-1" style={{ color: 'var(--color-text-primary)' }}>
                  Tu mapa de relación
                </h1>
              )}

              {data.relationshipDuration && (
                <p className="text-center text-sm mb-6" style={{ color: 'var(--color-text-tertiary)' }}>
                  {data.relationshipDuration}
                </p>
              )}

              {/* AI Narrative */}
              {data.narrative.relationshipStory ? (
                <div className="max-w-lg mx-auto">
                  <div className="flex items-center justify-center gap-1.5 mb-3">
                    <Sparkles className="h-3.5 w-3.5" style={{ color: 'var(--color-ai)' }} />
                    <span className="text-xs font-medium" style={{ color: 'var(--color-ai)' }}>Nuestra Historia — IA</span>
                  </div>
                  <p className="text-center leading-relaxed text-sm font-display italic" style={{ color: 'var(--color-text-secondary)' }}>
                    {data.narrative.relationshipStory}
                  </p>
                  <div className="flex justify-center mt-4">
                    <button
                      className="flex items-center gap-1.5 text-xs transition-colors"
                      style={{ color: 'var(--color-text-tertiary)' }}
                      onClick={() => handleGenerateNarrative(true)}
                      disabled={narrativeLoading}
                    >
                      {narrativeLoading ? (
                        <Loader2 className="h-3 w-3 animate-spin" />
                      ) : (
                        <RefreshCw className="h-3 w-3" />
                      )}
                      Regenerar historia
                    </button>
                  </div>
                </div>
              ) : (
                <div className="flex justify-center mt-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => handleGenerateNarrative(false)}
                    disabled={narrativeLoading}
                  >
                    {narrativeLoading ? (
                      <>
                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                        Generando...
                      </>
                    ) : (
                      <>
                        <BrainCircuit className="mr-2 h-4 w-4" />
                        Generar nuestra historia con IA
                      </>
                    )}
                  </Button>
                </div>
              )}
            </CardContent>
          </Card>
        </motion.div>

        {/* ═══ Section 2: View Switcher + Radar/List ═══ */}
        <motion.div variants={itemVariants}>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-semibold" style={{ color: 'var(--color-text-primary)' }}>Dimensiones</h2>
            <div className="flex gap-1 p-0.5 rounded-lg" style={{ background: 'var(--color-surface-2)' }}>
              <button
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-medium transition-all`}
                style={viewMode === 'radar' ? {
                  background: 'var(--color-surface-3)',
                  color: 'var(--color-text-primary)',
                } : {
                  color: 'var(--color-text-tertiary)',
                }}
                onClick={() => setViewMode('radar')}
              >
                <RadarIcon className="h-3.5 w-3.5" />
                Radar
              </button>
              <button
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-medium transition-all`}
                style={viewMode === 'list' ? {
                  background: 'var(--color-surface-3)',
                  color: 'var(--color-text-primary)',
                } : {
                  color: 'var(--color-text-tertiary)',
                }}
                onClick={() => setViewMode('list')}
              >
                <List className="h-3.5 w-3.5" />
                Lista
              </button>
            </div>
          </div>
        </motion.div>

        {/* Radar View */}
        {viewMode === 'radar' && (
          <motion.div variants={itemVariants}>
            <Card>
              <CardContent className="pt-6 pb-6">
                <RadarChart layers={data.layers} partnerCompleted={data.partnerCompleted} />

                {/* Legend */}
                <div className="flex items-center justify-center gap-6 mt-4 text-xs text-on_surface_variant">
                  <div className="flex items-center gap-1.5">
                    <div className="w-3 h-1.5 rounded-full" style={{ background: 'var(--color-conexion)' }} />
                    <span>Tú</span>
                  </div>
                  {data.partnerCompleted && (
                    <div className="flex items-center gap-1.5">
                      <div className="w-3 h-1.5 rounded-full opacity-50" style={{ background: 'var(--color-cuidado)', borderTop: '1px dashed' }} />
                      <span>{data.partnerName}</span>
                    </div>
                  )}
                </div>

                {/* Layer score pills */}
                <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mt-6">
                  {data.layers.map(l => (
                    <div
                      key={l.layer}
                      className={`flex items-center gap-2 px-3 py-2.5 rounded-xl ${LAYER_BG[l.layer]} cursor-pointer transition-transform hover:scale-[1.02]`}
                      onClick={() => {
                        setViewMode('list');
                        const firstDim = dimsByLayer[l.layer]?.[0];
                        if (firstDim) setExpandedDim(firstDim.slug);
                      }}
                    >
                      <span className="text-lg">{l.icon}</span>
                      <div className="min-w-0">
                        <p className={`text-xs font-medium ${LAYER_TEXT[l.layer]} truncate`}>{l.label}</p>
                        <p className="text-sm font-bold text-on_surface">{l.avgMyScore}%</p>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Layer AI summaries */}
                {Object.values(data.narrative.layerSummaries).some(Boolean) && (
                  <div className="mt-6 space-y-3">
                    {data.layers.map(l => {
                      const summary = data.narrative.layerSummaries[l.layer];
                      if (!summary) return null;
                      return (
                        <div key={l.layer} className="flex items-start gap-2.5 text-sm">
                          <span className="text-base shrink-0 mt-0.5">{l.icon}</span>
                          <p className="text-on_surface_variant leading-relaxed">{summary}</p>
                        </div>
                      );
                    })}
                  </div>
                )}
              </CardContent>
            </Card>
          </motion.div>
        )}

        {/* List View: Dimension Cards grouped by layer */}
        {viewMode === 'list' && (
          <motion.div variants={itemVariants} className="space-y-6">
            {['conexion', 'cuidado', 'choque', 'camino'].map(layer => {
              const dims = dimsByLayer[layer] || [];
              if (dims.length === 0) return null;
              const meta = data.layers.find(l => l.layer === layer);
              return (
                <div key={layer}>
                  <div className="flex items-center gap-2 mb-3">
                    <span className="text-lg">{meta?.icon}</span>
                    <h3 className={`text-sm font-semibold ${LAYER_TEXT[layer]}`}>
                      {meta?.label} — {meta?.avgMyScore}%
                    </h3>
                  </div>
                  <div className="space-y-2">
                    {dims.map(dim => (
                      <DimensionCard
                        key={dim.slug}
                        dim={dim}
                        partnerCompleted={data.partnerCompleted}
                        isExpanded={expandedDim === dim.slug}
                        onToggle={() =>
                          setExpandedDim(prev => (prev === dim.slug ? null : dim.slug))
                        }
                        coaching={coachingCache[dim.slug] ?? null}
                        loadingCoaching={coachingLoading[dim.slug] ?? false}
                        onGenerateCoaching={() => handleGenerateCoaching(dim.slug, !!coachingCache[dim.slug])}
                      />
                    ))}
                  </div>
                </div>
              );
            })}
          </motion.div>
        )}

        {/* ═══ Section 4: AI Growth Tips ═══ */}
        {data.narrative.growthTips.length > 0 && (
          <motion.div variants={itemVariants}>
            <Card className="border border-primary/10">
              <CardContent className="pt-5">
                <div className="flex items-center gap-2 mb-4">
                  <div className="w-8 h-8 rounded-lg bg-primary/15 flex items-center justify-center">
                    <Target className="h-4 w-4 text-primary" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-on_surface">Acciones para esta semana</h3>
                    <span className="text-xs text-primary flex items-center gap-1">
                      <Sparkles className="h-3 w-3" /> Personalizadas por IA
                    </span>
                  </div>
                </div>
                <ul className="space-y-3">
                  {data.narrative.growthTips.map((tip, i) => (
                    <li key={i} className="flex items-start gap-3 text-sm text-on_surface">
                      <span className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
                        {i + 1}
                      </span>
                      <span className="leading-relaxed">{tip}</span>
                    </li>
                  ))}
                </ul>
              </CardContent>
            </Card>
          </motion.div>
        )}

        {/* Generate narrative CTA if nothing is cached */}
        {!data.narrative.relationshipStory && data.narrative.growthTips.length === 0 && (
          <motion.div variants={itemVariants}>
            <Card className="border border-primary/20">
              <CardContent className="py-8 text-center">
                <BrainCircuit className="h-10 w-10 text-primary mx-auto mb-3" />
                <h3 className="font-semibold text-on_surface mb-1">Desbloquea tu análisis con IA</h3>
                <p className="text-sm text-on_surface_variant mb-4 max-w-sm mx-auto">
                  Genera tu historia de pareja, resúmenes por dimensión y acciones personalizadas.
                </p>
                <Button
                  onClick={() => handleGenerateNarrative(false)}
                  disabled={narrativeLoading}
                >
                  {narrativeLoading ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Generando...
                    </>
                  ) : (
                    <>
                      <Sparkles className="mr-2 h-4 w-4" />
                      Generar con IA
                    </>
                  )}
                </Button>
              </CardContent>
            </Card>
          </motion.div>
        )}

        {/* ═══ Section 5: Risk/Opportunity Summary ═══ */}
        {(data.dimensions.some(d => d.riskFlag) || data.dimensions.some(d => d.opportunityFlag)) && (
          <motion.div variants={itemVariants} className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {data.dimensions.some(d => d.riskFlag) && (
              <Card style={{ border: '1px solid rgba(248, 113, 113, 0.2)' }}>
                <CardContent className="pt-5">
                  <div className="flex items-center gap-2 mb-3">
                    <div className="w-8 h-8 rounded-lg flex items-center justify-center" style={{ background: 'rgba(248, 113, 113, 0.15)' }}>
                      <ShieldAlert className="h-4 w-4" style={{ color: 'var(--color-danger)' }} />
                    </div>
                    <h4 className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>Áreas de atención</h4>
                  </div>
                  <ul className="space-y-2">
                    {data.dimensions
                      .filter(d => d.riskFlag)
                      .map(d => (
                        <li key={d.slug} className="flex items-center gap-2 text-sm text-on_surface">
                          <div className={`w-2 h-2 rounded-full ${LAYER_COLORS[d.layer]}`} />
                          {d.label}
                          <span className="text-on_surface_variant ml-auto">
                            {d.mismatchDelta !== null ? `Δ ${Math.abs(d.mismatchDelta).toFixed(0)}` : ''}
                          </span>
                        </li>
                      ))}
                  </ul>
                </CardContent>
              </Card>
            )}

            {data.dimensions.some(d => d.opportunityFlag) && (
              <Card style={{ border: '1px solid rgba(74, 222, 128, 0.2)' }}>
                <CardContent className="pt-5">
                  <div className="flex items-center gap-2 mb-3">
                    <div className="w-8 h-8 rounded-lg flex items-center justify-center" style={{ background: 'rgba(74, 222, 128, 0.15)' }}>
                      <TrendingUp className="h-4 w-4" style={{ color: 'var(--color-success)' }} />
                    </div>
                    <h4 className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>Oportunidades de crecimiento</h4>
                  </div>
                  <ul className="space-y-2">
                    {data.dimensions
                      .filter(d => d.opportunityFlag)
                      .map(d => (
                        <li key={d.slug} className="flex items-center gap-2 text-sm text-on_surface">
                          <div className={`w-2 h-2 rounded-full ${LAYER_COLORS[d.layer]}`} />
                          {d.label}
                        </li>
                      ))}
                  </ul>
                </CardContent>
              </Card>
            )}
          </motion.div>
        )}

        {/* ═══ Section 6: Knowledge Scores ═══ */}
        <motion.div variants={itemVariants}>
          <KnowledgeScoreWidget />
        </motion.div>

        {/* ═══ Section 7: Bottom CTA ═══ */}
        <motion.div variants={itemVariants}>
          <Card className="overflow-hidden cursor-pointer transition-all hover:scale-[1.01]" style={{ background: 'var(--color-cuidado-dim)', border: '1px solid var(--color-border)' }}>
            <CardContent className="pt-6 pb-6">
              <div className="flex items-center justify-between flex-wrap gap-4">
                <div>
                  <h3 className="text-lg font-semibold mb-1" style={{ color: 'var(--color-text-primary)' }}>¿Listos para actuar?</h3>
                  <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
                    Ve tu plan semanal con actividades personalizadas para crecer juntos.
                  </p>
                </div>
                <Button
                  variant="outline"
                  onClick={() => router.push('/dashboard/plan')}
                >
                  Ver plan semanal
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
