-- ============================================================================
-- MIGRATION 08: Profile Enhancements
-- Run in: Supabase SQL Editor
-- Adds: birthdate, gender, bio, nickname to profiles
--        shared_nickname + consent to couples
--        daily_tips table
--        avatars storage bucket + policies
--        weekly_plan_items INSERT policy (missing from base schema)
-- ============================================================================

BEGIN;

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. Extend profiles table
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS birthdate DATE;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS gender TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS bio TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS nickname TEXT;

-- Add check constraint for gender (only if not already present)
DO $$ BEGIN
  ALTER TABLE profiles ADD CONSTRAINT profiles_gender_check
    CHECK (gender IS NULL OR gender IN ('male', 'female'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;


-- ─────────────────────────────────────────────────────────────────────────────
-- 2. Extend couples table — shared nicknames with mutual consent
-- ─────────────────────────────────────────────────────────────────────────────

ALTER TABLE couples ADD COLUMN IF NOT EXISTS shared_nickname TEXT;
-- nickname_consent tracks which users agreed: {"user_id_1": true, "user_id_2": true}
ALTER TABLE couples ADD COLUMN IF NOT EXISTS nickname_consent JSONB DEFAULT '{}';


-- ─────────────────────────────────────────────────────────────────────────────
-- 3. Daily tips — cached one AI tip per couple per day
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS daily_tips (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  tip_date DATE NOT NULL DEFAULT CURRENT_DATE,
  tip_text TEXT NOT NULL,
  dimension TEXT,          -- optional: which 4C layer the tip focuses on
  generated_by TEXT DEFAULT 'gemini-2.5-flash',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(couple_id, tip_date)
);

ALTER TABLE daily_tips ENABLE ROW LEVEL SECURITY;

CREATE POLICY "daily_tips_select" ON daily_tips FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

CREATE POLICY "daily_tips_insert" ON daily_tips FOR INSERT TO authenticated
  WITH CHECK (true);

CREATE POLICY "daily_tips_update" ON daily_tips FOR UPDATE TO authenticated
  USING (true);

CREATE INDEX IF NOT EXISTS idx_daily_tips_couple_date ON daily_tips(couple_id, tip_date);


-- ─────────────────────────────────────────────────────────────────────────────
-- 4. Storage bucket for avatars
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars',
  'avatars',
  true,
  5242880, -- 5MB
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO NOTHING;

-- Allow authenticated users to upload their own avatar
CREATE POLICY "Users can upload their own avatar"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow authenticated users to update their own avatar
CREATE POLICY "Users can update their own avatar"
ON storage.objects FOR UPDATE TO authenticated
USING (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow authenticated users to delete their own avatar
CREATE POLICY "Users can delete their own avatar"
ON storage.objects FOR DELETE TO authenticated
USING (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Public read for all avatars (bucket is public)
CREATE POLICY "Anyone can view avatars"
ON storage.objects FOR SELECT TO public
USING (bucket_id = 'avatars');


-- ─────────────────────────────────────────────────────────────────────────────
-- 5. Fix missing INSERT policy on weekly_plan_items
-- ─────────────────────────────────────────────────────────────────────────────

DO $$ BEGIN
  CREATE POLICY "weekly_plan_items_insert" ON weekly_plan_items FOR INSERT TO authenticated
    WITH CHECK (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;


-- ─────────────────────────────────────────────────────────────────────────────
-- Verification
-- ─────────────────────────────────────────────────────────────────────────────

SELECT '✅ profiles columns' AS check_name,
  (SELECT count(*) FROM information_schema.columns
   WHERE table_name = 'profiles' AND column_name IN ('birthdate', 'gender', 'bio', 'nickname')) AS found;

SELECT '✅ couples columns' AS check_name,
  (SELECT count(*) FROM information_schema.columns
   WHERE table_name = 'couples' AND column_name IN ('shared_nickname', 'nickname_consent')) AS found;

SELECT '✅ daily_tips table' AS check_name,
  (SELECT count(*) FROM information_schema.tables WHERE table_name = 'daily_tips') AS found;

SELECT '✅ avatars bucket' AS check_name,
  (SELECT count(*) FROM storage.buckets WHERE id = 'avatars') AS found;

COMMIT;
