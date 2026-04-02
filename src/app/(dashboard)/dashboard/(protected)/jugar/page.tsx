'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { MessageCircle, ArrowRight, Clock, Sparkles, Heart, Gamepad2, BookOpen, Target } from 'lucide-react';
import { AppShell } from '@/components/layout/AppShell';
import { getOrCreateDailyQuestion, type ConocenosDaily } from './conocernos/actions';

/* ══════════════════════════════════════
   JUGAR — Game Hub
   All playful features in one warm space
   ══════════════════════════════════════ */

export default function JugarPage() {
  const router = useRouter();
  const [conocernos, setConocernos] = useState<ConocenosDaily | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getOrCreateDailyQuestion()
      .then(data => setConocernos(data))
      .finally(() => setLoading(false));
  }, []);

  const features = [
    {
      id: 'conocernos',
      title: 'Conocernos',
      description: 'Una pregunta al día para descubrir algo nuevo del otro.',
      icon: MessageCircle,
      color: 'var(--color-conexion)',
      dimBg: 'var(--color-conexion-dim)',
      href: '/dashboard/jugar/conocernos',
      active: true,
      badge: conocernos && !conocernos.hasAnswered ? 'Nueva pregunta' : null,
    },
    {
      id: 'meconoces',
      title: '¿Me conoces?',
      description: 'Adivina las respuestas de tu pareja. ¿Cuánto saben el uno del otro?',
      icon: Sparkles,
      color: 'var(--color-camino)',
      dimBg: 'var(--color-camino-dim)',
      href: '/dashboard/jugar/meconoces',
      active: true,
      badge: null,
    },
    {
      id: 'sintonia',
      title: 'Sintonía',
      description: 'Dilemas rápidos. ¿Elegirán lo mismo o se abrirá el debate?',
      icon: Target,
      color: 'var(--color-choque)',
      dimBg: 'var(--color-choque-dim)',
      href: '/dashboard/jugar/sintonia',
      active: true,
      badge: 'Nuevo',
    },
    {
      id: 'quizzes',
      title: 'Quizzes Favoritos',
      description: 'Quizzes rápidos y divertidos para jugar juntos en tiempo real.',
      icon: Gamepad2,
      color: 'var(--color-cuidado)',
      dimBg: 'var(--color-cuidado-dim)',
      href: '/dashboard/jugar/favoritos',
      active: true,
      badge: null,
    },
    {
      id: 'historia',
      title: 'Nuestra Historia',
      description: 'Su diario compartido de momentos, recuerdos y primeras veces.',
      icon: BookOpen,
      color: 'var(--color-accent-rose)',
      dimBg: 'var(--color-memory-tint)',
      href: '/dashboard/jugar/historia',
      active: true,
      badge: null,
    },
    {
      id: 'evaluaciones',
      title: 'Evaluaciones Profundas',
      description: 'Cuestionarios extensos para analizar el estado de la relación.',
      icon: BookOpen,
      color: 'var(--color-ai)',
      dimBg: 'var(--color-surface-2)',
      href: '/dashboard/evaluaciones',
      active: true,
      badge: null,
    },
  ];

  return (
    <AppShell>
      <div className="max-w-lg mx-auto lg:max-w-2xl pb-10">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="mb-8"
        >
          <h1
            className="font-display text-3xl md:text-4xl mb-2"
            style={{ color: 'var(--color-text-primary)' }}
          >
            Jugar
          </h1>
          <p
            className="text-sm"
            style={{ color: 'var(--color-text-secondary)' }}
          >
            Descubranse jugando. Todo cuenta, nada pesa.
          </p>
        </motion.div>

        {/* Feature cards */}
        <div className="space-y-4">
          {features.map((feature, idx) => {
            const Icon = feature.icon;
            return (
              <motion.div
                key={feature.id}
                initial={{ opacity: 0, y: 16 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.4, delay: idx * 0.08 }}
              >
                <div
                  className={`rounded-[20px] p-6 relative overflow-hidden transition-all duration-300 ${feature.active ? 'cursor-pointer hover:scale-[1.01]' : 'opacity-60'}`}
                  style={{
                    background: feature.dimBg,
                    border: '1px solid var(--color-border)',
                  }}
                  onClick={() => feature.active && router.push(feature.href)}
                >
                  <div className="flex items-start gap-4">
                    <div
                      className="w-10 h-10 rounded-xl flex items-center justify-center shrink-0"
                      style={{ background: feature.color, color: 'var(--color-base)' }}
                    >
                      <Icon className="h-5 w-5" />
                    </div>

                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-1">
                        <h3
                          className="font-display text-lg"
                          style={{ color: 'var(--color-text-primary)' }}
                        >
                          {feature.title}
                        </h3>
                        {feature.badge && (
                          <span
                            className="px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider"
                            style={{
                              background: feature.active ? feature.color : 'var(--color-surface-3)',
                              color: feature.active ? 'var(--color-base)' : 'var(--color-text-tertiary)',
                            }}
                          >
                            {feature.badge}
                          </span>
                        )}
                      </div>
                      <p
                        className="text-sm leading-relaxed"
                        style={{ color: 'var(--color-text-secondary)' }}
                      >
                        {feature.description}
                      </p>
                    </div>

                    {feature.active && (
                      <ArrowRight
                        className="h-5 w-5 shrink-0 mt-2"
                        style={{ color: 'var(--color-text-tertiary)' }}
                      />
                    )}
                  </div>
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </AppShell>
  );
}
