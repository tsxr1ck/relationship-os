export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface Profile {
  id: string;
  full_name: string | null;
  avatar_url: string | null;
  locale: string;
  timezone: string;
  created_at: string;
  updated_at: string;
}

export interface Couple {
  id: string;
  invite_code: string;
  status: 'active' | 'archived' | 'dissolved';
  created_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface CoupleMember {
  id: string;
  couple_id: string;
  user_id: string;
  role: 'self' | 'partner';
  joined_at: string;
}

export interface Questionnaire {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  version: string;
  is_active: boolean;
  estimated_duration_minutes: number | null;
  created_at: string;
}

export interface QuestionnaireSection {
  id: string;
  questionnaire_id: string;
  slug: string;
  name: string;
  description: string | null;
  sort_order: number;
  estimated_questions: number | null;
  created_at: string;
}

export interface Question {
  id: string;
  section_id: string;
  question_number: number;
  question_text: string;
  question_type: 
    | 'LIKERT-5'
    | 'LIKERT-7'
    | 'FC'
    | 'ESCENARIO'
    | 'RANK'
    | 'SEMAFORO'
    | 'ABIERTA'
    | 'SLIDER';
  is_sensitive: boolean;
  is_required: boolean;
  is_opt_in: boolean;
  metadata: Json;
  created_at: string;
}

export interface AnswerOption {
  id: string;
  question_id: string;
  option_value: string;
  option_label: string;
  option_order: number;
  weight: Json;
}

export interface DimensionKey {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  layer: 'conexion' | 'cuidado' | 'choque' | 'camino';
  created_at: string;
}

export interface ResponseSession {
  id: string;
  user_id: string;
  questionnaire_id: string | null;
  section_id: string | null;
  status: 'started' | 'in_progress' | 'completed' | 'abandoned';
  started_at: string;
  completed_at: string | null;
  progress_pct: number;
}

export interface Response {
  id: string;
  session_id: string;
  question_id: string;
  answer_value: Json;
  answered_at: string;
}

export interface PersonalReport {
  id: string;
  user_id: string;
  session_id: string | null;
  archetype: string | null;
  summary: Json;
  strengths: Json;
  growth_areas: Json;
  created_at: string;
}

export interface CoupleReport {
  id: string;
  couple_id: string;
  session_a_id: string | null;
  session_b_id: string | null;
  summary: string | null;
  dimensions: Json;
  frictions: Json;
  strengths: Json;
  recommendations: Json;
  couple_archetype: string | null;
  created_at: string;
}

export interface DimensionScore {
  id: string;
  user_id: string;
  couple_id: string | null;
  dimension_id: string;
  raw_score: number | null;
  normalized_score: number | null;
  calculated_at: string;
}

export interface WeeklyPlan {
  id: string;
  couple_id: string;
  week_start: string;
  week_end: string;
  generated_at: string;
  couple_status_snapshot: Json;
  plan: Json;
  status: 'active' | 'completed' | 'skipped' | 'archived';
  completion_rate: number;
  couple_feedback: Json | null;
  ai_model_used: string;
  prompt_version: string;
}

export interface WeeklyPlanItem {
  id: string;
  plan_id: string;
  couple_id: string;
  day_of_week: number;
  day_label: string;
  title: string;
  description: string;
  dimension: string;
  activity_type: 'conversacion' | 'ritual' | 'reto' | 'reflexion' | 'microaccion' | 'check_in';
  duration_minutes: number;
  difficulty: 'easy' | 'medium' | 'deep';
  requires_both: boolean;
  assigned_to: string | null;
  status: 'pending' | 'completed' | 'skipped';
  completed_at: string | null;
  notes: string | null;
}

export interface GuidedConversation {
  id: string;
  slug: string;
  title: string;
  description: string | null;
  dimension: string;
  difficulty: 'easy' | 'medium' | 'deep';
  duration_minutes: number;
  prompt: Json;
  opening_card_id: string | null;
  created_at: string;
}

export interface WeeklyChallenge {
  id: string;
  slug: string;
  title: string;
  description: string;
  dimension: string;
  difficulty: 'easy' | 'medium' | 'deep';
  duration_days: number;
  created_at: string;
}

export interface ChallengeAssignment {
  id: string;
  couple_id: string;
  challenge_id: string;
  started_at: string;
  completed_at: string | null;
  status: 'active' | 'completed' | 'abandoned';
  progress: Json;
}

export interface CoupleStatusView {
  couple_id: string;
  user_id: string;
  invite_code: string;
  couple_status: 'active' | 'archived' | 'dissolved';
  couple_created_at: string;
  completed_sessions: number;
  last_activity: string | null;
  completed_activities: number;
  last_plan_week: string | null;
}
