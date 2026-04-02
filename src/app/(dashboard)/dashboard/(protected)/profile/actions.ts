'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { GoogleGenAI } from '@google/genai';
import { V2_DIMENSION_MAP } from '@/lib/scoring';
import { revalidatePath } from 'next/cache';
import { logActivityEvent } from '@/app/(dashboard)/dashboard/(protected)/notifications/actions';

// ─── Types ────────────────────────────────────────────────────

export interface ProfileData {
  id: string;
  email: string;
  fullName: string;
  avatarUrl: string | null;
  nickname: string | null;
  birthdate: string | null;
  age: number | null;
  gender: string | null;
  bio: string | null;
  locale: string;
  timezone: string;
  createdAt: string;
}

export interface CoupleInfo {
  hasCouple: boolean;
  couple?: {
    id: string;
    inviteCode: string;
    status: string;
    createdAt: string;
    durationText: string;
    sharedNickname: string | null;
    nicknameConsent: Record<string, boolean>;
    bothConsented: boolean;
  };
  partner?: {
    id: string;
    fullName: string;
    avatarUrl: string | null;
    nickname: string | null;
    joinedAt: string;
  };
  memberCount: number;
  isLinked: boolean;
  myConsent: boolean;
}

export interface ProfileCoaching {
  text: string;
  cachedAt: string | null;
}

// ─── Helpers ──────────────────────────────────────────────────

function computeAge(birthdate: string): number {
  const birth = new Date(birthdate);
  const today = new Date();
  let age = today.getFullYear() - birth.getFullYear();
  const m = today.getMonth() - birth.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) {
    age--;
  }
  return age;
}

function getDurationText(dateStr: string): string {
  const created = new Date(dateStr);
  const now = new Date();
  const diffDays = Math.floor((now.getTime() - created.getTime()) / (1000 * 60 * 60 * 24));

  if (diffDays < 7) return `${diffDays} días`;
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} semana${Math.floor(diffDays / 7) > 1 ? 's' : ''}`;
  if (diffDays >= 365) {
    const years = Math.floor(diffDays / 365);
    const months = Math.floor((diffDays % 365) / 30);
    return months > 0
      ? `${years} año${years > 1 ? 's' : ''} y ${months} mes${months > 1 ? 'es' : ''}`
      : `${years} año${years > 1 ? 's' : ''}`;
  }
  return `${Math.floor(diffDays / 30)} mes${Math.floor(diffDays / 30) > 1 ? 'es' : ''}`;
}

// ─── Get Profile ──────────────────────────────────────────────

export async function getProfile(): Promise<ProfileData | null> {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (!user || authError) return null;

  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single();

  return {
    id: user.id,
    email: user.email || '',
    fullName: profile?.full_name || '',
    avatarUrl: profile?.avatar_url || null,
    nickname: profile?.nickname || null,
    birthdate: profile?.birthdate || null,
    age: profile?.birthdate ? computeAge(profile.birthdate) : null,
    gender: profile?.gender || null,
    bio: profile?.bio || null,
    locale: profile?.locale || 'es-MX',
    timezone: profile?.timezone || 'America/Mexico_City',
    createdAt: profile?.created_at || user.created_at,
  };
}

// ─── Update Profile ───────────────────────────────────────────

export async function updateProfile(data: {
  fullName?: string;
  nickname?: string;
  birthdate?: string;
  gender?: string;
  bio?: string;
  locale?: string;
  timezone?: string;
}) {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (!user || authError) throw new Error('No autenticado');

  const updatePayload: Record<string, any> = {
    updated_at: new Date().toISOString(),
  };

  if (data.fullName !== undefined) updatePayload.full_name = data.fullName;
  if (data.nickname !== undefined) updatePayload.nickname = data.nickname || null;
  if (data.birthdate !== undefined) updatePayload.birthdate = data.birthdate || null;
  if (data.gender !== undefined) updatePayload.gender = data.gender || null;
  if (data.bio !== undefined) updatePayload.bio = data.bio || null;
  if (data.locale !== undefined) updatePayload.locale = data.locale;
  if (data.timezone !== undefined) updatePayload.timezone = data.timezone;

  const { error } = await supabase
    .from('profiles')
    .update(updatePayload)
    .eq('id', user.id);

  if (error) {
    console.error('Error updating profile:', error);
    throw new Error('Error al actualizar el perfil: ' + error.message);
  }

  await logActivityEvent('profile.updated', 'profile', user.id, {
    partner_name: data.fullName || 'Tu pareja',
  });

  revalidatePath('/dashboard');
  revalidatePath('/dashboard/profile');
  return { success: true };
}

// ─── Upload Avatar ────────────────────────────────────────────

export async function uploadAvatar(formData: FormData): Promise<{ avatarUrl: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const file = formData.get('avatar') as File;
  if (!file) throw new Error('No se seleccionó archivo');

  // Validate
  const maxSize = 5 * 1024 * 1024; // 5MB
  if (file.size > maxSize) throw new Error('La imagen no puede pesar más de 5MB');

  const allowed = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
  if (!allowed.includes(file.type)) throw new Error('Formato no soportado. Usa JPG, PNG, WebP o GIF.');

  const ext = file.name.split('.').pop() || 'jpg';
  const filePath = `${user.id}/avatar.${ext}`;

  // Delete old avatar files in the user's folder
  const { data: existingFiles } = await supabase.storage
    .from('avatars')
    .list(user.id);

  if (existingFiles && existingFiles.length > 0) {
    const pathsToDelete = existingFiles.map(f => `${user.id}/${f.name}`);
    await supabase.storage.from('avatars').remove(pathsToDelete);
  }

  // Upload new
  const { error: uploadError } = await supabase.storage
    .from('avatars')
    .upload(filePath, file, { upsert: true });

  if (uploadError) {
    console.error('Avatar upload error:', uploadError);
    throw new Error('Error al subir la imagen: ' + uploadError.message);
  }

  // Get public URL
  const { data: urlData } = supabase.storage
    .from('avatars')
    .getPublicUrl(filePath);

  const avatarUrl = urlData.publicUrl;

  // Update profile
  await supabase
    .from('profiles')
    .update({ avatar_url: avatarUrl, updated_at: new Date().toISOString() })
    .eq('id', user.id);

  revalidatePath('/dashboard');
  revalidatePath('/dashboard/profile');

  return { avatarUrl };
}

// ─── Delete Avatar ────────────────────────────────────────────

export async function deleteAvatar(): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  // Remove all files in user's avatar folder
  const { data: existingFiles } = await supabase.storage
    .from('avatars')
    .list(user.id);

  if (existingFiles && existingFiles.length > 0) {
    const pathsToDelete = existingFiles.map(f => `${user.id}/${f.name}`);
    await supabase.storage.from('avatars').remove(pathsToDelete);
  }

  // Clear URL in profile
  await supabase
    .from('profiles')
    .update({ avatar_url: null, updated_at: new Date().toISOString() })
    .eq('id', user.id);

  revalidatePath('/dashboard');
  revalidatePath('/dashboard/profile');

  return { success: true };
}

// ─── Get Couple Info ──────────────────────────────────────────

export async function getProfileCoupleInfo(): Promise<CoupleInfo> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) return { hasCouple: false, memberCount: 0, isLinked: false, myConsent: false };

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id, role')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) {
    return { hasCouple: false, memberCount: 0, isLinked: false, myConsent: false };
  }

  const { data: couple } = await supabase
    .from('couples')
    .select('*')
    .eq('id', membership.couple_id)
    .single();

  const admin = createAdminClient();
  const { data: members } = await admin
    .from('couple_members')
    .select('user_id, role, joined_at')
    .eq('couple_id', membership.couple_id);

  const partnerMember = members?.find((m) => m.user_id !== user.id);

  let partner = undefined;
  if (partnerMember) {
    const { data: partnerProfile } = await admin
      .from('profiles')
      .select('id, full_name, avatar_url, nickname')
      .eq('id', partnerMember.user_id)
      .single();

    partner = partnerProfile ? {
      id: partnerProfile.id,
      fullName: partnerProfile.full_name || 'Tu pareja',
      avatarUrl: partnerProfile.avatar_url,
      nickname: partnerProfile.nickname || null,
      joinedAt: partnerMember.joined_at,
    } : undefined;
  }

  const consent: Record<string, boolean> = couple?.nickname_consent || {};
  const bothConsented = partnerMember
    ? (consent[user.id] === true && consent[partnerMember.user_id] === true)
    : false;

  return {
    hasCouple: true,
    couple: {
      id: couple!.id,
      inviteCode: couple!.invite_code,
      status: couple!.status,
      createdAt: couple!.created_at,
      durationText: getDurationText(couple!.created_at),
      sharedNickname: couple?.shared_nickname || null,
      nicknameConsent: consent,
      bothConsented,
    },
    partner,
    memberCount: members?.length || 1,
    isLinked: !!partnerMember,
    myConsent: consent[user.id] === true,
  };
}

// ─── Nickname Consent Flow ────────────────────────────────────

export async function requestNicknameSharing(): Promise<{ myConsent: boolean; bothConsented: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) throw new Error('No tienes pareja vinculada');

  const admin = createAdminClient();

  // Get current consent
  const { data: couple } = await admin
    .from('couples')
    .select('nickname_consent')
    .eq('id', membership.couple_id)
    .single();

  const consent: Record<string, boolean> = couple?.nickname_consent || {};

  // Toggle my consent
  consent[user.id] = !consent[user.id];

  await admin
    .from('couples')
    .update({ nickname_consent: consent, updated_at: new Date().toISOString() })
    .eq('id', membership.couple_id);

  // Check if both consented
  const { data: members } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', membership.couple_id);

  const allUserIds = (members || []).map(m => m.user_id);
  const bothConsented = allUserIds.length === 2 && allUserIds.every(id => consent[id] === true);

  if (consent[user.id] === true && !bothConsented) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('full_name')
      .eq('id', user.id)
      .single();

    await logActivityEvent('nickname.requested', 'couple', membership.couple_id, {
      partner_name: profile?.full_name || 'Tu pareja',
    });
  }

  revalidatePath('/dashboard/profile');

  return { myConsent: consent[user.id], bothConsented };
}

// ─── Update Shared Nickname ───────────────────────────────────

export async function updateSharedNickname(nickname: string): Promise<{ success: boolean }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) throw new Error('No tienes pareja vinculada');

  const admin = createAdminClient();

  // Verify both consented
  const { data: couple } = await admin
    .from('couples')
    .select('nickname_consent')
    .eq('id', membership.couple_id)
    .single();

  const consent: Record<string, boolean> = couple?.nickname_consent || {};
  const { data: members } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', membership.couple_id);

  const allUserIds = (members || []).map(m => m.user_id);
  const bothConsented = allUserIds.length === 2 && allUserIds.every(id => consent[id] === true);

  if (!bothConsented) throw new Error('Ambos deben aceptar compartir apodos');

  await admin
    .from('couples')
    .update({ shared_nickname: nickname || null, updated_at: new Date().toISOString() })
    .eq('id', membership.couple_id);

  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  await logActivityEvent('nickname.accepted', 'couple', membership.couple_id, {
    partner_name: profile?.full_name || 'Tu pareja',
  });

  revalidatePath('/dashboard/profile');
  return { success: true };
}

// ─── AI Profile Coaching ──────────────────────────────────────

export async function generateProfileCoaching(
  forceRefresh: boolean = false
): Promise<ProfileCoaching> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { text: '', cachedAt: null };

  const admin = createAdminClient();

  // Check cache (key: _profile_coaching)
  if (!forceRefresh) {
    const { data: cached } = await admin
      .from('ai_insights')
      .select('insight_text, created_at')
      .eq('user_id', user.id)
      .eq('dimension_slug', '_profile_coaching')
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (cached?.insight_text) {
      return { text: cached.insight_text, cachedAt: cached.created_at };
    }
  }

  // Fetch context
  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name, birthdate, gender, bio')
    .eq('id', user.id)
    .single();

  const myName = profile?.full_name || 'Usuario';

  // Fetch profile vectors
  const { data: vectors } = await supabase
    .from('profile_vectors')
    .select('dimension_slug, normalized_score')
    .eq('user_id', user.id);

  if (!vectors || vectors.length === 0) {
    const fallback = `${myName}, completa el onboarding para recibir coaching personalizado sobre tu relación.`;
    return { text: fallback, cachedAt: null };
  }

  const scoreLines = vectors.map(v => {
    const meta = V2_DIMENSION_MAP[v.dimension_slug];
    return meta ? `${meta.label}: ${v.normalized_score}/100` : null;
  }).filter(Boolean).join('\n');

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    return { text: `${myName}, tus resultados muestran un perfil con matices interesantes. Explora cada dimensión para descubrir tus fortalezas.`, cachedAt: null };
  }

  const ai = new GoogleGenAI({ apiKey });

  const prompt = `
Eres un coach de relaciones empático para "Relationship OS".
Escribe un párrafo de máximo 4 oraciones de coaching personal para ${myName}.
${profile?.gender === 'male' ? 'Es hombre.' : profile?.gender === 'female' ? 'Es mujer.' : ''}
${profile?.birthdate ? `Tiene ${computeAge(profile.birthdate)} años.` : ''}
${profile?.bio ? `Bio: ${profile.bio}` : ''}

Sus puntuaciones de perfil:
${scoreLines}

REGLAS:
- Dirígete a ${myName} en segunda persona (tú).
- NO uses markdown (sin asteriscos ni negritas).
- Español mexicano cálido y concreto.
- Menciona una fortaleza y un área de curiosidad.
- Cierra con una micro-acción que pueda hacer hoy.
`;

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: { temperature: 0.7 },
    });

    const text = response.text || '';
    if (text) {
      // Cache it
      await admin.from('ai_insights').delete()
        .eq('user_id', user.id)
        .eq('dimension_slug', '_profile_coaching');

      await admin.from('ai_insights').insert({
        user_id: user.id,
        dimension_slug: '_profile_coaching',
        insight_text: text,
      });

      return { text, cachedAt: new Date().toISOString() };
    }
  } catch (err) {
    console.error('Profile coaching error:', err);
  }

  return { text: `${myName}, cada paso que das para conocerte mejor fortalece tu relación. Hoy, dedica 5 minutos a reflexionar sobre lo que más valoras en tu pareja.`, cachedAt: null };
}

// ─── Daily Tip ────────────────────────────────────────────────

export async function getDailyTip(): Promise<{ tip: string | null; dimension: string | null }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { tip: null, dimension: null };

  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return { tip: null, dimension: null };

  const admin = createAdminClient();
  const today = new Date().toISOString().split('T')[0];

  // Check cache
  const { data: cached } = await admin
    .from('daily_tips')
    .select('tip_text, dimension')
    .eq('couple_id', membership.couple_id)
    .eq('tip_date', today)
    .single();

  if (cached) return { tip: cached.tip_text, dimension: cached.dimension };

  // Generate a new tip
  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const myName = profile?.full_name || 'Tú';

  // Get partner name
  const { data: partnerMembers } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', membership.couple_id)
    .neq('user_id', user.id);

  let partnerName = 'tu pareja';
  if (partnerMembers && partnerMembers.length > 0) {
    const { data: pp } = await admin.from('profiles').select('full_name').eq('id', partnerMembers[0].user_id).single();
    partnerName = pp?.full_name || 'tu pareja';
  }

  // Get weakest area from vectors for focus
  const { data: vectors } = await supabase
    .from('profile_vectors')
    .select('dimension_slug, normalized_score')
    .eq('user_id', user.id);

  const layers = ['conexion', 'cuidado', 'choque', 'camino'];
  const randomLayer = layers[Math.floor(Math.random() * layers.length)];

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    const fallbackTips = [
      `Hoy, dediquen 5 minutos sin pantallas a preguntarse: "¿Cómo te sientes hoy?"`,
      `Sorprendan al otro con un detalle pequeño — una nota, un café, un abrazo largo.`,
      `Practiquen escuchar sin dar consejos. Solo presencia.`,
      `Compartan un recuerdo favorito de los últimos días juntos.`,
    ];
    const tip = fallbackTips[new Date().getDate() % fallbackTips.length];
    await admin.from('daily_tips').insert({
      couple_id: membership.couple_id,
      tip_date: today,
      tip_text: tip,
      dimension: randomLayer,
    });
    return { tip, dimension: randomLayer };
  }

  const ai = new GoogleGenAI({ apiKey });

  const prompt = `Actúa como un coach de parejas experto y profundamente empático para "Relationship OS".
Usuario: ${myName}. Pareja: ${partnerName}.
Dimensión de enfoque hoy: ${randomLayer}.

Genera un "Sabías que" o Consejo del Día que sea:
1. ÍNTIMO Y PERSONAL: Usa sus nombres. Haz que se sientan vistos.
2. ACCIONABLE HOY: Sugiere una acción pequeña pero con significado emocional profundo que puedan hacer en menos de 5 minutos hoy.
3. TONO: Cálido, inspirador, editorial de alta calidad.
4. MÁXIMO 2 oraciones cortas.

Ejemplo: "${myName}, hoy dile a ${partnerName} algo que admires de su forma de cuidarte. Un reconocimiento genuino fortalece su conexión instantáneamente."

REGLA: Sin markdown (sin astersiscos ni negritas). Texto plano.`;

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: { temperature: 0.85 },
    });

    const text = response.text?.trim() || '';
    if (text) {
      await admin.from('daily_tips').insert({
        couple_id: membership.couple_id,
        tip_date: today,
        tip_text: text,
        dimension: randomLayer,
      });
      return { tip: text, dimension: randomLayer };
    }
  } catch (err) {
    console.error('Daily tip generation error:', err);
  }

  const fallback = `${myName}, hoy tómense un momento para recordarle a ${partnerName} por qué son un gran equipo. Las palabras de aliento construyen puentes indestructibles.`;
  await admin.from('daily_tips').insert({
    couple_id: membership.couple_id,
    tip_date: today,
    tip_text: fallback,
    dimension: randomLayer,
  });
  return { tip: fallback, dimension: randomLayer };
}
