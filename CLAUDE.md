# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Custom Ghost 6 Handlebars theme called "The Cocktail Napkin" for jeremyfuksa.com. No build step — CSS and JS are served directly. The theme is uploaded as a zip to Ghost Admin.

## Key Commands

```bash
# Package theme for upload
cd theme && zip -r ../the-cocktail-napkin.zip . -x "*.DS_Store" -x "*node_modules*"

# Preview locally (no Ghost server needed)
open preview.html

# Deploy routes (separate from theme zip)
# Upload theme/routes.yaml via Ghost Admin > Settings > Labs > Routes
```

## Architecture

### Routing (`theme/routes.yaml`)
- `/` renders `custom-home.hbs` with data from a Ghost page titled "Home"
- `/writing/` is a post collection using `index.hbs`
- `/tag/{slug}/` uses `tag.hbs` for tag archives
- Posts live at `/writing/{slug}/`

### CSS Structure (no preprocessor, no build)
- `tokens.css` — design tokens only (CSS custom properties, no selectors)
- `base.css` — reset, heading/body defaults, animations
- `components.css` — all component styles (~1200 lines)
- `screen.css` — entry point that `@import`s the above three

The `preview.html` file loads the three CSS files directly via `<link>` tags (bypassing `screen.css` imports) because `@import` fails over `file://` protocol.

### Typography
- **Headings:** Fraunces (variable font) with `font-variation-settings: 'WONK' 1, 'opsz' 72` for the whimsical ball-terminal style. Weights: H1=400, H2=350, H3=350. Leading is intentionally tight (below 1:1 ratio on H2/H3).
- **Body:** Barlow (sans-serif), weight 400
- **Mono:** Fira Code for dates, read times, code blocks
- All three loaded via a single Google Fonts `<link>` in `default.hbs` and `preview.html`

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

### Preview System
`preview.html` is a static HTML file rendering all page templates with mock content. It exists because Handlebars templates need Ghost to render. When theme templates or styles change, the preview drifts — use `/preview-sync` to regenerate it.

## Custom Commands

- `/swap-font <name> for <heading|body>` — updates font in tokens.css + Google Fonts links in both default.hbs and preview.html
- `/preview-sync` — regenerates preview.html from current theme state

## Design Constraints (intentional, do not override)

- All spacing uses token variables. No hardcoded pixel values in CSS.
- Borders are `0.5px` (hairline weight is deliberate).
- Prose max-width is 680px. Do not widen.
- No JS dependencies. Vanilla JS only, kept minimal (TOC scroll spy is the only behavior).
- Nav logo at 32px uses the simplified SVG mark, not the full wordmark.
- `--color-text-muted` is AA Large only — use for metadata (dates, read times), not standalone body text.
