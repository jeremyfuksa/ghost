# The Cocktail Napkin

A custom Ghost 6 Handlebars theme for [jeremyfuksa.com](https://jeremyfuksa.com).

No build step. CSS and JS are served as-is. The theme is uploaded to Ghost Admin as a zip.

## Stack

- **Ghost** 6+ (Handlebars templates, `routes.yaml`)
- **CSS** — plain CSS with custom properties; no preprocessor
- **JS** — vanilla, minimal (TOC scroll-spy only)
- **Fonts** — Fraunces (headings), Fira Code (mono), system UI stack (body)

## Repo layout

```
theme/               The Ghost theme (this is what gets zipped and uploaded)
  assets/css/        tokens.css, base.css, components.css, screen.css
  partials/
  *.hbs              Templates (default, index, post, page, tag, custom-*)
  routes.yaml        Custom routing (uploaded separately in Ghost Admin)
dev/setup.sh         Idempotent bootstrap for the local Docker Ghost
docker-compose.yml   Local Ghost 5 Alpine + SQLite with theme bind-mount
CLAUDE.md            Detailed guidance for Claude Code agents
```

## Quick start (local development)

```bash
# Boot a local Ghost with the theme bind-mounted
docker compose up -d

# First run only — creates owner, activates theme, uploads routes, seeds content
bash dev/setup.sh
```

- Site: <http://localhost:2368>
- Admin: <http://localhost:2368/ghost/> — `dev@local.test` / `DevLocal12345!`

Edits to `theme/*.hbs` and `theme/assets/css/*` live-reload within a second or two.

Stop with `docker compose down` (data persists). Full reset: `docker compose down -v && rm -rf ghost-data/`.

## Packaging and deploy

```bash
cd theme && zip -r ../the-cocktail-napkin.zip . -x "*.DS_Store" -x "*node_modules*"
```

1. Upload `the-cocktail-napkin.zip` in Ghost Admin → Design → Themes.
2. If `theme/routes.yaml` changed, upload it separately under Settings → Labs → Routes.

## Design system

All spacing, type, color, border, and sizing values come from CSS custom properties in `theme/assets/css/tokens.css`. Hardcoded pixels in CSS or inline styles are off-limits; see `CLAUDE.md` for the full list of intentional exceptions (root font size, relative units, keyframes, media queries).

Two accent color roles — do not conflate them:

- `--color-accent-ui` — decorative only (borders, underlines, large uppercase).
- `--color-accent-text` — any readable orange/amber text. Passes 4.5:1.

Dark mode is system-preference only (`prefers-color-scheme`). No toggle.

## Validating

```bash
cd theme && npx gscan .
```

0 errors is the bar. A single warning about custom fonts is expected.

## CI and auto-merge

`.github/workflows/ci.yml` runs `gscan` against `theme/` on every PR and on pushes to `main`. The `--fatal` flag makes it exit non-zero on errors so the check actually blocks bad merges.

To enable auto-merge end-to-end, configure this once in the GitHub UI:

1. **Settings → General → Pull Requests**
   - Enable **Allow auto-merge**.
   - Enable **Automatically delete head branches**.
   - Pick one merge style (squash recommended) and disable the others.
2. **Settings → Branches → Branch protection rules → Add rule** for `main`:
   - **Require a pull request before merging**.
   - **Require status checks to pass before merging** → add `gscan` as required. Also tick **Require branches to be up to date before merging**.
   - Leave "Require approvals" off for a solo repo (it would block auto-merge with no second reviewer).
   - Tick **Do not allow bypassing the above settings** to keep the rule honest.

With that in place, enable auto-merge on an individual PR via the GitHub UI button, `gh pr merge --auto --squash <n>`, or the `mcp__github__enable_pr_auto_merge` tool. GitHub will merge it the moment `gscan` goes green.

## More

- `CLAUDE.md` — exhaustive architecture notes and conventions for agent-driven work.
- `.claude/commands/` — custom slash commands (`/swap-font`).
- `docs/superpowers/` — design specs and implementation plans.
