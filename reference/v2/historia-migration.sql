-- ============================================================
-- MIGRATION: Phase 2 - Nuestra Historia
-- Run in Supabase SQL Editor
-- ============================================================

-- 1. Create Core Memory Timeline Table
CREATE TABLE IF NOT EXISTS historia_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  content_type TEXT NOT NULL CHECK (content_type IN ('text', 'photo', 'voice', 'conocernos_reveal', 'system_milestone')),
  media_url TEXT,
  dimension TEXT CHECK (dimension IN ('conexion', 'cuidado', 'choque', 'camino', 'general', null)),
  metadata JSONB, -- For extra dynamic data like the attached conocernos answers
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for timeline fetching
CREATE INDEX idx_historia_timeline ON historia_entries(couple_id, occurred_at DESC);

-- 2. Create Surfaces Table (for tracking when memories are resurfaced in the feed)
CREATE TABLE IF NOT EXISTS historia_surfaces (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  entry_id UUID NOT NULL REFERENCES historia_entries(id) ON DELETE CASCADE,
  surfaced_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  surface_context TEXT -- e.g. "anniversary", "low_connection_boost"
);

-- Index for preventing over-surfacing
CREATE INDEX idx_historia_surfaces_couple ON historia_surfaces(couple_id, surfaced_at DESC);

-- 3. Enable RLS
ALTER TABLE historia_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE historia_surfaces ENABLE ROW LEVEL SECURITY;

-- 4. Policies
CREATE POLICY "Users can view their couple's history"
ON historia_entries FOR SELECT USING (
  couple_id IN (
    SELECT couple_id FROM couple_members WHERE user_id = auth.uid()
  )
);

CREATE POLICY "Users can insert to their couple's history"
ON historia_entries FOR INSERT WITH CHECK (
  couple_id IN (
    SELECT couple_id FROM couple_members WHERE user_id = auth.uid()
  )
);

CREATE POLICY "Users can update their couple's history"
ON historia_entries FOR UPDATE USING (
  couple_id IN (
    SELECT couple_id FROM couple_members WHERE user_id = auth.uid()
  )
);

CREATE POLICY "Users can delete their couple's history"
ON historia_entries FOR DELETE USING (
  couple_id IN (
    SELECT couple_id FROM couple_members WHERE user_id = auth.uid()
  )
);

-- Same for surfaces
CREATE POLICY "Users can view surfaces"
ON historia_surfaces FOR SELECT USING (
  couple_id IN (
    SELECT couple_id FROM couple_members WHERE user_id = auth.uid()
  )
);

CREATE POLICY "System can insert surfaces"
ON historia_surfaces FOR ALL USING (true) WITH CHECK (true);
