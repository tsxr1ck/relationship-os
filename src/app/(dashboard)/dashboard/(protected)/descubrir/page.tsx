'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { Compass, Lock, Heart, Loader2, CheckCircle2, ArrowRight, Sparkles, BrainCircuit, Target, RefreshCw, User, ShieldCheck } from 'lucide-react';
import { motion, type Variants } from 'framer-motion';
import { getQuestionnaireStatus, getCoupleStatus } from '../../questionnaire/actions';
import { getComparativeResults, getPersonalInsights, type ComparativeResults, type PersonalInsights } from './actions';

const containerVariants: Variants = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { staggerChildren: 0.1 } }
};

const itemVariants: Variants = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0, transition: { type: "spring" as const, stiffness: 300, damping: 24 } }
};

/** Render simple markdown-like bold (**text**) into React nodes */
function RichText({ text }: { text: string }) {
  const parts = text.split(/\*\*(.*?)\*\*/g);
  return (
    <span>
      {parts.map((part, i) =>
        i % 2 === 1 ? <strong key={i} className="font-semibold text-on_surface">{part}</strong> : part
      )}
    </span>
  );
}

export default function DescubrirPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [questionnaireStatus, setQuestionnaireStatus] = useState<'not_started' | 'in_progress' | 'completed'>('not_started');
  const [bothCompleted, setBothCompleted] = useState(false);
  const [comparative, setComparative] = useState<ComparativeResults | null>(null);
  const [personal, setPersonal] = useState<PersonalInsights | null>(null);
  const [loadingComparative, setLoadingComparative] = useState(false);
  const [loadingPersonal, setLoadingPersonal] = useState(false);
  const [activeTab, setActiveTab] = useState<'couple' | 'personal'>('personal');

  useEffect(() => {
    async function load() {
      try {
        const [qStatus, coupleStatus] = await Promise.all([
          getQuestionnaireStatus(),
          getCoupleStatus(),
        ]);

        if (qStatus.status === 'completed') {
          setQuestionnaireStatus('completed');
        } else if (qStatus.status === 'in_progress') {
          setQuestionnaireStatus('in_progress');
        } else {
          setQuestionnaireStatus('not_started');
        }

        const both = coupleStatus.bothCompleted || false;
        setBothCompleted(both);

        // Always load personal insights if questionnaire is completed
        if (qStatus.status === 'completed') {
          setLoadingPersonal(true);
          const personalData = await getPersonalInsights();
          setPersonal(personalData);
          setLoadingPersonal(false);
        }

        // If both completed, also fetch comparative results
        if (both) {
          setLoadingComparative(true);
          const results = await getComparativeResults();
          setComparative(results);
          setLoadingComparative(false);
        }
      } catch (err) {
        console.error('Error loading descubrir data:', err);
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
          <Loader2 className="h-12 w-12 text-primary animate-spin" />
        </div>
      </AppShell>
    );
  }

  const alignmentColor = (alignment: 'strong' | 'moderate' | 'divergent') => {
    switch (alignment) {
      case 'strong': return 'cuidado';
      case 'moderate': return 'camino';
      case 'divergent': return 'choque';
    }
  };

  const alignmentLabel = (alignment: 'strong' | 'moderate' | 'divergent') => {
    switch (alignment) {
      case 'strong': return 'Alineados';
      case 'moderate': return 'Oportunidad';
      case 'divergent': return 'A conversar';
    }
  };

  return (
    <AppShell>
      <div className="space-y-8">
        <div>
          <h1 className="text-3xl md:text-4xl font-semibold text-on_surface mb-2">
            Descubrir
          </h1>
          <p className="text-on_surface_variant">
            Explora insights personalizados impulsados por IA para ti y tu relación
          </p>
        </div>

        {/* Status: Not started or in progress */}
        {questionnaireStatus !== 'completed' && (
          <Card className="border border-primary/20 overflow-hidden">
            <CardContent className="pt-6">
              <div className="flex items-center gap-4">
                <div className="w-14 h-14 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                  <Compass className="h-6 w-6 text-primary" />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-on_surface mb-1">
                    {questionnaireStatus === 'in_progress'
                      ? 'Cuestionario en progreso'
                      : 'Completa la evaluación'}
                  </h3>
                  <p className="text-sm text-on_surface_variant">
                    Completa la evaluación de pareja para desbloquear tus insights personales de IA.
                  </p>
                </div>
                <Button onClick={() => router.push('/dashboard/questionnaire')}>
                  {questionnaireStatus === 'in_progress' ? 'Continuar' : 'Comenzar'}
                  <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Tab Switcher */}
        {questionnaireStatus === 'completed' && (
          <div className="flex gap-2 bg-surface_container_low p-1 rounded-xl">
            <button
              className={`flex-1 flex items-center justify-center gap-2 py-3 px-4 rounded-lg text-sm font-medium transition-all ${
                activeTab === 'personal'
                  ? 'bg-white text-on_surface shadow-sm'
                  : 'text-on_surface_variant hover:text-on_surface'
              }`}
              onClick={() => setActiveTab('personal')}
            >
              <User className="h-4 w-4" />
              Mi Análisis Personal
            </button>
            <button
              className={`flex-1 flex items-center justify-center gap-2 py-3 px-4 rounded-lg text-sm font-medium transition-all ${
                activeTab === 'couple'
                  ? 'bg-white text-on_surface shadow-sm'
                  : 'text-on_surface_variant hover:text-on_surface'
              }`}
              onClick={() => setActiveTab('couple')}
            >
              <Heart className="h-4 w-4" />
              Análisis de Pareja
            </button>
          </div>
        )}

        {/* ===== PERSONAL TAB ===== */}
        {activeTab === 'personal' && questionnaireStatus === 'completed' && (
          <>
            {loadingPersonal ? (
              <Card>
                <CardContent className="py-16 text-center">
                  <div className="flex flex-col items-center gap-4">
                    <div className="relative">
                      <BrainCircuit className="h-12 w-12 text-primary animate-pulse" />
                      <Sparkles className="h-5 w-5 text-camino absolute -top-1 -right-1 animate-bounce" />
                    </div>
                    <div>
                      <p className="text-on_surface font-medium mb-1">Generando tu coaching personal...</p>
                      <p className="text-sm text-on_surface_variant">Analizando tus respuestas de forma privada</p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ) : personal ? (
              <motion.div className="space-y-6" variants={containerVariants} initial="hidden" animate="show">
                {/* Privacy Badge */}
                <motion.div variants={itemVariants}>
                  <div className="flex items-center gap-2 px-4 py-2 bg-cuidado/10 rounded-xl w-fit">
                    <ShieldCheck className="h-4 w-4 text-cuidado" />
                    <span className="text-sm text-cuidado font-medium">
                      Solo tú puedes ver estos insights. Tu pareja recibe los suyos.
                    </span>
                  </div>
                </motion.div>

                {/* Personal Summary */}
                <motion.div variants={itemVariants}>
                  <Card className="border border-primary/20 overflow-hidden">
                    <CardContent className="pt-6">
                      <div className="flex items-start gap-3 mb-1">
                        <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center shrink-0 mt-0.5">
                          <BrainCircuit className="h-5 w-5 text-primary" />
                        </div>
                        <div>
                          <div className="flex items-center gap-2 mb-2">
                            <h3 className="font-semibold text-on_surface">Tu Coach Personal</h3>
                            <span className="px-2 py-0.5 bg-primary/10 text-primary rounded-full text-xs font-medium flex items-center gap-1">
                              <Sparkles className="h-3 w-3" /> IA
                            </span>
                          </div>
                          <p className="text-on_surface_variant leading-relaxed">
                            {personal.summary}
                          </p>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </motion.div>

                {/* Personal Dimension Scores + Coaching */}
                <motion.div variants={itemVariants}>
                  <h3 className="text-xl font-semibold text-on_surface mb-4">
                    Tus dimensiones
                  </h3>
                  <div className="space-y-4">
                    {personal.dimensions.map((dim) => (
                      <Card key={dim.slug} className="overflow-hidden">
                        <CardContent className="pt-5 pb-5">
                          <div className="flex items-start justify-between mb-3">
                            <div className="flex items-center gap-3">
                              <span className="text-2xl">{dim.icon}</span>
                              <h4 className="font-semibold text-on_surface">{dim.label}</h4>
                            </div>
                            <span className="text-lg font-bold text-on_surface">
                              {Math.round(dim.score * 100)}%
                            </span>
                          </div>

                          {/* Score bar */}
                          <div className="h-2.5 bg-surface_container_low rounded-full overflow-hidden mb-4">
                            <div
                              className={`h-full bg-${dim.color} rounded-full transition-all duration-700`}
                              style={{ width: `${dim.score * 100}%` }}
                            />
                          </div>

                          {/* AI Coaching */}
                          <div className="flex items-start gap-2 bg-surface_container_low/50 rounded-xl p-3">
                            <Sparkles className="h-4 w-4 text-primary shrink-0 mt-0.5" />
                            <p className="text-sm text-on_surface_variant leading-relaxed">
                              {dim.coaching}
                            </p>
                          </div>
                        </CardContent>
                      </Card>
                    ))}
                  </div>
                </motion.div>

                {/* Personal Practices */}
                {personal.practices.length > 0 && (
                  <motion.div variants={itemVariants}>
                    <Card className="border border-primary/10">
                      <CardContent className="pt-5">
                        <div className="flex items-center gap-2 mb-4">
                          <div className="w-8 h-8 rounded-lg bg-primary/15 flex items-center justify-center">
                            <Target className="h-4 w-4 text-primary" />
                          </div>
                          <div>
                            <h4 className="font-semibold text-on_surface">Tus prácticas de esta semana</h4>
                            <span className="text-xs text-primary flex items-center gap-1">
                              <Sparkles className="h-3 w-3" /> Personalizadas por IA
                            </span>
                          </div>
                        </div>
                        <ul className="space-y-3">
                          {personal.practices.map((item, i) => (
                            <li key={i} className="flex items-start gap-3 text-sm text-on_surface">
                              <span className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
                                {i + 1}
                              </span>
                              <span className="leading-relaxed">
                                <RichText text={item} />
                              </span>
                            </li>
                          ))}
                        </ul>
                      </CardContent>
                    </Card>
                  </motion.div>
                )}
              </motion.div>
            ) : (
              <Card>
                <CardContent className="py-8 text-center">
                  <p className="text-on_surface_variant">No se pudieron generar los insights personales.</p>
                  <Button variant="ghost" className="mt-3" onClick={() => window.location.reload()}>
                    <RefreshCw className="mr-2 h-4 w-4" /> Reintentar
                  </Button>
                </CardContent>
              </Card>
            )}
          </>
        )}

        {/* ===== COUPLE TAB ===== */}
        {activeTab === 'couple' && questionnaireStatus === 'completed' && (
          <>
            {/* Waiting for partner */}
            {!bothCompleted && (
              <Card className="border border-conexion/30 overflow-hidden">
                <CardContent className="pt-6">
                  <div className="flex items-center gap-4">
                    <div className="w-14 h-14 rounded-full bg-conexion/10 flex items-center justify-center shrink-0">
                      <Lock className="h-6 w-6 text-conexion" />
                    </div>
                    <div>
                      <h3 className="font-semibold text-on_surface mb-1">
                        Esperando a tu pareja
                      </h3>
                      <p className="text-sm text-on_surface_variant">
                        Los resultados comparativos se desbloquean cuando ambos completen el cuestionario.
                      </p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            )}

            {bothCompleted && (
              <>
                {loadingComparative ? (
                  <Card>
                    <CardContent className="py-16 text-center">
                      <div className="flex flex-col items-center gap-4">
                        <div className="relative">
                          <BrainCircuit className="h-12 w-12 text-primary animate-pulse" />
                          <Sparkles className="h-5 w-5 text-camino absolute -top-1 -right-1 animate-bounce" />
                        </div>
                        <div>
                          <p className="text-on_surface font-medium mb-1">Generando análisis comparativo...</p>
                          <p className="text-sm text-on_surface_variant">Comparando las respuestas de ambos</p>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                ) : comparative ? (
                  <motion.div className="space-y-6" variants={containerVariants} initial="hidden" animate="show">
                    {/* Hero banner */}
                    <motion.div variants={itemVariants}>
                      <Card className="overflow-hidden relative shadow-lg shadow-conexion/10">
                        <div className="absolute inset-0 bg-linear-to-br from-conexion/80 via-primary to-camino/80" />
                        <CardContent className="relative z-10 pt-10 pb-10 text-white text-center">
                          <div className="flex items-center justify-center gap-2 mb-3">
                            <Sparkles className="h-5 w-5" />
                            <span className="text-sm font-medium tracking-wide uppercase opacity-80">
                              Resultados Comparativos
                            </span>
                          </div>
                          <h2 className="text-3xl md:text-4xl font-bold mb-2">
                            {comparative.overallAlignment}%
                          </h2>
                          <p className="text-white/80 text-lg mb-1">Alineación general</p>
                          <p className="text-white/60 text-sm max-w-md mx-auto">
                            {comparative.myName} &amp; {comparative.partnerName}
                          </p>

                          <div className="mt-6 flex justify-center">
                            <div className="relative w-32 h-32">
                              <svg viewBox="0 0 120 120" className="w-full h-full -rotate-90">
                                <circle cx="60" cy="60" r="52" fill="none" stroke="rgba(255,255,255,0.15)" strokeWidth="8" />
                                <circle
                                  cx="60" cy="60" r="52" fill="none" stroke="white" strokeWidth="8" strokeLinecap="round"
                                  strokeDasharray={`${(comparative.overallAlignment / 100) * 327} 327`}
                                  className="transition-all duration-1000"
                                />
                              </svg>
                              <div className="absolute inset-0 flex items-center justify-center">
                                <Heart className="h-8 w-8 text-white" />
                              </div>
                            </div>
                          </div>
                        </CardContent>
                      </Card>
                    </motion.div>

                    {/* AI Overall Insight */}
                    <motion.div variants={itemVariants}>
                      <Card className="border border-primary/20 overflow-hidden">
                        <CardContent className="pt-6">
                          <div className="flex items-start gap-3">
                            <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center shrink-0 mt-0.5">
                              <BrainCircuit className="h-5 w-5 text-primary" />
                            </div>
                            <div>
                              <div className="flex items-center gap-2 mb-1">
                                <h3 className="font-semibold text-on_surface">Análisis de IA</h3>
                                <span className="px-2 py-0.5 bg-primary/10 text-primary rounded-full text-xs font-medium flex items-center gap-1">
                                  <Sparkles className="h-3 w-3" /> Gemini
                                </span>
                              </div>
                              <p className="text-on_surface_variant leading-relaxed">
                                {comparative.overallInsight}
                              </p>
                            </div>
                          </div>
                        </CardContent>
                      </Card>
                    </motion.div>

                    {/* Per-dimension comparisons */}
                    <motion.div variants={itemVariants}>
                      <h3 className="text-xl font-semibold text-on_surface mb-4">Comparación por dimensión</h3>
                      <div className="space-y-4">
                        {comparative.dimensions.map((dim) => (
                          <Card key={dim.dimension} className="overflow-hidden">
                            <CardContent className="pt-5 pb-5">
                              <div className="flex items-start justify-between mb-4">
                                <div className="flex items-center gap-3">
                                  <span className="text-2xl">{dim.icon}</span>
                                  <div>
                                    <h4 className="font-semibold text-on_surface">{dim.label}</h4>
                                    <span className={`inline-block mt-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-${alignmentColor(dim.alignment)}/15 text-${alignmentColor(dim.alignment)}`}>
                                      {alignmentLabel(dim.alignment)}
                                    </span>
                                  </div>
                                </div>
                                <div className="text-right">
                                  <span className="text-sm text-on_surface_variant">Diferencia</span>
                                  <p className="font-bold text-lg text-on_surface">{Math.round(dim.difference * 100)}%</p>
                                </div>
                              </div>

                              <div className="space-y-3">
                                <div>
                                  <div className="flex justify-between text-sm mb-1">
                                    <span className="text-on_surface_variant">{comparative.myName}</span>
                                    <span className="font-medium text-on_surface">{Math.round(dim.myScore * 100)}%</span>
                                  </div>
                                  <div className="h-2.5 bg-surface_container_low rounded-full overflow-hidden">
                                    <div className={`h-full bg-${dim.color} rounded-full transition-all duration-700`} style={{ width: `${dim.myScore * 100}%` }} />
                                  </div>
                                </div>
                                <div>
                                  <div className="flex justify-between text-sm mb-1">
                                    <span className="text-on_surface_variant">{comparative.partnerName}</span>
                                    <span className="font-medium text-on_surface">{Math.round(dim.partnerScore * 100)}%</span>
                                  </div>
                                  <div className="h-2.5 bg-surface_container_low rounded-full overflow-hidden">
                                    <div className={`h-full bg-${dim.color}/60 rounded-full transition-all duration-700`} style={{ width: `${dim.partnerScore * 100}%` }} />
                                  </div>
                                </div>
                              </div>

                              <div className="mt-4 pt-3 border-t border-outline_variant/30">
                                <div className="flex items-start gap-2">
                                  <Sparkles className="h-4 w-4 text-primary shrink-0 mt-0.5" />
                                  <p className="text-sm text-on_surface_variant leading-relaxed">{dim.insight}</p>
                                </div>
                              </div>
                            </CardContent>
                          </Card>
                        ))}
                      </div>
                    </motion.div>

                    {/* Strengths, Growth & Action Items */}
                    <motion.div variants={itemVariants} className="grid grid-cols-1 md:grid-cols-3 gap-4">
                      {comparative.strengths.length > 0 && (
                        <Card>
                          <CardContent className="pt-5">
                            <div className="flex items-center gap-2 mb-4">
                              <div className="w-8 h-8 rounded-lg bg-cuidado/15 flex items-center justify-center">
                                <span className="text-sm">💚</span>
                              </div>
                              <h4 className="font-semibold text-on_surface">Fortalezas</h4>
                            </div>
                            <ul className="space-y-2">
                              {comparative.strengths.map((s) => (
                                <li key={s} className="flex items-center gap-2 text-sm text-on_surface">
                                  <CheckCircle2 className="h-4 w-4 text-cuidado shrink-0" />
                                  {s}
                                </li>
                              ))}
                            </ul>
                          </CardContent>
                        </Card>
                      )}

                      {comparative.growthAreas.length > 0 && (
                        <Card>
                          <CardContent className="pt-5">
                            <div className="flex items-center gap-2 mb-4">
                              <div className="w-8 h-8 rounded-lg bg-camino/15 flex items-center justify-center">
                                <span className="text-sm">🌱</span>
                              </div>
                              <h4 className="font-semibold text-on_surface">Áreas de crecimiento</h4>
                            </div>
                            <ul className="space-y-2">
                              {comparative.growthAreas.map((g) => (
                                <li key={g} className="flex items-center gap-2 text-sm text-on_surface">
                                  <ArrowRight className="h-4 w-4 text-camino shrink-0" />
                                  {g}
                                </li>
                              ))}
                            </ul>
                          </CardContent>
                        </Card>
                      )}

                      {comparative.actionItems && comparative.actionItems.length > 0 && (
                        <Card className="border border-primary/10">
                          <CardContent className="pt-5">
                            <div className="flex items-center gap-2 mb-4">
                              <div className="w-8 h-8 rounded-lg bg-primary/15 flex items-center justify-center">
                                <Target className="h-4 w-4 text-primary" />
                              </div>
                              <div>
                                <h4 className="font-semibold text-on_surface">Acciones sugeridas</h4>
                                <span className="text-xs text-primary flex items-center gap-1">
                                  <Sparkles className="h-3 w-3" /> IA
                                </span>
                              </div>
                            </div>
                            <ul className="space-y-3">
                              {comparative.actionItems.map((item, i) => (
                                <li key={i} className="flex items-start gap-3 text-sm text-on_surface">
                                  <span className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
                                    {i + 1}
                                  </span>
                                  <span className="leading-relaxed">
                                    <RichText text={item} />
                                  </span>
                                </li>
                              ))}
                            </ul>
                          </CardContent>
                        </Card>
                      )}
                    </motion.div>

                    {/* CTA to Nosotros */}
                    <motion.div variants={itemVariants}>
                      <Card className="overflow-hidden relative shadow-md">
                        <div className="absolute inset-0 bg-linear-to-r from-primary to-primary_container" />
                        <CardContent className="relative z-10 pt-6 pb-6 text-white">
                          <div className="flex items-center justify-between">
                            <div>
                              <h3 className="text-lg font-semibold mb-1">Explora tu mapa completo</h3>
                              <p className="text-white/70 text-sm">Ve todas las dimensiones de tu relación en detalle</p>
                            </div>
                            <Button className="bg-white text-primary hover:bg-white/90 shrink-0" onClick={() => router.push('/dashboard/nosotros')}>
                              Ver Nosotros
                              <ArrowRight className="ml-2 h-4 w-4" />
                            </Button>
                          </div>
                        </CardContent>
                      </Card>
                    </motion.div>
                  </motion.div>
                ) : (
                  <Card>
                    <CardContent className="py-8 text-center">
                      <p className="text-on_surface_variant">No se pudieron cargar los resultados comparativos.</p>
                      <Button variant="ghost" className="mt-3" onClick={() => window.location.reload()}>
                        <RefreshCw className="mr-2 h-4 w-4" /> Recargar
                      </Button>
                    </CardContent>
                  </Card>
                )}
              </>
            )}
          </>
        )}
      </div>
    </AppShell>
  );
}
