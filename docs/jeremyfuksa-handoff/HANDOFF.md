# Project Handoff — jeremyfuksa.com `/work/` Rebuild

_Transferring from a Claude web conversation to Claude Code. Read this top-to-bottom before touching anything._

---

## What this project is

Rebuilding the `/work/` section of jeremyfuksa.com from a flat three-item portfolio into a **three-orbit body-of-IP architecture** that supports Jeremy's Director/Principal UX positioning during an active job search + independent consulting ramp-up.

**The positioning thesis (unstated on the site, but load-bearing for every decision):** at Jeremy's altitude, hiring managers grade portfolios on methodological rigor, not visual polish. Explicit framework articulation is the gap most senior portfolios miss. The rebuild treats the methodology as the primary IP and everything else as supporting evidence. Inspired by the Nate's Newsletter piece ["Your AI credentials don't matter. Your artifacts do."](https://natesnewsletter.substack.com/p/your-ai-credentials-dont-matter-your) — same observation, portfolio-scoped.

**The site:** Ghost 6 self-hosted on DigitalOcean (Ubuntu + Docker + Traefik v3 + MySQL 8). Custom theme based on Campfire Design System.

---

## The three-orbit architecture

### Frameworks — the primary IP
Seven named, portable methodological pieces, each its own page using a "Field Guide" template. They are the differentiator. Domain Foundation is the hub that points at them. Four known (Validation Stack, Role Inversion Model, Four-Layer Knowledge Architecture, Velocity Paradox); three more named in `moonbird_repackaging_plan.md` but not yet in this handoff context — Jeremy will need to provide them or reference the file.

### Demonstrations — the proof layer
Artifact-level exhibits showing the frameworks running in practice. Starting set:
- **Skill Ecosystem** — the corpus of encoded skills (jeremy-voice, campfire-css, omnifocus-expert, jeremys-workshop, moonbird-oracle, etc.) as a single exhibit proving Domain Foundation runs end-to-end on one practitioner.
- **jeremyfuksa.com Build** — the site itself as an applied case: Campfire tokens, voice calibration encoded in skills, analog-signal-in-chrome-only constraint, Claude Code theme prompts as executable artifacts.
- **Jeremy OS** — the integrated personal infrastructure (OmniFocus conventions, skill ecosystem, signal/noise dashboard, content engine, Ghost stack). Previously called "Signal/Noise Dashboard" but renamed — OS framing does load-bearing work the dashboard name couldn't.
- **Moonbird origin dispatch** — the Oracle-era research project, scrubbed per the repackaging checklist, as the origin case for Domain Foundation.

### Case Studies — traditional portfolio artifacts
Already live on the site. Three exist: Terra Design System, Seven Years in Healthcare UX, "Two Components That Didn't Ship" (at `/work/redwood-health-design/`). These stay roughly as-is; template kept. Jeremy may want one or more password-gated later, but not required.

---

## Voice & design conventions

- **All prose under Jeremy's byline uses the `jeremy-voice` skill.** It's installed in his local skill library. Do not write anything in his voice without consulting that skill first. Core rule: reporting, not thesizing. Underdraft.
- **All frontend work uses the `campfire-css` skill.** Use only existing Campfire design tokens; never invent new variables. Dark mode only via `prefers-color-scheme`, ember/amber palette, Fira Sans + Noto Serif, 8px grid, WCAG 2.1 AA with dual-role accent tokens (`--color-accent-ui` for decorative/large, `--color-accent-text` for body-size).
- **Relevant skills also on Jeremy's machine:** `moonbird-oracle` (for framework writing), `jeremys-workshop` (for image/thumbnail prompts), `obsidian-pkm` (for vault integration), `omnifocus-expert` (for task capture).

---

## Critical constraints Claude Code should know

1. **The `/work/` page body is empty in Ghost.** The visible rendering comes from a hardcoded custom theme template (`page-work.hbs`). Pushing page body content via the Ghost Admin API does nothing to the rendered output. All `/work/` changes are **theme-file work**, not content work. Edit `page-work.hbs` directly in `/var/lib/ghost/content/themes/<active-theme>/` on the DigitalOcean droplet.

2. **Ghost Admin API integration tokens do not have theme-management scope.** The `/themes/` endpoint returns 403. Theme uploads via API are blocked. Only path forward for theme changes is SSH + file edit. (The `ghost-mcp` integration only exposes posts endpoints, not pages or themes.)
   > **2026-04-21 correction:** this turned out to be wrong. The `GHOST_API` key in `.env` has full theme scope. `dev/deploy-theme.mjs` uploads and activates theme zips via `POST /ghost/api/admin/themes/upload/` + `PUT /ghost/api/admin/themes/<name>/activate/`. No SSH needed.

3. **Individual Ghost `/work/<slug>/` pages ARE editable via the Admin API** (body, title, excerpt, code injection). The Admin API key is in `.env` as `GHOST_API=<id>:<secret>` — format matches Ghost's `{id}:{secretHex}` integration token scheme. (Originally redacted from this handoff before commit.)

4. **Contact email is `hello@jeremyfuksa.com`** (Jeremy updated this recently from `jeremy@jeremyfuksa.com`).

5. **Memory patterns to preserve** — Jeremy uses OmniFocus as his primary task system; proactively capture new tasks. End substantive work sessions with an OmniFocus capture prompt. Use the `omnifocus-expert` skill for any task management interaction.

---

## What's already done in this session

- **About page rewritten, published, and edited.** Live at `https://jeremyfuksa.com/about/`. Jeremy made significant manual edits post-publish (title changed to "About Jeremy," company names genericized, several voice tightenings). Those edits are authoritative; don't revert them.
- **About excerpt behavior fixed.** `custom_excerpt` is preserved for SEO, RSS, Open Graph, and JSON-LD; visible rendering is suppressed via per-page `codeinjection_head` CSS (`<style>.static-page-excerpt{display:none;}</style>`). The `meta_description` field is also set to a short version for Google snippets.
- **`/work/` rebuild staged (not yet deployed).** Files waiting in the handoff bundle:
  - `page-work.hbs` — drop-in replacement for the theme template
  - `work-orbit.css` — new CSS rules to append to `components.css` in the theme
  - `work-page-preview.html` — self-contained preview, opens in any browser, pixel-accurate to post-deploy rendering
  - `README-deployment.md` — SSH deploy steps and rollback protocol
  - `work-page-content.md` — archival markdown of the copy

---

## Next tasks, in priority order

### 1. Deploy the `/work/` rebuild (immediate)
SSH to the droplet, back up the current `page-work.hbs`, drop in the new one, append `work-orbit.css` to the theme's `components.css` source, restart Ghost. See `README-deployment.md` for the full protocol. Estimated 15 minutes. Post-deploy verification checklist is in the README.

### 2. Pull the framework list from `moonbird_repackaging_plan.md`
Before drafting framework pages, Claude Code needs the full seven-framework inventory with one-line problem statements for each. Known: Validation Stack, Role Inversion Model, Four-Layer Knowledge Architecture, Velocity Paradox. Unknown (to this handoff): the other three. Either read `moonbird_repackaging_plan.md` from wherever it lives on Jeremy's machine, or ask him for the section.

### 3. Define the Field Guide template
One-framework pilot to prove the template before building all seven. Suggested pilot: **Four-Layer Knowledge Architecture** — it's the most concrete, already referenced in the existing Domain Foundation page, and has a natural diagram. Template structure (from architecture plan):
- Problem statement (1 paragraph — what the market can't see)
- Structural observation
- The named artifact (diagram or structural figure)
- Implementation notes (1–2 paragraphs on where this runs in practice)
- Cross-links to demonstrations that use this framework
- Related frameworks footer

Each framework page is its own Ghost page under `/work/frameworks/<slug>/` — which means Claude Code needs to either create new Ghost pages (Admin API supports this for posts, need to verify for pages) OR add more hardcoded rows to `page-work.hbs` pointing to routes that don't yet have backing pages. Decide based on how the theme handles missing pages — probably create real pages to avoid 404s.

### 4. Demonstrations — start with Skill Ecosystem
The highest-weight demonstration. Write it up as a single exhibit showing the encoded-expertise layer of Domain Foundation running on Jeremy's own practice. Claude Code has direct access to the skill files (probably at `~/.claude/skills/`), so it can reference them concretely.

### 5. Home page three-orbit teaser
Once `/work/` is rebuilt and frameworks exist, update the home page to signal the three-orbit structure — lead with one exhibit from each orbit. Home is currently a Ghost page that likely uses a template similar to `/work/`; same theme-edit path.

### 6. Nav update
Promote "Frameworks" to a top-level nav item (desktop), or keep single "Work" link with a restructured index (mobile fallback). Theme navigation is likely in a partial (`partials/navigation.hbs` or similar).

### 7. Content Engine (deferred until May 15, 2026)
Not this sprint. Jeremy has it locked behind that defer date in OmniFocus.

### 8. Writing: "Bullshit to Domain Foundation" arc piece
Memory #13 captures the seed: the AI-era career-within-a-career arc (image generation dicking around → worked through the landscape → Domain Foundation), structurally identical to the cars-to-national-brands agency-years arc. When Jeremy's ready, this is a natural Cocktail Napkin post. Not blocking anything else.

---

## Deploy protocol (general)

For theme file changes:
1. SSH to DigitalOcean droplet.
2. Navigate to `/var/lib/ghost/content/themes/<active-theme>/` (exact path depends on Docker volume mount — check `docker-compose.yml`).
3. Back up the file you're changing with `.bak.$(date +%Y%m%d)` suffix.
4. Replace or append as needed.
5. Restart Ghost: `docker compose restart ghost` (or `ghost restart` if using ghost-cli outside Docker).
6. Hard-refresh the affected page(s) in a browser to verify.
7. If anything's wrong, restore the `.bak` file and restart again.

For Ghost page content changes (individual `/work/<slug>/` pages, posts, etc.):
- Ghost Admin API with JWT auth works. Code example is in the web conversation transcript; the pattern is: GET page to retrieve current `updated_at`, then PUT to `/pages/<id>/?source=html` with an HTML body.
- DNS cache can flake — retry logic is worth building in (3–5 attempts with 2–3s backoff).

---

## Files in this handoff

- `HANDOFF.md` — this document
- `INITIAL_PROMPT.md` — paste this as your first message to Claude Code
- `about-page-rewrite.md` — final About markdown (already shipped; archival)
- `page-work.hbs` — new Work template (not yet deployed)
- `work-orbit.css` — CSS rules to append (not yet deployed)
- `README-deployment.md` — deploy steps
- `work-page-content.md` — archival markdown of Work copy
- `work-page-preview.html` — visual preview (open in browser)

---

## One last thing

Jeremy's working style: direct, high-trust, low-ceremony. Claude Code should propose → act → report back, not Socratic-dialogue every decision. When uncertainty exists, flag confidence level ("60% confident because X, uncertain about Y") rather than feigning certainty. End responses declaratively, not with "Would you like me to...". Capture new tasks in OmniFocus proactively via the `omnifocus-expert` skill.
