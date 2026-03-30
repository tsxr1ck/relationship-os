'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { GoogleGenAI } from '@google/genai';
import { V2_DIMENSION_MAP } from '@/lib/scoring';
import { revalidatePath } from 'next/cache';

// ─── Types ────────────────────────────────────────────────────

export interface PlanItem {
  id: string;
  dayOfWeek: number;
  dayLabel: string;
  title: string;
  description: string;
  dimension: string;
  dimensionLabel: string;
  activityType: string;
  durationMinutes: number;
  difficulty: string;
  requiresBoth: boolean;
  status: 'pending' | 'completed' | 'skipped';
  completedAt: string | null;
  notes: string | null;
}

export interface WeeklyPlanData {
  plan: {
    id: string;
    weekStart: string;
    weekEnd: string;
    weekLabel: string;
    status: string;
    aiModelUsed: string;
  };
  items: PlanItem[];
  completedCount: number;
  totalCount: number;
  progress: number;
  myName: string;
  partnerName: string | null;
}

// ─── Constants ────────────────────────────────────────────────

const LAYER_META: Record<string, { label: string; icon: string }> = {
  conexion: { label: 'Conexión', icon: '💜' },
  cuidado: { label: 'Cuidado', icon: '💚' },
  choque:  { label: 'Conflicto', icon: '⚡' },
  camino:  { label: 'Camino', icon: '🧭' },
};

const DAY_LABELS = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

function getDimensionLabel(slug: string): string {
  const map = V2_DIMENSION_MAP[slug];
  if (map) return map.label;
  return LAYER_META[slug]?.label || slug;
}

function getWeekDates() {
  const now = new Date();
  const dayOfWeek = now.getDay(); // 0=Sun, 1=Mon...
  const monday = new Date(now);
  monday.setDate(now.getDate() - (dayOfWeek === 0 ? 6 : dayOfWeek - 1));
  monday.setHours(0, 0, 0, 0);
  const sunday = new Date(monday);
  sunday.setDate(monday.getDate() + 6);
  return {
    weekStart: monday.toISOString().split('T')[0],
    weekEnd: sunday.toISOString().split('T')[0],
    weekLabel: `Semana del ${monday.toLocaleDateString('es-MX', { day: 'numeric' })} - ${sunday.toLocaleDateString('es-MX', { day: 'numeric', month: 'long' })}`,
  };
}

// ─── Get weekly plan ──────────────────────────────────────────

export async function getWeeklyPlan(): Promise<WeeklyPlanData | null> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  // Profile
  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const myName = profile?.full_name || 'Tú';

  // Couple
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return null;

  // Partner name
  const admin = createAdminClient();
  let partnerName: string | null = null;
  const { data: members } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', membership.couple_id)
    .neq('user_id', user.id);

  if (members && members.length > 0) {
    const { data: pp } = await admin
      .from('profiles')
      .select('full_name')
      .eq('id', members[0].user_id)
      .single();
    partnerName = pp?.full_name || 'Tu pareja';
  }

  // Latest plan
  const { data: plan } = await supabase
    .from('weekly_plans')
    .select('*')
    .eq('couple_id', membership.couple_id)
    .order('generated_at', { ascending: false })
    .limit(1)
    .single();

  if (!plan) return null;

  // Plan items
  const { data: rawItems } = await supabase
    .from('weekly_plan_items')
    .select('*')
    .eq('plan_id', plan.id)
    .order('day_of_week', { ascending: true });

  const items: PlanItem[] = (rawItems || []).map((item: any) => ({
    id: item.id,
    dayOfWeek: item.day_of_week,
    dayLabel: item.day_label,
    title: item.title,
    description: item.description,
    dimension: item.dimension,
    dimensionLabel: getDimensionLabel(item.dimension),
    activityType: item.activity_type,
    durationMinutes: item.duration_minutes,
    difficulty: item.difficulty,
    requiresBoth: item.requires_both,
    status: item.status,
    completedAt: item.completed_at,
    notes: item.notes,
  }));

  const weekStart = new Date(plan.week_start);
  const weekEnd = new Date(plan.week_end);
  const completedCount = items.filter(i => i.status === 'completed').length;

  return {
    plan: {
      id: plan.id,
      weekStart: plan.week_start,
      weekEnd: plan.week_end,
      weekLabel: `Semana del ${weekStart.toLocaleDateString('es-MX', { day: 'numeric' })} - ${weekEnd.toLocaleDateString('es-MX', { day: 'numeric', month: 'long' })}`,
      status: plan.status,
      aiModelUsed: plan.ai_model_used,
    },
    items,
    completedCount,
    totalCount: items.length,
    progress: items.length > 0 ? Math.round((completedCount / items.length) * 100) : 0,
    myName,
    partnerName,
  };
}

// ─── Toggle plan item ─────────────────────────────────────────

export async function togglePlanItem(itemId: string): Promise<{ newStatus: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const { data: item } = await supabase
    .from('weekly_plan_items')
    .select('status')
    .eq('id', itemId)
    .single();

  if (!item) throw new Error('Actividad no encontrada');

  const newStatus = item.status === 'completed' ? 'pending' : 'completed';

  const { error } = await supabase
    .from('weekly_plan_items')
    .update({
      status: newStatus,
      completed_at: newStatus === 'completed' ? new Date().toISOString() : null,
    })
    .eq('id', itemId);

  if (error) throw new Error('Error actualizando la actividad');

  revalidatePath('/dashboard/plan');
  revalidatePath('/dashboard');

  return { newStatus };
}

// ─── Skip plan item ───────────────────────────────────────────

export async function skipPlanItem(itemId: string): Promise<{ newStatus: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const { error } = await supabase
    .from('weekly_plan_items')
    .update({ status: 'skipped' })
    .eq('id', itemId);

  if (error) throw new Error('Error al omitir la actividad');

  revalidatePath('/dashboard/plan');
  return { newStatus: 'skipped' };
}

// ─── Add notes to plan item ───────────────────────────────────

export async function addPlanItemNote(itemId: string, notes: string): Promise<void> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const { error } = await supabase
    .from('weekly_plan_items')
    .update({ notes })
    .eq('id', itemId);

  if (error) throw new Error('Error guardando la nota');
}

// ─── Generate AI-powered weekly plan ──────────────────────────

export async function generateWeeklyPlan(): Promise<{ success: boolean; planId: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const admin = createAdminClient();

  // Get couple
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) throw new Error('No tienes una pareja registrada');
  const coupleId = membership.couple_id;

  // Get names
  const { data: myProfile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const myName = myProfile?.full_name || 'Tú';

  const { data: partnerMembers } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', coupleId)
    .neq('user_id', user.id);

  let partnerName = 'Tu pareja';
  if (partnerMembers && partnerMembers.length > 0) {
    const { data: pp } = await admin
      .from('profiles')
      .select('full_name')
      .eq('id', partnerMembers[0].user_id)
      .single();
    partnerName = pp?.full_name || 'Tu pareja';
  }

  // Fetch profile vectors for context
  const { data: myVectors } = await supabase
    .from('profile_vectors')
    .select('dimension_slug, normalized_score')
    .eq('user_id', user.id);

  const myScores: Record<string, number> = {};
  (myVectors || []).forEach(v => { myScores[v.dimension_slug] = v.normalized_score; });

  // Fetch couple vectors (mismatch data)
  const { data: coupleVectors } = await admin
    .from('couple_vectors')
    .select('dimension_slug, mismatch_delta, risk_flag, opportunity_flag')
    .eq('couple_id', coupleId);

  const risks = (coupleVectors || []).filter(v => v.risk_flag).map(v => ({
    slug: v.dimension_slug,
    label: V2_DIMENSION_MAP[v.dimension_slug]?.label || v.dimension_slug,
    delta: v.mismatch_delta,
  }));

  const opportunities = (coupleVectors || []).filter(v => v.opportunity_flag).map(v => ({
    slug: v.dimension_slug,
    label: V2_DIMENSION_MAP[v.dimension_slug]?.label || v.dimension_slug,
  }));

  // Compute 4C layer averages
  const layerAvg = (layer: string) => {
    const dims = Object.entries(V2_DIMENSION_MAP).filter(([, m]) => m.layer === layer);
    const vals = dims.map(([slug]) => myScores[slug] ?? 50);
    return vals.length > 0 ? Math.round(vals.reduce((a, b) => a + b, 0) / vals.length) : 50;
  };

  const scores4C = {
    conexion: layerAvg('conexion'),
    cuidado: layerAvg('cuidado'),
    choque: layerAvg('choque'),
    camino: layerAvg('camino'),
  };

  // Find weakest area to prioritize
  const weakest = Object.entries(scores4C).sort(([, a], [, b]) => a - b)[0];
  const strongest = Object.entries(scores4C).sort(([, a], [, b]) => b - a)[0];

  // ── Generate with AI ────────────────────────────────────

  const apiKey = process.env.GEMINI_API_KEY;
  const week = getWeekDates();

  // Default template plan (fallback if AI fails)
  const defaultItems = buildTemplatePlan(coupleId, '', weakest[0], strongest[0]);

  if (!apiKey) {
    // No API key — use smart template
    return await savePlan(supabase, coupleId, week, defaultItems, 'template', scores4C, myName, partnerName);
  }

  const ai = new GoogleGenAI({ apiKey });

  const prompt = `
Eres un coach de relaciones de pareja para "Relationship OS". Genera un plan semanal personalizado de 7 actividades diarias (lunes a domingo) para ${myName} y ${partnerName}.

DATOS DE LA PAREJA:
- Conexión: ${scores4C.conexion}/100
- Cuidado: ${scores4C.cuidado}/100
- Conflicto: ${scores4C.choque}/100
- Camino: ${scores4C.camino}/100
- Área más débil: ${LAYER_META[weakest[0]]?.label || weakest[0]} (${weakest[1]}/100)
- Área más fuerte: ${LAYER_META[strongest[0]]?.label || strongest[0]} (${strongest[1]}/100)
${risks.length > 0 ? `- Dimensiones con RIESGO: ${risks.map(r => `${r.label} (Δ${r.delta})`).join(', ')}` : ''}
${opportunities.length > 0 ? `- Dimensiones con OPORTUNIDAD: ${opportunities.map(o => o.label).join(', ')}` : ''}

Genera un JSON con esta estructura EXACTA:
{
  "activities": [
    {
      "day_of_week": 1,
      "day_label": "Lunes",
      "title": "Título corto y atractivo (máx 6 palabras)",
      "description": "Descripción clara de la actividad en 2-3 oraciones. Incluye instrucciones específicas de qué hacer.",
      "dimension": "conexion|cuidado|choque|camino",
      "activity_type": "conversacion|ritual|reto|reflexion|microaccion|check_in",
      "duration_minutes": 10,
      "difficulty": "easy|medium|deep",
      "requires_both": true
    }
  ]
}

REGLAS:
1. Exactamente 7 actividades, una por día (lun=1, dom=7).
2. Prioriza 2-3 actividades en el área MÁS DÉBIL de la pareja.
3. Incluye al menos 1 actividad que celebre el área más FUERTE.
${risks.length > 0 ? `4. Incluye al menos 1 actividad que aborde los riesgos: ${risks.map(r => r.label).join(', ')}.` : ''}
5. Alterna dificultades: comienza fácil (lun-mar), sube a medio (mié-jue), baja el viernes, sábado medium/deep, domingo fácil.
6. Varía los tipos de actividad: no repitas el mismo tipo consecutivamente.
7. duration_minutes realista: easy=5-15, medium=15-25, deep=25-45.
8. Usa los nombres (${myName} y ${partnerName}) en las descripciones.
9. NO uses formato markdown en las descripciones.
10. Escribe en español mexicano natural y cálido.
11. Las actividades "requires_both: false" son para que uno solo pueda hacer algo (reflexión personal, microacción sorpresa).
12. El check_in del domingo debe ser un cierre de semana: "¿Cómo nos fue esta semana?"
`;

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        temperature: 0.8,
      },
    });

    if (response.text) {
      const parsed = JSON.parse(response.text);

      if (Array.isArray(parsed.activities) && parsed.activities.length === 7) {
        const aiItems = parsed.activities.map((a: any) => ({
          couple_id: coupleId,
          day_of_week: a.day_of_week,
          day_label: a.day_label || DAY_LABELS[(a.day_of_week || 1) - 1],
          title: a.title,
          description: a.description,
          dimension: a.dimension || 'conexion',
          activity_type: a.activity_type || 'microaccion',
          duration_minutes: a.duration_minutes || 15,
          difficulty: a.difficulty || 'easy',
          requires_both: a.requires_both !== false,
          status: 'pending',
        }));

        return await savePlan(supabase, coupleId, week, aiItems, 'gemini-2.5-flash', scores4C, myName, partnerName);
      }
    }
  } catch (err) {
    console.error('AI plan generation error:', err);
  }

  // Fallback to template
  return await savePlan(supabase, coupleId, week, defaultItems, 'template-fallback', scores4C, myName, partnerName);
}

// ─── Save plan to DB ──────────────────────────────────────────

async function savePlan(
  supabase: Awaited<ReturnType<typeof createClient>>,
  coupleId: string,
  week: { weekStart: string; weekEnd: string },
  items: any[],
  model: string,
  scores4C: Record<string, number>,
  myName: string,
  partnerName: string
) {
  const admin = createAdminClient();

  // Delete any existing plan for the same week (handles regeneration)
  const { data: existingPlan } = await admin
    .from('weekly_plans')
    .select('id')
    .eq('couple_id', coupleId)
    .eq('week_start', week.weekStart)
    .single();

  if (existingPlan) {
    // Delete items first (FK dependency), then the plan
    await admin.from('weekly_plan_items').delete().eq('plan_id', existingPlan.id);
    await admin.from('weekly_plans').delete().eq('id', existingPlan.id);
  }

  // Insert the new plan (use admin to bypass RLS)
  const { data: plan, error: planError } = await admin
    .from('weekly_plans')
    .insert({
      couple_id: coupleId,
      week_start: week.weekStart,
      week_end: week.weekEnd,
      status: 'active',
      couple_status_snapshot: {
        scores4C,
        generated_for: [myName, partnerName],
        generated_at: new Date().toISOString(),
      },
      plan: { type: model === 'template' ? 'template' : 'ai-generated', version: '2.0' },
      ai_model_used: model,
      prompt_version: '2.0',
    })
    .select()
    .single();

  if (planError) {
    console.error('Error creating plan:', planError);
    throw new Error('Error al crear el plan: ' + planError.message);
  }

  // Attach plan_id to all items
  const planItems = items.map(item => ({ ...item, plan_id: plan.id }));

  // Insert items (use admin to bypass missing INSERT RLS policy)
  const { error: itemsError } = await admin
    .from('weekly_plan_items')
    .insert(planItems);

  if (itemsError) {
    console.error('Error creating plan items:', itemsError);
    throw new Error('Error al crear las actividades: ' + itemsError.message);
  }

  revalidatePath('/dashboard/plan');
  revalidatePath('/dashboard');

  return { success: true, planId: plan.id };
}

// ─── Smart template builder (fallback) ────────────────────────

function buildTemplatePlan(
  coupleId: string,
  planId: string,
  weakDim: string,
  strongDim: string
): any[] {
  return [
    {
      couple_id: coupleId,
      day_of_week: 1,
      day_label: 'Lunes',
      title: 'Check-in de apertura',
      description: 'Al empezar la semana, compartan: ¿Cómo llegas a esta semana? ¿Qué necesitas de mí? Solo escuchen, sin resolver nada.',
      dimension: 'conexion',
      activity_type: 'check_in',
      duration_minutes: 10,
      difficulty: 'easy',
      requires_both: true,
      status: 'pending',
    },
    {
      couple_id: coupleId,
      day_of_week: 2,
      day_label: 'Martes',
      title: 'Microacción sorpresa',
      description: 'Haz algo pequeño e inesperado por tu pareja hoy: un mensaje cariñoso, prepararle su café favorito, o dejarle una nota.',
      dimension: 'cuidado',
      activity_type: 'microaccion',
      duration_minutes: 10,
      difficulty: 'easy',
      requires_both: false,
      status: 'pending',
    },
    {
      couple_id: coupleId,
      day_of_week: 3,
      day_label: 'Miércoles',
      title: 'Conversación con profundidad',
      description: `Hablen sobre su área de crecimiento: ${LAYER_META[weakDim]?.label || weakDim}. Pregúntense: ¿Qué significa esta dimensión para cada uno? ¿Cómo podemos fortalecerla juntos?`,
      dimension: weakDim,
      activity_type: 'conversacion',
      duration_minutes: 20,
      difficulty: 'medium',
      requires_both: true,
      status: 'pending',
    },
    {
      couple_id: coupleId,
      day_of_week: 4,
      day_label: 'Jueves',
      title: 'Reflexión personal',
      description: 'Dedica 10 minutos a escribir: ¿Qué estoy haciendo bien en la relación? ¿Qué me gustaría cambiar de mi parte? No compartas todavía, solo reflexiona.',
      dimension: weakDim,
      activity_type: 'reflexion',
      duration_minutes: 10,
      difficulty: 'medium',
      requires_both: false,
      status: 'pending',
    },
    {
      couple_id: coupleId,
      day_of_week: 5,
      day_label: 'Viernes',
      title: 'Ritual de conexión',
      description: `Celebren su fortaleza: ${LAYER_META[strongDim]?.label || strongDim}. Pasen 30 minutos juntos haciendo algo que les recuerde por qué están juntos. Sin teléfonos.`,
      dimension: strongDim,
      activity_type: 'ritual',
      duration_minutes: 30,
      difficulty: 'easy',
      requires_both: true,
      status: 'pending',
    },
    {
      couple_id: coupleId,
      day_of_week: 6,
      day_label: 'Sábado',
      title: 'Reto de la semana',
      description: 'Elijan una actividad nueva que nunca hayan hecho juntos. Puede ser cocinar algo diferente, visitar un lugar nuevo, o aprender algo en equipo.',
      dimension: 'conexion',
      activity_type: 'reto',
      duration_minutes: 45,
      difficulty: 'medium',
      requires_both: true,
      status: 'pending',
    },
    {
      couple_id: coupleId,
      day_of_week: 7,
      day_label: 'Domingo',
      title: 'Check-in de cierre',
      description: 'Revisen la semana juntos: ¿Qué actividad nos acercó más? ¿Qué descubrimos? ¿Qué queremos repetir la próxima semana?',
      dimension: 'camino',
      activity_type: 'check_in',
      duration_minutes: 15,
      difficulty: 'easy',
      requires_both: true,
      status: 'pending',
    },
  ];
}
