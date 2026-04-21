# Work Page — Content Reference

Markdown source-of-truth for the copy on `/work/`. The live page is rendered by `theme/custom-work.hbs` (Ghost's `custom-*.hbs` per-page template convention). Copy edits live here for archival; deploys follow the repo's documented workflow in CLAUDE.md.

---

## Page intro (work-intro paragraph)

Falls inside a `{{#if custom_excerpt}}...{{else}}...{{/if}}` block in the template. The template hardcodes the fallback below; the `custom_excerpt` field on the Ghost page overrides it at edit time without a redeploy.

> The work falls into three groups. The methodology is Domain Foundation — an architecture for encoding design expertise into AI-reachable form. Demonstrations are how it runs in practice. Case studies are the client-facing enterprise work.

---

## Orbit 1 — Methodology

The methodology, in one place. Domain Foundation is the current form — and, for now, the whole of it.

**Exhibits:**

- **Domain Foundation** — _Methodology · 2023–ongoing_ → `/work/domain-foundation/`
  A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.

---

## Orbit 2 — Demonstrations

How the methodology runs in practice. Four in production: the Skill Ecosystem, jeremyfuksa.com as an applied case, Jeremy OS, and the Moonbird origin dispatch. Publishing as they're ready.

_(No exhibits yet. Empty state is text-only, not a placeholder card.)_

**In production, not yet shipped:**

- **The Skill Ecosystem** — the collection of encoded skills (jeremy-voice, campfire-css, omnifocus-expert, jeremys-workshop, moonbird-oracle, etc.) written up as a single exhibit demonstrating Domain Foundation running end-to-end on one practitioner.
- **jeremyfuksa.com Build** — the Ghost 6 theme production, Campfire token sourcing, voice calibration, analog-signal-in-chrome-only constraint, Claude Code theme prompt as executable artifact.
- **Jeremy OS** — the integrated personal infrastructure (OmniFocus conventions, skill ecosystem, dashboard, content engine, Ghost stack) framed as an OS rather than a dashboard.
- **Moonbird origin dispatch** — the Oracle-era research project (scrubbed per the repackaging checklist) as the origin case for Domain Foundation.

---

## Orbit 3 — Case Studies

Enterprise work at Cerner / Oracle Health, where the healthcare UI stakes sharpened the thinking that became Domain Foundation.

**Exhibits:**

- **Terra Design System** — _Case study · 2018–2024_ → `/work/terra-design-system/`
  Open-source React component library. 80+ components, 200+ icons, WCAG 2.1 AA. Built and led at Cerner / Oracle Health.

- **Seven Years in Healthcare UX** — _Case study · 2018–2024_ → `/work/seven-years-in-healthcare-ux/`
  Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.

- **Two Components That Didn't Ship** — _Case study · 2024–2026_ → `/work/redwood-health-design/`
  Health-specific components on Oracle's Redwood design system. The ones I remember best are the two we decided to kill.

---

## Work with me (CTA)

Available for design system engagements, UX strategy consulting, and senior design leadership roles. Based in Kansas City, working with teams anywhere.

- [Get in touch](mailto:hello@jeremyfuksa.com)
- [About me →](/about/)
