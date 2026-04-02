-- ============================================================
-- 11. PARTNER PRESENCE TRACKING
-- ============================================================

-- Add last_seen_at to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMPTZ DEFAULT NOW();
CREATE INDEX IF NOT EXISTS idx_profiles_last_seen ON profiles(last_seen_at);

-- Add app.opened event type to notification trigger
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
  SELECT cm.user_id INTO partner_id
  FROM couple_members cm
  WHERE cm.couple_id = NEW.couple_id
    AND cm.user_id != NEW.actor_id
  LIMIT 1;

  IF partner_id IS NULL THEN
    RETURN NEW;
  END IF;

  SELECT COALESCE(np.enabled, TRUE) INTO pref_enabled
  FROM notification_preferences np
  WHERE np.user_id = partner_id
    AND np.event_type = NEW.event_type;

  IF pref_enabled = FALSE THEN
    RETURN NEW;
  END IF;

  CASE NEW.event_type
    WHEN 'app.opened' THEN
      notif_title := 'Tu pareja está en la app';
      notif_body := COALESCE(NEW.metadata->>'partner_name', 'Tu pareja') || ' acaba de abrir la app.';
      notif_icon := 'smartphone';
      notif_action_url := '/dashboard';
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

  INSERT INTO notifications (user_id, event_id, title, body, icon, action_url)
  VALUES (partner_id, NEW.id, notif_title, notif_body, notif_icon, notif_action_url);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add app.opened to default preferences
CREATE OR REPLACE FUNCTION ensure_default_notification_preferences(user_uuid UUID)
RETURNS VOID AS $$
DECLARE
  event_types TEXT[] := ARRAY[
    'app.opened',
    'conocernos.answered', 'conocernos.revealed', 'conocernos.reacted',
    'plan.completed', 'plan.created',
    'challenge.completed', 'challenge.started',
    'historia.created', 'historia.revealed',
    'profile.updated', 'questionnaire.completed',
    'couple.joined', 'milestone.created',
    'nickname.requested', 'nickname.accepted'
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
