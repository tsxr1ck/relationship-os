# Relationship OS - Technical Specification

## Project Overview

**Relationship OS** is a sophisticated webapp for couples that combines deep psychological assessment with AI-powered relationship coaching. Each partner independently answers a detailed questionnaire, and the system generates actionable insights by crossing their responses.

### Core Value Proposition
> *"Descubre cómo se aman, dónde conectan, dónde chocan y cómo mejorar juntos."*

---

## Architecture

### Tech Stack
| Layer | Technology |
|-------|------------|
| Frontend | Next.js 14 (App Router) + TypeScript |
| Styling | Tailwind CSS + Design System |
| Backend | Supabase (PostgreSQL) |
| Auth | Supabase Auth (Magic Link + Google OAuth) |
| AI | OpenAI / Anthropic (Edge Functions) |
| State | React Context + React Hook Form |

### Project Structure
```
relationship/
├── app/                    # Next.js App Router
│   ├── (auth)/            # Auth pages (login, signup)
│   ├── (app)/             # Protected app routes
│   │   ├── questionnaire/ # Questionnaire flow
│   │   ├── dashboard/     # Couple dashboard
│   │   ├── plan/          # Weekly plan
│   │   └── profile/       # User profile
│   └── api/               # API routes
├── components/            # React components
│   ├── ui/                # Base UI components
│   ├── questionnaire/     # Question types
│   └── dashboard/         # Dashboard widgets
├── lib/                   # Utilities
│   ├── supabase/          # Supabase client & hooks
│   └── utils/             # Helper functions
├── types/                 # TypeScript definitions
├── docs/                  # Documentation
└── reference/             # Design references
```

---

## The 4C Framework

All features orbit around four macro-layers:

| Layer | Color | Hex | Metaphor | What It Measures |
|-------|-------|-----|----------|------------------|
| **Conexión** | Lilac | `#B8A6FF` | Thread | Emotional intimacy, rituals, humor, curiosity, time together |
| **Cuidado** | Mint | `#9DDFC6` | Root | Love languages, support, validation, attention, repair |
| **Choque** | Rose | `#E8A7B9` | Storm | Conflict, limits, reactivity, evasion, jealousy |
| **Camino** | Peach | `#FFBFA3` | Compass | Goals, money, children, career, future vision |

---

## Design System (from `reference/serene_connection/DESIGN.md`)

### Core Principles
- **No-Line Rule**: No 1px borders for sectioning
- **Tonal Layering**: Use background shifts instead of borders
- **Editorial Typography**: Manrope for headings, Inter for utility
- **Mobile-First**: Bottom sheet navigation, thumb-friendly CTAs

### Color Palette
| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#5f4fa0` | Main actions, gradients |
| `primary_container` | `#b6a4fd` | Primary backgrounds |
| `surface` | `#f5f6ff` | Global canvas |
| `surface_container_low` | `#e8e9f3` | Card backgrounds |
| `surface_container_lowest` | `#ffffff` | Elevated cards |
| `on_surface` | `#252f41` | Primary text |

### Component Guidelines
- **Buttons**: 3rem height, rounded-xl, gradient backgrounds
- **Cards**: 2rem corner radii, no dividers
- **Headers**: Large display text (3.5rem), breathing room

---

## Database Schema Overview

### Core Tables
- `profiles` - User data with locale, timezone, avatar
- `couples` - Relationship entity with invite_code
- `couple_members` - Pivot table (self/partner roles)
- `response_sessions` - Questionnaire session tracking
- `responses` - Individual answers (JSONB)
- `personal_reports` - Individual analysis
- `couple_reports` - Shared analysis
- `weekly_plans` - AI-generated plans
- `weekly_plan_items` - Daily activities

### Security
All sensitive tables use **Row Level Security (RLS)**:
- Individual responses: Only visible to the answering user
- Couple reports: Visible to both partners
- Plans: Visible to both partners

---

## Key Features

### 1. Questionnaire (52 Questions)
Divided into 4 blocks across 5-6 sessions:
- **Block A**: Personal Discovery (12 questions)
- **Block B**: Knowing Your Partner (16 questions)
- **Block C**: Relationship Dynamics (16 questions)
- **Block D**: Shared Life Project (8 questions)

### 2. Question Types
| Type | Description |
|------|-------------|
| LIKERT-5 | 5-point frequency scale |
| LIKERT-7 | 7-point agreement scale |
| FC | Forced Choice (2+ options) |
| ESCENARIO | Scenario-based |
| RANK | Priority ranking |
| SEMAFORO | Green/Yellow/Red options |
| ABIERTA | Free text (optional) |
| SLIDER | Positional slider |

### 3. Scoring System
Four metrics per dimension:
- **Affinity**: How similar (0.0-1.0)
- **Complementarity**: How positive difference can be
- **Friction**: Probability of tension
- **Growth Potential**: Room for improvement

### 4. Weekly AI Plan
- Generated every Monday via Edge Function
- 7 daily activities (ritual, conversation, microaction, reflection)
- Based on couple status snapshot
- Includes Sunday check-in

### 5. Arquetipos
- 6 Individual profiles (Cálido-Expresivo, Protector-Práctico, etc.)
- 6 Couple archetypes (Cálida-Exploradora, Serena-Constante, etc.)

---

## Development Phases

| Sprint | Focus | Deliverables |
|--------|-------|--------------|
| S1 | Foundation | Auth, profiles, couples, RLS, design system |
| S2 | Questionnaire | Question engine, all 52 questions, sessions |
| S3 | Scoring & Reports | Pipeline, personal & couple reports |
| S4 | AI Weekly Plans | Edge Function, weekly plans, dashboard |
| S5 | Engagement | Guided conversations, challenges, streaks |
| S6 | Monetization | Premium gating, shareable cards, polish |

---

## Environment Variables

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
OPENAI_API_KEY=your_openai_key
```

---

## References

- Full spec: `reference/relationship_os_v2.docx.md`
- Design system: `reference/serene_connection/DESIGN.md`
- UI mockups: `reference/*/`
