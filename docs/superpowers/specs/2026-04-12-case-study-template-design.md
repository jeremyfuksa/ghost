# Case Study Template Design

**Date:** 2026-04-12
**Status:** Approved

---

## Overview

Add a reusable case study system to the Ghost theme. The first piece is the Terra Design System (Cerner / Oracle Health, 2018–2024). More case studies will follow using the same pattern.

---

## Decisions

- **Visibility:** Public (no password protection)
- **Delivery:** Standalone page at its own URL per case study
- **Architecture:** Per-case-study Ghost page + dedicated HBS template. Sidebar metadata hardcoded in the template. Prose content authored in Ghost Admin's editor and rendered via `{{content}}`.
- **Layout:** Two-column — prose left (~65%), sticky sidebar right (~35%)
- **URL pattern:** `/work/{slug}/` via routes.yaml entry per case study

---

## Files

### New files

| File | Purpose |
|------|---------|
| `theme/custom-casestudy-terra.hbs` | Terra case study template |
| `static/casestudy-terra.html` | Static design companion |

### Modified files

| File | Change |
|------|--------|
| `theme/assets/css/components.css` | Add `.casestudy-*` component styles |
| `theme/routes.yaml` | Add `/work/terra-design-system/` route |
| `theme/custom-work.hbs` | Upgrade Systems work placeholder card to a real link |
| `static/work.html` | Same upgrade for static companion |

---

## Page Structure

```
← Work  (back link, mono font)

[Systems work]          ← eyebrow, accent color
Terra Design System     ← H1
[tagline/scope blurb]   ← 1-2 sentences

──────────────────────────────────────────────────── (hairline)

[prose: 65%]                    [sidebar: 35%, sticky]
  H2: Overview                    Role
  ...                             Organization
  H2: The Problem                 Timeline
  ...                             Scope
  H2: My Role                     ────
  ...                             [2×2 stat grid]
  H2: The System                    80+ / React components
  ...                               200+ / Icons
  H2: Outcomes                      1,500 / Healthcare orgs
  ...                               195 / Countries
  H2: What Happened Next          ────
  ...                             GitHub links (mono)
```

---

## Template Architecture

**`custom-casestudy-terra.hbs`** — extends `{{!< default}}`, wraps in `{{#page}}`:
- Hardcoded sidebar: Role, Org, Timeline, Scope, stats, GitHub links
- `{{content}}` renders the prose authored in Ghost Admin
- Ghost Admin page title becomes `{{title}}` in the header

**Reuse pattern for future case studies:**
- Copy `custom-casestudy-terra.hbs`
- Change the hardcoded sidebar values
- Create the Ghost page, assign the new template
- Add a route entry

---

## CSS Classes

All new classes follow existing naming conventions in `components.css`:

```
.casestudy-page          — outer container
.casestudy-back          — "← Work" back link (mono, muted)
.casestudy-header        — title block, bordered bottom
.casestudy-eyebrow       — category label (accent-text, mono, uppercase)
.casestudy-title         — H1 (Fraunces)
.casestudy-tagline       — scope blurb below title
.casestudy-body          — two-column grid wrapper
.casestudy-prose         — left column, prose content
.casestudy-prose h2      — section heading (hairline top border)
.casestudy-sidebar       — right column, sticky
.cs-meta-group           — one metadata field (label + value)
.cs-meta-label           — field label (mono, uppercase, muted)
.cs-meta-value           — field value
.cs-divider              — hairline hr between sidebar sections
.cs-stats                — 2×2 grid of stat blocks
.cs-stat                 — individual stat block (subtle bg)
.cs-stat-value           — large number (Fraunces)
.cs-stat-label           — description (mono, uppercase, muted)
.cs-link                 — external link (mono, accent-text)
```

Mobile: sidebar renders above prose (column reversal), stat grid stays 2×2.

---

## Token Usage

All values use existing tokens. No hardcoded pixels.

| Property | Token |
|----------|-------|
| Sidebar stat background | `--color-tag-bg` |
| Eyebrow / cs-link color | `--color-accent-text` |
| Section border | `--border-hairline` solid `--border-default` |
| Mono font | `--font-mono` |
| Heading font | `--font-serif` (Fraunces) |
| Spacing | `--spacing-*` tokens |

---

## Routes

Add to `theme/routes.yaml`:

```yaml
routes:
  /:
    template: custom-home
    data: page.home
  /work/terra-design-system/:
    template: custom-casestudy-terra
    data: page.terra-design-system
```

---

## Work Page Update

The static "Systems work" placeholder card (`work-card-static`) becomes a real link card (`work-card`) pointing to `/work/terra-design-system/`. Card content:
- Title: "Terra Design System"
- Excerpt: "Open-source React component library. 80+ components, 200+ icons, WCAG 2.1 AA. Cerner / Oracle Health, 2018–2024."
- Meta: "2018–2024"

---

## Ghost Content

One Ghost page seeded via `dev/setup.sh` using the existing `seed_page` / `assign_template` pattern:
- **Title:** Terra Design System
- **Slug:** terra-design-system
- **Template:** custom-casestudy-terra
- **Status:** Published
- **Body:** Full prose content (Overview → What Happened Next) as HTML with H2 headings, passed to `seed_page` as the `html` argument

---

## Out of Scope

- Password-protected case studies (none needed)
- Dynamic metadata (sidebar values are hardcoded per template)
- Tags or taxonomies for case studies
