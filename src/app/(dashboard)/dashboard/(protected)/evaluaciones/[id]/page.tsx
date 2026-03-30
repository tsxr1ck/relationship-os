'use client';

import { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { Loader2, ArrowLeft, ArrowRight, CheckCircle2, AlertCircle } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { getEvaluation, submitCustomEvaluationAnswers } from '../actions';
import { toast } from 'sonner';

export default function TakeEvaluationPage({ params }: { params: Promise<{ id: string }> }) {
  const unwrappedParams = use(params);
  const router = useRouter();
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [answers, setAnswers] = useState<Record<string, any>>({});
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    loadEval();
  }, [unwrappedParams.id]);

  async function loadEval() {
    try {
      const resp = await getEvaluation(unwrappedParams.id);
      setData(resp);
      
      // prepopulate answers if any
      if (resp.answers && resp.answers.length > 0) {
        const ansObj: Record<string, any> = {};
        for (const a of resp.answers) {
          ansObj[a.question_id] = a.answer_value;
        }
        setAnswers(ansObj);
      }
    } catch (err: any) {
      toast.error('Error', { description: err.message });
      router.push('/dashboard/evaluaciones');
    } finally {
      setLoading(false);
    }
  }

  const handleSelect = (questionId: string, value: any) => {
    setAnswers(prev => ({ ...prev, [questionId]: value }));
  };

  const handleNext = () => {
    if (currentIndex < data.questions.length - 1) {
      setCurrentIndex(prev => prev + 1);
    }
  };

  const handlePrev = () => {
    if (currentIndex > 0) {
      setCurrentIndex(prev => prev - 1);
    }
  };

  const handleSubmit = async () => {
    try {
      setSubmitting(true);
      toast.loading('Guardando respuestas...', { id: 'submit-eval' });
      await submitCustomEvaluationAnswers(unwrappedParams.id, answers);
      toast.success('¡Respuestas guardadas!', { id: 'submit-eval' });
      // Reload to see if partner is done or to show waiting state
      await loadEval();
    } catch (err: any) {
      toast.error('Error al guardar', { id: 'submit-eval', description: err.message });
    } finally {
      setSubmitting(false);
    }
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

  if (!data) return null;

  if (data.completed || (data.answers && data.answers.length === data.questions.length)) {
    return (
      <AppShell>
        <div className="flex flex-col items-center justify-center min-h-[60vh] max-w-md mx-auto text-center space-y-4">
          <div className="w-16 h-16 rounded-full flex items-center justify-center" style={{ background: 'var(--color-conexion-dim)' }}>
            <CheckCircle2 className="h-8 w-8" style={{ color: 'var(--color-conexion)' }} />
          </div>
          <h1 className="text-2xl font-bold" style={{ color: 'var(--color-text-primary)' }}>¡Completado!</h1>
          <p style={{ color: 'var(--color-text-secondary)' }}>
            Has respondido todas las preguntas. Sus respuestas se combinarán para generar el análisis.
          </p>
          <Button 
            onClick={() => router.push(`/dashboard/evaluaciones/${unwrappedParams.id}/results`)}
            className="mt-4"
          >
            Ver Resultados
          </Button>
          <Button variant="ghost" onClick={() => router.push('/dashboard/evaluaciones')}>
            Volver a Evaluaciones
          </Button>
        </div>
      </AppShell>
    );
  }

  const currentQ = data.questions[currentIndex];
  const isLast = currentIndex === data.questions.length - 1;
  const hasAnswer = answers[currentQ.id] !== undefined && answers[currentQ.id] !== '';

  return (
    <AppShell>
      <div className="max-w-2xl mx-auto pt-4 pb-20">
        <button 
          onClick={() => router.push('/dashboard/evaluaciones')}
          className="flex items-center gap-2 text-sm mb-6 transition-colors"
          style={{ color: 'var(--color-text-tertiary)' }}
        >
          <ArrowLeft className="h-4 w-4" /> Volver
        </button>

        <div className="mb-8">
          <h1 className="text-2xl font-bold mb-1" style={{ color: 'var(--color-text-primary)' }}>{data.evaluation.title}</h1>
          <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>Pregunta {currentIndex + 1} de {data.questions.length}</p>
          
          {/* Progress bar */}
          <div className="w-full h-1.5 rounded-full mt-4 overflow-hidden" style={{ background: 'var(--color-surface-3)' }}>
            <div 
              className="h-full transition-all duration-300 ease-in-out" 
              style={{ background: 'var(--color-ai)', width: `${((currentIndex) / data.questions.length) * 100}%` }}
            />
          </div>
        </div>

        <AnimatePresence mode="wait">
          <motion.div
            key={currentQ.id}
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            transition={{ duration: 0.2 }}
          >
            <Card style={{ background: 'var(--color-surface-2)', border: '1px solid var(--color-border)' }}>
              <CardContent className="p-6 md:p-8">
                <h2 className="text-xl md:text-2xl font-medium mb-8" style={{ color: 'var(--color-text-primary)' }}>
                  {currentQ.question_text}
                </h2>

                {currentQ.question_type === 'LIKERT-5' && (
                  <div className="space-y-3">
                    {[1, 2, 3, 4, 5].map(val => (
                      <button
                        key={val}
                        onClick={() => handleSelect(currentQ.id, val)}
                        className="w-full text-left p-4 rounded-xl border transition-all"
                        style={{
                          background: answers[currentQ.id] === val ? 'var(--color-ai-dim)' : 'transparent',
                          borderColor: answers[currentQ.id] === val ? 'var(--color-ai)' : 'var(--color-border)',
                          color: answers[currentQ.id] === val ? 'var(--color-ai)' : 'var(--color-text-primary)'
                        }}
                      >
                        {val === 1 && '1 - Totalmente en desacuerdo'}
                        {val === 2 && '2 - En desacuerdo'}
                        {val === 3 && '3 - Neutral'}
                        {val === 4 && '4 - De acuerdo'}
                        {val === 5 && '5 - Totalmente de acuerdo'}
                      </button>
                    ))}
                  </div>
                )}

                {currentQ.question_type === 'OPEN' && (
                  <textarea
                    rows={4}
                    value={answers[currentQ.id] || ''}
                    onChange={(e) => handleSelect(currentQ.id, e.target.value)}
                    placeholder="Escribe tu respuesta aquí..."
                    className="w-full p-4 rounded-xl resize-none outline-none focus:ring-2"
                    style={{
                      background: 'var(--color-surface-3)',
                      color: 'var(--color-text-primary)',
                      border: '1px solid var(--color-border)',
                      outlineColor: 'var(--color-ai)'
                    }}
                  />
                )}
              </CardContent>
            </Card>
          </motion.div>
        </AnimatePresence>

        <div className="flex items-center justify-between mt-8">
          <Button
            variant="outline"
            onClick={handlePrev}
            disabled={currentIndex === 0 || submitting}
          >
            Anterior
          </Button>

          {isLast ? (
            <Button
              onClick={handleSubmit}
              disabled={!hasAnswer || submitting}
              loading={submitting}
              style={{ background: 'var(--color-ai)', color: '#fff' }}
            >
              Terminar y Guardar
            </Button>
          ) : (
            <Button
              onClick={handleNext}
              disabled={!hasAnswer || submitting}
            >
              Siguiente <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          )}
        </div>
      </div>
    </AppShell>
  );
}
