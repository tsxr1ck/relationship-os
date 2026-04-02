# Relationship OS — Plan to Make It Work

> **Status**: The codebase has the full UI shell built, but **zero real interactivity**. Every page displays hardcoded/mock data. No data flows to or from Supabase. The questionnaire doesn't save answers. The dashboard is a static mockup. This plan covers every change needed to make the app functional, organized into executable phases.

---

## Diagnosis: What Exists vs. What's Broken

### ✅ What's Already Built (and working)
| Area | Status |
|------|--------|
| **Auth UI** (Login, Signup, Callback) | ✅ Functional — Supabase auth hooks, signIn/signUp/signOut all wired |
| **AuthProvider** context | ✅ Functional — session management, auth state listener |
| **Supabase clients** (client.ts, server.ts) | ✅ Functional — browser + server clients configured |
| **Server Actions** (createCouple, joinCouple) | ✅ Functional — insert into `couples` + `couple_members` |
| **Couple Create/Join pages** | ✅ Functional — calls server actions, shows invite code |
| **Design System** (globals.css, tokens) | ✅ Functional — 4C colors, Tailwind theme, Manrope/Inter fonts |
| **UI Components** (Button, Card, Input) | ✅ Functional — reusable, styled components |
| **Layout** (AppShell, BottomNav, Sidebar, Header) | ✅ Functional — responsive mobile/desktop layout |
| **Questionnaire UI components** | ✅ Functional — all 8 question types render correctly |
| **Question data bank** | ✅ Complete — all 52 questions, 4 blocks, typed & labeled |
| **Database schema** (SQL) | ✅ Complete in `docs/database-schema.sql` — but needs to be verified as deployed |
| **Scoring functions** | ✅ Partial — formulas exist but never called with real data |
| **TypeScript types** | ✅ Complete — full type coverage for all DB tables |

### ❌ What's Completely Broken / Not Functional
| Area | Problem |
|------|---------|
| **No Next.js middleware** | Protected routes are NOT guarded. Any unauthenticated user can hit `/dashboard`, `/onboarding`, etc. |
| **Onboarding doesn't check couple status** | Never queries Supabase to see if user already has a couple. Always shows the same 3-step wizard. |
| **Questionnaire doesn't save answers** | `handleNext` has `// In a real app, save to Supabase here` + fake `setTimeout(300ms)`. Nothing persists. |
| **Questionnaire doesn't create/manage sessions** | No `response_sessions` row is created. No progress tracking in DB. |
| **Dashboard is 100% hardcoded** | "Junt@s por 2 años", "12 semanas creciendo", progress bars at 85%/70%/30%/60% — all fake. |
| **Nosotros page uses `mockDimensions`** | Array of fake `DimensionScore` objects. No Supabase query. |
| **Plan page uses `mockPlan`** | Hardcoded 7-day plan. No `weekly_plans` or `weekly_plan_items` queries. Toggling completion is local state only. |
| **Descubrir page is static** | Module cards with hardcoded progress %. No real concept of "modules" in DB. |
| **Retos page is static** | Challenges are a hardcoded array. No `weekly_challenges` or `challenge_assignments` queries. |
| **Profile page shows placeholder data** | User name is "Usuario", stats are hardcoded (12/52/7). No profile edit functionality. |
| **No scoring pipeline** | `scoring.ts` has the formulas but is never invoked after questionnaire completion. |
| **No AI weekly plan generation** | The spec defines a Master Prompt + Edge Function. Neither exists. |
| **No personal/couple report generation** | Reports table exists in schema but no logic generates or fetches reports. |
| **Quick Actions on dashboard do nothing** | Buttons with no `onClick` handlers. |
| **"Desbloquear resultados compartidos" is dead** | Activity feed item — no logic behind it. |

---

## Phase 1: Foundation & Auth Guard (Critical Path)

**Goal**: Authenticated routes are protected. Onboarding correctly detects user state.

### 1.1 Create Next.js Middleware
- **[NEW]** `src/middleware.ts`
- Use `@supabase/ssr` to check session on every request
- Redirect unauthenticated users from `/(dashboard)/**` to `/login`
- Redirect authenticated users from `/login` and `/signup` to `/onboarding`
- Allow `/callback` to pass through

### 1.2 Fix Onboarding State Detection
- **[MODIFY]** `src/app/(dashboard)/onboarding/page.tsx`
- On mount: query `couple_members` to see if user already has a couple
- If user has a couple AND both members exist → redirect to `/dashboard`
- If user has a couple but only 1 member → show "waiting for partner" state
- If no couple → show create/join flow (current step 2)
- Also query `response_sessions` to check if questionnaire is started/completed

### 1.3 Fix Root Page Redirect
- **[MODIFY]** `src/app/page.tsx`
- Middleware handles auth redirect, so simplify this to just redirect to `/dashboard` (middleware will catch unauthed users)

---

## Phase 2: Questionnaire Flow (Core Feature)

**Goal**: Answers persist to Supabase. Sessions are tracked. Progress survives page reload.

### 2.1 Create Questionnaire Server Actions
- **[NEW]** `src/app/(dashboard)/dashboard/questionnaire/actions.ts`
  - `startQuestionnaireSession()` — creates a `response_sessions` row, returns session ID
  - `saveAnswer(sessionId, questionId, answerValue)` — upserts into `responses` table
  - `completeSection(sessionId, sectionId)` — updates session progress
  - `completeQuestionnaire(sessionId)` — marks session as completed, triggers scoring

### 2.2 Rewrite Questionnaire Page with Real Data
- **[MODIFY]** `src/app/(dashboard)/dashboard/questionnaire/page.tsx`
  - On mount: check for existing in-progress session → resume from last answered question
  - If no session: call `startQuestionnaireSession()`
  - `handleNext()`: call `saveAnswer()` → advance question
  - On section boundary: call `completeSection()`
  - On final question: call `completeQuestionnaire()` → redirect to results or dashboard
  - Progress bar uses real progress from session, not calculated from local state

### 2.3 Seed Questions into Supabase
- **[NEW]** `docs/seed-questions.sql`
  - Insert all 52 questions from `src/data/questionnaire.ts` into the `questions` table
  - Insert all answer options into `answer_options` table
  - Map questions to dimensions in `question_dimension_map`
  - This ensures the DB has the question IDs that match the frontend data

> **Decision point**: The app currently uses client-side question IDs (`q1`, `q2`...). We need to decide: use those as the DB IDs, or generate UUIDs and map them. **Recommendation**: Keep the `q1`-`q52` IDs as the actual UUIDs for simplicity, OR insert into DB and fetch questions from Supabase (cleaner long-term). We'll fetch from DB.

### 2.4 Fetch Questions from Supabase (Optional Enhancement)
- **[NEW]** `src/app/(dashboard)/dashboard/questionnaire/queries.ts`
  - `getQuestionnaire()` — fetch sections + questions from DB instead of local data
  - This means the questionnaire is fully DB-driven and versionable

---

## Phase 3: Scoring Pipeline & Reports  

**Goal**: After both partners complete the questionnaire, generate personal + couple reports.

### 3.1 Personal Report Generation
- **[NEW]** `src/lib/scoring/generate-personal-report.ts`
  - Takes a completed session's responses
  - Calculates per-dimension scores using the `question_dimension_map` weights
  - Determines personal archetype using `generatePersonalArchetype()` (already exists in `scoring.ts`)
  - Inserts into `personal_reports` and `dimension_scores` tables

### 3.2 Couple Report Generation
- **[NEW]** `src/lib/scoring/generate-couple-report.ts`
  - Triggered when BOTH partners have completed sessions
  - Cross-references both partners' dimension scores
  - Calculates affinity, complementarity, friction, growth potential per dimension (formulas exist in `scoring.ts`)
  - Determines couple archetype
  - Generates narrative summary (can use AI or template-based)
  - Inserts into `couple_reports`

### 3.3 Server Action: Trigger Scoring
- **[NEW]** `src/app/actions/scoring.ts`
  - `generateReports(sessionId)`:
    1. Generate personal report
    2. Check if partner also completed → if yes, generate couple report
    3. Return status

### 3.4 Post-Questionnaire Results Page
- **[NEW]** `src/app/(dashboard)/dashboard/questionnaire/results/page.tsx`
  - Shows personal report: archetype, strengths, growth areas
  - If couple report exists: shows "View couple report" CTA
  - If partner hasn't completed: shows "Waiting for your partner" state

---

## Phase 4: Live Dashboard

**Goal**: Dashboard pulls real data from Supabase — scores, plan status, couple info.

### 4.1 Dashboard Data Queries
- **[NEW]** `src/app/(dashboard)/dashboard/queries.ts`
  - `getDashboardData(userId)`:
    - Fetch couple info (partner name, relationship duration from `couples.created_at`)
    - Fetch latest `couple_reports` dimension scores for the 4C overview
    - Fetch active `weekly_plans` + item completion stats
    - Fetch recent activity (completed sessions, plan items)
    - Fetch latest AI insight from couple report

### 4.2 Rewrite Dashboard Page
- **[MODIFY]** `src/app/(dashboard)/dashboard/page.tsx`
  - Convert to server component (or use server action to fetch data)
  - Replace ALL hardcoded values with real data
  - Connection Map: real 4C scores from `couple_reports.dimensions`
  - "Fortaleza de la semana": from couple report's top strength
  - Partner avatars: from `profiles` table
  - Relationship duration: calculated from `couples.created_at`
  - Quick Actions: wire `onClick` handlers to navigate to real features
  - Activity feed: real recent events from response sessions and plan items

### 4.3 Rewrite Nosotros (Couple Report) Page  
- **[MODIFY]** `src/app/(dashboard)/dashboard/nosotros/page.tsx`
  - Remove `mockDimensions`
  - Fetch `couple_reports` + `dimension_scores` from Supabase
  - If no couple report exists: show "Complete the questionnaire first" CTA
  - Detail panel: real scores per dimension

### 4.4 Rewrite Profile Page
- **[MODIFY]** `src/app/(dashboard)/dashboard/profile/page.tsx`
  - Fetch `profiles` table for name, avatar
  - Real stats: count of completed sessions, weeks active, plans generated
  - "Edit profile" → functional form saving to `profiles` table
  - Show couple invite code for sharing

---

## Phase 5: Weekly Plan (AI-Powered)

**Goal**: AI generates a weekly plan based on the couple's scores. Plan items are trackable.

### 5.1 Create Plan Generation API Route
- **[NEW]** `src/app/api/generate-plan/route.ts`
  - Server-side only (uses service role key or API key)
  - Builds the Master Prompt from the spec (Section 6.2) with couple's status snapshot
  - Calls OpenAI/Anthropic API (temperature 0.7)
  - Validates JSON response with Zod
  - Inserts into `weekly_plans` + `weekly_plan_items`
  - Records in `ai_audit_log`

### 5.2 Rewrite Plan Page with Real Data
- **[MODIFY]** `src/app/(dashboard)/dashboard/plan/page.tsx`
  - Remove `mockPlan`
  - Fetch active `weekly_plans` + `weekly_plan_items` from Supabase
  - If no plan exists: show "Generate your first plan" CTA
  - `toggleComplete()`: update `weekly_plan_items.status` in Supabase
  - Progress bar: real completion rate
  - Weekly challenge: from `plan.weekly_challenge` JSON field

### 5.3 Sunday Check-in Flow
- **[NEW]** `src/app/(dashboard)/dashboard/plan/check-in/page.tsx`
  - Simple form: "¿Cómo estamos hoy?" (1-5 scale + optional text)
  - Saves to `weekly_plans.couple_feedback`
  - Updates `completion_rate`
  - Triggers next week's plan generation

---

## Phase 6: Retos & Descubrir (Engagement Features)

### 6.1 Wire Retos to Supabase
- **[MODIFY]** `src/app/(dashboard)/dashboard/retos/page.tsx`
  - Fetch `weekly_challenges` from Supabase for available challenges
  - Fetch `challenge_assignments` for active/completed challenges
  - "Comenzar reto" → insert `challenge_assignments` row
  - Display real streak from consecutive completed weeks

### 6.2 Wire Descubrir Modules
- **[MODIFY]** `src/app/(dashboard)/dashboard/descubrir/page.tsx`
  - Modules map to questionnaire sections/dimensions
  - Progress based on which sections are completed
  - "Comenzar" → navigates to questionnaire at the relevant section
  - Locked modules: require both partners to complete previous sections

### 6.3 Seed Content Data
- **[NEW]** `docs/seed-content.sql`
  - Insert `weekly_challenges` (bank of challenges from the spec)
  - Insert `guided_conversations` (conversation prompts)

---

## Phase 7: Polish & Edge Cases

### 7.1 Error Handling & Loading States
- All server actions need try/catch with user-friendly error messages
- All data-fetching pages need loading skeletons
- All forms need proper validation with `react-hook-form` + `zod`

### 7.2 Real-time Updates
- Use Supabase Realtime subscriptions for:
  - Partner completes questionnaire → notification on dashboard
  - Partner completes plan item → update plan view
  - New plan generated → refresh plan page

### 7.3 Responsive Design Fixes
- Test all pages at mobile breakpoints
- Ensure bottom nav doesn't overlap content
- Verify questionnaire is thumb-friendly

### 7.4 Missing Pages
- **[NEW]** `src/app/(auth)/forgot-password/page.tsx` — password reset flow (linked from login)
- **[NEW]** `src/app/(dashboard)/dashboard/profile/edit/page.tsx` — edit profile form

---

## Execution Priority

| Priority | Phase | Effort | Impact |
|----------|-------|--------|--------|
| 🔴 **P0** | **Phase 1**: Middleware + Onboarding | ~1 day | Blocks everything — unauthed users can't reach app, authed users get stuck in loops |
| 🔴 **P0** | **Phase 2**: Questionnaire saves | ~2 days | The **core feature** — without this, nothing in the app has meaning |
| 🟡 **P1** | **Phase 3**: Scoring + Reports | ~2 days | Unlocks the dashboard, nosotros, and all comparison features |
| 🟡 **P1** | **Phase 4**: Live Dashboard | ~1-2 days | Makes the main screen real — highest visibility impact |
| 🟢 **P2** | **Phase 5**: AI Weekly Plan | ~2 days | Retention feature — but requires AI API key |
| 🟢 **P2** | **Phase 6**: Retos & Descubrir | ~1 day | Engagement — but needs Phase 2 & 3 first |
| ⚪ **P3** | **Phase 7**: Polish | Ongoing | Quality — do as you go |

---

## Prerequisites / Questions for You

> [!IMPORTANT]
> Before I start executing, I need to confirm:

1. **Supabase project**: Is the database schema from `docs/database-schema.sql` already deployed to your Supabase project (`dnjqznvhetmemojhlvao`)? Or do I need to help you run it?

2. **AI API Key**: Do you have an OpenAI or Anthropic API key for the weekly plan generation (Phase 5)? If not, I can implement Phase 5 with a simulated/template-based plan generator for now.

3. **Should I execute all phases in one go**, or would you prefer to review after each phase?

4. **The `.env.local` shows the `SUPABASE_SERVICE_ROLE_KEY` is the same as the anon key** — this is likely a mistake. The service role key should be different (it bypasses RLS). Should I proceed with the anon key for now?

---

## Files to Create / Modify Summary

### New Files (12)
| File | Purpose |
|------|---------|
| `src/middleware.ts` | Auth guard for protected routes |
| `src/app/(dashboard)/dashboard/questionnaire/actions.ts` | Save answers, manage sessions |
| `src/app/(dashboard)/dashboard/questionnaire/queries.ts` | Fetch questions from DB |
| `src/app/(dashboard)/dashboard/questionnaire/results/page.tsx` | Post-questionnaire results view |
| `src/app/(dashboard)/dashboard/queries.ts` | Dashboard data fetching |
| `src/lib/scoring/generate-personal-report.ts` | Personal report pipeline |
| `src/lib/scoring/generate-couple-report.ts` | Couple report pipeline |
| `src/app/actions/scoring.ts` | Server actions for scoring |
| `src/app/api/generate-plan/route.ts` | AI plan generation endpoint |
| `src/app/(dashboard)/dashboard/plan/check-in/page.tsx` | Sunday check-in |
| `docs/seed-questions.sql` | Insert 52 questions into DB |
| `docs/seed-content.sql` | Insert challenges & conversations |

### Modified Files (9)
| File | Changes |
|------|---------|
| `src/app/page.tsx` | Simplify redirect logic |
| `src/app/(dashboard)/onboarding/page.tsx` | Query couple/session state |
| `src/app/(dashboard)/dashboard/page.tsx` | Replace all mocks with real data |
| `src/app/(dashboard)/dashboard/questionnaire/page.tsx` | Wire to Supabase sessions/responses |
| `src/app/(dashboard)/dashboard/nosotros/page.tsx` | Replace mockDimensions with real scores |
| `src/app/(dashboard)/dashboard/plan/page.tsx` | Replace mockPlan with real weekly plan |
| `src/app/(dashboard)/dashboard/descubrir/page.tsx` | Wire to questionnaire progress |
| `src/app/(dashboard)/dashboard/retos/page.tsx` | Wire to challenges DB |
| `src/app/(dashboard)/dashboard/profile/page.tsx` | Real profile data + edit |
