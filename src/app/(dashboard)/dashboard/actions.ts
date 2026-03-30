'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { GoogleGenAI } from '@google/genai';
import { V2_DIMENSION_MAP } from '@/lib/scoring';

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY || '' });
const MODEL = 'gemini-2.5-flash';

export interface DashboardInsight {
  title: string;
  body: string;
}

export async function getDashboardInsight(): Promise<DashboardInsight | null> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return null;

  const admin = createAdminClient();

  // get couple
  const { data: membership } = await supabase
    .from('couple_members')
    .select('couple_id')
    .eq('user_id', user.id)
    .single();

  if (!membership) return null;

  // Use today's date as slug to ensure 1 per day
  const todayStr = new Date().toISOString().split('T')[0];
  const insightSlug = `dashboard_insight_v2_${todayStr}`;

  const { data: existing } = await supabase
    .from('couple_insights')
    .select('title, body')
    .eq('couple_id', membership.couple_id)
    .eq('insight_type', 'comparative_summary')
    .eq('dimension_slug', insightSlug)
    .single();

  if (existing) {
    return existing;
  }

  // Generate new insight with V2 context
  const myName = (await supabase.from('profiles').select('full_name').eq('id', user.id).single()).data?.full_name || 'Tú';
  
  const partnerId = (await admin
    .from('couple_members')
    .select('user_id')
    .eq('couple_id', membership.couple_id)
    .neq('user_id', user.id)
    .single()).data?.user_id;

  let partnerName = 'tu pareja';
  if (partnerId) {
    partnerName = (await admin.from('profiles').select('full_name').eq('id', partnerId).single()).data?.full_name || 'tu pareja';
  }

  // Fetch V2 vectors
  const { data: myVectors } = await supabase
    .from('profile_vectors')
    .select('dimension_slug, normalized_score')
    .eq('user_id', user.id);

  const { data: partnerVectors } = partnerId ? await admin
    .from('profile_vectors')
    .select('dimension_slug, normalized_score')
    .eq('user_id', partnerId) : { data: [] };

  const { data: coupleVectors } = await admin
    .from('couple_vectors')
    .select('dimension_slug, mismatch_delta, risk_flag, opportunity_flag')
    .eq('couple_id', membership.couple_id);

  let context = 'Aún no tienen datos en su Blueprint V2. Dales la bienvenida y anímalos a completar la evaluación.';
  if (myVectors && myVectors.length > 0) {
    const summaries = myVectors.map((v: { dimension_slug: string; normalized_score: number }) => `${V2_DIMENSION_MAP[v.dimension_slug]?.label || v.dimension_slug}: ${v.normalized_score}`);
    const risks = coupleVectors?.filter(v => v.risk_flag).map(v => V2_DIMENSION_MAP[v.dimension_slug]?.label) || [];
    context = `Puntajes de ${myName}: ${summaries.join(', ')}. 
               ${partnerName} ${partnerVectors?.length ? 'ya completó' : 'aún no completa'}. 
               Riesgos detectados: ${risks.join(', ')}.`;
  }

  const prompt = `Eres un terapeuta de parejas de clase mundial para "Relationship OS".
Usuario: ${myName}. Pareja: ${partnerName}.
Contexto de su relación: ${context}.

Genera un insight DIARIO que sea:
1. EXTREMADAMENTE PERSONAL E ÍNTIMO: Usa sus nombres. Habla de "ustedes" o dirígete a ${myName} sobre ${partnerName}.
2. ORIENTADO A LA MEJORA: No solo describas, sugiere un pequeño cambio de mentalidad o una acción de cuidado para HOY.
3. TONO: Cálido, premium, profundo (no genérico). Máximo 45 palabras.
4. TÍTULO: Muy corto (2-3 palabras). Inspirador.

Devuelve estrictamente un JSON válido con este formato:
{ "title": "Título corto", "body": "Texto del insight íntimo y accionable." }`;

  try {
    const response = await ai.models.generateContent({
      model: MODEL,
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        temperature: 0.85,
      }
    });

    const text = response.text || '{}';
    const result = JSON.parse(text);
    
    if (!result.title || !result.body) throw new Error('Invalid AI format');

    const insertData = {
      couple_id: membership.couple_id,
      insight_type: 'comparative_summary',
      dimension_slug: insightSlug,
      title: result.title,
      body: result.body,
      metadata: { generated_at: new Date().toISOString(), source: 'daily_personal_v2' }
    };

    await supabase.from('couple_insights').insert(insertData);
    return result;
  } catch (err) {
    console.error('Error generating V2 insight:', err);
    return {
      title: 'Tu Momento',
      body: `${myName}, hoy es un buen día para recordarle a ${partnerName} por qué elegiste caminar a su lado. Un pequeño gesto de aprecio transforma toda la semana.`
    };
  }
}

export async function getInsights(evaluationId: string) {
  // Legacy / Other insights if needed
  return null;
}

