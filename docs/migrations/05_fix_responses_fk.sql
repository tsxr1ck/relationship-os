-- ============================================================================
-- RELATIONSHIP OS - 05_fix_responses_fk
-- RUN THIS IN SUPABASE SQL EDITOR
--
-- The `responses` table currently has a FK pointing to the legacy `questions`
-- table. In V2, question_id stores item_bank UUIDs instead.
-- This migration drops the old FK so V2 answers can be saved.
-- ============================================================================

ALTER TABLE responses DROP CONSTRAINT IF EXISTS responses_question_id_fkey;
