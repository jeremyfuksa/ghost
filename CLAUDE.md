# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Custom Ghost 6 Handlebars theme called "The Cocktail Napkin" for jeremyfuksa.com. No build step — CSS and JS are served directly. The theme is uploaded as a zip to Ghost Admin.

## Development Workflow: Static-First

Design changes start in `static/*.html` files, not in Ghost templates. CSS is shared — both static pages and HBS templates load the same CSS files.

```
static/              ← design here (standalone HTML pages)
  home.html          → theme/custom-home.hbs
  post.html          → theme/post.hbs
  writing.html       → theme/index.hbs
  now.html           → theme/custom-now.hbs
  tag.html           → theme/tag.hbs
  page.html          → theme/page.hbs
  error.html         → theme/error.hbs
theme/assets/css/    ← single source of truth for styles
```

**The flow:**
1. Open `static/*.html` in browser via `file://` — iterate on HTML structure and CSS
2. CSS changes go directly into `theme/assets/css/` — shared by both static and HBS
3. When HTML structure changes, port to the corresponding `.hbs` template
4. Each static file has a comment header documenting its HBS counterpart and last sync date

**CSS-only changes need no sync step.** Only structural HTML changes require porting to HBS.

## Key Commands

```bash
# Open static pages index
open preview.html

# Open a specific page
open static/home.html

# Package theme for upload (static/ is NOT included)
cd theme && zip -r ../the-cocktail-napkin.zip . -x "*.DS_Store" -x "*node_modules*"

# Deploy routes (separate from theme zip)
# Upload theme/routes.yaml via Ghost Admin > Settings > Labs > Routes
```

## Local Ghost Development with Docker

For rapid iteration, use a local Ghost instance instead of the manual zip → upload workflow:

```bash
# Start Ghost container (first time: builds volumes and seeds content)
docker compose up -d

# Run setup script on first launch (idempotent, safe to re-run)
bash dev/setup.sh

# Output: Site runs at http://localhost:2368, admin at http://localhost:2368/ghost/
# Credentials: dev@local.test / DevLocal12345!
```

**How it works:**
- `docker-compose.yml` — Ghost 5 Alpine container with SQLite, NODE_ENV=development (file watching enabled)
- `./theme` bind-mounts to Ghost's theme directory → live reloading on file changes
- `dev/setup.sh` — idempotent setup: creates owner account, activates theme, uploads routes.yaml, seeds test content
- Data persists in `ghost-data/` volume across container restarts

**Development loop:**
1. Edit `theme/*.hbs` or `theme/assets/css/*` → refresh browser (changes live within 1-2s)
2. Test all pages locally: `/`, `/writing/`, `/work/`, `/about/`, `/now/`, `/writing/{post}/`, `/tag/{tag}/`
3. Run `npx gscan theme` in `theme/` to validate compatibility (0 errors, 1 warning for custom fonts is normal)

**When done:**
```bash
# Stop (data persists)
docker compose down

# Full reset (if needed)
docker compose down -v && rm -rf ghost-data/
```

**Deploying to production:**
1. Package theme: `cd theme && zip -r ../the-cocktail-napkin.zip . -x "*.DS_Store" -x "*node_modules*"`
2. Upload to your Ghost Admin at beta.jeremyfuksa.com (Themes)
3. Upload routes.yaml via Settings > Labs > Routes (if it changed)

## Architecture

### Routing (`theme/routes.yaml`)
- `/` renders `custom-home.hbs` with data from a Ghost page titled "Home"
- `/writing/` is a post collection using `index.hbs`
- `/tag/{slug}/` uses `tag.hbs` for tag archives
- Posts live at `/writing/{slug}/`

### CSS Structure (no preprocessor, no build)
- `tokens.css` — design tokens only (CSS custom properties, no selectors)
- `base.css` — reset, heading/body defaults, animations
- `components.css` — all component styles
- `screen.css` — entry point that `@import`s the above three (used by Ghost)

Static pages load the three CSS files directly via `<link>` tags (bypassing `screen.css`) because `@import` fails over `file://`.

### Token System

All design values must use CSS custom properties from `tokens.css`. No hardcoded pixel values in CSS or inline styles in HTML/HBS.

**Token categories:** spacing (`--space-*`), typography (`--text-*`, `--leading-*`, `--weight-*`), tracking (`--tracking-*`), borders (`--border-hairline`, `--border-thin`, `--border-blockquote`), sizing (`--size-*`), layout (`--sidebar-*`, `--content-max`, `--prose-max`), colors, radius, transitions.

**Exceptions (intentionally not tokenized):**
- `font-size: 16px` on `html` (root font size)
- `0.875em` on inline code (relative to parent)
- Animation keyframe values
- Media query breakpoints (CSS vars don't work there)
- Mobile-specific responsive overrides in `@media` blocks

### Typography
- **Headings:** Fraunces (variable font) with `font-variation-settings: 'WONK' 1, 'opsz' 72`. Weights: H1=400, H2=350, H3=350. Leading is intentionally tight.
- **Body:** System UI stack (`-apple-system`, `BlinkMacSystemFont`, `Segoe UI`, `system-ui`, etc.) — no webfont
- **Mono:** Fira Code for dates, read times, code blocks
- **Heading color:** `--color-text-heading` (warm brown light / cream dark)

### Color System
Two accent color roles — never conflate them:
- `--color-accent-ui` — decorative only (borders, underlines, large uppercase text). Fails WCAG for body text.
- `--color-accent-text` — all readable text uses of orange/amber. Passes 4.5:1.

Dark mode is system-preference only (`prefers-color-scheme`). No JS toggle.

### Ghost Conventions
- `{{#get "posts"}}` for dynamic data fetching (home page latest, related posts)
- `{{@custom.show_reading_time}}` reads from theme custom settings in `package.json`
- `{{img_url feature_image size="m"}}` for responsive images
- `{{#foreach navigation}}` with `{{link_class}}` for active nav state
- `custom-*.hbs` templates are selectable per-page in Ghost Admin

## Custom Commands

- `/swap-font <name> for <heading|body>` — updates font in tokens.css + Google Fonts links in default.hbs and all static pages
- `/preview-sync` — regenerates static pages from current theme state

## Design Constraints (intentional, do not override)

- All values use token variables. No hardcoded pixels in CSS or inline styles in HTML.
- Borders use `var(--border-hairline)` (0.5px). The hairline weight is deliberate.
- Prose max-width is 680px. Do not widen.
- No JS dependencies. Vanilla JS only, kept minimal (TOC scroll spy is the only behavior).
- Nav logo at 32px uses the simplified SVG mark, not the full wordmark.
- `--color-text-muted` is AA Large only — use for metadata (dates, read times), not standalone body text.
