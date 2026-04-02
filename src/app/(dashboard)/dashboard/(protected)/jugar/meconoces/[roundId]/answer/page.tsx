'use client';

import { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import { AppShell } from '@/components/layout/AppShell';
import { motion } from 'framer-motion';
import { ArrowLeft, Loader2, Check } from 'lucide-react';
import { getRoundDetails, submitRoundAnswers, type MeConocesEntry } from '../../actions';

export default function AnswerPage({ params }: { params: Promise<{ roundId: string }> }) {
  const { roundId } = use(params);
  const router = useRouter();
  const [entries, setEntries] = useState<MeConocesEntry[]>([]);
  const [answers, setAnswers] = useState<Record<string, any>>({});
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [roundStatus, setRoundStatus] = useState<string | null>(null);
  const [error, setError] = useState('');

  useEffect(() => {
    async function load() {
      const { round, entries: ents } = await getRoundDetails(roundId);
      if (!round) {
        setError('Ronda no encontrada');
        setLoading(false);
        return;
      }
      setRoundStatus(round.status);
      if (round.status === 'pending_guesses' || round.status === 'completed') {
        router.push(`/dashboard/jugar/meconoces/${roundId}/guess`);
        return;
      }
      setEntries(ents);
      setLoading(false);
    }
    load();
  }, [roundId, router]);

  const handleAnswer = (entryId: string, value: any) => {
    setAnswers(prev => ({ ...prev, [entryId]: value }));
  };

  const handleSubmit = async () => {
    const unanswered = entries.filter(e => !answers[e.id]);
    if (unanswered.length > 0) {
      setError('Responde todas las preguntas');
      return;
    }
    setSubmitting(true);
    const result = await submitRoundAnswers(
      roundId,
      entries.map(e => ({ entryId: e.id, answer: answers[e.id] }))
    );
    setSubmitting(false);
    if (result.success) {
      router.push(`/dashboard/jugar/meconoces/${roundId}/guess`);
    } else {
      setError(result.error || 'Error al enviar respuestas');
    }
  };

  const progress = entries.length > 0
    ? Object.keys(answers).length / entries.length * 100
    : 0;

  if (loading) {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[70vh]">
          <Loader2 className="h-10 w-10 animate-spin" style={{ color: 'var(--color-conexion)' }} />
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell showNav={false}>
      <div className="max-w-lg mx-auto px-4 py-6 space-y-6">
        {/* Header */}
        <div className="flex items-center gap-3">
          <button
            onClick={() => router.push('/dashboard/jugar/meconoces')}
            className="p-2 rounded-xl transition-colors hover:bg-surface-3"
            style={{ color: 'var(--color-text-secondary)' }}
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div className="flex-1">
            <h1 className="font-display text-xl" style={{ color: 'var(--color-text-primary)' }}>
              Responde sobre ti
            </h1>
            <p className="text-xs" style={{ color: 'var(--color-text-tertiary)' }}>
              {Object.keys(answers).length} de {entries.length} respondidas
            </p>
          </div>
        </div>

        {/* Progress */}
        <div className="w-full h-2 rounded-full overflow-hidden" style={{ background: 'var(--color-surface-3)' }}>
          <motion.div
            className="h-full rounded-full"
            style={{ background: 'var(--color-conexion)' }}
            initial={{ width: 0 }}
            animate={{ width: `${progress}%` }}
          />
        </div>

        {/* Questions */}
        <div className="space-y-4">
          {entries.map((entry, i) => (
            <motion.div
              key={entry.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
              className="rounded-2xl p-5"
              style={{
                background: 'var(--color-surface-1)',
                border: `1px solid ${answers[entry.id] ? 'var(--color-success)' : 'var(--color-border)'}`,
              }}
            >
              <p className="text-sm font-medium mb-4" style={{ color: 'var(--color-text-primary)' }}>
                {entry.questionText}
              </p>

              {entry.questionType === 'LIKERT-5' && (
                <div className="flex gap-2 justify-center">
                  {[1, 2, 3, 4, 5].map(n => (
                    <button
                      key={n}
                      onClick={() => handleAnswer(entry.id, n)}
                      className="w-12 h-12 rounded-xl text-sm font-bold transition-all"
                      style={{
                        background: answers[entry.id] === n
                          ? 'var(--color-conexion)'
                          : 'var(--color-surface-3)',
                        color: answers[entry.id] === n
                          ? 'var(--color-base)'
                          : 'var(--color-text-secondary)',
                      }}
                    >
                      {n}
                    </button>
                  ))}
                </div>
              )}

              {entry.questionType === 'MULTIPLE_CHOICE' && entry.options && (
                <div className="space-y-2">
                  {entry.options.map((opt: any, oi: number) => (
                    <button
                      key={oi}
                      onClick={() => handleAnswer(entry.id, opt.value || opt)}
                      className="w-full text-left px-4 py-3 rounded-xl text-sm transition-all"
                      style={{
                        background: answers[entry.id] === (opt.value || opt)
                          ? 'var(--color-conexion)'
                          : 'var(--color-surface-3)',
                        color: answers[entry.id] === (opt.value || opt)
                          ? 'var(--color-base)'
                          : 'var(--color-text-secondary)',
                      }}
                    >
                      {opt.label || opt}
                    </button>
                  ))}
                </div>
              )}

              {entry.questionType === 'SHORT_TEXT' && (
                <input
                  type="text"
                  value={answers[entry.id] || ''}
                  onChange={e => handleAnswer(entry.id, e.target.value)}
                  placeholder="Tu respuesta..."
                  className="w-full px-4 py-3 rounded-xl text-sm outline-none transition-colors"
                  style={{
                    background: 'var(--color-surface-3)',
                    color: 'var(--color-text-primary)',
                    border: `1px solid ${answers[entry.id] ? 'var(--color-conexion)' : 'var(--color-border)'}`,
                  }}
                />
              )}

              {entry.questionType === 'RANK' && entry.options && (
                <div className="space-y-2">
                  <p className="text-xs mb-2" style={{ color: 'var(--color-text-tertiary)' }}>
                    Selecciona en orden de importancia (primero el más importante)
                  </p>
                  {entry.options.map((opt: any, oi: number) => (
                    <button
                      key={oi}
                      onClick={() => {
                        const current = answers[entry.id] || [];
                        const val = opt.value || opt;
                        if (current.includes(val)) {
                          handleAnswer(entry.id, current.filter((v: any) => v !== val));
                        } else {
                          handleAnswer(entry.id, [...current, val]);
                        }
                      }}
                      className="w-full text-left px-4 py-3 rounded-xl text-sm transition-all flex items-center gap-3"
                      style={{
                        background: answers[entry.id]?.includes(opt.value || opt)
                          ? 'var(--color-conexion)'
                          : 'var(--color-surface-3)',
                        color: answers[entry.id]?.includes(opt.value || opt)
                          ? 'var(--color-base)'
                          : 'var(--color-text-secondary)',
                      }}
                    >
                      {answers[entry.id]?.indexOf(opt.value || opt) !== -1 && (
                        <span className="w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold" style={{ background: 'rgba(255,255,255,0.2)' }}>
                          {answers[entry.id].indexOf(opt.value || opt) + 1}
                        </span>
                      )}
                      {opt.label || opt}
                    </button>
                  ))}
                </div>
              )}
            </motion.div>
          ))}
        </div>

        {error && (
          <p className="text-sm text-center" style={{ color: 'var(--color-danger)' }}>{error}</p>
        )}

        <button
          onClick={handleSubmit}
          disabled={submitting || Object.keys(answers).length < entries.length}
          className="w-full py-3.5 rounded-xl text-sm font-semibold transition-all disabled:opacity-50 flex items-center justify-center gap-2"
          style={{
            background: 'var(--color-conexion)',
            color: 'var(--color-base)',
          }}
        >
          {submitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check className="w-4 h-4" />}
          {submitting ? 'Enviando...' : 'Enviar respuestas'}
        </button>
      </div>
    </AppShell>
  );
}
