'use client';

import { Question } from '@/types/questionnaire';
import { LikertQuestion, FCQuestion, SemaforoQuestion, AbiertaQuestion, SliderQuestion, RankQuestion, EscenarioQuestion } from './QuestionComponents';

interface QuestionRendererProps {
  question: Question;
  value?: any;
  onChange: (value: any) => void;
}

export function QuestionRenderer({ question, value, onChange }: QuestionRendererProps) {
  switch (question.question_type) {
    case 'LIKERT-5':
    case 'LIKERT-7':
      return <LikertQuestion question={question} value={value} onChange={onChange} />;
    case 'FC':
      return <FCQuestion question={question} value={value} onChange={onChange} />;
    case 'SEMAFORO':
      return <SemaforoQuestion question={question} value={value} onChange={onChange} />;
    case 'ABIERTA':
      return <AbiertaQuestion question={question} value={value} onChange={onChange} />;
    case 'SLIDER':
      return <SliderQuestion question={question} value={value} onChange={onChange} />;
    case 'RANK':
      return <RankQuestion question={question} value={value} onChange={onChange} />;
    case 'ESCENARIO':
      return <EscenarioQuestion question={question} value={value} onChange={onChange} />;
    default:
      return <div>Tipo de pregunta no soportado</div>;
  }
}
