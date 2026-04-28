# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo contains two coexisting systems for jeremyfuksa.com during a migration to a headless architecture:

- **`theme/`** — the original "The Cocktail Napkin" Ghost 6 Handlebars theme. No build step; CSS and JS served directly. Deployed as a zip to Ghost Admin (or via the Admin API using `dev/deploy-theme.mjs`).
- **`site/`** — an Astro static site consuming Ghost as a headless source for posts. All non-post content (home, work, case studies, now, about) is local. Build with `cd site && pnpm build`. See `site/README.md`.

The end state is the Astro site in production with Ghost serving as a content-only backend. The Handlebars theme remains in the repo until cutover, then gets archived. Both systems can run concurrently against the same local Docker Ghost.

## Development Workflow

For Ghost-theme changes (Handlebars templates, `theme/assets/css/`, `routes.yaml`): work against the live Ghost dev container (see Docker section below). The bind-mounted theme directory live-reloads on file changes.

For Astro frontend changes (everything in `site/`): work in `site/` with `pnpm dev` for HMR. The Astro site fetches posts from the local Docker Ghost via Content API at build/dev time.

```bash
# Ghost backend (always running for both systems)
docker compose up -d            # http://localhost:2368/

# Astro frontend
cd site && pnpm dev             # http://localhost:4321/
cd site && pnpm test            # vitest contract + redirect tests
cd site && pnpm build           # static dist/
```

## Key Commands

```bash
# Package theme for upload
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
2. Upload to your Ghost Admin at jeremyfuksa.com (Themes) — or push via the Admin API using the `GHOST_API` key in `.env` (`POST /ghost/api/admin/themes/upload/` with a JWT signed from the key)
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
- **Headings:** Fraunces (variable font) with `font-variation-settings: 'WONK' 1, 'opsz' 72`. Weights: H1=425, H2=400, H3=400 (raised from H1=400, H2=350, H3=350 in 2026-04-25 for readability at body distance). Display H1 surfaces (`.hero-name`, `.casestudy-title`) match base h1 at 425; H2/H3-class title surfaces in components.css use 400. Leading is intentionally tight.
- **Body:** System UI stack (`-apple-system`, `BlinkMacSystemFont`, `Segoe UI`, `system-ui`, etc.) — no webfont
- **Mono:** Fira Code for dates, read times, code blocks
- **Heading color:** `--color-text-heading` (warm brown light / cream dark)

### Color System
Two accent color roles — never conflate them:
- `--color-accent-ui` — decorative only (borders, underlines, large uppercase text). Fails WCAG for body text.
- `--color-accent-text` — all readable text uses of orange/amber. Passes 4.5:1.

Dark mode follows `prefers-color-scheme` by default, with a manual `.theme-toggle` button in the nav header that overrides via `data-theme="light|dark"` and persists to `localStorage`. Both selectors must be honored when adding theme-aware rules: see `home-bg::before` (components.css:761-772) for the established pattern.

### Ghost Conventions
- `{{#get "posts"}}` for dynamic data fetching (home page latest, related posts)
- `{{@custom.show_reading_time}}` reads from theme custom settings in `package.json`
- `{{img_url feature_image size="m"}}` for responsive images
- `{{#foreach navigation}}` with `{{link_class}}` for active nav state
- `custom-*.hbs` templates are selectable per-page in Ghost Admin

## Custom Commands

- `/swap-font <name> for <heading|body>` — updates font in tokens.css + Google Fonts link in default.hbs

## Design Constraints (intentional, do not override)

- All values use token variables. No hardcoded pixels in CSS or inline styles in HTML.
- Borders use `var(--border-hairline)` (0.5px). The hairline weight is deliberate.
- Prose max-width is `--prose-max: 720px` (single-column reading); content max-width is `--content-max: 1280px` (multi-column). All page wrappers use `padding: var(--spacing-12) var(--spacing-8) var(--spacing-20)`; responsive horizontal padding step-down lives in the consolidated media block at the end of `components.css`.
- No JS dependencies. Vanilla JS only, in `theme/assets/js/main.js`. Five behaviors: theme toggle, TOC scroll spy + sliding indicator, heading-anchor copy-to-clipboard links, reading-progress bar, and `IntersectionObserver`-driven scroll reveal on images and cards. All respect `prefers-reduced-motion`.
- Nav logo at 32px uses the simplified SVG mark, not the full wordmark.
- `--color-text-muted` is AA Large only — use for metadata (dates, read times), not standalone body text.
