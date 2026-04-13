# Work Page Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the work page's 2-column card grid with a flat editorial row list showing only case studies and experiments — no writing posts, no locked section.

**Architecture:** Three files change: `components.css` (swap old card/grid/category classes for new work-list/work-row classes), `theme/custom-work.hbs` (replace `work-grid` section with `work-list` section, remove `{{#get "posts"}}` block), and `static/work.html` (same structural change, relative paths). The "Work with me" CTA section and all its classes are untouched.

**Tech Stack:** Ghost 6 Handlebars theme, vanilla CSS with design tokens, no build step.

---

## File Map

| Action | File | Responsibility |
|--------|------|----------------|
| Modify | `theme/assets/css/components.css` | Remove 14 old work-card/grid/category rule blocks, add 6 new work-list/work-row rules, remove `.work-grid` media query |
| Modify | `theme/custom-work.hbs` | Replace `<section class="work-grid">` block with `<section class="work-list">`, remove `{{#get "posts"}}` writing section, remove locked section |
| Modify | `static/work.html` | Same structural change as HBS, use relative hrefs, update sync comment |

---

## Task 1: Update CSS — swap grid/card/category classes for editorial row classes

**Files:**
- Modify: `theme/assets/css/components.css` (lines 2027–2180)

- [ ] **Step 1: Remove the old work-grid, work-category, work-card block**

In `theme/assets/css/components.css`, find and replace this entire block (lines 2027–2146):

Old string to find:
```css
.work-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--spacing-8);
  margin-bottom: var(--spacing-16);
}

.work-category {
  border-top: var(--border-hairline) solid var(--border-default);
  padding-top: var(--spacing-5);
}

.work-category-header {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-bottom: var(--spacing-4);
}

.work-category-label {
  font-family: var(--font-sans);
  font-size: var(--text-xs);
  font-weight: var(--font-weight-bold);
  letter-spacing: var(--tracking-widest);
  text-transform: uppercase;
  color: var(--text-tertiary);
}

.work-category-link {
  font-family: var(--font-sans);
  font-size: var(--text-sm);
  color: var(--color-accent-text);
  font-weight: var(--font-weight-medium);
}

.work-category-link:hover {
  color: var(--color-accent-hover);
}

.work-category-lock {
  font-family: var(--font-mono);
  font-size: var(--text-2xs);
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: var(--tracking-wide);
}

.work-category-body {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-3);
}

.work-card {
  display: block;
  padding: var(--spacing-4);
  background: var(--bg-subtle);
  border: var(--border-hairline) solid var(--border-subtle);
  border-radius: var(--radius-lg);
  transition: border-color var(--transition-fast), transform var(--transition-fast);
}

.work-card:hover {
  border-color: var(--color-accent-ui);
  transform: translateY(-1px);
}

.work-card-static,
.work-card-locked {
  cursor: default;
}

.work-card-static:hover,
.work-card-locked:hover {
  transform: none;
}

.work-card-locked {
  background: var(--color-accent-subtle);
  border-style: dashed;
  border-color: var(--color-accent-ui);
}

.work-card-title {
  font-size: var(--text-lg);
  margin-bottom: var(--spacing-2);
  letter-spacing: var(--tracking-snug);
}

.work-card-excerpt {
  font-size: var(--text-sm);
  line-height: var(--leading-sm);
  color: var(--text-secondary);
  margin-bottom: var(--spacing-3);
}

.work-card-meta {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  color: var(--text-tertiary);
}

.work-card-cta {
  display: inline-block;
  font-family: var(--font-sans);
  font-size: var(--text-sm);
  font-weight: var(--font-weight-semibold);
  color: var(--color-accent-text);
  margin-top: var(--spacing-2);
}

.work-card-cta:hover {
  color: var(--color-accent-hover);
}

.work-empty {
  font-size: var(--text-sm);
  color: var(--text-tertiary);
  font-style: italic;
}
```

Replace with:
```css
.work-list {
  max-width: var(--prose-max);
  margin: 0 auto var(--spacing-16);
}

.work-row {
  display: block;
  padding: var(--spacing-6) 0;
  border-bottom: var(--border-hairline) solid var(--border-default);
  transition: opacity var(--transition-fast);
}

.work-row:first-child {
  border-top: var(--border-hairline) solid var(--border-default);
}

.work-row:hover {
  opacity: 0.7;
}

.work-row-meta {
  font-family: var(--font-mono);
  font-size: var(--text-2xs);
  text-transform: uppercase;
  letter-spacing: var(--tracking-widest);
  color: var(--color-accent-text);
  margin-bottom: var(--spacing-2);
}

.work-row-title {
  font-size: var(--text-xl);
  font-weight: var(--font-weight-semibold);
  color: var(--text-primary);
  margin-bottom: var(--spacing-2);
  letter-spacing: var(--tracking-snug);
}

.work-row-excerpt {
  font-size: var(--text-sm);
  line-height: var(--leading-sm);
  color: var(--text-secondary);
}
```

- [ ] **Step 2: Remove the `.work-grid` media query**

In `theme/assets/css/components.css`, find:
```css
@media (max-width: 768px) {
  .work-grid {
    grid-template-columns: 1fr;
  }
}
```

Replace with nothing — delete it entirely. The replacement is an empty string (the block is removed, not replaced).

- [ ] **Step 3: Verify the CSS file opens without errors**

```bash
open static/work.html
```

Check the browser console — no CSS errors. The page will look broken at this point since the HBS/HTML hasn't been updated yet. That's expected.

- [ ] **Step 4: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "refactor: replace work card/grid CSS with editorial row classes"
```

---

## Task 2: Update theme/custom-work.hbs

**Files:**
- Modify: `theme/custom-work.hbs`

- [ ] **Step 1: Replace the work-grid section with work-list**

In `theme/custom-work.hbs`, find the entire `<section class="work-grid">` block:

```handlebars
  <section class="work-grid">
    {{!-- Writing & thinking --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Writing &amp; thinking</span>
        <a href="/writing/" class="work-category-link">All writing &rarr;</a>
      </div>
      <div class="work-category-body">
        {{#get "posts" limit="3" order="published_at desc"}}
          {{#if posts}}
            {{#foreach posts}}
              <a href="{{url}}" class="work-card">
                <h3 class="work-card-title">{{title}}</h3>
                {{#if custom_excerpt}}
                  <p class="work-card-excerpt">{{custom_excerpt}}</p>
                {{else}}
                  <p class="work-card-excerpt">{{excerpt words="20"}}</p>
                {{/if}}
                <span class="work-card-meta">{{date format="MMM YYYY"}}</span>
              </a>
            {{/foreach}}
          {{else}}
            <p class="work-empty">No posts yet.</p>
          {{/if}}
        {{/get}}
      </div>
    </div>

    {{!-- Systems work --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Systems work</span>
      </div>
      <div class="work-category-body">
        <a href="/work/terra-design-system/" class="work-card">
          <h3 class="work-card-title">Terra Design System</h3>
          <p class="work-card-excerpt">Open-source React component library. 80+ components, 200+ icons, WCAG 2.1 AA. Cerner / Oracle Health, 2018–2024.</p>
          <span class="work-card-meta">2018–2024</span>
        </a>
      </div>
    </div>

    {{!-- Leadership narratives --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Leadership narratives</span>
      </div>
      <div class="work-category-body">
        <a href="/work/seven-years-in-healthcare-ux/" class="work-card">
          <h3 class="work-card-title">Seven Years in Healthcare UX</h3>
          <p class="work-card-excerpt">Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.</p>
          <span class="work-card-meta">2018–2024</span>
        </a>
      </div>
    </div>

    {{!-- Experiments --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Experiments</span>
      </div>
      <div class="work-category-body">
        <a href="/work/domain-foundation/" class="work-card">
          <h3 class="work-card-title">Domain Foundation</h3>
          <p class="work-card-excerpt">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.</p>
          <span class="work-card-meta">2023–ongoing</span>
        </a>
      </div>
    </div>

    {{!-- Case studies (password-gated) --}}
    <div class="work-category work-category-locked">
      <div class="work-category-header">
        <span class="work-category-label">Case studies</span>
        <span class="work-category-lock">Password-protected</span>
      </div>
      <div class="work-category-body">
        <div class="work-card work-card-locked">
          <h3 class="work-card-title">Detailed engagement case studies</h3>
          <p class="work-card-excerpt">Process, decisions, and outcomes from specific engagements. Available on request — drop me a line and I'll share the password.</p>
          <a href="#work-with-me" class="work-card-cta">Request access &rarr;</a>
        </div>
      </div>
    </div>
  </section>
```

Replace with:

```handlebars
  <section class="work-list">
    <a href="/work/terra-design-system/" class="work-row">
      <div class="work-row-meta">Case study · 2018–2024</div>
      <div class="work-row-title">Terra Design System</div>
      <div class="work-row-excerpt">Open-source React component library. 80+ components, 200+ icons, WCAG 2.1 AA. Built and led at Cerner / Oracle Health.</div>
    </a>
    <a href="/work/seven-years-in-healthcare-ux/" class="work-row">
      <div class="work-row-meta">Case study · 2018–2024</div>
      <div class="work-row-title">Seven Years in Healthcare UX</div>
      <div class="work-row-excerpt">Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.</div>
    </a>
    <a href="/work/domain-foundation/" class="work-row">
      <div class="work-row-meta">Experiment · 2023–ongoing</div>
      <div class="work-row-title">Domain Foundation</div>
      <div class="work-row-excerpt">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.</div>
    </a>
  </section>
```

- [ ] **Step 2: Update the intro fallback text**

In `theme/custom-work.hbs`, find:
```handlebars
    {{#if custom_excerpt}}
      <p class="work-intro">{{custom_excerpt}}</p>
    {{else}}
      <p class="work-intro">A cross-section of the work I do — writing, systems thinking, leadership, and experiments. Some of it lives publicly. Some of it doesn't.</p>
    {{/if}}
```

Replace with:
```handlebars
    {{#if custom_excerpt}}
      <p class="work-intro">{{custom_excerpt}}</p>
    {{else}}
      <p class="work-intro">Systems thinking, design leadership, and experiments at the intersection of craft and technology.</p>
    {{/if}}
```

- [ ] **Step 3: Commit**

```bash
git add theme/custom-work.hbs
git commit -m "refactor: redesign work page to editorial rows"
```

---

## Task 3: Update static/work.html

**Files:**
- Modify: `static/work.html`

- [ ] **Step 1: Update the sync comment**

In `static/work.html`, find:
```html
<!--
  STATIC SOURCE for: theme/custom-work.hbs
  Last synced: 2026-04-12
```

Confirm the date already reads `2026-04-12`. If it does not, update it to `2026-04-12`.

- [ ] **Step 2: Replace the work-grid section with work-list**

In `static/work.html`, find the entire `<section class="work-grid">` block:

```html
      <section class="work-grid">
        <div class="work-category">
          <div class="work-category-header">
            <span class="work-category-label">Writing &amp; thinking</span>
            <a href="writing.html" class="work-category-link">All writing &rarr;</a>
          </div>
          <div class="work-category-body">
            <a href="post.html" class="work-card">
              <h3 class="work-card-title">On Design Systems That Actually Ship</h3>
              <p class="work-card-excerpt">Why most design systems stall, and what to do about it before the team gives up.</p>
              <span class="work-card-meta">Mar 2026</span>
            </a>
            <a href="post.html" class="work-card">
              <h3 class="work-card-title">UX Strategy as a Business Lever</h3>
              <p class="work-card-excerpt">Translating design work into the language the business uses to make decisions.</p>
              <span class="work-card-meta">Feb 2026</span>
            </a>
          </div>
        </div>

        <div class="work-category">
          <div class="work-category-header">
            <span class="work-category-label">Systems work</span>
          </div>
          <div class="work-category-body">
            <a href="casestudy-terra.html" class="work-card">
              <h3 class="work-card-title">Terra Design System</h3>
              <p class="work-card-excerpt">Open-source React component library. 80+ components, 200+ icons, WCAG 2.1 AA. Cerner / Oracle Health, 2018–2024.</p>
              <span class="work-card-meta">2018–2024</span>
            </a>
          </div>
        </div>

        <div class="work-category">
          <div class="work-category-header">
            <span class="work-category-label">Leadership narratives</span>
          </div>
          <div class="work-category-body">
            <a href="casestudy-cerner.html" class="work-card">
              <h3 class="work-card-title">Seven Years in Healthcare UX</h3>
              <p class="work-card-excerpt">Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.</p>
              <span class="work-card-meta">2018–2024</span>
            </a>
          </div>
        </div>

        <div class="work-category">
          <div class="work-category-header">
            <span class="work-category-label">Experiments</span>
          </div>
          <div class="work-category-body">
            <a href="casestudy-domain-foundation.html" class="work-card">
              <h3 class="work-card-title">Domain Foundation</h3>
              <p class="work-card-excerpt">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.</p>
              <span class="work-card-meta">2023–ongoing</span>
            </a>
          </div>
        </div>

        <div class="work-category work-category-locked">
          <div class="work-category-header">
            <span class="work-category-label">Case studies</span>
            <span class="work-category-lock">Password-protected</span>
          </div>
          <div class="work-category-body">
            <div class="work-card work-card-locked">
              <h3 class="work-card-title">Detailed engagement case studies</h3>
              <p class="work-card-excerpt">Process, decisions, and outcomes from specific engagements. Available on request — drop me a line and I'll share the password.</p>
              <a href="#work-with-me" class="work-card-cta">Request access &rarr;</a>
            </div>
          </div>
        </div>
      </section>
```

Replace with:

```html
      <section class="work-list">
        <a href="casestudy-terra.html" class="work-row">
          <div class="work-row-meta">Case study · 2018–2024</div>
          <div class="work-row-title">Terra Design System</div>
          <div class="work-row-excerpt">Open-source React component library. 80+ components, 200+ icons, WCAG 2.1 AA. Built and led at Cerner / Oracle Health.</div>
        </a>
        <a href="casestudy-cerner.html" class="work-row">
          <div class="work-row-meta">Case study · 2018–2024</div>
          <div class="work-row-title">Seven Years in Healthcare UX</div>
          <div class="work-row-excerpt">Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.</div>
        </a>
        <a href="casestudy-domain-foundation.html" class="work-row">
          <div class="work-row-meta">Experiment · 2023–ongoing</div>
          <div class="work-row-title">Domain Foundation</div>
          <div class="work-row-excerpt">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.</div>
        </a>
      </section>
```

- [ ] **Step 3: Update the intro fallback text**

In `static/work.html`, find:
```html
        <p class="work-intro">A cross-section of the work I do — writing, systems thinking, leadership, and experiments. Some of it lives publicly. Some of it doesn't.</p>
```

Replace with:
```html
        <p class="work-intro">Systems thinking, design leadership, and experiments at the intersection of craft and technology.</p>
```

- [ ] **Step 4: Commit**

```bash
git add static/work.html
git commit -m "refactor: update static work companion to editorial rows"
```

---

## Task 4: Browser verification

No file changes — verification only.

- [ ] **Step 1: Open static companion**

```bash
open static/work.html
```

Verify:
- Three editorial rows render: Terra Design System, Seven Years in Healthcare UX, Domain Foundation
- Each row has amber mono type label + date, bold title, muted excerpt
- First row has a top border hairline
- Each row has a bottom border hairline
- No card boxes, no category headers, no writing posts, no locked section
- "Work with me" CTA section renders below the list

- [ ] **Step 2: Open live Ghost page**

```bash
open http://localhost:2368/work/
```

Verify the same structure renders on the Ghost-served page.

- [ ] **Step 3: Test hover state**

Hover over each row — opacity should drop to ~70%. No transform/movement.

- [ ] **Step 4: Test mobile**

Browser DevTools → 375px viewport.

Verify: rows stack single-column (they already do), no horizontal overflow, "Work with me" actions stack vertically.

- [ ] **Step 5: Run gscan**

```bash
cd theme && npx gscan . && cd ..
```

Expected: 0 errors (1 warning for custom fonts is normal).

---

## Self-Review

**Spec coverage:**
- ✅ Editorial rows replacing card grid
- ✅ Writing posts removed ({{#get "posts"}} block gone)
- ✅ Locked section removed
- ✅ Work with me CTA unchanged
- ✅ New CSS classes: `.work-list`, `.work-row`, `.work-row:first-child`, `.work-row:hover`, `.work-row-meta`, `.work-row-title`, `.work-row-excerpt`
- ✅ Removed CSS: all `.work-grid`, `.work-category*`, `.work-card*`, `.work-empty` classes
- ✅ `.work-grid` media query removed
- ✅ Intro fallback text updated
- ✅ Static companion updated with relative paths
- ✅ All three work pieces present in both HBS and static

**Placeholder scan:** No TBDs or vague instructions. All code blocks are complete.

**Consistency:** Class names `.work-row`, `.work-row-meta`, `.work-row-title`, `.work-row-excerpt` are used identically in CSS (Task 1), HBS (Task 2), and static (Task 3).
