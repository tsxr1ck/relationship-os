export type QuestionType = 
  | 'LIKERT-5' 
  | 'LIKERT-7' 
  | 'FC' 
  | 'ESCENARIO' 
  | 'RANK' 
  | 'SEMAFORO' 
  | 'ABIERTA' 
  | 'SLIDER';

export type DimensionLayer = 'conexion' | 'cuidado' | 'choque' | 'camino';

export interface Question {
  id: string;
  section_id: string;
  question_number: number;
  question_text: string;
  question_type: QuestionType;
  is_sensitive: boolean;
  is_required: boolean;
  is_opt_in: boolean;
  metadata: QuestionMetadata;
}

export interface QuestionMetadata {
  options?: AnswerOption[];
  min_label?: string;
  max_label?: string;
  scenario?: string;
  ranks?: string[];
}

export interface AnswerOption {
  value: string;
  label: string;
  order: number;
  weight?: Record<string, number>;
}

export interface QuestionnaireSection {
  id: string;
  slug: string;
  name: string;
  description: string;
  sort_order: number;
  estimated_questions: number;
}

export interface QuestionnaireSession {
  id: string;
  user_id: string;
  questionnaire_id: string;
  section_id: string;
  status: 'started' | 'in_progress' | 'completed' | 'abandoned';
  started_at: string;
  completed_at?: string;
  progress_pct: number;
}

export interface QuestionResponse {
  question_id: string;
  answer_value: string | string[] | number | Record<string, any>;
}

// ─── V2 Blueprint Types ─────────────────────────────────────

export type OnboardingStage = 'onboarding' | 'core' | 'adaptive' | 'deep_dive';

export interface ProfileVector {
  dimension_slug: string;
  raw_score: number;
  normalized_score: number;
  item_count: number;
}

export interface OnboardingStatus {
  status: 'not_started' | 'in_progress' | 'completed';
  session: OnboardingSessionData | null;
  profileVectors: ProfileVector[];
}

export interface OnboardingSessionData {
  id: string;
  user_id: string;
  status: string;
  current_question_index: number;
  progress_pct: number;
  responses: Record<string, any>;
  started_at: string;
  completed_at?: string;
}
