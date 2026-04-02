# Couples App UX/UI Blueprint: From Dashboard to Shared Space

## Purpose

This blueprint translates the proposed redesign direction into a practical implementation plan for a couples app that currently feels like a SaaS dashboard instead of an intimate shared space. The goal is not a cosmetic redesign alone, but a product-level shift in mental model: from **tool I use** to **space we share**.

The recommendation assumes the current visual quality is already strong, and that the higher-value opportunity is improving emotional texture, flow, navigation hierarchy, and mobile behavior rather than rebuilding everything from scratch.

---

## Product Principle

### Current Problem

The current interface likely communicates structure, features, and utility well, but it frames the experience like software:

- Sidebar-driven navigation
- Sectioned feature discovery
- Data-card logic
- Dashboard mindset

That model is efficient, but emotionally wrong for the use case. Couples do not want to “open a dashboard” to connect. They want the app to feel warm, personal, alive, and relational.

### New Mental Model

The app should behave like:

- a shared journal,
- a quiet relationship companion,
- a living space that reflects both people,
- a place that remembers moments and surfaces meaning.

This means the product should prioritize:

1. Presence over information density.
2. Story over feature navigation.
3. Emotional continuity over modular tooling.
4. Mobile intimacy over desktop productivity patterns.

---

## Primary Redesign Goal

Rebuild the home experience as a **moment-driven mobile-first vertical feed** that tells the story of the relationship today.

Instead of opening into a navigation shell, the user should open into a single scrollable relationship surface containing:

- what is happening right now,
- one active prompt or action,
- one resurfaced memory,
- one AI insight phrased like a message,
- one subtle partner-presence signal.

The user should feel they are checking in on **us**, not checking app modules.

---

## Strategic Scope

### What should change now

- Home architecture
- Mobile navigation model
- Content hierarchy
- Emotional tone of surfaces and copy
- Shared/personal state cues
- Micro-interactions and presence mechanics

### What should *not* change immediately

- Entire backend domain model
- Every feature taxonomy at once
- Large-scale desktop-first layouts
- Visual system from zero unless necessary

### Product strategy recommendation

Adopt an **experience refactor**, not a full redesign rewrite.

That means:

- Keep what already feels premium.
- Change the structure users move through.
- Retheme selectively where it supports emotional tone.
- Launch in phases with measurable behavior changes.

---

## Recommended Direction

## Direction Choice

The strongest short-term path is:

### Direction 1: Warm Intimate Dark

This is the recommended implementation baseline because it preserves momentum while changing the product feel most effectively.

Why this direction wins:

- It evolves the current app instead of replacing it.
- It minimizes implementation risk.
- It supports nighttime use and emotional intimacy.
- It lets the team focus on flow, hierarchy, and interaction design first.
- It avoids spending months rebuilding a brand layer that is already good.

### Direction 1 Design Goals

Transform the current dark premium interface from:

- cool,
- analytical,
- system-like,
- feature-oriented

into something more:

- warm,
- tactile,
- personal,
- reflective,
- relationship-centered.

### Visual adjustments for this direction

- Shift accents from cool purple-blue toward amber, muted rose, copper, soft terracotta, or candlelit gold.
- Reduce visible hard card borders.
- Increase use of blurred depth, layered glow, and tonal contrast instead of outlined boxes.
- Use editorial typography with more warmth and softness.
- Increase vertical rhythm and breathing room in the main feed.
- Make modules feel like notes, memories, prompts, and presence signals—not widgets.

---

## Experience Architecture

## Core Navigation Rewrite

### Current pattern to replace

A SaaS-style left sidebar or feature-first shell should no longer be the primary navigation pattern on mobile.

### New mobile navigation model

Use a bottom navigation bar with a maximum of 4 primary destinations.

### Recommended nav structure

| Destination | Purpose | Notes |
|---|---|---|
| Hoy | Relationship feed and primary check-in | Default landing screen |
| Nosotros | Shared memories, timeline, relationship space | Can absorb Descubrir |
| Plan | Shared planning, date ideas, goals, upcoming moments | Keep action-oriented |
| Perfil | Personal insights, coaching, settings, account | Includes private/self space |

### Merge recommendations

To reduce navigation complexity:

- Merge **Descubrir** into **Nosotros** as sub-surfaces like prompts, ideas, and inspiration.
- Merge **Quizzes** into **Plan** or into a broader “Retos y Actividades” system.
- Keep total top-level nav items at 4 maximum.

### Desktop behavior

Desktop becomes adaptive, not primary.

Recommended desktop approach:

- Keep a compact left rail or top nav only on larger screens.
- Preserve the same information architecture as mobile.
- Avoid creating a separate desktop mental model.
- Desktop should feel like a wider version of the same emotional product, not a management console.

---

## Home Screen Blueprint

## New “Hoy” Feed

The home screen should be a single vertically scrolling story of the relationship today.

### Feed design principle

Every block in the feed must answer one of these questions:

- What’s happening between us right now?
- What deserves attention today?
- What meaningful thing from our history should resurface?
- What did my partner recently do here?
- What insight or invitation should guide our next interaction?

### Suggested feed order

1. Emotional header
2. Primary action card
3. Partner presence card
4. Shared progress or current challenge
5. Resurfaced memory card
6. AI insight/message
7. Optional supporting modules

### 1. Emotional header

This replaces a generic dashboard title.

Should include:

- contextual greeting,
- subtle date/time/relationship context,
- emotional microcopy,
- possibly streak or current relationship phase indicator.

#### Example content directions

- “Esta noche tienen una pregunta pendiente.”
- “Hace 2 días que no completan algo juntos.”
- “Hoy es un buen día para reconectar.”

The tone must feel warm, low-pressure, and human.

### 2. Primary action card

This is the most important object on the screen.

Rules:

- Only one primary CTA should dominate.
- It should represent the best next action for the couple *today*.
- It should adapt dynamically based on state.

Possible states:

- pending relationship question,
- shared challenge in progress,
- unfinished reflection,
- planned activity due today,
- “continue where you left off.”

#### Example titles

- “Tienen una pregunta esperándolos.”
- “Continúen el reto que empezaron anoche.”
- “Hoy toca planear algo juntos.”

### 3. Partner presence card

This is one of the most emotionally valuable additions.

It should communicate warmth and shared occupation of the space.

#### Content ideas

- “Melanie estuvo aquí hace 2 horas.”
- “Melanie respondió la pregunta de hoy.”
- “Melanie guardó una idea para ustedes.”

#### Rules

- Never make it feel like surveillance.
- Avoid exact timestamps if they feel invasive.
- Use soft relative time.
- Pair activity with relational context when possible.

Good:

- “Estuvo aquí esta tarde.”
- “Te dejó una respuesta hace un rato.”

Avoid:

- “Last active 2:13 PM.”
- “Online now” if the product is not truly synchronous.

### 4. Shared progress or current challenge

This module should answer: what are we currently building together?

Can show:

- active challenge,
- streak,
- completion state,
- percentage or step progression,
- next milestone.

Important: the presentation should feel celebratory or collaborative, not KPI-driven.

Replace cold metrics like:

- completion rate,
- engagement score,
- dashboard graphs,

with warmer language such as:

- “Les faltan 2 pasos para completar esto juntos.”
- “Van muy bien con este reto.”
- “Ya casi terminan este momento compartido.”

### 5. Resurfaced memory card

This creates continuity and makes the space feel alive over time.

#### Purpose

Bring back meaningful shared history in a lightweight, emotionally resonant way.

#### Content examples

- “Hace 3 semanas completaron esta actividad juntos.”
- “Ese día ambos eligieron la misma respuesta.”
- “Guardaron esta idea para una cita futura.”

#### Design notes

- Use archival styling or softer visual treatment.
- Distinguish memory from current action.
- This card should feel reflective, not urgent.

### 6. AI insight as message

The AI layer should not feel like analytics.

It should behave like a relationship-aware companion that notices patterns and surfaces encouraging, respectful observations.

#### Wrong framing

- “Relationship engagement increased by 14%.”
- “Based on your quiz completion behavior...”

#### Right framing

- “Parece que conectan más cuando responden algo corto pero personal.”
- “Esta semana han mostrado constancia; quizá es buen momento para una conversación más profunda.”
- “Han estado cerca en actividad, pero no tanto en reflexión. Hoy podría ser un buen día para una pregunta más íntima.”

#### Product rule

Every AI insight should read like a message, invitation, reflection, or gentle nudge—not a report.

---

## Information Hierarchy

## UX Priorities

The redesigned app should always prioritize content in this order:

1. Shared present moment
2. Best next action
3. Partner presence
4. Shared continuity/history
5. AI meaning layer
6. Secondary exploration
7. Settings/admin/system content

This hierarchy should drive:

- layout order,
- font scale,
- card sizing,
- visual weight,
- notification logic,
- motion emphasis.

Anything that does not serve this hierarchy should be visually reduced or moved deeper into the app.

---

## Personal vs Shared Space

## Transitional Version of Direction 3

Even if the team does not fully implement the “dual mode” vision right now, the redesign should introduce a semantic distinction between:

- **My space**
- **Our space**

### Recommended implementation now

Use visual and structural cues to distinguish these contexts without a full visual-system split.

#### Shared space traits

- warmer surfaces,
- brighter highlights,
- more celebratory states,
- partner-avatar pairing,
- joint language (“ustedes”, “juntos”, “nosotros”).

#### Personal space traits

- slightly quieter palette,
- more muted tone,
- reflection/coaching framing,
- self-oriented copy.

### Product sections by mode

| Area | Mode | Notes |
|---|---|---|
| Hoy | Shared-first | Default emotional landing |
| Nosotros | Shared | Memories, relationship layer, intimacy features |
| Plan | Shared | Dates, goals, upcoming experiences |
| Perfil / Coaching | Personal | Insights, private reflection, account settings |

### Why this matters

Users should be able to sense when they are in a personal reflective zone versus a shared relational zone. That distinction improves clarity and deepens the emotional texture of the product.

---

## UI System Changes

## Visual Language

The current interface should be evolved with the following concrete changes.

### 1. Surface treatment

Move away from hard SaaS card metaphors.

#### Current anti-patterns to reduce

- strong bordered cards,
- dense tile layouts,
- equal-weight dashboard modules,
- over-segmented panels.

#### New system

- soft layered surfaces,
- tonal grouping instead of visible outlines,
- larger hero cards for the main action,
- blended containers with subtle translucency or ambient depth,
- fewer but more meaningful modules per screen.

### 2. Corners and shape language

Use softer geometry.

Recommended:

- medium to large radii on cards,
- fewer sharp corners,
- more organic spacing,
- occasional overlapping depth for intimacy.

Avoid making everything perfectly symmetrical and grid-rigid.

### 3. Color system

Shift toward a warmer emotional palette.

#### Suggested palette direction

- base: charcoal espresso / deep warm graphite,
- elevated surfaces: cocoa, plum-brown, warm slate,
- accents: amber, rose gold, muted terracotta, candle gold,
- success/celebration: softened warm green,
- memory/archive surfaces: faded mauve or smoke-rose tint.

#### Color rules

- Primary CTA should remain clearly visible.
- Accent color should signal warmth, not tech.
- Avoid cold neon AI colors.
- Use color sparingly to preserve premium feel.

### 4. Typography

Maintain editorial quality but make it feel more personal.

Guidelines:

- Use a refined display face only for select emotional headings.
- Keep body/UI typography legible and quiet.
- Increase contrast between intimate headings and system labels.
- Replace analytic labels with warmer content titles.

#### Example shift

From:

- “Insights”
- “Activity Status”
- “Engagement Metrics”

To:

- “Lo que está vivo entre ustedes”
- “Hoy entre ustedes”
- “Un momento para volver”

### 5. Iconography

Reduce excessive feature-icon dependency.

Use icons as support, not as the main emotional affordance. In this app, text tone, spacing, avatars, and motion will communicate more intimacy than decorative icon circles.

---

## Motion System

## Emotional Micro-Interactions

Motion should make the app feel inhabited.

### Motion principles

- soft,
- low-friction,
- subtle,
- affirming,
- relational.

Avoid motion that feels gamified, loud, or productivity-oriented.

### Priority micro-moments to implement

#### 1. Partner completion acknowledgment

When Melanie completes something, show a subtle in-app acknowledgment such as:

- a softly animated toast sheet,
- a presence pulse in the feed,
- a tiny celebratory shimmer on the relevant card.

The goal is not notification overload; it is emotional continuity.

#### 2. Joint completion moment

When both users complete the same activity, trigger a warmer celebratory state.

Examples:

- soft confetti dust,
- glowing border pulse,
- merged avatar animation,
- small “completado juntos” banner.

This is a high-value delight mechanic because it reinforces togetherness.

#### 3. Memory resurfacing animation

When an old shared moment appears, animate it gently as if resurfacing from the archive.

Examples:

- fade + rise,
- blur-to-focus,
- subtle timeline reveal.

#### 4. AI message reveal

AI messages should appear like receiving a note, not loading a report.

Examples:

- progressive text reveal,
- card fade with slight lift,
- soft ambient highlight.

### Motion constraints

- Keep transitions under control; never over-animate the whole feed.
- Use reduced motion support.
- Make the primary action feel most alive.
- Shared events deserve more delight than personal admin actions.

---

## Content Design

## Voice and Microcopy

A major part of the redesign is linguistic.

The app should stop sounding like a feature platform and start sounding like a relationship companion.

### Copy principles

- warm but not cheesy,
- intimate but not overly sentimental,
- simple,
- present-tense,
- invitation-based,
- low-pressure,
- human.

### Replace system phrasing with relational phrasing

| System-like copy | Better relational copy |
|---|---|
| View insights | Mira lo que hoy se mueve entre ustedes |
| Pending task | Tienen algo pendiente juntos |
| Last activity | Melanie estuvo aquí hace un rato |
| AI recommendation | Una idea para hoy |
| Progress tracker | Así van con este momento compartido |

### Tone guardrails

Avoid:

- pseudo-therapeutic jargon,
- clinical relationship language,
- corporate growth language,
- data terminology.

Prefer:

- warmth,
- softness,
- clarity,
- lived-in intimacy.

---

## Feature-Level Changes

## Priority Implementation List

### 1. Home feed rebuild

This is the highest-impact change.

#### Deliverables

- New mobile-first “Hoy” route
- Card-based vertical feed
- Dynamic content priority engine
- One dominant CTA logic
- Presence module
- Memory module
- AI message module

### 2. Navigation simplification

#### Deliverables

- Bottom nav on mobile
- 4-item max information architecture
- Merged destinations and taxonomy rewrite
- Desktop adaptation that mirrors mobile structure

### 3. Presence system

#### Deliverables

- Relative-time partner last activity
- Last completed shared interaction
- Presence card on home
- Optional lightweight feed badges for recent partner activity

#### Data model notes

Track:

- last app open,
- last shared activity completed,
- last response submitted,
- last saved item relevant to partner visibility.

### 4. Shared-state celebration system

#### Deliverables

- Joint completion state UI
- Shared streak or momentum messaging
- Contextual celebratory micro-interactions
- Distinction between solo completion and mutual completion

### 5. Resurfaced memories system

#### Deliverables

- Time-based resurfacing logic
- Memory card templates
- Archive styling
- “On this moment” style entry points

Potential triggers:

- same activity completed X days/weeks ago,
- similar answer patterns,
- saved plans not revisited,
- anniversaries of meaningful in-app events.

### 6. AI insight reframing

#### Deliverables

- Rewrite AI output templates as conversational notes
- Remove data-report framing from UI
- Create categories: encouragement, reflection, invitation, pattern notice
- Add contextual placement rules in feed

---

## Functional Requirements

## Home Feed Module Specs

### A. Header module

**Inputs**
- user name
- partner name
- time of day
- relationship activity context

**Outputs**
- personalized greeting
- one-line emotional context

### B. Primary action module

**Inputs**
- pending shared action
- incompleted challenge
- due plan item
- highest-value suggested interaction

**Rules**
- exactly one primary action visible above the fold
- fallback to suggested reconnection action if nothing pending

### C. Partner presence module

**Inputs**
- partner last activity timestamp
- partner last visible action type

**Rules**
- convert timestamps to soft relative labels
- never expose private activity that should remain individual-only
- support no-recent-activity fallback copy

### D. Shared progress module

**Inputs**
- active challenge or sequence
- per-user completion state
- milestone thresholds

**Rules**
- express progress relationally rather than analytically
- emphasize next shared step

### E. Memory resurfacing module

**Inputs**
- historical shared activities
- age of event
- relevance score
- optional media or answer snippet

**Rules**
- only surface emotionally meaningful events
- avoid repetition fatigue
- rotate based on freshness and relevance

### F. AI message module

**Inputs**
- interaction history
- relationship behavior patterns
- current feed state

**Rules**
- tone must feel message-like
- max one primary AI insight in main feed at a time
- no cold diagnostic language

---

## UX Flows

## Target User Journeys

### Journey 1: Solo nightly check-in

1. User opens app on mobile.
2. Lands directly in Hoy feed.
3. Sees that Melanie was recently active.
4. Sees one pending question or shared action.
5. Completes or reads it.
6. Feels continued connection even if partner is absent.

### Journey 2: Shared completion moment

1. One partner completes an activity.
2. The other later opens the app.
3. Feed communicates that the activity is now ready or half-complete.
4. Second partner completes it.
5. App celebrates joint completion in a subtle shared way.
6. Feed then transitions to a reflective or next-step state.

### Journey 3: Re-engagement after inactivity

1. User returns after several days.
2. Home does not dump a dashboard.
3. It offers a warm re-entry with one suggested action, one memory, and one partner signal.
4. User feels welcomed back instead of confronted by backlog.

### Journey 4: Personal reflection vs shared space

1. User opens profile/coaching view.
2. Visual tone becomes slightly quieter and more private.
3. User returns to Hoy or Nosotros.
4. Shared warmth and dual-partner framing returns.

This transition reinforces the product’s emotional architecture.

---

## Technical Implementation Plan

## Frontend Architecture Recommendations

### Route-level structure

Recommended core app shells:

- `/today` or `/hoy`
- `/us` or `/nosotros`
- `/plan`
- `/profile`

### Component domains

Suggested top-level UI domains:

- `TodayFeed`
- `TodayHeader`
- `PrimaryActionCard`
- `PartnerPresenceCard`
- `SharedProgressCard`
- `MemoryResurfaceCard`
- `AiInsightCard`
- `BottomNav`
- `SharedModeShell`
- `PersonalModeShell`

### State considerations

You do not need a full backend rewrite to begin.

Start by composing the home feed from existing data sources where possible.

Possible data adapters:

- partner activity events,
- challenge/task states,
- memory/history records,
- AI insight output,
- plan/upcoming items,
- per-user visibility flags.

### Feed orchestration layer

Create a feed-prioritization layer that decides what appears and in what order.

Pseudo-priority logic:

1. Determine best next action.
2. Determine whether partner has meaningful recent presence.
3. Pull one relevant progress module if active.
4. Pull one resurfaced memory.
5. Pull one AI note.
6. Fill remaining space with lower-priority context modules.

This orchestration layer is more important than card styling.

---

## Suggested Data Contracts

### Partner presence event

```ts
interface PartnerPresenceEvent {
  partnerId: string;
  type: 'opened_app' | 'completed_activity' | 'answered_prompt' | 'saved_plan';
  createdAt: string;
  visibleInSharedFeed: boolean;
  sharedLabel?: string;
}
```

### Today primary action

```ts
interface TodayPrimaryAction {
  id: string;
  type: 'pending_question' | 'continue_challenge' | 'plan_together' | 'reflection' | 'suggested_reconnect';
  title: string;
  subtitle: string;
  ctaLabel: string;
  priorityScore: number;
}
```

### Resurfaced memory

```ts
interface ResurfacedMemory {
  id: string;
  sourceType: 'challenge' | 'question' | 'saved_plan' | 'milestone';
  title: string;
  description: string;
  occurredAt: string;
  relevanceScore: number;
  visualStyle: 'archive' | 'celebration' | 'reflection';
}
```

### AI note

```ts
interface RelationshipAiNote {
  id: string;
  category: 'encouragement' | 'reflection' | 'pattern' | 'invitation';
  message: string;
  generatedAt: string;
  contextKey?: string;
}
```

---

## Design System Tokens

## Practical Token Direction

These are not final values, but implementation intent.

### Color tokens

```ts
const colors = {
  bg: '#151311',
  surface: '#1d1a18',
  surfaceElevated: '#26211e',
  surfaceSoft: '#2d2622',
  textPrimary: '#f4ede6',
  textSecondary: '#c7b9ab',
  textMuted: '#9a8d82',
  accentPrimary: '#d89a5b',
  accentRose: '#c98c93',
  accentSoft: '#6e5a52',
  successWarm: '#7fa36a',
  memoryTint: '#4e3d44'
};
```

### Radius and density

- cards: 20px to 28px
- pills/chips: full rounded
- vertical spacing: generous
- touch targets: large and comfortable
- home feed max width on mobile: full width with soft horizontal padding

### Shadows and depth

- prefer ambient glow and layered opacity over hard borders
- preserve contrast with restrained depth
- primary action card can carry the richest depth treatment

---

## Screen-Level Wireframe Guidance

## Hoy Screen Structure

```text
[Status bar / top safe area]
[Emotional greeting]
[Primary action card]
[Partner presence card]
[Shared progress / challenge card]
[Resurfaced memory card]
[AI note card]
[Optional supporting card]
[Bottom nav]
```

### Layout rules

- Primary action must appear above the fold.
- Do not place more than one equally dominant card before first scroll.
- Use asymmetric card heights to avoid dashboard sameness.
- Keep a single main scroll region.
- Feed should feel editorial and alive, not modular and repetitive.

---

## Migration Roadmap

## Phase 1: Structural MVP

Goal: change the experience without rewriting the whole app.

### Deliverables

- Introduce bottom mobile navigation.
- Build new Hoy route.
- Remove sidebar-first mobile behavior.
- Surface primary action + partner presence + one memory + one AI note.
- Merge or hide low-priority nav destinations.

### Success metric

Users open the app and immediately understand what to do and what happened between them recently.

## Phase 2: Emotional polish

### Deliverables

- Warm palette evolution
- card system refresh
- microcopy rewrite
- partner completion feedback
- joint completion celebration
- archive/memory visual language

### Success metric

The app feels meaningfully more intimate without changing core functionality.

## Phase 3: Shared/personal mode depth

### Deliverables

- stronger distinction between personal and shared views
- contextual theming by space
- richer AI framing
- more advanced resurfacing logic

### Success metric

Users can emotionally feel the difference between “mine” and “ours.”

## Phase 4: Optimization and experimentation

### Deliverables

- test nav labels
- test memory frequency
- test AI note placement
- test partner-presence copy tone
- test completion celebration intensity

### Success metric

Behavior improves through measured iteration rather than assumption.

---

## Metrics to Evaluate the Redesign

## Product Health Signals

Track whether the redesign changes real behavior.

### Primary metrics

- daily or weekly home-screen opens,
- completion of primary home CTA,
- shared activity completion rate,
- return rate after partner activity,
- frequency of mutual completion sessions,
- time-to-first-action after app open.

### Secondary metrics

- memory card engagement,
- AI note open/expand rate,
- navigation depth reduction,
- drop-off between open and meaningful action,
- percentage of sessions that stay entirely within Hoy.

### Qualitative indicators

Ask:

- Does it feel warmer?
- Does it feel like us instead of software?
- Do you feel curious when opening it?
- Does Melanie’s presence feel comforting instead of mechanical?
- Does the app create more moments of reconnection?

---

## Risks and Guardrails

## Main Risks

### 1. Over-designing the surface

Risk:
The team spends too much time on aesthetics and too little on actual behavioral change.

Guardrail:
Ship the new feed structure before doing a full visual overhaul.

### 2. Making intimacy feel artificial

Risk:
Copy, AI notes, or motion become cheesy, scripted, or manipulative.

Guardrail:
Keep tone calm, sparse, and grounded.

### 3. Turning partner presence into surveillance

Risk:
Users feel monitored rather than accompanied.

Guardrail:
Use soft relative presence language and visibility rules.

### 4. Maintaining too many top-level destinations

Risk:
The new emotional home exists, but the rest of the app still feels like a SaaS shell.

Guardrail:
Reduce top-level navigation aggressively.

### 5. Equal-weight content modules

Risk:
The home feed becomes a dashboard disguised as cards.

Guardrail:
Enforce one dominant CTA and strict module hierarchy.

---

## Definition of Done

A redesign iteration should be considered successful when all of the following are true:

- The app opens into a relationship-centered Today/Hoy experience.
- Mobile no longer feels like a compressed desktop dashboard.
- There is only one dominant next action on home.
- Partner presence is visible in a warm, non-invasive way.
- At least one historical/shared memory can resurface contextually.
- AI content reads like a message, not a report.
- Navigation is reduced to 4 primary destinations or fewer.
- Shared and personal contexts feel distinct.
- The interface feels more intimate without sacrificing clarity.

---

## Final Recommendation

Do **not** start by redesigning every screen.

Start by redesigning the emotional center of the product:

- the home screen,
- the mobile navigation,
- the shared-presence layer,
- the microcopy,
- the delight moments.

If those pieces work, the product will already feel fundamentally different—even before a full visual-system evolution.

The real win is not that the app looks more beautiful.
The real win is that opening it feels like entering a shared place.
