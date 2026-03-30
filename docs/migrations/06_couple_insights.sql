-- ============================================================================
-- RELATIONSHIP OS - 06_couple_insights
-- RUN THIS IN SUPABASE SQL EDITOR
-- Stores AI-generated comparative insights for couples
-- ============================================================================

CREATE TABLE IF NOT EXISTS couple_insights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  insight_type TEXT NOT NULL CHECK (insight_type IN ('comparative_summary', 'dimension_insight', 'action_item')),
  dimension_slug TEXT, -- null for overall summaries
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  metadata JSONB DEFAULT '{}'::jsonb, -- scores, alignment level, etc.
  generated_by TEXT DEFAULT 'gemini-2.5-flash',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE couple_insights ENABLE ROW LEVEL SECURITY;

-- Couple members can view their insights
CREATE POLICY "couple_insights_select" ON couple_insights FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- Index for fast couple lookups
CREATE INDEX IF NOT EXISTS idx_couple_insights_couple ON couple_insights(couple_id);
