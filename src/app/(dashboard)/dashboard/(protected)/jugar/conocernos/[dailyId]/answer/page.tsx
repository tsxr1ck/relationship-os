'use client';

import { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { ArrowLeft, Send, Loader2 } from 'lucide-react';
import { AppShell } from '@/components/layout/AppShell';
import { getOrCreateDailyQuestion, submitConocenosAnswer, type ConocenosDaily } from '../../actions';

export default function ConocenosAnswerPage({ params }: { params: Promise<{ dailyId: string }> }) {
  const { dailyId } = use(params);
  const router = useRouter();
  const [daily, setDaily] = useState<ConocenosDaily | null>(null);
  const [answer, setAnswer] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getOrCreateDailyQuestion().then(data => {
      setDaily(data);
      if (data?.hasAnswered) setSubmitted(true);
      setLoading(false);
    });
  }, []);

  const handleSubmit = async () => {
    if (!answer.trim() || submitting) return;
    setSubmitting(true);
    setError('');

    const result = await submitConocenosAnswer(dailyId, answer);

    if (result.success) {
      setSubmitted(true);
    } else {
      setError(result.error || 'Error al enviar');
    }
    setSubmitting(false);
  };

  if (loading) {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[70vh]">
          <Loader2 className="h-8 w-8 animate-spin" style={{ color: 'var(--color-conexion)' }} />
        </div>
      </AppShell>
    );
  }

  // Already answered — show confirmation
  if (submitted) {
    return (
      <AppShell showNav={false}>
        <div className="max-w-md mx-auto px-5 pt-12">
          {/* Back */}
          <button
            onClick={() => router.push('/dashboard/jugar/conocernos')}
            className="flex items-center gap-2 mb-12 text-sm transition-colors"
            style={{ color: 'var(--color-text-tertiary)' }}
          >
            <ArrowLeft className="h-4 w-4" /> Volver
          </button>

          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="text-center"
          >
            <motion.div
              className="w-16 h-16 rounded-full mx-auto mb-6 flex items-center justify-center"
              style={{ background: 'var(--color-conexion-dim)', border: '2px solid var(--color-conexion)' }}
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', stiffness: 200, damping: 15, delay: 0.2 }}
            >
              <span className="text-2xl">✓</span>
            </motion.div>

            <h2 className="font-display text-2xl mb-3" style={{ color: 'var(--color-text-primary)' }}>
              Respuesta guardada
            </h2>
            <p className="text-sm leading-relaxed mb-8" style={{ color: 'var(--color-text-secondary)' }}>
              {daily?.partnerHasAnswered
                ? 'Tu pareja ya respondió. Las respuestas se revelan pronto.'
                : 'Esperando a que tu pareja responda. Las respuestas se revelan al final del día.'}
            </p>

            <button
              onClick={() => router.push('/dashboard')}
              className="px-6 py-3 rounded-2xl text-sm font-semibold transition-all active:scale-95"
              style={{ background: 'var(--color-surface-2)', color: 'var(--color-text-primary)', border: '1px solid var(--color-border)' }}
            >
              Volver al inicio
            </button>
          </motion.div>
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell showNav={false}>
      <div className="max-w-md mx-auto px-5 pt-8 pb-12 min-h-[80vh] flex flex-col">
        {/* Back */}
        <button
          onClick={() => router.back()}
          className="flex items-center gap-2 mb-8 text-sm transition-colors"
          style={{ color: 'var(--color-text-tertiary)' }}
        >
          <ArrowLeft className="h-4 w-4" /> Volver
        </button>

        {/* Question */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="flex-1"
        >
          <p
            className="text-[11px] font-bold uppercase tracking-[0.16em] mb-4"
            style={{ color: 'var(--color-conexion)' }}
          >
            Pregunta del día
          </p>

          <h1
            className="font-display text-2xl md:text-3xl leading-snug mb-10"
            style={{ color: 'var(--color-text-primary)' }}
          >
            {daily?.questionText || 'Cargando...'}
          </h1>

          {/* Answer input */}
          <div className="relative">
            <textarea
              value={answer}
              onChange={(e) => setAnswer(e.target.value.slice(0, 500))}
              placeholder="Escribe tu respuesta..."
              rows={5}
              className="w-full rounded-2xl px-5 py-4 text-[15px] leading-relaxed resize-none outline-none transition-all placeholder:opacity-40"
              style={{
                background: 'var(--color-surface-1)',
                color: 'var(--color-text-primary)',
                border: '1px solid var(--color-border)',
              }}
              onFocus={(e) => e.target.style.borderColor = 'var(--color-conexion)'}
              onBlur={(e) => e.target.style.borderColor = 'var(--color-border)'}
              autoFocus
            />
            <span
              className="absolute bottom-3 right-4 text-[11px]"
              style={{ color: answer.length > 450 ? 'var(--color-warning)' : 'var(--color-text-tertiary)' }}
            >
              {answer.length}/500
            </span>
          </div>

          {error && (
            <p className="text-sm mt-3" style={{ color: 'var(--color-danger)' }}>{error}</p>
          )}
        </motion.div>

        {/* Submit */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="mt-8"
        >
          <button
            onClick={handleSubmit}
            disabled={!answer.trim() || submitting}
            className="w-full py-4 rounded-2xl text-sm font-bold flex items-center justify-center gap-2 transition-all active:scale-[0.98] disabled:opacity-40 disabled:cursor-not-allowed"
            style={{
              background: answer.trim() ? 'var(--color-conexion)' : 'var(--color-surface-3)',
              color: answer.trim() ? 'var(--color-base)' : 'var(--color-text-tertiary)',
            }}
          >
            {submitting ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <>
                Enviar respuesta
                <Send className="h-4 w-4" />
              </>
            )}
          </button>

          <p className="text-center text-[11px] mt-3" style={{ color: 'var(--color-text-tertiary)' }}>
            Tu pareja no verá tu respuesta hasta la hora de revelación.
          </p>
        </motion.div>
      </div>
    </AppShell>
  );
}
