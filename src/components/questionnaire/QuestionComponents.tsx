'use client';

import { useState } from 'react';
import { cn } from '@/lib/utils';
import { Question, AnswerOption } from '@/types/questionnaire';
import { Card, CardContent } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';

interface LikertQuestionProps {
  question: Question;
  value?: string;
  onChange: (value: string) => void;
}

export function LikertQuestion({ question, value, onChange }: LikertQuestionProps) {
  const options = question.metadata.options || [];
  
  return (
    <div className="space-y-4">
      <div className="flex flex-wrap justify-center gap-2">
        {options.map((option) => (
          <button
            key={option.value}
            onClick={() => onChange(option.value)}
            className={cn(
              'px-4 py-3 rounded-xl text-sm font-medium transition-all',
              value === option.value
                ? 'bg-primary text-white shadow-md'
                : 'bg-surface_container_low text-on_surface hover:bg-surface_container_lowest'
            )}
          >
            {option.label}
          </button>
        ))}
      </div>
    </div>
  );
}

interface FCQuestionProps {
  question: Question;
  value?: string;
  onChange: (value: string) => void;
}

export function FCQuestion({ question, value, onChange }: FCQuestionProps) {
  const options = question.metadata.options || [];
  
  return (
    <div className="space-y-3">
      {options.map((option) => (
        <button
          key={option.value}
          onClick={() => onChange(option.value)}
          className={cn(
            'w-full p-4 rounded-xl text-left transition-all',
            value === option.value
              ? 'bg-primary text-white shadow-md'
              : 'bg-surface_container_low text-on_surface hover:bg-surface_container_lowest'
          )}
        >
          {option.label}
        </button>
      ))}
    </div>
  );
}

interface SemaforoQuestionProps {
  question: Question;
  value?: string;
  onChange: (value: string) => void;
}

export function SemaforoQuestion({ question, value, onChange }: SemaforoQuestionProps) {
  const options = question.metadata.options || [];
  
  const colors: Record<string, string> = {
    green: 'bg-cuidado hover:bg-cuidado/80',
    yellow: 'bg-yellow-400 hover:bg-yellow-500',
    red: 'bg-choque hover:bg-choque/80',
  };
  
  return (
    <div className="space-y-3">
      {options.map((option) => (
        <button
          key={option.value}
          onClick={() => onChange(option.value)}
          className={cn(
            'w-full p-4 rounded-xl text-left transition-all',
            value === option.value
              ? `${colors[option.value]} text-white shadow-md`
              : 'bg-surface_container_low text-on_surface hover:bg-surface_container_lowest'
          )}
        >
          {option.label}
        </button>
      ))}
    </div>
  );
}

interface AbiertaQuestionProps {
  question: Question;
  value?: string;
  onChange: (value: string) => void;
}

export function AbiertaQuestion({ question, value, onChange }: AbiertaQuestionProps) {
  return (
    <div className="space-y-3">
      <textarea
        value={value || ''}
        onChange={(e) => onChange(e.target.value)}
        placeholder="Escribe tu respuesta..."
        className="w-full h-32 p-4 rounded-xl bg-surface_container_low border-none resize-none focus:ring-2 focus:ring-primary/20 focus:bg-surface_container_lowest"
        maxLength={500}
      />
      <p className="text-sm text-on_surface_variant text-right">
        {(value || '').length}/500
      </p>
    </div>
  );
}

interface SliderQuestionProps {
  question: Question;
  value?: number;
  onChange: (value: number) => void;
}

export function SliderQuestion({ question, value = 50, onChange }: SliderQuestionProps) {
  return (
    <div className="space-y-6">
      <div className="flex justify-between text-sm text-on_surface_variant">
        <span>{question.metadata.min_label || 'Izquierda'}</span>
        <span>{question.metadata.max_label || 'Derecha'}</span>
      </div>
      <input
        type="range"
        min="0"
        max="100"
        value={value}
        onChange={(e) => onChange(Number(e.target.value))}
        className="w-full h-2 bg-surface_container_low rounded-full appearance-none cursor-pointer accent-primary"
      />
      <div className="text-center">
        <span className="text-3xl font-bold text-primary">{value}%</span>
      </div>
    </div>
  );
}

interface RankQuestionProps {
  question: Question;
  value?: string[];
  onChange: (value: string[]) => void;
}

export function RankQuestion({ question, value = [], onChange }: RankQuestionProps) {
  const ranks = question.metadata.ranks || [];
  const [items, setItems] = useState(ranks);
  
  const moveItem = (fromIndex: number, toIndex: number) => {
    const newItems = [...items];
    const [removed] = newItems.splice(fromIndex, 1);
    newItems.splice(toIndex, 0, removed);
    setItems(newItems);
    onChange(newItems);
  };
  
  return (
    <div className="space-y-2">
      <p className="text-sm text-on_surface_variant mb-4">
        Arrastra para ordenar de mayor (1) a menor prioridad
      </p>
      {items.map((item, index) => (
        <div
          key={item}
          className="flex items-center gap-3 p-4 bg-surface_container_low rounded-xl"
        >
          <span className="w-8 h-8 rounded-full bg-primary text-white flex items-center justify-center font-bold text-sm">
            {index + 1}
          </span>
          <span className="flex-1 font-medium">{item}</span>
          <div className="flex gap-1">
            <button
              onClick={() => moveItem(index, Math.max(0, index - 1))}
              disabled={index === 0}
              className="p-1 hover:bg-surface_container_lowest rounded disabled:opacity-30"
            >
              ↑
            </button>
            <button
              onClick={() => moveItem(index, Math.min(items.length - 1, index + 1))}
              disabled={index === items.length - 1}
              className="p-1 hover:bg-surface_container_lowest rounded disabled:opacity-30"
            >
              ↓
            </button>
          </div>
        </div>
      ))}
    </div>
  );
}

interface EscenarioQuestionProps {
  question: Question;
  value?: string;
  onChange: (value: string) => void;
}

export function EscenarioQuestion({ question, value, onChange }: EscenarioQuestionProps) {
  const options = question.metadata.options || [];
  
  return (
    <div className="space-y-4">
      <div className="p-4 bg-primary_container/20 rounded-xl text-center">
        <p className="text-on_surface">{question.metadata.scenario}</p>
      </div>
      <div className="space-y-3">
        {options.map((option) => (
          <button
            key={option.value}
            onClick={() => onChange(option.value)}
            className={cn(
              'w-full p-4 rounded-xl text-left transition-all',
              value === option.value
                ? 'bg-primary text-white shadow-md'
                : 'bg-surface_container_low text-on_surface hover:bg-surface_container_lowest'
            )}
          >
            {option.label}
          </button>
        ))}
      </div>
    </div>
  );
}
