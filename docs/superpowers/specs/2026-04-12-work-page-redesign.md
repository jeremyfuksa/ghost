# Work Page Redesign Design

**Date:** 2026-04-12
**Status:** Approved

---

## Overview

Redesign the `/work/` page from a category grid with boxed cards to a clean editorial row list. The page currently mixes writing posts, case studies, experiments, and a password-protected placeholder into a 2-column card grid. The new design removes all of that structure and replaces it with a flat list of rows — one per work piece — focused solely on the case studies and experiments that already have dedicated pages.

---

## Decisions

- **Structure:** Single-column editorial rows (no grid, no cards, no category headers)
- **Content:** Case studies and experiments only — no writing posts pulled via `{{#get "posts"}}`, no locked/password-protected section
- **Work with me CTA:** Stays at bottom, unchanged
- **Intro text:** Uses `{{custom_excerpt}}` from Ghost Admin (dynamic), with a hardcoded fallback in the template
- **Row anatomy:** Type label (amber mono) · date · title · one-liner excerpt
- **New CSS:** `.work-list`, `.work-row`, `.work-row-meta`, `.work-row-title`, `.work-row-excerpt` added to `components.css`
- **Removed CSS:** `.work-grid`, `.work-category*`, `.work-card*`, `.work-empty` — no longer needed, removed to keep the file clean

---

## Files

### Modified files

| File | Change |
|------|--------|
| `theme/assets/css/components.css` | Replace grid/card/category CSS with work-list/work-row CSS |
| `theme/custom-work.hbs` | Full restructure — editorial rows, remove writing section and locked section |
| `static/work.html` | Same restructure as HBS companion |

---

## Page Structure

```
[eyebrow]                     ← "The Cocktail Napkin"
Work                          ← H1
[intro]                       ← {{custom_excerpt}} or fallback

──────────────────────────────  (hairline)

Case study · 2018–2024        ← .work-row-meta (amber mono)
Terra Design System           ← .work-row-title
[one-liner]                   ← .work-row-excerpt

──────────────────────────────  (hairline, between rows)

Case study · 2018–2024
Seven Years in Healthcare UX
[one-liner]

──────────────────────────────

Experiment · 2023–ongoing
Domain Foundation
[one-liner]

──────────────────────────────

[Work with me CTA]            ← unchanged, existing classes
```

---

## HTML Structure

### Work list (replaces `.work-grid` and all category/card markup)

```html
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

Each `.work-row` is an `<a>` tag — the entire row is the link. No arrow element in the DOM; hover state communicates interactivity via opacity shift.

---

## CSS

### New classes (add to `components.css`, replacing grid/card/category block)

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

### Removed classes (delete from `components.css`)

- `.work-grid` and its `@media` rule
- `.work-category`, `.work-category-header`, `.work-category-label`
- `.work-category-link`, `.work-category-link:hover`
- `.work-category-lock`, `.work-category-body`
- `.work-card`, `.work-card:hover`
- `.work-card-static`, `.work-card-locked` and their hover rules
- `.work-card-title`, `.work-card-excerpt`, `.work-card-meta`
- `.work-card-cta`, `.work-card-cta:hover`
- `.work-empty`

### Kept classes (unchanged)

- `.work-page`, `.work-header`, `.work-header h1`, `.work-intro`
- `.work-feature-image`, `.work-feature-image img`, `.work-prose`
- `.work-cta-section`, `.work-cta-title`, `.work-cta-body`, `.work-cta-actions`
- All existing mobile responsive rules for `.work-page` and `.work-cta-actions`

---

## HBS Template (custom-work.hbs)

Full replacement of the `<section class="work-grid">` block and its contents with `<section class="work-list">`. The `{{#get "posts"}}` block is removed entirely. The work-with-me section is unchanged.

The intro uses:
```handlebars
{{#if custom_excerpt}}
  <p class="work-intro">{{custom_excerpt}}</p>
{{else}}
  <p class="work-intro">Systems thinking, design leadership, and experiments at the intersection of craft and technology.</p>
{{/if}}
```

---

## Static Companion (static/work.html)

Same restructure as the HBS template. Back link uses relative paths (`casestudy-terra.html`, `casestudy-cerner.html`, `casestudy-domain-foundation.html`) instead of Ghost absolute URLs. Update `Last synced` comment to `2026-04-12`.

---

## Out of Scope

- Writing posts on the work page (removed; belongs on `/writing/`)
- Password-protected case studies section (removed)
- Category headers / labels (removed)
- Arrow icons or visual indicators beyond hover opacity
- Changes to the case study pages themselves
- Changes to the writing page
