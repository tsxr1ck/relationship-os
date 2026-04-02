'use client';

import { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import { Loader2, ArrowLeft, Check, FastForward } from 'lucide-react';
import { AppShell } from '@/components/layout/AppShell';
import { submitQuizAnswer, getQuizSession, type QuizSession } from '../actions';
import { createClient } from '@/lib/supabase/client';

export default function QuizLivePage({ params }: { params: Promise<{ sessionId: string }> }) {
  const { sessionId } = use(params);
  const router = useRouter();
  
  const [session, setSession] = useState<QuizSession | null>(null);
  const [loading, setLoading] = useState(true);
  const [myUserId, setMyUserId] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  
  // Custom polling hook effect
  useEffect(() => {
    let intervalId: NodeJS.Timeout;
    
    async function fetchState() {
      // Get self ID once
      if (!myUserId) {
         const supabase = createClient();
         const { data: { user } } = await supabase.auth.getUser();
         if (user) setMyUserId(user.id);
      }
      
      const st = await getQuizSession(sessionId);
      if (st) {
        setSession(st);
        setLoading(false);
      }
    }
    
    // Initial fetch
    fetchState();
    
    // Poll every 2.5 seconds
    intervalId = setInterval(fetchState, 2500);
    return () => clearInterval(intervalId);
  }, [sessionId, myUserId]);

  if (loading || !myUserId) {
    return (
      <AppShell showNav={false}>
        <div className="flex flex-col items-center justify-center min-h-[70vh]">
          <Loader2 className="h-8 w-8 animate-spin mb-4" style={{ color: 'var(--color-cuidado)' }} />
          <p className="text-sm text-center px-4" style={{ color: 'var(--color-text-secondary)' }}>
            Sincronizando con tu pareja...<br/>
            No cierres la pantalla.
          </p>
        </div>
      </AppShell>
    );
  }

  if (!session) {
    return (
      <AppShell showNav={false}>
         <div className="text-center pt-24">Error: Sesión no encontrada</div>
      </AppShell>
    );
  }

  if (session.status === 'completed') {
    return (
      <AppShell showNav={false}>
        <div className="max-w-md mx-auto px-5 pt-12 text-center">
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ type: 'spring', delay: 0.1 }}
            className="w-20 h-20 rounded-full mx-auto mb-6 flex items-center justify-center"
            style={{ background: 'var(--color-cuidado)', color: 'var(--color-base)' }}
          >
            <Check className="h-10 w-10" />
          </motion.div>
          <h1 className="font-display text-3xl mb-3" style={{ color: 'var(--color-text-primary)' }}>
            ¡Quiz Terminado!
          </h1>
          <p className="text-sm mb-12" style={{ color: 'var(--color-text-secondary)' }}>
            Pueden ver sus respuestas en Nuestra Historia pronto.
          </p>
          <button
            onClick={() => router.push('/dashboard/jugar/favoritos')}
            className="w-full py-4 rounded-2xl text-sm font-bold transition-all active:scale-[0.98]"
            style={{ background: 'var(--color-surface-2)', color: 'var(--color-text-primary)', border: '1px solid var(--color-border)' }}
          >
            Volver a Favoritos
          </button>
        </div>
      </AppShell>
    );
  }

  // Active playing state
  const currentQ = session.questions[session.currentQuestionIndex];
  const qObj = session.answers[session.currentQuestionIndex.toString()] || {};
  const iAnswered = !!qObj[myUserId];
  const partnerAnsweredKeys = Object.keys(qObj).filter(k => k !== myUserId);
  const partnerAnswered = partnerAnsweredKeys.length > 0;

  const handleSelect = async (opt: string) => {
    if (iAnswered || submitting) return;
    setSubmitting(true);
    await submitQuizAnswer(sessionId, session.currentQuestionIndex, opt);
    // Optimistic UI update handled by the next poll (2.5s)
    setSubmitting(false);
  };

  return (
    <AppShell showNav={false}>
      <div className="max-w-md mx-auto px-5 pt-8 pb-12 flex flex-col min-h-screen">
        
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <button onClick={() => router.push('/dashboard/jugar/favoritos')} className="text-sm flex items-center" style={{ color: 'var(--color-text-tertiary)' }}>
            <ArrowLeft className="h-4 w-4 mr-1" /> Salir
          </button>
          <span className="text-[11px] uppercase tracking-[0.2em] font-bold px-3 py-1 rounded-full" style={{ background: 'var(--color-surface-2)', color: 'var(--color-text-primary)' }}>
            {session.currentQuestionIndex + 1} / {session.questions.length}
          </span>
        </div>

        {/* Progress Bar */}
        <div className="w-full h-1.5 rounded-full mb-10 overflow-hidden" style={{ background: 'var(--color-surface-1)' }}>
          <motion.div
             className="h-full rounded-full"
             style={{ background: 'var(--color-cuidado)' }}
             initial={{ width: 0 }}
             animate={{ width: `${(session.currentQuestionIndex / session.questions.length) * 100}%` }}
             transition={{ duration: 0.5 }}
          />
        </div>

        {/* Question Area */}
        <AnimatePresence mode="wait">
           <motion.div
             key={session.currentQuestionIndex}
             initial={{ opacity: 0, x: 20 }}
             animate={{ opacity: 1, x: 0 }}
             exit={{ opacity: 0, x: -20 }}
             className="flex-1"
           >
              <h2 className="font-display text-2xl md:text-3xl leading-snug mb-10 text-center" style={{ color: 'var(--color-text-primary)' }}>
                {currentQ.question_text}
              </h2>

              <div className="space-y-3 relative">
                
                {/* Options overlay if waiting for partner */}
                {iAnswered && !partnerAnswered && (
                  <div className="absolute inset-0 z-10 flex flex-col items-center justify-center rounded-[20px] backdrop-blur-[2px]" style={{ background: 'rgba(0,0,0,0.4)' }}>
                     <Loader2 className="h-6 w-6 animate-spin mb-3" style={{ color: 'var(--color-base)' }} />
                     <p className="text-sm font-bold text-white text-center">Esperando a tu pareja...</p>
                  </div>
                )}

                {JSON.parse(currentQ.options).map((opt: string, i: number) => {
                  const isSelected = qObj[myUserId] === opt;
                  
                  return (
                    <motion.button
                      key={i}
                      whileTap={{ scale: iAnswered ? 1 : 0.98 }}
                      onClick={() => handleSelect(opt)}
                      disabled={iAnswered}
                      className="w-full text-left p-5 rounded-2xl text-[15px] transition-all relative overflow-hidden"
                      style={{
                        background: isSelected ? 'var(--color-cuidado)' : 'var(--color-surface-1)',
                        color: isSelected ? 'var(--color-base)' : 'var(--color-text-primary)',
                        border: isSelected ? '1px solid var(--color-cuidado)' : '1px solid var(--color-border)',
                      }}
                    >
                      {opt}
                    </motion.button>
                  );
                })}
              </div>
           </motion.div>
        </AnimatePresence>

        {/* Partner Status SnackBar */}
        {!iAnswered && partnerAnswered && (
          <motion.div
             initial={{ opacity: 0, y: 20 }}
             animate={{ opacity: 1, y: 0 }}
             className="fixed bottom-8 left-1/2 -translate-x-1/2 px-6 py-3 rounded-full flex items-center gap-2 shadow-2xl z-50 whitespace-nowrap"
             style={{ background: 'var(--color-text-primary)', color: 'var(--color-base)' }}
          >
             <FastForward className="h-4 w-4" />
             <span className="text-sm font-bold">Tu pareja ya respondió</span>
          </motion.div>
        )}

      </div>
    </AppShell>
  );
}
