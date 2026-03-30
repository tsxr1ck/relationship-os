-- Run this in Supabase SQL Editor (all at once)

-- 1. Drop ALL possible policy names for couple_members SELECT
DROP POLICY IF EXISTS "Users can view their couple memberships" ON couple_members;
DROP POLICY IF EXISTS "Users can view couple memberships in their couples" ON couple_members;

-- 2. Drop ALL possible policy names for profiles SELECT
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view own and partner profiles" ON profiles;

-- 3. Create helper functions (SECURITY DEFINER bypasses RLS)
CREATE OR REPLACE FUNCTION get_my_couple_ids()
RETURNS SETOF UUID AS $$
  SELECT couple_id FROM couple_members WHERE user_id = auth.uid();
$$ LANGUAGE sql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_my_couple_partner_ids()
RETURNS SETOF UUID AS $$
  SELECT cm.user_id 
  FROM couple_members cm 
  WHERE cm.couple_id IN (SELECT get_my_couple_ids())
  AND cm.user_id != auth.uid();
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- 4. Create new policies
CREATE POLICY "Users can view couple memberships in their couples"
ON couple_members FOR SELECT
USING (couple_id IN (SELECT get_my_couple_ids()));

CREATE POLICY "Users can view own and partner profiles"
ON profiles FOR SELECT
USING (
  id = auth.uid()
  OR id IN (SELECT get_my_couple_partner_ids())
);
