-- ============================================================
-- 13. SINTONÍA LIVE — REAL-TIME DILEMMAS
-- ============================================================

-- Dilemma bank
CREATE TABLE sintonia_dilemmas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scenario TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('moral','practico','emocional','financiero','social','aventura','general')),
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Game session
CREATE TABLE sintonia_games (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  total_rounds INTEGER NOT NULL DEFAULT 5,
  match_count INTEGER DEFAULT 0,
  score_pct NUMERIC,
  status TEXT DEFAULT 'playing' CHECK (status IN ('playing', 'finished', 'abandoned')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  finished_at TIMESTAMPTZ
);

-- Round results
CREATE TABLE sintonia_game_rounds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id UUID NOT NULL REFERENCES sintonia_games(id) ON DELETE CASCADE,
  dilemma_id UUID NOT NULL REFERENCES sintonia_dilemmas(id),
  round_number INTEGER NOT NULL,
  user_a_id UUID NOT NULL REFERENCES auth.users(id),
  user_b_id UUID NOT NULL REFERENCES auth.users(id),
  user_a_vote CHAR(1) CHECK (user_a_vote IN ('A', 'B')),
  user_b_vote CHAR(1) CHECK (user_b_vote IN ('A', 'B')),
  is_match BOOLEAN,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE sintonia_dilemmas ENABLE ROW LEVEL SECURITY;
ALTER TABLE sintonia_games ENABLE ROW LEVEL SECURITY;
ALTER TABLE sintonia_game_rounds ENABLE ROW LEVEL SECURITY;

-- Dilemmas: read-only for authenticated
CREATE POLICY "sintonia_dilemmas_read" ON sintonia_dilemmas FOR SELECT TO authenticated
  USING (active = TRUE);

-- Games: via couple membership
CREATE POLICY "sintonia_games_select" ON sintonia_games FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "sintonia_games_insert" ON sintonia_games FOR INSERT TO authenticated
  WITH CHECK (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "sintonia_games_update" ON sintonia_games FOR UPDATE TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- Rounds: via game ownership
CREATE POLICY "sintonia_rounds_select" ON sintonia_game_rounds FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM sintonia_games g
    JOIN couple_members cm ON cm.couple_id = g.couple_id
    WHERE g.id = game_id AND cm.user_id = auth.uid()
  ));
CREATE POLICY "sintonia_rounds_insert" ON sintonia_game_rounds FOR INSERT TO authenticated
  WITH CHECK (EXISTS (
    SELECT 1 FROM sintonia_games g
    JOIN couple_members cm ON cm.couple_id = g.couple_id
    WHERE g.id = game_id AND cm.user_id = auth.uid()
  ));

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_sintonia_dilemmas_category ON sintonia_dilemmas(category, active);
CREATE INDEX idx_sintonia_games_couple ON sintonia_games(couple_id);
CREATE INDEX idx_sintonia_games_status ON sintonia_games(couple_id, status);
CREATE INDEX idx_sintonia_rounds_game ON sintonia_game_rounds(game_id);
CREATE INDEX idx_sintonia_rounds_number ON sintonia_game_rounds(game_id, round_number);
