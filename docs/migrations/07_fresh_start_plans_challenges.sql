-- ============================================================================
-- FRESH START: Reset weekly plans, challenges, and ALL AI-generated content
-- Run in: Supabase SQL Editor
-- ⚠️ This will DELETE all plan/challenge/AI data. Profiles, couples,
--    onboarding, assessments, and vectors are preserved.
-- ============================================================================

BEGIN;

-- ─────────────────────────────────────────────────────────────────────────────
-- Phase 1: Wipe generated data (FK-safe order)
-- ─────────────────────────────────────────────────────────────────────────────

-- 1a. Weekly plan items  (FK → weekly_plans, couples)
DELETE FROM weekly_plan_items;

-- 1b. Weekly plans  (FK → couples)
DELETE FROM weekly_plans;

-- 1c. Challenge assignments  (FK → weekly_challenges, couples)
DELETE FROM challenge_assignments;

-- 1d. Challenge catalog (we reseed below)
DELETE FROM weekly_challenges;

-- 1e. Nosotros narratives — relationship_story, layer_summary, growth_tip
--     (Cached AI from nosotros/actions.ts → generateNosotrosNarrative)
DELETE FROM nosotros_narratives;

-- 1f. Couple insights — comparative_summary, dimension_insight, action_item
--     (Cached AI from descubrir/actions.ts → generateAIInsights)
DELETE FROM couple_insights;

-- 1g. AI insights — dimension coaching, personal insights, reto coaching/tips
--     Covers ALL cached AI across:
--       • nosotros/actions.ts  → generateDimensionDeepDive  (dimension_slug = dim slug)
--       • descubrir/actions.ts → getPersonalInsights        (_summary, _practice, dim slugs)
--       • retos/actions.ts     → coaching (reto_coaching_*), tips (reto_tips_*),
--                                 reflections (reto_reflection_*)
DELETE FROM ai_insights;

-- 1h. AI audit log — token tracking for all Gemini calls
DELETE FROM ai_audit_log;


-- ─────────────────────────────────────────────────────────────────────────────
-- Phase 2: Seed fresh challenge catalog (12 retos, 3 per 4C layer)
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO weekly_challenges (slug, title, description, dimension, difficulty, duration_days) VALUES

  -- ── Conexión ──────────────────────────────────────────────
  ('conexion-sin-pantallas',
   '48 horas sin pantallas juntos',
   'Pasen 48 horas priorizando la presencia: sin redes sociales, sin TV de fondo. Solo ustedes. Conversen, cocinen, salgan a caminar.',
   'conexion', 'deep', 7),

  ('ritual-matutino',
   'Crea un ritual matutino de pareja',
   'Durante 7 días, empiecen el día con un pequeño ritual juntos: café, un abrazo de 20 segundos, o compartir una intención para el día.',
   'conexion', 'easy', 7),

  ('preguntas-profundas',
   '7 preguntas que nunca se han hecho',
   'Cada día, háganse una pregunta profunda que nunca se han hecho. Sin juzgar, solo escuchar. Descúbranse de nuevo.',
   'conexion', 'medium', 7),

  -- ── Cuidado ───────────────────────────────────────────────
  ('actos-servicio',
   'Semana de actos de servicio',
   'Esta semana, cada uno hace un acto de servicio diario para el otro sin que lo pida: preparar algo, resolver un pendiente, un detalle inesperado.',
   'cuidado', 'easy', 7),

  ('carta-honesta',
   'Carta honesta de apreciación',
   'Cada uno escribe una carta de al menos una página sobre lo que aprecia del otro. Léanla en voz alta al final de la semana.',
   'cuidado', 'medium', 5),

  ('lenguaje-amor',
   'Habla en su idioma de amor',
   'Identifiquen el lenguaje de amor principal de cada uno. Esta semana, expresen amor SOLO en el idioma del otro, no en el propio.',
   'cuidado', 'medium', 7),

  -- ── Choque (Conflicto) ────────────────────────────────────
  ('conflicto-constructivo',
   'Laboratorio de conflicto',
   'Elijan un tema pendiente y practiquen la técnica de los 15 minutos: 5 min habla uno, 5 min el otro, 5 min buscan un acuerdo. Sin interrumpirse.',
   'choque', 'deep', 5),

  ('pausas-conscientes',
   'Instala el botón de pausa',
   'Acuerden una palabra o señal para pausar cualquier discusión que se caliente. Practíquenla 3 veces esta semana, incluso en situaciones leves.',
   'choque', 'easy', 7),

  ('bitacora-tension',
   'Bitácora de tensiones',
   'Cada uno lleva un registro diario de momentos de tensión: qué pasó, qué sentiste, qué necesitabas. Al final de la semana, compartan sin culpar.',
   'choque', 'medium', 7),

  -- ── Camino ────────────────────────────────────────────────
  ('vision-compartida',
   'Diseña tu mapa del futuro',
   'Dediquen 2 sesiones esta semana a crear un tablero visual (físico o digital) de su visión compartida a 1, 3 y 5 años.',
   'camino', 'medium', 7),

  ('finanzas-abiertas',
   'Transparencia financiera total',
   'Esta semana, compartan sus números reales: ingresos, gastos, deudas, ahorros. Sin juicios. Busquen un acuerdo para el próximo mes.',
   'camino', 'deep', 5),

  ('proyecto-juntos',
   'Proyecto de equipo',
   'Elijan un mini proyecto para hacer juntos esta semana: reorganizar un espacio, planear un viaje, cocinar un menú semanal. Trabajen como equipo.',
   'camino', 'easy', 7);


-- ─────────────────────────────────────────────────────────────────────────────
-- Phase 3: Verification
-- ─────────────────────────────────────────────────────────────────────────────

SELECT '✅ weekly_plans'         AS table_name, count(*) AS remaining FROM weekly_plans
UNION ALL
SELECT '✅ weekly_plan_items',   count(*) FROM weekly_plan_items
UNION ALL
SELECT '✅ challenge_assignments', count(*) FROM challenge_assignments
UNION ALL
SELECT '✅ weekly_challenges (seeded)', count(*) FROM weekly_challenges
UNION ALL
SELECT '✅ nosotros_narratives', count(*) FROM nosotros_narratives
UNION ALL
SELECT '✅ couple_insights',     count(*) FROM couple_insights
UNION ALL
SELECT '✅ ai_insights',         count(*) FROM ai_insights
UNION ALL
SELECT '✅ ai_audit_log',        count(*) FROM ai_audit_log;

COMMIT;
