/**
 * V2 Onboarding Items — 15 personal profile questions
 * Source: relationship-os-questionnaire-blueprint.md (lines 200-215)
 *
 * These are hardcoded for reliable frontend rendering.
 * The DB item_bank table mirrors this data for scoring/analytics.
 */

export interface OnboardingItem {
  id: string;
  sort_order: number;
  dimension_slug: string;
  construct_slug: string;
  question_text: string;
  question_type: 'LIKERT-5' | 'ESCENARIO';
  options: OnboardingOption[];
  scenario?: string;
}

export interface OnboardingOption {
  value: string;
  label: string;
  order: number;
}

export interface OnboardingDimension {
  slug: string;
  label: string;
  description: string;
  icon: string;
  color: string;
  item_count: number;
}

// ─── Dimension metadata ─────────────────────────────────────

export const ONBOARDING_DIMENSIONS: OnboardingDimension[] = [
  {
    slug: 'autonomy',
    label: 'Autonomía',
    description: 'Necesidad de espacio personal e independencia',
    icon: '🏔️',
    color: '#B8A6FF', // conexion
    item_count: 2,
  },
  {
    slug: 'reassurance',
    label: 'Afecto y seguridad',
    description: 'Cómo necesitas sentirte querido/a y seguro/a',
    icon: '💜',
    color: '#9DDFC6', // cuidado
    item_count: 2,
  },
  {
    slug: 'conflict',
    label: 'Estilo de conflicto',
    description: 'Cómo enfrentas tensiones y recuperas la calma',
    icon: '⚡',
    color: '#E8A7B9', // choque
    item_count: 3,
  },
  {
    slug: 'stress_coping',
    label: 'Manejo del estrés',
    description: 'Qué necesitas cuando las cosas se ponen difíciles',
    icon: '🌊',
    color: '#FFBFA3', // camino
    item_count: 2,
  },
  {
    slug: 'emotional_expression',
    label: 'Expresión emocional',
    description: 'Facilidad para expresar sentimientos y necesidades',
    icon: '🗣️',
    color: '#B8A6FF',
    item_count: 2,
  },
  {
    slug: 'rituals',
    label: 'Rituales y consistencia',
    description: 'Importancia de rutinas y tiempo de calidad',
    icon: '🕯️',
    color: '#9DDFC6',
    item_count: 2,
  },
  {
    slug: 'future_orientation',
    label: 'Visión de futuro',
    description: 'Importancia de construir y planificar juntos',
    icon: '🧭',
    color: '#FFBFA3',
    item_count: 2,
  },
];

// ─── The 15 onboarding items ────────────────────────────────

const likert5Options: OnboardingOption[] = [
  { value: '1', label: 'Muy en desacuerdo', order: 1 },
  { value: '2', label: 'En desacuerdo', order: 2 },
  { value: '3', label: 'Neutral', order: 3 },
  { value: '4', label: 'De acuerdo', order: 4 },
  { value: '5', label: 'Muy de acuerdo', order: 5 },
];

export const ONBOARDING_ITEMS: OnboardingItem[] = [
  // ── Autonomy (2) ──
  {
    id: 'onb-01',
    sort_order: 1,
    dimension_slug: 'autonomy',
    construct_slug: 'personal_space',
    question_text: 'Cuando me siento abrumado/a, primero necesito espacio antes de hablar.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },
  {
    id: 'onb-02',
    sort_order: 2,
    dimension_slug: 'autonomy',
    construct_slug: 'independence',
    question_text: 'Para mí es importante mantener espacios propios dentro de la relación.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },

  // ── Reassurance / Affection (2) ──
  {
    id: 'onb-03',
    sort_order: 3,
    dimension_slug: 'reassurance',
    construct_slug: 'affection_actions',
    question_text: 'Me siento querido/a principalmente a través de acciones concretas.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },
  {
    id: 'onb-04',
    sort_order: 4,
    dimension_slug: 'reassurance',
    construct_slug: 'verbal_reassurance',
    question_text: 'Necesito escuchar palabras claras de cariño o reconocimiento para sentirme seguro/a.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },

  // ── Conflict Approach (3) ──
  {
    id: 'onb-05',
    sort_order: 5,
    dimension_slug: 'conflict',
    construct_slug: 'conflict_initiation',
    question_text: 'Prefiero resolver tensiones pronto, aunque la conversación sea incómoda.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },
  {
    id: 'onb-06',
    sort_order: 6,
    dimension_slug: 'conflict',
    construct_slug: 'conflict_avoidance',
    question_text: 'Cuando hay conflicto, me cuesta iniciar la conversación.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },
  {
    id: 'onb-07',
    sort_order: 7,
    dimension_slug: 'conflict',
    construct_slug: 'repair_speed',
    question_text: 'Después de una discusión, suelo recuperar la calma con rapidez.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },

  // ── Stress Coping (2 scenarios) ──
  {
    id: 'onb-08',
    sort_order: 8,
    dimension_slug: 'stress_coping',
    construct_slug: 'bad_day_response',
    question_text: 'Si tengo un mal día, prefiero que mi pareja:',
    question_type: 'ESCENARIO',
    scenario: 'Imagina que llegas a casa después de un día difícil...',
    options: [
      { value: 'A', label: 'Me escuche sin dar consejos', order: 1 },
      { value: 'B', label: 'Me ayude a resolver lo que pasó', order: 2 },
      { value: 'C', label: 'Me dé espacio y tiempo', order: 3 },
      { value: 'D', label: 'Me pregunte qué necesito en ese momento', order: 4 },
    ],
  },
  {
    id: 'onb-09',
    sort_order: 9,
    dimension_slug: 'stress_coping',
    construct_slug: 'difficult_talk_timing',
    question_text: 'Si mi pareja quiere hablar de algo difícil cuando yo no estoy regulado/a, prefiero:',
    question_type: 'ESCENARIO',
    scenario: 'Tu pareja necesita hablar de algo importante, pero tú no te sientes listo/a...',
    options: [
      { value: 'A', label: 'Hablar de una vez para no dejarlo pendiente', order: 1 },
      { value: 'B', label: 'Pedir una pausa corta y retomar después', order: 2 },
      { value: 'C', label: 'Dejarlo para otro momento más tranquilo', order: 3 },
      { value: 'D', label: 'Evitarlo si no es urgente', order: 4 },
    ],
  },

  // ── Emotional Expression (2) ──
  {
    id: 'onb-10',
    sort_order: 10,
    dimension_slug: 'emotional_expression',
    construct_slug: 'asking_comfort',
    question_text: 'Me resulta fácil pedir consuelo o apoyo emocional.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },
  {
    id: 'onb-11',
    sort_order: 11,
    dimension_slug: 'emotional_expression',
    construct_slug: 'expressing_needs',
    question_text: 'Me resulta fácil decir claramente lo que necesito.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },

  // ── Rituals and Consistency (2) ──
  {
    id: 'onb-12',
    sort_order: 12,
    dimension_slug: 'rituals',
    construct_slug: 'daily_rituals',
    question_text: 'Los pequeños rituales cotidianos me ayudan a sentir conexión.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },
  {
    id: 'onb-13',
    sort_order: 13,
    dimension_slug: 'rituals',
    construct_slug: 'quality_time',
    question_text: 'Me gusta saber cuándo tendremos tiempo de calidad juntos.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },

  // ── Future Orientation (2) ──
  {
    id: 'onb-14',
    sort_order: 14,
    dimension_slug: 'future_orientation',
    construct_slug: 'future_talks',
    question_text: 'Hablar del futuro como pareja es importante para mí.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },
  {
    id: 'onb-15',
    sort_order: 15,
    dimension_slug: 'future_orientation',
    construct_slug: 'building_together',
    question_text: 'Me tranquiliza sentir que estamos construyendo algo juntos.',
    question_type: 'LIKERT-5',
    options: likert5Options,
  },
];

// ─── Scoring helpers ────────────────────────────────────────

/**
 * Mapping for scenario answers to numeric scores for profile vectors.
 * Scenarios don't have a natural 1-5 scale, so we assign profile-relevant weights.
 */
export const SCENARIO_SCORING: Record<string, Record<string, Record<string, number>>> = {
  bad_day_response: {
    // Which dimension each scenario answer contributes to
    A: { emotional_expression: 4, reassurance: 3 },
    B: { conflict: 4, autonomy: 2 },
    C: { autonomy: 5, emotional_expression: 2 },
    D: { emotional_expression: 4, reassurance: 4 },
  },
  difficult_talk_timing: {
    A: { conflict: 5, emotional_expression: 3 },
    B: { conflict: 3, emotional_expression: 4 },
    C: { autonomy: 4, conflict: 2 },
    D: { autonomy: 5, conflict: 1 },
  },
};
