-- ============================================================================
-- RELATIONSHIP OS - V2 Questionnaire Blueprint Migration
-- ============================================================================

-- ============================================================================
-- 1. V2 Core Data Tables (Item Bank & Generation)
-- ============================================================================

-- Item Bank: Master repository of approved questions
CREATE TABLE IF NOT EXISTS item_bank (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug TEXT UNIQUE NOT NULL,
    stage TEXT NOT NULL CHECK (stage IN ('onboarding', 'core', 'adaptive', 'deep_dive')),
    dimension_slug TEXT,
    construct_slug TEXT,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL CHECK (question_type IN ('LIKERT-5', 'LIKERT-7', 'SCENARIO', 'RANK', 'OPEN')),
    response_scale JSONB, -- Array of labels or options
    reverse_scored BOOLEAN DEFAULT false,
    sensitivity_level TEXT DEFAULT 'normal' CHECK (sensitivity_level IN ('normal', 'high', 'opt-in')),
    active BOOLEAN DEFAULT true,
    version TEXT DEFAULT '1.0',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Item Dimensions: Mapping questions to dimensions
CREATE TABLE IF NOT EXISTS item_dimensions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    item_id UUID NOT NULL REFERENCES item_bank(id) ON DELETE CASCADE,
    dimension_slug TEXT NOT NULL, -- references dimension_keys(slug) implicitly as logic
    weight NUMERIC(3,2) DEFAULT 1.00,
    UNIQUE(item_id, dimension_slug)
);

-- ============================================================================
-- 2. V2 Assessment Construction
-- ============================================================================

-- Profile Vectors: Storing normalized 0-100 scores from Onboarding
CREATE TABLE IF NOT EXISTS profile_vectors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    dimension_slug TEXT NOT NULL,
    intensity_score NUMERIC(5,2) NOT NULL, -- 0 to 100
    confidence_level NUMERIC(5,2) DEFAULT 1.0, 
    calculated_at TIMESTAMPTZ DEFAULT NOW(),
    source_session_id UUID REFERENCES response_sessions(id),
    UNIQUE(user_id, dimension_slug)
);

-- Couple Vectors: Storing computed pair deltas & mismatch flags
CREATE TABLE IF NOT EXISTS couple_vectors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
    dimension_slug TEXT NOT NULL,
    mismatch_delta NUMERIC(5,2) NOT NULL,
    risk_flag BOOLEAN DEFAULT false,
    opportunity_flag BOOLEAN DEFAULT false,
    calculated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(couple_id, dimension_slug)
);

-- Generated Assessments: One runtime JSON representation of the 28 questions per couple per iteration
CREATE TABLE IF NOT EXISTS generated_assessments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    gemini_prompt_version TEXT,
    status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Generated Assessment Items: The selected/rewritten questions from the bank for this couple
CREATE TABLE IF NOT EXISTS generated_assessment_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assessment_id UUID NOT NULL REFERENCES generated_assessments(id) ON DELETE CASCADE,
    item_bank_id UUID REFERENCES item_bank(id) ON DELETE SET NULL, -- Can be null if rewritten by Gemini completely
    category TEXT NOT NULL CHECK (category IN ('core', 'insight', 'adaptive')),
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL,
    response_scale JSONB,
    sort_order INT NOT NULL,
    target_dimension TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add assessment reference to response sessions
ALTER TABLE response_sessions 
ADD COLUMN IF NOT EXISTS generated_assessment_id UUID REFERENCES generated_assessments(id);

ALTER TABLE response_sessions 
ADD COLUMN IF NOT EXISTS stage TEXT DEFAULT 'legacy' CHECK (stage IN ('legacy', 'onboarding', 'couple_v2', 'deep_dive'));

-- ============================================================================
-- 3. RLS Policies
-- ============================================================================

ALTER TABLE item_bank ENABLE ROW LEVEL SECURITY;
ALTER TABLE item_dimensions ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile_vectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE couple_vectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE generated_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE generated_assessment_items ENABLE ROW LEVEL SECURITY;

-- Item Bank (Read-only for all)
CREATE POLICY "Anyone can view item bank" ON item_bank FOR SELECT USING (true);
CREATE POLICY "Anyone can view item dimensions" ON item_dimensions FOR SELECT USING (true);

-- Profile Vectors (Users can manage their own)
CREATE POLICY "Users view own profile vectors" ON profile_vectors FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Users insert own profile vectors" ON profile_vectors FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users update own profile vectors" ON profile_vectors FOR UPDATE USING (user_id = auth.uid());

-- Couple Vectors (Couple members can view)
CREATE POLICY "Couple members view their vectors" ON couple_vectors FOR SELECT USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);
CREATE POLICY "System inserts couple vectors" ON couple_vectors FOR INSERT WITH CHECK (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);
CREATE POLICY "System updates couple vectors" ON couple_vectors FOR UPDATE USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- Generated Assessments (Couple access)
CREATE POLICY "Couple views their assessments" ON generated_assessments FOR SELECT USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);
CREATE POLICY "Couple inserts their assessments" ON generated_assessments FOR INSERT WITH CHECK (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- Generated Assessment Items (Couple access)
CREATE POLICY "Couple views their assessment items" ON generated_assessment_items FOR SELECT USING (
    assessment_id IN (
        SELECT id FROM generated_assessments WHERE couple_id IN (
            SELECT couple_id FROM couple_members WHERE user_id = auth.uid()
        )
    )
);
CREATE POLICY "Couple inserts their assessment items" ON generated_assessment_items FOR INSERT WITH CHECK (
    assessment_id IN (
        SELECT id FROM generated_assessments WHERE couple_id IN (
            SELECT couple_id FROM couple_members WHERE user_id = auth.uid()
        )
    )
);

-- Trigger to auto-update 'updated_at' on item_bank
CREATE TRIGGER update_item_bank_modtime
BEFORE UPDATE ON item_bank
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
