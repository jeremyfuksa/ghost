# Design Experience Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Lighten the home featured-work block so it stops competing with the hero, and rework all five case-study sidebars to be content-distinct rather than cookie-cutter.

**Architecture:** Pure CSS + HBS template edits, no build step, no JS framework. Verification is visual (Ghost dev container at `http://localhost:2368/`) plus `npx gscan theme`.

**Note (mid-execution decision, 2026-04-24):** The static-first workflow has been retired. Tasks 5, 12, and 13 from the original plan (porting changes to `static/*.html` and creating new static counterparts) are dropped — the `static/` directory, `preview.html`, and the `/preview-sync` command were removed. Verification happens directly against the live Ghost dev container.

**Tech Stack:** Ghost 5 (Handlebars), vanilla CSS with custom properties, Docker dev container, gscan for theme validation.

**Spec:** [`docs/superpowers/specs/2026-04-24-design-experience-spec.md`](../specs/2026-04-24-design-experience-spec.md)

**Verification model:** This is a no-build CSS/HBS theme with no test runner. Each task uses one of three verification approaches: (a) **gscan** for HBS/Ghost compatibility, (b) **visual diff in browser** at the relevant URL on `http://localhost:2368/`, (c) **grep/diff** for CSS token presence/absence. The "test" in TDD terms is the visual or structural assertion the task is making — written explicitly in each step.

---

## Pre-flight

### Task 0: Verify environment + bump version

**Files:**
- Modify: `theme/package.json` (version bump per memory rule)

- [ ] **Step 1: Confirm Ghost dev container is up**

Run: `docker ps --format "{{.Names}} {{.Status}}" | grep tcn-ghost-dev`
Expected: `tcn-ghost-dev Up <duration>`

If not running: `docker compose up -d && bash dev/setup.sh`

- [ ] **Step 2: Confirm baseline gscan is clean**

Run: `cd theme && npx gscan . 2>&1 | tail -20`
Expected: `0 errors`, possibly `1 warning` for custom fonts (per CLAUDE.md, this is normal).

If errors exist that aren't related to this work, stop and surface them — do not proceed past pre-existing failures.

- [ ] **Step 3: Confirm baseline visual state**

Open in browser: `http://localhost:2368/` and `http://localhost:2368/work/terra-design-system/` (and other case studies if they're available — see Ghost admin for slugs).
Take a mental note of: hero/featured-work overlap, current sidebar structure, current taglines and eyebrows. These are the "before" you'll compare against.

- [ ] **Step 4: Bump version**

Edit `theme/package.json`. Find the `"version"` field. Bump patch number (e.g., `1.4.2` → `1.4.3`).

- [ ] **Step 5: Commit pre-flight**

```bash
git add theme/package.json docs/superpowers/specs/
git commit -m "Add design experience spec + punch list, bump version"
```

---

## Phase 1 — Home featured-work lightening (A2)

### Task 1: Update featured-card tokens for light surface

**Files:**
- Modify: `theme/assets/css/tokens.css:124-128` (light mode), `tokens.css:182-184` (dark mode `.dark` block)

- [ ] **Step 1: Visual assertion — confirm current state**

Open `http://localhost:2368/`. The three cards under the hero are teal (`#75acaf`), with white text, overlapping the hero photo by ~64px. This is what's about to change.

- [ ] **Step 2: Replace light-mode featured-card tokens**

Find this block in `theme/assets/css/tokens.css` (around line 124):

```css
  /* Featured work card */
  --color-featured-card-bg: #1c1f26;
  --color-featured-card-surface: #75acaf;
  --color-featured-card-border: rgba(0, 0, 0, 0.1);
```

Replace with:

```css
  /* Featured work card */
  --color-featured-card-bg: var(--color-accent-subtle);
  --color-featured-card-border: var(--color-now-border);
  --color-featured-card-text: var(--color-text-heading);
  --color-featured-card-body: var(--text-secondary);
  --color-featured-card-label: var(--color-eyebrow);
```

Note: `--color-featured-card-surface` is removed (no longer used). `--color-featured-card-bg` repurposed to point to the cream surface.

- [ ] **Step 3: Replace dark-mode featured-card tokens**

Find this block in `theme/assets/css/tokens.css` (around line 182):

```css
  --color-featured-card-surface: #2e5a5c;
  --color-featured-card-border: rgba(255, 255, 255, 0.08);
```

Replace with:

```css
  --color-featured-card-bg: var(--primary-950);
  --color-featured-card-border: var(--primary-900);
  --color-featured-card-text: var(--color-text-heading);
  --color-featured-card-body: var(--text-secondary);
  --color-featured-card-label: var(--color-eyebrow);
```

- [ ] **Step 4: Verify no orphan references to the removed token**

Run: `grep -rn "color-featured-card-surface" theme/`
Expected: zero matches.

If any match remains, fix it before continuing.

- [ ] **Step 5: Visual check (cards will look broken — that's expected here)**

Reload `http://localhost:2368/`. Cards now show as cream-on-cream with no contrast — text is invisible because `components.css` still references the old token names. That's the next task. Do not commit yet.

---

### Task 2: Update featured-work card CSS to consume new tokens + drop overlap + Fraunces title

**Files:**
- Modify: `theme/assets/css/components.css:934-940` (margin), `:948-964` (card surface + hover), `:991-998` (label), `:1008-1022` (title + body)

- [ ] **Step 1: Drop the -64px overlap**

In `theme/assets/css/components.css`, find the `.featured-work` rule (around line 934):

```css
.featured-work {
  max-width: var(--content-max);
  margin: -64px auto 0;
  padding: 0 var(--spacing-8);
  position: relative;
  z-index: 1;
}
```

Replace `margin: -64px auto 0;` with `margin: var(--spacing-12) auto 0;`. The block now sits below the hero with breathing room.

- [ ] **Step 2: Update card surface + hover**

Find `.featured-work-card` (around line 948):

```css
.featured-work-card {
  background: var(--color-featured-card-surface);
  border: var(--border-hairline) solid var(--color-featured-card-border);
  ...
}

.featured-work-card:hover {
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}
```

Replace the `background` line with: `background: var(--color-featured-card-bg);`
Replace the `:hover` border-color with: `border-color: var(--color-eyebrow);`
(The `transform: translateY(-2px)` stays.)

- [ ] **Step 3: Update label color (was white-on-teal)**

Find `.featured-work-label` (around line 991):

```css
.featured-work-label {
  ...
  color: rgba(255, 255, 255, 0.6);
  ...
}
```

Replace `color: rgba(255, 255, 255, 0.6);` with `color: var(--color-featured-card-label);`

- [ ] **Step 4: Convert title to Fraunces + update color**

Find `.featured-work-title` (around line 1008):

```css
.featured-work-title {
  font-size: var(--text-2xl);
  font-weight: var(--font-weight-semibold);
  color: #ffffff;
  line-height: var(--leading-2xl);
  margin: 0;
}
```

Replace entirely with:

```css
.featured-work-title {
  font-family: var(--font-heading);
  font-variation-settings: 'WONK' 1, 'opsz' 72;
  font-size: var(--text-2xl);
  font-weight: 350;
  color: var(--color-featured-card-text);
  line-height: var(--leading-2xl);
  margin: 0;
}
```

- [ ] **Step 5: Update body + link colors**

Find `.featured-work-body` (around line 1016):

```css
.featured-work-body {
  ...
  color: rgba(255, 255, 255, 0.8);
  ...
}
```

Replace `color: rgba(255, 255, 255, 0.8);` with `color: var(--color-featured-card-body);`.

Find `.featured-work-link` (around line 1024):

```css
.featured-work-link {
  ...
  color: #ffffff;
  ...
}
```

Replace `color: #ffffff;` with `color: var(--color-accent-text);`.

- [ ] **Step 6: Visual verification**

Reload `http://localhost:2368/`. Expected:
- Three cards now sit *below* the hero photo with breathing room (no overlap).
- Cards are cream/paper-colored (light mode) or near-black (dark mode).
- Card titles are Fraunces (serif), heading-warm-brown in light mode, cream in dark mode.
- Eyebrows are warm-brown (`--color-eyebrow`), not white.
- Body text reads as readable secondary text.
- Hover lifts each card 2px and darkens the hairline.

If any text is unreadable, recheck token references.

- [ ] **Step 7: Commit Tasks 1+2**

```bash
git add theme/assets/css/tokens.css theme/assets/css/components.css
git commit -m "Lighten home featured-work cards; remove hero overlap"
```

---

### Task 3: Lighten hero gradient

**Files:**
- Modify: `theme/assets/css/components.css:797-798` (light hero), `:807-810` (dark hero)

- [ ] **Step 1: Lighten light-mode gradient**

Find the `.hero` rule in `components.css` (around line 794):

```css
.hero {
  padding: var(--spacing-24) var(--spacing-20) var(--spacing-20);
  background-image:
    linear-gradient(to bottom, rgba(0,0,0,0.45) 0%, rgba(0,0,0,0.35) 70%, rgba(0,0,0,0.55) 100%),
    url(../images/jeremy-hero.jpg);
  ...
}
```

Replace the linear-gradient stop values: `0.45` → `0.35`, `0.35` → `0.25`, `0.55` → `0.45`.

Result:

```css
  background-image:
    linear-gradient(to bottom, rgba(0,0,0,0.35) 0%, rgba(0,0,0,0.25) 70%, rgba(0,0,0,0.45) 100%),
    url(../images/jeremy-hero.jpg);
```

- [ ] **Step 2: Lighten dark-mode gradient**

Find the dark-mode block (around line 805):

```css
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) .hero {
    background-image:
      linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.4) 70%, rgba(0,0,0,0.65) 100%),
      url(../images/jeremy-hero.jpg);
  }
}
```

And the parallel `:root[data-theme="dark"]` block (around line 813). Replace stop values in **both**: `0.5` → `0.4`, `0.4` → `0.3`, `0.65` → `0.55`.

- [ ] **Step 3: Visual verification**

Reload `http://localhost:2368/`. Hero photo should breathe more — Jeremy's portrait reads more clearly, less crushed under the overlay. Hero text (name, positioning paragraph) must still be readable; if any white text fades into a bright spot in the photo, the gradient went too light — back off by 0.05 on the relevant stop.

- [ ] **Step 4: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "Lighten hero gradient now that featured cards no longer overlap"
```

---

### Task 4: Remove cursor-spotlight effect

**Files:**
- Modify: `theme/assets/js/main.js` (remove featured-card pointer block)
- Modify: `theme/assets/css/components.css:3338-3367` (remove `::before` cursor spotlight)

- [ ] **Step 1: Remove JS handler**

In `theme/assets/js/main.js`, find the cursor-spotlight block (around line 154):

```javascript
  // ---- Cursor spotlight on featured-work cards --------------------------
  if (!reduceMotion) {
    var featuredCards = document.querySelectorAll('.featured-work-card');
    featuredCards.forEach(function (card) {
      card.addEventListener('pointermove', function (e) {
        var rect = card.getBoundingClientRect();
        card.style.setProperty('--mx', (e.clientX - rect.left) + 'px');
        card.style.setProperty('--my', (e.clientY - rect.top) + 'px');
      });
    });
  }
```

Delete the entire block (the comment header line through the closing `}` on the outer `if`).

- [ ] **Step 2: Remove CSS spotlight rules**

In `theme/assets/css/components.css`, find the "Cursor spotlight" comment header (around line 3338) and the rules following it:

```css
/* Cursor spotlight — dark featured-work card */
.featured-work-card {
  position: relative;
  overflow: hidden;
  ...
}

.featured-work-card::before {
  content: "";
  position: absolute;
  ...
}

.featured-work-card:hover::before {
  ...
}

.featured-work-card > * {
  position: relative;
  z-index: 1;
}
```

Delete the entire spotlight block (comment + 4 rules: `.featured-work-card`, `.featured-work-card::before`, `.featured-work-card:hover::before`, `.featured-work-card > *`).

**Important:** the *primary* `.featured-work-card` definition (around line 948 in the featured-work section) MUST remain. Only the duplicate in the polish/spotlight section is being removed.

- [ ] **Step 3: Verify both `.featured-work-card` selectors are not still present**

Run: `grep -n "^\.featured-work-card" theme/assets/css/components.css`
Expected: exactly **two** lines — `.featured-work-card {` and `.featured-work-card:hover {`. If `::before` or `> *` selectors still appear in the output, the deletion missed them.

- [ ] **Step 4: Visual verification**

Reload `http://localhost:2368/`. Move the cursor over the featured-work cards. Expected: no glowing radial follower, no `--mx`/`--my` tracking. Hover state is still 2px lift + hairline darken.

- [ ] **Step 5: Commit**

```bash
git add theme/assets/js/main.js theme/assets/css/components.css
git commit -m "Remove cursor-spotlight effect from featured-work cards"
```

---

### Task 5: Port home featured-work changes to static/home.html

**Files:**
- Modify: `static/home.html` (sync from current theme state)

- [ ] **Step 1: Open static file**

Open `static/home.html`. Find the `<!-- STATIC SOURCE for: theme/custom-home.hbs -->` header comment near the top.

- [ ] **Step 2: Locate featured-work block**

Find the `<section class="featured-work">` block in the static file. The HTML structure inside should already match `theme/custom-home.hbs` — check that the markup hasn't drifted. If markup differs, bring static into sync with the HBS template.

- [ ] **Step 3: Verify static file references shared CSS**

The static file should `<link rel="stylesheet" href="../theme/assets/css/...">` to the same CSS files. Open `static/home.html` directly with `open static/home.html` (or via `preview.html`) and confirm the lightened cards render the same as the Ghost dev container.

If they differ: the static file may be loading a stale CSS path. Adjust the `<link>` references.

- [ ] **Step 4: Update sync date**

Update the `Last synced:` date in the header comment to today (`2026-04-24`).

- [ ] **Step 5: Commit**

```bash
git add static/home.html
git commit -m "Sync static/home.html with featured-work redesign"
```

---

## Phase 2 — Case-study sidebar redesign

### Task 6: Add new CSS for `.cs-fact-list` and `.cs-pullquote`; expand `.cs-stats` if needed

**Files:**
- Modify: `theme/assets/css/components.css` — add new rules at the end of the case-study section (after `.cs-link:hover` around line 3175)

- [ ] **Step 1: Locate insertion point**

In `theme/assets/css/components.css`, find `.cs-link:hover { ... }` (around line 3174). Insert the new rules immediately after it, before the `/* Mobile */` comment block at line 3179.

- [ ] **Step 2: Add `.cs-fact-list` styles**

Insert:

```css
/* Fact list — vertical key-value pairs for Signal block */
.cs-fact-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-3);
  margin: 0;
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
```

- [ ] **Step 3: Add `.cs-pullquote` styles**

Append after the fact-list block:

```css
/* Pull quote — italic Fraunces for Signal block */
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
```

- [ ] **Step 4: Verify `.cs-stats` is unchanged**

Run: `grep -A 4 "^\.cs-stats {" theme/assets/css/components.css`
Expected:

```css
.cs-stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--spacing-3);
}
```

The existing 2-column grid handles 4 or 6 stats fine — no change needed for Terra's expansion.

- [ ] **Step 5: Verify gscan still passes**

Run: `cd theme && npx gscan . 2>&1 | tail -10`
Expected: 0 errors. (gscan validates Handlebars + theme structure, not CSS, but worth confirming the file is still valid CSS by reload.)

Also reload `http://localhost:2368/work/terra-design-system/` — page should render unchanged (the new classes aren't used yet).

- [ ] **Step 6: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "Add cs-fact-list and cs-pullquote styles for case-study sidebars"
```

---

### Task 7: Rewrite Terra case study (eyebrow, tagline, sidebar — expanded stats)

**Files:**
- Modify: `theme/custom-casestudy-terra.hbs`

- [ ] **Step 1: Update eyebrow**

In `theme/custom-casestudy-terra.hbs`, find:

```handlebars
    <div class="casestudy-eyebrow">Systems work</div>
```

Replace with:

```handlebars
    <div class="casestudy-eyebrow">Systems work · 2018–2024</div>
```

- [ ] **Step 2: Update tagline**

Find:

```handlebars
    <p class="casestudy-tagline">Open-source React component library serving hundreds of teams across enterprise healthcare.</p>
```

Replace with:

```handlebars
    <p class="casestudy-tagline">Healthcare UI components don't get to be approximately right. Three and a half years closing the gap between the standard and what the engineer built in good faith.</p>
```

- [ ] **Step 3: Drop Scope meta-group**

Find the `<div class="cs-meta-group">` block containing `Scope` (around line 31–34) and delete the entire block:

```handlebars
      <div class="cs-meta-group">
        <div class="cs-meta-label">Scope</div>
        <div class="cs-meta-value">Open-source React component library serving hundreds of teams across enterprise healthcare</div>
      </div>
```

The remaining meta-groups should be: Role, Organization, Timeline (in that order).

- [ ] **Step 4: Expand stats grid from 4 to 6 cells**

Find the existing `<div class="cs-stats">` block. Replace its contents entirely with:

```handlebars
      <div class="cs-stats">
        <div class="cs-stat">
          <div class="cs-stat-value">80+</div>
          <div class="cs-stat-label">React components</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">200+</div>
          <div class="cs-stat-label">Icons</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">1,500</div>
          <div class="cs-stat-label">Healthcare orgs</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">195</div>
          <div class="cs-stat-label">Countries</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">125+</div>
          <div class="cs-stat-label">Design standards</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">150+</div>
          <div class="cs-stat-label">A11y guidelines</div>
        </div>
      </div>
```

- [ ] **Step 5: Verify gscan**

Run: `cd theme && npx gscan . 2>&1 | tail -10`
Expected: 0 errors.

- [ ] **Step 6: Visual verification**

Reload `http://localhost:2368/work/terra-design-system/`. Expected:
- Eyebrow now reads `Systems work · 2018–2024`
- Tagline is the new "approximately right" sentence
- Sidebar shows Role, Organization, Timeline (no Scope), then a 6-cell stats grid (2 columns × 3 rows), then 4 GitHub/blog links
- Mobile (resize <768px): sidebar reorders above prose; stats stay 2-col

- [ ] **Step 7: Commit**

```bash
git add theme/custom-casestudy-terra.hbs
git commit -m "Rewrite Terra case study: thesis tagline, typed eyebrow, expanded stats"
```

---

### Task 8: Rewrite Redwood Health case study (eyebrow, tagline, sidebar — fact list)

**Files:**
- Modify: `theme/custom-casestudy-redwood.hbs`

- [ ] **Step 1: Update eyebrow + tagline**

In `theme/custom-casestudy-redwood.hbs`, find:

```handlebars
    <div class="casestudy-eyebrow">Case study</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">Health-specific component authoring on Oracle's Redwood design system.</p>
```

Replace with:

```handlebars
    <div class="casestudy-eyebrow">Systems work · 2024–2026</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">Two components shipped. Two we'd already designed and decided to kill. The decisions about what <em>not</em> to build were the work.</p>
```

- [ ] **Step 2: Drop Scope meta-group**

Find and delete the entire Scope block:

```handlebars
      <div class="cs-meta-group">
        <div class="cs-meta-label">Scope</div>
        <div class="cs-meta-value">Health-specific component authoring on Oracle's Redwood design system</div>
      </div>
```

Remaining meta-groups: Role, Organization, Timeline.

- [ ] **Step 3: Add Signal block (fact list) before existing divider + link**

After the last `.cs-meta-group` (Timeline) and before the existing `<hr class="cs-divider">`, insert:

```handlebars
      <hr class="cs-divider">

      <dl class="cs-fact-list">
        <div>
          <dt>Shipped</dt>
          <dd>Page Summary, Object ID, health-aware timestamp</dd>
        </div>
        <div>
          <dt>Descoped</dt>
          <dd>Name truncator, pronoun notification</dd>
        </div>
        <div>
          <dt>Team</dt>
          <dd>6-person Health Design inside ~100-person Redwood org</dd>
        </div>
      </dl>
```

The existing `<hr class="cs-divider">` and Redwood link block stay below this — re-verify by reading the file that the structure is now: meta-groups → divider → fact-list → divider → cs-link. (Two dividers total, framing the fact list.)

- [ ] **Step 4: Verify gscan**

Run: `cd theme && npx gscan . 2>&1 | tail -10`
Expected: 0 errors.

- [ ] **Step 5: Visual verification**

Reload `http://localhost:2368/work/redwood-health-design/`. Expected:
- Eyebrow: `Systems work · 2024–2026`
- Tagline: "Two components shipped..." with *not* italicized
- Sidebar: Role / Organization / Timeline → divider → fact list (3 items, mono labels + sans values) → divider → Redwood link

- [ ] **Step 6: Commit**

```bash
git add theme/custom-casestudy-redwood.hbs
git commit -m "Rewrite Redwood case study: thesis tagline, typed eyebrow, shipped/descoped fact list"
```

---

### Task 9: Rewrite Cerner / 7-Years case study (eyebrow, tagline, sidebar — fact list, no links)

**Files:**
- Modify: `theme/custom-casestudy-cerner.hbs`

- [ ] **Step 1: Update eyebrow + tagline**

Find:

```handlebars
    <div class="casestudy-eyebrow">Leadership narratives</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.</p>
```

Replace with:

```handlebars
    <div class="casestudy-eyebrow">Leadership · 2018–2026</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">Twelve reports across eight locations and three continents, two years with no promotions on the table, and one closing question that kept the conversations honest.</p>
```

- [ ] **Step 2: Drop Scope meta-group**

Find and delete the entire Scope block:

```handlebars
      <div class="cs-meta-group">
        <div class="cs-meta-label">Scope</div>
        <div class="cs-meta-value">Revenue cycle product design, design system engineering partnership, distributed team leadership through a $28B acquisition</div>
      </div>
```

- [ ] **Step 3: Add Signal block (fact list) after Timeline**

After the Timeline `.cs-meta-group` and before the closing `</aside>`, insert:

```handlebars
      <hr class="cs-divider">

      <dl class="cs-fact-list">
        <div>
          <dt>Reports</dt>
          <dd>12 → 5 (attrition + restructuring)</dd>
        </div>
        <div>
          <dt>Distribution</dt>
          <dd>8 locations, 3 continents</dd>
        </div>
        <div>
          <dt>Drought</dt>
          <dd>2 years with no promotions available</dd>
        </div>
        <div>
          <dt>Outcome</dt>
          <dd>3 promotions earned during the drought</dd>
        </div>
      </dl>
```

No `.cs-link` block — Cerner case study has no external links.

- [ ] **Step 4: Verify gscan**

Run: `cd theme && npx gscan . 2>&1 | tail -10`
Expected: 0 errors.

- [ ] **Step 5: Visual verification**

Reload the Cerner case-study URL (check Ghost admin for slug — likely `/work/seven-years-in-healthcare-ux/`). Expected:
- Eyebrow: `Leadership · 2018–2026`
- New tagline
- Sidebar: Role / Organization / Timeline → divider → fact list (4 items)
- No links block, no trailing divider

- [ ] **Step 6: Commit**

```bash
git add theme/custom-casestudy-cerner.hbs
git commit -m "Rewrite Cerner case study: thesis tagline, typed eyebrow, leadership fact list"
```

---

### Task 10: Rewrite Domain Foundation case study (eyebrow, tagline, sidebar — fact list, no links)

**Files:**
- Modify: `theme/custom-casestudy-domain-foundation.hbs`

- [ ] **Step 1: Update eyebrow + tagline**

Find:

```handlebars
    <div class="casestudy-eyebrow">Experiments</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.</p>
```

Replace with:

```handlebars
    <div class="casestudy-eyebrow">Methodology · 2025–ongoing</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">Encode institutional knowledge as layers, each owned by the role that produces it, and let the model compose from all of them at generation time.</p>
```

- [ ] **Step 2: Drop Scope meta-group**

Find and delete:

```handlebars
      <div class="cs-meta-group">
        <div class="cs-meta-label">Scope</div>
        <div class="cs-meta-value">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows</div>
      </div>
```

Note: Domain Foundation has no Organization meta-group (the existing template only has Role / Timeline / Scope). After dropping Scope, the meta-groups are Role and Timeline only — that's correct (no employer, this is independent work).

- [ ] **Step 3: Add Signal block (fact list)**

After the Timeline `.cs-meta-group` and before `</aside>`, insert:

```handlebars
      <hr class="cs-divider">

      <dl class="cs-fact-list">
        <div>
          <dt>Layers</dt>
          <dd>Universal · Domain · Component · Role</dd>
        </div>
        <div>
          <dt>Architecture</dt>
          <dd>Vector DB + MCP server + LLM</dd>
        </div>
        <div>
          <dt>Pivot</dt>
          <dd>In-Figma metadata → retrievable knowledge base</dd>
        </div>
        <div>
          <dt>Origin</dt>
          <dd>Winter break 2025–2026</dd>
        </div>
      </dl>
```

- [ ] **Step 4: Verify gscan**

Run: `cd theme && npx gscan . 2>&1 | tail -10`
Expected: 0 errors.

- [ ] **Step 5: Visual verification**

Reload `http://localhost:2368/work/domain-foundation/`. Expected:
- Eyebrow: `Methodology · 2025–ongoing`
- Tagline: the "encode institutional knowledge as layers" sentence
- Sidebar: Role / Timeline (two meta-groups only) → divider → fact list (4 items)
- No Organization, no Scope, no links

- [ ] **Step 6: Commit**

```bash
git add theme/custom-casestudy-domain-foundation.hbs
git commit -m "Rewrite Domain Foundation case study: thesis tagline, typed eyebrow, layer-architecture fact list"
```

---

### Task 11: Rewrite Moonbird case study (eyebrow, tagline, sidebar — pull quote, no links)

**Files:**
- Modify: `theme/custom-casestudy-moonbird.hbs`

- [ ] **Step 1: Update eyebrow + tagline**

Find:

```handlebars
    <div class="casestudy-eyebrow">Case study</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">A year inside Oracle Health figuring out what design practice becomes when AI does the making.</p>
```

Replace with:

```handlebars
    <div class="casestudy-eyebrow">Research · 2025–2026</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">The opening question was defensive: how do we keep a non-designer from generating something that doesn't match our design system. Answering that tells you what <em>not</em> to allow, not what to build.</p>
```

- [ ] **Step 2: Drop Scope meta-group**

Find and delete:

```handlebars
      <div class="cs-meta-group">
        <div class="cs-meta-label">Scope</div>
        <div class="cs-meta-value">A year-long research project encoding institutional design knowledge into AI-retrievable form.</div>
      </div>
```

Remaining meta-groups: Role, Organization, Timeline.

- [ ] **Step 3: Add Signal block (pull quote)**

After the Timeline meta-group and before `</aside>`, insert:

```handlebars
      <hr class="cs-divider">

      <blockquote class="cs-pullquote">The first thing said, in the first meeting, was that AI in the hands of engineering and PM was going to take our jobs.</blockquote>
```

- [ ] **Step 4: Verify gscan**

Run: `cd theme && npx gscan . 2>&1 | tail -10`
Expected: 0 errors.

- [ ] **Step 5: Visual verification**

Reload `http://localhost:2368/moonbird/`. Expected:
- Eyebrow: `Research · 2025–2026`
- Tagline: the "opening question was defensive" sentence with *not* italicized
- Sidebar: Role / Organization / Timeline → divider → italic Fraunces pull quote with hairline left rule (color `--color-blockquote-rule`, which is `#a8654f` light / `#c9998a` dark)

- [ ] **Step 6: Commit**

```bash
git add theme/custom-casestudy-moonbird.hbs
git commit -m "Rewrite Moonbird case study: thesis tagline, typed eyebrow, opening-line pull quote"
```

---

### Task 12: Sync existing static case-study files (Terra, Domain Foundation, Cerner)

**Files:**
- Modify: `static/casestudy-terra.html`
- Modify: `static/casestudy-domain-foundation.html`
- Modify: `static/casestudy-cerner.html`

- [ ] **Step 1: Sync Terra static**

Open `static/casestudy-terra.html`. Find the eyebrow, tagline, and sidebar markup. Apply the same changes as Task 7:
- Eyebrow → `Systems work · 2018–2024`
- Tagline → "Healthcare UI components don't get to be approximately right..."
- Drop Scope meta-group
- Expand stats from 4 to 6 cells (add Design standards 125+ and A11y guidelines 150+)

Update the `Last synced:` header comment to `2026-04-24`.

- [ ] **Step 2: Sync Domain Foundation static**

Open `static/casestudy-domain-foundation.html`. Apply Task 10 changes:
- Eyebrow → `Methodology · 2025–ongoing`
- Tagline → "Encode institutional knowledge as layers..."
- Drop Scope meta-group
- Add fact list (Layers / Architecture / Pivot / Origin)

Update `Last synced:` to `2026-04-24`.

- [ ] **Step 3: Sync Cerner static**

Open `static/casestudy-cerner.html`. Apply Task 9 changes:
- Eyebrow → `Leadership · 2018–2026`
- Tagline → "Twelve reports across eight locations..."
- Drop Scope meta-group
- Add fact list (Reports / Distribution / Drought / Outcome)

Update `Last synced:` to `2026-04-24`.

- [ ] **Step 4: Visual verification of static files**

Open each in browser:
```
open static/casestudy-terra.html
open static/casestudy-domain-foundation.html
open static/casestudy-cerner.html
```

Each should match the live Ghost dev rendering.

- [ ] **Step 5: Commit**

```bash
git add static/casestudy-terra.html static/casestudy-domain-foundation.html static/casestudy-cerner.html
git commit -m "Sync existing static case-study files with sidebar rework"
```

---

### Task 13: Create static counterparts for Moonbird and Redwood

**Files:**
- Create: `static/casestudy-moonbird.html`
- Create: `static/casestudy-redwood.html`

- [ ] **Step 1: Create Moonbird static from Terra template**

Copy `static/casestudy-terra.html` to `static/casestudy-moonbird.html` as a starting point:

```bash
cp static/casestudy-terra.html static/casestudy-moonbird.html
```

- [ ] **Step 2: Edit Moonbird static**

Open `static/casestudy-moonbird.html`. Update:

- Header comment: `STATIC SOURCE for: theme/custom-casestudy-moonbird.hbs`, `Last synced: 2026-04-24`
- `<title>`: "Moonbird — The Cocktail Napkin"
- `<h1 class="casestudy-title">`: "Moonbird"
- Eyebrow, tagline, meta-groups, Signal block: match Task 11 exactly
- Replace prose body with the Moonbird draft content (from `drafts/moonbird-case-study.md`, converted to HTML — h2 → `<h2>`, paragraphs → `<p>`, links → `<a>`)
- Remove the stats grid and link list from the Terra template — Moonbird uses a pull quote, not stats, and has no external links

- [ ] **Step 3: Create Redwood static from Terra template**

```bash
cp static/casestudy-terra.html static/casestudy-redwood.html
```

- [ ] **Step 4: Edit Redwood static**

Open `static/casestudy-redwood.html`. Update:

- Header comment: `STATIC SOURCE for: theme/custom-casestudy-redwood.hbs`, `Last synced: 2026-04-24`
- `<title>`: "Two Components That Didn't Ship — The Cocktail Napkin"
- `<h1 class="casestudy-title">`: "Two Components That Didn't Ship"
- Eyebrow, tagline, meta-groups, Signal block: match Task 8
- Replace prose body with the Redwood draft content (from `drafts/redwood-health-design.md`)
- Replace stats grid with the fact-list (Shipped / Descoped / Team)
- Keep the Redwood design-system link

- [ ] **Step 5: Visual verification**

```
open static/casestudy-moonbird.html
open static/casestudy-redwood.html
```

Both should render correctly using the shared `theme/assets/css/` files. Confirm pull quote renders with italic Fraunces + left rule on Moonbird; fact list renders with mono labels on Redwood.

- [ ] **Step 6: Commit**

```bash
git add static/casestudy-moonbird.html static/casestudy-redwood.html
git commit -m "Create static counterparts for Moonbird and Redwood case studies"
```

---

## Phase 3 — Verification + packaging

### Task 14: End-to-end verification

**Files:** none (read-only verification)

- [ ] **Step 1: gscan final pass**

Run: `cd theme && npx gscan . 2>&1 | tail -20`
Expected: 0 errors, custom-fonts warning is acceptable.

- [ ] **Step 2: All five case studies render correctly in light mode**

Visit each at `http://localhost:2368/`:
- `/work/terra-design-system/` — eyebrow `Systems work · 2018–2024`, 6-cell stats, 4 links
- `/work/redwood-health-design/` — eyebrow `Systems work · 2024–2026`, fact list, Redwood link
- `/work/seven-years-in-healthcare-ux/` (or current Cerner slug) — eyebrow `Leadership · 2018–2026`, fact list, no links
- `/work/domain-foundation/` — eyebrow `Methodology · 2025–ongoing`, fact list, no Organization meta-group
- `/moonbird/` — eyebrow `Research · 2025–2026`, italic Fraunces pull quote with left rule

For each: tagline is the new thesis sentence (not the old title-paraphrase). Sidebar has 3 meta-groups (or 2 for Domain Foundation), no Scope.

- [ ] **Step 3: Home page in light mode**

`http://localhost:2368/`:
- Hero photo breathes, less crushed than before
- Three featured-work cards sit *below* hero (no overlap), cream surface, Fraunces titles, warm-brown eyebrows
- Cursor over a card: 2px lift + hairline darken, NO glowing radial follower

- [ ] **Step 4: Dark mode pass**

Toggle dark mode (system preference or theme-toggle button). Re-verify all of Step 2 and Step 3:
- Featured cards become near-black surface (`--primary-950`) with light borders
- Sidebar fact lists / pull quotes still readable
- No color regressions (white-on-white, accent colors mid-toggle, etc.)

- [ ] **Step 5: Mobile pass (resize browser to <768px)**

For each case study, sidebar should reorder above prose. Stats stay 2-col. Fact list stays single-column. Pull quote stays bordered-left and readable.

- [ ] **Step 6: Static-file pass**

```
open static/home.html
open static/casestudy-terra.html
open static/casestudy-domain-foundation.html
open static/casestudy-cerner.html
open static/casestudy-moonbird.html
open static/casestudy-redwood.html
```

Each should match the corresponding Ghost dev rendering (allowing for the static files using hardcoded content rather than `{{title}}`/`{{content}}`).

If any verification step fails, do not proceed to packaging — fix the regression and re-verify.

- [ ] **Step 7: Commit (if any small verification fixes)**

```bash
git status
# If anything was fixed during verification:
git commit -am "Verification fixes from end-to-end pass"
```

If nothing changed, no commit needed — proceed to Task 15.

---

### Task 15: Package and (optionally) deploy

**Files:**
- Generated: `the-cocktail-napkin.zip`

- [ ] **Step 1: Verify version was bumped**

Run: `grep '"version"' theme/package.json`
Expected: a version higher than the prior commit on `main`. If not, bump it now (`patch` → `+1`) and commit.

- [ ] **Step 2: Package theme**

Run:

```bash
cd theme && zip -r ../the-cocktail-napkin.zip . -x "*.DS_Store" -x "*node_modules*"
```

Expected: zip file written to project root, no errors.

- [ ] **Step 3: (Optional) Deploy to production via Admin API**

Per memory: GHOST_API key in `.env` uploads + activates themes via `dev/deploy-theme.mjs`. Run only if you intend to deploy this work to jeremyfuksa.com:

```bash
node dev/deploy-theme.mjs
```

Expected: HTTP 200, theme uploaded and activated.

If you want to review the live result first, skip this step — the user can deploy manually.

- [ ] **Step 4: Final commit**

```bash
git status
git add the-cocktail-napkin.zip
git commit -m "Package v$(grep version theme/package.json | head -1 | sed 's/.*: \"//;s/\".*//')  with featured-work + case-study redesign"
```

(Or simpler: `git commit -m "Package theme zip"` if the dynamic message gets unwieldy.)

---

## Done

When all tasks are checked off:
- Home featured-work block lightened, hero overlap removed, cursor spotlight gone, Fraunces card titles
- All five case studies have typed eyebrows, thesis taglines, three-slot sidebars with per-study Signal content
- Static counterparts exist for all five case studies (3 updated, 2 newly created)
- gscan passes with 0 errors
- Theme zip packaged and (optionally) deployed
