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
static/              Standalone HTML pages used for design iteration
theme/               The Ghost theme (this is what gets zipped and uploaded)
  assets/css/        tokens.css, base.css, components.css, screen.css
  partials/
  *.hbs              Templates (default, index, post, page, tag, custom-*)
  routes.yaml        Custom routing (uploaded separately in Ghost Admin)
dev/setup.sh         Idempotent bootstrap for the local Docker Ghost
docker-compose.yml   Local Ghost 5 Alpine + SQLite with theme bind-mount
preview.html         Index of all static design pages
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

## Design-first workflow

Design happens in `static/*.html` first — they share the same CSS as the HBS templates.

1. Iterate on HTML + CSS in `static/` by opening the file directly in a browser.
2. CSS changes go into `theme/assets/css/` and apply to both static and Ghost automatically.
3. When HTML structure changes, port it to the corresponding `.hbs` template.

CSS-only changes need no sync step. Each static file has a header comment pointing to its HBS counterpart.

| Static page | HBS template |
| --- | --- |
| `static/home.html` | `theme/custom-home.hbs` |
| `static/writing.html` | `theme/index.hbs` |
| `static/post.html` | `theme/post.hbs` |
| `static/page.html` | `theme/page.hbs` |
| `static/tag.html` | `theme/tag.hbs` |
| `static/now.html` | `theme/custom-now.hbs` |
| `static/error.html` | `theme/error.hbs` |

## Packaging and deploy

```bash
# Build the theme zip (static/ is NOT included)
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

## More

- `CLAUDE.md` — exhaustive architecture notes and conventions for agent-driven work.
- `.claude/commands/` — custom slash commands (`/swap-font`, `/preview-sync`).
- `docs/superpowers/` — design specs and implementation plans.
