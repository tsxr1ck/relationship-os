# Sprint 1: Foundation

**Goal**: Set up the complete infrastructure for the Relationship OS app.

**Duration**: 2 weeks  
**Status**: Not Started

---

## Deliverables Checklist

| # | Task | Est. Time | Status |
|---|------|-----------|--------|
| 1.1 | Initialize Next.js 14 project | 1 hr | ⬜ |
| 1.2 | Configure Tailwind + Design System | 1 hr | ⬜ |
| 1.3 | Set up Supabase project | 30 min | ⬜ |
| 1.4 | Create database schema + RLS | 2 hr | ⬜ |
| 1.5 | Install Supabase client packages | 15 min | ⬜ |
| 1.6 | Create auth client + hooks | 2 hr | ⬜ |
| 1.7 | Build login page (magic link) | 2 hr | ⬜ |
| 1.8 | Build signup page | 1 hr | ⬜ |
| 1.9 | Create AppShell component | 1 hr | ⬜ |
| 1.10 | Create BottomNav component | 1 hr | ⬜ |
| 1.11 | Build couple invite flow | 3 hr | ⬜ |
| 1.12 | Create couples table logic | 2 hr | ⬜ |
| 1.13 | Set up protected routes | 1 hr | ⬜ |
| 1.14 | Create profile page | 1 hr | ⬜ |
| 1.15 | Testing + bug fixes | 2 hr | ⬜ |

---

## Task Details

### 1.1 Initialize Next.js 14 Project

```bash
bunx create-next-app@latest relationship-os --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-bun
```

**What to verify:**
- TypeScript compiles without errors
- Tailwind is working
- Dev server starts on port 3000

---

### 1.2 Configure Tailwind + Design System

**File**: `tailwind.config.ts`

Add the 4C colors from spec:
```ts
colors: {
  // Primary
  primary: '#5f4fa0',
  primary_container: '#b6a4fd',
  
  // Surfaces (from DESIGN.md)
  surface: '#f5f6ff',
  surface_container_low: '#e8e9f3',
  surface_container_lowest: '#ffffff',
  
  // Text
  on_surface: '#252f41',
  
  // 4C Layers
  conexion: '#B8A6FF',    // Lilac
  cuidado: '#9DDFC6',    // Mint
  choque: '#E8A7B9',      // Rose
  camino: '#FFBFA3',      // Peach
  
  // Extended
  outline_variant: 'rgba(37, 47, 65, 0.15)',
}
```

**Add to globals.css:**
- Set up CSS variables for fonts (Manrope, Inter)
- Remove default Next.js styles

---

### 1.3 Set Up Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Create new project: `relationship-os`
3. Note credentials:
   - Project URL
   - Anon Key
   - Service Role Key (for admin tasks only!)

4. Create `.env.local`:
```env
NEXT_PUBLIC_SUPABASE_URL=your_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_key
```

---

### 1.4 Create Database Schema

**File**: `docs/database-schema.sql`

Run the schema in Supabase SQL Editor. Tables to create:

```sql
-- Core Identity
profiles
couples  
couple_members
couple_status_view

-- Questionnaire
questionnaires
questionnaire_sections
questions
answer_options
dimension_keys
question_dimension_map

-- Responses
response_sessions
responses

-- Reports
personal_reports
couple_reports
dimension_scores

-- Weekly Plans
weekly_plans
weekly_plan_items

-- Content
guided_conversations
weekly_challenges
challenge_assignments
milestones

-- Audit
ai_audit_log
```

**RLS Policies**: See full schema file for detailed policies.

---

### 1.5 Install Supabase Client Packages

```bash
bun add @supabase/supabase-js @supabase/ssr
```

Optional but recommended:
```bash
bun add zod react-hook-form @hookform/resolvers
bun add framer-motion lucide-react clsx tailwind-merge
```

---

### 1.6 Create Auth Client + Hooks

**Files to create:**
```
lib/supabase/
├── client.ts        # Browser client
├── server.ts        # Server client (for Server Actions)
├── middleware.ts    # Auth middleware
├── hooks.ts         # React hooks (useSession, useUser)
└── types.ts         # Database types
```

**Key hooks needed:**
- `useSession()` - Get current session
- `useUser()` - Get current user
- `useSignIn()` - Sign in with email/Google
- `useSignUp()` - Sign up new user
- `useSignOut()` - Sign out

---

### 1.7 Build Login Page

**Route**: `app/(auth)/login/page.tsx`

Features:
- Email input for magic link
- Google OAuth button
- "Forgot password" link (future)
- Link to signup

---

### 1.8 Build Signup Page

**Route**: `app/(auth)/signup/page.tsx`

Features:
- Email input
- Password input (if using email/password)
- Google OAuth button
- Terms acceptance checkbox

---

### 1.9 Create AppShell Component

**File**: `components/AppShell.tsx`

Structure:
```tsx
<main className="min-h-screen bg-surface">
  <Header />          // Top bar with user info
  {children}          // Page content
  <BottomNav />      // Mobile navigation
</main>
```

---

### 1.10 Create BottomNav Component

**File**: `components/BottomNav.tsx`

Navigation items:
1. **Inicio** (Home) - `app/(app)/page.tsx`
2. **Nosotros** (Dashboard) - `app/(app)/dashboard/page.tsx`
3. **Plan** (Weekly Plan) - `app/(app)/plan/page.tsx`
4. **Perfil** (Profile) - `app/(app)/profile/page.tsx`

Design:
- Fixed bottom position
- Glassmorphism effect
- Active state indicator (4C colors)
- Safe area padding for mobile

---

### 1.11 Build Couple Invite Flow

**Flow:**
1. New user completes auth
2. Prompted to create or join a couple
3. **Create Couple**: Generate unique invite_code
4. **Join Couple**: Enter partner's invite_code

**Pages:**
- `app/(app)/couple/create/page.tsx`
- `app/(app)/couple/join/page.tsx`

---

### 1.12 Create Couples Table Logic

**Functions needed:**
- `createCouple(userId)` - Create new couple, add creator as self
- `joinCouple(userId, inviteCode)` - Join existing couple
- `leaveCouple(userId)` - Leave couple (with confirmation)
- `getCouple(coupleId)` - Get couple details
- `getPartner(coupleId, userId)` - Get the other person

**Invite code generation:**
- 8-character alphanumeric, uppercase
- Store in `couples.invite_code`
- Unique constraint

---

### 1.13 Set Up Protected Routes

**Middleware**: `middleware.ts`

Check auth state:
- Redirect to `/login` if not authenticated
- Redirect to `/onboarding` if no couple (after auth)

**Components:**
- `<SignedIn>` - Render children if signed in
- `<SignedOut>` - Render children if signed out
- `<HasCouple>` - Render children if has couple

---

### 1.14 Create Profile Page

**Route**: `app/(app)/profile/page.tsx`

Features:
- Display user avatar/name
- Edit profile (locale, timezone)
- View couple info
- Sign out button
- Delete account (future)

---

### 1.15 Testing + Bug Fixes

**Checklist:**
- [ ] Can sign up with email
- [ ] Can sign in with magic link
- [ ] Can sign in with Google
- [ ] Can create a couple
- [ ] Can join a couple with invite code
- [ ] BottomNav works on mobile
- [ ] Protected routes redirect correctly
- [ ] Profile displays correctly

---

## Next Steps

After completing Sprint 1, proceed to **Sprint 2: Questionnaire Engine**.

---

## Notes

- Use `bun` for all package management
- Run `bun run lint` and `bun run typecheck` before committing
- Supabase RLS is critical - never disable for production tables
- Keep all API routes server-side (not exposed to client)
