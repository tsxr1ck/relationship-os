'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { Sparkles, Loader2, ArrowRight, ClipboardList, Zap, RefreshCw, Plus, Send } from 'lucide-react';
import { motion, type Variants } from 'framer-motion';
import { getEvaluations, createEvaluation, getTopicSuggestions } from './actions';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';

const containerVariants: Variants = {
  hidden: { opacity: 0 },
  show: { opacity: 1, transition: { staggerChildren: 0.1 } }
};

const itemVariants: Variants = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0, transition: { type: "spring", stiffness: 300, damping: 24 } }
};

export default function EvaluacionesPage() {
  const router = useRouter();
  const [evals, setEvals] = useState<any[]>([]);
  const [topics, setTopics] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [creating, setCreating] = useState(false);
  const [selectedTopic, setSelectedTopic] = useState('');
  const [customTopic, setCustomTopic] = useState('');
  const [fetchingTopics, setFetchingTopics] = useState(false);

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      setLoading(true);
      const evalsData = await getEvaluations();
      setEvals(evalsData);
    } catch (err: any) {
      toast.error('Error cargando quizzes', { description: err.message });
    } finally {
      setLoading(false);
    }
  }

  async function refreshTopics() {
    try {
      setFetchingTopics(true);
      const topicsData = await getTopicSuggestions();
      setTopics(topicsData);
      toast.success('Nuevas sugerencias listas');
    } catch (err: any) {
      toast.error('Error al sugerir temas', { description: err.message });
    } finally {
      setFetchingTopics(false);
    }
  }

  async function handleCreate(topicTitle: string) {
    if (!topicTitle.trim()) return;
    try {
      setCreating(true);
      setSelectedTopic(topicTitle);
      toast.loading('Generando tu quiz interactivo...', { id: 'create-eval' });
      const newEvalId = await createEvaluation(topicTitle);
      toast.success('¡Quiz generado con éxito!', { id: 'create-eval' });
      
      // Navigate to the new evaluation immediately
      router.push(`/dashboard/evaluaciones/${newEvalId}`);
    } catch (err: any) {
      toast.error('Error al generar el quiz', { id: 'create-eval', description: err.message });
      setCreating(false);
      setSelectedTopic('');
    }
  }

  const activeEvals = evals.filter(e => e.status !== 'completed');
  const completedEvals = evals.filter(e => e.status === 'completed');

  return (
    <AppShell>
      <motion.div
        className="space-y-8"
        variants={containerVariants}
        initial="hidden"
        animate="show"
      >
        <motion.div variants={itemVariants}>
          <h1 className="font-display text-3xl md:text-4xl mb-2" style={{ color: 'var(--color-text-primary)' }}>
            Quizzes de Pareja
          </h1>
          <p style={{ color: 'var(--color-text-secondary)' }}>
            Actividades interactivas generadas por IA para conocerse mejor. Elijan un tema y ¡a jugar!
          </p>
        </motion.div>

        {/* ═══ Custom Creation ═══ */}
        <motion.div variants={itemVariants} className="space-y-4">
          <div className="flex items-center gap-2 mb-2">
            <Plus className="h-5 w-5" style={{ color: 'var(--color-ai)' }} />
            <h2 className="text-lg font-semibold" style={{ color: 'var(--color-text-primary)' }}>Idea Propia</h2>
          </div>
          
          <Card style={{ background: 'var(--color-surface-2)', border: '1px solid var(--color-border)', borderRadius: '1.5rem' }} className="overflow-hidden">
            <CardContent className="p-2 flex gap-2">
              <input 
                type="text"
                placeholder="¿Sobre qué quieren jugar hoy? (Ej: Finanzas, Viajes, Nuestra historia...)"
                className="flex-1 bg-transparent px-4 py-3 outline-hidden text-sm"
                style={{ color: 'var(--color-text-primary)' }}
                value={customTopic}
                onChange={(e) => setCustomTopic(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && handleCreate(customTopic)}
                disabled={creating}
              />
              <Button 
                onClick={() => handleCreate(customTopic)} 
                disabled={creating || !customTopic.trim()}
                style={{ background: 'var(--color-ai)', color: '#fff', borderRadius: '1rem' }}
                className="shrink-0"
              >
                {creating && selectedTopic === customTopic ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <><Send className="h-4 w-4 mr-2" /> Crear Quiz</>
                )}
              </Button>
            </CardContent>
          </Card>
        </motion.div>

        {/* ═══ AI Suggestions ═══ */}
        <motion.div variants={itemVariants} className="space-y-4">
          <div className="flex items-center justify-between mb-2">
            <div className="flex items-center gap-2">
              <Zap className="h-5 w-5" style={{ color: 'var(--color-ai)' }} />
              <h2 className="text-lg font-semibold" style={{ color: 'var(--color-text-primary)' }}>Inspiración de la IA</h2>
            </div>
            
            <Button 
              variant="ghost" 
              size="sm" 
              onClick={refreshTopics} 
              disabled={fetchingTopics || creating}
              className="text-xs"
              style={{ color: 'var(--color-text-tertiary)' }}
            >
              <RefreshCw className={cn("h-3 w-3 mr-2", fetchingTopics && "animate-spin")} />
              Sugerir nuevos
            </Button>
          </div>
          
          {fetchingTopics ? (
             <div className="flex flex-col items-center justify-center py-16 space-y-4">
               <div className="relative">
                 <div className="absolute inset-0 blur-xl opacity-20 bg-ai rounded-full animate-pulse" />
                 <Loader2 className="h-10 w-10 animate-spin relative" style={{ color: 'var(--color-ai)' }} />
               </div>
               <p className="text-sm font-medium animate-pulse" style={{ color: 'var(--color-text-secondary)' }}>Explorando nuevas dinámicas para ustedes...</p>
             </div>
          ) : topics.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-3">
              {topics.map((topic, i) => (
                <button
                  key={i}
                  disabled={creating}
                  onClick={() => handleCreate(topic.title)}
                  className="text-left rounded-2xl p-6 border transition-all duration-300 hover:scale-[1.02] active:scale-95 group relative overflow-hidden flex flex-col h-full"
                  style={{ 
                    background: 'var(--color-surface-2)', 
                    borderColor: selectedTopic === topic.title ? 'var(--color-ai)' : 'var(--color-border)',
                  }}
                >
                  <div className="text-4xl mb-4 transform group-hover:scale-110 transition-transform duration-300">{topic.emoji}</div>
                  <h3 className="font-semibold text-lg leading-tight mb-2" style={{ color: 'var(--color-text-primary)' }}>
                    {topic.title}
                  </h3>
                  <p className="text-sm line-clamp-3 mb-4 flex-1" style={{ color: 'var(--color-text-secondary)' }}>
                    {topic.subtitle}
                  </p>
                  
                  <div className="text-[10px] font-bold uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-opacity" style={{ color: 'var(--color-ai)' }}>
                    Comenzar ahora →
                  </div>

                  {/* Subtle hover glow */}
                  <div className="absolute inset-0 opacity-0 group-hover:opacity-[0.03] pointer-events-none transition-opacity duration-500"
                    style={{ background: 'var(--color-ai)' }} 
                  />
                </button>
              ))}
            </div>
          ) : (
             <Card style={{ background: 'var(--color-surface-2)', border: '1px solid var(--color-border)', borderRadius: '2rem' }} className="overflow-hidden group">
               <CardContent className="p-10 text-center flex flex-col items-center">
                 <div className="w-16 h-16 rounded-2xl flex items-center justify-center mb-6 transition-transform group-hover:rotate-12" style={{ background: 'var(--color-ai-dim)' }}>
                   <Sparkles className="h-8 w-8" style={{ color: 'var(--color-ai)' }} />
                 </div>
                 <h3 className="text-xl font-display mb-2" style={{ color: 'var(--color-text-primary)' }}>Inspiración a un click</h3>
                 <p className="max-w-sm mb-8 text-sm leading-relaxed" style={{ color: 'var(--color-text-secondary)' }}>
                   ¿Quieren descubrir algo nuevo hoy? Dejen que nuestra IA analice su momento actual y les proponga 3 dinámicas personalizadas.
                 </p>
                 <Button 
                   onClick={refreshTopics}
                   style={{ background: 'var(--color-ai)', color: '#fff', paddingLeft: '2rem', paddingRight: '2rem', height: '3.5rem', borderRadius: '1.25rem' }}
                   className="shadow-lg shadow-ai/20 transition-all hover:shadow-ai/40"
                 >
                   <Zap className="h-4 w-4 mr-2" />
                   Generar Sugerencias
                 </Button>
               </CardContent>
             </Card>
          )}
        </motion.div>

        {loading ? (
          <div className="flex items-center justify-center py-10">
            <Loader2 className="h-8 w-8 animate-spin" style={{ color: 'var(--color-ai)' }} />
          </div>
        ) : (
          <>
            {/* ═══ Active Evaluations ═══ */}
            {activeEvals.length > 0 && (
              <motion.div variants={itemVariants} className="space-y-3">
                <h3 className="text-lg font-semibold flex items-center gap-2" style={{ color: 'var(--color-text-primary)' }}>
                  <ClipboardList className="h-5 w-5" style={{ color: 'var(--color-conexion)' }} />
                  Evaluaciones Activas
                </h3>
                {activeEvals.map(ev => (
                  <Card key={ev.id} className="overflow-hidden hover:scale-[1.01] transition-transform cursor-pointer" onClick={() => router.push(`/dashboard/evaluaciones/${ev.id}`)}>
                    <CardContent className="p-4 flex items-center justify-between">
                      <div className="min-w-0 pr-4">
                        <p className="font-medium truncate mb-0.5" style={{ color: 'var(--color-text-primary)' }}>{ev.title}</p>
                        <p className="text-xs truncate" style={{ color: 'var(--color-text-secondary)' }}>Creada el {new Date(ev.created_at).toLocaleDateString()}</p>
                      </div>
                      <div className="shrink-0">
                        <ArrowRight className="h-5 w-5" style={{ color: 'var(--color-text-tertiary)' }} />
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </motion.div>
            )}

            {/* ═══ Completed Evaluations ═══ */}
            {completedEvals.length > 0 && (
              <motion.div variants={itemVariants} className="space-y-3 pt-4 border-t" style={{ borderColor: 'var(--color-border)' }}>
                <h3 className="text-lg font-semibold flex items-center gap-2" style={{ color: 'var(--color-text-primary)' }}>
                  Completadas
                </h3>
                {completedEvals.map(ev => (
                  <Card key={ev.id} className="opacity-70 hover:opacity-100 transition-opacity cursor-pointer" onClick={() => router.push(`/dashboard/evaluaciones/${ev.id}/results`)}>
                    <CardContent className="p-4 flex items-center justify-between bg-surface-2">
                      <div className="min-w-0 pr-4">
                        <p className="font-medium truncate mb-0.5" style={{ color: 'var(--color-text-primary)' }}>{ev.title}</p>
                        <p className="text-xs truncate" style={{ color: 'var(--color-text-tertiary)' }}>{ev.topic}</p>
                      </div>
                      <div className="shrink-0 flex items-center text-xs" style={{ color: 'var(--color-ai)' }}>
                        <Sparkles className="h-3 w-3 mr-1" />
                        Ver Insights
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </motion.div>
            )}
            
            {evals.length === 0 && (
              <motion.div variants={itemVariants} className="text-center py-12">
                <ClipboardList className="h-12 w-12 mx-auto mb-3 opacity-20" style={{ color: 'var(--color-text-primary)' }} />
                <p style={{ color: 'var(--color-text-secondary)' }}>Aún no tienen ninguna evaluación personalizada.</p>
              </motion.div>
            )}
          </>
        )}
      </motion.div>
    </AppShell>
  );
}
