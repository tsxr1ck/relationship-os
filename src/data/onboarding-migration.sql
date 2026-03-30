-- ============================================================
-- Relationship OS V2 — Onboarding & Item Bank Migration
-- Run this in Supabase SQL Editor
-- ============================================================

-- 1. Item Bank — master list of vetted question items
CREATE TABLE IF NOT EXISTS item_bank (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  stage TEXT NOT NULL CHECK (stage IN ('onboarding', 'core', 'adaptive', 'deep_dive')),
  dimension_slug TEXT NOT NULL,
  construct_slug TEXT NOT NULL,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL CHECK (question_type IN ('LIKERT-5', 'LIKERT-7', 'FC', 'ESCENARIO', 'RANK', 'SEMAFORO', 'ABIERTA', 'SLIDER')),
  response_scale JSONB,
  reverse_scored BOOLEAN DEFAULT FALSE,
  sensitivity_level TEXT DEFAULT 'low' CHECK (sensitivity_level IN ('low', 'medium', 'high')),
  requires_opt_in BOOLEAN DEFAULT FALSE,
  scoring_strategy TEXT DEFAULT 'direct',
  sort_order INTEGER NOT NULL DEFAULT 0,
  active BOOLEAN DEFAULT TRUE,
  version INTEGER DEFAULT 1,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Item Dimensions — mapping items to dimensions with weights
CREATE TABLE IF NOT EXISTS item_dimensions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  item_id UUID REFERENCES item_bank(id) ON DELETE CASCADE,
  dimension_slug TEXT NOT NULL,
  weight NUMERIC(4,3) DEFAULT 1.000,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Profile Vectors — per-user normalized onboarding outputs
CREATE TABLE IF NOT EXISTS profile_vectors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  dimension_slug TEXT NOT NULL,
  raw_score NUMERIC(6,2) NOT NULL,
  normalized_score NUMERIC(6,2) NOT NULL,
  item_count INTEGER DEFAULT 0,
  version INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, dimension_slug)
);

-- 4. Onboarding sessions — track personal onboarding completion
CREATE TABLE IF NOT EXISTS onboarding_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
  status TEXT NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed')),
  current_question_index INTEGER DEFAULT 0,
  progress_pct INTEGER DEFAULT 0,
  responses JSONB DEFAULT '{}',
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Onboarding responses — individual answers for onboarding items
CREATE TABLE IF NOT EXISTS onboarding_responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID REFERENCES onboarding_sessions(id) ON DELETE CASCADE,
  item_id UUID REFERENCES item_bank(id) ON DELETE CASCADE,
  answer_value JSONB NOT NULL,
  answered_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(session_id, item_id)
);

-- ============================================================
-- RLS Policies
-- ============================================================

ALTER TABLE item_bank ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_dimensions ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile_vectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE onboarding_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE onboarding_responses ENABLE ROW LEVEL SECURITY;

-- item_bank: readable by all authenticated users (public question catalog)
CREATE POLICY "item_bank_select" ON item_bank FOR SELECT TO authenticated USING (TRUE);

-- item_dimensions: readable by all authenticated users
CREATE POLICY "item_dimensions_select" ON item_dimensions FOR SELECT TO authenticated USING (TRUE);

-- profile_vectors: users can only read/write their own
CREATE POLICY "profile_vectors_select" ON profile_vectors FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "profile_vectors_insert" ON profile_vectors FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "profile_vectors_update" ON profile_vectors FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- onboarding_sessions: users can only manage their own
CREATE POLICY "onboarding_sessions_select" ON onboarding_sessions FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "onboarding_sessions_insert" ON onboarding_sessions FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "onboarding_sessions_update" ON onboarding_sessions FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- onboarding_responses: users can manage their own (via session ownership)
CREATE POLICY "onboarding_responses_select" ON onboarding_responses FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM onboarding_sessions WHERE id = onboarding_responses.session_id AND user_id = auth.uid()));
CREATE POLICY "onboarding_responses_insert" ON onboarding_responses FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM onboarding_sessions WHERE id = onboarding_responses.session_id AND user_id = auth.uid()));
CREATE POLICY "onboarding_responses_update" ON onboarding_responses FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM onboarding_sessions WHERE id = onboarding_responses.session_id AND user_id = auth.uid()));

-- ============================================================
-- Seed: 15 Onboarding Items from Blueprint
-- ============================================================

INSERT INTO item_bank (stage, dimension_slug, construct_slug, question_text, question_type, response_scale, sort_order, metadata) VALUES
-- Autonomy (2 items)
('onboarding', 'autonomy', 'personal_space', 'Cuando me siento abrumado/a, primero necesito espacio antes de hablar.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 1, '{"min_label": "Muy en desacuerdo", "max_label": "Muy de acuerdo"}'),

('onboarding', 'autonomy', 'independence', 'Para mí es importante mantener espacios propios dentro de la relación.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 2, '{"min_label": "Muy en desacuerdo", "max_label": "Muy de acuerdo"}'),

-- Reassurance / Affection (2 items)
('onboarding', 'reassurance', 'affection_actions', 'Me siento querido/a principalmente a través de acciones concretas.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 3, '{}'),

('onboarding', 'reassurance', 'verbal_reassurance', 'Necesito escuchar palabras claras de cariño o reconocimiento para sentirme seguro/a.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 4, '{}'),

-- Conflict Approach (3 items)
('onboarding', 'conflict', 'conflict_initiation', 'Prefiero resolver tensiones pronto, aunque la conversación sea incómoda.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 5, '{}'),

('onboarding', 'conflict', 'conflict_avoidance', 'Cuando hay conflicto, me cuesta iniciar la conversación.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 6, '{"reverse_scored": true}'),

('onboarding', 'conflict', 'repair_speed', 'Después de una discusión, suelo recuperar la calma con rapidez.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 7, '{}'),

-- Stress Coping (2 scenario items)
('onboarding', 'stress_coping', 'bad_day_response', 'Si tengo un mal día, prefiero que mi pareja:', 'ESCENARIO',
 '{"options": [{"value": "A", "label": "Me escuche sin dar consejos", "order": 1}, {"value": "B", "label": "Me ayude a resolver lo que pasó", "order": 2}, {"value": "C", "label": "Me dé espacio y tiempo", "order": 3}, {"value": "D", "label": "Me pregunte qué necesito en ese momento", "order": 4}]}',
 8, '{"scenario": "Imagina que llegas a casa después de un día difícil..."}'),

('onboarding', 'stress_coping', 'difficult_talk_timing', 'Si mi pareja quiere hablar de algo difícil cuando yo no estoy regulado/a, prefiero:', 'ESCENARIO',
 '{"options": [{"value": "A", "label": "Hablar de una vez para no dejarlo pendiente", "order": 1}, {"value": "B", "label": "Pedir una pausa corta y retomar después", "order": 2}, {"value": "C", "label": "Dejarlo para otro momento más tranquilo", "order": 3}, {"value": "D", "label": "Evitarlo si no es urgente", "order": 4}]}',
 9, '{"scenario": "Tu pareja necesita hablar de algo importante, pero tú no te sientes listo/a..."}'),

-- Emotional Expression (2 items)
('onboarding', 'emotional_expression', 'asking_comfort', 'Me resulta fácil pedir consuelo o apoyo emocional.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 10, '{}'),

('onboarding', 'emotional_expression', 'expressing_needs', 'Me resulta fácil decir claramente lo que necesito.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 11, '{}'),

-- Rituals and Consistency (2 items)
('onboarding', 'rituals', 'daily_rituals', 'Los pequeños rituales cotidianos me ayudan a sentir conexión.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 12, '{}'),

('onboarding', 'rituals', 'quality_time', 'Me gusta saber cuándo tendremos tiempo de calidad juntos.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 13, '{}'),

-- Future Orientation (2 items)
('onboarding', 'future_orientation', 'future_talks', 'Hablar del futuro como pareja es importante para mí.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 14, '{}'),

('onboarding', 'future_orientation', 'building_together', 'Me tranquiliza sentir que estamos construyendo algo juntos.', 'LIKERT-5',
 '{"options": [{"value": "1", "label": "Muy en desacuerdo", "order": 1}, {"value": "2", "label": "En desacuerdo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "De acuerdo", "order": 4}, {"value": "5", "label": "Muy de acuerdo", "order": 5}]}',
 15, '{}');

-- Seed item_dimensions for all onboarding items
INSERT INTO item_dimensions (item_id, dimension_slug, weight)
SELECT id, dimension_slug, 1.000 FROM item_bank WHERE stage = 'onboarding';

-- ============================================================
-- Indexes
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_item_bank_stage ON item_bank(stage);
CREATE INDEX IF NOT EXISTS idx_item_bank_dimension ON item_bank(dimension_slug);
CREATE INDEX IF NOT EXISTS idx_profile_vectors_user ON profile_vectors(user_id);
CREATE INDEX IF NOT EXISTS idx_onboarding_sessions_user ON onboarding_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_onboarding_responses_session ON onboarding_responses(session_id);
