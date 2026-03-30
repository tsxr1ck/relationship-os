-- ============================================================================
-- RELATIONSHIP OS - Migration: AI Insights Table
-- Run in: Supabase SQL Editor
-- ============================================================================

-- Create the ai_insights table to cache API responses
CREATE TABLE IF NOT EXISTS ai_insights (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    couple_id UUID REFERENCES couples(id) ON DELETE SET NULL,
    dimension_slug TEXT NOT NULL,
    insight_text TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    -- Ensure only one insight per user/dimension pair
    UNIQUE(user_id, dimension_slug)
);

-- Row Level Security (RLS)
ALTER TABLE ai_insights ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own insights
CREATE POLICY "Users can view own insights"
ON ai_insights FOR SELECT
USING (user_id = auth.uid());

-- Policy: Users can insert their own insights
CREATE POLICY "Users can insert own insights"
ON ai_insights FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Policy: Users can update their own insights
CREATE POLICY "Users can update own insights"
ON ai_insights FOR UPDATE
USING (user_id = auth.uid());

-- Trigger to auto-update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_ai_insights_modtime
BEFORE UPDATE ON ai_insights
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
