-- ============================================================
-- MIGRATION: Phase 3 - Favoritos & Quizzes
-- Run in Supabase SQL Editor
-- ============================================================

-- 1. Create Favoritos Questions Table
CREATE TABLE IF NOT EXISTS favoritos_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category TEXT NOT NULL CHECK (category IN ('comida', 'viajes', 'entretenimiento', 'intimidad', 'random', 'futuro')),
  question_text TEXT NOT NULL,
  options JSONB NOT NULL, -- Array of strings e.g. ["Opción A", "Opción B", "Opción C", "Opción D"]
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Create Realtime Sessions Table
CREATE TABLE IF NOT EXISTS favoritos_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  category TEXT NOT NULL,
  questions JSONB NOT NULL, -- Array of fetched question objects
  current_question_index INTEGER DEFAULT 0,
  user1_id UUID REFERENCES auth.users(id),
  user2_id UUID REFERENCES auth.users(id),
  answers JSONB DEFAULT '{}'::jsonb, -- Store answers as { "questionId": { "userId1": "answer", "userId2": "answer" } }
  status TEXT DEFAULT 'waiting' CHECK (status IN ('waiting', 'playing', 'completed', 'cancelled')),
  started_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for session polling
CREATE INDEX idx_favoritos_sessions ON favoritos_sessions(couple_id, status);

-- 3. Enable RLS
ALTER TABLE favoritos_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE favoritos_sessions ENABLE ROW LEVEL SECURITY;

-- 4. Policies
CREATE POLICY "Anyone can read active questions"
ON favoritos_questions FOR SELECT USING (active = true);

CREATE POLICY "Users can view their couple's sessions"
ON favoritos_sessions FOR SELECT USING (
  couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

CREATE POLICY "Users can create sessions for their couple"
ON favoritos_sessions FOR INSERT WITH CHECK (
  couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

CREATE POLICY "Users can update their couple's sessions"
ON favoritos_sessions FOR UPDATE USING (
  couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- ============================================================
-- SEED DATA (A sample of 12 questions across categories)
-- ============================================================
INSERT INTO favoritos_questions (category, question_text, options) VALUES
-- Comida
('comida', 'Si sólo pudieran comer de un país por el resto de su vida, ¿cuál sería?', '["Mexicana", "Italiana", "Japonesa", "Libanesa"]'),
('comida', '¿Cuál es el dulce que siempre desaparece primero en la casa?', '["Chocolate oscuro", "Gomitas", "Helado", "Galletas"]'),
('comida', '¿Qué comida asumen que al otro le encanta pero secretamente odia (o tolera)?', '["Atún", "Aceitunas", "Queso azul", "Cilantro"]'),
-- Viajes
('viajes', 'Si les regalaran los vuelos hoy, ¿a dónde se irían mañana?', '["Playa desierta", "Ciudad histórica europea", "Montaña/Cabaña", "Roadtrip sin destino"]'),
('viajes', '¿Cuál es su estilo de viaje?', '["Itinerario en Excel minuto a minuto", "Fluir con lo que pase", "Despertar tarde y turistear", "Tour gastronómico puro"]'),
-- Entretenimiento
('entretenimiento', '¿Qué serie podrían ver una y otra vez sin cansarse?', '["The Office / Friends", "Game of Thrones", "Breaking Bad", "Anime o Documentales"]'),
('entretenimiento', '¿Quién controla normalmente el Netflix en la TV de la sala?', '["Yo", "Mi pareja", "Es un debate democrático", "Quien llegue primero"]'),
-- Intimidad
('intimidad', '¿Cuál es el gesto físico favorito de ustedes en el sillón?', '["Pies entrelazados", "Cabeza en el regazo", "Abrazo de cucharita", "Sentados cerca pero sin tocarse"]'),
('intimidad', '¿Qué loción o perfume del otro les vuelve locos?', '["El de uso diario", "El de salir elegante", "El olor natural recién bañadx", "No usan perfume"]'),
-- Random
('random', 'Si hubiera un apocalipsis zombie, ¿qué rol tomaría cada quien?', '["Líder táctico", "El que busca comida", "El que construye armas", "El que muere primero"]'),
('random', '¿En qué tema tu pareja podría dar una conferencia TED de 1 hora sin prepararse?', '["Cultura Pop/Cine", "Su trabajo", "Un hobby raro", "Chismes familiares"]'),
-- Futuro
('futuro', '¿Cómo se imaginan en 10 años un domingo por la mañana?', '["Despertando tarde solos", "Con niños corriendo", "Paseando perros en un bosque", "Desayunando en otra ciudad"]');
