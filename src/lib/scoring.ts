import { DimensionLayer } from '@/types/questionnaire';

export interface DimensionScore {
  dimension: string;
  layer: DimensionLayer;
  affinity: number;
  complementarity: number;
  friction: number;
  growthPotential: number;
  label: string;
}

export interface CoupleReport {
  id: string;
  couple_id: string;
  summary: string;
  dimensions: DimensionScore[];
  strengths: string[];
  frictions: string[];
  recommendations: string[];
  couple_archetype: string;
  created_at: string;
}

export interface PersonalReport {
  id: string;
  user_id: string;
  archetype: string;
  summary: string;
  strengths: string[];
  growth_areas: string[];
  created_at: string;
}

const dimensionLabels: Record<string, string> = {
  intimidad_emocional: 'Intimidad Emocional',
  rituales: 'Rituales',
  humor_compartido: 'Humor Compartido',
  curiosidad_mutua: 'Curiosidad Mutua',
  tiempo_juntos: 'Tiempo Juntos',
  lenguajes_afecto: 'Lenguajes del Afecto',
  apoyo_emocional: 'Apoyo Emocional',
  validacion: 'Validación Emocional',
  atencion: 'Atención',
  reparacion: 'Reparación',
  estilo_conflicto: 'Estilo de Conflicto',
  limites: 'Límites',
  reactividad: 'Reactividad',
  evasion: 'Evasión',
  cierre: 'Cierre',
  metas: 'Metas',
  dinero: 'Dinero',
  familia: 'Familia',
  hogar: 'Hogar',
  identidad: 'Identidad',
};

export function getDimensionLabel(slug: string): string {
  return dimensionLabels[slug] || slug;
}

export function getScoreLabel(score: number): { label: string; color: string } {
  if (score >= 0.85) return { label: 'Muy alineados', color: 'cuidado' };
  if (score >= 0.65) return { label: 'Bastante alineados', color: 'blue' };
  if (score >= 0.45) return { label: 'Complementarios', color: 'conexion' };
  if (score >= 0.25) return { label: 'Diferencia sensible', color: 'camino' };
  return { label: 'Zona a trabajar', color: 'choque' };
}

export function calculateAffinity(scoreA: number, scoreB: number): number {
  return 1 - Math.abs(scoreA - scoreB);
}

export function calculateComplementarity(scoreA: number, scoreB: number, tolerance: number): number {
  const difference = Math.abs(scoreA - scoreB);
  return difference <= tolerance ? difference : 1 - (difference - tolerance) / (1 - tolerance);
}

export function calculateFriction(scoreA: number, scoreB: number, lowTolerance: number): number {
  const difference = Math.abs(scoreA - scoreB);
  if (difference < lowTolerance) return 0;
  return (difference - lowTolerance) / (1 - lowTolerance);
}

export function calculateGrowthPotential(awareness: number, openness: number, habit: number): number {
  return (awareness + openness + habit) / 3;
}

export function generateCoupleArchetype(dimensions: DimensionScore[]): string {
  const conexion = dimensions.filter(d => d.layer === 'conexion').reduce((a, b) => a + b.affinity, 0) / 5;
  const cuidado = dimensions.filter(d => d.layer === 'cuidado').reduce((a, b) => a + b.affinity, 0) / 5;
  const choque = dimensions.filter(d => d.layer === 'choque').reduce((a, b) => a + b.affinity, 0) / 5;
  const camino = dimensions.filter(d => d.layer === 'camino').reduce((a, b) => a + b.affinity, 0) / 5;
  
  if (conexion > 0.7 && cuidado > 0.6) return 'Cálida-Exploradora';
  if (cuidado > 0.7 && camino > 0.6) return 'Serena-Constante';
  if (conexion > 0.6 && choque > 0.5) return 'Magnética-Intensa';
  if (choque > 0.6 && cuidado > 0.5) return 'Complementaria-Dinámica';
  if (camino > 0.7 && cuidado > 0.5) return 'Tierna-Estratégica';
  if (conexion < 0.4 && cuidado > 0.5) return 'Libre-Conectada';
  
  return 'Cálida-Exploradora';
}

export function generatePersonalArchetype(answers: Record<string, any>): string {
  // Simplified archetype detection based on key answers
  const regulation = answers['q2'];
  const conflict = answers['q5'];
  const recharge = answers['q27'];
  
  if (regulation === 'A' && conflict === 'B') return 'Independiente-Reflexivo';
  if (conflict === 'A' && recharge === 'B') return 'Cálido-Expresivo';
  if (regulation === 'B' && recharge === 'A') return 'Protector-Práctico';
  if (recharge === 'C') return 'Lúdico-Explorador';
  if (conflict === 'D') return 'Estable-Constructor';
  
  return 'Sensitivo-Intuitivo';
}

// ─── V2 Blueprint: Profile Vectors & Distance ───────────────

/**
 * V2 dimension framework — maps onboarding dimensions to the 4C macro layers
 */
export const V2_DIMENSION_MAP: Record<string, { layer: DimensionLayer; label: string }> = {
  autonomy: { layer: 'camino', label: 'Autonomía' },
  reassurance: { layer: 'cuidado', label: 'Afecto y seguridad' },
  conflict: { layer: 'choque', label: 'Estilo de conflicto' },
  stress_coping: { layer: 'choque', label: 'Manejo del estrés' },
  emotional_expression: { layer: 'conexion', label: 'Expresión emocional' },
  rituals: { layer: 'conexion', label: 'Rituales y consistencia' },
  future_orientation: { layer: 'camino', label: 'Visión de futuro' },
  // Extended dimensions from couple assessment
  emotional_intimacy: { layer: 'conexion', label: 'Intimidad emocional' },
  partner_insight: { layer: 'conexion', label: 'Curiosidad mutua' },
  support_fit: { layer: 'cuidado', label: 'Estilo de apoyo' },
  validation: { layer: 'cuidado', label: 'Validación emocional' },
  shared_planning: { layer: 'camino', label: 'Planificación compartida' },
};

export interface ProfileVectorEntry {
  dimension_slug: string;
  normalized_score: number;
}

/**
 * Compute the distance between two profile vectors.
 * Returns a record of dimension slugs to distance scores (0-100).
 * Higher distance = larger mismatch = more tension risk.
 */
export function computeProfileDistance(
  vectorsA: ProfileVectorEntry[],
  vectorsB: ProfileVectorEntry[]
): Record<string, { distance: number; riskLevel: 'low' | 'medium' | 'high' }> {
  const mapA: Record<string, number> = {};
  vectorsA.forEach((v) => { mapA[v.dimension_slug] = v.normalized_score; });

  const mapB: Record<string, number> = {};
  vectorsB.forEach((v) => { mapB[v.dimension_slug] = v.normalized_score; });

  const allDimensions = new Set([...Object.keys(mapA), ...Object.keys(mapB)]);
  const result: Record<string, { distance: number; riskLevel: 'low' | 'medium' | 'high' }> = {};

  allDimensions.forEach((dim) => {
    const scoreA = mapA[dim] ?? 50;
    const scoreB = mapB[dim] ?? 50;
    const distance = Math.abs(scoreA - scoreB);

    let riskLevel: 'low' | 'medium' | 'high' = 'low';
    if (distance > 40) riskLevel = 'high';
    else if (distance > 20) riskLevel = 'medium';

    result[dim] = { distance, riskLevel };
  });

  return result;
}

/**
 * Compute top mismatch areas from profile distance (for adaptive question selection)
 */
export function getTopMismatches(
  distances: Record<string, { distance: number; riskLevel: string }>,
  count: number = 3
): string[] {
  return Object.entries(distances)
    .sort(([, a], [, b]) => b.distance - a.distance)
    .slice(0, count)
    .map(([dim]) => dim);
}

/**
 * Compute aggregate 4C scores from profile vectors
 */
export function compute4CFromProfileVectors(
  vectors: ProfileVectorEntry[]
): { conexion: number; cuidado: number; choque: number; camino: number } {
  const layerScores: Record<string, number[]> = {
    conexion: [],
    cuidado: [],
    choque: [],
    camino: [],
  };

  vectors.forEach((v) => {
    const dimInfo = V2_DIMENSION_MAP[v.dimension_slug];
    if (dimInfo) {
      layerScores[dimInfo.layer].push(v.normalized_score);
    }
  });

  const avg = (arr: number[]) =>
    arr.length > 0 ? arr.reduce((a, b) => a + b, 0) / arr.length : 50;

  return {
    conexion: Math.round(avg(layerScores.conexion)) / 100,
    cuidado: Math.round(avg(layerScores.cuidado)) / 100,
    choque: Math.round(100 - avg(layerScores.choque)) / 100, // Invert — lower choque is better
    camino: Math.round(avg(layerScores.camino)) / 100,
  };
}
