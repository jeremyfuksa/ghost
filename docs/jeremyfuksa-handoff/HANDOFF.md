# jeremyfuksa.com — `/work/` Rebuild Handoff

**To:** Claude Code
**From:** Web-conversation Claude (working session, April 2026)
**Status:** Staged copy + template + CSS changes, not yet deployed. Ready for your first turn with Jeremy at the terminal.

---

## Read CLAUDE.md first

**If anything in this document conflicts with CLAUDE.md in the theme repo, CLAUDE.md wins.** This handoff was written without direct access to the repo; it's a content and structural proposal, not a deploy playbook. The repo's documented workflow (version bump → commit → zip → `dev/deploy-theme.mjs`) is the source of truth for how this ships.

A prior version of this handoff prescribed an SSH-edit deploy path that would have desynced the live theme from the repo permanently. That's corrected here. If you see anything below that still smells like a shortcut around CLAUDE.md's workflow, trust CLAUDE.md.

---

## What this is

A design and copy rebuild of `/work/` on Jeremy's site — the portfolio page — shifting it from a flat list of case studies into a three-orbit structure that fronts his methodology (Domain Foundation) as the primary exhibit, with demonstrations and enterprise case studies supporting it.

The About page at `/about/` was also rebuilt in the same session and is already live. You don't need to touch it unless Jeremy asks. Archived at `about-page-rewrite.md`.

---

## Why Jeremy is doing this now

Two converging things:

1. He recently read Nate Kadlac's newsletter piece arguing that in an AI-era hiring market, a candidate's artifacts — their actual body of thinking, published — matter more than résumé credentials. Jeremy's current portfolio under-indexes on the thinking and over-indexes on "here are case studies." He wants the new `/work/` to lead with methodology first, demonstrations second, client case studies third.
2. He's post-Oracle Health (laid off, fully independent now), running an active job search for Director / Principal / senior UX leadership roles, and simultaneously building a consulting practice. The `/work/` page is the single highest-leverage artifact for both audiences.

The positioning is **depth over count**. One methodology, pursued seriously, with demonstrations of it running in practice and case studies showing where the thinking came from — beats "seven framework pages" every time at the altitude he's hiring into.

---

## The architecture — three orbits

`/work/` is organized into three parallel orbits, each with its own `<h2>` heading and intro paragraph.

### Methodology (singular)

**The primary IP. One exhibit.**

Domain Foundation is the methodology. It's an architecture for encoding organizational design expertise into AI-reachable form — a four-layer knowledge structure (base layer / domain layer / component layer / role layer, each layer owned by a different role in the design org). Its output is a corpus that downstream AI pipelines can reach, but those downstream applications are out of scope for this page. The methodology itself is the exhibit.

**Important context:** An earlier memory note described "seven frameworks" in Jeremy's repackaged Moonbird body of work. In this session we traced that claim back and found it was speculative — a misreading of an old repackaging plan. The real scope is singular: **Domain Foundation and the Four-Layer Knowledge Architecture collapse into one thing**. They're not a methodology containing multiple frameworks; they're the same work under two names.

Do not scaffold out "framework pages" based on the old note. Do not generate Validation Stack / Role Inversion Model / Velocity Paradox pages. The existing `/work/domain-foundation/` Ghost page already articulates the methodology as one cohesive narrative. Tightening that page is a task below; splitting it into seven is not.

### Demonstrations

How the methodology runs in practice. Four dispatches are in production, none published yet. They'll publish as they're ready. The orbit intentionally shows no placeholder cards — just the intro paragraph, and real cards appear as each dispatch ships.

The four:

1. **The Skill Ecosystem** — Jeremy's collection of encoded skills (jeremy-voice, campfire-css, omnifocus-expert, jeremys-workshop, moonbird-oracle, and others) as a single exhibit demonstrating Domain Foundation running end-to-end on one practitioner. Highest weight; likely first to ship.
2. **jeremyfuksa.com Build** — the Ghost 6 theme build, Campfire token sourcing, voice calibration, the analog-signal-in-chrome-only constraint, and the Claude Code theme prompt as an executable artifact.
3. **Jeremy OS** — the integrated personal infrastructure (OmniFocus, skill ecosystem, Signal/Noise dashboard, content engine, Ghost stack) framed as an operating system rather than a productivity dashboard.
4. **Moonbird origin dispatch** — the Oracle-era research project (scrubbed per the repackaging checklist) as the origin case for Domain Foundation.

### Case Studies

Enterprise work at Cerner / Oracle Health. Three cards, all live at existing URLs:

- Terra Design System (`/work/terra-design-system/`)
- Seven Years in Healthcare UX (`/work/seven-years-in-healthcare-ux/`)
- Two Components That Didn't Ship (`/work/redwood-health-design/`)

---

## The files in this handoff

| File | Role |
| --- | --- |
| `custom-work.hbs` | Proposed template shape. **Diff against the existing `theme/custom-work.hbs` — don't blindly replace.** Preserves `{{#if custom_excerpt}}`, `{{#if feature_image}}`, `{{#if content}}` fallbacks so Jeremy can still edit intro text and add a hero image via Ghost Admin without a redeploy. |
| `work-orbit.css` | CSS rules to insert in `components.css` grouped with existing `.work-*` rules, before the consolidated mobile `@media` block. Only uses existing Campfire tokens. No new variables. |
| `work-page-content.md` | Markdown archival of the copy. Not deployed. |
| `work-page-preview.html` | Self-contained HTML preview rendered against the live site's CSS. Open in a browser to sanity-check before deploying. |
| `DEPLOYMENT-NOTES.md` | Short notes that defer to CLAUDE.md for deploy steps. Carries the verification checklist. |
| `about-page-rewrite.md` | Archival of the About page rewrite (already live). |
| `INITIAL_PROMPT.md` | Paste-ready message for your first turn with Jeremy. |

---

## Critical constraints

### Follow CLAUDE.md's deploy workflow

Version bump `theme/package.json`, commit, zip, upload via `dev/deploy-theme.mjs`. Credentials live in `.env` (gitignored). Don't paste secrets anywhere; don't SSH-edit the droplet.

### `/work/` renders from `custom-work.hbs`, not page body

The Ghost page at `/work/` has an empty body in the admin. All the structural rendering happens in `theme/custom-work.hbs` (Ghost's `custom-*.hbs` per-page template convention). The Ghost Admin API can update the page's `custom_excerpt`, `feature_image`, and `html` content — and the proposed template exposes those via `{{#if}}` fallback blocks — but the three-orbit structure itself lives in the template.

### Design system — Campfire, no new tokens

Jeremy has a `campfire-css` skill that governs all frontend work on this site. **Read it before writing or reviewing any CSS.** Core rule: no new CSS variables, ever. The `work-orbit.css` file was authored to comply.

Tokens in use on this page: `--spacing-*`, `--text-*`, `--leading-*`, `--color-accent-ui`, `--text-secondary`, `--font-sans`, `--prose-max`. The amber `<h2>` underline uses `--color-accent-ui` to match the existing `<h1>` treatment — WCAG-compliant because it's decorative and large, not body text.

### Voice — use the jeremy-voice skill

All prose on this page passed through voice review in the working session. If Jeremy asks you to revise copy, use the `jeremy-voice` skill. Core rules: report flat, don't synthesize; underdraft rather than overstate; cultural/geographic details are load-bearing; no "I learned," no "I discovered," no narration of growth.

### Contact surface

Contact email on the site is `hello@jeremyfuksa.com`.

---

## Next tasks

Not strictly linear. Blockers are called out so you don't chase a task you can't finish.

### 1. Deploy the `/work/` rebuild (unblocked)

Propose the plan to Jeremy before executing — confirm you've read CLAUDE.md, confirm the diff against the existing `custom-work.hbs` (specifically what conditional blocks live in the current file that this proposal doesn't), confirm the CSS insertion point in `components.css`. Then execute per CLAUDE.md's workflow. Verify against the checklist in `DEPLOYMENT-NOTES.md`.

### 2. Tighten the Domain Foundation page (partially blocked)

The existing `/work/domain-foundation/` page is good but was written before this session's clarifications about scope. Under the clarified framing — one methodology, one architectural move, no multi-framework implication — it could be tightened:

- Add a clear diagram of the Four-Layer Knowledge Architecture if one doesn't already exist (SVG or image). Each layer labeled with the role that owns it.
- Tighten the narrative to foreground the architecture as *the* central move, rather than one move among several.
- Add a brief "downstream applications" section that credibly gestures at where the encoded corpus can feed (generation pipelines, validation layers, evaluation harnesses) without claiming ownership of those downstream tools. Jeremy's exact framing: "that kind of stuff is really out of the scope of what we want to talk about, but we could give credible examples."

**Blocker:** the Four-Layer diagram. Jeremy needs to provide source material (a sketch, existing diagram, or rough notes on what each layer's name and role-ownership is) before the page tightening can actually ship with a new diagram. The narrative tightening can proceed without it; the diagram can't.

This is a Ghost page — editable via Admin API using the posts/pages endpoints. Use the `jeremy-voice` skill.

### 3. Write and publish the Skill Ecosystem dispatch (partially blocked)

Highest-weight of the four Demonstrations. Gets the Demonstrations orbit off empty-state. Frame: one practitioner, Domain Foundation running end-to-end on themselves. Use `jeremy-voice`.

**Blocker:** the skill corpus itself. Jeremy has skills in `/mnt/skills/user/` on his working environment, but you may or may not see them depending on how the session is wired. Confirm you can read the skill directory before starting the dispatch; if not, ask Jeremy to paste a list of skills + short descriptions.

When the dispatch ships, `custom-work.hbs` needs one more card added to the Demonstrations orbit's `.work-list` — small template edit, same deploy path as Task 1.

### 4. Other Demonstrations (unblocked, no fixed order)

jeremyfuksa.com Build, Jeremy OS, Moonbird origin dispatch. Let Jeremy direct. Each publishes the same way: Ghost post + template card add.

### 5. Home page update (unblocked, minor)

Once `/work/` is live, the home page teaser for Work may want updating to hint at the three-orbit structure rather than the old flat list. Small edit; handle when Jeremy raises it.

### 6. Navigation audit (unblocked, minor)

Check whether the top nav promotes `/work/` correctly in light of the new structure. Probably fine as-is.

### 7. Content Engine (deferred)

Don't start before May 15, 2026 per Jeremy's OmniFocus.

### 8. "Bullshit to Domain Foundation" Cocktail Napkin post (unblocked, low priority)

Sketched in an earlier memory — Jeremy's AI-era arc from image generation and Will-Smith-eating-spaghetti experiments up to Domain Foundation, structurally mirroring his "local car ads to national brands" agency-years arc. Not yet written. Surface if it fits a content slot.

---

## Session protocol

Jeremy uses OmniFocus fanatically. Use the `omnifocus-expert` skill any time you touch his task system. Proactively capture tasks during sessions without being asked — if he mentions something that needs doing, route it to OmniFocus.

At the end of substantive working sessions, ask: *"Before we close — anything from this session to capture in OmniFocus? New tasks, completed items to check off, or next steps?"*

His working style is direct, high-trust, low-ceremony. He delegates substantial autonomous work and expects comprehensive output without hand-holding. Reviews plans, identifies gaps, issues corrections clearly. Prefers **propose → execute → report** over Socratic dialogue once constraints are established.

---

## One closing note

The prior version of this handoff shipped with several load-bearing errors that the coding agent caught on first read: wrong template filename, SSH-based deploy path contradicting the repo's documented workflow, a false claim about Admin API theme scope, a hardcoded template that would have dropped useful Ghost conditionals, and a pasted production secret. This version corrects those. If you spot more of the same shape — confident claims about infrastructure that haven't been verified against the actual repo — flag them before acting.

---

_Verified: 2026-04-21. Facts about deploy paths, API scope, template filenames, and CSS placement were corrected in a review cycle against the repo. Re-verify against CLAUDE.md if you're reading this more than a few weeks out._
