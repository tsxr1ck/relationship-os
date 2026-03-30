'use client';

import { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { Loader2, ArrowLeft, Sparkles, BrainCircuit, HeartHandshake, Copy, Clock, CheckCircle2 } from 'lucide-react';
import { motion } from 'framer-motion';
import { getInsights, generateCustomInsights, getEvaluation } from '../../actions';
import { toast } from 'sonner';

export default function EvalResultsPage({ params }: { params: Promise<{ id: string }> }) {
  const unwrappedParams = use(params);
  const router = useRouter();
  const [insights, setInsights] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [generating, setGenerating] = useState(false);
  const [evaluation, setEval] = useState<any>(null);
  const [partnerCompleted, setPartnerCompleted] = useState<boolean>(false);
  const [meCompleted, setMeCompleted] = useState<boolean>(false);

  useEffect(() => {
    loadData();
  }, [unwrappedParams.id]);

  async function loadData() {
    try {
      const [evData, insData] = await Promise.all([
        getEvaluation(unwrappedParams.id).catch(() => null),
        getInsights(unwrappedParams.id).catch(() => null)
      ]);
      setEval(evData?.evaluation);
      setPartnerCompleted(evData?.partner_completed || false);
      setMeCompleted(evData?.completed || false);
      setInsights(insData);
    } catch (err: any) {
      toast.error('Error cargando resultados', { description: err.message });
    } finally {
      setLoading(false);
    }
  }

  async function handleGenerate() {
    try {
      setGenerating(true);
      toast.loading('Analizando las respuestas de ambos...', { id: 'gen-insights' });
      const newInsights = await generateCustomInsights(unwrappedParams.id);
      toast.success('¡Análisis generado!', { id: 'gen-insights' });
      setInsights(newInsights);
    } catch (err: any) {
      toast.error('Aún no pueden ver los resultados', { 
        id: 'gen-insights', 
        description: err.message || 'Asegúrate de que ambos hayan terminado.' 
      });
    } finally {
      setGenerating(false);
    }
  }

  const handleShare = () => {
    const link = `${window.location.origin}/dashboard/evaluaciones/${unwrappedParams.id}`;
    navigator.clipboard.writeText(link);
    toast.success('¡Enlace de invitación copiado!');
  };

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <Loader2 className="h-8 w-8 animate-spin" style={{ color: 'var(--color-ai)' }} />
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell>
      <div className="max-w-3xl mx-auto pt-4 pb-20 space-y-8">
        <button 
          onClick={() => router.push('/dashboard/evaluaciones')}
          className="flex items-center gap-2 text-sm transition-colors"
          style={{ color: 'var(--color-text-tertiary)' }}
        >
          <ArrowLeft className="h-4 w-4" /> Volver a evaluaciones
        </button>

        <div>
          <h1 className="text-3xl font-bold mb-2 flex items-center gap-3" style={{ color: 'var(--color-text-primary)' }}>
            <BrainCircuit className="h-8 w-8" style={{ color: 'var(--color-ai)' }} />
            Resultados: {evaluation?.title || 'Evaluación'}
          </h1>
          <p style={{ color: 'var(--color-text-secondary)' }}>
             {evaluation?.description}
          </p>
        </div>

        {!insights ? (
           <div className="space-y-6">
             <div className="grid grid-cols-2 gap-4">
                <Card style={{ background: 'var(--color-surface-2)', border: '1px solid var(--color-border)' }}>
                  <CardContent className="p-6 flex flex-col items-center justify-center text-center">
                    {meCompleted ? (
                      <>
                        <CheckCircle2 className="h-10 w-10 mb-3" style={{ color: 'var(--color-conexion)' }} />
                         <p className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>Tú Completaste</p>
                      </>
                    ) : (
                      <>
                        <Clock className="h-10 w-10 mb-3" style={{ color: 'var(--color-text-tertiary)' }} />
                         <p className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>Aún no completas</p>
                         <Button variant="outline" size="sm" className="mt-4" onClick={() => router.push(`/dashboard/evaluaciones/${unwrappedParams.id}`)}>
                           Ir a Completar
                         </Button>
                      </>
                    )}
                  </CardContent>
                </Card>
                <Card style={{ background: 'var(--color-surface-2)', border: '1px solid var(--color-border)' }}>
                  <CardContent className="p-6 flex flex-col items-center justify-center text-center">
                    {partnerCompleted ? (
                      <>
                         <CheckCircle2 className="h-10 w-10 mb-3" style={{ color: 'var(--color-conexion)' }} />
                         <p className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>Pareja Completó</p>
                      </>
                    ) : (
                      <>
                        <Clock className="h-10 w-10 mb-3" style={{ color: 'var(--color-text-tertiary)' }} />
                         <p className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>Pareja Pendiente</p>
                      </>
                    )}
                  </CardContent>
                </Card>
             </div>

             <Card style={{ background: 'var(--color-surface-2)', border: '1px solid var(--color-border)' }}>
               <CardContent className="p-8 text-center space-y-4">
                 <Sparkles className="h-12 w-12 mx-auto" style={{ color: 'var(--color-ai-glow)' }} />
                 <h2 className="text-xl font-medium" style={{ color: 'var(--color-text-primary)' }}>
                   Análisis Grupal
                 </h2>
                 <p style={{ color: 'var(--color-text-secondary)' }}>
                   {meCompleted && partnerCompleted 
                      ? "Ambos completaron la evaluación. ¡Es hora de descubrir los resultados!"
                      : "Para generar el análisis, ambos miembros de la pareja deben haber completado la evaluación."}
                 </p>
                 
                 {meCompleted && partnerCompleted ? (
                   <Button 
                     onClick={handleGenerate} 
                     disabled={generating}
                     loading={generating}
                     style={{ background: 'var(--color-ai)', color: '#fff' }}
                     className="mt-4"
                   >
                     Analizar respuestas
                   </Button>
                 ) : (
                   <Button 
                     onClick={handleShare} 
                     variant="outline"
                     className="mt-4"
                   >
                     <Copy className="h-4 w-4 md:mr-2" /> <span className="hidden md:inline">Copiar Enlace de Invitación</span>
                   </Button>
                 )}
               </CardContent>
             </Card>
           </div>
        ) : (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="space-y-6"
          >
            {/* Summary */}
            <Card style={{ background: 'var(--color-surface-2)', border: '1px solid var(--color-border)' }}>
              <CardContent className="p-6 md:p-8 space-y-4">
                <h2 className="text-xl font-semibold flex items-center gap-2" style={{ color: 'var(--color-text-primary)' }}>
                  <HeartHandshake className="h-6 w-6" style={{ color: 'var(--color-conexion)' }} />
                  Lo que Descubrimos Juntos
                </h2>
                <div 
                  className="prose prose-invert max-w-none text-sm leading-relaxed"
                  style={{ color: 'var(--color-text-secondary)' }}
                >
                  {insights.ai_summary.split('\n').map((paragraph: string, i: number) => (
                    <p key={i} className={paragraph.trim() ? "mb-4" : ""}>{paragraph}</p>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Actions */}
            <h3 className="text-lg font-semibold mt-10 mb-4 px-2" style={{ color: 'var(--color-text-primary)' }}>Próximos Pasos Divertidos</h3>
            <div className="grid gap-4 md:grid-cols-2">
              {insights.ai_actions.map((action: string, idx: number) => (
                <Card key={idx} style={{ background: 'var(--color-surface-3)', border: '1px solid var(--color-border)' }}>
                  <CardContent className="p-5 flex items-start gap-3">
                    <div className="w-6 h-6 rounded-full flex shrink-0 items-center justify-center text-xs font-bold mt-0.5"
                      style={{ background: 'var(--color-ai-dim)', color: 'var(--color-ai)' }}>
                      {idx + 1}
                    </div>
                    <p className="text-sm leading-relaxed" style={{ color: 'var(--color-text-primary)' }}>
                      {action}
                    </p>
                  </CardContent>
                </Card>
              ))}
            </div>
          </motion.div>
        )}
      </div>
    </AppShell>
  );
}
