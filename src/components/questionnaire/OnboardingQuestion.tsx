'use client';

import { cn } from '@/lib/utils';
import type { OnboardingItem, OnboardingOption } from '@/data/onboarding-data';

interface OnboardingQuestionProps {
  item: OnboardingItem;
  value?: any;
  onChange: (value: any) => void;
}

export function OnboardingQuestion({ item, value, onChange }: OnboardingQuestionProps) {
  // Extract actual value from stored format {value: "3"} or raw "3"
  const currentValue = typeof value === 'object' && value?.value !== undefined
    ? String(value.value)
    : value !== undefined ? String(value) : undefined;

  if (item.question_type === 'LIKERT-5') {
    return <LikertOnboarding item={item} value={currentValue} onChange={onChange} />;
  }

  if (item.question_type === 'ESCENARIO') {
    return <ScenarioOnboarding item={item} value={currentValue} onChange={onChange} />;
  }

  return <div>Tipo no soportado</div>;
}

// ─── Likert ─────────────────────────────────────────────────

function LikertOnboarding({
  item,
  value,
  onChange,
}: {
  item: OnboardingItem;
  value?: string;
  onChange: (value: any) => void;
}) {
  return (
    <div className="space-y-4">
      <div className="flex flex-wrap justify-center gap-2">
        {item.options.map((option) => (
          <button
            key={option.value}
            onClick={() => onChange(option.value)}
            className={cn(
              'px-5 py-3.5 rounded-xl text-sm font-medium transition-all duration-200',
              'min-w-[100px] active:scale-95',
              value === option.value
                ? 'bg-primary text-white shadow-lg shadow-primary/25 scale-[1.02]'
                : 'bg-surface_container_low text-on_surface hover:bg-surface_container_lowest hover:shadow-sm'
            )}
          >
            {option.label}
          </button>
        ))}
      </div>
    </div>
  );
}

// ─── Scenario ───────────────────────────────────────────────

function ScenarioOnboarding({
  item,
  value,
  onChange,
}: {
  item: OnboardingItem;
  value?: string;
  onChange: (value: any) => void;
}) {
  return (
    <div className="space-y-5">
      {item.scenario && (
        <div className="p-4 bg-linear-to-br from-primary_container/20 to-conexion/10 rounded-xl text-center">
          <p className="text-on_surface text-sm italic">{item.scenario}</p>
        </div>
      )}
      <div className="space-y-3">
        {item.options.map((option) => (
          <button
            key={option.value}
            onClick={() => onChange(option.value)}
            className={cn(
              'w-full p-4 rounded-xl text-left transition-all duration-200 active:scale-[0.98]',
              value === option.value
                ? 'bg-primary text-white shadow-lg shadow-primary/25'
                : 'bg-surface_container_low text-on_surface hover:bg-surface_container_lowest hover:shadow-sm'
            )}
          >
            <span className="text-sm font-medium">{option.label}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
