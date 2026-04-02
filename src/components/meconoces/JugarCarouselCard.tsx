'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import { ArrowRight, MessageCircle, Sparkles, BookOpen, Gamepad2, Zap, ChevronLeft, ChevronRight, Play } from 'lucide-react';
import { getOrCreateDailyQuestion, type ConocenosDaily } from '@/app/(dashboard)/dashboard/(protected)/jugar/conocernos/actions';
import { getActiveRound } from '@/app/(dashboard)/dashboard/(protected)/jugar/meconoces/actions';
import { getActiveGame } from '@/app/(dashboard)/dashboard/(protected)/jugar/sintonia/actions';

const GAMES = [
  {
    id: 'conocernos',
    title: 'Conocernos',
    subtitle: 'Pregunta del día',
    description: 'Una pregunta al día para descubrir algo nuevo del otro.',
    icon: MessageCircle,
    color: 'var(--color-conexion)',
    dimBg: 'var(--color-conexion-dim)',
    href: '/dashboard/jugar/conocernos',
  },
  {
    id: 'meconoces',
    title: '¿Me conoces?',
    subtitle: 'Juego de adivinanza',
    description: 'Adivina las respuestas de tu pareja. ¿Cuánto se conocen?',
    icon: Sparkles,
    color: 'var(--color-camino)',
    dimBg: 'var(--color-camino-dim)',
    href: '/dashboard/jugar/meconoces',
  },
  {
    id: 'sintonia',
    title: 'Sintonía',
    subtitle: 'Dilemas en vivo',
    description: 'Conéctense al mismo tiempo y respondan dilemas juntos.',
    icon: Zap,
    color: 'var(--color-choque)',
    dimBg: 'var(--color-choque-dim)',
    href: '/dashboard/jugar/sintonia',
  },
  {
    id: 'historia',
    title: 'Nuestra Historia',
    subtitle: 'Diario compartido',
    description: 'Su diario de momentos, recuerdos y primeras veces.',
    icon: BookOpen,
    color: 'var(--color-accent-rose)',
    dimBg: 'var(--color-memory-tint)',
    href: '/dashboard/jugar/historia',
  },
  {
    id: 'quizzes',
    title: 'Quizzes',
    subtitle: 'Diversión rápida',
    description: 'Quizzes rápidos y divertidos para jugar juntos.',
    icon: Gamepad2,
    color: 'var(--color-cuidado)',
    dimBg: 'var(--color-cuidado-dim)',
    href: '/dashboard/jugar/favoritos',
  },
];

export function JugarCarouselCard() {
  const router = useRouter();
  const [current, setCurrent] = useState(0);
  const [conocernos, setConocernos] = useState<ConocenosDaily | null>(null);
  const [activeRound, setActiveRound] = useState<any>(null);
  const [isPaused, setIsPaused] = useState(false);

  useEffect(() => {
    getOrCreateDailyQuestion().then(d => setConocernos(d));
    getActiveRound().then(r => setActiveRound(r));
  }, []);

  const next = useCallback(() => {
    setCurrent(prev => (prev + 1) % GAMES.length);
  }, []);

  const prev = useCallback(() => {
    setCurrent(prev => (prev - 1 + GAMES.length) % GAMES.length);
  }, []);

  useEffect(() => {
    if (isPaused) return;
    const timer = setInterval(next, 5000);
    return () => clearInterval(timer);
  }, [next, isPaused]);

  const game = GAMES[current];
  const Icon = game.icon;

  const getBadge = () => {
    if (game.id === 'conocernos' && conocernos && !conocernos.hasAnswered) return 'Nueva pregunta';
    if (game.id === 'meconoces' && activeRound) return 'Ronda en curso';
    return null;
  };

  const badge = getBadge();

  const handleClick = () => {
    if (game.id === 'meconoces' && activeRound) {
      if (activeRound.status === 'pending_answers') {
        router.push(`/dashboard/jugar/meconoces/${activeRound.id}/answer`);
        return;
      }
      if (activeRound.status === 'pending_guesses') {
        router.push(`/dashboard/jugar/meconoces/${activeRound.id}/guess`);
        return;
      }
    }
    router.push(game.href);
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.15 }}
    >
      <div
        className="rounded-[20px] overflow-hidden transition-all duration-300"
        style={{
          background: game.dimBg,
          border: '1px solid var(--color-border)',
        }}
        onMouseEnter={() => setIsPaused(true)}
        onMouseLeave={() => setIsPaused(false)}
      >
        {/* Header bar */}
        <div className="flex items-center justify-between px-5 pt-4 pb-2">
          <div className="flex items-center gap-2">
            <Play className="w-3.5 h-3.5" style={{ color: 'var(--color-text-tertiary)' }} />
            <span className="text-[11px] font-bold uppercase tracking-[0.16em]" style={{ color: 'var(--color-text-tertiary)' }}>
              Jugar
            </span>
          </div>

          {/* Dots */}
          <div className="flex items-center gap-1.5">
            {GAMES.map((_, i) => (
              <button
                key={i}
                onClick={() => setCurrent(i)}
                className="rounded-full transition-all duration-300"
                style={{
                  width: i === current ? 20 : 6,
                  height: 6,
                  background: i === current ? game.color : 'var(--color-surface-3)',
                }}
              />
            ))}
          </div>
        </div>

        {/* Content */}
        <div className="px-5 pb-4">
          <AnimatePresence mode="wait">
            <motion.div
              key={current}
              initial={{ opacity: 0, x: 30 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -30 }}
              transition={{ duration: 0.35, ease: 'easeOut' }}
              className="flex items-start gap-4"
            >
              {/* Icon */}
              <div
                className="w-12 h-12 rounded-xl flex items-center justify-center shrink-0"
                style={{ background: game.color }}
              >
                <Icon className="w-6 h-6" style={{ color: 'var(--color-base)' }} />
              </div>

              {/* Text */}
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-0.5">
                  <h3 className="font-display text-lg" style={{ color: 'var(--color-text-primary)' }}>
                    {game.title}
                  </h3>
                  {badge && (
                    <span
                      className="px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider"
                      style={{ background: game.color, color: 'var(--color-base)' }}
                    >
                      {badge}
                    </span>
                  )}
                </div>
                <p className="text-[11px] font-medium mb-1" style={{ color: game.color }}>
                  {game.subtitle}
                </p>
                <p className="text-sm leading-relaxed" style={{ color: 'var(--color-text-secondary)' }}>
                  {game.description}
                </p>
              </div>
            </motion.div>
          </AnimatePresence>
        </div>

        {/* Footer */}
        <div
          className="flex items-center justify-between px-5 py-3"
          style={{ borderTop: '1px solid var(--color-border)' }}
        >
          <div className="flex items-center gap-1">
            <button
              onClick={prev}
              className="p-1.5 rounded-lg transition-colors"
              style={{ color: 'var(--color-text-tertiary)' }}
              onMouseEnter={e => { e.currentTarget.style.background = 'var(--color-surface-3)'; }}
              onMouseLeave={e => { e.currentTarget.style.background = 'transparent'; }}
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <button
              onClick={next}
              className="p-1.5 rounded-lg transition-colors"
              style={{ color: 'var(--color-text-tertiary)' }}
              onMouseEnter={e => { e.currentTarget.style.background = 'var(--color-surface-3)'; }}
              onMouseLeave={e => { e.currentTarget.style.background = 'transparent'; }}
            >
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>

          <button
            onClick={handleClick}
            className="flex items-center gap-1.5 text-sm font-medium transition-colors"
            style={{ color: game.color }}
          >
            Jugar ahora
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      </div>
    </motion.div>
  );
}
