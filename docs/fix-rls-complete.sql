-- Complete fix for all RLS policies

-- Drop existing policies on couples
DROP POLICY IF EXISTS "Couple members can view their couple" ON couples;
DROP POLICY IF EXISTS "Users can insert couples they create" ON couples;

-- Allow authenticated users to view couples they're members of
CREATE POLICY "Couple members can view their couple"
ON couples FOR SELECT
USING (
    id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid())
);

-- Allow authenticated users to create couples
CREATE POLICY "Users can create couples"
ON couples FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- Allow authenticated users to update their couples
CREATE POLICY "Users can update their couple"
ON couples FOR UPDATE
USING (auth.role() = 'authenticated');

-- Drop existing policies on couple_members
DROP POLICY IF EXISTS "Users can view their couple memberships" ON couple_members;
DROP POLICY IF EXISTS "Users can insert themselves as couple members" ON couple_members;

-- Allow authenticated users to view their couple memberships
CREATE POLICY "Users can view their couple memberships"
ON couple_members FOR SELECT
USING (user_id = auth.uid() OR couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- Allow authenticated users to insert couple members
CREATE POLICY "Users can insert couple members"
ON couple_members FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- Drop existing policies on profiles
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

-- Allow authenticated users to view their profile
CREATE POLICY "Users can view own profile"
ON profiles FOR SELECT
USING (id = auth.uid());

-- Allow authenticated users to update their profile
CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
USING (id = auth.uid());

-- Allow authenticated users to insert their profile
CREATE POLICY "Users can insert own profile"
ON profiles FOR INSERT
WITH CHECK (id = auth.uid());

-- Drop existing policies on response_sessions
DROP POLICY IF EXISTS "Users can view own sessions" ON response_sessions;
DROP POLICY IF EXISTS "Users can insert own sessions" ON response_sessions;
DROP POLICY IF EXISTS "Users can update own sessions" ON response_sessions;

-- Allow authenticated users to manage their sessions
CREATE POLICY "Users can view own sessions"
ON response_sessions FOR SELECT
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own sessions"
ON response_sessions FOR INSERT
WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own sessions"
ON response_sessions FOR UPDATE
USING (user_id = auth.uid());

-- Drop existing policies on responses
DROP POLICY IF EXISTS "Users can view own responses" ON responses;
DROP POLICY IF EXISTS "Users can insert own responses" ON responses;
DROP POLICY IF EXISTS "Users can update own responses" ON responses;

-- Allow authenticated users to manage their responses
CREATE POLICY "Users can view own responses"
ON responses FOR SELECT
USING (
    session_id IN (SELECT id FROM response_sessions WHERE user_id = auth.uid())
);

CREATE POLICY "Users can insert own responses"
ON responses FOR INSERT
WITH CHECK (
    session_id IN (SELECT id FROM response_sessions WHERE user_id = auth.uid())
);

CREATE POLICY "Users can update own responses"
ON responses FOR UPDATE
USING (
    session_id IN (SELECT id FROM response_sessions WHERE user_id = auth.uid())
);
