'use client';

import { motion } from 'framer-motion';
import { useRouter } from 'next/navigation';
import { MessageCircle, Check, Eye, Clock, ArrowRight } from 'lucide-react';

interface ConocenosCardData {
  dailyId: string;
  questionText: string;
  hasAnswered: boolean;
  partnerHasAnswered: boolean;
  isRevealed: boolean;
  revealAt: string;
}

interface ConocenosCardProps {
  data: ConocenosCardData;
}

export function ConocenosCard({ data }: ConocenosCardProps) {
  const router = useRouter();

  // State 1: Not answered — primary CTA
  if (!data.hasAnswered) {
    return (
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 0.15 }}
      >
        <div
          className="rounded-[20px] p-6 relative overflow-hidden cursor-pointer group transition-all duration-300 hover:scale-[1.01]"
          style={{
            background: 'linear-gradient(145deg, var(--color-conexion-dim) 0%, var(--color-surface-1) 100%)',
            border: '1px solid var(--color-border)',
          }}
          onClick={() => router.push(`/dashboard/jugar/conocernos/${data.dailyId}/answer`)}
        >
          {/* Decorative glow */}
          <div
            className="absolute -top-8 -right-8 w-24 h-24 rounded-full blur-3xl opacity-15 group-hover:opacity-25 transition-opacity"
            style={{ background: 'var(--color-conexion)' }}
          />

          <div className="relative z-10">
            <div className="flex items-center gap-2 mb-4">
              <div
                className="w-7 h-7 rounded-lg flex items-center justify-center"
                style={{ background: 'var(--color-conexion)', color: 'var(--color-base)' }}
              >
                <MessageCircle className="h-3.5 w-3.5" />
              </div>
              <span
                className="text-[11px] font-bold uppercase tracking-[0.16em]"
                style={{ color: 'var(--color-conexion)' }}
              >
                Conocernos
              </span>
              <span
                className="ml-auto px-2 py-0.5 rounded-full text-[9px] font-bold uppercase"
                style={{ background: 'var(--color-conexion)', color: 'var(--color-base)' }}
              >
                Nueva
              </span>
            </div>

            <p
              className="text-[15px] leading-relaxed mb-5 line-clamp-2"
              style={{ color: 'var(--color-text-primary)' }}
            >
              {data.questionText}
            </p>

            <span
              className="text-sm font-medium flex items-center gap-1.5"
              style={{ color: 'var(--color-conexion)' }}
            >
              Responder <ArrowRight className="h-4 w-4 group-hover:translate-x-0.5 transition-transform" />
            </span>
          </div>
        </div>
      </motion.div>
    );
  }

  // State 2: Answered, waiting for reveal
  if (!data.isRevealed) {
    return (
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 0.15 }}
      >
        <div
          className="rounded-[20px] px-5 py-4 flex items-center gap-4"
          style={{ background: 'var(--color-surface-1)', border: '1px solid var(--color-border)' }}
        >
          <div
            className="w-9 h-9 rounded-xl flex items-center justify-center shrink-0"
            style={{ background: 'var(--color-conexion-dim)', border: '1px solid rgba(232, 116, 138, 0.3)' }}
          >
            <Check className="h-4 w-4" style={{ color: 'var(--color-success-warm)' }} />
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-sm" style={{ color: 'var(--color-text-primary)' }}>
              Tu respuesta está guardada
            </p>
            <p className="text-[11px] mt-0.5" style={{ color: 'var(--color-text-tertiary)' }}>
              {data.partnerHasAnswered
                ? 'Ambos respondieron — se revela pronto'
                : 'Esperando a tu pareja'}
            </p>
          </div>
          <div className="flex items-center gap-1 text-[10px] shrink-0" style={{ color: 'var(--color-text-tertiary)' }}>
            <Clock className="h-3 w-3" />
            {new Date(data.revealAt).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit' })}
          </div>
        </div>
      </motion.div>
    );
  }

  // State 3: Revealed — tap to see answers
  return (
    <motion.div
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay: 0.15 }}
    >
      <div
        className="rounded-[20px] px-5 py-4 flex items-center gap-4 cursor-pointer transition-all hover:scale-[1.01]"
        style={{
          background: 'linear-gradient(135deg, var(--color-memory-tint) 0%, var(--color-surface-1) 100%)',
          border: '1px solid var(--color-border)',
        }}
        onClick={() => router.push(`/dashboard/jugar/conocernos/${data.dailyId}/reveal`)}
      >
        <div
          className="w-9 h-9 rounded-xl flex items-center justify-center shrink-0"
          style={{ background: 'var(--color-memory-tint)', border: '1px solid rgba(201, 140, 147, 0.3)' }}
        >
          <Eye className="h-4 w-4" style={{ color: 'var(--color-accent-rose)' }} />
        </div>
        <div className="flex-1 min-w-0">
          <p className="text-sm" style={{ color: 'var(--color-text-primary)' }}>
            ¡Respuestas reveladas!
          </p>
          <p className="text-[11px] mt-0.5 line-clamp-1" style={{ color: 'var(--color-text-tertiary)' }}>
            {data.questionText}
          </p>
        </div>
        <ArrowRight className="h-4 w-4 shrink-0" style={{ color: 'var(--color-accent-rose)' }} />
      </div>
    </motion.div>
  );
}
