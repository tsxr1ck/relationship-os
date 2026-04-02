'use client';

import { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import { ArrowLeft, Heart, Clock, BookOpen, BookmarkPlus, Loader2 } from 'lucide-react';
import { AppShell } from '@/components/layout/AppShell';
import { getOrCreateDailyQuestion, reactToAnswer, type ConocenosDaily } from '../../actions';
import { saveRevealToHistory } from '../../../historia/actions';
import { logActivityEvent } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';

const REACTION_EMOJIS = ['❤️', '😲', '😂', '🥹', '🤔'];

export default function ConocenosRevealPage({ params }: { params: Promise<{ dailyId: string }> }) {
  const { dailyId } = use(params);
  const router = useRouter();
  const [daily, setDaily] = useState<ConocenosDaily | null>(null);
  const [loading, setLoading] = useState(true);
  const [selectedEmoji, setSelectedEmoji] = useState<string | null>(null);
  const [comment, setComment] = useState('');
  const [reactionSent, setReactionSent] = useState(false);
  const [savingHistory, setSavingHistory] = useState(false);
  const [savedToHistory, setSavedToHistory] = useState(false);

  useEffect(() => {
    getOrCreateDailyQuestion().then(data => {
      setDaily(data);
      if (data?.userReaction?.emoji) {
        setSelectedEmoji(data.userReaction.emoji);
        setReactionSent(true);
      }
      if (data?.userReaction?.comment) {
        setComment(data.userReaction.comment);
      }
      setLoading(false);

      if (data?.isRevealed) {
        logActivityEvent('conocernos.revealed', 'conocernos_reveal', dailyId, {});
      }
    });
  }, []);

  const handleReaction = async (emoji: string) => {
    if (!daily) return;
    setSelectedEmoji(emoji);

    // We need the partner's user ID — derive it from the daily context
    // For now, send the reaction to the server action which handles it
    const result = await reactToAnswer(dailyId, 'partner', emoji, comment || null);
    if (result.success) setReactionSent(true);
  };

  const handeSaveToHistory = async () => {
    if (!daily || !daily.userAnswer || !daily.partnerAnswer) return;
    setSavingHistory(true);
    const result = await saveRevealToHistory({
      dailyId,
      questionText: daily.questionText,
      userAnswer: daily.userAnswer,
      partnerAnswer: daily.partnerAnswer,
      dimension: daily.dimension,
      date: daily.questionDate,
    });
    if (result.success) {
      setSavedToHistory(true);
    }
    setSavingHistory(false);
  };

  if (loading) {
    return (
      <AppShell showNav={false}>
        <div className="flex items-center justify-center min-h-[70vh]">
          <div className="w-8 h-8 rounded-full border-2 border-t-transparent animate-spin"
            style={{ borderColor: 'var(--color-conexion)', borderTopColor: 'transparent' }} />
        </div>
      </AppShell>
    );
  }

  // Not yet revealed
  if (daily && !daily.isRevealed) {
    return (
      <AppShell showNav={false}>
        <div className="max-w-md mx-auto px-5 pt-12">
          <button
            onClick={() => router.push('/dashboard/jugar/conocernos')}
            className="flex items-center gap-2 mb-12 text-sm"
            style={{ color: 'var(--color-text-tertiary)' }}
          >
            <ArrowLeft className="h-4 w-4" /> Volver
          </button>

          <div className="text-center">
            <Clock className="h-12 w-12 mx-auto mb-4" style={{ color: 'var(--color-text-tertiary)', opacity: 0.4 }} />
            <h2 className="font-display text-2xl mb-3" style={{ color: 'var(--color-text-primary)' }}>
              Aún no es hora
            </h2>
            <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
              Las respuestas se revelan a las{' '}
              {new Date(daily.revealAt).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })}.
            </p>
          </div>
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell showNav={false}>
      <div className="max-w-md mx-auto px-5 pt-8 pb-12">
        {/* Back */}
        <button
          onClick={() => router.push('/dashboard/jugar/conocernos')}
          className="flex items-center gap-2 mb-8 text-sm"
          style={{ color: 'var(--color-text-tertiary)' }}
        >
          <ArrowLeft className="h-4 w-4" /> Volver
        </button>

        {/* Question */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
        >
          <p
            className="text-[11px] font-bold uppercase tracking-[0.16em] mb-3"
            style={{ color: 'var(--color-accent-rose)' }}
          >
            {daily?.questionDate
              ? new Date(daily.questionDate).toLocaleDateString('es-MX', { day: 'numeric', month: 'long', year: 'numeric' })
              : 'Hoy'}
          </p>

          <h1
            className="font-display text-xl md:text-2xl leading-snug mb-8 italic"
            style={{ color: 'var(--color-text-primary)' }}
          >
            &ldquo;{daily?.questionText}&rdquo;
          </h1>
        </motion.div>

        {/* Side by side answers */}
        <div className="space-y-4 mb-8">
          {/* User's answer */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2, duration: 0.5 }}
          >
            <div
              className="rounded-[20px] p-5"
              style={{
                background: 'linear-gradient(135deg, var(--color-conexion-dim) 0%, var(--color-surface-1) 100%)',
                border: '1px solid var(--color-border)',
              }}
            >
              <p className="text-[10px] font-bold uppercase tracking-[0.2em] mb-3" style={{ color: 'var(--color-conexion)' }}>
                Tú dijiste
              </p>
              <p className="text-[15px] leading-relaxed" style={{ color: 'var(--color-text-primary)' }}>
                {daily?.userAnswer || 'No respondiste esta vez.'}
              </p>

              {/* Partner's reaction to my answer */}
              {daily?.partnerReaction?.emoji && (
                <motion.div
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ type: 'spring', delay: 0.8 }}
                  className="mt-3 flex items-center gap-2"
                >
                  <span className="text-lg">{daily.partnerReaction.emoji}</span>
                  {daily.partnerReaction.comment && (
                    <span className="text-xs italic" style={{ color: 'var(--color-text-secondary)' }}>
                      &ldquo;{daily.partnerReaction.comment}&rdquo;
                    </span>
                  )}
                </motion.div>
              )}
            </div>
          </motion.div>

          {/* Partner's answer */}
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.4, duration: 0.5 }}
          >
            <div
              className="rounded-[20px] p-5"
              style={{
                background: 'linear-gradient(135deg, var(--color-cuidado-dim) 0%, var(--color-surface-1) 100%)',
                border: '1px solid var(--color-border)',
              }}
            >
              <p className="text-[10px] font-bold uppercase tracking-[0.2em] mb-3" style={{ color: 'var(--color-cuidado)' }}>
                Tu pareja dijo
              </p>
              <p className="text-[15px] leading-relaxed" style={{ color: 'var(--color-text-primary)' }}>
                {daily?.partnerAnswer || 'No respondió esta vez.'}
              </p>
            </div>
          </motion.div>
        </div>

        {/* Reaction bar */}
        {daily?.partnerAnswer && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.6 }}
          >
            <p
              className="text-[11px] font-bold uppercase tracking-[0.14em] mb-3 text-center"
              style={{ color: 'var(--color-text-tertiary)' }}
            >
              ¿Cómo te hizo sentir?
            </p>

            <div className="flex items-center justify-center gap-3 mb-6">
              {REACTION_EMOJIS.map((emoji) => (
                <motion.button
                  key={emoji}
                  onClick={() => handleReaction(emoji)}
                  whileTap={{ scale: 0.85 }}
                  className="w-12 h-12 rounded-2xl flex items-center justify-center text-xl transition-all"
                  style={{
                    background: selectedEmoji === emoji ? 'var(--color-surface-3)' : 'var(--color-surface-1)',
                    border: selectedEmoji === emoji ? '2px solid var(--color-conexion)' : '1px solid var(--color-border)',
                    boxShadow: selectedEmoji === emoji ? '0 0 12px rgba(232, 116, 138, 0.25)' : 'none',
                  }}
                >
                  {emoji}
                </motion.button>
              ))}
            </div>

            {/* Comment input */}
            {selectedEmoji && (
              <motion.div
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: 'auto' }}
                className="mb-6"
              >
                <textarea
                  value={comment}
                  onChange={(e) => setComment(e.target.value.slice(0, 280))}
                  placeholder="Agrega un comentario (opcional)..."
                  rows={2}
                  className="w-full rounded-2xl px-4 py-3 text-sm resize-none outline-none"
                  style={{
                    background: 'var(--color-surface-1)',
                    color: 'var(--color-text-primary)',
                    border: '1px solid var(--color-border)',
                  }}
                />
              </motion.div>
            )}

            {reactionSent && (
              <motion.p
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="text-center text-xs"
                style={{ color: 'var(--color-success-warm)' }}
              >
                ✓ Tu reacción fue guardada
              </motion.p>
            )}
          </motion.div>
        )}

        {/* Action buttons */}
        <div className="mt-8 flex flex-col gap-3">
          {daily?.partnerAnswer && (
            <button
              onClick={handeSaveToHistory}
              disabled={savingHistory || savedToHistory}
              className={`w-full py-3.5 rounded-2xl text-sm font-semibold flex items-center justify-center gap-2 transition-all ${savedToHistory ? 'opacity-50' : 'active:scale-[0.98]'}`}
              style={{
                background: 'var(--color-surface-1)',
                color: savedToHistory ? 'var(--color-success-warm)' : 'var(--color-accent-rose)',
                border: '1px solid var(--color-border)'
              }}
            >
              {savingHistory ? <Loader2 className="h-4 w-4 animate-spin" /> : 
               savedToHistory ? ' Guardado en historia' : 
               <><BookmarkPlus className="h-4 w-4" /> Guardar en Nuestra Historia</>}
            </button>
          )}

          <button
            onClick={() => router.push('/dashboard')}
            className="w-full py-3.5 rounded-2xl text-sm font-semibold transition-all active:scale-[0.98]"
            style={{ background: 'var(--color-surface-2)', color: 'var(--color-text-primary)', border: '1px solid var(--color-border)' }}
          >
            Volver al inicio
          </button>
        </div>
      </div>
    </AppShell>
  );
}
