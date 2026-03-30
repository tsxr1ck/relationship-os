-- ============================================================
-- Relationship OS V2 — Complete Fresh Schema
-- Run this in Supabase SQL Editor
-- ============================================================
-- ⚠️ This DROPS all existing tables. Back up your data first!
-- ============================================================

-- Drop in reverse dependency order
DROP TABLE IF EXISTS ai_audit_log CASCADE;
DROP TABLE IF EXISTS ai_insights CASCADE;
DROP TABLE IF EXISTS challenge_assignments CASCADE;
DROP TABLE IF EXISTS milestones CASCADE;
DROP TABLE IF EXISTS weekly_plan_items CASCADE;
DROP TABLE IF EXISTS weekly_plans CASCADE;
DROP TABLE IF EXISTS weekly_challenges CASCADE;
DROP TABLE IF EXISTS guided_conversations CASCADE;
DROP TABLE IF EXISTS couple_reports CASCADE;
DROP TABLE IF EXISTS personal_reports CASCADE;
DROP TABLE IF EXISTS couple_vectors CASCADE;
DROP TABLE IF EXISTS dimension_scores CASCADE;
DROP TABLE IF EXISTS onboarding_responses CASCADE;
DROP TABLE IF EXISTS onboarding_sessions CASCADE;
DROP TABLE IF EXISTS profile_vectors CASCADE;
DROP TABLE IF EXISTS item_dimensions CASCADE;
DROP TABLE IF EXISTS item_bank CASCADE;
DROP TABLE IF EXISTS generated_assessment_items CASCADE;
DROP TABLE IF EXISTS generated_assessments CASCADE;
DROP TABLE IF EXISTS responses CASCADE;
DROP TABLE IF EXISTS response_sessions CASCADE;
DROP TABLE IF EXISTS answer_options CASCADE;
DROP TABLE IF EXISTS question_dimension_map CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS questionnaire_sections CASCADE;
DROP TABLE IF EXISTS questionnaires CASCADE;
DROP TABLE IF EXISTS dimension_keys CASCADE;
DROP TABLE IF EXISTS couple_members CASCADE;
DROP TABLE IF EXISTS couples CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;


-- ============================================================
-- 1. CORE: Auth & Profiles
-- ============================================================

CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  avatar_url TEXT,
  locale TEXT DEFAULT 'es-MX',
  timezone TEXT DEFAULT 'America/Mexico_City',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 2. COUPLES
-- ============================================================

CREATE TABLE couples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invite_code TEXT NOT NULL UNIQUE,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'archived', 'dissolved')),
  created_by UUID NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE couple_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('self', 'partner')),
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(couple_id, user_id)
);

-- ============================================================
-- 3. DIMENSION KEYS (the 4C framework)
-- ============================================================

CREATE TABLE dimension_keys (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  layer TEXT NOT NULL CHECK (layer IN ('conexion', 'cuidado', 'choque', 'camino')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 4. V2 ITEM BANK (all questions — onboarding + core + adaptive)
-- ============================================================

CREATE TABLE item_bank (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL UNIQUE,
  stage TEXT NOT NULL CHECK (stage IN ('onboarding', 'core', 'adaptive', 'deep_dive')),
  dimension_slug TEXT,
  construct_slug TEXT,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL CHECK (question_type IN ('LIKERT-5', 'LIKERT-7', 'SCENARIO', 'RANK', 'OPEN', 'FC', 'ESCENARIO', 'SEMAFORO', 'ABIERTA', 'SLIDER')),
  response_scale JSONB,
  reverse_scored BOOLEAN DEFAULT FALSE,
  sensitivity_level TEXT DEFAULT 'normal' CHECK (sensitivity_level IN ('normal', 'high', 'opt-in')),
  requires_opt_in BOOLEAN DEFAULT FALSE,
  scoring_strategy TEXT DEFAULT 'direct',
  sort_order INTEGER NOT NULL DEFAULT 0,
  active BOOLEAN DEFAULT TRUE,
  version TEXT DEFAULT '1.0',
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE item_dimensions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  item_id UUID NOT NULL REFERENCES item_bank(id) ON DELETE CASCADE,
  dimension_slug TEXT NOT NULL,
  weight NUMERIC(4,3) DEFAULT 1.000,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 5. LEGACY QUESTIONNAIRE (52-question system, still used for couple assessment)
-- ============================================================

CREATE TABLE questionnaires (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  version TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  estimated_duration_minutes INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE questionnaire_sections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  questionnaire_id UUID NOT NULL REFERENCES questionnaires(id) ON DELETE CASCADE,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  sort_order INTEGER NOT NULL,
  estimated_questions INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  section_id UUID NOT NULL REFERENCES questionnaire_sections(id) ON DELETE CASCADE,
  question_number INTEGER NOT NULL,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL CHECK (question_type IN ('LIKERT-5', 'LIKERT-7', 'FC', 'ESCENARIO', 'RANK', 'SEMAFORO', 'ABIERTA', 'SLIDER')),
  is_sensitive BOOLEAN DEFAULT FALSE,
  is_required BOOLEAN DEFAULT TRUE,
  is_opt_in BOOLEAN DEFAULT FALSE,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE answer_options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  option_value TEXT NOT NULL,
  option_label TEXT NOT NULL,
  option_order INTEGER NOT NULL,
  weight JSONB DEFAULT '{}'
);

CREATE TABLE question_dimension_map (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimension_keys(id) ON DELETE CASCADE,
  weight NUMERIC DEFAULT 1.00
);

-- ============================================================
-- 6. RESPONSE SESSIONS & RESPONSES (for legacy questionnaire)
-- ============================================================

CREATE TABLE generated_assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  gemini_prompt_version TEXT,
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE response_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  questionnaire_id UUID NOT NULL REFERENCES questionnaires(id),
  section_id UUID REFERENCES questionnaire_sections(id),
  status TEXT DEFAULT 'started' CHECK (status IN ('started', 'in_progress', 'completed', 'abandoned')),
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  progress_pct INTEGER DEFAULT 0,
  current_section TEXT,
  current_question_index INTEGER DEFAULT 0,
  stage TEXT DEFAULT 'legacy' CHECK (stage IN ('legacy', 'onboarding', 'couple_v2', 'deep_dive')),
  generated_assessment_id UUID REFERENCES generated_assessments(id)
);

CREATE TABLE responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES response_sessions(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES questions(id),
  answer_value JSONB NOT NULL,
  answered_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(session_id, question_id)
);

CREATE TABLE generated_assessment_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id UUID NOT NULL REFERENCES generated_assessments(id) ON DELETE CASCADE,
  item_bank_id UUID REFERENCES item_bank(id),
  category TEXT NOT NULL CHECK (category IN ('core', 'insight', 'adaptive')),
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL,
  response_scale JSONB,
  sort_order INTEGER NOT NULL,
  target_dimension TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 7. V2 ONBOARDING (personal profile assessment)
-- ============================================================

CREATE TABLE onboarding_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
  status TEXT NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed')),
  current_question_index INTEGER DEFAULT 0,
  progress_pct INTEGER DEFAULT 0,
  responses JSONB DEFAULT '{}',
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE onboarding_responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES onboarding_sessions(id) ON DELETE CASCADE,
  item_id TEXT NOT NULL,
  answer_value JSONB NOT NULL,
  answered_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(session_id, item_id)
);

-- ============================================================
-- 8. PROFILE VECTORS (V2 onboarding outputs)
-- ============================================================

CREATE TABLE profile_vectors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  dimension_slug TEXT NOT NULL,
  raw_score NUMERIC(6,2) NOT NULL,
  normalized_score NUMERIC(6,2) NOT NULL,
  item_count INTEGER DEFAULT 0,
  version INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, dimension_slug)
);

-- ============================================================
-- 9. SCORING & REPORTS
-- ============================================================

CREATE TABLE dimension_scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  couple_id UUID REFERENCES couples(id),
  dimension_id UUID NOT NULL REFERENCES dimension_keys(id),
  raw_score NUMERIC,
  normalized_score NUMERIC,
  calculated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE couple_vectors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  dimension_slug TEXT NOT NULL,
  mismatch_delta NUMERIC NOT NULL,
  risk_flag BOOLEAN DEFAULT FALSE,
  opportunity_flag BOOLEAN DEFAULT FALSE,
  calculated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE personal_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  session_id UUID REFERENCES response_sessions(id),
  archetype TEXT,
  summary JSONB DEFAULT '{}',
  strengths JSONB DEFAULT '[]',
  growth_areas JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE couple_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  session_a_id UUID REFERENCES response_sessions(id),
  session_b_id UUID REFERENCES response_sessions(id),
  summary TEXT,
  dimensions JSONB DEFAULT '[]',
  frictions JSONB DEFAULT '[]',
  strengths JSONB DEFAULT '[]',
  recommendations JSONB DEFAULT '[]',
  couple_archetype TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 10. WEEKLY PLANS & ACTIVITIES
-- ============================================================

CREATE TABLE weekly_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  week_start DATE NOT NULL,
  week_end DATE NOT NULL,
  generated_at TIMESTAMPTZ DEFAULT NOW(),
  couple_status_snapshot JSONB NOT NULL,
  plan JSONB NOT NULL,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'skipped', 'archived')),
  completion_rate NUMERIC DEFAULT 0,
  couple_feedback JSONB,
  ai_model_used TEXT NOT NULL,
  prompt_version TEXT NOT NULL,
  UNIQUE(couple_id, week_start)
);

CREATE TABLE weekly_plan_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id UUID NOT NULL REFERENCES weekly_plans(id) ON DELETE CASCADE,
  couple_id UUID NOT NULL REFERENCES couples(id),
  day_of_week INTEGER NOT NULL CHECK (day_of_week >= 1 AND day_of_week <= 7),
  day_label TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  dimension TEXT NOT NULL,
  activity_type TEXT NOT NULL CHECK (activity_type IN ('conversacion', 'ritual', 'reto', 'reflexion', 'microaccion', 'check_in')),
  duration_minutes INTEGER NOT NULL,
  difficulty TEXT DEFAULT 'medium' CHECK (difficulty IN ('easy', 'medium', 'deep')),
  requires_both BOOLEAN DEFAULT TRUE,
  assigned_to TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'skipped')),
  completed_at TIMESTAMPTZ,
  notes TEXT
);

CREATE TABLE weekly_challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  dimension TEXT NOT NULL,
  difficulty TEXT DEFAULT 'medium',
  duration_days INTEGER DEFAULT 7,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE challenge_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  challenge_id UUID NOT NULL REFERENCES weekly_challenges(id),
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'abandoned')),
  progress JSONB DEFAULT '{}'
);

-- ============================================================
-- 11. ENGAGEMENT FEATURES
-- ============================================================

CREATE TABLE guided_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  description TEXT,
  dimension TEXT NOT NULL,
  difficulty TEXT DEFAULT 'medium' CHECK (difficulty IN ('easy', 'medium', 'deep')),
  duration_minutes INTEGER DEFAULT 20,
  prompt JSONB NOT NULL,
  opening_card_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE milestones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  milestone_type TEXT NOT NULL CHECK (milestone_type IN ('anniversary', 'achievement', 'milestone', 'special_date')),
  date DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 12. AI
-- ============================================================

CREATE TABLE ai_insights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  couple_id UUID REFERENCES couples(id),
  dimension_slug TEXT NOT NULL,
  insight_text TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE ai_audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID REFERENCES couples(id),
  model TEXT NOT NULL,
  prompt_version TEXT NOT NULL,
  input_tokens INTEGER,
  output_tokens INTEGER,
  total_tokens INTEGER,
  latency_ms INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);


-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE couple_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE dimension_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_bank ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_dimensions ENABLE ROW LEVEL SECURITY;
ALTER TABLE questionnaires ENABLE ROW LEVEL SECURITY;
ALTER TABLE questionnaire_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE answer_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE question_dimension_map ENABLE ROW LEVEL SECURITY;
ALTER TABLE response_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE generated_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE generated_assessment_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE onboarding_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE onboarding_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile_vectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE dimension_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE couple_vectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE personal_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE couple_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_plan_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE guided_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_insights ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_audit_log ENABLE ROW LEVEL SECURITY;

-- ── Profiles: users manage their own ──
CREATE POLICY "profiles_select" ON profiles FOR SELECT TO authenticated USING (auth.uid() = id);
CREATE POLICY "profiles_insert" ON profiles FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles_update" ON profiles FOR UPDATE TO authenticated USING (auth.uid() = id);

-- ── Couple Members: simple direct check — NO subqueries on itself ──
-- Users can only see their own membership rows (partner lookups use admin client)
CREATE POLICY "couple_members_select" ON couple_members FOR SELECT TO authenticated
  USING (user_id = auth.uid());
CREATE POLICY "couple_members_insert" ON couple_members FOR INSERT TO authenticated WITH CHECK (TRUE);

-- ── Couples: uses subquery on couple_members, which is safe (no self-reference) ──
CREATE POLICY "couples_select" ON couples FOR SELECT TO authenticated
  USING (id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "couples_insert" ON couples FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by);
CREATE POLICY "couples_update" ON couples FOR UPDATE TO authenticated
  USING (id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- ── Public catalogs (read-only for all authenticated) ──
CREATE POLICY "dimension_keys_select" ON dimension_keys FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "item_bank_select" ON item_bank FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "item_dimensions_select" ON item_dimensions FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "questionnaires_select" ON questionnaires FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "questionnaire_sections_select" ON questionnaire_sections FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "questions_select" ON questions FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "answer_options_select" ON answer_options FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "question_dimension_map_select" ON question_dimension_map FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "weekly_challenges_select" ON weekly_challenges FOR SELECT TO authenticated USING (TRUE);
CREATE POLICY "guided_conversations_select" ON guided_conversations FOR SELECT TO authenticated USING (TRUE);

-- ── Response Sessions: users manage their own ──
CREATE POLICY "response_sessions_select" ON response_sessions FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "response_sessions_insert" ON response_sessions FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "response_sessions_update" ON response_sessions FOR UPDATE TO authenticated USING (user_id = auth.uid());

-- ── Responses: via session ownership ──
CREATE POLICY "responses_select" ON responses FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM response_sessions WHERE id = session_id AND user_id = auth.uid()));
CREATE POLICY "responses_insert" ON responses FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM response_sessions WHERE id = session_id AND user_id = auth.uid()));
CREATE POLICY "responses_update" ON responses FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM response_sessions WHERE id = session_id AND user_id = auth.uid()));

-- ── Onboarding: users manage their own ──
CREATE POLICY "onboarding_sessions_select" ON onboarding_sessions FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "onboarding_sessions_insert" ON onboarding_sessions FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "onboarding_sessions_update" ON onboarding_sessions FOR UPDATE TO authenticated USING (user_id = auth.uid());

CREATE POLICY "onboarding_responses_select" ON onboarding_responses FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM onboarding_sessions WHERE id = session_id AND user_id = auth.uid()));
CREATE POLICY "onboarding_responses_insert" ON onboarding_responses FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM onboarding_sessions WHERE id = session_id AND user_id = auth.uid()));
CREATE POLICY "onboarding_responses_update" ON onboarding_responses FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM onboarding_sessions WHERE id = session_id AND user_id = auth.uid()));

-- ── Profile Vectors: users manage their own ──
CREATE POLICY "profile_vectors_select" ON profile_vectors FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "profile_vectors_insert" ON profile_vectors FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "profile_vectors_update" ON profile_vectors FOR UPDATE TO authenticated USING (user_id = auth.uid());

-- ── Scoring: via user or couple membership ──
CREATE POLICY "dimension_scores_select" ON dimension_scores FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "couple_vectors_select" ON couple_vectors FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- ── Reports: via ownership or couple membership ──
CREATE POLICY "personal_reports_select" ON personal_reports FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "couple_reports_select" ON couple_reports FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- ── Weekly Plans: via couple membership ──
CREATE POLICY "weekly_plans_select" ON weekly_plans FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "weekly_plans_insert" ON weekly_plans FOR INSERT TO authenticated
  WITH CHECK (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "weekly_plan_items_select" ON weekly_plan_items FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "weekly_plan_items_update" ON weekly_plan_items FOR UPDATE TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- ── Challenges: via couple membership ──
CREATE POLICY "challenge_assignments_select" ON challenge_assignments FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "challenge_assignments_insert" ON challenge_assignments FOR INSERT TO authenticated
  WITH CHECK (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "challenge_assignments_update" ON challenge_assignments FOR UPDATE TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- ── Milestones: via couple membership ──
CREATE POLICY "milestones_select" ON milestones FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "milestones_insert" ON milestones FOR INSERT TO authenticated
  WITH CHECK (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- ── AI: via user ownership ──
CREATE POLICY "ai_insights_select" ON ai_insights FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "ai_audit_log_select" ON ai_audit_log FOR SELECT TO authenticated USING (TRUE);

-- ── Generated Assessments: via couple membership ──
CREATE POLICY "generated_assessments_select" ON generated_assessments FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "generated_assessment_items_select" ON generated_assessment_items FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM generated_assessments WHERE id = assessment_id AND couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())));


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_couple_members_user ON couple_members(user_id);
CREATE INDEX idx_couple_members_couple ON couple_members(couple_id);
CREATE INDEX idx_response_sessions_user ON response_sessions(user_id);
CREATE INDEX idx_response_sessions_status ON response_sessions(user_id, status);
CREATE INDEX idx_responses_session ON responses(session_id);
CREATE INDEX idx_onboarding_sessions_user ON onboarding_sessions(user_id);
CREATE INDEX idx_onboarding_responses_session ON onboarding_responses(session_id);
CREATE INDEX idx_profile_vectors_user ON profile_vectors(user_id);
CREATE INDEX idx_item_bank_stage ON item_bank(stage);
CREATE INDEX idx_item_bank_dimension ON item_bank(dimension_slug);
CREATE INDEX idx_questions_section ON questions(section_id);
CREATE INDEX idx_weekly_plans_couple ON weekly_plans(couple_id);
CREATE INDEX idx_weekly_plan_items_plan ON weekly_plan_items(plan_id);
CREATE INDEX idx_dimension_scores_user ON dimension_scores(user_id);
CREATE INDEX idx_couple_vectors_couple ON couple_vectors(couple_id);


-- ============================================================
-- SEED: Structural Data
-- ============================================================

-- 1. Dimension Keys (V2 framework — 12 dimensions mapped to 4C)
INSERT INTO dimension_keys (slug, name, description, layer) VALUES
  ('intimidad_emocional', 'Intimidad Emocional', 'Vulnerabilidad, profundidad, cercanía sentida', 'conexion'),
  ('rituales', 'Rituales y Presencia', 'Pequeños hábitos, atención, conexión recurrente', 'conexion'),
  ('curiosidad_mutua', 'Curiosidad Mutua', 'Sentirse conocido/a y conocer al otro', 'conexion'),
  ('apoyo_emocional', 'Estilo de Apoyo', 'Si el cuidado ofrecido coincide con el necesitado', 'cuidado'),
  ('validacion', 'Validación Emocional', 'Sentirse comprendido/a y reconocido/a', 'cuidado'),
  ('lenguajes_afecto', 'Encaje Afectivo', 'Coincidencia entre afecto deseado y recibido', 'cuidado'),
  ('estilo_conflicto', 'Inicio del Conflicto', 'Disposición y habilidad para empezar conversaciones difíciles', 'choque'),
  ('reactividad', 'Reactividad y Regulación', 'Activación emocional y auto-regulación', 'choque'),
  ('reparacion', 'Reparación y Reconexión', 'Capacidad de recuperarse y cerrar ciclos después de fricciones', 'choque'),
  ('metas', 'Planificación Compartida', 'Alineación alrededor del futuro y metas a largo plazo', 'camino'),
  ('dinero', 'Justicia y Acuerdos', 'Dinero, responsabilidades, límites, sistemas familiares', 'camino'),
  ('identidad', 'Integración de Autonomía', 'Espacio para la individualidad dentro del compromiso', 'camino');

-- 2. Main questionnaire shell
INSERT INTO questionnaires (slug, name, description, version, is_active, estimated_duration_minutes) VALUES
  ('relacion-v2', 'Evaluación de Pareja V2', 'Evaluación personalizada de relación construida a partir de perfiles individuales.', '2.0', true, 20);

-- 3. Questionnaire sections (4C blocks)
INSERT INTO questionnaire_sections (questionnaire_id, slug, name, description, sort_order, estimated_questions) VALUES
  ((SELECT id FROM questionnaires WHERE slug = 'relacion-v2'), 'section-a', 'Conexión', 'Intimidad emocional, rituales, humor, curiosidad, tiempo juntos', 1, 13),
  ((SELECT id FROM questionnaires WHERE slug = 'relacion-v2'), 'section-b', 'Cuidado', 'Lenguajes del afecto, apoyo, validación, atención, reparación', 2, 13),
  ((SELECT id FROM questionnaires WHERE slug = 'relacion-v2'), 'section-c', 'Choque', 'Conflicto, límites, reactividad, evasión, cierre', 3, 13),
  ((SELECT id FROM questionnaires WHERE slug = 'relacion-v2'), 'section-d', 'Camino', 'Metas, dinero, familia, hogar, identidad', 4, 13);

-- 4. Onboarding items (15 personal profile questions from blueprint)
INSERT INTO item_bank (slug, stage, dimension_slug, construct_slug, question_text, question_type, response_scale, sort_order, metadata) VALUES
('onb-01', 'onboarding', 'autonomy', 'personal_space', 'Cuando me siento abrumado/a, primero necesito espacio antes de hablar.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 1, '{}'),
('onb-02', 'onboarding', 'autonomy', 'independence', 'Para mí es importante mantener espacios propios dentro de la relación.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 2, '{}'),
('onb-03', 'onboarding', 'reassurance', 'affection_actions', 'Me siento querido/a principalmente a través de acciones concretas.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 3, '{}'),
('onb-04', 'onboarding', 'reassurance', 'verbal_reassurance', 'Necesito escuchar palabras claras de cariño o reconocimiento para sentirme seguro/a.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 4, '{}'),
('onb-05', 'onboarding', 'conflict', 'conflict_initiation', 'Prefiero resolver tensiones pronto, aunque la conversación sea incómoda.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 5, '{}'),
('onb-06', 'onboarding', 'conflict', 'conflict_avoidance', 'Cuando hay conflicto, me cuesta iniciar la conversación.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 6, '{"reverse_scored": true}'),
('onb-07', 'onboarding', 'conflict', 'repair_speed', 'Después de una discusión, suelo recuperar la calma con rapidez.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 7, '{}'),
('onb-08', 'onboarding', 'stress_coping', 'bad_day_response', 'Si tengo un mal día, prefiero que mi pareja:', 'ESCENARIO',
 '{"options": [{"value": "A", "label": "Me escuche sin dar consejos", "order": 1}, {"value": "B", "label": "Me ayude a resolver lo que pasó", "order": 2}, {"value": "C", "label": "Me dé espacio y tiempo", "order": 3}, {"value": "D", "label": "Me pregunte qué necesito en ese momento", "order": 4}]}',
 8, '{"scenario": "Imagina que llegas a casa después de un día difícil..."}'),
('onb-09', 'onboarding', 'stress_coping', 'difficult_talk_timing', 'Si mi pareja quiere hablar de algo difícil cuando yo no estoy regulado/a, prefiero:', 'ESCENARIO',
 '{"options": [{"value": "A", "label": "Hablar de una vez para no dejarlo pendiente", "order": 1}, {"value": "B", "label": "Pedir una pausa corta y retomar después", "order": 2}, {"value": "C", "label": "Dejarlo para otro momento más tranquilo", "order": 3}, {"value": "D", "label": "Evitarlo si no es urgente", "order": 4}]}',
 9, '{"scenario": "Tu pareja necesita hablar de algo importante, pero tú no te sientes listo/a..."}'),
('onb-10', 'onboarding', 'emotional_expression', 'asking_comfort', 'Me resulta fácil pedir consuelo o apoyo emocional.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 10, '{}'),
('onb-11', 'onboarding', 'emotional_expression', 'expressing_needs', 'Me resulta fácil decir claramente lo que necesito.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 11, '{}'),
('onb-12', 'onboarding', 'rituals', 'daily_rituals', 'Los pequeños rituales cotidianos me ayudan a sentir conexión.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 12, '{}'),
('onb-13', 'onboarding', 'rituals', 'quality_time', 'Me gusta saber cuándo tendremos tiempo de calidad juntos.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 13, '{}'),
('onb-14', 'onboarding', 'future_orientation', 'future_talks', 'Hablar del futuro como pareja es importante para mí.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 14, '{}'),
('onb-15', 'onboarding', 'future_orientation', 'building_together', 'Me tranquiliza sentir que estamos construyendo algo juntos.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 15, '{}');

-- Seed item_dimensions for onboarding items
INSERT INTO item_dimensions (item_id, dimension_slug, weight)
SELECT id, dimension_slug, 1.000 FROM item_bank WHERE stage = 'onboarding';
