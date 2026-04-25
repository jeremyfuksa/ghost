# Design Experience Spec — Home Featured Work + Case-Study Sidebars

**Date:** 2026-04-24
**Companion to:** [`2026-04-24-site-audit-punch-list.md`](2026-04-24-site-audit-punch-list.md) (cleanup items)
**Scope:** Two design-judgment changes that affect how visitors experience the site. The punch list covers code/perf cleanup; this covers visual and editorial decisions.

---

## Problem 1 — Home featured-work block competes with the hero

### Current state

- Hero is a portrait photo with a 0.45 → 0.55 dark gradient overlay (`linear-gradient(rgba(0,0,0,0.45) 0%, rgba(0,0,0,0.35) 70%, rgba(0,0,0,0.55) 100%)`).
- Featured-work block uses `margin-top: -64px` so three teal cards (`#75acaf` / `--color-featured-card-surface`) overlap the bottom of the hero photo.
- Cards carry a cursor-spotlight effect (`::before` radial gradient that follows pointer position, wired in [main.js:152-162](theme/assets/js/main.js#L152-L162)).
- Result: two heavy elements colliding. The teal-on-photo overlap is the source of the "competing" feeling.

### Solution — A2: lighten + de-overlap

Five changes, all in [components.css](theme/assets/css/components.css) and [tokens.css](theme/assets/css/tokens.css). No HBS markup change.

**1. Drop the overlap.**
[components.css:934-940](theme/assets/css/components.css#L934-L940) — change `margin: -64px auto 0` to `margin: var(--spacing-12) auto 0`. Cards sit *after* the hero with breathing room.

**2. Lighten card surface — repurpose existing tokens.**
[tokens.css:124-128](theme/assets/css/tokens.css#L124-L128) — replace the dark/teal featured-card tokens:

```css
/* Light mode */
--color-featured-card-bg: var(--color-accent-subtle);   /* #faf6f5 — paper/cream */
--color-featured-card-border: var(--color-now-border);  /* #c9998a hairline */
--color-featured-card-text: var(--color-text-heading);
--color-featured-card-body: var(--text-secondary);
--color-featured-card-label: var(--color-eyebrow);
```

```css
/* Dark mode (in .dark block) */
--color-featured-card-bg: var(--primary-950);
--color-featured-card-border: var(--primary-900);
/* text tokens inherit defaults — already work in dark */
```

The existing `--color-featured-card-surface` (`#75acaf`) is no longer referenced — remove it.

**3. Drop the cursor-spotlight effect.**
- Remove the `featured-work-card` block from [main.js:154-162](theme/assets/js/main.js#L154-L162).
- Remove the `.featured-work-card::before` and `.featured-work-card:hover::before` rules from [components.css:3338-3367](theme/assets/css/components.css#L3338-L3367) (the "Cursor spotlight" section in the polish block).
- New hover state is just: hairline darkens to `var(--color-now-border)` at full opacity, optional 1px translateY. Already partially there at [components.css:961-964](theme/assets/css/components.css#L961-L964) — keep `transform: translateY(-2px)`, change `border-color` to use the new border token at hover.

**4. Lighten the hero gradient.**
[components.css:797-798](theme/assets/css/components.css#L797-L798) — `0.45/0.35/0.55` → `0.35/0.25/0.45`. Same pattern in the dark-mode block at [components.css:807-810](theme/assets/css/components.css#L807-L810): `0.5/0.4/0.65` → `0.4/0.3/0.55`. Photo breathes more now that cards aren't overlapping it.

**5. Card typography leans Fraunces.**
[components.css:1008-1014](theme/assets/css/components.css#L1008-L1014) — `.featured-work-title` becomes:

```css
.featured-work-title {
  font-family: var(--font-heading);
  font-variation-settings: 'WONK' 1, 'opsz' 72;
  font-size: var(--text-2xl);
  font-weight: 350;        /* matches case-study h2 */
  color: var(--color-featured-card-text);
  line-height: var(--leading-2xl);
  margin: 0;
}
```

Card title now reads as a chapter header, not a product card label. Eyebrow (`.featured-work-label`) stays sans/uppercase — it's the type-system signal.

### What does NOT change

- Three-card grid layout
- Eyebrow / title / body / link content structure inside each card
- Responsive collapse to 1-column under 900px ([components.css:984-989](theme/assets/css/components.css#L984-L989))
- The "See all work →" link below the grid

---

## Problem 2 — Case-study sidebars are cookie-cutter

### Current state

Five case studies, all using identical four-field sidebar (Role / Organization / Timeline / Scope). On four of five, "Scope" duplicates the header tagline. Terra is the only one with stats; Redwood and Terra are the only ones with links. Three case studies have an inert "Organization" + "Scope" pair that adds no information.

The taglines themselves paraphrase the title. The eyebrows are inconsistent ("Systems work" / "Leadership narratives" / "Experiments" / "Case study" / "Case study") — leftover categorization from an earlier draft.

### Solution — three-slot structure + per-study Signal content + tagline rewrites

#### 2a. Sidebar structure — three slots, not a four-field stamp

```
┌─────────────────────────┐
│ META BLOCK              │  Role · Organization · Timeline (drop Scope)
├─────────────────────────┤
│ SIGNAL BLOCK            │  Per-study content (stats / fact list / pull quote)
├─────────────────────────┤
│ LINKS BLOCK (optional)  │  External references — only when they exist
└─────────────────────────┘
```

**Markup changes** (HBS):
- Meta block keeps existing `.cs-meta-group` × 3 (Role, Organization, Timeline). Drop the Scope group entirely.
- New `.cs-signal` wrapper containing one of:
  - `.cs-stats` (already exists, expand grid to support 6 cells)
  - `.cs-fact-list` (new — vertical key-value pairs, mono labels + sans values)
  - `.cs-pullquote` (new — italic Fraunces, ~14px, 4-6 lines max, with a hairline left rule using `var(--color-blockquote-rule)`)
- `.cs-divider` (`<hr>`) separates Meta from Signal, and Signal from Links when both are present.
- `.cs-link` block stays. Optional. Wrapped with `{{#if}}` patterns where applicable.

**CSS changes** (`components.css`, case-study section starting [line 2899](theme/assets/css/components.css#L2899)):

```css
/* New: vertical key-value list for Signal block */
.cs-fact-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-3);
}
.cs-fact-list dt {
  font-family: var(--font-mono);
  font-size: var(--text-3xs);
  text-transform: uppercase;
  letter-spacing: var(--tracking-wider);
  color: var(--text-tertiary);
  margin-bottom: var(--spacing-1);
}
.cs-fact-list dd {
  font-size: var(--text-sm);
  color: var(--text-primary);
  line-height: var(--leading-sm);
  margin: 0;
}

/* New: pull-quote variant for Signal block */
.cs-pullquote {
  font-family: var(--font-heading);
  font-variation-settings: 'WONK' 1, 'opsz' 72;
  font-style: italic;
  font-weight: 350;
  font-size: var(--text-base);
  line-height: var(--leading-lg);
  color: var(--color-text-heading);
  border-left: var(--border-blockquote) solid var(--color-blockquote-rule);
  padding-left: var(--spacing-4);
  margin: 0;
}

/* Stats — expand to support 6 cells while staying 2-col on mobile */
.cs-stats {
  /* already 2-col grid, no change needed */
}
```

#### 2b. Per-case-study Signal content

| Case study | Signal type | Content |
|---|---|---|
| **Terra** | `cs-stats` (6 cells, 2-col) | `80+` React components · `200+` Icons · `1,500` Healthcare orgs · `195` Countries · `125+` Design standards · `150+` A11y guidelines (WCAG 2.1 AA) |
| **Redwood Health** | `cs-fact-list` | Shipped: Page Summary, Object ID, health-aware timestamp · Descoped: name truncator, pronoun notification · Team: 6-person Health Design inside ~100-person Redwood org |
| **Cerner / 7 Years** | `cs-fact-list` | Reports: 12 → 5 (attrition + restructuring) · Distribution: 8 locations, 3 continents · Drought: 2 years, no promotions available · Outcome: 3 promotions earned during the drought |
| **Domain Foundation** | `cs-fact-list` | Layers: Universal · Domain · Component · Role · Architecture: Vector DB + MCP server + LLM · Pivot: in-Figma metadata → retrievable knowledge base · Origin: winter break 2025–2026 |
| **Moonbird** | `cs-pullquote` | *"The first thing said, in the first meeting, was that AI in the hands of engineering and PM was going to take our jobs."* — opening line of the draft, sets the whole tone |

Moonbird gets the pullquote treatment because the chapter opens with one of the strongest single sentences in the whole site, and a stats list would underweight it. The other four lean on factual density that stats/lists carry better.

#### 2c. Links block (where present)

- **Terra**: 4 GitHub/blog links (already in HBS, keep)
- **Redwood**: Redwood design system link (already in HBS, keep)
- **Domain Foundation, Moonbird, Cerner**: no Links block — `{{#if}}` it out cleanly so the divider doesn't render either.

#### 2d. Tagline rewrites — the thesis sentence, not the title paraphrase

The header `<p class="casestudy-tagline">` should be the sentence the reader leaves the case study with. Drawn from each draft:

| Case study | New tagline |
|---|---|
| **Terra** | "Healthcare UI components don't get to be approximately right. Three and a half years closing the gap between the standard and what the engineer built in good faith." |
| **Redwood Health** | "Two components shipped. Two we'd already designed and decided to kill. The decisions about what *not* to build were the work." |
| **Cerner / 7 Years** | "Twelve reports across eight locations and three continents, two years with no promotions on the table, and one closing question that kept the conversations honest." |
| **Domain Foundation** | "Encode institutional knowledge as layers, each owned by the role that produces it, and let the model compose from all of them at generation time." |
| **Moonbird** | "The opening question was defensive: how do we keep a non-designer from generating something that doesn't match our design system. Answering that tells you what *not* to allow, not what to build." |

These are pulled (lightly tightened) from sentences in the existing drafts — Jeremy's voice, not invented. The Cerner one is the only synthesis; its draft doesn't have a single summarizing line.

#### 2e. Eyebrow normalization — Pattern B (typed + dated)

Replace inconsistent eyebrows with a `[Type] · [Date range]` pattern. Matches the `/work/` page row pattern already in use ([custom-work.hbs:26](theme/custom-work.hbs#L26)).

| Case study | New eyebrow |
|---|---|
| **Terra** | `Systems work · 2018–2024` |
| **Redwood Health** | `Systems work · 2024–2026` |
| **Cerner / 7 Years** | `Leadership · 2018–2026` |
| **Domain Foundation** | `Methodology · 2025–ongoing` |
| **Moonbird** | `Research · 2025–2026` |

The eyebrow now does navigation work — a visitor scanning sees what *kind* of chapter this is, not just "Case study" five times. Same vocabulary as the `/work/` rows so the two surfaces stay aligned.

---

## Files affected

**Templates (HBS):**
- [theme/custom-casestudy-cerner.hbs](theme/custom-casestudy-cerner.hbs) — eyebrow, tagline, sidebar (drop Scope, add fact list, no links)
- [theme/custom-casestudy-domain-foundation.hbs](theme/custom-casestudy-domain-foundation.hbs) — eyebrow, tagline, sidebar (drop Scope, add fact list, no links)
- [theme/custom-casestudy-moonbird.hbs](theme/custom-casestudy-moonbird.hbs) — eyebrow, tagline, sidebar (drop Scope, add pullquote, no links)
- [theme/custom-casestudy-redwood.hbs](theme/custom-casestudy-redwood.hbs) — eyebrow, tagline, sidebar (drop Scope, add fact list, keep link)
- [theme/custom-casestudy-terra.hbs](theme/custom-casestudy-terra.hbs) — eyebrow, tagline, sidebar (drop Scope, expand stats to 6 cells, keep links)

**CSS:**
- [theme/assets/css/tokens.css](theme/assets/css/tokens.css) — featured-card tokens (lighten), remove `--color-featured-card-surface`, mirror in `.dark`
- [theme/assets/css/components.css](theme/assets/css/components.css) — featured-work block (margin, surface, hover, title typography), hero gradient, new `.cs-fact-list` and `.cs-pullquote` styles, expanded `.cs-stats` grid

**JS:**
- [theme/assets/js/main.js](theme/assets/js/main.js) — remove cursor-spotlight handler

**Static counterparts** (per the static-first workflow):
- [static/home.html](static/home.html) — port featured-work changes
- [static/casestudy-cerner.html](static/casestudy-cerner.html), [static/casestudy-domain-foundation.html](static/casestudy-domain-foundation.html), [static/casestudy-terra.html](static/casestudy-terra.html) — port sidebar/tagline/eyebrow changes

(No static counterparts exist for Moonbird or Redwood case studies. Worth creating during this work or noting in punch list.)

---

## Out of scope (intentional)

- **Hero photo replacement** — keep current portrait. The lighter gradient and removed overlap address the "heaviness" complaint without re-shooting.
- **`/work/` page redesign** — the row layout there is already what we're moving the home toward in spirit. Touching it is a different effort.
- **`/now/`, `/about/`, post-page redesigns** — not the problem we set out to solve.
- **Removing the case-study sidebar entirely** — explicitly rejected in conversation: "I would like to use case study sidebar, but so far we haven't put a lot of effort into getting the content in there right."
- **Post-page sidebar (TOC + Related)** — different surface, different purpose. Leave it alone.

---

## Definition of done

1. Home page: hero photo no longer crashes into featured-work cards; cards read as paper/cream surfaces with Fraunces titles; cursor spotlight gone.
2. All five case-study pages: three-slot sidebar (Meta · Signal · optional Links); per-study Signal content as specified; tagline is the thesis, not the title paraphrase; eyebrow follows `[Type] · [Date range]` pattern.
3. Static counterparts updated where they exist; sync-date headers refreshed.
4. CSS reduced (no broken/orphan tokens left, `--color-featured-card-surface` removed).
5. No regressions in dark mode.
6. `npx gscan theme` still passes (0 errors).
