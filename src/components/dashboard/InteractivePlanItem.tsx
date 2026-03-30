'use client';

import { useState } from 'react';
import { Calendar, CheckCircle2, ChevronRight, Loader2, PlayCircle } from 'lucide-react';
import { togglePlanItem } from '@/app/(dashboard)/dashboard/(protected)/plan/actions';
import { useRouter } from 'next/navigation';

const DIMENSION_COLORS: Record<string, { color: string; dim: string }> = {
  Conexión: { color: 'var(--color-conexion)', dim: 'var(--color-conexion-dim)' },
  Cuidado: { color: 'var(--color-cuidado)', dim: 'var(--color-cuidado-dim)' },
  Conflicto: { color: 'var(--color-choque)', dim: 'var(--color-choque-dim)' },
  Choque: { color: 'var(--color-choque)', dim: 'var(--color-choque-dim)' },
  Camino: { color: 'var(--color-camino)', dim: 'var(--color-camino-dim)' },
};

interface InteractivePlanItemProps {
  item: any;
  hasAccess: boolean;
}

export function InteractivePlanItem({ item, hasAccess }: InteractivePlanItemProps) {
  const router = useRouter();
  const [isUpdating, setIsUpdating] = useState(false);
  const isCompleted = item.status === 'completed';

  const dimColor = DIMENSION_COLORS[item.dimensionLabel] || { color: 'var(--color-ai)', dim: 'var(--color-ai-dim)' };

  const handleToggle = async (e: React.MouseEvent) => {
    e.stopPropagation();
    if (!hasAccess || isUpdating) return;

    try {
      setIsUpdating(true);
      await togglePlanItem(item.id);
    } catch (err) {
      console.error('Failed to toggle plan item', err);
    } finally {
      setIsUpdating(false);
    }
  };

  return (
    <div
      className="rounded-2xl p-5 md:p-6 cursor-pointer group relative overflow-hidden flex flex-col justify-between transition-all duration-200 hover:scale-[1.01]"
      style={{
        background: dimColor.dim,
        border: '1px solid var(--color-border)',
        borderLeft: `4px solid ${dimColor.color}`,
      }}
      onClick={() => router.push('/dashboard/plan')}
    >
      <div className="flex justify-between items-start mb-4">
        <div>
          <h5 className="text-xs font-bold uppercase tracking-widest flex items-center gap-1.5 mb-1.5" style={{ color: 'var(--color-text-tertiary)' }}>
            <Calendar className="h-3.5 w-3.5" /> {item.dayLabel} · Plan Semanal
          </h5>
          <span
            className="inline-block px-2 py-1 text-[10px] font-bold uppercase rounded-lg"
            style={{ background: `${dimColor.color}20`, color: dimColor.color }}
          >
            {item.dimensionLabel}
          </span>
        </div>

        {/* Checkbox */}
        <button
          onClick={handleToggle}
          disabled={!hasAccess || isUpdating}
          className="shrink-0 w-8 h-8 rounded-full flex items-center justify-center transition-all z-10"
          style={{
            background: isCompleted ? dimColor.color : 'var(--color-surface-3)',
            color: isCompleted ? 'var(--color-base)' : 'var(--color-text-tertiary)',
          }}
        >
          {isUpdating ? (
            <Loader2 className="h-4 w-4 animate-spin" />
          ) : isCompleted ? (
            <CheckCircle2 className="h-5 w-5" />
          ) : (
            <PlayCircle className="h-5 w-5 opacity-70" />
          )}
        </button>
      </div>

      <div>
        <p className={`text-lg font-bold transition-all ${isCompleted ? 'line-through opacity-50' : ''}`} style={{ color: 'var(--color-text-primary)' }}>
          {item.title}
        </p>
        <p className="text-sm mt-1.5 line-clamp-2" style={{ color: 'var(--color-text-secondary)' }}>
          {item.description}
        </p>
      </div>

      <div className="mt-5 pt-4 flex justify-between items-center text-xs" style={{ borderTop: '1px solid var(--color-border)' }}>
        <span className="font-semibold" style={{ color: 'var(--color-text-tertiary)' }}>
          {item.durationMinutes} min • {item.difficulty === 'easy' ? 'Fácil' : item.difficulty === 'medium' ? 'Medio' : 'Profundo'}
        </span>
        <span className="font-medium flex items-center group-hover:underline" style={{ color: dimColor.color }}>
          Ver detalles <ChevronRight className="h-3 w-3 ml-0.5" />
        </span>
      </div>
    </div>
  );
}
