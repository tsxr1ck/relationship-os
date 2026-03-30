-- Fix infinite recursion in RLS policies

-- Drop all existing policies on couple_members
DROP POLICY IF EXISTS "Users can view their couple memberships" ON couple_members;
DROP POLICY IF EXISTS "Users can insert themselves as couple members" ON couple_members;
DROP POLICY IF EXISTS "Users can view their couple memberships" ON couple_members;
DROP POLICY IF EXISTS "Users can insert couple members" ON couple_members;

-- Create simple policies without circular references
CREATE POLICY "Users can view own couple membership"
ON couple_members FOR SELECT
USING (user_id = auth.uid());

CREATE POLICY "Users can insert couple members"
ON couple_members FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- Also fix the circular reference in couples
DROP POLICY IF EXISTS "Couple members can view their couple" ON couples;

CREATE POLICY "Users can view their couples"
ON couples FOR SELECT
USING (
    EXISTS (SELECT 1 FROM couple_members WHERE couple_id = couples.id AND user_id = auth.uid())
);

-- For profiles - simplify
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

CREATE POLICY "Users can view own profile"
ON profiles FOR SELECT
USING (id = auth.uid());

CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
USING (id = auth.uid());

CREATE POLICY "Users can insert own profile"
ON profiles FOR INSERT
WITH CHECK (id = auth.uid());
