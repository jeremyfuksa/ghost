# Seven Years in Healthcare UX — Case Study Design

**Date:** 2026-04-12
**Status:** Approved

---

## Overview

Add the second case study page to the Ghost theme. "Seven Years in Healthcare UX" is a narrative career arc piece covering three phases at Cerner / Oracle Health: revenue cycle product design, design system engineering, and distributed design management through a $28B acquisition. It follows the same per-case-study template pattern established by the Terra case study.

---

## Decisions

- **Visibility:** Public (no password protection)
- **Delivery:** Standalone page at its own URL
- **Architecture:** Ghost page + dedicated HBS template (`custom-casestudy-cerner.hbs`). Sidebar metadata hardcoded in template. Prose authored in Ghost Admin, rendered via `{{content}}`.
- **Layout:** Two-column — prose left (~65%), sticky sidebar right (~35%)
- **URL pattern:** `/work/seven-years-in-healthcare-ux/`
- **Sidebar:** 4 metadata fields only (Role, Organization, Timeline, Scope) — no stats grid, no external links
- **Timeline:** HTML table in prose, styled with new `.casestudy-prose table/th/td` CSS
- **Artifacts section:** Omitted
- **Work page:** "Leadership narratives" placeholder card (`work-card-static`) upgraded to a real link card

---

## Files

### New files

| File | Purpose |
|------|---------|
| `theme/custom-casestudy-cerner.hbs` | Cerner case study template |
| `static/casestudy-cerner.html` | Static design companion |

### Modified files

| File | Change |
|------|--------|
| `theme/assets/css/components.css` | Add `.casestudy-prose table/th/td` styles |
| `theme/routes.yaml` | Add `/work/seven-years-in-healthcare-ux/` route |
| `theme/custom-work.hbs` | Upgrade Leadership narratives placeholder to real link card |
| `static/work.html` | Same upgrade for static companion |
| `dev/setup.sh` | Seed Cerner page + assign template |

---

## Page Structure

```
← Work  (back link, mono font)

[Leadership narratives]   ← eyebrow, accent color
Seven Years in Healthcare UX   ← H1
[tagline]   ← 1-2 sentences

──────────────────────────────────────────────────── (hairline)

[prose: ~65%]                         [sidebar: ~35%, sticky]
  H2: Overview                          Role
  H2: Revenue Cycle: Learning            Organization
       the Domain                        Timeline
  H2: Terra: Working in the Gap          Scope
  H2: Management: A Different Job
  H2: What I Protected
  H2: What I Carried Out
  H2: Timeline
    [HTML table: Phase / Dates /
     Role / Scope]
```

---

## Template Architecture

**`custom-casestudy-cerner.hbs`** — extends `{{!< default}}`, wraps in `{{#page}}`:
- Hardcoded sidebar: Role (progression), Organization, Timeline, Scope
- `{{content}}` renders prose authored in Ghost Admin
- Ghost Admin page title becomes `{{title}}` in the header

**Eyebrow:** "Leadership narratives"
**Tagline:** "Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition."
**Slug:** `seven-years-in-healthcare-ux`

---

## CSS

All new classes follow existing naming conventions. Only new rules needed for this case study:

```
.casestudy-prose table   — full-width, border-collapse
.casestudy-prose th      — mono, uppercase, muted label style (10px, letter-spacing: 0.1em)
.casestudy-prose td      — hairline row separators, vertical-align: top
.casestudy-prose tr:last-child td   — no bottom border
.casestudy-prose td:first-child     — slightly bolder, heading color
.casestudy-prose td:nth-child(2)    — mono, muted (dates column)
```

All existing `.casestudy-*` and `.cs-*` classes already defined in `components.css` are reused unchanged.

---

## Token Usage

All values use existing tokens. No hardcoded pixels.

| Property | Token |
|----------|-------|
| Table border | `--border-hairline` solid `--border-default` |
| Row separator | `--border-hairline` solid `--border-subtle` (lighter) |
| Mono font | `--font-mono` |
| Heading color | `--color-text-heading` |
| Muted color | `--text-tertiary` |
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
  /work/seven-years-in-healthcare-ux/:
    template: custom-casestudy-cerner
    data: page.seven-years-in-healthcare-ux
```

---

## Work Page Update

The "Leadership narratives" placeholder card (`work-card-static`) becomes a real link card (`work-card`) pointing to `/work/seven-years-in-healthcare-ux/`:
- **Title:** "Seven Years in Healthcare UX"
- **Excerpt:** "Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition."
- **Meta:** "2018–2024"

---

## Ghost Content

One Ghost page seeded via `dev/setup.sh` using the Python JSON encoding pattern (same as Terra):
- **Title:** Seven Years in Healthcare UX
- **Slug:** seven-years-in-healthcare-ux
- **Template:** custom-casestudy-cerner
- **Status:** Published
- **Body:** Full prose (Overview → Timeline table) as HTML with H2 headings + HTML table

---

## Prose Content

### Sections (in order)

**Overview** — Two paragraphs. Covers all three phases: revenue cycle (3 months), Terra/UX Foundations (3.5 years), design management (2022–2024). Ends: "This is the full arc."

**Revenue Cycle: Learning the Domain** — Four paragraphs. Dense Millennium interface, patient stay compliance widget, learning that density is a design requirement not a problem.

**Terra: Working in the Gap** — Three paragraphs. Links to `/work/terra-design-system/` for details. Short version: PR review, interaction/accessibility in code, icon library, 125+ standards, 150+ guidelines, 3.5 years.

**Management: A Different Job** — Four paragraphs. IC work ended, job became people. Peak: 12 designers, 8 locations. Oracle philosophy shift: 80% IC / 20% manager. Went from 12 reports to 5.

**What I Protected** — Two paragraphs. Got 3 reports promoted with pay raises during Oracle freeze. Required airtight justification packages. Most important management work — doesn't show up as a deliverable.

**What I Carried Out** — Five paragraphs. Lessons: density is a requirement, design systems are a coordination problem, management is advocacy. Ends: IC and management were different jobs.

**Timeline** — HTML table:

| Phase | Dates | Role | Scope |
|-------|-------|------|-------|
| Revenue Cycle | Sep–Dec 2018 | UX Designer | Middle office product, patient stay compliance widget |
| Terra / UX Foundations | Dec 2018–Mid 2022 | Senior UX Designer | Design system engineering partnership, PR review, icon library, design advisory |
| Design Management | Mid 2022–2024 | UX Design Manager | 5–12 reports across 8 locations, 3 continents; team leadership through Oracle acquisition |

---

## Sidebar Values (hardcoded in template)

| Field | Value |
|-------|-------|
| Role | UX Designer → Senior UX Designer → UX Design Manager |
| Organization | Cerner / Oracle Health |
| Timeline | 2018–2024 |
| Scope | Revenue cycle product design, design system engineering partnership, distributed team leadership through a $28B acquisition |

---

## Out of Scope

- Stats grid (no quantitative stats block for this piece)
- External links in sidebar
- Artifacts section (omitted by design)
- Password protection
