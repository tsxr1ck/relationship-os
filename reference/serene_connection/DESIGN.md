# Design System Strategy: The Relational Sanctuary

## 1. Overview & Creative North Star
This design system is anchored by the Creative North Star of **"The Relational Sanctuary."** 

Unlike standard productivity tools that prioritize "efficiency" through rigid grids and dense information, this system treats digital space as a living, breathing room for connection. We move away from the "template" look by embracing **Intentional Asymmetry** and **Tonal Layering**. High-end editorial design is the benchmark: we use dramatic shifts in typography scale and expansive white space to create a sense of calm authority. The interface doesn't just display data; it holds space for the user’s most important human connections.

---

## 2. Colors: Depth Without Lines
Our palette is a sophisticated blend of stability (`on_surface`) and soft, rhythmic accents. To achieve a premium feel, we strictly follow the **"No-Line" Rule**: 1px solid borders are prohibited for sectioning. 

### Surface Hierarchy & Nesting
We define boundaries through background shifts and "stacked" sheets of color. 
- **The Base:** Use `surface` (#f5f6ff) as the global canvas.
- **The Layering Principle:** Instead of borders, use the Surface-Container tiers. Place a `surface_container_lowest` card (Pure White) on a `surface_container_low` background to create a soft, natural lift.
- **Glass & Gradient:** For floating elements (drawers, navigation bars), use Glassmorphism. Apply `surface` at 80% opacity with a `24px` backdrop-blur. 
- **Signature Textures:** Main CTAs or Hero sections should utilize subtle linear gradients—transitioning from `primary` (#5f4fa0) to `primary_container` (#b6a4fd)—to provide a "visual soul" that flat colors cannot achieve.

---

## 3. Typography: The Editorial Voice
We utilize **Manrope** for its geometric yet warm characteristics and **Inter** for utility.

| Level | Token | Font | Size | Weight | Intent |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Display** | `display-lg` | Manrope | 3.5rem | Semibold | Hero moments; high-impact "check-ins." |
| **Headline** | `headline-md` | Manrope | 1.75rem | Semibold | Section starts; breathing room titles. |
| **Title** | `title-md` | Manrope | 1.125rem | Medium | Card titles and prominent labels. |
| **Body** | `body-lg` | Manrope | 1rem | Regular | Primary reading (16px equivalent). |
| **Label** | `label-md` | Inter | 0.75rem | Semibold | Functional UI; navigation and metadata. |

**The Editorial Scale:** To break the monotony, use `display-lg` for headers that occupy the top 40% of the screen on mobile, allowing content to "breathe" before the user begins to scroll.

---

## 4. Elevation & Depth: Tonal Layering
Traditional shadows and borders create "visual noise." This system relies on **Ambient Light** and **Soft Stacking**.

- **The Layering Principle:** Depth is achieved by "nesting." A `surface_container_highest` element should only live inside a `surface_container_low` parent. This mimics the way fine paper sits on a desk.
- **Ambient Shadows:** When an element must float (e.g., a primary action button or a modal), use a diffused shadow: `Box-shadow: 0 12px 40px rgba(37, 47, 65, 0.06)`. Note the color: we use a tinted version of `on_surface` rather than pure black.
- **The "Ghost Border" Fallback:** If accessibility requires a border, use the `outline_variant` token at **15% opacity**. High-contrast, 100% opaque borders are strictly forbidden.

---

## 5. Components: Ergonomic & Tactile
Components must feel "comfortable" and optimized for the lower half of the screen (Reachability).

### Buttons & Inputs
- **Primary Action:** Large, `xl` (3rem) height, utilizing the `primary` to `primary_container` gradient.
- **Text Inputs:** Use `surface_container_low` as the background with no border. On focus, transition the background to `surface_container_lowest` and add a "Ghost Border" in `primary`.
- **Roundedness:** Every interactive component uses `xl` (3rem) for cards and `md` (1.5rem) for smaller buttons, creating a "pebble-like" tactile feel.

### Cards & Lists
- **The No-Divider Rule:** Forbid the use of horizontal divider lines. Separate list items using `spacing.4` (1.4rem) or by alternating subtle background shades (`surface_container_low` vs `surface_container_lowest`).
- **Nesting:** Cards should appear as "sheets" sitting atop the background, utilizing `lg` (2rem) corner radii to feel soft and approachable.

### Specialized Components
- **The "Comfort Header":** A massive header area containing only a title and a simple greeting, pushing interactive elements into the "Easy Reach" zone of the lower 60% of the screen.
- **Relational Pulse (Chip):** Use the accent colors (`Peach`, `Mint`, `Lilac`) with 10% opacity backgrounds and 100% opacity text to indicate "Mood" or "Connection Status" without overwhelming the visual hierarchy.

---

## 6. Do’s and Don’ts

### Do
- **Do** use asymmetrical layouts. A card might be left-aligned with a large right margin to create an "editorial" feel.
- **Do** use `spacing.20` (7rem) or `spacing.24` (8.5rem) for top-of-page padding. Space is a luxury; use it.
- **Do** treat "Empty States" as moments of zen. Use a single `headline-sm` title and a `primary` text link, surrounded by white space.

### Don't
- **Don't** use 1px dividers or high-contrast borders. If the sections aren't clear, your background color shifts aren't distinct enough.
- **Don't** use "Clinical Blue." Stick to our `primary` (#5f4fa0) and its warmer tones to maintain the "Relationship" focus.
- **Don't** cram information. If a screen feels busy, move secondary actions into a bottom-sheet (accessible via a "More" trigger).

### Accessibility Note
While we prioritize soft aesthetics, ensure that `on_surface` (#252f41) is used for all primary body text to maintain a contrast ratio of at least 7:1 against `surface` colors.