# Domain Foundation Case Study Design

**Date:** 2026-04-12
**Status:** Approved

---

## Overview

Add a third case study page to the Ghost theme. "Domain Foundation" is a methodology and research piece covering the design and validation of a four-layer knowledge architecture for AI-assisted design workflows. It follows the same per-case-study template pattern established by Terra and Cerner, with a sidebar that includes both metadata fields and a 2×2 stats grid (like Terra, unlike Cerner).

---

## Decisions

- **Visibility:** Public (no password protection)
- **Delivery:** Standalone page at its own URL
- **Architecture:** Ghost page + dedicated HBS template (`custom-casestudy-domain-foundation.hbs`). Sidebar metadata hardcoded in template. Prose authored in Ghost Admin, rendered via `{{content}}`.
- **Layout:** Two-column — prose left (~65%), sticky sidebar right (~35%)
- **URL pattern:** `/work/domain-foundation/`
- **Sidebar:** 3 metadata fields (Role, Timeline, Scope — no Organization, self-directed work) + divider + 2×2 stats grid (9 findings, 7 frameworks, 4 knowledge layers, 5 validation tiers) + no external links
- **Work page:** "Experiments" placeholder card upgraded to a real link card
- **New CSS:** None required — existing casestudy block covers all needed styles

---

## Files

### New files

| File | Purpose |
|------|---------|
| `theme/custom-casestudy-domain-foundation.hbs` | Domain Foundation case study template |
| `static/casestudy-domain-foundation.html` | Static design companion |

### Modified files

| File | Change |
|------|--------|
| `theme/routes.yaml` | Add `/work/domain-foundation/` route |
| `theme/custom-work.hbs` | Upgrade Experiments placeholder to real link card |
| `static/work.html` | Same upgrade for static companion |
| `dev/setup.sh` | Seed Domain Foundation page + assign template |

---

## Page Structure

```
← Work  (back link, mono font)

[Experiments]             ← eyebrow, accent color
Domain Foundation         ← H1
[tagline]                 ← 1-2 sentences

──────────────────────────────────────────────────── (hairline)

[prose: ~65%]                         [sidebar: ~35%, sticky]
  H2: Overview                          Role
  H2: The Problem                       Timeline
  H2: The Insight                       Scope
  H2: The Architecture                  ────
  H2: What I Built and Tested           [2×2 stat grid]
  H2: The Frameworks                      9 / findings
  H2: The Technical Stack                 7 / frameworks
  H2: Why This Matters                    4 / knowledge layers
  H2: Current Status                      5 / validation tiers
```

---

## Template Architecture

**`custom-casestudy-domain-foundation.hbs`** — extends `{{!< default}}`, wraps in `{{#page}}`:
- Hardcoded sidebar: Role, Timeline, Scope (3 fields), divider, 2×2 stats
- `{{content}}` renders prose authored in Ghost Admin
- Ghost Admin page title becomes `{{title}}` in the header

**Eyebrow:** "Experiments"
**Tagline:** "A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows."
**Slug:** `domain-foundation`

---

## Sidebar Values (hardcoded in template)

| Field | Value |
|-------|-------|
| Role | Creator and primary researcher |
| Timeline | 2023–2024, ongoing |
| Scope | A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows |

### Stats grid (2×2)

| Value | Label |
|-------|-------|
| 9 | Findings |
| 7 | Frameworks |
| 4 | Knowledge layers |
| 5 | Validation tiers |

One `cs-divider` between the metadata fields and the stats grid. No second divider after the stats (no links follow). Sidebar ends after the stats grid.

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
  /work/domain-foundation/:
    template: custom-casestudy-domain-foundation
    data: page.domain-foundation
```

---

## Work Page Update

The "Experiments" placeholder card (`work-card-static`) becomes a real link card (`work-card`) pointing to `/work/domain-foundation/`:
- **Title:** "Domain Foundation"
- **Excerpt:** "A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows."
- **Meta:** "2023–ongoing"

---

## Ghost Content

One Ghost page seeded via `dev/setup.sh` using the Python JSON encoding pattern:
- **Title:** Domain Foundation
- **Slug:** domain-foundation
- **Template:** custom-casestudy-domain-foundation
- **Status:** Published
- **Body:** Full prose (Overview → Current Status) as HTML with H2 headings

---

## Prose Content

### Sections (in order)

**Overview** — Two paragraphs. AI tools generate fast, not right. Domain Foundation closes the gap between model capability and domain expertise. Ends with scope: thinking, architecture, findings.

**The Problem** — Three paragraphs. Design systems tell AI *what* to build, not *why*. The reasoning — clinical safety, workflow constraints, non-negotiable accessibility — lives in people's heads. AI produces plausible output without domain context but can't distinguish safe from unsafe in a clinical layout.

**The Insight** — Two paragraphs. Design systems need to become brains, not libraries. The shift from documentation to machine-queryable intelligence: encoding institutional knowledge into structures AI tools consume alongside tokens and component specs.

**The Architecture** — Five paragraphs. Four-layer knowledge model: Base (universal, design system team), Domain (industry, domain experts), Component (artifact-specific, component authors), Role (user context, researchers). Layers compose at generation time. Governance is distributed.

**What I Built and Tested** — Four paragraphs. Not theoretical — working systems, structured experiments, nine findings grouped by theme: knowledge structure (3 findings), generation fidelity (2 findings), architecture (3 findings), workflow (1 finding: bootstrap-navigate-validate pattern).

**The Frameworks** — Eight paragraphs. Seven original frameworks: The Validation Stack (5-tier model), The Role Inversion Model (designers → validators, researchers → reality anchors), The Velocity Paradox (AI compresses generation not validation), Design Systems as Executable Knowledge, The "Being Right vs. Getting to Right" Divide, The Four-Layer Knowledge Architecture, The Bootstrap-Navigate-Validate Pattern.

**The Technical Stack** — Three paragraphs. Architecture: vectorized database → MCP server → LLM. Value is in what goes in the database, how it's structured, how it's governed. Dual-path delivery (semantic retrieval + file-based fallback). Graceful degradation built in.

**Why This Matters** — Two paragraphs. Every organization adopting AI design tools is about to discover their design system isn't enough. Companies that figure out the reasoning layer early will produce work reflecting genuine expertise. Domain Foundation is how you build that layer.

**Current Status** — Two paragraphs. Methodology complete and validated. Repackaging underway — removing employer-specific references, generalizing healthcare examples. Frameworks and findings are domain-agnostic: healthcare made them sharp, they apply anywhere design decisions have consequences.

---

## CSS

No new CSS required. All needed classes already exist in `components.css`:
- `.casestudy-*` — page, back, header, eyebrow, title, tagline, body, prose
- `.cs-meta-group`, `.cs-meta-label`, `.cs-meta-value` — sidebar metadata
- `.cs-divider` — hairline divider between sections
- `.cs-stats`, `.cs-stat`, `.cs-stat-value`, `.cs-stat-label` — 2×2 stats grid

---

## Out of Scope

- External links in sidebar (no public artifact URLs)
- Password protection
- Table styles (no tables in this prose)
- Organization metadata field (self-directed work)
