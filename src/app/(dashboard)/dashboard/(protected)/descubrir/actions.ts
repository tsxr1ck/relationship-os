'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { GoogleGenAI } from '@google/genai';

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

export interface DimensionComparison {
  dimension: string;
  label: string;
  color: string;
  icon: string;
  myScore: number;
  partnerScore: number;
  difference: number;
  alignment: 'strong' | 'moderate' | 'divergent';
  insight: string; // AI-generated
}

export interface ComparativeResults {
  myName: string;
  partnerName: string;
  overallAlignment: number; // 0-100
  overallInsight: string; // AI-generated summary
  dimensions: DimensionComparison[];
  strengths: string[];
  growthAreas: string[];
  actionItems: string[]; // AI-generated action items
}

export interface PersonalInsights {
  userName: string;
  summary: string; // Overall personal coaching paragraph
  dimensions: {
    slug: string;
    label: string;
    icon: string;
    color: string;
    score: number;
    coaching: string; // Private coaching text
  }[];
  practices: string[]; // Individual action items
}

const DIMENSION_META: Record<string, { label: string; color: string; icon: string }> = {
  conexion: { label: 'Conexión Emocional', color: 'conexion', icon: '💜' },
  cuidado: { label: 'Cuidado Mutuo', color: 'cuidado', icon: '💚' },
  choque: { label: 'Gestión del Conflicto', color: 'choque', icon: '⚡' },
  camino: { label: 'Proyecto de Vida', color: 'camino', icon: '🧭' },
};

/**
 * Compute dimension scores from V2 generated assessment responses.
 * Uses generated_assessment_items.target_dimension directly instead of legacy section mapping.
 */
async function computeScoresV2(
  userId: string,
  coupleId: string,
  admin: ReturnType<typeof createAdminClient>
): Promise<Record<string, number>> {
  // Find the user's completed V2 session
  const { data: session } = await admin
    .from('response_sessions')
    .select('id')
    .eq('user_id', userId)
    .eq('status', 'completed')
    .eq('stage', 'couple_v2')
    .order('completed_at', { ascending: false })
    .limit(1)
    .single();

  if (!session) {
    // Fallback: try any completed session
    const { data: anySession } = await admin
      .from('response_sessions')
      .select('id')
      .eq('user_id', userId)
      .eq('status', 'completed')
      .order('completed_at', { ascending: false })
      .limit(1)
      .single();

    if (!anySession) return { conexion: 0.5, cuidado: 0.5, choque: 0.5, camino: 0.5 };
    return computeFromSession(anySession.id, coupleId, admin);
  }

  return computeFromSession(session.id, coupleId, admin);
}

async function computeFromSession(
  sessionId: string,
  coupleId: string,
  admin: ReturnType<typeof createAdminClient>
): Promise<Record<string, number>> {
  // Fetch responses
  const { data: responses } = await admin
    .from('responses')
    .select('question_id, answer_value')
    .eq('session_id', sessionId);

  if (!responses || responses.length === 0) {
    return { conexion: 0.5, cuidado: 0.5, choque: 0.5, camino: 0.5 };
  }

  // Get the couple's generated assessment to map question_ids → dimensions
  const { data: assessment } = await admin
    .from('generated_assessments')
    .select('id')
    .eq('couple_id', coupleId)
    .order('created_at', { ascending: false })
    .limit(1)
    .single();

  if (!assessment) return { conexion: 0.5, cuidado: 0.5, choque: 0.5, camino: 0.5 };

  // Fetch generated items for dimension mapping
  const { data: items } = await admin
    .from('generated_assessment_items')
    .select('item_bank_id, target_dimension, question_type')
    .eq('assessment_id', assessment.id);

  // Build lookup: item_bank_id → { dimension, type }
  const itemMeta: Record<string, { dimension: string; type: string }> = {};
  (items || []).forEach(item => {
    if (item.item_bank_id) {
      itemMeta[item.item_bank_id] = {
        dimension: item.target_dimension || 'conexion',
        type: item.question_type || 'LIKERT-5',
      };
    }
  });

  const scoreMap: Record<string, number[]> = {
    conexion: [], cuidado: [], choque: [], camino: [],
  };

  responses.forEach(r => {
    const meta = itemMeta[r.question_id];
    if (!meta || !scoreMap[meta.dimension]) return;

    let val: number;
    if (typeof r.answer_value === 'object' && r.answer_value !== null) {
      val = parseFloat(r.answer_value.value);
    } else {
      val = parseFloat(r.answer_value);
    }
    if (isNaN(val)) return;

    const scale = meta.type === 'LIKERT-7' ? 7 : 5;
    const normalized = val / scale;
    scoreMap[meta.dimension].push(normalized);
  });

  const avg = (arr: number[]) =>
    arr.length > 0 ? arr.reduce((a, b) => a + b, 0) / arr.length : 0.5;

  return {
    conexion: Math.round(avg(scoreMap.conexion) * 100) / 100,
    cuidado: Math.round(avg(scoreMap.cuidado) * 100) / 100,
    choque: Math.round(avg(scoreMap.choque) * 100) / 100,
    camino: Math.round(avg(scoreMap.camino) * 100) / 100,
  };
}

function getAlignmentLevel(diff: number): 'strong' | 'moderate' | 'divergent' {
  if (diff <= 0.15) return 'strong';
  if (diff <= 0.30) return 'moderate';
  return 'divergent';
}

/**
 * Generate AI-powered insights for the couple's comparative results.
 * Caches results in couple_insights table.
 */
async function generateAIInsights(
  coupleId: string,
  myName: string,
  partnerName: string,
  myScores: Record<string, number>,
  partnerScores: Record<string, number>,
  admin: ReturnType<typeof createAdminClient>
): Promise<{
  dimensionInsights: Record<string, string>;
  overallInsight: string;
  actionItems: string[];
}> {
  // Check cache first
  const { data: cached } = await admin
    .from('couple_insights')
    .select('insight_type, dimension_slug, body')
    .eq('couple_id', coupleId)
    .order('created_at', { ascending: false });

  if (cached && cached.length >= 5) {
    // We have cached insights — use them
    const dimensionInsights: Record<string, string> = {};
    let overallInsight = '';
    const actionItems: string[] = [];

    cached.forEach(row => {
      if (row.insight_type === 'dimension_insight' && row.dimension_slug) {
        dimensionInsights[row.dimension_slug] = row.body;
      } else if (row.insight_type === 'comparative_summary') {
        overallInsight = row.body;
      } else if (row.insight_type === 'action_item') {
        actionItems.push(row.body);
      }
    });

    if (overallInsight && Object.keys(dimensionInsights).length >= 4) {
      return { dimensionInsights, overallInsight, actionItems };
    }
  }

  // Generate fresh insights with Gemini
  const prompt = `
Actúa como un psicólogo de parejas experto. Analiza los resultados comparativos de esta pareja y genera insights personalizados en español.

RESULTADOS (escala 0-1, donde 1 es lo más positivo):

${myName}:
- Conexión Emocional: ${myScores.conexion}
- Cuidado Mutuo: ${myScores.cuidado}  
- Gestión del Conflicto: ${myScores.choque}
- Proyecto de Vida: ${myScores.camino}

${partnerName}:
- Conexión Emocional: ${partnerScores.conexion}
- Cuidado Mutuo: ${partnerScores.cuidado}
- Gestión del Conflicto: ${partnerScores.choque}
- Proyecto de Vida: ${partnerScores.camino}

Genera un JSON con exactamente esta estructura:
{
  "overallInsight": "Un párrafo de 2-3 oraciones sobre el estado general de la relación. Sé cálido pero honesto.",
  "conexion": "Un insight específico de 2 oraciones sobre la conexión emocional de esta pareja.",
  "cuidado": "Un insight específico de 2 oraciones sobre el cuidado mutuo.",
  "choque": "Un insight específico de 2 oraciones sobre cómo manejan los conflictos.",
  "camino": "Un insight específico de 2 oraciones sobre su proyecto de vida conjunto.",
  "actionItems": ["3 acciones concretas y prácticas que pueden implementar esta semana"]
}

REGLAS:
- Usa los nombres reales (${myName} y ${partnerName}) en los insights
- Sé empático y constructivo, nunca alarmista
- Las acciones deben ser específicas y realizables (no genéricas)
- NO uses formato markdown (no asteriscos, no negritas). Usa texto plano.
- Escribe en español mexicano natural
`;

  const defaultInsights = {
    dimensionInsights: {
      conexion: `${myName} y ${partnerName} tienen perspectivas distintas sobre su conexión emocional. Explorar qué significa intimidad para cada uno puede abrir nuevas puertas.`,
      cuidado: 'El cuidado mutuo es un pilar importante. Reflexionen sobre cómo cada uno expresa y recibe cuidado en el día a día.',
      choque: 'Los conflictos son naturales en toda relación. Lo importante es cómo los navegan juntos y cómo se reparan después.',
      camino: 'Tener una visión compartida del futuro fortalece la relación. Dediquen tiempo a conversar sobre sus sueños y prioridades.',
    },
    overallInsight: `${myName} y ${partnerName} están en un momento interesante de su relación. Sus resultados muestran áreas de fortaleza y oportunidades de crecimiento que, al trabajarlas juntos, pueden profundizar su vínculo.`,
    actionItems: [
      'Dediquen 15 minutos esta semana a una conversación sin pantallas sobre cómo se sienten en la relación.',
      'Cada uno escriba 3 cosas que aprecia del otro y compártanlas en persona.',
      'Elijan un tema donde no estén alineados y practiquen escucharse sin interrumpir.',
    ],
  };

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        temperature: 0.7,
      }
    });

    if (response.text) {
      const parsed = JSON.parse(response.text);

      const result = {
        dimensionInsights: {
          conexion: parsed.conexion || defaultInsights.dimensionInsights.conexion,
          cuidado: parsed.cuidado || defaultInsights.dimensionInsights.cuidado,
          choque: parsed.choque || defaultInsights.dimensionInsights.choque,
          camino: parsed.camino || defaultInsights.dimensionInsights.camino,
        },
        overallInsight: parsed.overallInsight || defaultInsights.overallInsight,
        actionItems: Array.isArray(parsed.actionItems) ? parsed.actionItems : defaultInsights.actionItems,
      };

      // Cache in DB (fire and forget)
      const insightsToInsert = [
        {
          couple_id: coupleId,
          insight_type: 'comparative_summary',
          dimension_slug: null,
          title: 'Resumen Comparativo',
          body: result.overallInsight,
          metadata: { myScores, partnerScores },
        },
        ...Object.entries(result.dimensionInsights).map(([dim, text]) => ({
          couple_id: coupleId,
          insight_type: 'dimension_insight' as const,
          dimension_slug: dim,
          title: DIMENSION_META[dim]?.label || dim,
          body: text,
          metadata: { myScore: myScores[dim], partnerScore: partnerScores[dim] },
        })),
        ...result.actionItems.map((item: string) => ({
          couple_id: coupleId,
          insight_type: 'action_item' as const,
          dimension_slug: null,
          title: 'Acción Sugerida',
          body: item,
          metadata: {},
        })),
      ];

      // Clear old insights for this couple before inserting new ones
      await admin.from('couple_insights').delete().eq('couple_id', coupleId);
      await admin.from('couple_insights').insert(insightsToInsert);

      return result;
    }
  } catch (err) {
    console.error('AI insight generation error:', err);
  }

  return defaultInsights;
}

export async function getComparativeResults(): Promise<ComparativeResults | null> {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();

  if (!user || authError) return null;

  const admin = createAdminClient();

  // Get couple membership
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return null;

  // Get partner
  const { data: members } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', membership.couple_id)
    .neq('user_id', user.id);

  if (!members || members.length === 0) return null;
  const partnerId = members[0].user_id;

  // Check both completed
  const { data: mySession } = await admin
    .from('response_sessions')
    .select('id')
    .eq('user_id', user.id)
    .eq('status', 'completed')
    .limit(1)
    .single();

  const { data: partnerSession } = await admin
    .from('response_sessions')
    .select('id')
    .eq('user_id', partnerId)
    .eq('status', 'completed')
    .limit(1)
    .single();

  if (!mySession || !partnerSession) return null;

  // Get names
  const { data: myProfile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const { data: partnerProfile } = await admin
    .from('profiles')
    .select('full_name')
    .eq('id', partnerId)
    .single();

  const myName = myProfile?.full_name || 'Yo';
  const partnerName = partnerProfile?.full_name || 'Mi pareja';

  // Compute scores using V2 logic
  const [myScores, partnerScores] = await Promise.all([
    computeScoresV2(user.id, membership.couple_id, admin),
    computeScoresV2(partnerId, membership.couple_id, admin),
  ]);

  // Generate AI insights (cached)
  const aiInsights = await generateAIInsights(
    membership.couple_id,
    myName,
    partnerName,
    myScores,
    partnerScores,
    admin
  );

  // Build dimension comparisons with AI insights
  const dimensions: DimensionComparison[] = Object.entries(DIMENSION_META).map(
    ([key, meta]) => {
      const myScore = myScores[key] || 0.5;
      const partnerScore = partnerScores[key] || 0.5;
      const difference = Math.abs(myScore - partnerScore);

      return {
        dimension: key,
        label: meta.label,
        color: meta.color,
        icon: meta.icon,
        myScore,
        partnerScore,
        difference,
        alignment: getAlignmentLevel(difference),
        insight: aiInsights.dimensionInsights[key] || 'Explorar esta dimensión juntos puede fortalecer su relación.',
      };
    }
  );

  // Overall alignment (inverse of average difference)
  const avgDiff = dimensions.reduce((a, d) => a + d.difference, 0) / dimensions.length;
  const overallAlignment = Math.round((1 - avgDiff) * 100);

  // Strengths & growth areas
  const sorted = [...dimensions].sort((a, b) => a.difference - b.difference);
  const strengths = sorted
    .filter((d) => d.alignment === 'strong')
    .map((d) => d.label);
  const growthAreas = sorted
    .filter((d) => d.alignment !== 'strong')
    .sort((a, b) => b.difference - a.difference)
    .map((d) => d.label);

  return {
    myName,
    partnerName,
    overallAlignment,
    overallInsight: aiInsights.overallInsight,
    dimensions,
    strengths,
    growthAreas,
    actionItems: aiInsights.actionItems,
  };
}

/**
 * Generate PRIVATE personal insights for the current user.
 * The AI sees both scores for context, but output is framed
 * entirely around the individual — the partner's raw scores
 * are NEVER exposed to the user.
 */
export async function getPersonalInsights(): Promise<PersonalInsights | null> {
  const supabase = await createClient();
  const { data: { user }, error: authError } = await supabase.auth.getUser();
  if (!user || authError) return null;

  const admin = createAdminClient();

  // Get couple
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) return null;

  // Get partner ID
  const { data: members } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', membership.couple_id)
    .neq('user_id', user.id);

  const partnerId = members?.[0]?.user_id;

  // Get my name
  const { data: myProfile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const userName = myProfile?.full_name || 'Tú';

  // Compute my scores
  const myScores = await computeScoresV2(user.id, membership.couple_id, admin);

  // Compute partner scores (used for context only, never exposed)
  let partnerScores: Record<string, number> = { conexion: 0.5, cuidado: 0.5, choque: 0.5, camino: 0.5 };
  if (partnerId) {
    partnerScores = await computeScoresV2(partnerId, membership.couple_id, admin);
  }

  // Check cache in ai_insights
  const { data: cached } = await admin
    .from('ai_insights')
    .select('dimension_slug, insight_text')
    .eq('user_id', user.id)
    .eq('couple_id', membership.couple_id)
    .order('created_at', { ascending: false });

  if (cached && cached.length >= 5) {
    // Rebuild from cache
    const summaryRow = cached.find(r => r.dimension_slug === '_summary');
    const practiceRows = cached.filter(r => r.dimension_slug === '_practice');
    const dimRows = cached.filter(r => r.dimension_slug && !r.dimension_slug.startsWith('_'));

    if (summaryRow && dimRows.length >= 4) {
      return {
        userName,
        summary: summaryRow.insight_text,
        dimensions: Object.entries(DIMENSION_META).map(([slug, meta]) => {
          const row = dimRows.find(r => r.dimension_slug === slug);
          return {
            slug,
            label: meta.label,
            icon: meta.icon,
            color: meta.color,
            score: myScores[slug] || 0.5,
            coaching: row?.insight_text || 'Reflexiona sobre esta área de tu relación.',
          };
        }),
        practices: practiceRows.map(r => r.insight_text),
      };
    }
  }

  // Generate fresh with Gemini
  const prompt = `
Actúa como un coach de relaciones personal y empático. Genera insights PRIVADOS para ${userName}.

CONTEXTO: ${userName} y su pareja completaron una evaluación de relación.

Puntuaciones de ${userName} (escala 0-1, 1 = más positivo):
- Conexión Emocional: ${myScores.conexion}
- Cuidado Mutuo: ${myScores.cuidado}
- Gestión del Conflicto: ${myScores.choque}
- Proyecto de Vida: ${myScores.camino}

Dinámica de la relación (NO MENCIONES estos datos explícitamente):
- Alineación en conexión: ${getAlignmentLevel(Math.abs(myScores.conexion - partnerScores.conexion))}
- Alineación en cuidado: ${getAlignmentLevel(Math.abs(myScores.cuidado - partnerScores.cuidado))}
- Alineación en choque: ${getAlignmentLevel(Math.abs(myScores.choque - partnerScores.choque))}
- Alineación en camino: ${getAlignmentLevel(Math.abs(myScores.camino - partnerScores.camino))}

Genera un JSON:
{
  "summary": "2-3 oraciones de coaching personal para ${userName}. Habla en segunda persona (tú). Sé cálido y directo.",
  "conexion": "2 oraciones de coaching personal sobre conexión emocional. Enfócate en lo que ${userName} puede hacer.",
  "cuidado": "2 oraciones de coaching personal sobre cuidado mutuo.",
  "choque": "2 oraciones de coaching personal sobre manejo de conflictos.",
  "camino": "2 oraciones de coaching personal sobre proyecto de vida.",
  "practices": ["3 prácticas personales concretas que ${userName} puede hacer individualmente esta semana para mejorar la relación"]
}

REGLAS CRÍTICAS:
- Habla SOLO con ${userName}, en segunda persona (tú)
- NUNCA reveles las puntuaciones de la pareja ni menciones diferencias numéricas
- Puedes hacer referencia sutil a la dinámica ("parece haber espacio para alinearse más") sin dar datos
- Las prácticas deben ser individuales, algo que ${userName} puede hacer por su cuenta
- NO uses formato markdown (no asteriscos, no negritas). Usa texto plano.
- Escribe en español mexicano natural y empático
`;

  const defaultResult: PersonalInsights = {
    userName,
    summary: `${userName}, tus resultados muestran que tienes una base sólida para seguir creciendo en tu relación. Cada dimensión ofrece una oportunidad única de profundizar tu conexión.`,
    dimensions: Object.entries(DIMENSION_META).map(([slug, meta]) => ({
      slug,
      label: meta.label,
      icon: meta.icon,
      color: meta.color,
      score: myScores[slug] || 0.5,
      coaching: 'Reflexiona sobre qué acciones puedes tomar para fortalecer esta área.',
    })),
    practices: [
      'Dedica 10 minutos al día a escuchar activamente a tu pareja sin distracciones.',
      'Escribe en un cuaderno una cosa que aprecias de tu relación cada noche.',
      'Practica expresar una necesidad de forma clara y amable esta semana.',
    ],
  };

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        temperature: 0.7,
      }
    });

    if (response.text) {
      const parsed = JSON.parse(response.text);

      const result: PersonalInsights = {
        userName,
        summary: parsed.summary || defaultResult.summary,
        dimensions: Object.entries(DIMENSION_META).map(([slug, meta]) => ({
          slug,
          label: meta.label,
          icon: meta.icon,
          color: meta.color,
          score: myScores[slug] || 0.5,
          coaching: parsed[slug] || defaultResult.dimensions.find(d => d.slug === slug)?.coaching || '',
        })),
        practices: Array.isArray(parsed.practices) ? parsed.practices : defaultResult.practices,
      };

      // Cache in ai_insights (fire and forget)
      await admin.from('ai_insights').delete()
        .eq('user_id', user.id)
        .eq('couple_id', membership.couple_id);

      const rows = [
        {
          user_id: user.id,
          couple_id: membership.couple_id,
          dimension_slug: '_summary',
          insight_text: result.summary,
        },
        ...result.dimensions.map(d => ({
          user_id: user.id,
          couple_id: membership.couple_id,
          dimension_slug: d.slug,
          insight_text: d.coaching,
        })),
        ...result.practices.map(p => ({
          user_id: user.id,
          couple_id: membership.couple_id,
          dimension_slug: '_practice',
          insight_text: p,
        })),
      ];

      await admin.from('ai_insights').insert(rows);

      return result;
    }
  } catch (err) {
    console.error('Personal insight generation error:', err);
  }

  return defaultResult;
}
