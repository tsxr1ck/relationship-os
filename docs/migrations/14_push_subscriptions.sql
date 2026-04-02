-- Migration 14: Push Subscriptions for Background Notifications
-- Enables PWA push notifications via VAPID protocol

CREATE TABLE IF NOT EXISTS push_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    endpoint TEXT NOT NULL,
    auth TEXT NOT NULL,
    p256dh TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Unique constraint for upsert operations
CREATE UNIQUE INDEX IF NOT EXISTS idx_push_subscriptions_user_endpoint ON push_subscriptions(user_id, endpoint);

-- Index for faster lookups by user
CREATE INDEX IF NOT EXISTS idx_push_subscriptions_user_id ON push_subscriptions(user_id);

-- RLS Policies
ALTER TABLE push_subscriptions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can insert their own push subscriptions" ON push_subscriptions;
CREATE POLICY "Users can insert their own push subscriptions" ON push_subscriptions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can view their own push subscriptions" ON push_subscriptions;
CREATE POLICY "Users can view their own push subscriptions" ON push_subscriptions
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own push subscriptions" ON push_subscriptions;
CREATE POLICY "Users can delete their own push subscriptions" ON push_subscriptions
    FOR DELETE USING (auth.uid() = user_id);
