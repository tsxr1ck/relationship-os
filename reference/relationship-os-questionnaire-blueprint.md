# Relationship OS Questionnaire Blueprint

## Purpose

This document defines a production-ready blueprint for a two-stage relationship assessment system designed for a couple-focused product. The goal is to replace a long, static first-run questionnaire with a shorter onboarding assessment and a dynamically generated couple questionnaire that is more relevant, more measurable, and easier to complete.[cite:87][cite:90][cite:91]

The system is designed to support three outcomes: better completion rates, stronger metric quality, and a more personalized user experience.[cite:91][cite:97] It also supports a practical implementation path using Gemini Cloud API to generate adaptive questionnaires, summaries, weekly plans, and follow-up modules from structured profile data.[cite:91]

## Product Thesis

A fixed 52-question questionnaire at first login creates friction, mixes measurement styles, and asks too many items that are difficult to score consistently.[cite:90][cite:93][cite:96] A better model is to collect a short self-profile first, infer relationship-relevant traits from that profile, and then generate a custom assessment for both partners based on their combined styles, mismatches, and blind spots.[cite:87][cite:91][cite:97]

This approach preserves comparability by keeping a fixed core set of questions while improving relevance through adaptive question selection.[cite:91][cite:94] It also creates a foundation for richer downstream features such as custom reports, weekly relationship plans, targeted conversation prompts, and risk/opportunity scoring.[cite:87][cite:91]

## Core Design Principles

A strong questionnaire system should follow these rules:

- Ask one thing at a time; avoid double-barreled items that combine two ideas in one question.[cite:90][cite:93][cite:99]
- Prefer observable behavior, preference, confidence, or satisfaction over mind-reading or speculative interpretation.[cite:90]
- Use question wording that maps cleanly to one construct so each score has a clear meaning.[cite:86][cite:90]
- Use open-ended questions sparingly; they are valuable for nuance and coaching, but weak as primary scoring inputs.[cite:90][cite:96]
- Use adaptive or branched questioning only after a strong item bank and dimension model exist.[cite:91][cite:94]
- Keep onboarding light enough to finish in one sitting without fatigue.[cite:97]

## Recommended System Architecture

The recommended design has three layers.

### Stage 1: Personal Onboarding Profile

Each user completes a 12-18 question self-profile immediately after signup. This stage should feel fast, reflective, and non-clinical.[cite:97] Its job is not to diagnose the relationship; its job is to classify the user across a set of stable or semi-stable working dimensions that help generate better later questions.[cite:87][cite:91]

Suggested target dimensions for onboarding:

| Dimension | What it captures | Sample metric type |
|---|---|---|
| Autonomy need | Need for personal space and independence | Preference / frequency |
| Reassurance need | Desire for verbal/behavioral reassurance | Preference / satisfaction |
| Conflict approach | Tendency to confront, pause, avoid, appease, or repair | Behavior |
| Repair speed | How fast the person calms and reconnects | Recovery |
| Affection preference | Preferred style of receiving and giving care | Preference / ranking |
| Stress coping style | Whether the person wants solutions, listening, space, or structure | Scenario / preference |
| Emotional expression | Ease of naming needs and emotions | Confidence / comfort |
| Future orientation | How much importance they give to shared planning | Alignment / priority |
| Structure vs spontaneity | Desire for plans, rituals, and predictability | Preference |
| Recognition need | Importance of appreciation and acknowledgment | Satisfaction / need |

This stage should create a `personal_profile` object for each user that becomes the basis for the adaptive couple assessment.[cite:91]

### Stage 2: Generated Couple Assessment

After both partners complete onboarding, the system generates a custom 24-36 question assessment for that specific pair. A practical version is 28 total items: 18 fixed core questions and 10 adaptive questions.[cite:91][cite:97]

The generated assessment should combine:

- Core questions that everyone receives, to preserve comparability across all couples.[cite:91]
- Adaptive mismatch questions, based on the largest differences between the two personal profiles.[cite:91][cite:94]
- Confidence and partner-understanding questions, to measure how accurately each person understands the other.[cite:87]
- Optional sensitive modules, such as intimacy, money, family planning, or boundaries, gated by opt-in and product context.[cite:87]

### Stage 3: Deep-Dive Modules

After the core couple assessment, the product can offer optional deep-dive modules. These modules should be selected because the data shows tension, uncertainty, or high importance in that area, not because every couple must answer everything.[cite:87][cite:91]

Recommended deep-dive modules:

- Conflict and repair
- Affection and intimacy
- Money and fairness
- Family and parenting
- Time, rituals, and attention
- Identity, career, and autonomy
- Home, city, and future plans

## Target Measurement Model

The product should measure at least three top-level outputs.

### 1. Similarity

This score captures where the couple is naturally aligned in needs, preferences, and future orientation. Similarity does not mean “healthy” by itself, but it helps estimate friction load and ease of coordination.[cite:91]

### 2. Tension Risk

This score captures likely conflict zones, especially where one person’s need or style creates pressure on the other. High mismatch on autonomy, repair timing, conflict initiation, affection style, or money fairness can create recurrent loops.[cite:87][cite:91]

### 3. Growth Opportunity

This score captures areas where the couple is not necessarily in danger, but could improve meaningfully through better understanding, rituals, clearer agreements, or more direct communication.[cite:87]

A fourth optional score is **Partner Insight Accuracy**, which compares a person’s prediction of their partner against the partner’s self-report. This is more useful than trivia-based “how well do you know your partner?” items because it measures functional understanding, not memory of facts.[cite:87]

## Better Question Design

The existing questionnaire contains many interesting prompts, but its scoring quality is weakened by four recurring patterns.[cite:90][cite:96]

### Problem 1: Mind-reading items

Questions such as “What is your partner’s biggest fear in the relationship, even if they never say it?” create projection risk. These items often measure the respondent’s own interpretation more than their partner’s actual state.[cite:90]

**Better pattern:** ask for confidence or evidence-based understanding.

Examples:

- “¿Qué tan seguro/a te sientes de entender qué inseguridades emocionales activan a tu pareja?”
- “¿Qué tan bien identificas las señales de que tu pareja necesita apoyo, espacio o contención?”

### Problem 2: Double-barreled items

Questions that combine frequency and quality, current process and fairness, or multiple constructs in one prompt are harder to interpret and score.[cite:90][cite:93][cite:99]

Examples from the current style and improved replacements:

| Weak item | Why it is weak | Better replacement |
|---|---|---|
| “¿Qué tan satisfecho/a estás con la cantidad y calidad de conversaciones que tienen?” | Mixes frequency and quality in one item.[cite:99] | Split into: “¿Qué tan satisfecho/a estás con la frecuencia de sus conversaciones importantes?” and “¿Qué tan satisfecho/a estás con la profundidad de sus conversaciones importantes?”[cite:99] |
| “¿Cómo manejan actualmente sus finanzas como pareja? ¿Es el sistema justo para ambos?” | Mixes current arrangement and fairness.[cite:90] | Split into: “¿Tienen acuerdos claros sobre cómo dividir gastos?” and “¿Sientes que la forma en que reparten gastos es justa para ti?”[cite:90] |

### Problem 3: Too many open-ended items in core scoring

Open-ended items are excellent for reflections, coaching prompts, and report generation, but they are weak as primary metrics because they are harder to standardize and compare at scale.[cite:90][cite:96]

**Better pattern:** keep open text optional and secondary.

Recommended use of open text:

- One optional reflection at the end of onboarding.
- One optional “what feels hardest lately?” question after the core couple assessment.
- One optional “what small action would help this week?” input for weekly plan generation.

### Problem 4: Trivia over functional partner insight

Questions about favorite color, favorite series, or favorite food may feel playful, but they are less predictive of relationship quality than questions about emotional regulation, support needs, and stress cues.[cite:87]

**Better pattern:** ask whether the person can predict how their partner responds under stress, closeness, or conflict.[cite:87]

Examples:

- “Sé reconocer cuándo mi pareja necesita primero escucha y no soluciones.”
- “Sé qué gesto hace que mi pareja se sienta cuidada en un mal día.”
- “Puedo identificar cuándo mi pareja necesita espacio antes de seguir una conversación difícil.”

## Recommended Question Mix

The scoring backbone should rely mostly on short, clean Likert items, with a smaller number of scenario and ranking items.[cite:90][cite:91]

Recommended mix:

| Type | Target share | Purpose |
|---|---:|---|
| Likert-5 / Likert-7 | 60-70% | Main scoring, behavioral frequency, satisfaction, confidence, alignment |
| Scenario items | 15-20% | Stress response, conflict choices, support preferences |
| Ranking items | 10-15% | Tradeoffs such as affection style or priority ordering |
| Open text | ~10% optional | Nuance, report personalization, coaching prompts |

Forced-choice should be used carefully. It works best when both options are equally plausible and not obviously more socially desirable.[cite:86] If one answer sounds more mature or healthy, users may optimize for image instead of truth.[cite:86]

## Proposed Dimension Framework

A strong V2 should use a stable internal dimension model with a smaller number of well-defined constructs. The current 20 subdimensions are workable, but they should be fed by cleaner items and a more explicit scoring framework.

Recommended working model:

| Layer | Dimension | Definition |
|---|---|---|
| Conexión | Emotional intimacy | Vulnerability, depth, felt closeness |
| Conexión | Rituals and shared presence | Small habits, attention, recurring connection |
| Conexión | Curiosity and partner insight | Feeling known and knowing the other well |
| Cuidado | Support fit | Whether care offered matches care needed |
| Cuidado | Validation | Feeling emotionally understood and acknowledged |
| Cuidado | Affection fit | Match between desired and received affection |
| Choque | Conflict initiation | Willingness and skill in starting hard talks |
| Choque | Reactivity and regulation | Emotional activation and self-soothing |
| Choque | Repair and reconnection | Ability to recover and close loops after friction |
| Camino | Shared planning | Alignment around future and long-term goals |
| Camino | Fairness and agreements | Money, responsibilities, boundaries, family systems |
| Camino | Autonomy integration | Space for individuality inside commitment |

This shorter dimension model is easier to explain in reports and easier to map to product features than an overly granular taxonomy.[cite:87][cite:91]

## Stage 1 Blueprint: 15 Onboarding Items

Below is a recommended onboarding structure for each individual user.

### Onboarding dimensions and item counts

| Dimension | Items | Target format |
|---|---:|---|
| Autonomy | 2 | Likert |
| Reassurance / affection | 2 | Likert / ranking |
| Conflict approach | 3 | Likert / scenario |
| Stress coping | 2 | Scenario |
| Emotional expression | 2 | Likert |
| Rituals and consistency | 2 | Likert |
| Future orientation | 2 | Likert |

### Proposed onboarding item set

1. “Cuando me siento abrumado/a, primero necesito espacio antes de hablar.”
2. “Para mí es importante mantener espacios propios dentro de la relación.”
3. “Me siento querido/a principalmente a través de acciones concretas.”
4. “Necesito escuchar palabras claras de cariño o reconocimiento para sentirme seguro/a.”
5. “Prefiero resolver tensiones pronto, aunque la conversación sea incómoda.”
6. “Cuando hay conflicto, me cuesta iniciar la conversación.”
7. “Después de una discusión, suelo recuperar la calma con rapidez.”
8. Scenario: “Si tengo un mal día, prefiero que mi pareja: me escuche / me ayude a resolver / me dé espacio / me pregunte qué necesito.”
9. Scenario: “Si mi pareja quiere hablar de algo difícil cuando yo no estoy regulado/a, prefiero: hablar de una vez / pedir una pausa corta / dejarlo para otro momento / evitarlo.”
10. “Me resulta fácil pedir consuelo o apoyo emocional.”
11. “Me resulta fácil decir claramente lo que necesito.”
12. “Los pequeños rituales cotidianos me ayudan a sentir conexión.”
13. “Me gusta saber cuándo tendremos tiempo de calidad juntos.”
14. “Hablar del futuro como pareja es importante para mí.”
15. “Me tranquiliza sentir que estamos construyendo algo juntos.”

These items are short, single-construct, and useful for profile generation.[cite:90][cite:99]

## Stage 2 Blueprint: Generated 28-Question Couple Assessment

Recommended composition:

| Category | Count | Notes |
|---|---:|---|
| Fixed core questions | 12 | Everyone gets these |
| Partner-insight questions | 8 | Compare prediction vs self-report |
| Adaptive mismatch questions | 8 | Chosen from top gaps |
| Total | 28 | Good balance of depth and completion rate |

### Fixed core questions

These should appear for all couples, regardless of profile.

1. “¿Qué tan satisfecho/a estás con la frecuencia de sus conversaciones importantes?”
2. “¿Qué tan satisfecho/a estás con la profundidad de sus conversaciones importantes?”
3. “¿Con qué frecuencia sienten que están presentes el uno para el otro sin pantallas ni distracciones?”
4. “¿Qué tan fácil les resulta reparar y reconectar después de una discusión?”
5. “¿Qué tan claro te resulta cuándo tu pareja necesita apoyo emocional?”
6. “¿Qué tan escuchado/a te sientes por tu pareja cuando algo te importa?”
7. “¿Qué tan alineados están actualmente en sus prioridades de vida para los próximos 1-2 años?”
8. “¿Sientes que existe una forma justa de repartir responsabilidades y esfuerzos en la relación?”
9. “¿Con qué frecuencia tienen muestras de cariño no sexuales que se sienten naturales para ambos?”
10. “¿Qué tan conocido/a te sientes por tu pareja más allá de lo superficial?”
11. “¿Qué tan cómodos son para hablar de un tema difícil sin que se convierta en pelea?”
12. “¿Qué tan optimista te sientes sobre la dirección actual de la relación?”

### Partner-insight questions

These are more valuable than trivia because they measure functional understanding.

1. “Sé reconocer cuándo mi pareja necesita espacio antes de seguir hablando.”
2. “Puedo distinguir cuándo mi pareja quiere escucha y cuándo quiere soluciones.”
3. “Conozco qué suele activar más estrés en mi pareja en esta etapa.”
4. “Sé qué gesto o acción hace que mi pareja se sienta cuidada en un mal día.”
5. “Puedo anticipar qué tipo de conflicto le cuesta más abrir a mi pareja.”
6. “Entiendo qué tan importante es para mi pareja tener tiempo propio.”
7. “Entiendo qué tanto necesita mi pareja reconocimiento verbal o visible.”
8. “Puedo describir con bastante precisión cómo imagina mi pareja su futuro cercano.”

These can be scored against the partner’s self-profile using confidence deltas or direct agreement models.[cite:87]

### Adaptive mismatch question bank

The adaptive engine should choose 8 of these based on the pair’s largest profile gaps.

#### If autonomy mismatch is high

- “¿Sientes que tu necesidad de espacio personal es respetada por tu pareja?”
- “¿Con qué frecuencia interpretan la necesidad de espacio como rechazo en lugar de autorregulación?”

#### If reassurance mismatch is high

- “¿Qué tan seguido recibes muestras de cariño en la forma que más te importa?”
- “¿Qué tan claro tiene tu pareja cómo hacerte sentir seguro/a emocionalmente?”

#### If conflict style mismatch is high

- “Cuando surge tensión, ¿qué tan fácil es encontrar un ritmo de conversación que funcione para ambos?”
- “¿Sientes que uno quiere resolver demasiado rápido mientras el otro necesita más tiempo?”

#### If repair speed mismatch is high

- “Después de una discusión, ¿se respetan sus tiempos de recuperación sin alejarse demasiado?”
- “¿Qué tan fácil es volver a sentirse cercanos después de un desacuerdo?”

#### If future orientation mismatch is high

- “¿Qué tan claro es para ambos cuál debería ser el siguiente paso importante en la relación?”
- “¿Sientes que tú y tu pareja avanzan al mismo ritmo cuando hablan de compromisos y planes?”

#### If money/fairness mismatch is high

- “¿Tienen acuerdos suficientemente claros sobre gastos, prioridades y expectativas?”
- “¿Sientes que tus preocupaciones económicas son comprendidas por tu pareja?”

## Scoring Blueprint

The scoring system should be transparent enough for internal use and interpretable enough for user-facing reports.

### Score families

| Score family | Inputs | Output |
|---|---|---|
| Personal trait scores | Onboarding self-items | Personal profile vectors |
| Couple alignment scores | Core couple items + profile similarity | Dimension alignment |
| Insight accuracy scores | Partner predictions vs self-profile | Knowledge / empathy metric |
| Tension risk scores | High mismatch + low repair + low clarity | Risk flags |
| Opportunity scores | Medium mismatch + high willingness + low skill | Coaching targets |

### Suggested scoring logic

1. Normalize all scalar items to 0-100.
2. Compute each user’s personal profile by dimension.
3. Compute profile distance between partners by dimension.
4. Blend direct relationship experience items with profile distance.
5. Weight direct experience higher than inferred mismatch when both are available.
6. Flag a domain as high risk only when mismatch and low couple-functioning both appear.
7. Flag a domain as growth opportunity when mismatch exists but willingness, hope, or curiosity remain moderate to high.

### Example formula logic

A practical internal heuristic for one dimension might look like this:

- `alignment_score = 0.55 * direct_experience + 0.30 * inverse_profile_distance + 0.15 * partner_insight_accuracy`
- `risk_score = mismatch_weight + low_repair_weight + low_clarity_weight`
- `opportunity_score = mismatch_weight + motivation_weight + unfinished_conversation_weight`

These formulas should be tuned empirically after real user data accumulates.[cite:86][cite:91]

## Gemini Cloud API Role

Gemini Cloud API should not invent the full measurement system from scratch on every run. It should operate inside a constrained orchestration framework.

### Gemini should do

- Generate adaptive questions from approved templates and item bank metadata.
- Rewrite question wording for tone and clarity while preserving construct intent.
- Select the most relevant modules based on profile deltas and confidence thresholds.
- Generate personalized summaries and suggested conversation prompts.
- Produce weekly plan ideas from structured couple insights.

### Gemini should not do alone

- Define dimension math ad hoc.
- Change scoring weights without system rules.
- Create unsupported constructs that do not map to your schema.
- Evaluate truth from purely freeform partner projections without reference anchors.

The safest pattern is deterministic scoring plus LLM-assisted content generation.[cite:86][cite:91]

## Recommended Data Model

A practical implementation should separate item-bank content from runtime questionnaire assembly.

### Core tables to add or refine

| Table | Purpose |
|---|---|
| `item_bank` | Master list of vetted question items |
| `item_dimensions` | Mapping of items to dimensions, weights, and stage |
| `item_variants` | Alternative phrasings, locales, tone styles |
| `adaptive_rules` | Rules for selecting modules based on profile deltas |
| `generated_assessments` | Runtime-assembled questionnaire instances |
| `generated_assessment_items` | The exact selected items shown to a couple |
| `profile_vectors` | Per-user normalized onboarding outputs |
| `couple_vectors` | Derived pair-level scores and mismatch deltas |
| `report_snapshots` | Versioned structured outputs sent to Gemini |

### Item bank fields

Recommended fields for each item:

- `id`
- `stage` (`onboarding`, `core`, `adaptive`, `deep_dive`)
- `dimension_slug`
- `construct_slug`
- `question_text`
- `question_type`
- `response_scale`
- `reverse_scored`
- `sensitivity_level`
- `requires_opt_in`
- `prompt_template_key`
- `scoring_strategy`
- `validity_notes`
- `active`
- `version`

This structure makes Gemini generation safer because the model works from typed templates and dimension metadata instead of from raw intuition.[cite:91]

## Adaptive Generation Flow

A production-safe generation pipeline should work like this:

1. User A finishes onboarding.
2. User B finishes onboarding.
3. The backend computes personal profile vectors for both.
4. The backend computes profile deltas and selects top mismatch and uncertainty zones.
5. The system builds a runtime prompt package for Gemini containing only:
   - allowed dimensions,
   - allowed item templates,
   - user profile summary values,
   - opt-in boundaries,
   - target number of items,
   - localization and tone constraints.
6. Gemini returns either:
   - selected existing items, or
   - tightly bounded item rewrites from approved templates.
7. The backend validates the returned items against schema and business rules.
8. The final generated questionnaire is stored as an immutable assessment instance.

This preserves auditability, reproducibility, and scoring consistency while still delivering personalization.[cite:91][cite:94]

## Prompting Strategy for Gemini

Gemini prompts should be structured, not conversational. The model should be told exactly what role it is performing and what output schema is required.

### Recommended Gemini responsibilities

#### A. Questionnaire assembly prompt

Input should include:

- Couple profile summary JSON
- Allowed dimensions and candidate item templates
- Required fixed core count
- Required adaptive count
- Forbidden patterns, such as double-barreled wording, mind-reading, or moralized phrasing
- Output schema requiring JSON only

#### B. Summary generation prompt

Input should include:

- Final score vectors
- Strongest alignments
- Highest mismatch areas
- Confidence and insight deltas
- User-safe tone instructions
- Bounded claim rules, such as “do not diagnose” and “avoid certainty language”

#### C. Weekly plan generation prompt

Input should include:

- Top 2 strengths
- Top 2 friction risks
- One growth opportunity area
- Time availability and preferred activity format
- Output requirements for 5-7 micro-actions or rituals

## Sample Gemini Prompt Template

```text
System role:
You are an assessment assembler for a relationship product. Your task is to build a personalized couple questionnaire using only the approved dimensions, templates, and rules provided. Do not invent new dimensions. Do not write double-barreled questions. Do not ask users to mind-read their partner.

Output:
Return valid JSON only with this schema:
{
  "assessment_name": string,
  "items": [
    {
      "template_key": string,
      "dimension": string,
      "question_text": string,
      "question_type": string,
      "options": [...],
      "reason": string
    }
  ]
}

Rules:
- Include exactly 18 fixed core items and 10 adaptive items.
- Adaptive items must target the top mismatch zones first.
- Prefer Likert items unless a scenario item better captures the construct.
- Avoid asking about favorite colors, favorite entertainment, or general trivia.
- If intimacy is not opt-in, exclude intimacy items.
```

## Validation Rules

Any Gemini-generated questionnaire should be rejected if it violates the following:

- More than one construct in a single item.[cite:90][cite:99]
- Mind-reading phrasing without confidence framing.[cite:90]
- Response options that overlap or are not mutually exclusive.[cite:96]
- More than 30% of adaptive items concentrated in one narrow construct unless explicitly intended.[cite:91]
- Sensitive content shown without opt-in.
- Items that cannot map to a known scoring rule.

## Reporting Blueprint

The reporting layer should explain the relationship in plain language while still being grounded in structured scores.

### Report sections

1. Overall relationship snapshot
2. Strongest areas of alignment
3. Likely tension patterns
4. How well each partner understands the other
5. One or two unfinished conversations worth having
6. One-week action plan

### Report tone rules

- Avoid labels that sound diagnostic or absolute.[cite:86]
- Use probabilistic phrasing such as “may create tension” or “appears important for both of you.”[cite:86]
- Distinguish between mismatch and incompatibility; not every difference is a problem.[cite:87]
- Frame growth opportunities as learnable patterns, not character flaws.[cite:87]

## UX Flow Recommendation

### First login

- Welcome
- Explain the value: “Answer a few quick questions so the app can personalize your relationship roadmap.”
- 15-question onboarding profile
- Progress bar and estimated time under 3 minutes
- Warm, non-clinical tone

### After personal onboarding

- Show a lightweight “your profile is ready” snapshot
- Invite partner
- Explain that the shared assessment becomes smarter once both people finish

### After both complete onboarding

- Generate and deliver the 28-question couple assessment
- Show why this assessment is customized, for example: “Built around communication rhythm, closeness needs, and future alignment.”
- Allow pause and resume

### After couple assessment

- Present scores visually but simply
- Offer 1-2 optional deep dives, not six at once
- Offer one immediate action, such as a guided conversation or weekly plan

## What to Replace in the Existing 52-Question Set

### Keep or adapt

These themes are strong and should remain in V2, though some wording needs tightening:

- Need for alone time / autonomy
- Conflict initiation difficulty
- Repair speed after conflict
- Affection expression frequency
- Value of rituals
- Alignment on future plans
- Presence without distraction
- Feeling deeply known
- Touch and non-sexual affection
- Fairness around money and responsibilities

### Reduce or move to optional

These should not dominate the core score:

- Favorite color / favorite series / favorite food style trivia
- Speculative “what your partner fears but never says” prompts
- Large clusters of open-ended memory questions
- Questions that combine two concepts in one rating

### Move to deep-dive or journal mode

- Childhood memory meaning
- Symbolic sensory nostalgia
- Parents / family-of-origin admiration reflections
- Unpursued dreams and identity themes

These can be powerful for intimacy or reflective prompts, but they belong in guided conversation experiences, not the core measurement spine.

## Implementation Roadmap

### Phase 1: Measurement foundation

- Define final dimension framework.
- Audit the current 52 questions.
- Rewrite or retire weak items.
- Build initial item bank of 80-120 approved questions.
- Add scoring metadata and validation rules.[cite:90][cite:91]

### Phase 2: Onboarding system

- Launch 15-question personal profile.
- Create personal profile vectors.
- Build basic profile summaries.
- Store score normalization pipeline.

### Phase 3: Adaptive generation

- Build fixed core question set.
- Create adaptive rules engine.
- Add Gemini question assembly prompts with strict schema.
- Validate output and persist generated assessment versions.[cite:91]

### Phase 4: Reporting and actions

- Generate user-safe summaries.
- Add tension risk and growth opportunity reporting.
- Generate guided conversations and weekly plans.
- Add optional deep-dive modules.

### Phase 5: Optimization

- Measure completion rate by stage.
- Measure question drop-off by item.
- Measure perceived relevance and emotional safety.
- Tune weights and adaptive selection logic from real usage data.[cite:86][cite:91]

## Success Metrics

Track success at product, measurement, and user-experience levels.

| Metric | Why it matters |
|---|---|
| Onboarding completion rate | Validates low-friction first-run flow |
| Couple assessment completion rate | Measures adaptive relevance |
| Average time to completion | Detects fatigue and over-complexity |
| Drop-off by item | Identifies confusing or heavy questions |
| Report usefulness score | Measures whether outputs feel actionable |
| Perceived personalization | Confirms adaptive approach is noticeable |
| Partner insight delta | Measures practical understanding gains over time |
| Repeat module participation | Indicates trust and ongoing value |

## Final Recommendation

The best approach is not to improve the existing 52-question questionnaire as a single static form. The better approach is to redesign the system around a short personal onboarding profile, a fixed-core adaptive couple assessment, and optional deep-dive modules.[cite:91][cite:97]

This architecture gives stronger metrics, lower first-session fatigue, better personalization, and more useful downstream AI outputs.[cite:91][cite:97] Gemini Cloud API should be used as a constrained generation and summarization layer on top of a structured item bank and deterministic scoring framework, not as a replacement for measurement design.[cite:86][cite:91]

## Immediate Next Steps

1. Freeze the target dimension framework.
2. Convert the current 52 items into an audit sheet: keep, rewrite, move, or remove.
3. Build the 15-item onboarding profile.
4. Define the 12 fixed core couple questions.
5. Create an adaptive bank of 40-60 candidate couple items.
6. Implement score normalization and profile-vector generation.
7. Build Gemini prompts for bounded questionnaire assembly and reporting.
8. Run pilot testing with real couples before hardening scoring weights.
