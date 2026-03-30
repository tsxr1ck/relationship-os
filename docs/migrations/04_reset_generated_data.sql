-- ============================================================================
-- RELATIONSHIP OS - Reset Generated Assessment Data
-- RUN THIS IN SUPABASE SQL EDITOR to clear AI-generated data
-- Then refresh the questionnaire page to trigger a fresh generation
-- ============================================================================

-- 1. Delete response sessions tied to V2 assessments
DELETE FROM responses WHERE session_id IN (
  SELECT id FROM response_sessions WHERE stage = 'couple_v2'
);
DELETE FROM response_sessions WHERE stage = 'couple_v2';

-- 2. Delete generated assessment items and assessments
DELETE FROM generated_assessment_items;
DELETE FROM generated_assessments;

-- Done! Now refresh /dashboard/questionnaire to trigger a new AI generation.
