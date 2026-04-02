-- ============================================================
-- 10. NOTIFICATION SYSTEM
-- ============================================================

-- Activity Events Table (immutable log of all partner actions)
CREATE TABLE activity_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID NOT NULL REFERENCES couples(id) ON DELETE CASCADE,
  actor_id UUID NOT NULL REFERENCES auth.users(id),
  event_type TEXT NOT NULL,
  entity_type TEXT,
  entity_id UUID,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notifications Table (derived from activity_events, per-user)
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  event_id UUID REFERENCES activity_events(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  icon TEXT DEFAULT 'bell',
  action_url TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notification Preferences Table
CREATE TABLE notification_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL,
  enabled BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, event_type)
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE activity_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_preferences ENABLE ROW LEVEL SECURITY;

-- Activity Events: users can see events for their couples
CREATE POLICY "activity_events_select" ON activity_events FOR SELECT TO authenticated
  USING (couple_id IN (SELECT couple_id FROM couple_members WHERE user_id = auth.uid()));

-- Notifications: users can only see their own notifications
CREATE POLICY "notifications_select" ON notifications FOR SELECT TO authenticated
  USING (user_id = auth.uid());
CREATE POLICY "notifications_update" ON notifications FOR UPDATE TO authenticated
  USING (user_id = auth.uid());
CREATE POLICY "notifications_delete" ON notifications FOR DELETE TO authenticated
  USING (user_id = auth.uid());

-- Notification Preferences: users manage their own preferences
CREATE POLICY "notification_preferences_select" ON notification_preferences FOR SELECT TO authenticated
  USING (user_id = auth.uid());
CREATE POLICY "notification_preferences_insert" ON notification_preferences FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());
CREATE POLICY "notification_preferences_update" ON notification_preferences FOR UPDATE TO authenticated
  USING (user_id = auth.uid());

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_activity_events_couple ON activity_events(couple_id);
CREATE INDEX idx_activity_events_actor ON activity_events(actor_id);
CREATE INDEX idx_activity_events_type ON activity_events(event_type);
CREATE INDEX idx_activity_events_created ON activity_events(created_at DESC);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_user_created ON notifications(user_id, created_at DESC);
CREATE INDEX idx_notifications_event ON notifications(event_id);

CREATE INDEX idx_notification_preferences_user ON notification_preferences(user_id);
CREATE INDEX idx_notification_preferences_user_type ON notification_preferences(user_id, event_type);

-- ============================================================
-- TRIGGER: Auto-create notifications from activity_events
-- ============================================================

CREATE OR REPLACE FUNCTION create_notifications_from_event()
RETURNS TRIGGER AS $$
DECLARE
  partner_id UUID;
  notif_title TEXT;
  notif_body TEXT;
  notif_icon TEXT;
  notif_action_url TEXT;
  pref_enabled BOOLEAN;
BEGIN
  -- Find the partner in the same couple
  SELECT cm.user_id INTO partner_id
  FROM couple_members cm
  WHERE cm.couple_id = NEW.couple_id
    AND cm.user_id != NEW.actor_id
  LIMIT 1;

  -- If no partner, skip notification
  IF partner_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- Check user's notification preferences
  SELECT COALESCE(np.enabled, TRUE) INTO pref_enabled
  FROM notification_preferences np
  WHERE np.user_id = partner_id
    AND np.event_type = NEW.event_type;

  -- If preference explicitly disabled, skip
  IF pref_enabled = FALSE THEN
    RETURN NEW;
  END IF;

  -- Generate notification content based on event_type
  CASE NEW.event_type
    WHEN 'conocernos.answered' THEN
      notif_title := 'Tu pareja respondió la pregunta del día';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' ya respondió la pregunta de Conocernos de hoy.';
      notif_icon := 'heart';
      notif_action_url := '/dashboard/jugar/conocernos';

    WHEN 'conocernos.revealed' THEN
      notif_title := '¡Las respuestas están listas!';
      notif_body := 'Ya puedes ver las respuestas de hoy en Conocernos.';
      notif_icon := 'eye';
      notif_action_url := '/dashboard/jugar/conocernos';

    WHEN 'conocernos.reacted' THEN
      notif_title := 'Tu pareja reaccionó a tu respuesta';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' reaccionó a tu respuesta de hoy.';
      notif_icon := 'smile';
      notif_action_url := '/dashboard/jugar/conocernos';

    WHEN 'plan.completed' THEN
      notif_title := 'Tu pareja completó una actividad';
      notif_body := COALESCE(NEW.metadata->>'activity_title', 'Una actividad') || ' fue completada en el plan semanal.';
      notif_icon := 'check-circle';
      notif_action_url := '/dashboard/plan';

    WHEN 'plan.created' THEN
      notif_title := 'Nuevo plan semanal disponible';
      notif_body := 'Tu pareja generó un nuevo plan semanal para los dos.';
      notif_icon := 'calendar';
      notif_action_url := '/dashboard/plan';

    WHEN 'challenge.completed' THEN
      notif_title := '¡Reto completado!';
      notif_body := COALESCE(NEW.metadata->>'challenge_title', 'Un reto') || ' fue completado por tu pareja.';
      notif_icon := 'trophy';
      notif_action_url := '/dashboard/retos';

    WHEN 'challenge.started' THEN
      notif_title := 'Tu pareja empezó un reto';
      notif_body := COALESCE(NEW.metadata->>'challenge_title', 'Un reto') || ' comenzó. ¡Únete!';
      notif_icon := 'zap';
      notif_action_url := '/dashboard/retos';

    WHEN 'historia.created' THEN
      notif_title := 'Nuevo recuerdo compartido';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' agregó un nuevo recuerdo a su historia.';
      notif_icon := 'book-open';
      notif_action_url := '/dashboard/jugar/historia';

    WHEN 'historia.revealed' THEN
      notif_title := '¡Nuevo recuerdo revelado!';
      notif_body := 'Un recuerdo fue revelado en su historia compartida.';
      notif_icon := 'sparkles';
      notif_action_url := '/dashboard/jugar/historia';

    WHEN 'profile.updated' THEN
      notif_title := 'Tu pareja actualizó su perfil';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' hizo cambios en su perfil.';
      notif_icon := 'user';
      notif_action_url := '/dashboard/profile';

    WHEN 'questionnaire.completed' THEN
      notif_title := 'Evaluación completada';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' completó la evaluación ' || COALESCE(NEW.metadata->>'assessment_name', '') || '.';
      notif_icon := 'clipboard-check';
      notif_action_url := '/dashboard/nosotros';

    WHEN 'couple.joined' THEN
      notif_title := '¡Tu pareja se unió!';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Alguien') || ' se unió a ustedes como pareja.';
      notif_icon := 'users';
      notif_action_url := '/dashboard';

    WHEN 'milestone.created' THEN
      notif_title := 'Nuevo hito agregado';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' agregó un nuevo hito: ' || COALESCE(NEW.metadata->>'milestone_title', '') || '.';
      notif_icon := 'flag';
      notif_action_url := '/dashboard';

    WHEN 'nickname.requested' THEN
      notif_title := 'Solicitud de apodo compartido';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' quiere compartir un apodo contigo.';
      notif_icon := 'message-circle';
      notif_action_url := '/dashboard/profile';

    WHEN 'nickname.accepted' THEN
      notif_title := '¡Apodo compartido aceptado!';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' aceptó el apodo compartido.';
      notif_icon := 'heart';
      notif_action_url := '/dashboard/profile';

    ELSE
      notif_title := 'Nueva actividad de tu pareja';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' realizó una actividad en la app.';
      notif_icon := 'bell';
      notif_action_url := '/dashboard';
  END CASE;

  -- Insert the notification for the partner
  INSERT INTO notifications (user_id, event_id, title, body, icon, action_url)
  VALUES (partner_id, NEW.id, notif_title, notif_body, notif_icon, notif_action_url);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_create_notifications_from_event
  AFTER INSERT ON activity_events
  FOR EACH ROW
  EXECUTE FUNCTION create_notifications_from_event();

-- ============================================================
-- SEED: Default notification preferences for all event types
-- ============================================================

-- This function ensures default preferences exist for a user
CREATE OR REPLACE FUNCTION ensure_default_notification_preferences(user_uuid UUID)
RETURNS VOID AS $$
DECLARE
  event_types TEXT[] := ARRAY[
    'conocernos.answered',
    'conocernos.revealed',
    'conocernos.reacted',
    'plan.completed',
    'plan.created',
    'challenge.completed',
    'challenge.started',
    'historia.created',
    'historia.revealed',
    'profile.updated',
    'questionnaire.completed',
    'couple.joined',
    'milestone.created',
    'nickname.requested',
    'nickname.accepted'
  ];
  et TEXT;
BEGIN
  FOREACH et IN ARRAY event_types LOOP
    INSERT INTO notification_preferences (user_id, event_type, enabled)
    VALUES (user_uuid, et, TRUE)
    ON CONFLICT (user_id, event_type) DO NOTHING;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create default preferences when a profile is created
CREATE OR REPLACE FUNCTION create_default_notification_preferences()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM ensure_default_notification_preferences(NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_create_notification_prefs ON profiles;
CREATE TRIGGER trigger_create_notification_prefs
  AFTER INSERT ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION create_default_notification_preferences();

-- ============================================================
-- HELPER FUNCTION: Log activity event
-- ============================================================

CREATE OR REPLACE FUNCTION log_activity_event(
  p_couple_id UUID,
  p_actor_id UUID,
  p_event_type TEXT,
  p_entity_type TEXT DEFAULT NULL,
  p_entity_id UUID DEFAULT NULL,
  p_metadata JSONB DEFAULT '{}'
)
RETURNS UUID AS $$
DECLARE
  v_event_id UUID;
BEGIN
  INSERT INTO activity_events (couple_id, actor_id, event_type, entity_type, entity_id, metadata)
  VALUES (p_couple_id, p_actor_id, p_event_type, p_entity_type, p_entity_id, p_metadata)
  RETURNING id INTO v_event_id;
  
  RETURN v_event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
