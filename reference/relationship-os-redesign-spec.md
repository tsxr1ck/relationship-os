# Relationship OS — UI/UX Complete Redesign Specification
### Version 3.0 · "Intimate Dark Editorial"

> **Design Philosophy:** Stop looking like a B2B SaaS tool. A relationship app should feel like a beautiful private journal that happens to be powered by AI. Warm, intimate, personal — with the precision of a premium analytics product underneath.

---

## 🔴 What's Wrong With the Current Design (Honest Audit)

| Area | Current Problem | Impact |
|---|---|---|
| Color palette | Purple gradient on light gray — the most overused combo in AI apps | Zero emotional resonance, generic |
| Sidebar | 20% of screen width for 5 nav items + huge dead space | Wastes premium screen real estate |
| Dashboard hero | "Su Viaje Juntos" copilot card feels like a Microsoft Teams onboarding screen | Impersonal, cold |
| 4C cards | Show "–" dashes in empty state — no visual hierarchy or personality | Looks broken, not inviting |
| Typography | Fully generic system sans-serif throughout | No editorial weight, no warmth |
| Light theme default | Relationship data should feel private, protected, warm | Feels clinical |
| Nosotros page | Big gradient banner but everything below is just prose lists | Not analytical enough for the richness of the data |
| Plan Semanal | Looks like Jira / linear task manager | Disconnected from the emotional context |

---

## 🎨 1. Design Language System

### 1.1 Aesthetic Direction: "Warm Dark Editorial"

Think: **Spotify Wrapped × a luxury therapy journal × Notion AI**

- **Dark first.** Default to a rich dark theme. Relationship data is intimate — dark mode signals privacy, focus, and premium quality.
- **Warm, not cold.** Current purples are cool and corporate. New palette uses warm tones — amber, rose, cream — that feel human.
- **Editorial moments.** Use serif typography for emotional statements (names, narrative text, scores). Use clean sans for data and UI chrome.
- **AI is ambient, not intrusive.** The AI doesn't announce itself with a dark hero box. It whispers. It surfaces inside cards, in subtle glows, in a thin animated underline.

---

### 1.2 Color Tokens

```css
/* === FOUNDATION === */
--color-base:        #0D0B0F;   /* Rich near-black with warm tint */
--color-surface-1:   #15121A;   /* Primary card backgrounds */
--color-surface-2:   #1E1A26;   /* Elevated surfaces, modals */
--color-surface-3:   #272230;   /* Hover states, inputs */
--color-border:      #2D2838;   /* Subtle borders */
--color-border-glow: #3D3550;   /* Active/focus borders */

/* === TEXT === */
--color-text-primary:   #F2EEF7;   /* Near-white with warm tint */
--color-text-secondary: #9B93AA;   /* Muted labels, metadata */
--color-text-tertiary:  #6B6178;   /* Placeholders, disabled */

/* === 4C DIMENSION COLORS — Each is an identity, not just a label === */
--color-conexion:      #E8748A;   /* Rose — Emotional Connection */
--color-conexion-dim:  #2D1820;   /* Dark rose surface for conexion cards */
--color-conexion-glow: rgba(232, 116, 138, 0.15);

--color-cuidado:       #F2A65A;   /* Amber — Tender Care */
--color-cuidado-dim:   #2A1D0E;   /* Dark amber surface */
--color-cuidado-glow:  rgba(242, 166, 90, 0.15);

--color-choque:        #5EC4B6;   /* Teal — Conflict Navigation */
--color-choque-dim:    #0E2320;   /* Dark teal surface */
--color-choque-glow:   rgba(94, 196, 182, 0.15);

--color-camino:        #C9A84C;   /* Gold — Shared Vision */
--color-camino-dim:    #231C07;   /* Dark gold surface */
--color-camino-glow:   rgba(201, 168, 76, 0.15);

/* === AI ACCENT === */
--color-ai:            #8B9FE8;   /* Cool periwinkle — distinctly "AI", not human */
--color-ai-dim:        #131627;
--color-ai-glow:       rgba(139, 159, 232, 0.12);

/* === SEMANTIC === */
--color-success:  #4ADE80;
--color-warning:  #FBBF24;
--color-danger:   #F87171;
```

---

### 1.3 Typography Scale

**Rationale:** Pair a warm serif for emotional/display moments with a geometric sans for data/UI.

```css
/* Display — Relationship names, narrative headlines, big scores */
font-family: 'DM Serif Display', serif;

/* Body & UI — Labels, data, navigation, buttons */
font-family: 'Geist', 'Inter', sans-serif;

/* Monospace — Timestamps, metadata, AI attribution tags */
font-family: 'Geist Mono', monospace;
```

**Type Scale:**
```
display-2xl:  56px / 1.1 / DM Serif Display   → "Ricardo & Melanie"
display-xl:   40px / 1.15 / DM Serif Display  → Page hero headlines
display-lg:   32px / 1.2 / DM Serif Display   → Section titles
title-xl:     24px / 1.3 / Geist SemiBold     → Card titles
title-lg:     20px / 1.4 / Geist SemiBold     → Sub-sections
body-lg:      16px / 1.6 / Geist Regular      → Narrative text
body-sm:      14px / 1.5 / Geist Regular      → Secondary content
label:        12px / 1.4 / Geist Medium (UC)  → Tags, labels
mono-sm:      12px / 1.4 / Geist Mono         → Metadata, timestamps
```

---

### 1.4 Elevation & Depth System

Dark UI needs layered depth, not shadows.

```
Layer 0 — Page background:  var(--color-base) — #0D0B0F
Layer 1 — Base cards:       var(--color-surface-1) + 1px border var(--color-border)
Layer 2 — Hover / elevated: var(--color-surface-2) + glow border
Layer 3 — Modals / sheets:  var(--color-surface-3) + backdrop blur
```

Cards use a subtle 1px border that transitions to a glowing border (`box-shadow: 0 0 0 1px var(--color-conexion)`) on hover/active. No drop shadows — glow borders only.

---

### 1.5 Motion Principles (Framer Motion)

```
Entrances:      fade-up, 20-30px, 0.4s ease-out, stagger 0.08s between siblings
Hover states:   scale(1.02), border glow, 0.15s
Number updates: animated counter (0 → value), 0.8s ease-out on mount
Score fills:    arc/bar fill animation left-to-right, 1.2s ease-out
AI text:        typewriter effect at 30ms/char for Copilot messages
Page transitions: opacity 0→1 + y 8→0, 0.3s, per-route
Pulse:          pulsing glow ring on AI elements, 2.5s infinite
```

---

## 🗂️ 2. Navigation Redesign

### 2.1 Kill the Wide Sidebar

The current 280px sidebar is wasteful. **Replace with a 64px icon rail** on desktop, **floating bottom bar** on mobile.

### 2.2 Desktop: Icon Rail (Left, 64px)

```
┌──────┐
│  ◉   │  ← App logo mark (small, glowing)
│──────│
│  ⌂   │  Inicio
│  ◎   │  Descubrir
│  ♡   │  Nosotros      ← Active: glowing pill behind icon, color = section accent
│  ⊞   │  Plan
│  ⚑   │  Retos
│──────│
│      │  (spacer)
│  ◯   │  Perfil        ← Avatar image, not an icon
└──────┘
```

**Icon Rail Details:**
- Width: `64px`, full height, `var(--color-surface-1)` background, right border `1px solid var(--color-border)`
- Icons: Lucide, 20px stroke-1
- Active state: A `40×40` rounded pill behind the icon, filled with the section's dimension color at 15% opacity, border at 40% opacity
- Tooltip: On hover, a floating label appears to the right: `position: absolute; left: 72px` — smooth slide-in
- Bottom: Clicking the avatar opens a popover with profile/sign-out options (no dedicated "Perfil" page cluttering nav)

### 2.3 Mobile: Floating Bottom Navigation

```
╔══════════════════════════════════════╗
║  ⌂      ◎      ♡      ⊞      ⚑     ║
╚══════════════════════════════════════╝
```

- `position: fixed; bottom: 16px; left: 50%; transform: translateX(-50%)`
- `width: calc(100% - 32px); max-width: 380px`
- Glassmorphism: `background: rgba(21, 18, 26, 0.85); backdrop-filter: blur(20px)`
- `border-radius: 24px; border: 1px solid var(--color-border)`
- Active icon gets a dot indicator in its dimension color

---

## 🏠 3. Dashboard (Inicio) — Complete Redesign

### 3.1 Layout Structure

Replace the current single-column blob layout with a **responsive grid**:

```
DESKTOP (1280px+):
┌────────────────────────────────────────────────────────────┐
│  RELATIONSHIP PULSE HERO                                    │  ← Full width, 280px tall
├──────────────────────────────┬─────────────────────────────┤
│  AI COPILOT CARD             │  4C HEALTH RING             │  ← 60/40 split
├──────────────────────────────┴─────────────────────────────┤
│  HOY ←  TASK DEL DÍA (interactive inline)                 │  ← Full width
├────────────┬────────────┬────────────┬─────────────────────┤
│ CONEXIÓN   │ CUIDADO    │ CHOQUE     │ CAMINO              │  ← 4 equal columns
│ mini-card  │ mini-card  │ mini-card  │ mini-card           │
├────────────┴────────────┴────────────┴─────────────────────┤
│  RETO ACTIVO              │  SABÍAS QUE (Daily Tip)        │  ← 50/50
└────────────────────────────────────────────────────────────┘

MOBILE:
Stacked vertically in this order:
1. Pulse Hero (full width, 220px)
2. AI Copilot Card
3. Tarea del Día
4. 4C Mini-Cards (2×2 grid)
5. Reto Activo
6. Daily Tip
```

---

### 3.2 Component: Relationship Pulse Hero

This is the emotional anchor of the dashboard. It replaces the current generic "Buenas tardes, Ricardo" header.

**Visual Design:**
- Full-width banner, `height: 280px` (desktop), `220px` (mobile)
- Background: Animated mesh gradient using the couple's current "dominant dimension" color. If Camino is highest → warm gold mesh. If Conexión is risk → subtle rose pulse.
  ```css
  background: radial-gradient(ellipse at 20% 50%, var(--color-camino-glow) 0%, transparent 60%),
              radial-gradient(ellipse at 80% 50%, var(--color-conexion-glow) 0%, transparent 60%),
              var(--color-surface-1);
  ```
- Subtle noise texture overlay: `opacity: 0.04` SVG noise filter
- A very faint topographic/wave SVG pattern in the background (pure CSS or inline SVG)

**Content Layout (horizontal):**
```
LEFT COLUMN:
  ┌────────────────────────────────┐
  │  [Avatar R] ♥ [Avatar M]       │  ← Overlapping avatars with glow ring
  │                                │
  │  Ricardo & Melanie             │  ← DM Serif Display, 40px
  │  Día 7 de crecimiento juntos   │  ← Body-sm, muted
  │                                │
  │  [♡ 312 días juntos]  [↑ Semana activa]  │  ← Pill badges
  └────────────────────────────────┘

RIGHT COLUMN (or overlaid on desktop):
  ┌────────────────────┐
  │  Salud general     │
  │       72%          │  ← Large animated number, DM Serif
  │  ████████░░ 4C     │  ← Mini horizontal bar breakdown
  └────────────────────┘
```

**Avatar Connection Animation (Framer Motion):**
- Both avatars `48px` circles, overlapping by `16px`, each with a `2px` border in their dimension color
- Between them: an animated SVG heart pulse line (like a heartbeat graph) that plays on mount and loops subtly
- The glow ring around the pair pulses at `2.5s` infinite using keyframes

---

### 3.3 Component: AI Copilot Card (Redesigned)

**Problem with current:** It's a dark imposing box that screams "I AM THE AI." It feels like an alert.

**New approach:** A soft, glowing card that feels like a gentle nudge from a wise friend.

**Visual Design:**
```
╔══════════════════════════════════════════════════════════╗
║  ✦ COPILOTO IA                                   [•••]  ║  ← "•••" = context menu
║                                                          ║
║  "Hoy sería un buen momento para la                     ║
║   actividad de Miércoles — llevan 3 días                ║  ← DM Serif italic, 22px
║   sin check-ins de Cuidado."                            ║
║                                                          ║
║  [Ver tarea →]    [Recordar mañana]                      ║
╚══════════════════════════════════════════════════════════╝
```

**Styles:**
- Background: `var(--color-ai-dim)` with `border: 1px solid rgba(139, 159, 232, 0.25)`
- Left accent: `4px` left border in `var(--color-ai)` — like a blockquote
- The AI text uses **typewriter animation on mount** (Framer Motion `animate` with staggered characters or word-by-word)
- `✦` icon pulses with `var(--color-ai-glow)` box-shadow
- **Contextual CTA:** The primary button changes dynamically:
  - No assessment → `"Iniciar Evaluación"`
  - Assessment done, no plan → `"Generar Plan Semanal"`
  - Plan active → `"Ver tarea de hoy"`
  - Active reto → `"Actualizar progreso"`
- Secondary action is always dismissible/snooze

---

### 3.4 Component: Tarea del Día (Inline Interactive)

Keep the existing `InteractivePlanItem` concept but redesign it visually.

```
╔══════════════════════════════════════════════════════════╗
║  MIÉRCOLES · PLAN SEMANAL                        5 min   ║
║                                                          ║
║  ○  Semáforo de Sentimientos                            ║
║     Comparte 3 palabras que describan cómo              ║
║     te has sentido esta semana con tu pareja.           ║
║                                                          ║
║  [✓ Marcar como hecha]    [→ Ver todas las tareas]      ║
╚══════════════════════════════════════════════════════════╝
```

- Background: `var(--color-cuidado-dim)` (because this task belongs to Cuidado dimension)
- The dimension is color-coded — the card's accent color matches which 4C it belongs to
- Checkbox is custom: a circle that fills with a checkmark animation on click (Framer Motion `AnimatePresence` + scale/opacity)
- `border-left: 4px solid var(--color-cuidado)`

---

### 3.5 Component: 4C Dimension Mini-Cards (Bottom Grid)

The current "Tu Mapa de Relación" with dashes is dead on arrival. Replace with richly designed mini-cards.

**Each card:**
```
╔══════════════════╗
║  CONEXIÓN        ║  ← Label monospace 11px uppercase
║                  ║
║       65%        ║  ← DM Serif Display 36px, bold, in dimension color
║                  ║
║  ████████░░      ║  ← Animated progress arc or bar (matches dimension color)
║                  ║
║  ▲ +3 esta sem   ║  ← Trend indicator with Framer motion count-up
╚══════════════════╝
```

- Each card has its own `--color-{dimension}-dim` background and `--color-{dimension}` accent
- Hover: `scale(1.03)`, border glow in dimension color, reveals a "Ver análisis →" link
- **Empty state (no data yet):** Instead of `–`, show a soft pulsing "?" with copy: *"Completa tu evaluación para ver este dato"* — feels like an invitation, not an error
- On click: navigate directly to `/dashboard/nosotros#conexion`

---

### 3.6 Component: Reto Activo Card

```
╔═══════════════════════════════════════════╗
║  🔥 RETO ACTIVO  ·  DÍA 3 DE 7            ║
║                                           ║
║  48 Horas Sin Pantallas                  ║  ← DM Serif 24px
║                                           ║
║  ▓▓▓▓▓░░░░░  43%                          ║  ← Warm gold progress bar
║                                           ║
║  [Registrar progreso hoy]                ║
╚═══════════════════════════════════════════╝
```

- Dimension: `var(--color-camino)` theme (since retos map to Camino)
- The progress bar is a custom SVG or Tailwind with animated width on mount

---

## 🧠 4. Nosotros Page — Redesign

### 4.1 New Layout Structure

The current page has a big hero card then linear content below. Redesign as an **immersive analytical view** with tabbed depth.

```
HEADER ZONE:
  Full-bleed title zone with couple name + animated score ring
  
TAB BAR:
  [Nuestra Historia]  [Las 4 Dimensiones]  [Comparativa]  [Consejos]

TAB: Nuestra Historia
  ┌──────────────────────────────────────────────────────┐
  │  AI Narrative card (warm, not purple)                │
  │  "Ricardo y Melanie navegan su relación con..."      │
  │                                                      │
  │  [Regenerar ↺]  ← Small ghost button, not prominent │
  └──────────────────────────────────────────────────────┘
  
  Below: 4 "Chapter" cards, one per dimension
  Each reveals the dimension summary + growth tip

TAB: Las 4 Dimensiones
  Full radar chart (redesigned, dark theme)
  Below: 4 expanded dimension cards with bar charts comparing partners

TAB: Comparativa
  Side-by-side partner comparison view
  Visual delta indicators showing mismatch/alignment

TAB: Consejos
  Growth tips displayed as a beautiful list/cards
  Each tip linked back to its dimension
```

---

### 4.2 Component: Narrative Card (Replacing Purple Hero)

**Current:** Large purple gradient banner that dominates the page and feels generic.

**New:** A warm editorial card that reads like a magazine pullout.

```
╔══════════════════════════════════════════════════════════╗
║                                             ✦ Generado por IA  ║
║                                                          ║
║  "Ricardo y Melanie navegan su relación                 ║
║   con una visión compartida que los                     ║  ← DM Serif italic 22px
║   impulsa hacia adelante."                              ║
║                                                          ║
║  Su fortaleza está en el Camino compartido, con        ║
║  oportunidades de crecer en la expresión del           ║  ← Body-lg 16px, muted
║  Cuidado cotidiano.                                     ║
║                                                          ║
║  ─────────────────────────────────────                  ║
║  [Regenerar historia ↺]                                 ║
╚══════════════════════════════════════════════════════════╝
```

- Background: `var(--color-surface-1)`, no gradient
- Left border: `4px solid` with a gradient from `var(--color-camino)` to `var(--color-conexion)` — representing the couple's unique blend
- The opening quote sentence is styled differently (larger, italic, DM Serif) from the body paragraph — editorial pull-quote style
- "Regenerar" is a ghost button (no fill), not a prominent CTA — it's a utility, not the main action

---

### 4.3 Component: Dimension Cards (Expanded)

Each of the 4C dimensions gets a full card section:

```
╔═══════════════════════════════════════════════════════════╗
║  ● CONEXIÓN EMOCIONAL                              65%    ║
║  ─────────────────────────────────────────────────────── ║
║                                                           ║
║  Ricardo     ███████░░░  70%                             ║
║  Melanie     ██████░░░░  60%                             ║
║                                                           ║
║  Delta: +10 · Zona de OPORTUNIDAD ▲                      ║
║                                                           ║
║  ✦ IA: "En tu conexión emocional, hay una base sólida.  ║
║  Busca momentos para compartir sentimientos profundos."  ║
║                                                           ║
║  [Ver análisis completo →]                               ║
╚═══════════════════════════════════════════════════════════╝
```

- Header uses dimension color for the dot and percentage
- Both partner bars shown as dual horizontal bars (like a back-to-back bar chart)
- Delta badge: green = opportunity, amber = watch, red = risk — each with its icon
- AI insight is visually distinct: slightly indented, `✦` prefix, `var(--color-ai)` text color

---

## 📅 5. Plan Semanal — Redesign

### 5.1 New Layout

Move away from the Jira/linear feel. Make it feel like a **week in someone's life**, not a task tracker.

```
HEADER:
  "Plan de la Semana" · 22–28 de marzo
  [Progress ring 0/7]  [Generate new plan ↺ IA]

WEEK STRIP:
  A horizontal scrollable week view where each day is a pill:
  ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┐
  │ Lun │ Mar │ Mié │ Jue │ Vie │ Sáb │ Dom │
  │  1  │  2  │  3  │  4  │  5  │  6  │  7  │
  │  ✓  │  ●  │  ○  │  ○  │  ○  │  ○  │  ○  │
  └─────┴─────┴─────┴─────┴─────┴─────┴─────┘
  ✓ = completed (green dot)  ● = today (accent pill)  ○ = pending

TASK FEED:
  Tasks displayed as rich cards, NOT a checklist:
```

### 5.2 Task Cards (Redesigned)

```
╔══════════════════════════════════════════════════════════╗
║  LUNES · CONEXIÓN                              ⏱ 10 min  ║
║                                                          ║
║  Sorpresa de Inicio de Semana                           ║  ← Title 20px Geist SemiBold
║                                                          ║
║  Prepara un pequeño gesto sorpresa para tu pareja      ║  ← Description (expandable)
║  antes de que termine el día. Puede ser una nota,      ║
║  un café, o simplemente decirlo con palabras.          ║
║                                                          ║
║  [○ Marcar completa]    [— Omitir]    [✎ Nota privada] ║
╚══════════════════════════════════════════════════════════╝
```

- Background: `var(--color-conexion-dim)` (matches the task's 4C dimension)
- On "Marcar completa": The card gets a checkmark animation, the background briefly flashes `var(--color-success)` at 20% opacity, then the card gracefully slides out with `AnimatePresence` exit animation
- "Nota privada" opens an inline textarea expansion (no navigation required)
- Dimension label in top-left is a colored badge

---

## ⚡ 6. Retos Page — Redesign

### 6.1 Layout

```
HEADER:
  "Retos de Relación"
  Tagline: "Desafíos diseñados para acercarlos más"

ACTIVE CHALLENGE BANNER (if any):
  Full-width card showing current reto progress (same design as dashboard card)

CATALOG:
  Tab filter: [Todos] [Fácil] [Medio] [Profundo]
  
  Grid of challenge cards:
```

### 6.2 Challenge Cards

```
╔══════════════════════════════════╗
║  ⚡ FÁCIL · CONEXIÓN              ║
║                                  ║
║  Semáforo de Sentimientos       ║  ← DM Serif 20px
║                                  ║
║  Comparte tu estado emocional    ║
║  usando colores como señal.     ║
║                                  ║
║  ⏱ 15 min · 👥 Juntos            ║
║                                  ║
║  [Aceptar reto →]                ║
╚══════════════════════════════════╝
```

- Card grid: `grid-cols-1 md:grid-cols-2 lg:grid-cols-3`
- Each difficulty level has a color: Easy → teal, Medium → amber, Deep → rose
- On "Aceptar reto": AI coaching text appears in an animated bottom sheet / modal before confirming

---

## 🔍 7. Descubrir Page — Redesign

### 7.1 Consolidation Idea

**Consider merging Descubrir + Nosotros** into a single `/dashboard/analisis` page with internal tabs:
- `Mi Perfil` (personal dimension scores, coach message)
- `Nosotros` (couple scores, narrative, comparison)
- `Insights IA` (growth tips, coaching messages per dimension)

This avoids the current confusion of having two pages that both show dimension data.

### 7.2 "Tu Coach Personal" Card (Redesigned)

```
╔══════════════════════════════════════════════════════════╗
║  ✦ TU COACH PERSONAL                                     ║
║                                                          ║
║  Ricardo, estás invirtiendo activamente                 ║
║  en tu relación. Tu Conexión Emocional                  ║  ← Typewriter animation
║  muestra una base sólida — el siguiente                 ║
║  paso es fortalecer el Cuidado diario.                  ║
║                                                          ║
║  → Dimensión a trabajar esta semana: Cuidado ●          ║
╚══════════════════════════════════════════════════════════╝
```

- The "→ Dimensión a trabajar" line links directly to the Plan Semanal filtered by that dimension

---

## 📐 8. Spacing & Sizing System

```
--space-1:  4px
--space-2:  8px
--space-3:  12px
--space-4:  16px
--space-5:  20px
--space-6:  24px
--space-8:  32px
--space-10: 40px
--space-12: 48px
--space-16: 64px

Card padding:         24px (desktop), 16px (mobile)
Card border-radius:   16px outer, 12px inner elements
Section gap:          32px desktop, 24px mobile
Page side padding:    48px desktop, 16px mobile
```

---

## 🧩 9. Component Library Additions (shadcn/ui Extensions)

The following components need to be custom-built or heavily styled on top of shadcn primitives:

### New Components Needed:

| Component | Purpose | Notes |
|---|---|---|
| `<DimensionCard>` | 4C score display | Custom arc + trend indicator |
| `<RelationshipPulseHero>` | Dashboard hero | Animated avatars + mesh gradient |
| `<AICopilotCard>` | Contextual AI message | Typewriter, left-accent border |
| `<TaskCard>` | Plan Semanal item | Dimension-colored, inline complete |
| `<WeekStrip>` | Day selector | Horizontal scroll, today highlight |
| `<ChallengeCard>` | Reto catalog item | Difficulty-colored, modal on click |
| `<NarrativeCard>` | AI story display | Editorial pull-quote style |
| `<PartnerComparisonBar>` | Dual bar chart | Two bars + delta badge |
| `<DimensionBadge>` | Inline label | Color-coded pill per 4C |
| `<IconRail>` | Desktop nav | 64px, icon-only, tooltips |
| `<FloatingNav>` | Mobile nav | Glassmorphism bottom bar |

---

## 🛠️ 10. Implementation Priority Order

### Phase 1 — Foundation (Do First)
1. Install `DM Serif Display` from Google Fonts (add to `layout.tsx`)
2. Define all CSS tokens in `globals.css`
3. Build `<IconRail>` + `<FloatingNav>` — replace sidebar immediately
4. Apply dark theme as default (`class="dark"` on `<html>`)

### Phase 2 — Dashboard Core
5. Build `<RelationshipPulseHero>` with placeholder data
6. Redesign `<AICopilotCard>` with typewriter effect
7. Build 4 `<DimensionCard>` components (with proper empty states)
8. Restyle `<TaskCard>` with dimension color system

### Phase 3 — Inner Pages
9. Redesign Nosotros with tab structure + `<NarrativeCard>`
10. Redesign `<PartnerComparisonBar>` for dimension detail
11. Redesign Plan Semanal with `<WeekStrip>` + new task cards
12. Redesign Retos catalog with challenge cards + bottom sheet confirm

### Phase 4 — Polish
13. Add Framer Motion entrance animations to all pages (staggered fade-up)
14. Add `AnimatePresence` to task completion flows
15. Implement loading skeletons for all AI-dependent sections (match final design shape exactly)
16. Mobile responsiveness pass

---

## 🎯 11. Key Design Decisions Summary

| Decision | Why |
|---|---|
| Dark theme by default | Intimacy, privacy, premium feel — relationship data is personal |
| Icon rail instead of wide sidebar | Recovers ~200px of content real estate |
| 4C has its own color identity | Makes the framework feel real and learnable, not abstract |
| DM Serif Display for emotional text | Warmth + editorial weight that generic sans can't provide |
| Glow borders instead of shadows | Dark UI best practice, more premium than drop shadows |
| Typewriter effect for AI text | Makes AI feel alive and thinking, not pre-rendered |
| Dimension-colored task cards | Every UI element reinforces the 4C mental model |
| Consolidate Descubrir + Nosotros | Reduces navigation confusion — both pages currently show dimension data |
| No gradient hero on Nosotros | Gradients feel decorative; editorial feels meaningful |
| Merge narrative + data in one Nosotros | The story and the data should live together, reinforce each other |

---

## 📎 Appendix: Shadcn/Tailwind Quick-Wins

These can be applied immediately without major refactoring:

```tsx
// 1. Dark mode wrapper — add to layout.tsx
<html className="dark">

// 2. Font loading — layout.tsx
import { DM_Serif_Display } from 'next/font/google'
const dmSerif = DM_Serif_Display({ weight: '400', subsets: ['latin'], variable: '--font-display' })

// 3. Tailwind dark tokens in tailwind.config.ts
theme: {
  extend: {
    colors: {
      conexion: '#E8748A',
      cuidado: '#F2A65A',
      choque: '#5EC4B6',
      camino: '#C9A84C',
      ai: '#8B9FE8',
    },
    fontFamily: {
      display: ['var(--font-display)', 'serif'],
    }
  }
}

// 4. Base card style (replaces generic white cards)
const cardBase = "bg-[#15121A] border border-[#2D2838] rounded-2xl p-6 hover:border-[#3D3550] transition-all duration-200"

// 5. Dimension badge component
const dimensionColors = {
  conexion: 'bg-[#2D1820] text-[#E8748A] border-[#E8748A]/30',
  cuidado:  'bg-[#2A1D0E] text-[#F2A65A] border-[#F2A65A]/30',
  choque:   'bg-[#0E2320] text-[#5EC4B6] border-[#5EC4B6]/30',
  camino:   'bg-[#231C07] text-[#C9A84C] border-[#C9A84C]/30',
}
```

---

*This document is the single source of truth for the Relationship OS v3.0 visual redesign. All component work should reference the design tokens, spacing system, and aesthetic direction defined here.*
