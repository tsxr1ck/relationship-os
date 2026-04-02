'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { Plane, Coffee, Heart, Dice5, Zap, Star, Loader2, ArrowLeft } from 'lucide-react';
import { AppShell } from '@/components/layout/AppShell';
import { getQuizCategories, createQuizSession, type QuizCategory } from './actions';

const CATEGORY_ICONS: Record<string, any> = {
  comida: Coffee,
  viajes: Plane,
  entretenimiento: Star,
  intimidad: Heart,
  random: Dice5,
  futuro: Zap,
};

const CATEGORY_COLORS: Record<string, string> = {
  comida: 'var(--color-cuidado)',
  viajes: 'var(--color-camino)',
  entretenimiento: 'var(--color-conexion)',
  intimidad: 'var(--color-accent-rose)',
  random: 'var(--color-ai)',
  futuro: 'var(--color-choque)',
};

export default function FavoritosPage() {
  const router = useRouter();
  const [categories, setCategories] = useState<QuizCategory[]>([]);
  const [loading, setLoading] = useState(true);
  const [starting, setStarting] = useState<string | null>(null);
  const [error, setError] = useState('');

  useEffect(() => {
    getQuizCategories().then(data => {
      setCategories(data);
      setLoading(false);
    });
  }, []);

  const handleStart = async (categoryId: string) => {
    if (starting) return;
    setStarting(categoryId);
    setError('');

    const res = await createQuizSession(categoryId);

    if (res.success && res.sessionId) {
      router.push(`/dashboard/jugar/favoritos/${res.sessionId}`);
    } else {
      setError(res.error || 'Error al iniciar quiz');
      setStarting(null);
    }
  };

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <Loader2 className="h-8 w-8 animate-spin" style={{ color: 'var(--color-cuidado)' }} />
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell>
      <div className="max-w-lg mx-auto lg:max-w-2xl pb-24">
        
        <button
          onClick={() => router.push('/dashboard/jugar')}
          className="flex items-center gap-2 mb-8 text-sm transition-colors"
          style={{ color: 'var(--color-text-tertiary)' }}
        >
          <ArrowLeft className="h-4 w-4" /> Volver
        </button>

        <motion.div
           initial={{ opacity: 0, y: 12 }}
           animate={{ opacity: 1, y: 0 }}
           className="mb-8"
        >
          <h1 className="font-display text-3xl mb-2" style={{ color: 'var(--color-text-primary)' }}>
            Quizzes Favoritos
          </h1>
          <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
            Jueguen rondas rápidas y descubran si de verdad se conocen.
          </p>
          {error && <p className="text-sm mt-3" style={{ color: 'var(--color-danger)' }}>{error}</p>}
        </motion.div>

        <div className="grid grid-cols-2 gap-4">
          {categories.map((cat, i) => {
            const Icon = CATEGORY_ICONS[cat.id] || Star;
            const color = CATEGORY_COLORS[cat.id] || 'var(--color-conexion)';
            
            return (
              <motion.div
                key={cat.id}
                initial={{ opacity: 0, y: 16 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.05 }}
              >
                <div
                  onClick={() => handleStart(cat.id)}
                  className={`rounded-[20px] p-5 aspect-square flex flex-col items-center justify-center text-center cursor-pointer transition-all hover:scale-[1.02] active:scale-95 ${starting === cat.id ? 'opacity-80' : ''}`}
                  style={{
                    background: `linear-gradient(135deg, ${color}20, var(--color-surface-1))`,
                    border: '1px solid var(--color-border)',
                  }}
                >
                  {starting === cat.id ? (
                    <Loader2 className="h-8 w-8 mb-4 animate-spin" style={{ color }} />
                  ) : (
                    <div className="w-12 h-12 rounded-full flex items-center justify-center mb-4"
                         style={{ background: color, color: 'var(--color-base)' }}>
                      <Icon className="h-6 w-6" />
                    </div>
                  )}
                  <h3 className="font-display text-base leading-tight mb-1" style={{ color: 'var(--color-text-primary)' }}>
                    {cat.label}
                  </h3>
                  <p className="text-[11px] uppercase tracking-wider font-bold" style={{ color: 'var(--color-text-tertiary)' }}>
                    {cat.count} preguntas
                  </p>
                </div>
              </motion.div>
            );
          })}
        </div>

        {categories.length === 0 && (
          <div className="text-center py-12 rounded-[20px]" style={{ border: '1px dashed var(--color-border)' }}>
            <p className="text-sm" style={{ color: 'var(--color-text-secondary)' }}>
              No hay preguntas agregadas. Corre el seed SQL.
            </p>
          </div>
        )}

      </div>
    </AppShell>
  );
}
