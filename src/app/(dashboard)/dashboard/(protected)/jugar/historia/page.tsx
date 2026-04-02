'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { BookOpen, Camera, Mic, Plus, Calendar, Edit3, ArrowLeft, Quote } from 'lucide-react';
import { AppShell } from '@/components/layout/AppShell';
import { getMemories, type HistoriaEntry } from './actions';

const DIMENSION_COLORS: Record<string, string> = {
  conexion: 'var(--color-conexion)',
  cuidado: 'var(--color-cuidado)',
  choque: 'var(--color-choque)',
  camino: 'var(--color-camino)',
  general: 'var(--color-ai)',
};

export default function HistoriaPage() {
  const router = useRouter();
  const [memories, setMemories] = useState<HistoriaEntry[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getMemories(0, 50).then(data => {
      setMemories(data);
      setLoading(false);
    });
  }, []);

  if (loading) {
    return (
      <AppShell>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="w-8 h-8 rounded-full border-2 border-t-transparent animate-spin"
            style={{ borderColor: 'var(--color-accent-rose)', borderTopColor: 'transparent' }} />
        </div>
      </AppShell>
    );
  }

  return (
    <AppShell>
      <div className="max-w-lg mx-auto lg:max-w-3xl pb-24 relative px-4 sm:px-0">

        <motion.div
           initial={{ opacity: 0, y: 12 }}
           animate={{ opacity: 1, y: 0 }}
           className="mb-12 mt-4"
        >
          <div className="flex items-center justify-between mb-2">
            <h1 className="font-display text-3xl sm:text-4xl" style={{ color: 'var(--color-text-primary)' }}>
              Nuestra Historia
            </h1>
            <div
              className="w-12 h-12 rounded-full flex items-center justify-center cursor-pointer transition-transform hover:scale-105 shadow-xl"
              style={{ background: 'var(--color-accent-rose)', color: 'var(--color-base)' }}
              onClick={() => router.push('/dashboard/jugar/historia/new')}
            >
              <Plus className="h-6 w-6" />
            </div>
          </div>
          <p className="text-sm opacity-80" style={{ color: 'var(--color-text-secondary)' }}>
            Su museo de recuerdos, anécdotas y primeras veces.
          </p>
        </motion.div>

        {memories.length === 0 ? (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="text-center py-16"
          >
            <div className="w-16 h-16 rounded-2xl mx-auto flex items-center justify-center mb-4"
                 style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}>
              <BookOpen className="h-6 w-6" style={{ color: 'var(--color-text-tertiary)' }} />
            </div>
            <p className="font-display mb-2 text-lg text-primary">Aún no hay memorias</p>
            <p className="text-sm text-secondary px-8 mb-6">
              Guarden respuestas de Conocernos, suban fotos o registren momentos importantes.
            </p>
            <button
               className="px-6 py-2.5 rounded-2xl text-sm font-semibold transition-all active:scale-95"
               style={{ background: 'var(--color-accent-rose)', color: 'var(--color-base)' }}
               onClick={() => router.push('/dashboard/jugar/historia/new')}
            >
              Añadir 1er recuerdo
            </button>
          </motion.div>
        ) : (
          <div className="relative pl-6 before:absolute before:inset-y-0 before:left-6 before:w-[2px] before:bg-[var(--color-border)]">
            {memories.map((memory, i) => (
              <TimelineItem key={memory.id} memory={memory} index={i} />
            ))}
          </div>
        )}

      </div>
    </AppShell>
  );
}

function TimelineItem({ memory, index }: { memory: HistoriaEntry; index: number }) {
  const isQuote = memory.metadata?.customType === 'quote';
  const isMilestone = memory.contentType === 'system_milestone' || memory.metadata?.customType === 'user_milestone';

  const Icon = isQuote ? Quote :
               memory.contentType === 'photo' ? Camera :
               memory.contentType === 'voice' ? Mic :
               memory.contentType === 'conocernos_reveal' ? Edit3 :
               isMilestone ? Calendar :
               BookOpen;

  const dimColor = DIMENSION_COLORS[memory.dimension || 'general'];
  const date = new Date(memory.occurredAt || new Date());

  return (
    <motion.div
        initial={{ opacity: 0, x: -10 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ delay: index * 0.08, duration: 0.5 }}
        className="relative mb-10 pl-8 group"
    >
      {/* Timeline Node */}
      <div className="absolute left-0 top-1.5 -translate-x-1/2 w-4 h-4 rounded-full border-4 shadow-sm"
           style={{ background: dimColor, borderColor: 'var(--color-base)' }} />

      {/* Date */}
      <p className="text-[11px] font-bold uppercase tracking-[0.16em] mb-2" style={{ color: dimColor }}>
        {date.toLocaleDateString('es-MX', { day: 'numeric', month: 'long', year: 'numeric' })}
      </p>

      {/* Card */}
      <div
         className={`rounded-[20px] p-5 relative transition-all duration-300 ${memory.contentType === 'conocernos_reveal' ? 'pr-4' : ''}`}
         style={{
           background: memory.contentType === 'conocernos_reveal' ? 'linear-gradient(135deg, var(--color-surface-1), var(--color-memory-tint))' : 'var(--color-surface-1)',
           border: '1px solid var(--color-border)'
         }}
      >
        <div className="flex gap-3 items-start">
           <div className="w-10 h-10 shrink-0 rounded-full flex items-center justify-center"
                style={{ background: 'var(--color-surface-2)' }}>
              <Icon className="h-4 w-4" style={{ color: dimColor }} />
           </div>
           <div className="flex-1 min-w-0">
              
              {/* QUOTES */}
              {isQuote && (
                <div className="relative pt-1">
                   <p className="font-display text-xl leading-snug italic mb-2" style={{ color: 'var(--color-text-primary)' }}>"{memory.title}"</p>
                   {memory.description && (
                     <p className="text-[11px] font-bold uppercase tracking-[0.1em]" style={{ color: 'var(--color-text-tertiary)' }}>
                       — {memory.description}
                     </p>
                   )}
                </div>
              )}

              {/* MILTESTONES */}
              {isMilestone && (
                <div className="pt-0.5">
                   <p className="text-[9px] font-bold uppercase tracking-[0.2em] mb-1" style={{ color: dimColor }}>Hito</p>
                   <h3 className="font-display text-[19px] mb-1.5" style={{ color: 'var(--color-text-primary)' }}>{memory.title}</h3>
                   {memory.description && (
                     <p className="text-[14px] leading-relaxed" style={{ color: 'var(--color-text-secondary)' }}>
                       {memory.description}
                     </p>
                   )}
                </div>
              )}

              {/* STANDARD CONTENT (Text & Photos) */}
              {!isQuote && !isMilestone && memory.contentType !== 'conocernos_reveal' && (
                <div>
                  <h3 className="font-display text-[17px] mb-1 pt-0.5" style={{ color: 'var(--color-text-primary)' }}>
                    {memory.title}
                  </h3>
                  {memory.description && (
                    <p className="text-[14px] leading-relaxed mb-3 whitespace-pre-wrap" style={{ color: 'var(--color-text-secondary)' }}>
                      {memory.description}
                    </p>
                  )}
                  {memory.contentType === 'photo' && (
                    <div className="relative mt-3 rounded-xl overflow-hidden border aspect-video" style={{ borderColor: 'var(--color-border)', background: 'var(--color-surface-2)' }}>
                      {memory.mediaUrl ? (
                        <img src={memory.mediaUrl} alt={memory.title} className="w-full h-full object-cover" />
                      ) : (
                        <div className="w-full h-full flex flex-col items-center justify-center" style={{ color: 'var(--color-text-tertiary)' }}>
                          <Camera className="h-6 w-6 opacity-30" />
                        </div>
                      )}
                    </div>
                  )}
                </div>
              )}

              {/* Special rendering for Conocernos */}
              {memory.contentType === 'conocernos_reveal' && (
                <div>
                  <h3 className="font-display text-[17px] mb-1 pt-0.5" style={{ color: 'var(--color-text-primary)' }}>
                    {memory.title}
                  </h3>
                  {memory.description && (
                    <p className="text-[14px] leading-relaxed mb-3" style={{ color: 'var(--color-text-secondary)' }}>
                      {memory.description}
                    </p>
                  )}

                  {memory.metadata && (
                    <div className="space-y-3 mt-4 border-t pt-4" style={{ borderColor: 'rgba(255,255,255,0.05)' }}>
                      <div className="opacity-90">
                        <p className="text-[10px] uppercase font-bold tracking-widest mb-1" style={{ color: 'var(--color-text-tertiary)' }}>Tu Respuesta</p>
                        <p className="text-[14px] italic" style={{ color: 'var(--color-text-primary)' }}>"{memory.metadata.userAnswer}"</p>
                      </div>
                      <div className="opacity-90">
                        <p className="text-[10px] uppercase font-bold tracking-widest mb-1" style={{ color: 'var(--color-text-tertiary)' }}>Su Respuesta</p>
                        <p className="text-[14px] italic" style={{ color: 'var(--color-text-primary)' }}>"{memory.metadata.partnerAnswer}"</p>
                      </div>
                    </div>
                  )}
                </div>
              )}

           </div>
        </div>
      </div>
    </motion.div>
  );
}
