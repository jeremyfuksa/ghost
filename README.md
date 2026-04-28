# The Cocktail Napkin

The site for [jeremyfuksa.com](https://jeremyfuksa.com).

## Architecture

A static [Astro](https://astro.build) site that consumes Ghost as a headless CMS for blog posts only. Home, work, case studies, now, and about are local Astro routes / MDX files. The Handlebars theme that previously drove the site was retired in April 2026.

## Stack

- **Astro 5+** with `@tryghost/content-api` for posts, MDX content collection for case studies
- **Plain CSS** with custom properties; no preprocessor
- **Vanilla JS**, minimal (theme toggle, TOC scroll-spy, reading-progress bar)
- **Fonts** — Fraunces (headings), Fira Code (mono), system UI stack (body)
- **Hosting** — DigitalOcean droplet running Traefik + nginx + Ghost in Docker

## Repo layout

```
site/                The Astro project (the deployed site)
  src/pages/         Routes
  src/content/       Case studies (MDX) and content config
  src/lib/           Ghost client + format helpers
  src/styles/        tokens.css, base.css, components.css, campfire.css, screen.css
  public/            Static assets, scripts/main.js
docker-compose.yml   Local Ghost (SQLite, dev mode)
dev/setup.sh         First-run owner-account setup for local Ghost
dev/deploy-post.mjs  Push a markdown file as a Ghost post
drafts/              Local markdown drafts staged for Ghost
docs/                Plans, specs, handoffs
CLAUDE.md            Detailed guidance for Claude Code agents
```

## Quick start

```bash
# Backend: local headless Ghost
docker compose up -d
bash dev/setup.sh                 # first run only — creates owner account

# Frontend: Astro
cd site
cp .env.example .env              # paste a Content API key from Ghost Admin
pnpm install
pnpm dev                          # http://localhost:4321/
```

- Astro: <http://localhost:4321>
- Ghost admin: <http://localhost:2368/ghost/> — `dev@local.test` / `DevLocal12345!`
- Get the Content API key in Ghost Admin → Settings → Integrations → "Add custom integration".

Edits under `site/src/` hot-reload. Edits to posts in Ghost Admin appear after restart of `pnpm dev` (or rebuild) since posts are fetched at build time.

## Production deploy

Production is a DigitalOcean droplet (`161.35.226.162`) running Traefik (TLS), an nginx container serving `site/dist`, and headless Ghost at [cms.jeremyfuksa.com](https://cms.jeremyfuksa.com). A webhook container runs `rebuild-astro.sh` which pulls the repo and rebuilds Astro in place.

```bash
git push origin main
ssh admin@161.35.226.162 'docker exec webhook /scripts/rebuild-astro.sh'
```

Ghost publish events also auto-trigger this hook, so writing a post in Ghost Admin rebuilds the site automatically.

## Design system

All spacing, type, color, border, and sizing values come from CSS custom properties in [site/src/styles/tokens.css](site/src/styles/tokens.css). Hardcoded pixels in CSS or inline styles are off-limits; see [CLAUDE.md](CLAUDE.md) for the full list of intentional exceptions.

Two accent color roles — do not conflate them:

- `--color-accent-ui` — decorative only (borders, underlines, large uppercase).
- `--color-accent-text` — any readable orange/amber text. Passes 4.5:1.

Dark mode follows `prefers-color-scheme` and exposes a manual `.theme-toggle` button that overrides via `data-theme="light|dark"` and persists to `localStorage`.

## CI

`.github/workflows/ci.yml` runs `pnpm install` + `pnpm check` (Astro type-check) on every PR and on pushes to `main`. Tests are not run in CI because the Ghost contract test needs `GHOST_URL` / `GHOST_CONTENT_API_KEY` from `site/.env`.

## More

- [CLAUDE.md](CLAUDE.md) — architecture, deploy flow, conventions
- [site/README.md](site/README.md) — Astro-specific dev instructions
- [.claude/commands/](.claude/commands/) — custom slash commands (`/swap-font`)
- [docs/superpowers/](docs/superpowers/) — design specs and implementation plans
