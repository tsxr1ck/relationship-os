-- Fix RLS policies for couples table

-- Drop existing policy
DROP POLICY IF EXISTS "Users can insert couples they create" ON couples;

-- Create a simpler insert policy that allows authenticated users to create couples
CREATE POLICY "Authenticated users can create couples"
ON couples FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- Also fix couple_members insert policy
DROP POLICY IF EXISTS "Users can insert themselves as couple members" ON couple_members;

CREATE POLICY "Authenticated users can join couples"
ON couple_members FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- Enable RLS on all tables if not already enabled
ALTER TABLE couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE couple_members ENABLE ROW LEVEL SECURITY;
