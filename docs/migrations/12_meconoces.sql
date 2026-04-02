-- ============================================================
-- 12. ME CONOCES — GUESSING GAME
-- ============================================================

-- Question bank for guessing game
CREATE TABLE meconoces_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_text TEXT NOT NULL,
  answer_prompt TEXT NOT NULL,
  question_type TEXT NOT NULL CHECK (question_type IN ('LIKERT-5','MULTIPLE_CHOICE','SHORT_TEXT','RANK')),
  dimension TEXT NOT NULL CHECK (dimension IN ('conexion','cuidado','choque','camino','general')),
  options JSONB,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- A single game round (5 questions)
CREATE TABLE meconoces_rounds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  answerer_id UUID NOT NULL REFERENCES auth.users(id),
  guesser_id UUID NOT NULL REFERENCES auth.users(id),
  status TEXT DEFAULT 'pending_answers' CHECK (
    status IN ('pending_answers','pending_guesses','completed')
  ),
  score INTEGER,
  score_pct NUMERIC,
  dimension_scores JSONB DEFAULT '{}',
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Individual question entries within a round
CREATE TABLE meconoces_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  round_id UUID NOT NULL REFERENCES meconoces_rounds(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES meconoces_questions(id),
  sort_order INTEGER NOT NULL,
  real_answer JSONB,
  guessed_answer JSONB,
  points_awarded INTEGER DEFAULT 0,
  match_level TEXT CHECK (match_level IN ('exact','close','wrong')),
  ai_judgment TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Cumulative knowledge score per couple per dimension
CREATE TABLE meconoces_scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  dimension TEXT NOT NULL,
  about_user_id UUID NOT NULL REFERENCES auth.users(id),
  guesser_id UUID NOT NULL REFERENCES auth.users(id),
  knowledge_score NUMERIC NOT NULL DEFAULT 0,
  rounds_played INTEGER DEFAULT 0,
  last_played TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(couple_id, dimension, about_user_id, guesser_id)
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE meconoces_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE meconoces_rounds ENABLE ROW LEVEL SECURITY;
ALTER TABLE meconoces_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE meconoces_scores ENABLE ROW LEVEL SECURITY;

-- Questions: read-only for all authenticated
CREATE POLICY "meconoces_questions_read" ON meconoces_questions FOR SELECT TO authenticated
  USING (active = TRUE);

-- Rounds: users can see rounds for their couples
CREATE POLICY "meconoces_rounds_select" ON meconoces_rounds FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "meconoces_rounds_insert" ON meconoces_rounds FOR INSERT TO authenticated
  WITH CHECK (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "meconoces_rounds_update" ON meconoces_rounds FOR UPDATE TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- Entries: via round ownership
CREATE POLICY "meconoces_entries_select" ON meconoces_entries FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM meconoces_rounds r
    JOIN couple_members cm ON cm.couple_id = r.couple_id
    WHERE r.id = round_id AND cm.user_id = auth.uid()
  ));
CREATE POLICY "meconoces_entries_insert" ON meconoces_entries FOR INSERT TO authenticated
  WITH CHECK (EXISTS (
    SELECT 1 FROM meconoces_rounds r
    JOIN couple_members cm ON cm.couple_id = r.couple_id
    WHERE r.id = round_id AND cm.user_id = auth.uid()
  ));
CREATE POLICY "meconoces_entries_update" ON meconoces_entries FOR UPDATE TO authenticated
  USING (EXISTS (
    SELECT 1 FROM meconoces_rounds r
    JOIN couple_members cm ON cm.couple_id = r.couple_id
    WHERE r.id = round_id AND cm.user_id = auth.uid()
  ));

-- Scores: via couple membership
CREATE POLICY "meconoces_scores_select" ON meconoces_scores FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
CREATE POLICY "meconoces_scores_upsert" ON meconoces_scores FOR ALL TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_meconoces_rounds_couple ON meconoces_rounds(couple_id);
CREATE INDEX idx_meconoces_rounds_status ON meconoces_rounds(couple_id, status);
CREATE INDEX idx_meconoces_rounds_answerer ON meconoces_rounds(answerer_id);
CREATE INDEX idx_meconoces_rounds_guesser ON meconoces_rounds(guesser_id);
CREATE INDEX idx_meconoces_entries_round ON meconoces_entries(round_id);
CREATE INDEX idx_meconoces_entries_question ON meconoces_entries(question_id);
CREATE INDEX idx_meconoces_scores_couple ON meconoces_scores(couple_id);
CREATE INDEX idx_meconoces_scores_pair ON meconoces_scores(couple_id, about_user_id, guesser_id);
CREATE INDEX idx_meconoces_questions_dimension ON meconoces_questions(dimension, active);
