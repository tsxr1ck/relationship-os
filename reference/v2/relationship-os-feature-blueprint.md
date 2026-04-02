# Relationship OS — Feature Blueprint
## Conocernos, ¿Me conoces?, Nuestra Historia & Quizzes Upgrade

**Version:** 1.0  
**Date:** March 2026  
**Author:** Clave Studio  
**Stack:** Next.js (App Router) · TypeScript · Supabase · Gemini AI · Tailwind CSS

---

## Table of Contents

1. [Overview & Philosophy](#1-overview--philosophy)
2. [Feature 1 — Conocernos (Daily Question Game)](#2-feature-1--conocernos-daily-question-game)
3. [Feature 2 — ¿Me conoces? (Guessing Game)](#3-feature-2--me-conoces-guessing-game)
4. [Feature 3 — Nuestra Historia (Memory Vault)](#4-feature-3--nuestra-historia-memory-vault)
5. [Feature 4 — Quizzes Upgrade (Favoritos)](#5-feature-4--quizzes-upgrade-favoritos)
6. [Database Schema (Full SQL)](#6-database-schema-full-sql)
7. [Navigation & Integration](#7-navigation--integration)
8. [Implementation Order](#8-implementation-order)

---

## 1. Overview & Philosophy

These four features share a single design principle: **make discovery feel like play, not work.** The goal is not more data or more AI analysis — the goal is more moments where Ricardo and Melanie learn something new about each other and feel closer because of it.

Each feature maps to an existing gap in the current product:

| Gap | Feature |
|---|---|
| No daily retention hook | Conocernos |
| No playful interaction between partners | ¿Me conoces? |
| No shared memory or history | Nuestra Historia |
| Quizzes feel like assessments, not games | Quizzes Upgrade |

All features integrate with the existing **4C framework** (Conexión, Cuidado, Choque, Camino) and feed back into the couple's profile over time.

---

## 2. Feature 1 — Conocernos (Daily Question Game)

### 2.1 Concept

Every day, both partners receive the **same question** privately. Each answers on their own without seeing the other's response. At a fixed reveal time (default: 8:00 PM couple's timezone), both answers are shown side by side. No scoring. No AI analysis. Just discovery and a natural conversation starter.

This is the **primary daily retention hook** for the app.

### 2.2 User Flow

```
[Morning notification] → "La pregunta del día está lista"
         ↓
[User opens app] → Conocernos card appears on Dashboard
         ↓
[User reads question] → Writes private answer → Submits
         ↓
[Before reveal time] → "Tu respuesta está guardada. Melanie aún no ha respondido." 
   OR → "Melanie ya respondió. Las respuestas se revelan a las 8pm."
         ↓
[After reveal time] → Both answers shown side by side
         ↓
[Optional] → React with an emoji · Leave a comment
```

### 2.3 Question Structure

Questions are pre-seeded in the database and tagged by **4C dimension** and **tone**. Tones are:

- `light` — fun, easy, low-stakes (e.g., "¿Cuál sería tu cena perfecta hoy?")
- `reflective` — slightly deeper (e.g., "¿Qué momento de esta semana no quisieras olvidar?")
- `visionary` — future-oriented (e.g., "¿A dónde te gustaría viajar antes de los 40?")
- `playful` — absurd or fun (e.g., "Si fueras un personaje de película, ¿cuál serías?")

The system rotates through questions ensuring no repeat within 90 days per couple. Gemini can optionally generate new questions weekly to supplement the bank.

### 2.4 Reveal Logic

- Reveal time is configurable per couple (stored in `couples` table extension).
- Before both partners answer: show only "Tu respuesta está guardada."
- Once both answered AND reveal time passed: show both answers.
- If only one partner answered by reveal time: show that answer, mark the other as "no respondió hoy."
- Questions expire at midnight. A new one is assigned daily via a scheduled function or on-demand when the user opens the app.

### 2.5 Reactions & Comments

After reveal, each partner can:
- React with one emoji (❤️ 😲 😂 🥹 🤔)
- Leave a short comment (max 280 characters)
- Save the exchange to **Nuestra Historia** with one tap

### 2.6 4C Integration

Each question is tagged to a dimension. Over time, the system tracks which dimensions produce the most "surprised" reactions (emoji 😲) and surfaces that as insight: *"Parece que Cuidado es donde más se sorprenden el uno al otro."*

### 2.7 Database Tables

```sql
-- Question bank for Conocernos
CREATE TABLE conocernos_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_text TEXT NOT NULL,
  dimension TEXT NOT NULL CHECK (dimension IN ('conexion','cuidado','choque','camino','general')),
  tone TEXT NOT NULL CHECK (tone IN ('light','reflective','visionary','playful')),
  author TEXT DEFAULT 'seed', -- 'seed' | 'gemini'
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Daily question assignment per couple
CREATE TABLE conocernos_daily (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES conocernos_questions(id),
  question_date DATE NOT NULL DEFAULT CURRENT_DATE,
  reveal_at TIMESTAMPTZ NOT NULL, -- computed from couple's reveal_time setting
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(couple_id, question_date)
);

-- Individual answers (private until reveal)
CREATE TABLE conocernos_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  daily_id UUID NOT NULL REFERENCES conocernos_daily(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  answer_text TEXT NOT NULL,
  answered_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(daily_id, user_id)
);

-- Reactions and comments after reveal
CREATE TABLE conocernos_reactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  daily_id UUID NOT NULL REFERENCES conocernos_daily(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  target_user_id UUID NOT NULL REFERENCES auth.users(id), -- whose answer they reacted to
  emoji TEXT, -- one of: ❤️ 😲 😂 🥹 🤔
  comment TEXT CHECK (char_length(comment) <= 280),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(daily_id, user_id, target_user_id)
);
```

### 2.8 Seed Questions (Minimum 60)

Seed at least 60 questions across all tones and dimensions before launch. Examples:

**Light / General**
- ¿Cuál sería tu cena perfecta esta noche?
- ¿Qué canción te describe esta semana?
- ¿Qué harías si tuvieras un día completamente para ti?
- ¿Cuál es tu lugar favorito en el mundo hasta ahora?
- ¿Qué película podrías ver en bucle sin cansarte?

**Reflective / Conexión**
- ¿Qué momento de esta semana no quisieras olvidar?
- ¿Qué es algo que te cuesta trabajo pedir, aunque lo necesitas?
- ¿Qué te hace sentir más visto/a?

**Visionary / Camino**
- ¿A dónde te gustaría viajar antes de los 40?
- ¿Cómo imaginas un martes cualquiera en 10 años?
- ¿Qué proyecto personal tienes guardado en la cabeza?

**Playful / General**
- ¿Cuál sería tu superpoder ideal?
- Si fueras un personaje de serie, ¿quién serías?
- ¿Cuál es tu orden de tacos perfecta?

### 2.9 Server Actions Required

```
getOrCreateDailyQuestion(coupleId)   → returns today's daily record
submitKnowAnswer(dailyId, text)      → saves private answer
getDailyReveal(dailyId)              → returns both answers if reveal time passed
reactToAnswer(dailyId, emoji, comment, targetUserId)
saveToHistory(dailyId)               → copies to nuestra_historia
```

### 2.10 UI Components Required

- `ConocenosCard` — dashboard widget showing today's question status
- `ConocenosAnswerPage` — full-screen answer input
- `ConocenosRevealPage` — side-by-side reveal with reactions
- `ConocenosHistoryPage` — list of past exchanges

---

## 3. Feature 2 — ¿Me conoces? (Guessing Game)

### 3.1 Concept

A turn-based game where one partner answers a question about themselves and the other partner **guesses** what their answer was. Points are awarded for accuracy. The app tracks knowledge scores per 4C dimension over time, turning "I don't know her well enough" into a measurable and improvable metric.

This is the **most interactive and gamified** feature in the roadmap.

### 3.2 User Flow

```
[Partner A initiates a round]
         ↓
[Partner A answers 5 questions about themselves privately]
         ↓
[Partner B receives notification: "Ricardo te lanzó un reto — ¿cuánto me conoces?"]
         ↓
[Partner B guesses Partner A's answers]
         ↓
[Results revealed: score, correct answers, Partner A's real answers]
         ↓
[Both see the Knowledge Score update per dimension]
         ↓
[Optional: Partner B initiates a reverse round]
```

### 3.3 Scoring

- **Exact match** on open text (fuzzy match via simple comparison): 3 points
- **Close match** on scale questions (within 1 point): 2 points
- **Wrong**: 0 points
- Max score per round: 15 points (5 questions × 3 points)
- Percentage score stored as `knowledge_score` per dimension per couple

For open-text questions, use **Gemini** to judge similarity (e.g., "pollo asado" vs "una cena con pollo" = close match). Keep the prompt simple and deterministic.

### 3.4 Question Types for This Game

Questions must be answerable **about yourself** in a concrete way:

- Scale questions: "Del 1 al 5, ¿qué tan seguido necesitas tiempo solo para recargar energía?"
- Multiple choice: "Cuando estoy estresado/a, yo: (a) hablo con alguien (b) me aíslo (c) hago ejercicio (d) como algo rico"
- Short text: "¿Cuál es mi mayor miedo irracional?"
- Ranking: "Ordena estos de más a menos importante para mí: familia, trabajo, salud, dinero, diversión"

All questions are **tagged to a 4C dimension** so the knowledge score per dimension is meaningful.

### 3.5 Knowledge Score Tracking

The knowledge score is a **rolling average** of last 10 rounds per dimension per couple. Displayed in Nosotros and Descubrir as a secondary metric alongside the 4C health scores.

Example display:
```
¿Cuánto se conocen?
Conexión  ████████░░ 78%
Cuidado   █████░░░░░ 52%   ← Oportunidad
Choque    ███████░░░ 68%
Camino    █████████░ 89%
```

### 3.6 Database Tables

```sql
-- Question bank specifically for guessing game
CREATE TABLE meconoces_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_text TEXT NOT NULL,         -- "¿Cuál es mi mayor miedo irracional?"
  answer_prompt TEXT NOT NULL,         -- What the answerer sees: "¿Cuál es tu mayor miedo irracional?"
  question_type TEXT NOT NULL CHECK (question_type IN ('LIKERT-5','MULTIPLE_CHOICE','SHORT_TEXT','RANK')),
  dimension TEXT NOT NULL CHECK (dimension IN ('conexion','cuidado','choque','camino','general')),
  options JSONB,                        -- for MULTIPLE_CHOICE and RANK types
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- A single game round (5 questions)
CREATE TABLE meconoces_rounds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  answerer_id UUID NOT NULL REFERENCES auth.users(id),   -- who answered about themselves
  guesser_id UUID NOT NULL REFERENCES auth.users(id),    -- who is guessing
  status TEXT DEFAULT 'pending_answers' CHECK (
    status IN ('pending_answers','pending_guesses','completed')
  ),
  score INTEGER,                        -- total score out of 15
  score_pct NUMERIC,                    -- percentage
  dimension_scores JSONB DEFAULT '{}', -- { conexion: 80, cuidado: 60 ... }
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
  real_answer JSONB,                    -- answerer's actual answer (hidden until complete)
  guessed_answer JSONB,                 -- guesser's guess
  points_awarded INTEGER DEFAULT 0,
  match_level TEXT CHECK (match_level IN ('exact','close','wrong')),
  ai_judgment TEXT,                     -- Gemini's reasoning for open text matches
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Cumulative knowledge score per couple per dimension
CREATE TABLE meconoces_scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  dimension TEXT NOT NULL,
  about_user_id UUID NOT NULL REFERENCES auth.users(id),   -- whose answers were being guessed
  guesser_id UUID NOT NULL REFERENCES auth.users(id),
  knowledge_score NUMERIC NOT NULL,    -- 0-100 rolling average
  rounds_played INTEGER DEFAULT 0,
  last_played TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(couple_id, dimension, about_user_id, guesser_id)
);
```

### 3.7 Server Actions Required

```
startMeConocesRound(coupleId, answererId, guesserId)
submitRoundAnswers(roundId, answers[])          → answerer submits their real answers
submitRoundGuesses(roundId, guesses[])          → guesser submits their guesses
scoreRound(roundId)                             → calculates scores, updates meconoces_scores
getMeConocesScores(coupleId)                    → returns knowledge scores per dimension
getActiveRound(coupleId)                        → returns any pending round
```

### 3.8 Gemini Integration for Open Text Scoring

When `question_type = 'SHORT_TEXT'`, after both answers and guesses are submitted, call Gemini with a simple prompt:

```
Given that the real answer is: "[real_answer]"
And the guess was: "[guessed_answer]"
Are these the same, similar, or different?
Respond with JSON: { "match": "exact" | "close" | "wrong", "reason": "one sentence" }
```

Cache the result in `meconoces_entries.ai_judgment`.

### 3.9 UI Components Required

- `MeConocesCard` — dashboard widget showing active round or invite to play
- `RoundAnswerPage` — answerer fills in their real answers privately
- `RoundGuessPage` — guesser tries to match each answer
- `RoundResultsPage` — reveal with score, correct vs guessed, celebration animation
- `KnowledgeScoreWidget` — embeddable in Nosotros and Descubrir

---

## 4. Feature 3 — Nuestra Historia (Memory Vault)

### 4.1 Concept

A shared, chronological space where the couple logs memories, inside jokes, firsts, and important moments. Both partners can add entries. The AI periodically surfaces old memories on the dashboard to create moments of nostalgia. Over time this becomes the couple's private digital journal.

### 4.2 Memory Types

| Type | Example |
|---|---|
| `memory` | "Vimos la lluvia desde el café en Mazatlán" |
| `first` | "Primera vez que cocinamos juntos" |
| `inside_joke` | "Lo del pollo" |
| `milestone` | "Nos mudamos juntos" |
| `gratitude` | "Hoy me cuidó cuando estaba enfermo/a" |

### 4.3 Entry Structure

Each memory entry contains:
- **Title** — short label (required, max 80 chars)
- **Description** — longer text (optional, max 500 chars)
- **Date** — when it happened (defaults to today, editable)
- **Type** — one of the types above
- **4C Tag** — which dimension it relates to (optional, user selects or AI suggests)
- **Photo** — optional image upload (Supabase Storage)
- **Emoji** — one emoji to represent it (optional)
- **Private flag** — if true, only the entry creator can see it

### 4.4 AI Surface Logic

Gemini periodically (weekly) scans the couple's history and picks 1-2 memories to surface on the dashboard with a warm framing:

- "Hace exactamente 3 meses anotaron: *[memory]*. ¿Cómo recuerdan ese momento?"
- "Este día del año pasado tuvieron su primer [milestone]. ¿Qué ha cambiado desde entonces?"

Surface these as a card on the main dashboard. This is a **read-only AI observation**, not an interactive element — just a moment of warmth.

### 4.5 Saving from Other Features

Both **Conocernos** and **¿Me conoces?** have a "Guardar en nuestra historia" button after reveal. This auto-creates a `memory` type entry with:
- Title: the question text
- Description: both answers side by side
- Type: `memory`
- 4C tag: inherited from the question's dimension

### 4.6 Database Tables

```sql
-- Main memory vault
CREATE TABLE historia_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  created_by UUID NOT NULL REFERENCES auth.users(id),
  title TEXT NOT NULL CHECK (char_length(title) <= 80),
  description TEXT CHECK (char_length(description) <= 500),
  entry_date DATE NOT NULL DEFAULT CURRENT_DATE,
  entry_type TEXT NOT NULL CHECK (
    entry_type IN ('memory','first','inside_joke','milestone','gratitude')
  ),
  dimension TEXT CHECK (dimension IN ('conexion','cuidado','choque','camino','general')),
  emoji TEXT,
  photo_url TEXT,
  is_private BOOLEAN DEFAULT FALSE,
  source TEXT DEFAULT 'manual' CHECK (source IN ('manual','conocernos','meconoces','system')),
  source_ref_id UUID,                  -- optional FK to the source record
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- AI surfaced memories (to avoid repeating the same memory)
CREATE TABLE historia_surfaces (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  entry_id UUID NOT NULL REFERENCES historia_entries(id) ON DELETE CASCADE,
  surface_date DATE NOT NULL DEFAULT CURRENT_DATE,
  surface_text TEXT NOT NULL,          -- the AI-written framing sentence
  dismissed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(couple_id, entry_id, surface_date)
);
```

### 4.7 Server Actions Required

```
createHistoriaEntry(coupleId, payload)
updateHistoriaEntry(entryId, payload)
deleteHistoriaEntry(entryId)
getHistoriaEntries(coupleId, filters?)    → paginated, filterable by type/dimension
getSurfacedMemory(coupleId)               → returns today's AI surface or generates one
dismissSurface(surfaceId)
uploadHistoriaPhoto(formData)             → Supabase Storage upload
```

### 4.8 Gemini Integration for Surface Text

Once per week (or on-demand when the dashboard loads and no surface exists for today):

```
Given this couple has this memory from [date]:
Title: [title]
Description: [description]

Write a warm, 1-sentence surfacing message in Spanish that makes them want to 
revisit this moment. Reference how long ago it was. Keep it under 100 characters.
Example: "Hace 3 meses anotaron esto — ¿siguen sintiéndolo igual?"
```

### 4.9 UI Components Required

- `HistoriaDashboardCard` — dashboard widget showing today's surfaced memory
- `HistoriaPage` — full vault with chronological timeline, filter by type
- `HistoriaEntryCard` — individual memory card in the timeline
- `AddMemorySheet` — bottom sheet / modal to add a new entry
- `HistoriaEntryDetail` — full detail view with photo

---

## 5. Feature 4 — Quizzes Upgrade (Favoritos)

### 5.1 Concept

Add a **Favoritos** pre-built quiz category alongside the existing custom topic system. These are lighter, faster quizzes that feel like a game night activity — not a psychological assessment. Lower friction, more fun, designed to be done together in real time.

### 5.2 Favoritos Categories

| Category | Description | Example Questions |
|---|---|---|
| 🍕 Gustos | Food, music, movies, comfort | "¿Cuál es mi comfort food favorito?" |
| 🌍 Sueños | Travel, bucket list, ambitions | "¿A dónde iríamos si pudiéramos ir mañana?" |
| 🏠 Hogar | Lifestyle, routines, home | "¿Cuál es mi parte favorita de nuestra casa?" |
| 😄 Humor | Fun, absurd, playful | "¿Cuál es la cosa más tonta que me da miedo?" |
| 💭 Mente | Thoughts, values, beliefs | "¿Qué opinión mía te sorprendió cuando la descubriste?" |
| 💛 Nosotros | Relationship-specific | "¿Cuál es tu recuerdo favorito de nuestro primer año?" |

### 5.3 Changes to Existing Quiz System

**Add to the Quizzes page:**

1. A **"Favoritos" tab** alongside "Idea Propia" and "Inspiración de la IA"
2. Pre-built category cards (the 6 above) — tapping one launches a pre-seeded quiz immediately without AI generation wait time
3. **Real-time mode option** — a toggle that makes the quiz feel synchronous. Both partners answer simultaneously and see results in real time, like playing a game together at the table.

**Real-time mode flow:**
```
[Partner A starts Favoritos quiz] → shareable session link generated
[Partner B joins via notification or link]
[Both see the same question at the same time]
[Both answer simultaneously — 30-second timer optional]
[Results revealed together]
[Next question auto-advances]
```

### 5.4 Database Changes

```sql
-- Pre-built Favoritos question bank
CREATE TABLE favoritos_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category TEXT NOT NULL CHECK (
    category IN ('gustos','sueños','hogar','humor','mente','nosotros')
  ),
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL CHECK (question_type IN ('OPEN','MULTIPLE_CHOICE','RANK')),
  options JSONB,                        -- for MULTIPLE_CHOICE
  dimension TEXT CHECK (dimension IN ('conexion','cuidado','choque','camino','general')),
  difficulty TEXT DEFAULT 'light' CHECK (difficulty IN ('light','medium')),
  active BOOLEAN DEFAULT TRUE,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add real_time_mode and category fields to custom_evaluations
ALTER TABLE custom_evaluations 
  ADD COLUMN IF NOT EXISTS is_realtime BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS favoritos_category TEXT,
  ADD COLUMN IF NOT EXISTS realtime_session_code TEXT,
  ADD COLUMN IF NOT EXISTS realtime_status TEXT DEFAULT 'waiting' 
    CHECK (realtime_status IN ('waiting','active','completed'));

-- Real-time session state (for synchronous play)
CREATE TABLE favoritos_realtime_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  evaluation_id UUID NOT NULL REFERENCES custom_evaluations(id) ON DELETE CASCADE,
  couple_id UUID NOT NULL REFERENCES couples(id),
  current_question_index INTEGER DEFAULT 0,
  status TEXT DEFAULT 'waiting' CHECK (status IN ('waiting','active','completed')),
  both_joined BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 5.5 Seed Questions (Minimum 10 per category = 60 total)

**Gustos (examples)**
- ¿Cuál es mi comfort food favorito?
- ¿Qué género de música me pone de buenas instantáneamente?
- ¿Cuál es la película que más veces he visto?
- Si pudiera comer solo una cosa por el resto de mi vida, ¿qué sería?
- ¿Cuál es mi bebida favorita en un día frío?

**Sueños (examples)**
- ¿A dónde viajaría si pudiera ir mañana?
- ¿Qué haría si me ganara la lotería esta semana?
- ¿Cuál es algo que quiero aprender antes de los 50?
- ¿Cómo sería mi día perfecto de vacaciones?
- ¿Cuál es el lugar del mundo que más curiosidad me da?

**Nosotros (examples)**
- ¿Cuál es tu recuerdo favorito de nuestro primer año?
- ¿Qué fue lo primero que te gustó de mí?
- ¿Cuál es la tradición nuestra que más valoras?
- ¿Qué es algo que hacemos juntos que nunca quisieras dejar de hacer?
- ¿Cuál fue la primera vez que pensaste "esta persona es especial"?

### 5.6 Server Actions Required

```
getFavoritosCategories()                        → returns 6 category cards
createFavoritosQuiz(coupleId, category)         → creates evaluation from seed bank
joinRealtimeSession(evaluationId, userId)       → marks user as joined
advanceRealtimeQuestion(sessionId)              → moves to next question
getRealtimeState(sessionId)                     → returns current question + answers
```

---

## 6. Database Schema (Full SQL)

Run these migrations in order in Supabase SQL Editor. All tables use RLS.

```sql
-- ============================================================
-- MIGRATION: Conocernos, ¿Me conoces?, Nuestra Historia, Favoritos
-- ============================================================

-- 1. CONOCERNOS
-- ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS conocernos_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_text TEXT NOT NULL,
  dimension TEXT NOT NULL DEFAULT 'general' 
    CHECK (dimension IN ('conexion','cuidado','choque','camino','general')),
  tone TEXT NOT NULL DEFAULT 'light'
    CHECK (tone IN ('light','reflective','visionary','playful')),
  author TEXT DEFAULT 'seed',
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS conocernos_daily (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES conocernos_questions(id),
  question_date DATE NOT NULL DEFAULT CURRENT_DATE,
  reveal_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(couple_id, question_date)
);

CREATE TABLE IF NOT EXISTS conocernos_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  daily_id UUID NOT NULL REFERENCES conocernos_daily(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  answer_text TEXT NOT NULL,
  answered_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(daily_id, user_id)
);

CREATE TABLE IF NOT EXISTS conocernos_reactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  daily_id UUID NOT NULL REFERENCES conocernos_daily(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  target_user_id UUID NOT NULL REFERENCES auth.users(id),
  emoji TEXT,
  comment TEXT CHECK (char_length(comment) <= 280),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(daily_id, user_id, target_user_id)
);

-- 2. ¿ME CONOCES?
-- ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS meconoces_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_text TEXT NOT NULL,
  answer_prompt TEXT NOT NULL,
  question_type TEXT NOT NULL 
    CHECK (question_type IN ('LIKERT-5','MULTIPLE_CHOICE','SHORT_TEXT','RANK')),
  dimension TEXT NOT NULL DEFAULT 'general'
    CHECK (dimension IN ('conexion','cuidado','choque','camino','general')),
  options JSONB,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS meconoces_rounds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  answerer_id UUID NOT NULL REFERENCES auth.users(id),
  guesser_id UUID NOT NULL REFERENCES auth.users(id),
  status TEXT DEFAULT 'pending_answers' 
    CHECK (status IN ('pending_answers','pending_guesses','completed')),
  score INTEGER,
  score_pct NUMERIC,
  dimension_scores JSONB DEFAULT '{}',
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS meconoces_entries (
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

CREATE TABLE IF NOT EXISTS meconoces_scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  dimension TEXT NOT NULL,
  about_user_id UUID NOT NULL REFERENCES auth.users(id),
  guesser_id UUID NOT NULL REFERENCES auth.users(id),
  knowledge_score NUMERIC NOT NULL,
  rounds_played INTEGER DEFAULT 0,
  last_played TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(couple_id, dimension, about_user_id, guesser_id)
);

-- 3. NUESTRA HISTORIA
-- ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS historia_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  created_by UUID NOT NULL REFERENCES auth.users(id),
  title TEXT NOT NULL CHECK (char_length(title) <= 80),
  description TEXT CHECK (char_length(description) <= 500),
  entry_date DATE NOT NULL DEFAULT CURRENT_DATE,
  entry_type TEXT NOT NULL 
    CHECK (entry_type IN ('memory','first','inside_joke','milestone','gratitude')),
  dimension TEXT CHECK (dimension IN ('conexion','cuidado','choque','camino','general')),
  emoji TEXT,
  photo_url TEXT,
  is_private BOOLEAN DEFAULT FALSE,
  source TEXT DEFAULT 'manual' 
    CHECK (source IN ('manual','conocernos','meconoces','system')),
  source_ref_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS historia_surfaces (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  entry_id UUID NOT NULL REFERENCES historia_entries(id) ON DELETE CASCADE,
  surface_date DATE NOT NULL DEFAULT CURRENT_DATE,
  surface_text TEXT NOT NULL,
  dismissed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(couple_id, entry_id, surface_date)
);

-- 4. FAVORITOS (Quizzes Upgrade)
-- ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS favoritos_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category TEXT NOT NULL 
    CHECK (category IN ('gustos','sueños','hogar','humor','mente','nosotros')),
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL 
    CHECK (question_type IN ('OPEN','MULTIPLE_CHOICE','RANK')),
  options JSONB,
  dimension TEXT CHECK (dimension IN ('conexion','cuidado','choque','camino','general')),
  difficulty TEXT DEFAULT 'light' CHECK (difficulty IN ('light','medium')),
  active BOOLEAN DEFAULT TRUE,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE custom_evaluations 
  ADD COLUMN IF NOT EXISTS is_realtime BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS favoritos_category TEXT,
  ADD COLUMN IF NOT EXISTS realtime_session_code TEXT,
  ADD COLUMN IF NOT EXISTS realtime_status TEXT DEFAULT 'waiting'
    CHECK (realtime_status IN ('waiting','active','completed'));

CREATE TABLE IF NOT EXISTS favoritos_realtime_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  evaluation_id UUID NOT NULL REFERENCES custom_evaluations(id) ON DELETE CASCADE,
  couple_id UUID NOT NULL REFERENCES couples(id),
  current_question_index INTEGER DEFAULT 0,
  status TEXT DEFAULT 'waiting' 
    CHECK (status IN ('waiting','active','completed')),
  both_joined BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─────────────────────────────────────────────────────────────
-- RLS POLICIES
-- ─────────────────────────────────────────────────────────────

-- Conocernos
ALTER TABLE conocernos_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE conocernos_daily ENABLE ROW LEVEL SECURITY;
ALTER TABLE conocernos_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE conocernos_reactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "conocernos_questions_read" ON conocernos_questions 
  FOR SELECT TO authenticated USING (TRUE);

CREATE POLICY "conocernos_daily_read" ON conocernos_daily 
  FOR SELECT TO authenticated 
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

CREATE POLICY "conocernos_daily_insert" ON conocernos_daily 
  FOR INSERT TO authenticated WITH CHECK (TRUE); -- managed by server action

CREATE POLICY "conocernos_answers_insert" ON conocernos_answers 
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

-- Answers are private until reveal — enforce in server action, not RLS
CREATE POLICY "conocernos_answers_read" ON conocernos_answers 
  FOR SELECT TO authenticated USING (user_id = auth.uid()); -- own answers always visible

CREATE POLICY "conocernos_reactions_all" ON conocernos_reactions 
  FOR ALL TO authenticated USING (user_id = auth.uid());

-- ¿Me conoces?
ALTER TABLE meconoces_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE meconoces_rounds ENABLE ROW LEVEL SECURITY;
ALTER TABLE meconoces_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE meconoces_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "meconoces_questions_read" ON meconoces_questions 
  FOR SELECT TO authenticated USING (TRUE);

CREATE POLICY "meconoces_rounds_select" ON meconoces_rounds 
  FOR SELECT TO authenticated 
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

CREATE POLICY "meconoces_rounds_insert" ON meconoces_rounds 
  FOR INSERT TO authenticated WITH CHECK (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
  );

CREATE POLICY "meconoces_entries_select" ON meconoces_entries 
  FOR SELECT TO authenticated 
  USING (round_id IN (
    SELECT id FROM meconoces_rounds 
    WHERE couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
  ));

CREATE POLICY "meconoces_scores_select" ON meconoces_scores 
  FOR SELECT TO authenticated 
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- Nuestra Historia
ALTER TABLE historia_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE historia_surfaces ENABLE ROW LEVEL SECURITY;

CREATE POLICY "historia_entries_select" ON historia_entries 
  FOR SELECT TO authenticated 
  USING (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
    AND (is_private = FALSE OR created_by = auth.uid())
  );

CREATE POLICY "historia_entries_insert" ON historia_entries 
  FOR INSERT TO authenticated WITH CHECK (
    couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
    AND created_by = auth.uid()
  );

CREATE POLICY "historia_entries_update" ON historia_entries 
  FOR UPDATE TO authenticated USING (created_by = auth.uid());

CREATE POLICY "historia_entries_delete" ON historia_entries 
  FOR DELETE TO authenticated USING (created_by = auth.uid());

CREATE POLICY "historia_surfaces_select" ON historia_surfaces 
  FOR SELECT TO authenticated 
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- Favoritos
ALTER TABLE favoritos_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE favoritos_realtime_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "favoritos_questions_read" ON favoritos_questions 
  FOR SELECT TO authenticated USING (TRUE);

CREATE POLICY "favoritos_realtime_select" ON favoritos_realtime_sessions 
  FOR SELECT TO authenticated 
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- INDEXES
-- ─────────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_conocernos_daily_couple_date 
  ON conocernos_daily(couple_id, question_date);
CREATE INDEX IF NOT EXISTS idx_conocernos_answers_daily 
  ON conocernos_answers(daily_id);
CREATE INDEX IF NOT EXISTS idx_meconoces_rounds_couple 
  ON meconoces_rounds(couple_id);
CREATE INDEX IF NOT EXISTS idx_meconoces_scores_couple 
  ON meconoces_scores(couple_id);
CREATE INDEX IF NOT EXISTS idx_historia_entries_couple_date 
  ON historia_entries(couple_id, entry_date DESC);
CREATE INDEX IF NOT EXISTS idx_historia_surfaces_couple_date 
  ON historia_surfaces(couple_id, surface_date DESC);
CREATE INDEX IF NOT EXISTS idx_favoritos_questions_category 
  ON favoritos_questions(category, active);
```

---

## 7. Navigation & Integration

### 7.1 New Nav Item: "Jugar"

Add a **"Jugar"** nav item that consolidates all interactive/game features:

```
Jugar
├── Conocernos        (daily question — primary entry point)
├── ¿Me conoces?     (guessing game)
├── Quizzes           (existing + Favoritos upgrade)
└── Nuestra Historia  (memory vault)
```

This replaces the standalone Quizzes nav item and adds everything under one playful umbrella. Icon suggestion: 🎮 or a custom dice/heart combination.

### 7.2 Dashboard Integration

Add the following widgets to the main dashboard, in priority order:

1. **Conocernos card** (highest priority — daily habit) — shows today's question, answer status, and reveal state
2. **Nuestra Historia surface** — "Hace X tiempo..." surfaced memory
3. **¿Me conoces? pending round** — if a round is waiting for the user, show it

These replace or supplement the existing "Sabías que" daily tip card.

### 7.3 Nosotros Integration

Add a **"¿Cuánto se conocen?"** section to the Nosotros page below the radar chart, showing the knowledge scores from ¿Me conoces? per dimension. This makes the game feel meaningful — it contributes to the relationship map.

---

## 8. Implementation Order

Build in this sequence to maximize impact and testability:

### Sprint 1 — Conocernos (Week 1-2)
**Why first:** Highest retention value, simplest to build, immediately usable.

- [ ] Run DB migration (conocernos tables)
- [ ] Seed 60+ questions in `conocernos_questions`
- [ ] Build `getOrCreateDailyQuestion` server action
- [ ] Build `submitAnswer` and `getDailyReveal` server actions
- [ ] Build `ConocenosCard` dashboard widget
- [ ] Build `ConocenosAnswerPage` 
- [ ] Build `ConocenosRevealPage` with reactions
- [ ] Add Conocernos card to main dashboard
- [ ] Test end-to-end with two accounts (Ricardo + Melanie)

### Sprint 2 — Nuestra Historia (Week 3)
**Why second:** Low complexity, high emotional value, creates foundation for AI surfacing.

- [ ] Run DB migration (historia tables)
- [ ] Build CRUD server actions for historia_entries
- [ ] Build `HistoriaPage` with timeline view
- [ ] Build `AddMemorySheet` bottom modal
- [ ] Add "Guardar en historia" button to Conocernos reveal
- [ ] Build `getSurfacedMemory` with Gemini
- [ ] Add surfaced memory card to dashboard

### Sprint 3 — Quizzes Upgrade / Favoritos (Week 4)
**Why third:** Builds on existing quiz infrastructure, low friction.

- [ ] Run DB migration (favoritos tables + custom_evaluations columns)
- [ ] Seed 60+ questions across 6 categories
- [ ] Add Favoritos tab to Quizzes page
- [ ] Build category selection UI
- [ ] Build `createFavoritosQuiz` server action (no AI wait — instant)
- [ ] Optional: build real-time session logic with Supabase Realtime

### Sprint 4 — ¿Me conoces? (Week 5-6)
**Why last:** Most complex, needs the question bank and game logic fully designed.

- [ ] Run DB migration (meconoces tables)
- [ ] Seed 30+ guessing questions across all dimensions
- [ ] Build round lifecycle server actions
- [ ] Build `RoundAnswerPage` and `RoundGuessPage`
- [ ] Build `RoundResultsPage` with score reveal and animation
- [ ] Integrate Gemini for open-text scoring
- [ ] Build `KnowledgeScoreWidget` and add to Nosotros
- [ ] Add ¿Me conoces? card to dashboard for pending rounds

---

## Appendix — File Structure

```
src/app/(dashboard)/dashboard/(protected)/
├── jugar/
│   ├── page.tsx                    ← Jugar hub page
│   ├── conocernos/
│   │   ├── page.tsx               ← Daily question + history list
│   │   ├── [dailyId]/
│   │   │   ├── answer/page.tsx    ← Answer input
│   │   │   └── reveal/page.tsx   ← Reveal + reactions
│   │   └── actions.ts
│   ├── meconoces/
│   │   ├── page.tsx               ← Active round or start new
│   │   ├── [roundId]/
│   │   │   ├── answer/page.tsx   ← Answerer flow
│   │   │   ├── guess/page.tsx    ← Guesser flow
│   │   │   └── results/page.tsx  ← Score reveal
│   │   └── actions.ts
│   └── historia/
│       ├── page.tsx               ← Timeline view
│       ├── [entryId]/page.tsx    ← Detail view
│       └── actions.ts

src/components/dashboard/
├── ConocenosCard.tsx              ← Dashboard widget
├── HistoriaSurfaceCard.tsx        ← Dashboard surfaced memory
├── MeConocesPendingCard.tsx       ← Dashboard pending round
└── KnowledgeScoreWidget.tsx       ← Nosotros integration
```

---

*Blueprint v1.0 — Clave Studio — March 2026*
*Ready for implementation. Start with Sprint 1.*
