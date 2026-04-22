# Pick-up note for 2026-04-22

State at end of 2026-04-21 working session.

## What's live on production right now

- **`/work/`** — three-orbit restructure, live at 1.8.1. Frameworks / Demonstrations / Case Studies. Demonstrations orbit currently has intro copy only, no cards.
- **`/work/domain-foundation/`** — rewritten live. Opens with the Christmas 2024 crystallization scene. Research-year content moved out into a separate dispatch that hasn't been published yet. **One known issue:** internal link to `/work/research-year/` in the current live page will 404 until the Research Year dispatch is published.
- **`/about/`**, `/now/`, `/` — unchanged this session.

## What's drafted and ready but not published

Four Ghost posts, all in `drafts/`:

1. `drafts/research-year-dispatch.md` — Title: "The Research Year". The pre-crystallization research at Oracle Health / Redwood. Anonymized at codename level only. ~1,050 words.
2. `drafts/skill-ecosystem-dispatch.md` — Title: "The Skill Ecosystem". 26 encoded skills as the methodology at one-practitioner scale. ~1,050 words.
3. `drafts/jeremyfuksa-build-dispatch.md` — Title: "jeremyfuksa.com, Rebuilt Against a Corpus". This site as applied demonstration. ~1,100 words.
4. `drafts/jeremy-os-dispatch.md` — Title: "Jeremy OS". Integrated personal infrastructure across OmniFocus, Obsidian, skills, n8n, Home Assistant. ~1,150 words.

## What still needs to happen to publish

### 1. Architectural decision (stopped here for your call)

The existing Work pieces (Terra, Seven Years, Redwood, Domain Foundation) are **Ghost Pages** with **per-page custom templates** (`custom-casestudy-*.hbs`) and **individual routes.yaml entries**. They're not Posts.

The four new dispatches are written as **blog posts**, not case studies. They don't need bespoke templates. Options:

- **Option A (recommended):** Publish all four as Ghost **Posts** under `/writing/<slug>/`. No `routes.yaml` change needed. Demonstrations orbit cards link to `/writing/<slug>/`. Treats them as what they are — dispatches, not case studies. Fast, low-risk.
- **Option B:** Publish all four as Ghost **Pages** at `/<slug>/` (bare URL, no `/work/` prefix). Matches case study URL shape but skips the `/work/` prefix. Requires no routes.yaml change.
- **Option C:** Publish all four as Ghost Pages AND add four routes.yaml entries for `/work/<slug>/`. Matches case study URL exactly. Requires uploading new routes.yaml via Ghost Admin → Labs → Routes — separate from theme zip.

My recommendation: **A**. The dispatches are blog posts in voice and form. `/writing/` is the right place.

### 2. Publish the posts

Once the architectural decision is made:

```bash
# Draft all four first (creates them but unpublished)
node dev/deploy-post.mjs --file drafts/research-year-dispatch.md --title "The Research Year" --slug research-year --status draft --push
node dev/deploy-post.mjs --file drafts/skill-ecosystem-dispatch.md --title "The Skill Ecosystem" --slug skill-ecosystem --status draft --push
node dev/deploy-post.mjs --file drafts/jeremyfuksa-build-dispatch.md --title "jeremyfuksa.com, Rebuilt Against a Corpus" --slug jeremyfuksa-rebuilt-against-a-corpus --status draft --push
node dev/deploy-post.mjs --file drafts/jeremy-os-dispatch.md --title "Jeremy OS" --slug jeremy-os --status draft --push
```

Dry-run each without `--push` first if you want previews. Each runs in ~2 seconds.

Then review each in Ghost Admin, hit Publish when satisfied.

### 3. Update `theme/custom-work.hbs` with four Demonstrations cards

After the posts are published and URLs are known, edit `theme/custom-work.hbs` and add four `<a class="work-row">` entries inside the Demonstrations orbit's `<div class="work-list">` (currently empty). Pattern matches the existing Case Studies orbit structure.

Suggested card order (matches the reading-in-sequence intent):

1. The Research Year — meta: "Dispatch · 2024" — points to research dispatch URL
2. The Skill Ecosystem — meta: "Dispatch · 2026" — points to skill dispatch URL
3. jeremyfuksa.com, Rebuilt Against a Corpus — meta: "Dispatch · 2026"
4. Jeremy OS — meta: "Dispatch · 2026"

### 4. Deploy theme

```bash
# Bump theme/package.json version to 1.8.2
# Commit
cd theme && rm -f ../the-cocktail-napkin.zip && zip -r ../the-cocktail-napkin.zip . -x "*.DS_Store" -x "*node_modules*"
cd ..
node dev/deploy-theme.mjs
```

### 5. Verify

- `/work/` — Demonstrations orbit now shows four cards
- Each card's target URL loads and renders
- Domain Foundation's `/work/research-year/` link now resolves (or update to the chosen URL scheme)

## What's in `drafts/` for archival / review

- `drafts/skill-ecosystem-audit.md` — full pre-publication audit of the 26 Jeremy-authored skills. Reference document. Not for publication. Useful if you want to see *why* specific refinements were made today.

## Skills refinements made today (all backed up in Obsidian vault)

Refinements applied directly to `~/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/.../skills/`:

- `cli-expert` / `unix-expert` — trigger descriptions sharpened to separate "build a CLI tool" from "administer a Unix system"
- `documentation-expert` / `doc-coauthoring` — clarified as stance vs. process skills with cross-references
- `jeremy-voice` — added `references/blog-deliverables.md`
- `obsidian-cli` — decomposed into core + `references/command-reference.md` + `references/patterns-and-gotchas.md`
- `moonbird-oracle` — added `references/vault-schema.md`; Exploration Agenda reframed as Historical
- `omnifocus-expert` — added `references/system-architecture.md`; Content Engine date handled gracefully
- `content-strategist` — Clarity Standards section tightened
- `figma-expert` — cross-link to `figma-make-prompt-engineer` strengthened
- **NEW:** `cocktail-napkin-theme` — encodes the Ghost theme build practice

Backups at:
- `~/Obsidian/🤖 Agents/Skills/backups/2026-04-21/` — pre-refinement (25 skills)
- `~/Obsidian/🤖 Agents/Skills/backups/2026-04-21-refined/` — post-refinement (26 skills including the new theme one)

**Restart Claude Desktop** to pick up the skill refinements in your working sessions.

## Git state

All commits pushed to `origin/main` as of end of session. Current HEAD: `7828c10` — "Draft four Demonstrations dispatches + rewrite Domain Foundation".

No uncommitted changes. Working tree clean.

## Deploy scripts ready to use

- `dev/deploy-theme.mjs` — full theme zip upload + activate. ~4 seconds.
- `dev/deploy-page.mjs --slug <slug> --file <markdown> [--push]` — update existing Ghost page body.
- `dev/deploy-post.mjs --file <markdown> --title "..." [--slug <slug>] [--tags a,b] [--excerpt "..."] [--status draft|published] [--push]` — create new Ghost post from markdown.

All three dry-run by default (omit `--push`). All three parse the `GHOST_API` key from `.env`.

## If anything breaks

- Roll back a git commit: `git revert <sha>` (don't hard-reset — that's destructive)
- Roll back a page-content deploy: re-run `deploy-page.mjs` with the previous-version markdown
- Roll back a theme deploy: use Ghost Admin → Settings → Design → click the prior 1.8.x version and activate, or re-zip and redeploy an earlier git state

## One thing I want to flag

The live Domain Foundation page currently links to `/work/research-year/` which 404s until the Research Year dispatch is published. If you're not planning to publish tomorrow, consider either:

1. Publishing the Research Year dispatch first so the link resolves (architectural decision above determines the exact URL)
2. Temporarily updating Domain Foundation via `deploy-page.mjs` to remove the link until you're ready

Low urgency — it's one internal link, reads as plain text if the URL doesn't resolve. But worth knowing about.

---

Everything else is ready. You should be able to read the drafts, decide the URL architecture, publish the four posts, add cards to `custom-work.hbs`, bump theme version, deploy, verify. Probably a 30-minute session.
