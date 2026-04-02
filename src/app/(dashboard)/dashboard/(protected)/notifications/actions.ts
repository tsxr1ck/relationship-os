'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { revalidatePath } from 'next/cache';

export interface NotificationItem {
  id: string;
  title: string;
  body: string;
  icon: string;
  actionUrl: string | null;
  isRead: boolean;
  createdAt: string;
}

export interface UnreadCount {
  count: number;
}

export async function getNotifications(limit = 20): Promise<NotificationItem[]> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return [];

  const { data, error } = await supabase
    .from('notifications')
    .select('id, title, body, icon, action_url, is_read, created_at')
    .eq('user_id', user.id)
    .order('created_at', { ascending: false })
    .limit(limit);

  if (error) {
    console.error('Error fetching notifications:', error);
    return [];
  }

  return (data || []).map(n => ({
    id: n.id,
    title: n.title,
    body: n.body,
    icon: n.icon,
    actionUrl: n.action_url,
    isRead: n.is_read,
    createdAt: n.created_at,
  }));
}

export async function getUnreadCount(): Promise<UnreadCount> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { count: 0 };

  const { count, error } = await supabase
    .from('notifications')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', user.id)
    .eq('is_read', false);

  if (error) {
    console.error('Error fetching unread count:', error);
    return { count: 0 };
  }

  return { count: count || 0 };
}

export async function markNotificationAsRead(notificationId: string): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false };

  const { error } = await supabase
    .from('notifications')
    .update({ is_read: true })
    .eq('id', notificationId)
    .eq('user_id', user.id);

  if (error) {
    console.error('Error marking notification as read:', error);
    return { success: false };
  }

  revalidatePath('/dashboard');
  return { success: true };
}

export async function markAllNotificationsAsRead(): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false };

  const { error } = await supabase
    .from('notifications')
    .update({ is_read: true })
    .eq('user_id', user.id)
    .eq('is_read', false);

  if (error) {
    console.error('Error marking all notifications as read:', error);
    return { success: false };
  }

  revalidatePath('/dashboard');
  return { success: true };
}

export async function deleteNotification(notificationId: string): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false };

  const { error } = await supabase
    .from('notifications')
    .delete()
    .eq('id', notificationId)
    .eq('user_id', user.id);

  if (error) {
    console.error('Error deleting notification:', error);
    return { success: false };
  }

  revalidatePath('/dashboard');
  return { success: true };
}

export async function logActivityEvent(
  eventType: string,
  entityType: string | null = null,
  entityId: string | null = null,
  metadata: Record<string, unknown> = {}
): Promise<void> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return;

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return;

  const admin = createAdminClient();
  await admin.rpc('log_activity_event', {
    p_couple_id: membership.couple_id,
    p_actor_id: user.id,
    p_event_type: eventType,
    p_entity_type: entityType,
    p_entity_id: entityId,
    p_metadata: metadata,
  });
}

export interface NotificationPreferenceItem {
  eventType: string;
  enabled: boolean;
  label: string;
}

export async function getNotificationPreferences(): Promise<NotificationPreferenceItem[]> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return [];

  const { data, error } = await supabase
    .from('notification_preferences')
    .select('event_type, enabled')
    .eq('user_id', user.id)
    .order('event_type');

  if (error) {
    console.error('Error fetching notification preferences:', error);
    return [];
  }

  const labels: Record<string, string> = {
    'conocernos.answered': 'Conocernos - Respuesta del día',
    'conocernos.revealed': 'Conocernos - Revelación de respuestas',
    'conocernos.reacted': 'Conocernos - Reacción a respuesta',
    'plan.completed': 'Plan - Actividad completada',
    'plan.created': 'Plan - Nuevo plan semanal',
    'challenge.completed': 'Reto - Reto completado',
    'challenge.started': 'Reto - Reto iniciado',
    'historia.created': 'Historia - Nuevo recuerdo',
    'historia.revealed': 'Historia - Recuerdo revelado',
    'profile.updated': 'Perfil - Actualización',
    'questionnaire.completed': 'Evaluación - Completada',
    'couple.joined': 'Pareja - Se unió',
    'milestone.created': 'Hito - Nuevo hito',
    'nickname.requested': 'Apodo - Solicitud',
    'nickname.accepted': 'Apodo - Aceptado',
  };

  return (data || []).map(p => ({
    eventType: p.event_type,
    enabled: p.enabled,
    label: labels[p.event_type] || p.event_type,
  }));
}

export async function updateNotificationPreference(
  eventType: string,
  enabled: boolean
): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false };

  const { error } = await supabase
    .from('notification_preferences')
    .update({ enabled, updated_at: new Date().toISOString() })
    .eq('user_id', user.id)
    .eq('event_type', eventType);

  if (error) {
    console.error('Error updating notification preference:', error);
    return { success: false };
  }

  return { success: true };
}

export async function logAppOpened(fireNotification = true): Promise<void> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return;

  await supabase
    .from('profiles')
    .update({ last_seen_at: new Date().toISOString() })
    .eq('id', user.id);

  if (!fireNotification) return;

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return;

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const admin = createAdminClient();
  await admin.rpc('log_activity_event', {
    p_couple_id: membership.couple_id,
    p_actor_id: user.id,
    p_event_type: 'app.opened',
    p_entity_type: 'app_session',
    p_entity_id: null,
    p_metadata: { partner_name: profile?.full_name || 'Tu pareja' },
  });
}
