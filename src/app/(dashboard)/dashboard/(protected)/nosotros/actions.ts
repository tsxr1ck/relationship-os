'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { GoogleGenAI } from '@google/genai';
import { V2_DIMENSION_MAP } from '@/lib/scoring';

// ─── Types ────────────────────────────────────────────────────

export interface NosotrosDimension {
  slug: string;
  label: string;
  layer: 'conexion' | 'cuidado' | 'choque' | 'camino';
  myScore: number;           // 0-100
  partnerScore: number | null; // 0-100, null if partner hasn't finished
  mismatchDelta: number | null;
  riskFlag: boolean;
  opportunityFlag: boolean;
  coaching: string | null;   // AI text from ai_insights
}

export interface LayerSummary {
  layer: string;
  label: string;
  icon: string;
  avgMyScore: number;
  avgPartnerScore: number | null;
  dimensionCount: number;
  aiSummary: string | null;
}

export interface NosotrosNarrative {
  relationshipStory: string | null;
  layerSummaries: Record<string, string>;
  growthTips: string[];
}

export interface NosotrosData {
  myName: string;
  partnerName: string | null;
  coupleId: string | null;
  relationshipDuration: string | null;
  overallHealth: number;         // 0-100
  hasPartner: boolean;
  partnerCompleted: boolean;
  dimensions: NosotrosDimension[];
  layers: LayerSummary[];
  narrative: NosotrosNarrative;
}

// ─── Constants ────────────────────────────────────────────────

const LAYER_META: Record<string, { label: string; icon: string }> = {
  conexion: { label: 'Conexión', icon: '💜' },
  cuidado: { label: 'Cuidado', icon: '💚' },
  choque:  { label: 'Conflicto', icon: '⚡' },
  camino:  { label: 'Camino', icon: '🧭' },
};

function getRelativeDuration(dateStr: string): string {
  const created = new Date(dateStr);
  const now = new Date();
  const diffMs = now.getTime() - created.getTime();
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

  if (diffDays < 7) return `${diffDays} días juntos`;
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} semanas juntos`;
  if (diffDays < 365) return `${Math.floor(diffDays / 30)} meses juntos`;
  const years = Math.floor(diffDays / 365);
  const months = Math.floor((diffDays % 365) / 30);
  return months > 0
    ? `${years} año${years > 1 ? 's' : ''} y ${months} mes${months > 1 ? 'es' : ''}`
    : `${years} año${years > 1 ? 's' : ''}`;
}

// ─── Main data loader ─────────────────────────────────────────

export async function getNosotrosData(): Promise<NosotrosData> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const admin = createAdminClient();

  // ── User profile
  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const myName = profile?.full_name || 'Tú';

  // ── Couple membership
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  let partnerName: string | null = null;
  let coupleId: string | null = null;
  let relationshipDuration: string | null = null;
  let hasPartner = false;
  let partnerCompleted = false;
  let partnerId: string | null = null;

  if (membership) {
    coupleId = membership.couple_id;

    // Couple info
    const { data: coupleData } = await supabase
      .from('couples')
      .select('created_at')
      .eq('id', coupleId)
      .single();

    if (coupleData) {
      relationshipDuration = getRelativeDuration(coupleData.created_at);
    }

    // Partner
    const { data: members } = await admin
      .from('couple_members')
      .select('user_id')
      .eq('couple_id', coupleId)
      .neq('user_id', user.id);

    if (members && members.length > 0) {
      partnerId = members[0].user_id;
      hasPartner = true;

      const { data: partnerProfile } = await admin
        .from('profiles')
        .select('full_name')
        .eq('id', partnerId)
        .single();

      partnerName = partnerProfile?.full_name || 'Tu pareja';

      // Check if partner completed
      const { data: partnerSession } = await admin
        .from('response_sessions')
        .select('id')
        .eq('user_id', partnerId)
        .eq('status', 'completed')
        .limit(1)
        .single();

      partnerCompleted = !!partnerSession;
    }
  }

  // ── My profile vectors
  const { data: myVectors } = await supabase
    .from('profile_vectors')
    .select('dimension_slug, normalized_score')
    .eq('user_id', user.id);

  const myVectorMap: Record<string, number> = {};
  (myVectors || []).forEach(v => {
    myVectorMap[v.dimension_slug] = v.normalized_score;
  });

  // ── Partner profile vectors (via admin)
  const partnerVectorMap: Record<string, number> = {};
  if (partnerId && partnerCompleted) {
    const { data: partnerVectors } = await admin
      .from('profile_vectors')
      .select('dimension_slug, normalized_score')
      .eq('user_id', partnerId);

    (partnerVectors || []).forEach(v => {
      partnerVectorMap[v.dimension_slug] = v.normalized_score;
    });
  }

  // ── Couple vectors (mismatch deltas)
  const coupleVectorMap: Record<string, { delta: number; risk: boolean; opportunity: boolean }> = {};
  if (coupleId) {
    const { data: coupleVectors } = await admin
      .from('couple_vectors')
      .select('dimension_slug, mismatch_delta, risk_flag, opportunity_flag')
      .eq('couple_id', coupleId);

    (coupleVectors || []).forEach(v => {
      coupleVectorMap[v.dimension_slug] = {
        delta: v.mismatch_delta,
        risk: v.risk_flag,
        opportunity: v.opportunity_flag,
      };
    });
  }

  // ── Cached AI coaching from ai_insights
  const coachingMap: Record<string, string> = {};
  if (coupleId) {
    const { data: cached } = await admin
      .from('ai_insights')
      .select('dimension_slug, insight_text')
      .eq('user_id', user.id)
      .eq('couple_id', coupleId);

    (cached || []).forEach(r => {
      if (r.dimension_slug && !r.dimension_slug.startsWith('_')) {
        coachingMap[r.dimension_slug] = r.insight_text;
      }
    });
  }

  // ── Build dimensions from V2_DIMENSION_MAP
  const dimensions: NosotrosDimension[] = Object.entries(V2_DIMENSION_MAP).map(
    ([slug, meta]) => {
      const myScore = myVectorMap[slug] ?? 50;
      const partnerScore = partnerCompleted ? (partnerVectorMap[slug] ?? null) : null;
      const cv = coupleVectorMap[slug];

      return {
        slug,
        label: meta.label,
        layer: meta.layer,
        myScore,
        partnerScore,
        mismatchDelta: cv?.delta ?? null,
        riskFlag: cv?.risk ?? false,
        opportunityFlag: cv?.opportunity ?? false,
        coaching: coachingMap[slug] ?? null,
      };
    }
  );

  // ── Build layer summaries
  const layerGroups: Record<string, NosotrosDimension[]> = {};
  dimensions.forEach(d => {
    if (!layerGroups[d.layer]) layerGroups[d.layer] = [];
    layerGroups[d.layer].push(d);
  });

  // Fetch cached layer summaries from nosotros_narratives
  const layerSummaryMap: Record<string, string> = {};
  if (coupleId) {
    const { data: layerNarratives } = await admin
      .from('nosotros_narratives')
      .select('dimension_slug, body')
      .eq('couple_id', coupleId)
      .eq('narrative_type', 'layer_summary');

    (layerNarratives || []).forEach(n => {
      if (n.dimension_slug) layerSummaryMap[n.dimension_slug] = n.body;
    });
  }

  const layers: LayerSummary[] = ['conexion', 'cuidado', 'choque', 'camino'].map(layer => {
    const dims = layerGroups[layer] || [];
    const avg = (arr: number[]) =>
      arr.length > 0 ? Math.round(arr.reduce((a, b) => a + b, 0) / arr.length) : 50;

    return {
      layer,
      label: LAYER_META[layer].label,
      icon: LAYER_META[layer].icon,
      avgMyScore: avg(dims.map(d => d.myScore)),
      avgPartnerScore: partnerCompleted
        ? avg(dims.filter(d => d.partnerScore !== null).map(d => d.partnerScore!))
        : null,
      dimensionCount: dims.length,
      aiSummary: layerSummaryMap[layer] ?? null,
    };
  });

  // ── Overall health: average of my layer scores
  const overallHealth = Math.round(
    layers.reduce((a, l) => a + l.avgMyScore, 0) / layers.length
  );

  // ── Cached narratives
  let relationshipStory: string | null = null;
  const growthTips: string[] = [];

  if (coupleId) {
    const { data: narrativeRows } = await admin
      .from('nosotros_narratives')
      .select('narrative_type, dimension_slug, body')
      .eq('couple_id', coupleId);

    (narrativeRows || []).forEach(n => {
      if (n.narrative_type === 'relationship_story') {
        relationshipStory = n.body;
      } else if (n.narrative_type === 'growth_tip') {
        growthTips.push(n.body);
      }
    });
  }

  return {
    myName,
    partnerName,
    coupleId,
    relationshipDuration,
    overallHealth,
    hasPartner,
    partnerCompleted,
    dimensions,
    layers,
    narrative: {
      relationshipStory,
      layerSummaries: layerSummaryMap,
      growthTips,
    },
  };
}

// ─── AI: Generate relationship narrative ──────────────────────

export async function generateNosotrosNarrative(
  forceRefresh: boolean = false
): Promise<{
  relationshipStory: string;
  layerSummaries: Record<string, string>;
  growthTips: string[];
  error?: string;
}> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { relationshipStory: '', layerSummaries: {}, growthTips: [], error: 'No autorizado' };

  const admin = createAdminClient();

  // Get couple
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  if (!membership) {
    return { relationshipStory: '', layerSummaries: {}, growthTips: [], error: 'No tienes pareja vinculada.' };
  }

  const coupleId = membership.couple_id;

  // Check cache if not forcing
  if (!forceRefresh) {
    const { data: cached } = await admin
      .from('nosotros_narratives')
      .select('narrative_type, dimension_slug, body')
      .eq('couple_id', coupleId);

    if (cached && cached.length >= 5) {
      const story = cached.find(r => r.narrative_type === 'relationship_story');
      const layerRows = cached.filter(r => r.narrative_type === 'layer_summary');
      const tipRows = cached.filter(r => r.narrative_type === 'growth_tip');

      if (story && layerRows.length >= 4) {
        const layerSummaries: Record<string, string> = {};
        layerRows.forEach(r => { if (r.dimension_slug) layerSummaries[r.dimension_slug] = r.body; });
        return {
          relationshipStory: story.body,
          layerSummaries,
          growthTips: tipRows.map(r => r.body),
        };
      }
    }
  }

  // Fetch data for AI prompt
  const { data: myProfile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const myName = myProfile?.full_name || 'Tú';

  // Get partner
  const { data: members } = await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', coupleId)
    .neq('user_id', user.id);

  const partnerId = members?.[0]?.user_id;
  let partnerName = 'Tu pareja';
  if (partnerId) {
    const { data: pp } = await admin.from('profiles').select('full_name').eq('id', partnerId).single();
    partnerName = pp?.full_name || 'Tu pareja';
  }

  // Fetch vectors
  const { data: myVectors } = await supabase
    .from('profile_vectors')
    .select('dimension_slug, normalized_score')
    .eq('user_id', user.id);

  const myScores: Record<string, number> = {};
  (myVectors || []).forEach(v => { myScores[v.dimension_slug] = v.normalized_score; });

  const partnerScores: Record<string, number> = {};
  if (partnerId) {
    const { data: pv } = await admin
      .from('profile_vectors')
      .select('dimension_slug, normalized_score')
      .eq('user_id', partnerId);
    (pv || []).forEach(v => { partnerScores[v.dimension_slug] = v.normalized_score; });
  }

  // Couple vectors
  const { data: coupleVectors } = await admin
    .from('couple_vectors')
    .select('dimension_slug, mismatch_delta, risk_flag, opportunity_flag')
    .eq('couple_id', coupleId);

  const risks = (coupleVectors || []).filter(v => v.risk_flag).map(v => v.dimension_slug);
  const opportunities = (coupleVectors || []).filter(v => v.opportunity_flag).map(v => v.dimension_slug);

  // Build 4C averages
  const layerAvg = (layer: string, scores: Record<string, number>) => {
    const dims = Object.entries(V2_DIMENSION_MAP).filter(([, m]) => m.layer === layer);
    const vals = dims.map(([slug]) => scores[slug] ?? 50);
    return vals.length > 0 ? Math.round(vals.reduce((a, b) => a + b, 0) / vals.length) : 50;
  };

  const my4C = {
    conexion: layerAvg('conexion', myScores),
    cuidado: layerAvg('cuidado', myScores),
    choque: layerAvg('choque', myScores),
    camino: layerAvg('camino', myScores),
  };

  const partner4C = partnerId ? {
    conexion: layerAvg('conexion', partnerScores),
    cuidado: layerAvg('cuidado', partnerScores),
    choque: layerAvg('choque', partnerScores),
    camino: layerAvg('camino', partnerScores),
  } : null;

  // Default fallbacks
  const defaults = {
    relationshipStory: `${myName} y ${partnerName} están construyendo una relación con base sólida. Sus resultados muestran fortalezas reales y áreas donde pueden crecer juntos con intención y diálogo.`,
    layerSummaries: {
      conexion: 'Su conexión emocional es un pilar importante de su relación. Cultívenla con momentos de intimidad y curiosidad mutua.',
      cuidado: 'El cuidado mutuo se expresa de distintas formas. Reconocer y apreciar los gestos del otro fortalece el vínculo.',
      choque: 'Los conflictos son naturales. Lo que marca la diferencia es cómo los navegan y se reparan después de una discusión.',
      camino: 'Tener una visión compartida del futuro requiere conversaciones abiertas sobre metas, finanzas y prioridades.',
    },
    growthTips: [
      'Dediquen 15 minutos esta semana a una conversación sin pantallas sobre cómo se sienten.',
      'Cada uno escriba 3 cosas que aprecia del otro y compártanlas en persona.',
      'Elijan un tema donde no estén alineados y practiquen escucharse sin interrumpir.',
    ],
  };

  // Call Gemini
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    return { ...defaults, error: 'Falta GEMINI_API_KEY' };
  }

  const ai = new GoogleGenAI({ apiKey });

  const prompt = `
Actúa como un psicólogo de parejas experto para "Relationship OS".

PAREJA: ${myName} y ${partnerName}

PUNTUACIONES DE ${myName} (escala 0-100):
- Conexión: ${my4C.conexion}
- Cuidado: ${my4C.cuidado}
- Conflicto: ${my4C.choque}
- Camino: ${my4C.camino}

${partner4C ? `PUNTUACIONES DE ${partnerName} (escala 0-100):
- Conexión: ${partner4C.conexion}
- Cuidado: ${partner4C.cuidado}
- Conflicto: ${partner4C.choque}
- Camino: ${partner4C.camino}` : `(${partnerName} aún no ha completado la evaluación)`}

${risks.length > 0 ? `ÁREAS DE RIESGO: ${risks.map(r => V2_DIMENSION_MAP[r]?.label || r).join(', ')}` : ''}
${opportunities.length > 0 ? `ÁREAS DE OPORTUNIDAD: ${opportunities.map(o => V2_DIMENSION_MAP[o]?.label || o).join(', ')}` : ''}

Genera un JSON con EXACTAMENTE esta estructura:
{
  "relationshipStory": "Una narrativa de 3-4 oraciones sobre la relación de ${myName} y ${partnerName}. Habla sobre sus dinámicas, fortalezas únicas, y lo que los hace especiales como pareja. Usa sus nombres. Sé poético pero concreto.",
  "conexion": "2-3 oraciones sobre cómo viven la Conexión emocional como pareja.",
  "cuidado": "2-3 oraciones sobre cómo se cuidan mutuamente.",
  "choque": "2-3 oraciones sobre cómo manejan los conflictos y tensiones.",
  "camino": "2-3 oraciones sobre su proyecto de vida y visión compartida.",
  "growthTips": ["Exactamente 3 acciones concretas y prácticas que pueden hacer esta semana como pareja. Deben ser específicas, no genéricas."]
}

REGLAS:
- NO uses formato markdown (sin asteriscos, sin negritas, sin viñetas).
- Escribe en español mexicano natural, cálido y empático.
- Usa los nombres reales de la pareja.
- Las acciones deben ser realizables esta semana.
- Sé esperanzador pero honesto sobre las áreas de crecimiento.
`;

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        temperature: 0.7,
      },
    });

    if (response.text) {
      const parsed = JSON.parse(response.text);

      const result = {
        relationshipStory: parsed.relationshipStory || defaults.relationshipStory,
        layerSummaries: {
          conexion: parsed.conexion || defaults.layerSummaries.conexion,
          cuidado: parsed.cuidado || defaults.layerSummaries.cuidado,
          choque: parsed.choque || defaults.layerSummaries.choque,
          camino: parsed.camino || defaults.layerSummaries.camino,
        },
        growthTips: Array.isArray(parsed.growthTips) ? parsed.growthTips : defaults.growthTips,
      };

      // Save to DB — clear old, insert new
      await admin.from('nosotros_narratives').delete().eq('couple_id', coupleId);

      const rows = [
        {
          couple_id: coupleId,
          narrative_type: 'relationship_story',
          dimension_slug: null,
          title: 'Nuestra Historia',
          body: result.relationshipStory,
          metadata: { my4C, partner4C },
        },
        ...Object.entries(result.layerSummaries).map(([layer, text]) => ({
          couple_id: coupleId,
          narrative_type: 'layer_summary' as const,
          dimension_slug: layer,
          title: LAYER_META[layer]?.label || layer,
          body: text,
          metadata: {},
        })),
        ...result.growthTips.map((tip: string, i: number) => ({
          couple_id: coupleId,
          narrative_type: 'growth_tip' as const,
          dimension_slug: `tip_${i + 1}`,
          title: `Consejo ${i + 1}`,
          body: tip,
          metadata: {},
        })),
      ];

      await admin.from('nosotros_narratives').insert(rows);

      return result;
    }
  } catch (err) {
    console.error('Nosotros narrative generation error:', err);
  }

  return defaults;
}

// ─── AI: Dimension deep dive ──────────────────────────────────

export async function generateDimensionDeepDive(
  dimensionSlug: string,
  forceRefresh: boolean = false
): Promise<{ coaching: string; error?: string }> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { coaching: '', error: 'No autorizado' };

  const admin = createAdminClient();

  // Get couple
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .limit(1)
    .single();

  const coupleId = membership?.couple_id || null;

  // Check cache
  if (!forceRefresh && coupleId) {
    const { data: existing } = await admin
      .from('ai_insights')
      .select('insight_text')
      .eq('user_id', user.id)
      .eq('couple_id', coupleId)
      .eq('dimension_slug', dimensionSlug)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (existing?.insight_text) {
      return { coaching: existing.insight_text };
    }
  }

  // Fallback: check without couple_id
  if (!forceRefresh) {
    const { data: existingNoCid } = await admin
      .from('ai_insights')
      .select('insight_text')
      .eq('user_id', user.id)
      .eq('dimension_slug', dimensionSlug)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (existingNoCid?.insight_text) {
      return { coaching: existingNoCid.insight_text };
    }
  }

  // Fetch data for prompt
  const { data: profile } = await supabase
    .from('profiles')
    .select('full_name')
    .eq('id', user.id)
    .single();

  const myName = profile?.full_name || 'Tú';

  const dimMeta = V2_DIMENSION_MAP[dimensionSlug];
  const dimLabel = dimMeta?.label || dimensionSlug;

  // My score
  const { data: myVec } = await supabase
    .from('profile_vectors')
    .select('normalized_score')
    .eq('user_id', user.id)
    .eq('dimension_slug', dimensionSlug)
    .single();

  const myScore = myVec?.normalized_score ?? 50;

  // Partner data
  let partnerScore: number | null = null;
  let partnerName: string | null = null;

  if (coupleId) {
    const { data: members } = await admin
      .from('couple_members')
      .select('user_id')
      .eq('couple_id', coupleId)
      .neq('user_id', user.id);

    if (members && members.length > 0) {
      const pid = members[0].user_id;
      const { data: pp } = await admin.from('profiles').select('full_name').eq('id', pid).single();
      partnerName = pp?.full_name || null;

      const { data: pVec } = await admin
        .from('profile_vectors')
        .select('normalized_score')
        .eq('user_id', pid)
        .eq('dimension_slug', dimensionSlug)
        .single();

      partnerScore = pVec?.normalized_score ?? null;
    }
  }

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    return { coaching: '', error: 'Falta GEMINI_API_KEY' };
  }

  const ai = new GoogleGenAI({ apiKey });

  let prompt = `
Actúa como un coach de relaciones empático para "Relationship OS".
Analiza la dimensión "${dimLabel}" de ${myName}.

Puntuación de ${myName}: ${myScore}/100
`;

  if (partnerScore !== null && partnerName) {
    const diff = Math.abs(myScore - partnerScore);
    prompt += `
Puntuación de ${partnerName}: ${partnerScore}/100
Diferencia: ${diff} puntos

Instrucciones:
1. Compara con empatía ambas puntuaciones en "${dimLabel}".
2. Si la diferencia es menor a 15, celebra la alineación.
3. Si está entre 15 y 30, resáltalo como oportunidad de crecimiento.
4. Si es mayor a 30, sugiere con tacto que dialoguen sobre este tema.
5. Da 1-2 acciones concretas que pueden hacer como pareja en esta dimensión.
`;
  } else {
    prompt += `
Instrucciones:
1. Analiza qué significa la puntuación de ${myScore}/100 en "${dimLabel}".
2. Si es mayor a 70, es una fortaleza. Si está entre 40 y 70, hay margen de mejora. Bajo 40, es prioridad.
3. Da una reflexión sobre cómo cultivar esta dimensión mientras espera los resultados de su pareja.
`;
  }

  prompt += `
REGLAS:
- Máximo 3 párrafos cortos.
- NO uses formato markdown. Texto plano solamente.
- Escribe en español mexicano natural, cálido y constructivo.
- Dirígete a ${myName} directamente (tú).
`;

  const defaultCoaching = `${myName}, tu puntuación de ${myScore}/100 en ${dimLabel} muestra un punto de partida interesante. Toda dimensión, sea alta o baja, ofrece espacio para explorar y profundizar. Reflexiona sobre qué acciones pequeñas podrías tomar esta semana para nutrir esta área de tu relación.`;

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: { temperature: 0.7 },
    });

    const text = response.text;
    if (!text) return { coaching: defaultCoaching };

    // Save to DB
    if (coupleId) {
      // Delete old entry for this dimension
      await admin
        .from('ai_insights')
        .delete()
        .eq('user_id', user.id)
        .eq('couple_id', coupleId)
        .eq('dimension_slug', dimensionSlug);

      await admin.from('ai_insights').insert({
        user_id: user.id,
        couple_id: coupleId,
        dimension_slug: dimensionSlug,
        insight_text: text,
      });
    } else {
      // No couple — save without couple_id
      await admin
        .from('ai_insights')
        .delete()
        .eq('user_id', user.id)
        .eq('dimension_slug', dimensionSlug);

      await admin.from('ai_insights').insert({
        user_id: user.id,
        dimension_slug: dimensionSlug,
        insight_text: text,
      });
    }

    return { coaching: text };
  } catch (err) {
    console.error('Dimension deep dive error:', err);
    return { coaching: defaultCoaching };
  }
}
