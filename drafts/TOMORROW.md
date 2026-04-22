# Pick-up note — updated 2026-04-22 after audit pass

All four dispatches have been audited, fact-checked, voice-checked, and edited. See `drafts/dispatch-audit.md` for the full audit that drove the edits.

Major reclassification from the audit: **Jeremy OS is now a blog post, not a Demonstrations dispatch.** Reasons in the audit. The file was renamed from `jeremy-os-dispatch.md` to `jeremy-os-post.md` to reflect this.

## What's live on production right now

- `/work/` — three-orbit restructure, live at theme 1.8.1. Frameworks / Demonstrations / Case Studies. Demonstrations orbit currently has intro copy only, no cards.
- `/work/domain-foundation/` — rewritten live yesterday. Opens with the Christmas 2024 crystallization scene. **Known issue:** it contains a link to `/work/research-year/` that will 404 until the Research Year dispatch is published.
- `/about/`, `/now/`, `/` — unchanged.

## What's drafted and ready for publication

Three Demonstrations dispatches (portfolio):

1. `drafts/research-year-dispatch.md` — Title: "The Research Year". Research at Oracle Health / Redwood through 2024, leading to but not equal to Domain Foundation.
2. `drafts/skill-ecosystem-dispatch.md` — Title: "The Skill Ecosystem". 26 encoded skills as Domain Foundation running at one-practitioner scale.
3. `drafts/jeremyfuksa-build-dispatch.md` — Title: "jeremyfuksa.com, Rebuilt Against a Corpus". This site as applied demonstration. Restructured in the audit pass to open with design-taste rather than deploy-script details.

One Cocktail Napkin blog post:

4. `drafts/jeremy-os-post.md` — Title: "Jeremy OS". Personal-infrastructure reflection, reclassified from dispatch to blog post during the audit.

## Publication plan (revised)

### 1. URL architecture — decided

**All four become Ghost Posts under `/writing/<slug>/`.** No routes.yaml change needed. The three dispatches get Demonstrations orbit cards pointing to their `/writing/` URLs. Jeremy OS doesn't need a card (it's a blog post, not a dispatch).

Rationale: the pieces are all blog-post in voice. Hosting them under `/writing/` preserves the existing case-study pattern (Ghost Pages with custom templates at `/work/<slug>/`) for actual case studies, and positions dispatches as the blog-post form they actually are. Case studies live at `/work/`; dispatches and posts live at `/writing/`.

### 2. Publish commands

```bash
# Dry-run each first (omit --push) to preview HTML
node dev/deploy-post.mjs --file drafts/research-year-dispatch.md --title "The Research Year" --slug research-year --status draft --push
node dev/deploy-post.mjs --file drafts/skill-ecosystem-dispatch.md --title "The Skill Ecosystem" --slug skill-ecosystem --status draft --push
node dev/deploy-post.mjs --file drafts/jeremyfuksa-build-dispatch.md --title "jeremyfuksa.com, Rebuilt Against a Corpus" --slug jeremyfuksa-rebuilt-against-a-corpus --status draft --push
node dev/deploy-post.mjs --file drafts/jeremy-os-post.md --title "Jeremy OS" --slug jeremy-os --status draft --push
```

Each creates as a draft. Review in Ghost Admin, hit Publish when ready.

### 3. Demonstrations orbit cards (three, not four)

After publishing the three dispatches, edit `theme/custom-work.hbs` and add three `<a class="work-row">` entries inside the Demonstrations orbit's `<div class="work-list">`. Pattern matches existing Case Studies orbit.

**Reading order (per audit recommendation):**

1. The Skill Ecosystem — meta: "Dispatch · 2026"
2. The Research Year — meta: "Dispatch · 2024"
3. jeremyfuksa.com, Rebuilt Against a Corpus — meta: "Dispatch · 2026"

URLs all point to `/writing/<slug>/`.

Jeremy OS does NOT get an orbit card. It's a standalone blog post surfaced through the blog index.

### 4. Deploy theme

```bash
# Bump theme/package.json to 1.8.2
# Commit
cd theme && rm -f ../the-cocktail-napkin.zip && zip -r ../the-cocktail-napkin.zip . -x "*.DS_Store" -x "*node_modules*"
cd ..
node dev/deploy-theme.mjs
```

### 5. Verify

- `/work/` — Demonstrations orbit now shows three cards
- Each card's target URL loads and renders
- `/work/domain-foundation/`'s link to `/work/research-year/` — **will still 404.** The link expects `/work/research-year/` but the post is at `/writing/research-year/`. Update the Domain Foundation page via `dev/deploy-page.mjs` to fix the link, or accept the 404 until the orbit-card-URLs architecture settles.

## Audit-level findings worth reviewing

All four pieces were edited based on `drafts/dispatch-audit.md`. Headline fixes applied:

- **Research Year** — Figma Make chronology fixed (couldn't actually use it until November 2024 due to Oracle legal review; relevant Make Kits not until October 2025). One sentence added about the research continuing without you.
- **Skill Ecosystem** — Oracle/Domain Foundation conflation fixed in two paragraphs. "Clinical safety researchers and regulatory experts" corrected to "human factors researchers, and a PhD on staff whose job included tracking healthcare regulatory and safety practice."
- **jeremyfuksa.com Build** — Structural restructure. Opens with "analog signal in a chrome frame" design-taste paragraph; deploy-script and handoff-was-wrong story moved to after the corpus description; compounding-curve claim softened from measured times to honest vibes.
- **Jeremy OS** — Project-count claim corrected. Five "X lives in Y" paragraphs varied for rhythm. Added link to Domain Foundation for lineage. Reclassified to blog post.

## Three gaps the audit flagged for the set

1. The four pieces answer "what does the methodology look like running on me" but none answers "what does an employer or client get from hiring this thinking." That conversion-oriented piece doesn't exist. Not writing it now; flagging for later.
2. Photography and printmaking skills don't exist. Called out honestly in two of the dispatches as gaps.
3. The Domain Foundation case study's `/work/research-year/` link currently 404s. Fix either by publishing Research Year at that URL, or by updating the Domain Foundation body to point to `/writing/research-year/`.

## What's in `drafts/` for archival

- `drafts/dispatch-audit.md` — full audit of pieces 1–4. Reference document; not for publication.
- `drafts/skill-ecosystem-audit.md` — pre-refinement audit of the 25-skill corpus from 2026-04-21.

## Skills refinements made 2026-04-21 (backed up in Obsidian vault)

See prior TOMORROW.md versions in git history. All backed up at:
- `~/Obsidian/🤖 Agents/Skills/backups/2026-04-21/` — pre-refinement
- `~/Obsidian/🤖 Agents/Skills/backups/2026-04-21-refined/` — post-refinement

**Restart Claude Desktop** to pick up the skill refinements in your working sessions.

## Deploy scripts

- `dev/deploy-theme.mjs` — full theme zip upload + activate
- `dev/deploy-page.mjs --slug <slug> --file <markdown> [--push]` — update existing Ghost page body
- `dev/deploy-post.mjs --file <markdown> --title "..." [--slug <slug>] [--tags a,b] [--excerpt "..."] [--status draft|published] [--push]` — create new Ghost post

All three dry-run by default. All three parse `GHOST_API` from `.env`.

## What I'm still waiting on from you

- **Pieces 5–9 audit decision.** Per your direction: quickly evaluate the existing `/work/` case studies (Terra, Seven Years, Redwood), plus `/about/`, to see if they need work before publishing the dispatches alongside them. I haven't done that pass yet. Probably an hour of work.
- **Home page surfacing of Work.** You noted this explicitly; it's queued as a separate task.
