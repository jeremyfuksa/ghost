# jeremyfuksa.com — Astro frontend

Static Astro site that renders posts from a headless Ghost instance and serves all other pages from local content.

## Prerequisites

- Node 20+
- pnpm 8+
- Local Ghost running at `http://localhost:2368` (see repo root for Docker setup)

## Setup

```bash
cd site
cp .env.example .env
# Edit .env: paste a Content API key from http://localhost:2368/ghost/ → Settings → Integrations
pnpm install
```

## Develop

```bash
pnpm dev              # http://localhost:4321/
```

Astro reads posts from Ghost at build/dev time. Drafts in Ghost are not fetched (Content API doesn't expose them by default).

## Test

```bash
pnpm test             # vitest contract + redirect tests
pnpm check            # astro check (TypeScript)
```

## Build

```bash
pnpm build            # output in dist/
pnpm preview          # serve dist/ locally
```

## Deploy

Static `dist/` directory ready for Netlify/Vercel/Cloudflare Pages. A Ghost webhook on `post.published` / `post.updated` should trigger a rebuild.

## Editing content

- **Posts:** Edit in Ghost Admin (`http://localhost:2368/ghost/`). Changes appear after rebuild.
- **Case studies:** `src/content/case-studies/<slug>.mdx`.
- **Home, Now, About, Work index:** corresponding `.astro` files in `src/pages/`.
- **Design tokens / CSS:** `src/styles/*.css`. No build step.
- **JS:** `public/scripts/main.js`.

## Architecture notes

- **Content API client:** `src/lib/ghost.ts` exports `getAllPosts`, `getPostBySlug`, `getPostsByTag`, `getAllTags`. Tilde-pinned to `@tryghost/content-api ~1.11.21` (this SDK has historically changed error shape between minor versions). The 1.11.x branch ships no types, so `src/env.d.ts` declares the module ambiently.
- **Format helpers:** `src/lib/format.ts` exports `ghostImageUrl`, `isoDate`, `shortDate`, `monthYear`, `readingTime`. `ghostImageUrl` rewrites Ghost CDN paths to a target width per `theme/package.json` `image_sizes`.
- **Content collection:** `src/content/case-studies/` holds five MDX files with Zod-validated frontmatter (`src/content/config.ts`). One shared `CaseStudyLayout.astro` renders header + sidebar; the MDX body fills the prose slot.
- **Redirects:** `src/redirects.json` is wired into `astro.config.mjs`. Two entries today (`/moonbird/`, `/rss/`); add to the JSON, rebuild, ship.
- **404:** `src/pages/404.astro` passes `noCanonical` to suppress the canonical link and og:url.
- **RSS:** `src/pages/rss.xml.ts` emits the feed at `/rss.xml`. The redirect from `/rss/` preserves any existing subscribers.
