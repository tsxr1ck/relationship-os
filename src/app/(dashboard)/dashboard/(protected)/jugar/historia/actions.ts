'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { logActivityEvent } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';

export interface HistoriaEntry {
  id: string;
  title: string;
  description: string | null;
  contentType: 'text' | 'photo' | 'voice' | 'conocernos_reveal' | 'system_milestone';
  mediaUrl: string | null;
  dimension: string | null;
  occurredAt: string;
  metadata: any | null;
  createdBy: string;
}

export async function getMemories(page: number = 0, limit: number = 20): Promise<HistoriaEntry[]> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return [];

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return [];
  const coupleId = membership.couple_id;

  const offset = page * limit;

  const { data } = await supabase
    .from('historia_entries')
    .select('*')
    .eq('couple_id', coupleId)
    .order('occurred_at', { ascending: false })
    .order('created_at', { ascending: false })
    .range(offset, offset + limit - 1);

  if (!data) return [];

  return data.map((d: any) => ({
    id: d.id,
    title: d.title,
    description: d.description,
    contentType: d.content_type,
    mediaUrl: d.media_url,
    dimension: d.dimension,
    occurredAt: d.occurred_at,
    metadata: d.metadata,
    createdBy: d.created_by,
  }));
}

export async function createMemory(data: {
  title: string;
  description?: string;
  dimension?: string;
  occurredAt?: string;
  contentType?: string;
  mediaUrl?: string;
  metadata?: any;
}): Promise<{ success: boolean; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false, error: 'No autenticado' };

  if (!data.title?.trim()) {
    return { success: false, error: 'El título es requerido' };
  }

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return { success: false, error: 'No tienes una pareja vinculada' };

  let actualContentType = data.contentType || 'text';
  let finalMetadata = data.metadata || null;

  // Hack for missing DB enum values
  if (actualContentType === 'quote') {
    actualContentType = 'text';
    finalMetadata = { ...finalMetadata, customType: 'quote' };
  } else if (actualContentType === 'milestone') {
    actualContentType = 'system_milestone';
    finalMetadata = { ...finalMetadata, customType: 'user_milestone' };
  }

  const insertData = {
    couple_id: membership.couple_id,
    created_by: user.id,
    title: data.title.trim(),
    description: data.description?.trim() || null,
    dimension: data.dimension || null,
    occurred_at: data.occurredAt || new Date().toISOString(),
    content_type: actualContentType,
    media_url: data.mediaUrl || null,
    metadata: finalMetadata,
  };

  const { error } = await supabase.from('historia_entries').insert(insertData);

  if (error) {
    console.error('Failed to create memory:', error);
    return { success: false, error: 'No se pudo guardar la memoria: ' + error.message };
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  await logActivityEvent('historia.created', 'historia_entry', membership.couple_id, {
    partner_name: profile?.full_name || 'Tu pareja',
  });

  return { success: true };
}

export async function saveRevealToHistory(params: {
  dailyId: string;
  questionText: string;
  userAnswer: string;
  partnerAnswer: string;
  dimension: string;
  date: string;
}): Promise<{ success: boolean; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { success: false, error: 'No autenticado' };

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return { success: false, error: 'No tienes pareja' };

  // First check if a reveal for this dailyId already exists in history to avoid duplicates
  const { data: existing } = await supabase
    .from('historia_entries')
    .select('id')
    .eq('couple_id', membership.couple_id)
    .eq('content_type', 'conocernos_reveal')
    .contains('metadata', { dailyId: params.dailyId })
    .limit(1)
    .single();

  if (existing) {
    return { success: false, error: 'Esta revelación ya está guardada en su historia' };
  }

  const metadata = {
    dailyId: params.dailyId,
    userAnswer: params.userAnswer,
    partnerAnswer: params.partnerAnswer,
  };

  const insertData = {
    couple_id: membership.couple_id,
    created_by: user.id,
    title: 'Pregunta del Día: ' + params.questionText.slice(0, 40) + (params.questionText.length > 40 ? '...' : ''),
    description: `Respondieron a una pregunta de Conocernos el ${new Date(params.date).toLocaleDateString('es-MX', { month: 'long', day: 'numeric' })}.`,
    content_type: 'conocernos_reveal',
    dimension: params.dimension,
    occurred_at: params.date,
    metadata,
  };

  const { error } = await supabase.from('historia_entries').insert(insertData);

  if (error) {
    console.error('Failed to create history entry from reveal:', error);
    return { success: false, error: 'Error al curar en la historia' };
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  await logActivityEvent('historia.revealed', 'conocernos_reveal', params.dailyId, {
    partner_name: profile?.full_name || 'Tu pareja',
  });

  return { success: true };
}
