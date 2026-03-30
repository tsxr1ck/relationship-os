'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { InteractivePlanItem } from '@/components/dashboard/InteractivePlanItem';
import { Calendar, Heart, Loader2, Sparkles, Award, ChevronRight, Lightbulb, ArrowRight, Flame } from 'lucide-react';
import { motion, type Variants } from 'framer-motion';
import { getDashboardData, type DashboardData } from '../queries';

const containerVariants: Variants = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { staggerChildren: 0.08 } }
};

const itemVariants: Variants = {
  hidden: { opacity: 0, y: 24 },
  show: { opacity: 1, y: 0, transition: { type: "spring", stiffness: 260, damping: 22 } }
};

const DIMENSION_CONFIG = {
  conexion: {
    label: 'Conexión',
    color: 'var(--color-conexion)',
    dimBg: 'var(--color-conexion-dim)',
    glow: 'var(--color-conexion-glow)',
  },
  cuidado: {
    label: 'Cuidado',
    color: 'var(--color-cuidado)',
    dimBg: 'var(--color-cuidado-dim)',
    glow: 'var(--color-cuidado-glow)',
  },
  choque: {
    label: 'Conflicto',
    color: 'var(--color-choque)',
    dimBg: 'var(--color-choque-dim)',
    glow: 'var(--color-choque-glow)',
  },
  camino: {
    label: 'Camino',
    color: 'var(--color-camino)',
    dimBg: 'var(--color-camino-dim)',
    glow: 'var(--color-camino-glow)',
  },
} as const;

// Animated counter hook
function useCountUp(target: number, duration: number = 800) {
  const [value, setValue] = useState(0);
  useEffect(() => {
    if (target === 0) return;
    const start = performance.now();
    const animate = (now: number) => {
      const elapsed = now - start;
      const progress = Math.min(elapsed / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3); // easeOutCubic
      setValue(Math.round(eased * target));
      if (progress < 1) requestAnimationFrame(animate);
    };
    requestAnimationFrame(animate);
  }, [target, duration]);
  return value;
}

export default function DashboardPage() {
  const router = useRouter();
  const [data, setData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  // Compute overallHealth early (before hooks that depend on it)
  const hasScoresEarly = !!(data?.scores && Object.keys(data.scores).length > 0);
  let overallHealth = 0;
  if (hasScoresEarly && data?.scores) {
    const s = data.scores;
    overallHealth = Math.round(((s.conexion + s.cuidado + s.camino + s.choque) / 4) * 100);
  }
  const animatedHealth = useCountUp(overallHealth);

  useEffect(() => {
    async function load() {
      try {
        const dashData = await getDashboardData();
        setData(dashData);
      } catch (err: any) {
        console.error('Dashboard load error:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="text-center">
            <Loader2 className="h-12 w-12 mx-auto mb-4 animate-spin" style={{ color: 'var(--color-ai)' }} />
            <p style={{ color: 'var(--color-text-secondary)' }}>Cargando tu ecosistema...</p>
          </div>
        </div>
      </AppShell>
    );
  }

  if (error || !data) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="text-center">
            <p className="mb-4 font-medium" style={{ color: 'var(--color-text-secondary)' }}>{error || 'Error cargando datos'}</p>
            <button
              className="px-6 py-2 rounded-xl font-bold transition-colors"
              style={{ background: 'var(--color-surface-2)', color: 'var(--color-text-primary)', border: '1px solid var(--color-border-glow)' }}
              onClick={() => window.location.reload()}
            >Reintentar</button>
          </div>
        </div>
      </AppShell>
    );
  }

  const hasScores = hasScoresEarly;
  const hasCouple = data.couple !== null;

  // Compatibility Status Logic
  const getCompatibilityStatus = (score: number) => {
    if (score >= 90) return { label: 'Alma Gemela', emoji: '💎', color: 'var(--color-conexion)' };
    if (score >= 80) return { label: 'En Sintonía', emoji: '🔥', color: 'var(--color-cuidado)' };
    if (score >= 70) return { label: 'Creciendo', emoji: '🌱', color: 'var(--color-camino)' };
    if (score >= 50) return { label: 'Construyendo', emoji: '🛠️', color: 'var(--color-text-secondary)' };
    return { label: 'Estabilizando', emoji: '⚓', color: 'var(--color-choque)' };
  };

  const status = getCompatibilityStatus(animatedHealth);

  // Today's task logic
  // ... (rest of the logic remains same)
  let todaysItemRaw = null;
  if (data.weeklyPlan && data.weeklyPlan.items?.length > 0) {
    const todayNum = new Date().getDay() || 7;
    todaysItemRaw = data.weeklyPlan.items.find((i: any) => i.day_of_week === todayNum && i.status === 'pending');
    if (!todaysItemRaw) {
      todaysItemRaw = data.weeklyPlan.items.find((i: any) => i.status === 'pending');
    }
  }

  let todaysItemMapped = null;
  if (todaysItemRaw) {
    todaysItemMapped = {
      id: todaysItemRaw.id,
      dayOfWeek: todaysItemRaw.day_of_week,
      dayLabel: todaysItemRaw.day_label,
      title: todaysItemRaw.title,
      description: todaysItemRaw.description,
      dimensionLabel: typeof todaysItemRaw.dimension === 'string'
        ? todaysItemRaw.dimension.charAt(0).toUpperCase() + todaysItemRaw.dimension.slice(1)
        : '',
      activityType: todaysItemRaw.activity_type,
      durationMinutes: todaysItemRaw.duration_minutes,
      difficulty: todaysItemRaw.difficulty,
      status: todaysItemRaw.status,
    };
  }

  // Dynamic CTA
  let copilotCta = "Analizar Resultados";
  let copilotAction = '/dashboard/nosotros';

  if (!data.onboardingCompleted) {
    copilotCta = "Completar Onboarding";
    copilotAction = "/onboarding";
  } else if (!hasCouple) {
    copilotCta = "Invitar a mi pareja";
    copilotAction = "/couple/create";
  } else if (data.questionnaireStatus !== 'completed') {
    copilotCta = "Continuar Evaluación";
    copilotAction = "/dashboard/nosotros";
  } else if (data.activeChallenge) {
    copilotCta = "Ver Reto Activo";
    copilotAction = "/dashboard/retos";
  } else if (data.weeklyPlan && !todaysItemRaw) {
    copilotCta = "Revisar Progreso";
    copilotAction = "/dashboard/plan";
  }

  return (
    <AppShell>
      <motion.div
        className="space-y-6 md:space-y-8 pb-10"
        variants={containerVariants}
        initial="hidden"
        animate="show"
      >
        {/* ═══ RELATIONSHIP PULSE HERO ═══ */}
        <motion.section
          variants={itemVariants}
          className="relative overflow-hidden rounded-3xl"
          style={{
            height: 'auto',
            minHeight: '240px',
            background: `
              radial-gradient(ellipse at 20% 50%, ${DIMENSION_CONFIG.camino.glow} 0%, transparent 60%),
              radial-gradient(ellipse at 80% 50%, ${DIMENSION_CONFIG.conexion.glow} 0%, transparent 60%),
              var(--color-surface-1)
            `,
            border: '1px solid var(--color-border)',
          }}
        >
          {/* Noise overlay */}
          <div className="absolute inset-0 opacity-[0.03]" style={{
            backgroundImage: `url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E")`,
          }} />

          <div className="relative z-10 p-6 md:p-8 flex flex-col md:flex-row items-center gap-6 md:gap-10">
            {/* Left: Avatar pair + names */}
            <div className="flex flex-col items-center md:items-start gap-4 flex-1">
              <div className="flex items-center -space-x-4">
                <div
                  className="w-14 h-14 rounded-full flex items-center justify-center text-xl font-bold overflow-hidden z-10 animate-glow-ring"
                  style={{
                    background: 'var(--color-surface-2)',
                    color: 'var(--color-text-primary)',
                    border: '2px solid var(--color-conexion)',
                  }}
                  onClick={() => router.push('/dashboard/profile')}
                >
                  {data.user.avatarUrl ? (
                    <img src={data.user.avatarUrl} alt="User" className="w-full h-full object-cover" />
                  ) : (
                    data.user.displayName.charAt(0).toUpperCase()
                  )}
                </div>

                <svg width="32" height="20" viewBox="0 0 32 20" className="z-20 -mx-2" style={{ filter: 'drop-shadow(0 0 4px var(--color-conexion))' }}>
                  <motion.path
                    d="M0 10 L8 10 L12 3 L16 17 L20 7 L24 10 L32 10"
                    fill="none"
                    stroke="var(--color-conexion)"
                    strokeWidth="1.5"
                    strokeLinecap="round"
                    initial={{ pathLength: 0 }}
                    animate={{ pathLength: 1 }}
                    transition={{ duration: 1.5, ease: "easeOut", delay: 0.3 }}
                  />
                </svg>

                {data.partner ? (
                  <div
                    className="w-14 h-14 rounded-full flex items-center justify-center text-xl font-bold overflow-hidden"
                    style={{
                      background: 'var(--color-surface-2)',
                      color: 'var(--color-text-primary)',
                      border: '2px solid var(--color-cuidado)',
                    }}
                  >
                    {data.partner.avatarUrl ? (
                      <img src={data.partner.avatarUrl} alt="Partner" className="w-full h-full object-cover" />
                    ) : (
                      data.partner.displayName.charAt(0).toUpperCase()
                    )}
                  </div>
                ) : (
                  <div
                    className="w-14 h-14 rounded-full flex items-center justify-center cursor-pointer transition-colors"
                    style={{
                      background: 'var(--color-surface-3)',
                      color: 'var(--color-text-tertiary)',
                      border: '2px dashed var(--color-border)',
                    }}
                    onClick={() => router.push('/couple/create')}
                  >
                    +
                  </div>
                )}
              </div>

              <div className="text-center md:text-left">
                <h1 className="font-display text-3xl md:text-4xl" style={{ color: 'var(--color-text-primary)' }}>
                  {data.partner
                    ? `${data.user.displayName.split(' ')[0]} & ${data.partner.displayName.split(' ')[0]}`
                    : data.user.displayName.split(' ')[0]}
                </h1>
                <p className="text-sm mt-1" style={{ color: 'var(--color-text-secondary)' }}>
                  Día {data.weeksActive * 7} de crecimiento juntos
                </p>
              </div>

              <div className="flex flex-wrap gap-2">
                {hasCouple && (
                  <span
                    className="px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1.5"
                    style={{ background: 'var(--color-conexion-dim)', color: 'var(--color-conexion)', border: '1px solid rgba(232, 116, 138, 0.2)' }}
                  >
                    <Heart className="h-3.5 w-3.5" /> {data.couple!.durationText}
                  </span>
                )}
                <span
                  className="px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1.5"
                  style={{ background: 'var(--color-camino-dim)', color: 'var(--color-camino)', border: '1px solid rgba(201, 168, 76, 0.2)' }}
                >
                  <Sparkles className="h-3.5 w-3.5" /> Semana activa
                </span>
              </div>
            </div>

            {/* Right: Overall health score + Compatibility Badge */}
            {hasScores && (
              <div className="flex flex-col items-center gap-1">
                <p className="text-[10px] font-black uppercase tracking-[0.2em] mb-1 opacity-50" style={{ color: 'var(--color-text-primary)' }}>
                  Salud general
                </p>

                <div className="relative mb-2">
                  <span className="font-display text-6xl md:text-7xl leading-none" style={{ color: 'var(--color-text-primary)' }}>
                    {animatedHealth}%
                  </span>

                  {/* The Compatibility Symbol Badge */}
                  <motion.div
                    className=" flex items-center gap-1 px-2 py-1 rounded-full text-[10px] font-bold border shadow-lg backdrop-blur-md"
                    style={{ background: 'var(--color-surface-2)', borderColor: status.color, color: status.color }}
                    initial={{ scale: 0, rotate: -20 }}
                    animate={{ scale: 1, rotate: 0 }}
                    transition={{ type: 'spring', delay: 1 }}
                  >
                    <span>{status.emoji}</span>
                    <span className="uppercase tracking-wider">{status.label}</span>
                  </motion.div>
                </div>

                {/* Mini bar breakdown */}
                <div className="flex gap-1.5 w-40 mt-1">
                  {(['conexion', 'cuidado', 'choque', 'camino'] as const).map(key => {
                    const score = Math.round((data.scores![key as keyof typeof data.scores] || 0) * 100);
                    const conf = DIMENSION_CONFIG[key];
                    return (
                      <div key={key} className="flex-1 h-1.5 rounded-full overflow-hidden" style={{ background: 'var(--color-surface-3)' }}>
                        <motion.div
                          className="h-full rounded-full"
                          style={{ background: conf.color }}
                          initial={{ width: 0 }}
                          animate={{ width: `${score}%` }}
                          transition={{ duration: 1, delay: 0.5, ease: "easeOut" }}
                        />
                      </div>
                    );
                  })}
                </div>
              </div>
            )}
          </div>
        </motion.section>

        {/* ═══ AI COPILOT CARD + 4C HEALTH RING ═══ */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">

          {/* AI Copilot Card */}
          <motion.div variants={itemVariants} className="lg:col-span-7">
            <div
              className="rounded-3xl p-8 relative overflow-hidden h-full group"
              style={{
                background: 'linear-gradient(135deg, var(--color-ai-dim) 0%, var(--color-surface-1) 100%)',
                border: '1px solid rgba(139, 159, 232, 0.3)',
              }}
            >
              {/* Decorative AI pattern */}
              <div className="absolute top-0 right-0 p-8 opacity-[0.05] pointer-events-none group-hover:scale-110 transition-transform duration-700">
                <Sparkles className="w-24 h-24" style={{ color: 'var(--color-ai)' }} />
              </div>

              <div className="flex items-center gap-3 mb-6">
                <div className="w-8 h-8 rounded-xl flex items-center justify-center shadow-inner" style={{ background: 'var(--color-ai)', color: 'var(--color-base)' }}>
                  <Sparkles className="h-4 w-4" />
                </div>
                <span className="text-xs font-black uppercase tracking-[0.2em]" style={{ color: 'var(--color-ai)' }}>
                  Copiloto IA
                </span>
              </div>

              {data.dashboardInsight ? (
                <div className="space-y-4">
                  <h4 className="text-xl font-display leading-tight" style={{ color: 'var(--color-text-primary)' }}>
                    {data.dashboardInsight.title}
                  </h4>
                  <p className="text-lg leading-relaxed italic opacity-90" style={{ color: 'var(--color-text-primary)' }}>
                    &ldquo;{data.dashboardInsight.body}&rdquo;
                  </p>
                </div>
              ) : (
                <p className="text-base mb-6 leading-relaxed" style={{ color: 'var(--color-text-secondary)' }}>
                  {data.questionnaireStatus === 'completed'
                    ? 'Estoy analizando sus últimos momentos para darles el mejor consejo del día.'
                    : 'Finalicen su evaluación para que pueda guiarles con mayor precisión.'}
                </p>
              )}

              <div className="flex items-center gap-3 mt-8">
                <button
                  onClick={() => router.push(copilotAction)}
                  className="px-6 py-3 rounded-2xl text-sm font-bold transition-all hover:translate-x-1 active:scale-95 flex items-center gap-2 shadow-lg shadow-ai/20"
                  style={{
                    background: 'var(--color-ai)',
                    color: 'var(--color-base)',
                  }}
                >
                  {copilotCta} <ArrowRight className="h-4 w-4" />
                </button>
              </div>
            </div>
          </motion.div>

          {/* Today's Task */}
          <motion.div variants={itemVariants} className="lg:col-span-5">
            {todaysItemMapped ? (
              <InteractivePlanItem item={todaysItemMapped} hasAccess={hasCouple} />
            ) : (
              <div
                className="rounded-3xl p-8 flex flex-col items-center justify-center text-center h-full cursor-pointer transition-all hover:shadow-xl"
                style={{
                  background: 'var(--color-surface-1)',
                  border: '1px solid var(--color-border)',
                }}
                onClick={() => router.push('/dashboard/plan')}
              >
                <div className="w-14 h-14 rounded-2xl flex items-center justify-center mb-4" style={{ background: 'var(--color-cuidado-dim)' }}>
                  <Calendar className="h-7 w-7" style={{ color: 'var(--color-cuidado)' }} />
                </div>
                <h5 className="text-lg font-semibold mb-2" style={{ color: 'var(--color-text-primary)' }}>Tu Plan Semanal</h5>
                <p className="text-sm mb-6 max-w-[240px]" style={{ color: 'var(--color-text-secondary)' }}>
                  {data.weeklyPlan ? '¡Has completado todas las tareas de hoy! Tómate un respiro.' : 'Aún no tienes un plan activo para esta semana.'}
                </p>
                <span className="text-sm font-bold flex items-center px-4 py-2 rounded-xl" style={{ background: 'var(--color-surface-2)', color: 'var(--color-cuidado)' }}>
                  Ir al Planificador <ChevronRight className="h-4 w-4 ml-1" />
                </span>
              </div>
            )}
          </motion.div>
        </div>

        {/* ═══ 4C DIMENSION MINI-CARDS ═══ */}
        <motion.div variants={itemVariants}>
          <div className="flex items-center justify-between mb-4 px-1">
            <h3 className="text-xs font-black uppercase tracking-[0.2em]" style={{ color: 'var(--color-text-tertiary)' }}>
              Tu Mapa de Relación
            </h3>
            {hasScores && (
              <span
                className="text-xs font-bold cursor-pointer hover:underline"
                style={{ color: 'var(--color-ai)' }}
                onClick={() => router.push('/dashboard/nosotros')}
              >
                Explorar Detalles →
              </span>
            )}
          </div>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {(['conexion', 'cuidado', 'choque', 'camino'] as const).map((key) => {
              const conf = DIMENSION_CONFIG[key];
              const score = hasScores ? Math.round((data.scores![key as keyof typeof data.scores] || 0) * 100) : 0;

              return (
                <div
                  key={key}
                  className="rounded-2xl p-5 cursor-pointer group flex flex-col justify-between overflow-hidden relative transition-all duration-300 hover:scale-[1.03] hover:shadow-lg"
                  style={{
                    background: conf.dimBg,
                    border: '1px solid var(--color-border)',
                  }}
                  onClick={() => router.push('/dashboard/nosotros')}
                >
                  <div>
                    <p className="text-[10px] font-black tracking-[0.15em] uppercase mb-4" style={{ color: conf.color }}>
                      {conf.label}
                    </p>

                    {hasScores ? (
                      <>
                        <span className="font-display text-4xl mb-2 block" style={{ color: conf.color }}>
                          {score}%
                        </span>
                        <div className="w-full h-1.5 rounded-full overflow-hidden" style={{ background: 'var(--color-surface-3)' }}>
                          <motion.div
                            className="h-full rounded-full"
                            style={{ background: conf.color }}
                            initial={{ width: 0 }}
                            animate={{ width: `${score}%` }}
                            transition={{ duration: 1, ease: "easeOut", delay: 0.2 }}
                          />
                        </div>
                      </>
                    ) : (
                      <div className="flex flex-col items-center justify-center flex-1 gap-2 py-4">
                        <motion.span
                          className="font-display text-4xl"
                          style={{ color: 'var(--color-text-tertiary)' }}
                          animate={{ opacity: [0.3, 0.7, 0.3] }}
                          transition={{ duration: 2, repeat: Infinity }}
                        >
                          ?
                        </motion.span>
                        <p className="text-[9px] text-center font-bold uppercase tracking-wider" style={{ color: 'var(--color-text-tertiary)' }}>
                          Sin datos
                        </p>
                      </div>
                    )}
                  </div>

                  {/* Subtle hover background highlight */}
                  <div className="absolute inset-0 bg-white/5 opacity-0 group-hover:opacity-10 transition-opacity pointer-events-none" />
                </div>
              );
            })}
          </div>
        </motion.div>

        {/* ═══ BOTTOM ROW: Reto Activo + Daily Tip ═══ */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Active Challenge */}
          <motion.div variants={itemVariants}>
            {data.activeChallenge ? (
              <div
                className="rounded-3xl p-8 cursor-pointer transition-all hover:shadow-xl relative overflow-hidden group h-full"
                style={{
                  background: 'var(--color-camino-dim)',
                  border: '1px solid var(--color-border)',
                }}
                onClick={() => router.push('/dashboard/retos')}
              >
                <div className="flex items-center gap-2 mb-4">
                  <div className="w-6 h-6 rounded-lg flex items-center justify-center" style={{ background: 'var(--color-camino)', color: 'var(--color-base)' }}>
                    <Flame className="h-3.5 w-3.5" />
                  </div>
                  <span className="text-xs font-black uppercase tracking-[0.2em]" style={{ color: 'var(--color-camino)' }}>
                    Reto Activo
                  </span>
                </div>
                <h4 className="font-display text-2xl mb-2" style={{ color: 'var(--color-text-primary)' }}>
                  {data.activeChallenge.title}
                </h4>
                <p className="text-sm opacity-80 mb-6" style={{ color: 'var(--color-text-primary)' }}>
                  Fortaleciendo la dimensión &ldquo;{data.activeChallenge.dimension}&rdquo;
                </p>
                <span className="text-sm font-bold flex items-center gap-1" style={{ color: 'var(--color-camino)' }}>
                  Ver detalles <ArrowRight className="h-4 w-4 ml-1 group-hover:translate-x-1 transition-transform" />
                </span>
              </div>
            ) : (
              <div
                className="rounded-3xl p-8 flex flex-col items-center justify-center text-center h-full cursor-pointer transition-all hover:bg-surface-2"
                style={{
                  background: 'var(--color-surface-1)',
                  border: '1px dashed var(--color-border)',
                }}
                onClick={() => router.push('/dashboard/retos')}
              >
                <Award className="h-10 w-10 mb-4 opacity-30" style={{ color: 'var(--color-text-secondary)' }} />
                <p className="font-bold mb-2" style={{ color: 'var(--color-text-primary)' }}>¿Listos para un reto?</p>
                <p className="text-sm opacity-70" style={{ color: 'var(--color-text-secondary)' }}>
                  Activen un reto semanal para inyectar novedad y crecimiento.
                </p>
              </div>
            )}
          </motion.div>

          {/* Daily Tip - "Sabías que" */}
          <motion.div variants={itemVariants}>
            {hasCouple && data.dailyTip ? (
              <div
                className="rounded-3xl p-8 h-full flex flex-col justify-between cursor-pointer transition-all hover:shadow-xl group relative overflow-hidden"
                style={{
                  background: 'linear-gradient(135deg, var(--color-cuidado-dim) 0%, var(--color-surface-1) 100%)',
                  border: '1px solid rgba(242, 166, 90, 0.3)',
                }}
                onClick={() => router.push('/dashboard/nosotros')}
              >
                {/* Background accent */}
                <div className="absolute -bottom-6 -right-6 opacity-[0.05] group-hover:rotate-12 transition-transform duration-700">
                  <Lightbulb className="w-32 h-32" style={{ color: 'var(--color-cuidado)' }} />
                </div>

                <div className="flex items-center gap-3 mb-6">
                  <div className="w-8 h-8 rounded-xl flex items-center justify-center shadow-lg" style={{ background: 'var(--color-cuidado)', color: 'var(--color-base)' }}>
                    <Lightbulb className="h-4 w-4" />
                  </div>
                  <span className="text-xs font-black uppercase tracking-[0.2em]" style={{ color: 'var(--color-cuidado)' }}>
                    Sabías que...
                  </span>
                </div>

                <p className="text-lg leading-relaxed font-medium md:text-xl" style={{ color: 'var(--color-text-primary)' }}>
                  &ldquo;{data.dailyTip.tip}&rdquo;
                </p>

                <div className="mt-8 flex items-center gap-2 text-xs font-bold uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-opacity" style={{ color: 'var(--color-cuidado)' }}>
                  Ver mapa de relación <ArrowRight className="h-3 w-3" />
                </div>
              </div>
            ) : (
              <div
                className="rounded-3xl p-8 flex flex-col items-center justify-center text-center h-full border border-dashed"
                style={{
                  background: 'var(--color-surface-1)',
                  borderColor: 'var(--color-border)',
                }}
              >
                <Lightbulb className="h-10 w-10 mb-4 opacity-20" style={{ color: 'var(--color-text-secondary)' }} />
                <p className="text-sm font-medium" style={{ color: 'var(--color-text-secondary)' }}>
                  Sus tips diarios personalizados aparecerán aquí.
                </p>
              </div>
            )}
          </motion.div>
        </div>
      </motion.div>
    </AppShell>
  );
}
