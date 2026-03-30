-- ============================================================================
-- RELATIONSHIP OS - Database Schema
-- Version: 1.0
-- Description: Complete schema with RLS policies
-- Run in: Supabase SQL Editor
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- SECTION 1: CORE IDENTITY TABLES
-- ============================================================================

-- Profiles: Extended user data beyond auth.users
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT,
    avatar_url TEXT,
    locale TEXT DEFAULT 'es-MX',
    timezone TEXT DEFAULT 'America/Mexico_City',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Couples: The relationship entity
CREATE TABLE couples (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    invite_code TEXT UNIQUE NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'archived', 'dissolved')),
    created_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Couple Members: Pivot table connecting users to couples
CREATE TABLE couple_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('self', 'partner')),
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(couple_id, user_id)
);

-- Couple Status View: Materialized view for quick status lookups
CREATE MATERIALIZED VIEW couple_status_view AS
SELECT 
    cm.couple_id,
    cm.user_id,
    c.invite_code,
    c.status as couple_status,
    c.created_at as couple_created_at,
    (
        SELECT COUNT(*) 
        FROM response_sessions rs 
        WHERE rs.user_id = cm.user_id 
        AND rs.status = 'completed'
    ) as completed_sessions,
    (
        SELECT MAX(rs.completed_at) 
        FROM response_sessions rs 
        WHERE rs.user_id = cm.user_id 
        AND rs.status = 'completed'
    ) as last_activity,
    (
        SELECT COUNT(*) 
        FROM weekly_plan_items wpi
        JOIN weekly_plans wp ON wp.id = wpi.plan_id
        WHERE wp.couple_id = cm.couple_id 
        AND wpi.status = 'completed'
    ) as completed_activities,
    (
        SELECT MAX(wp.week_start)
        FROM weekly_plans wp
        WHERE wp.couple_id = cm.couple_id
    ) as last_plan_week
FROM couple_members cm
JOIN couples c ON c.id = cm.couple_id;

-- ============================================================================
-- SECTION 2: QUESTIONNAIRE TABLES
-- ============================================================================

-- Questionnaires: Versioned questionnaire definitions
CREATE TABLE questionnaires (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    version TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    estimated_duration_minutes INT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Questionnaire Sections: Blocks (A, B, C, D)
CREATE TABLE questionnaire_sections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    questionnaire_id UUID NOT NULL REFERENCES questionnaires(id) ON DELETE CASCADE,
    slug TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    sort_order INT NOT NULL,
    estimated_questions INT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(questionnaire_id, slug)
);

-- Questions: The actual question bank
CREATE TABLE questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    section_id UUID NOT NULL REFERENCES questionnaire_sections(id) ON DELETE CASCADE,
    question_number INT NOT NULL,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL CHECK (question_type IN (
        'LIKERT-5', 'LIKERT-7', 'FC', 'ESCENARIO', 'RANK', 
        'SEMAFORO', 'ABIERTA', 'SLIDER'
    )),
    is_sensitive BOOLEAN DEFAULT false,
    is_required BOOLEAN DEFAULT true,
    is_opt_in BOOLEAN DEFAULT false,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Answer Options: Predefined choices for each question
CREATE TABLE answer_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_value TEXT NOT NULL,
    option_label TEXT NOT NULL,
    option_order INT NOT NULL,
    weight JSONB DEFAULT '{}',
    UNIQUE(question_id, option_value)
);

-- Dimension Keys: The 20 subdimensiones
CREATE TABLE dimension_keys (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    layer TEXT NOT NULL CHECK (layer IN ('conexion', 'cuidado', 'choque', 'camino')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Question Dimension Map: N:N relationship with weights
CREATE TABLE question_dimension_map (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    dimension_id UUID NOT NULL REFERENCES dimension_keys(id) ON DELETE CASCADE,
    weight NUMERIC(3,2) DEFAULT 1.00,
    UNIQUE(question_id, dimension_id)
);

-- ============================================================================
-- SECTION 3: RESPONSE TABLES
-- ============================================================================

-- Response Sessions: Each time a user starts/completes the questionnaire
CREATE TABLE response_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    questionnaire_id UUID NOT NULL REFERENCES questionnaires(id),
    section_id UUID REFERENCES questionnaire_sections(id),
    status TEXT DEFAULT 'started' CHECK (status IN ('started', 'in_progress', 'completed', 'abandoned')),
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    progress_percentage NUMERIC(5,2) DEFAULT 0
);

-- Responses: Individual answers
CREATE TABLE responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES response_sessions(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    answer_value JSONB NOT NULL,
    answered_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- SECTION 4: REPORT TABLES
-- ============================================================================

-- Personal Reports: Individual analysis
CREATE TABLE personal_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    session_id UUID REFERENCES response_sessions(id),
    archetype TEXT,
    summary JSONB DEFAULT '{}',
    strengths JSONB DEFAULT '[]',
    growth_areas JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Couple Reports: Shared analysis (both partners can see)
CREATE TABLE couple_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
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

-- Dimension Scores: Normalized scores per dimension per user
CREATE TABLE dimension_scores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    couple_id UUID REFERENCES couples(id),
    dimension_id UUID NOT NULL REFERENCES dimension_keys(id),
    raw_score NUMERIC(5,2),
    normalized_score NUMERIC(5,2),
    calculated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, dimension_id)
);

-- ============================================================================
-- SECTION 5: WEEKLY PLAN TABLES
-- ============================================================================

-- Weekly Plans: AI-generated weekly plans
CREATE TABLE weekly_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
    week_start DATE NOT NULL,
    week_end DATE NOT NULL,
    generated_at TIMESTAMPTZ DEFAULT NOW(),
    couple_status_snapshot JSONB NOT NULL,
    plan JSONB NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'skipped', 'archived')),
    completion_rate NUMERIC(4,2) DEFAULT 0,
    couple_feedback JSONB,
    ai_model_used TEXT NOT NULL,
    prompt_version TEXT NOT NULL
);

-- Weekly Plan Items: Individual daily activities
CREATE TABLE weekly_plan_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    plan_id UUID NOT NULL REFERENCES weekly_plans(id) ON DELETE CASCADE,
    couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
    day_label TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    dimension TEXT NOT NULL,
    activity_type TEXT NOT NULL CHECK (activity_type IN (
        'conversacion', 'ritual', 'reto', 'reflexion', 'microaccion', 'check_in'
    )),
    duration_minutes INT NOT NULL,
    difficulty TEXT DEFAULT 'medium' CHECK (difficulty IN ('easy', 'medium', 'deep')),
    requires_both BOOLEAN DEFAULT true,
    assigned_to TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'skipped')),
    completed_at TIMESTAMPTZ,
    notes TEXT
);

-- AI Audit Log: Track all AI calls
CREATE TABLE ai_audit_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    couple_id UUID REFERENCES couples(id),
    model TEXT NOT NULL,
    prompt_version TEXT NOT NULL,
    input_tokens INT,
    output_tokens INT,
    total_tokens INT,
    latency_ms INT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- SECTION 6: CONTENT TABLES
-- ============================================================================

-- Guided Conversations: Library of conversation prompts
CREATE TABLE guided_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    dimension TEXT NOT NULL,
    difficulty TEXT DEFAULT 'medium' CHECK (difficulty IN ('easy', 'medium', 'deep')),
    duration_minutes INT DEFAULT 20,
    prompt JSONB NOT NULL,
    opening_card_id TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Weekly Challenges: Bank of challenges
CREATE TABLE weekly_challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    dimension TEXT NOT NULL,
    difficulty TEXT DEFAULT 'medium',
    duration_days INT DEFAULT 7,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Challenge Assignments: Active challenge for a couple
CREATE TABLE challenge_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
    challenge_id UUID NOT NULL REFERENCES weekly_challenges(id),
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'abandoned')),
    progress JSONB DEFAULT '{}'
);

-- Milestones: Important dates
CREATE TABLE milestones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    milestone_type TEXT NOT NULL CHECK (milestone_type IN (
        'anniversary', 'achievement', 'milestone', 'special_date'
    )),
    date DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- SECTION 7: ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE couple_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE response_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE personal_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE couple_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE dimension_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_plan_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE guided_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE milestones ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- RLS: profiles
-- ============================================================================

CREATE POLICY "Users can view own profile"
ON profiles FOR SELECT
USING (id = auth.uid());

CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
USING (id = auth.uid());

CREATE POLICY "Users can insert own profile"
ON profiles FOR INSERT
WITH CHECK (id = auth.uid());

-- ============================================================================
-- RLS: couples
-- ============================================================================

CREATE POLICY "Couple members can view their couple"
ON couples FOR SELECT
USING (
    id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

CREATE POLICY "Users can insert couples they create"
ON couples FOR INSERT
WITH CHECK (created_by = auth.uid());

-- ============================================================================
-- RLS: couple_members
-- ============================================================================

CREATE POLICY "Users can view their couple memberships"
ON couple_members FOR SELECT
USING (user_id = auth.uid());

CREATE POLICY "Users can insert themselves as couple members"
ON couple_members FOR INSERT
WITH CHECK (user_id = auth.uid());

-- ============================================================================
-- RLS: response_sessions
-- ============================================================================

CREATE POLICY "Users can view own sessions"
ON response_sessions FOR SELECT
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own sessions"
ON response_sessions FOR INSERT
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own sessions"
ON response_sessions FOR UPDATE
USING (user_id = auth.uid());

-- ============================================================================
-- RLS: responses
-- ============================================================================

CREATE POLICY "Users can view own responses"
ON responses FOR SELECT
USING (
    session_id IN (SELECT id FROM response_sessions WHERE user_id = auth.uid())
);

CREATE POLICY "Users can insert own responses"
ON responses FOR INSERT
WITH CHECK (
    session_id IN (SELECT id FROM response_sessions WHERE user_id = auth.uid())
);

CREATE POLICY "Users can update own responses"
ON responses FOR UPDATE
USING (
    session_id IN (SELECT id FROM response_sessions WHERE user_id = auth.uid())
);

-- ============================================================================
-- RLS: personal_reports
-- ============================================================================

CREATE POLICY "Users can view own personal reports"
ON personal_reports FOR SELECT
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own personal reports"
ON personal_reports FOR INSERT
WITH CHECK (user_id = auth.uid());

-- ============================================================================
-- RLS: couple_reports
-- ============================================================================

CREATE POLICY "Couple members can view shared reports"
ON couple_reports FOR SELECT
USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- ============================================================================
-- RLS: dimension_scores
-- ============================================================================

CREATE POLICY "Users can view own dimension scores"
ON dimension_scores FOR SELECT
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own dimension scores"
ON dimension_scores FOR INSERT
WITH CHECK (user_id = auth.uid());

-- ============================================================================
-- RLS: weekly_plans
-- ============================================================================

CREATE POLICY "Couple members can view weekly plans"
ON weekly_plans FOR SELECT
USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- ============================================================================
-- RLS: weekly_plan_items
-- ============================================================================

CREATE POLICY "Couple members can view plan items"
ON weekly_plan_items FOR SELECT
USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

CREATE POLICY "Couple members can update plan item status"
ON weekly_plan_items FOR UPDATE
USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- ============================================================================
-- RLS: challenge_assignments
-- ============================================================================

CREATE POLICY "Couple members can view challenges"
ON challenge_assignments FOR SELECT
USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

CREATE POLICY "Couple members can update challenges"
ON challenge_assignments FOR UPDATE
USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- ============================================================================
-- RLS: milestones
-- ============================================================================

CREATE POLICY "Couple members can view milestones"
ON milestones FOR SELECT
USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

CREATE POLICY "Couple members can insert milestones"
ON milestones FOR INSERT
WITH CHECK (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- ============================================================================
-- RLS: guided_conversations (public read)
-- ============================================================================

CREATE POLICY "Anyone can view guided conversations"
ON guided_conversations FOR SELECT
USING (true);

-- ============================================================================
-- RLS: weekly_challenges (public read)
-- ============================================================================

CREATE POLICY "Anyone can view weekly challenges"
ON weekly_challenges FOR SELECT
USING (true);

-- ============================================================================
-- SECTION 8: SEED DATA
-- ============================================================================

-- Seed Dimension Keys (the 20 subdimensiones)
INSERT INTO dimension_keys (slug, name, description, layer) VALUES
-- Conexion (5)
('intimidad_emocional', 'Intimidad Emocional', 'Profundidad y vulnerabilidad emocional', 'conexion'),
('rituales', 'Rituales', 'Costumbres y rituales compartidos', 'conexion'),
('humor_compartido', 'Humor Compartido', 'Risa y momentos ligeros juntos', 'conexion'),
('curiosidad_mutua', 'Curiosidad Mutua', 'Interés genuino en el otro', 'conexion'),
('tiempo_juntos', 'Tiempo Juntos', 'Cantidad y calidad de tiempo compartido', 'conexion'),

-- Cuidado (5)
('lenguajes_afecto', 'Lenguajes del Afecto', 'Cómo dan y reciben amor', 'cuidado'),
('apoyo_emocional', 'Apoyo Emocional', 'Soporte en momentos difíciles', 'cuidado'),
('validacion', 'Validación Emocional', 'Reconocimiento de emociones', 'cuidado'),
('atencion', 'Atención', 'Presencia y atención plena', 'cuidado'),
('reparacion', 'Reparación', 'Capacidad de arreglar conflictos', 'cuidado'),

-- Choque (5)
('estilo_conflicto', 'Estilo de Conflicto', 'Cómo manejan discusiones', 'choque'),
('limites', 'Límites', 'Boundaries personales', 'choque'),
('reactividad', 'Reactividad', 'Respuesta emocional bajo presión', 'choque'),
('evasion', 'Evasión', 'Tendencia a evitar conflictos', 'choque'),
('cierre', 'Cierre', 'Capacidad de resolver y cerrar', 'choque'),

-- Camino (5)
('metas', 'Metas', 'Objetivos compartidos', 'camino'),
('dinero', 'Dinero', 'Manejo financiero', 'camino'),
('familia', 'Familia', 'Planificación familiar', 'camino'),
('hogar', 'Hogar', 'Vivienda y ciudad', 'camino'),
('identidad', 'Identidad', 'Independencia y carrera', 'camino')
ON CONFLICT (slug) DO NOTHING;

-- Seed Questionnaire (Base v1)
INSERT INTO questionnaires (slug, name, description, version, estimated_duration_minutes)
VALUES ('base-v1', 'Cuestionario Base', 'Cuestionario inicial de 52 preguntas', '1.0', 30)
ON CONFLICT (slug) DO NOTHING;

-- Seed Questionnaire Sections
INSERT INTO questionnaire_sections (questionnaire_id, slug, name, description, sort_order, estimated_questions)
SELECT 
    q.id,
    'bloque-a',
    'Descubrimiento Personal',
    'Conoce mejor a ti mismo/a antes de comparar',
    1,
    12
FROM questionnaires q WHERE q.slug = 'base-v1'
ON CONFLICT (questionnaire_id, slug) DO NOTHING;

INSERT INTO questionnaire_sections (questionnaire_id, slug, name, description, sort_order, estimated_questions)
SELECT 
    q.id,
    'bloque-b',
    'Conocer a Tu Pareja',
    'Descubre cuánto conoces realmente a tu pareja',
    2,
    16
FROM questionnaires q WHERE q.slug = 'base-v1'
ON CONFLICT (questionnaire_id, slug) DO NOTHING;

INSERT INTO questionnaire_sections (questionnaire_id, slug, name, description, sort_order, estimated_questions)
SELECT 
    q.id,
    'bloque-c',
    'Relación y Dinámica',
    'Cómo funcionan juntos en cotidiano y presión',
    3,
    16
FROM questionnaires q WHERE q.slug = 'base-v1'
ON CONFLICT (questionnaire_id, slug) DO NOTHING;

INSERT INTO questionnaire_sections (questionnaire_id, slug, name, description, sort_order, estimated_questions)
SELECT 
    q.id,
    'bloque-d',
    'Proyecto de Vida Compartido',
    'Hacia dónde van como pareja',
    4,
    8
FROM questionnaires q WHERE q.slug = 'base-v1'
ON CONFLICT (questionnaire_id, slug) DO NOTHING;

-- ============================================================================
-- SECTION 9: HELPER FUNCTIONS
-- ============================================================================

-- Function to generate invite code
CREATE OR REPLACE FUNCTION generate_invite_code()
RETURNS TEXT AS $$
DECLARE
    chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    result TEXT := '';
    i INT;
BEGIN
    FOR i IN 1..8 LOOP
        result := result || substr(chars, floor(random() * length(chars) + 1)::int, 1);
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql VOLATILE;

-- Function to get couple ID for user
CREATE OR REPLACE FUNCTION get_couple_id_for_user(user_uuid UUID)
RETURNS UUID AS $$
DECLARE
    couple_uuid UUID;
BEGIN
    SELECT couple_id INTO couple_uuid
    FROM couple_members
    WHERE user_id = user_uuid
    LIMIT 1;
    RETURN couple_uuid;
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to check if user is in a couple
CREATE OR REPLACE FUNCTION has_couple(user_uuid UUID)
RETURNS BOOLEAN AS $$
DECLARE
    has_c BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM couple_members WHERE user_id = user_uuid) INTO has_c;
    RETURN has_c;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- SECTION 10: TRIGGERS
-- ============================================================================

-- Trigger to create profile on user creation
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (id, full_name, avatar_url, locale, timezone)
    VALUES (
        NEW.id,
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'avatar_url',
        COALESCE(NEW.raw_user_meta_data->>'locale', 'es-MX'),
        COALESCE(NEW.raw_user_meta_data->>'timezone', 'America/Mexico_City')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION handle_new_user();

-- Trigger to create couple status entry
CREATE OR REPLACE FUNCTION handle_couple_created()
RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW couple_status_view;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_couple_created
AFTER INSERT ON couples
FOR EACH ROW
EXECUTE FUNCTION handle_couple_created();

CREATE TRIGGER on_couple_member_created
AFTER INSERT ON couple_members
FOR EACH ROW
EXECUTE FUNCTION handle_couple_created();

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
