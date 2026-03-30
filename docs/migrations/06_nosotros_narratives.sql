-- ============================================================================
-- MIGRATION 06: nosotros_narratives
-- Description: AI-generated relationship stories cached per couple
-- Run in: Supabase SQL Editor
-- ============================================================================

-- Table: nosotros_narratives
CREATE TABLE IF NOT EXISTS nosotros_narratives (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  narrative_type TEXT NOT NULL CHECK (narrative_type IN (
    'relationship_story',    -- Overall "Nuestra Historia" narrative
    'layer_summary',         -- Per-layer (conexion/cuidado/choque/camino) summary
    'growth_tip'             -- AI-generated actionable tip
  )),
  dimension_slug TEXT,       -- NULL for overall, filled for layer/dimension specific
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  metadata JSONB DEFAULT '{}',
  generated_by TEXT DEFAULT 'gemini-2.5-flash',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Unique constraint: one narrative per couple per type per dimension
CREATE UNIQUE INDEX IF NOT EXISTS nosotros_narratives_unique_idx
  ON nosotros_narratives (couple_id, narrative_type, COALESCE(dimension_slug, '__null__'));

-- ============================================================================
-- RLS Policies
-- ============================================================================

ALTER TABLE nosotros_narratives ENABLE ROW LEVEL SECURITY;

-- Couple members can read their narratives
CREATE POLICY "Couple members can view narratives"
ON nosotros_narratives FOR SELECT
USING (
  couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- Insert/update/delete via service role (server actions use admin client)
CREATE POLICY "Service role can insert narratives"
ON nosotros_narratives FOR INSERT
WITH CHECK (true);

CREATE POLICY "Service role can update narratives"
ON nosotros_narratives FOR UPDATE
USING (true);

CREATE POLICY "Service role can delete narratives"
ON nosotros_narratives FOR DELETE
USING (true);

-- ============================================================================
-- END OF MIGRATION 06
-- ============================================================================
