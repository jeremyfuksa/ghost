# Astro migration — vestigial cleanup inventory

**Date:** 2026-04-25
**Branch:** `feat/astro-headless-migration`
**Scope:** What's vestigial, when each item can be removed, what stays.

> **Status: completed 2026-04-28.** Both halves are done. The `theme/` directory was deleted (not archived — git history is the archive). `dev/deploy-theme.mjs` and `dev/deploy-page.mjs` were deleted. `dev/deploy-post.mjs` was kept (Jeremy: not sure, default per spec is keep). `dev/setup.sh` was slimmed to owner-account creation only. CLAUDE.md and README.md rewritten Astro-only. `*.zip` rule removed from `.gitignore`. CI swapped from gscan → Astro check. The remainder of this doc is preserved as-is for historical context.

This doc has two halves:
- **Half A** — pre-cutover safe actions (some apply to the worktree, some only to `main`)
- **Half B** — post-cutover punch list (executed in a separate plan once Astro is in production)

---

## Inventory

### Top-level repo paths

| Path | Status | Notes |
|------|--------|-------|
| `theme/` | **ARCHIVE at cutover** | The Handlebars theme. Stays until Ghost stops driving the public site. Move to `archive/the-cocktail-napkin-handlebars-theme/` post-cutover. |
| `site/` | **KEEP** | The new Astro site. End-state primary. |
| `dev/setup.sh` | **KEEP, slim post-cutover** | Still drives local Ghost. After cutover, drop the theme-activation step (Ghost can run default Casper). |
| `dev/deploy-theme.mjs` | **ARCHIVE at cutover** | Handlebars-theme upload script. Useless once theme is archived. |
| `dev/deploy-page.mjs` | **DELETE post-cutover** | Pushes content to Ghost Pages — Pages are no longer in the architecture. |
| `dev/deploy-post.mjs` | **DECIDE with Jeremy** | Pushes posts to Ghost Admin from local markdown. Useful if drafts in `drafts/` keep getting authored locally; redundant if all editing happens in Ghost Admin. Keep by default. |
| `docker-compose.yml` | **KEEP** | Still needed for local Ghost (now headless). |
| `ghost-data/` (gitignored) | **KEEP** | Ghost's local DB volume. |
| `the-cocktail-napkin.zip` | **DELETE pre-cutover** (root only, gitignored) | Stale build artifact. Already gitignored via `*.zip` rule. Action below. |
| `node_modules/` (root, gitignored) | **KEEP** | Used by `dev/*.mjs` scripts and `sync-campfire`. |
| `package.json` (root) | **MODIFY post-cutover** | `sync-campfire` script becomes vestigial when theme is archived. `marked` dep ditto if no script still uses it. |
| `package-lock.json` (root) | **KEEP** | Pairs with root `package.json`. |
| `drafts/` | **KEEP** | Source markdown for case studies (now ported to `site/src/content/case-studies/`) and for posts. The five case-study `.md` files are technically duplicated in MDX form, but the drafts have additional context (SEO description, thumbnail prompts) worth preserving. |
| `docs/` | **KEEP** | Plans and specs. |
| `.playwright-mcp/` (gitignored) | **DELETE pre-cutover** (root only) | Stale per gitignore semantics. Action below. |
| `.worktrees/` (gitignored) | **KEEP** | Worktrees state. |
| `.superpowers/` (gitignored) | **KEEP** | Skill state. |
| `README.md` | **MODIFY** | Updated in Task 13 to describe dual architecture. Will need another update post-cutover to drop the dual-system explanation. |
| `CLAUDE.md` | **MODIFY** | Updated in Task 13. Will need post-cutover slim. |
| `.env` (gitignored) | **KEEP** | Ghost Admin API key for `dev/deploy-*.mjs` scripts. |
| `.mcp.json` | **KEEP** | MCP server config. |

### Inside `theme/` (all ARCHIVE at cutover; nothing deletes pre-cutover)

| Path | End state |
|------|-----------|
| `theme/*.hbs` (16 templates) | Archive |
| `theme/partials/*.hbs` (10 partials) | Archive |
| `theme/assets/css/*.css` | Already copied verbatim into `site/src/styles/`. Source of truth becomes Astro post-cutover. **Note:** `campfire.css` in the worktree's `site/src/styles/` has a missing-`}` fix that needs backporting to `theme/assets/css/campfire.css` on `main` while the theme still ships. |
| `theme/assets/js/main.js` | Already copied verbatim into `site/public/scripts/`. Source of truth becomes Astro. |
| `theme/assets/images/` | Already copied into `site/public/images/`. |
| `theme/routes.yaml` | Archive (no equivalent in Astro). |
| `theme/package.json` | Archive (Ghost theme manifest, not a Node project). |

---

## Half A — Pre-cutover actions

### Already done (in the worktree)

- ✅ Inventory documented (this file).
- ✅ All non-post pages migrated to Astro under `site/`.

### Apply to `main` (NOT the worktree)

The following items only exist in the main checkout at `/Users/jeremyfuksa/Dev/ghost/`, not in this worktree (which is a fresh checkout). Run these from `main` after merging:

```bash
# 1. Stale build artifact (already gitignored via *.zip)
rm -f /Users/jeremyfuksa/Dev/ghost/the-cocktail-napkin.zip

# 2. Stale Playwright MCP working tree (already gitignored)
rm -rf /Users/jeremyfuksa/Dev/ghost/.playwright-mcp

# 3. Backport the load-bearing campfire.css fix to the still-shipping theme:
#    add the missing `}` after line 733 of theme/assets/css/campfire.css.
#    The fix is already in this worktree's site/src/styles/campfire.css.
echo "}" >> /Users/jeremyfuksa/Dev/ghost/theme/assets/css/campfire.css
# (then verify with: tail -5 theme/assets/css/campfire.css)
# (and run: cd /Users/jeremyfuksa/Dev/ghost/theme && npx gscan . to confirm)
```

These are documented separately because they don't belong in the migration branch — they're routine cleanup of `main`-only state.

---

## Half B — Post-cutover punch list

**Do NOT execute until:** Astro is deployed to production, DNS is cut over, monitoring is clean for 48 hours, and Jeremy confirms.

These items go into a separate plan referenced from `2026-04-25-astro-cutover-prep.md` (Task 15 deliverable).

```
1. Move theme/ → archive/the-cocktail-napkin-handlebars-theme/
2. Delete dev/deploy-theme.mjs (or move to archive/)
3. Delete dev/deploy-page.mjs (Ghost Pages no longer in architecture)
4. Confirm with Jeremy: keep or delete dev/deploy-post.mjs
5. Remove root package.json sync-campfire script (theme no longer consumes campfire.css)
6. Remove root package.json `marked` dep if no script still uses it (grep for `import.*marked`)
7. Update .gitignore: remove `*.zip` rule if no zips are produced anymore
8. Update CLAUDE.md: remove the "## Local Ghost Development with Docker" section's
   theme-deployment instructions; rewrite as "Astro frontend dev" + "Ghost backend dev"
9. Update README.md: drop the dual-system explanation, single Astro architecture
10. Slim dev/setup.sh: remove theme upload, keep only owner account + content seed
11. Decide whether docker-compose.yml stays (yes, if Ghost-as-CMS is local-first) or
    moves to a managed Ghost host
```

Each item should get explicit verification: grep for callers, confirm with Jeremy, run tests.

---

## Open questions (decide at cutover prep)

- Does `dev/deploy-post.mjs` survive? Depends on whether posts continue to be drafted in `drafts/` and pushed to Ghost via script, or whether all post drafting moves into Ghost Admin directly.
- Does Ghost stay self-hosted via Docker, or move to Ghost(Pro) / a managed instance? Affects `docker-compose.yml` and `dev/setup.sh`.
- Do the contents of `drafts/` get committed to the Astro site as MDX content over time, or stay as draft sources for posts that go through Ghost?
