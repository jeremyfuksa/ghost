# Astro + Headless Ghost Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the custom Ghost Handlebars theme with an Astro static site that consumes Ghost as a headless content source for posts only — moving home, work, case studies, now, and about into version-controlled `.astro` / MDX files.

**Architecture:** Ghost (running locally via Docker, eventually production) keeps owning blog posts and tags. Astro fetches posts at build time via `@tryghost/content-api` and renders them under `/writing/`. All non-post pages (`/`, `/work/`, `/work/<slug>/`, `/now/`, `/about/`) become first-class Astro routes — case studies as MDX in a content collection. The existing design system (`tokens.css` / `base.css` / `components.css` / `campfire.css`) ports over as global CSS unchanged. The vanilla JS (`main.js`) ports over as a single inline-bundled script. Build output is fully static; deploys are triggered by a Ghost webhook → static host (Netlify/Vercel/Cloudflare Pages — host choice is deferred to post-migration).

**Tech Stack:** Astro 5+, `@tryghost/content-api` (Ghost SDK), `@astrojs/mdx`, `@astrojs/rss`, `@astrojs/sitemap`, TypeScript (strict), node 20+, pnpm. Existing CSS preserved verbatim. No CSS preprocessor, no Tailwind, no React. Vitest for tests where genuinely useful (data-shape contracts, redirect maps).

**Out of scope:** Members/subscriptions migration, comments, search UI, image optimization beyond Ghost's existing sizes, Portal embed (signup links pass through to the Ghost host), final hosting decision and DNS cutover. Those land in a follow-up plan once parity ships to staging.

**Working location:** New top-level directory `site/` in this repo (alongside existing `theme/`). The Ghost theme stays untouched until the cutover task at the very end. This is deliberate: the existing site keeps shipping while the new one is being built, and we can A/B compare locally page-by-page.

---

## File Structure

```
site/
├── astro.config.mjs            # Astro config: integrations, site URL, output mode
├── package.json                # Astro deps; separate from root package.json
├── pnpm-lock.yaml
├── tsconfig.json               # strict TS, paths alias (~/* → src/*)
├── .env.example                # GHOST_URL, GHOST_CONTENT_API_KEY (committed)
├── .env                        # gitignored, real values
├── public/
│   ├── images/
│   │   ├── flame.svg           # copied from theme/assets/images/
│   │   └── jeremy-hero.jpg     # copied from theme/assets/images/
│   └── robots.txt
├── src/
│   ├── env.d.ts                # Astro env types
│   ├── lib/
│   │   ├── ghost.ts            # GhostContentAPI singleton + typed wrappers
│   │   ├── ghost.types.ts      # Post / Tag / Author shapes (subset we use)
│   │   └── format.ts           # date helpers, reading-time fallback
│   ├── content/
│   │   ├── config.ts           # Content collection schemas
│   │   └── case-studies/
│   │       ├── domain-foundation.mdx
│   │       ├── moonbird.mdx
│   │       ├── redwood-health-design.mdx
│   │       ├── seven-years-in-healthcare-ux.mdx
│   │       └── terra-design-system.mdx
│   ├── styles/
│   │   ├── campfire.css        # copied verbatim from theme/assets/css/
│   │   ├── tokens.css          # copied verbatim
│   │   ├── base.css            # copied verbatim
│   │   ├── components.css      # copied verbatim
│   │   └── screen.css          # entry point that @imports the four above
│   ├── scripts/
│   │   └── main.js             # copied verbatim from theme/assets/js/main.js
│   ├── layouts/
│   │   └── BaseLayout.astro    # equivalent of default.hbs
│   ├── components/
│   │   ├── SiteHeader.astro    # equivalent of partials/header.hbs
│   │   ├── SiteFooter.astro    # equivalent of partials/footer.hbs
│   │   ├── PostCard.astro      # equivalent of partials/post-card.hbs
│   │   ├── PostCardFeatured.astro
│   │   ├── SidebarPostLink.astro
│   │   ├── TagPill.astro
│   │   ├── NowCard.astro
│   │   ├── SubscribeCta.astro
│   │   ├── IconShare.astro
│   │   └── CaseStudyLayout.astro  # composes header + sidebar slots
│   └── pages/
│       ├── index.astro         # /
│       ├── 404.astro
│       ├── about.astro         # /about/
│       ├── now.astro           # /now/
│       ├── work/
│       │   ├── index.astro     # /work/
│       │   └── [slug].astro    # /work/<slug>/  (case studies from collection)
│       ├── writing/
│       │   ├── index.astro     # /writing/  (paginated)
│       │   ├── [slug].astro    # /writing/<slug>/  (post)
│       │   └── page/[page].astro  # /writing/page/2/, /3/, ...
│       ├── tag/
│       │   └── [slug].astro    # /tag/<tag>/
│       ├── rss.xml.ts          # /rss/ feed (matches Ghost's URL)
│       └── sitemap-index.xml.ts  # via @astrojs/sitemap integration
└── tests/
    ├── ghost.test.ts           # contract test: API returns expected shape
    └── redirects.test.ts       # legacy URL coverage
```

**Why this layout:**
- `site/` is fully separate from `theme/` so the existing Ghost theme keeps working until the cutover. No cross-contamination.
- Components mirror the existing partials 1:1 by name to make the port mechanical and reviewable.
- CSS is copied verbatim, not refactored. Any cleanup is post-migration work.
- Case studies as a content collection (`src/content/case-studies/`) gets us schema validation, type safety, and frontmatter — the architectural payoff of the migration.
- Posts stay in Ghost (fetched at build time); only their *rendering* moves.

---

## Task 1: Bootstrap the Astro project

**Files:**
- Create: `site/package.json`
- Create: `site/astro.config.mjs`
- Create: `site/tsconfig.json`
- Create: `site/.env.example`
- Create: `site/.gitignore`
- Modify: `.gitignore` (root) — add `site/.env`, `site/dist/`, `site/.astro/`, `site/node_modules/`

- [ ] **Step 1: Verify pnpm and node versions are compatible**

Run: `node --version && pnpm --version`
Expected: Node `v20.x` or higher; pnpm `8.x` or higher.

If pnpm is missing, install it: `npm install -g pnpm`.

- [ ] **Step 2: Create the Astro project directory and scaffold package.json**

Create `site/package.json`:

```json
{
  "name": "jeremyfuksa-site",
  "type": "module",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "astro dev",
    "build": "astro build",
    "preview": "astro preview",
    "check": "astro check",
    "test": "vitest run"
  },
  "dependencies": {
    "@astrojs/mdx": "^4.0.0",
    "@astrojs/rss": "^4.0.0",
    "@astrojs/sitemap": "^3.2.0",
    "@tryghost/content-api": "^1.11.21",
    "astro": "^5.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.6.0",
    "vitest": "^2.1.0"
  }
}
```

- [ ] **Step 3: Create astro.config.mjs**

Create `site/astro.config.mjs`:

```js
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://jeremyfuksa.com',
  output: 'static',
  trailingSlash: 'always',
  build: {
    format: 'directory',
  },
  integrations: [mdx(), sitemap()],
});
```

`trailingSlash: 'always'` and `format: 'directory'` together preserve the existing `/writing/<slug>/` URL shape that Ghost has been emitting.

- [ ] **Step 4: Create tsconfig.json**

Create `site/tsconfig.json`:

```json
{
  "extends": "astro/tsconfigs/strict",
  "include": [".astro/types.d.ts", "**/*"],
  "exclude": ["dist"],
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "~/*": ["src/*"]
    }
  }
}
```

- [ ] **Step 5: Create .env.example and .gitignore**

Create `site/.env.example`:

```
GHOST_URL=http://localhost:2368
GHOST_CONTENT_API_KEY=replace-with-content-api-key-from-ghost-admin
```

Create `site/.gitignore`:

```
node_modules/
dist/
.astro/
.env
.env.production
*.log
```

- [ ] **Step 6: Update root .gitignore**

Append to `.gitignore` (root):

```

# Astro site (separate workspace)
site/node_modules/
site/dist/
site/.astro/
site/.env
site/.env.production
```

- [ ] **Step 7: Install dependencies**

Run: `cd site && pnpm install`
Expected: All packages resolve. No peer-dep warnings about Astro 5.

- [ ] **Step 8: Verify the empty Astro install builds**

Run: `cd site && pnpm astro check`
Expected: `0 errors, 0 warnings, 0 hints` (no source files yet).

- [ ] **Step 9: Commit**

```bash
git add site/package.json site/astro.config.mjs site/tsconfig.json site/.env.example site/.gitignore .gitignore site/pnpm-lock.yaml
git commit -m "feat(site): bootstrap Astro project alongside existing Ghost theme"
```

---

## Task 2: Wire up Ghost Content API client

**Files:**
- Create: `site/src/lib/ghost.types.ts`
- Create: `site/src/lib/ghost.ts`
- Create: `site/src/env.d.ts`
- Create: `site/tests/ghost.test.ts`
- Create: `site/.env` (local-only, not committed)

This task gets a real-data connection to the local Docker Ghost instance. After this, every subsequent task can fetch real posts.

- [ ] **Step 1: Get a Content API key from local Ghost**

The Docker Ghost instance is at `http://localhost:2368`. Open `http://localhost:2368/ghost/` (admin), log in with `dev@local.test` / `DevLocal12345!`, navigate to **Settings → Integrations → Add custom integration**, name it "Astro site", and copy the **Content API Key** (NOT the Admin API key — Content API key is shorter, ~26 hex chars).

If the local Ghost isn't running: `docker compose up -d` from the repo root, then `bash dev/setup.sh`.

- [ ] **Step 2: Populate site/.env**

Create `site/.env`:

```
GHOST_URL=http://localhost:2368
GHOST_CONTENT_API_KEY=<paste the key from step 1>
```

This file is gitignored.

- [ ] **Step 3: Add env type definitions**

Create `site/src/env.d.ts`:

```ts
/// <reference path="../.astro/types.d.ts" />

interface ImportMetaEnv {
  readonly GHOST_URL: string;
  readonly GHOST_CONTENT_API_KEY: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
```

- [ ] **Step 4: Define typed Ghost data shapes**

Create `site/src/lib/ghost.types.ts`:

```ts
export interface GhostTag {
  id: string;
  slug: string;
  name: string;
  url: string;
  count?: { posts: number };
}

export interface GhostAuthor {
  id: string;
  slug: string;
  name: string;
  bio?: string;
  profile_image?: string;
  url: string;
}

export interface GhostPost {
  id: string;
  slug: string;
  title: string;
  html: string;
  excerpt: string;
  custom_excerpt: string | null;
  feature_image: string | null;
  feature_image_caption: string | null;
  featured: boolean;
  published_at: string;
  updated_at: string;
  reading_time: number;
  url: string;
  tags: GhostTag[];
  primary_tag: GhostTag | null;
  authors: GhostAuthor[];
  primary_author: GhostAuthor | null;
}
```

These cover only the fields the existing theme actually reads. Add more later only when a template needs them.

- [ ] **Step 5: Write a failing contract test**

Create `site/tests/ghost.test.ts`:

```ts
import { describe, expect, it } from 'vitest';
import { getAllPosts, getPostBySlug, getAllTags } from '../src/lib/ghost';

describe('ghost API client', () => {
  it('fetches posts with the expected shape', async () => {
    const posts = await getAllPosts();
    expect(Array.isArray(posts)).toBe(true);
    expect(posts.length).toBeGreaterThan(0);

    const post = posts[0];
    expect(post).toMatchObject({
      id: expect.any(String),
      slug: expect.any(String),
      title: expect.any(String),
      html: expect.any(String),
      published_at: expect.any(String),
      reading_time: expect.any(Number),
    });
    expect(Array.isArray(post.tags)).toBe(true);
  });

  it('fetches a single post by slug', async () => {
    const all = await getAllPosts();
    const slug = all[0].slug;
    const post = await getPostBySlug(slug);
    expect(post?.slug).toBe(slug);
  });

  it('returns null for a missing slug', async () => {
    const post = await getPostBySlug('definitely-not-a-real-post-slug-xyzzy');
    expect(post).toBeNull();
  });

  it('fetches tags ordered by post count desc', async () => {
    const tags = await getAllTags();
    expect(Array.isArray(tags)).toBe(true);
  });
});
```

- [ ] **Step 6: Run the failing test**

Run: `cd site && pnpm vitest run`
Expected: FAIL with `Cannot find module '../src/lib/ghost'`.

- [ ] **Step 7: Implement the Ghost client**

Create `site/src/lib/ghost.ts`:

```ts
import GhostContentAPI from '@tryghost/content-api';
import type { GhostPost, GhostTag } from './ghost.types';

const url = import.meta.env.GHOST_URL;
const key = import.meta.env.GHOST_CONTENT_API_KEY;

if (!url || !key) {
  throw new Error(
    'GHOST_URL and GHOST_CONTENT_API_KEY must be set in site/.env',
  );
}

const api = new GhostContentAPI({
  url,
  key,
  version: 'v5.0',
});

export async function getAllPosts(): Promise<GhostPost[]> {
  const posts = await api.posts.browse({
    limit: 'all',
    include: ['tags', 'authors'],
    order: 'published_at desc',
  });
  return posts as unknown as GhostPost[];
}

export async function getPostBySlug(slug: string): Promise<GhostPost | null> {
  try {
    const post = await api.posts.read(
      { slug },
      { include: ['tags', 'authors'] },
    );
    return post as unknown as GhostPost;
  } catch (err) {
    if ((err as { type?: string }).type === 'NotFoundError') return null;
    throw err;
  }
}

export async function getPostsByTag(tagSlug: string): Promise<GhostPost[]> {
  const posts = await api.posts.browse({
    limit: 'all',
    filter: `tag:${tagSlug}`,
    include: ['tags', 'authors'],
    order: 'published_at desc',
  });
  return posts as unknown as GhostPost[];
}

export async function getAllTags(): Promise<GhostTag[]> {
  const tags = await api.tags.browse({
    limit: 'all',
    order: 'count.posts desc',
    include: ['count.posts'],
  });
  return tags as unknown as GhostTag[];
}
```

- [ ] **Step 8: Add a vitest config that loads .env**

Create `site/vitest.config.ts`:

```ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'node',
    env: {
      ...process.env,
    },
  },
});
```

Vitest needs help loading `.env` for non-Astro contexts. Add a tiny shim — create `site/tests/setup.ts`:

```ts
import { config } from 'dotenv';
config({ path: '.env' });
```

Update `site/vitest.config.ts`:

```ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'node',
    setupFiles: ['./tests/setup.ts'],
  },
});
```

Add `dotenv` to devDependencies: `cd site && pnpm add -D dotenv`.

The Ghost client uses `import.meta.env` which Vitest exposes from `process.env` automatically once dotenv populates it. If the test still can't read the vars, change `site/src/lib/ghost.ts` line `const url = import.meta.env.GHOST_URL;` to `const url = import.meta.env.GHOST_URL ?? process.env.GHOST_URL;` (same for key) — Astro and Vitest both resolve correctly.

- [ ] **Step 9: Run the test, expect PASS**

Run: `cd site && pnpm vitest run`
Expected: All 4 tests pass. If posts.length is 0, the local Ghost has no seed posts — re-run `bash dev/setup.sh` from repo root, which seeds test content.

- [ ] **Step 10: Commit**

```bash
git add site/src/lib site/src/env.d.ts site/tests site/vitest.config.ts site/package.json site/pnpm-lock.yaml site/.env.example
git commit -m "feat(site): add typed Ghost Content API client with contract tests"
```

---

## Task 3: Port the design system (CSS + JS) verbatim

**Files:**
- Create: `site/src/styles/campfire.css`
- Create: `site/src/styles/tokens.css`
- Create: `site/src/styles/base.css`
- Create: `site/src/styles/components.css`
- Create: `site/src/styles/screen.css`
- Create: `site/src/scripts/main.js`
- Create: `site/public/images/flame.svg`
- Create: `site/public/images/jeremy-hero.jpg`

**Critical constraint from CLAUDE.md:** No CSS preprocessor, no build step transforming CSS, no Tailwind. The existing CSS works; copy it verbatim. Any restructuring is post-migration.

- [ ] **Step 1: Copy CSS files verbatim**

Run from repo root:

```bash
mkdir -p site/src/styles
cp theme/assets/css/campfire.css site/src/styles/campfire.css
cp theme/assets/css/tokens.css site/src/styles/tokens.css
cp theme/assets/css/base.css site/src/styles/base.css
cp theme/assets/css/components.css site/src/styles/components.css
cp theme/assets/css/screen.css site/src/styles/screen.css
```

Verify: `cd site && wc -l src/styles/*.css` should match the originals (157, 733, 3345, 8, 208 = 4451 total lines).

- [ ] **Step 2: Copy JS verbatim**

```bash
mkdir -p site/src/scripts
cp theme/assets/js/main.js site/src/scripts/main.js
```

Verify it's 162 lines: `wc -l site/src/scripts/main.js`.

- [ ] **Step 3: Copy public images**

```bash
mkdir -p site/public/images
cp theme/assets/images/flame.svg site/public/images/flame.svg
cp theme/assets/images/jeremy-hero.jpg site/public/images/jeremy-hero.jpg
```

- [ ] **Step 4: Add a robots.txt**

Create `site/public/robots.txt`:

```
User-agent: *
Allow: /

Sitemap: https://jeremyfuksa.com/sitemap-index.xml
```

- [ ] **Step 5: Sanity-check that CSS imports resolve from screen.css**

Read `site/src/styles/screen.css` and confirm it `@import`s `campfire.css`, `tokens.css`, `base.css`, `components.css` in that order. The originals already do.

- [ ] **Step 6: Commit**

```bash
git add site/src/styles site/src/scripts site/public
git commit -m "feat(site): copy design system CSS, vanilla JS, and static images verbatim from theme"
```

---

## Task 4: Build the base layout and shared components

**Files:**
- Create: `site/src/layouts/BaseLayout.astro`
- Create: `site/src/components/SiteHeader.astro`
- Create: `site/src/components/SiteFooter.astro`
- Create: `site/src/components/IconShare.astro`
- Create: `site/src/components/TagPill.astro`
- Create: `site/src/components/PostCard.astro`
- Create: `site/src/components/PostCardFeatured.astro`
- Create: `site/src/components/SidebarPostLink.astro`
- Create: `site/src/components/NowCard.astro`
- Create: `site/src/components/SubscribeCta.astro`
- Create: `site/src/pages/index.astro` (placeholder for now — replaced in Task 6)

This task ports every Handlebars partial to an Astro component, plus the `default.hbs` outer shell.

- [ ] **Step 1: Create BaseLayout.astro**

Create `site/src/layouts/BaseLayout.astro`:

```astro
---
import '~/styles/screen.css';

interface Props {
  title: string;
  description?: string;
  bodyClass?: string;
  ogImage?: string;
}

const { title, description, bodyClass = '', ogImage } = Astro.props;
const canonical = new URL(Astro.url.pathname, Astro.site).toString();
---

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{title}</title>
  {description && <meta name="description" content={description} />}
  <link rel="canonical" href={canonical} />
  <link rel="icon" type="image/svg+xml" href="/images/flame.svg" />
  <meta property="og:title" content={title} />
  {description && <meta property="og:description" content={description} />}
  <meta property="og:url" content={canonical} />
  {ogImage && <meta property="og:image" content={ogImage} />}
  <meta name="twitter:card" content="summary_large_image" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link
    href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,WONK@9..144,100..900,0..1&display=swap"
    rel="stylesheet"
  />
  <script is:inline>
    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.documentElement.classList.add('dark');
    }
  </script>
  <!-- Google Analytics -->
  <script async src="https://www.googletagmanager.com/gtag/js?id=G-DJBY6FWMKN"></script>
  <script is:inline>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-DJBY6FWMKN');
  </script>
</head>
<body class={bodyClass}>
  <slot name="header">
    <!-- Fallback rendered if a page doesn't override -->
  </slot>
  <div class="site-content">
    <slot />
  </div>
  <slot name="footer" />
  <div class="reading-progress" aria-hidden="true"></div>
  <script src="/scripts/main.js" is:inline></script>
</body>
</html>
```

Note: the original `default.hbs` always renders header + footer. We'll have pages just call `<SiteHeader />` and `<SiteFooter />` themselves rather than slot fallbacks — simpler. Update `BaseLayout.astro` to:

```astro
---
import '~/styles/screen.css';
import SiteHeader from '~/components/SiteHeader.astro';
import SiteFooter from '~/components/SiteFooter.astro';

interface Props {
  title: string;
  description?: string;
  bodyClass?: string;
  ogImage?: string;
}

const { title, description, bodyClass = '', ogImage } = Astro.props;
const canonical = new URL(Astro.url.pathname, Astro.site).toString();
---

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{title}</title>
  {description && <meta name="description" content={description} />}
  <link rel="canonical" href={canonical} />
  <link rel="icon" type="image/svg+xml" href="/images/flame.svg" />
  <meta property="og:title" content={title} />
  {description && <meta property="og:description" content={description} />}
  <meta property="og:url" content={canonical} />
  {ogImage && <meta property="og:image" content={ogImage} />}
  <meta name="twitter:card" content="summary_large_image" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link
    href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,WONK@9..144,100..900,0..1&display=swap"
    rel="stylesheet"
  />
  <script is:inline>
    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.documentElement.classList.add('dark');
    }
  </script>
  <script async src="https://www.googletagmanager.com/gtag/js?id=G-DJBY6FWMKN"></script>
  <script is:inline>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-DJBY6FWMKN');
  </script>
</head>
<body class={bodyClass}>
  <SiteHeader currentPath={Astro.url.pathname} />
  <div class="site-content">
    <slot />
  </div>
  <SiteFooter />
  <div class="reading-progress" aria-hidden="true"></div>
  <script src="/scripts/main.js" is:inline></script>
</body>
</html>
```

We need to make `main.js` reachable as `/scripts/main.js`. Move it from `src/scripts/` to `public/scripts/`. Run:

```bash
mkdir -p site/public/scripts
mv site/src/scripts/main.js site/public/scripts/main.js
rmdir site/src/scripts
```

(`is:inline` on the script tag prevents Astro from trying to bundle it — we want it served verbatim.)

- [ ] **Step 2: Create SiteHeader.astro**

Create `site/src/components/SiteHeader.astro`:

```astro
---
interface Props {
  currentPath: string;
}
const { currentPath } = Astro.props;

const navItems = [
  { url: '/writing/', label: 'Writing' },
  { url: '/work/', label: 'Work' },
  { url: '/now/', label: 'Now' },
  { url: '/about/', label: 'About' },
];

function isActive(itemUrl: string): boolean {
  if (itemUrl === '/') return currentPath === '/';
  return currentPath.startsWith(itemUrl);
}
---

<header class="nav">
  <div class="nav-inner">
    <a href="/" class="nav-brand">
      <div class="nav-logo" style="--logo-glyph: url('/images/flame.svg')" aria-hidden="true"></div>
      <div class="nav-name-stack">
        <span class="nav-site-name">The Cocktail Napkin</span>
        <span class="nav-author-name">Jeremy Fuksa</span>
      </div>
    </a>
    <nav>
      <ul class="nav-links">
        {navItems.map((item) => (
          <li>
            <a href={item.url} class={isActive(item.url) ? 'nav-current' : ''}>
              {item.label}
            </a>
          </li>
        ))}
        <li>
          <button class="theme-toggle" type="button" aria-label="Toggle dark mode">
            <svg class="theme-toggle-icon theme-toggle-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
              <circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/>
            </svg>
            <svg class="theme-toggle-icon theme-toggle-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
              <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
            </svg>
          </button>
        </li>
      </ul>
    </nav>
  </div>
</header>
```

`nav-current` is the class Ghost emits via `{{link_class}}` — verify by inspecting current production rendering, or grep `theme/assets/css/components.css` for `nav-current`. If the active-link class differs in CSS, match the CSS, not this guess.

To verify: `grep -n "nav-current\|nav-active\|link_class" theme/assets/css/components.css` — adjust the active class to whatever the CSS expects.

- [ ] **Step 3: Create SiteFooter.astro**

Create `site/src/components/SiteFooter.astro` by porting `theme/partials/footer.hbs` literally — keep all five social SVGs verbatim, replace `{{date format="YYYY"}}` with `{new Date().getFullYear()}`, and replace `{{asset "images/flame.svg"}}` with `/images/flame.svg`. (Full content matches `theme/partials/footer.hbs` lines 1–49.)

```astro
---
const year = new Date().getFullYear();
---

<footer class="site-footer">
  <div class="footer-inner">
    <div class="footer-row footer-row-top">
      <div class="footer-brand">
        <div class="footer-brand-mark" style="--logo-glyph: url('/images/flame.svg')" aria-hidden="true"></div>
        <div class="footer-brand-text">
          <span class="footer-brand-name">Jeremy Fuksa</span>
          <span class="footer-tagline">Kansas City · KF0NUI</span>
        </div>
      </div>
      <nav>
        <ul class="footer-nav">
          <li><a href="/writing/">Writing</a></li>
          <li><a href="/work/">Work</a></li>
          <li><a href="/now/">Now</a></li>
          <li><a href="/about/">About</a></li>
        </ul>
      </nav>
    </div>
    <div class="footer-row footer-row-bottom">
      <nav class="footer-social" aria-label="Social links">
        <a href="https://linkedin.com/in/jeremyfuksa" class="footer-social-link" target="_blank" rel="noopener" aria-label="LinkedIn">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18" aria-hidden="true"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 0 1-2.063-2.065 2.064 2.064 0 1 1 2.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg>
          <span class="footer-social-label">LinkedIn</span>
        </a>
        <a href="https://github.com/jeremyfuksa" class="footer-social-link" target="_blank" rel="noopener" aria-label="GitHub">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18" aria-hidden="true"><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></svg>
          <span class="footer-social-label">GitHub</span>
        </a>
        <a href="https://instagram.com/jeremyfuksa" class="footer-social-link" target="_blank" rel="noopener" aria-label="Instagram">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18" aria-hidden="true"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 1 0 0 12.324 6.162 6.162 0 0 0 0-12.324zM12 16a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm6.406-11.845a1.44 1.44 0 1 0 0 2.881 1.44 1.44 0 0 0 0-2.881z"/></svg>
          <span class="footer-social-label">Instagram</span>
        </a>
        <a href="https://www.youtube.com/@JeremyFuksa" class="footer-social-link" target="_blank" rel="noopener" aria-label="YouTube">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18" aria-hidden="true"><path d="M23.495 6.205a3.007 3.007 0 0 0-2.088-2.088c-1.87-.501-9.396-.501-9.396-.501s-7.507-.01-9.396.501A3.007 3.007 0 0 0 .527 6.205a31.247 31.247 0 0 0-.522 5.805 31.247 31.247 0 0 0 .522 5.783 3.007 3.007 0 0 0 2.088 2.088c1.868.502 9.396.502 9.396.502s7.506 0 9.396-.502a3.007 3.007 0 0 0 2.088-2.088 31.247 31.247 0 0 0 .5-5.783 31.247 31.247 0 0 0-.5-5.805zM9.609 15.601V8.408l6.264 3.602z"/></svg>
          <span class="footer-social-label">YouTube</span>
        </a>
        <a href="https://www.threads.com/@jeremyfuksa" class="footer-social-link" target="_blank" rel="noopener" aria-label="Threads">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18" aria-hidden="true"><path d="M12.186 24h-.007c-3.581-.024-6.334-1.205-8.184-3.509C2.35 18.44 1.5 15.586 1.472 12.01v-.017c.03-3.579.879-6.43 2.525-8.482C5.845 1.205 8.6.024 12.18 0h.014c2.746.02 5.043.725 6.826 2.098 1.677 1.29 2.858 3.13 3.509 5.467l-2.04.569c-1.104-3.96-3.898-5.984-8.304-6.015-2.91.022-5.11.936-6.54 2.717C4.307 6.504 3.616 8.914 3.589 12c.027 3.086.718 5.496 2.057 7.164 1.43 1.783 3.631 2.698 6.54 2.717 2.623-.02 4.358-.631 5.8-2.045 1.647-1.613 1.618-3.593 1.09-4.798-.31-.71-.873-1.3-1.634-1.75-.192 1.352-.622 2.446-1.284 3.272-.886 1.102-2.14 1.704-3.73 1.79-1.202.065-2.361-.218-3.259-.801-1.063-.689-1.685-1.74-1.752-2.964-.065-1.19.408-2.353 1.33-3.275.982-.980 2.48-1.438 4.38-1.318.97.06 1.748.217 2.401.444-.093-.5-.233-.964-.421-1.385C14.93 9.05 14 8.54 12.69 8.47l-.028-.001c-.764-.04-1.888.152-2.517.868l-1.513-1.388c.986-1.073 2.554-1.643 4.051-1.56 2.05.1 3.593.894 4.5 2.338.823 1.303 1.133 3.12.887 5.114-.013.107-.027.213-.042.318.56.47 1.034 1.015 1.39 1.618.905 1.515.894 3.994-.893 5.754-1.838 1.8-4.11 2.604-7.339 2.625zm1.45-10.674c-1.252-.092-2.177.184-2.662.797-.37.467-.431 1.02-.173 1.572.277.6.863.976 1.643.978h.028c.927-.04 1.572-.415 1.92-.912.358-.516.557-1.253.621-2.236-.455-.122-.942-.194-1.377-.199z"/></svg>
          <span class="footer-social-label">Threads</span>
        </a>
      </nav>
      <span class="footer-copy">&copy; {year}</span>
    </div>
    <div class="footer-row footer-row-subscribe">
      <a href="/#/portal/signup" class="footer-subscribe-link">Subscribe to The Cocktail Napkin &rarr;</a>
    </div>
  </div>
</footer>
```

Note: the `/#/portal/signup` link is Ghost's Portal signup hash — verify it routes correctly once the Astro site is on the same domain as Ghost (or change to a direct Ghost URL like `https://jeremyfuksa.com/#/portal/signup` if Ghost ends up on a subdomain).

- [ ] **Step 4: Create IconShare.astro**

Create `site/src/components/IconShare.astro`:

```astro
<svg class="icon icon-share" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" width="16" height="16">
  <circle cx="18" cy="5" r="3"/>
  <circle cx="6" cy="12" r="3"/>
  <circle cx="18" cy="19" r="3"/>
  <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/>
  <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>
</svg>
```

- [ ] **Step 5: Create TagPill.astro**

Create `site/src/components/TagPill.astro`:

```astro
---
import type { GhostTag } from '~/lib/ghost.types';

interface Props {
  tags: GhostTag[];
}

const { tags } = Astro.props;
const first = tags[0];
---

{first && (
  <a href={`/tag/${first.slug}/`} class="tag">{first.name}</a>
)}
```

The original `tag-pill.hbs` uses `{{#foreach tags limit="1"}}` — same behavior: render the primary tag as a link.

- [ ] **Step 6: Create PostCard.astro**

Create `site/src/components/PostCard.astro`:

```astro
---
import type { GhostPost } from '~/lib/ghost.types';
import TagPill from './TagPill.astro';

interface Props {
  post: GhostPost;
}

const { post } = Astro.props;
const url = `/writing/${post.slug}/`;
const dateIso = new Date(post.published_at).toISOString().slice(0, 10);
const dateLabel = new Date(post.published_at).toLocaleDateString('en-US', {
  month: 'short',
  day: 'numeric',
  year: 'numeric',
});
const excerpt = post.custom_excerpt ?? post.excerpt;
const readtime = post.reading_time ? `${post.reading_time} min read` : null;
const featureImage = post.feature_image
  ? buildGhostImageUrl(post.feature_image, 'm')
  : null;

function buildGhostImageUrl(src: string, size: 'xxs' | 'xs' | 's' | 'm' | 'l' | 'xl'): string {
  const widths = { xxs: 30, xs: 100, s: 300, m: 600, l: 1000, xl: 2000 };
  if (!src.includes('/content/images/')) return src;
  return src.replace('/content/images/', `/content/images/size/w${widths[size]}/`);
}
---

<article class={`post-card ${featureImage ? 'post-card-has-image' : ''}`}>
  {featureImage && (
    <div class="post-card-image-col">
      <a href={url} class="post-card-image-link">
        <img class="post-card-image" src={featureImage} alt={post.title} loading="lazy" />
      </a>
      <div class="post-card-meta">
        <TagPill tags={post.tags} />
        <span class="post-card-date">
          <time datetime={dateIso}>{dateLabel}</time>
        </span>
      </div>
    </div>
  )}
  <div class="post-card-content">
    {!featureImage && (
      <div class="post-card-meta">
        <TagPill tags={post.tags} />
        <span class="post-card-date">
          <time datetime={dateIso}>{dateLabel}</time>
        </span>
      </div>
    )}
    <a href={url}>
      <h3 class="post-card-title">{post.title}</h3>
    </a>
    {excerpt && <p class="post-card-excerpt">{excerpt}</p>}
    <div class="post-card-footer">
      {readtime && <span class="post-card-readtime">{readtime}</span>}
      <a href={url} class="post-card-read-link">Read <span>&rarr;</span></a>
    </div>
  </div>
</article>
```

The `buildGhostImageUrl` helper replicates Ghost's `{{img_url ... size="m"}}` by injecting `/size/wNNN/` into the image path. Widths come from `theme/package.json` `image_sizes`.

- [ ] **Step 7: Extract the image-url helper to a shared module**

Create `site/src/lib/format.ts`:

```ts
const ghostImageWidths = {
  xxs: 30,
  xs: 100,
  s: 300,
  m: 600,
  l: 1000,
  xl: 2000,
} as const;

export type GhostImageSize = keyof typeof ghostImageWidths;

export function ghostImageUrl(src: string | null, size: GhostImageSize): string | null {
  if (!src) return null;
  if (!src.includes('/content/images/')) return src;
  return src.replace(
    '/content/images/',
    `/content/images/size/w${ghostImageWidths[size]}/`,
  );
}

export function isoDate(date: string): string {
  return new Date(date).toISOString().slice(0, 10);
}

export function shortDate(date: string): string {
  return new Date(date).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
}

export function monthYear(date: string): string {
  return new Date(date).toLocaleDateString('en-US', {
    month: 'short',
    year: 'numeric',
  });
}

export function readingTime(minutes: number | undefined): string | null {
  if (!minutes) return null;
  return `${minutes} min read`;
}
```

Now refactor `PostCard.astro` to use these helpers:

```astro
---
import type { GhostPost } from '~/lib/ghost.types';
import { ghostImageUrl, isoDate, shortDate, readingTime } from '~/lib/format';
import TagPill from './TagPill.astro';

interface Props {
  post: GhostPost;
}

const { post } = Astro.props;
const url = `/writing/${post.slug}/`;
const featureImage = ghostImageUrl(post.feature_image, 'm');
const excerpt = post.custom_excerpt ?? post.excerpt;
const readtime = readingTime(post.reading_time);
---

<article class={`post-card ${featureImage ? 'post-card-has-image' : ''}`}>
  {featureImage && (
    <div class="post-card-image-col">
      <a href={url} class="post-card-image-link">
        <img class="post-card-image" src={featureImage} alt={post.title} loading="lazy" />
      </a>
      <div class="post-card-meta">
        <TagPill tags={post.tags} />
        <span class="post-card-date">
          <time datetime={isoDate(post.published_at)}>{shortDate(post.published_at)}</time>
        </span>
      </div>
    </div>
  )}
  <div class="post-card-content">
    {!featureImage && (
      <div class="post-card-meta">
        <TagPill tags={post.tags} />
        <span class="post-card-date">
          <time datetime={isoDate(post.published_at)}>{shortDate(post.published_at)}</time>
        </span>
      </div>
    )}
    <a href={url}>
      <h3 class="post-card-title">{post.title}</h3>
    </a>
    {excerpt && <p class="post-card-excerpt">{excerpt}</p>}
    <div class="post-card-footer">
      {readtime && <span class="post-card-readtime">{readtime}</span>}
      <a href={url} class="post-card-read-link">Read <span>&rarr;</span></a>
    </div>
  </div>
</article>
```

- [ ] **Step 8: Create PostCardFeatured.astro**

Create `site/src/components/PostCardFeatured.astro`:

```astro
---
import type { GhostPost } from '~/lib/ghost.types';
import { ghostImageUrl, isoDate, shortDate, readingTime } from '~/lib/format';
import TagPill from './TagPill.astro';

interface Props {
  post: GhostPost;
}

const { post } = Astro.props;
const url = `/writing/${post.slug}/`;
const featureImage = ghostImageUrl(post.feature_image, 'l');
const excerpt = post.custom_excerpt ?? post.excerpt;
const readtime = readingTime(post.reading_time);
---

<article class={`post-card-featured ${featureImage ? 'post-card-featured-has-image' : ''}`}>
  {post.featured && <div class="featured-badge">&#9733; Featured</div>}
  {featureImage && (
    <a href={url} class="post-card-featured-image-link">
      <img class="post-card-featured-image" src={featureImage} alt={post.title} loading="lazy" />
    </a>
  )}
  <div class="post-card-meta">
    <TagPill tags={post.tags} />
    <span class="post-card-date">
      <time datetime={isoDate(post.published_at)}>{shortDate(post.published_at)}</time>
    </span>
    {readtime && <span class="post-card-readtime">{readtime}</span>}
  </div>
  <a href={url}>
    <h2 class="post-card-title">{post.title}</h2>
  </a>
  {excerpt && <p class="post-card-excerpt">{excerpt}</p>}
</article>
```

- [ ] **Step 9: Create SidebarPostLink.astro**

Create `site/src/components/SidebarPostLink.astro`:

```astro
---
import type { GhostPost } from '~/lib/ghost.types';

interface Props {
  post: GhostPost;
}

const { post } = Astro.props;
const url = `/writing/${post.slug}/`;
const teaser = post.custom_excerpt ?? post.excerpt;
---

<a href={url} class="sidebar-post-link">
  <span class="sidebar-post-title">{post.title}</span>
  {teaser && <span class="sidebar-post-teaser">{teaser}</span>}
</a>
```

- [ ] **Step 10: Create NowCard.astro**

Create `site/src/components/NowCard.astro` — port `theme/partials/now-card.hbs` literally, including the hardcoded "Independent / Domain Foundation / Kansas City" content.

```astro
<div class="now-card">
  <div class="now-card-header">
    <span class="now-card-dot"></span>
    <span class="now-card-label">NOW</span>
  </div>

  <div class="now-card-item">
    <div class="now-card-item-label">Status</div>
    <div class="now-card-item-value">Independent</div>
    <div class="now-card-item-sub">Available for consulting &amp; senior roles</div>
  </div>

  <div class="now-card-item">
    <div class="now-card-item-label">Building</div>
    <div class="now-card-item-value">Domain Foundation</div>
    <div class="now-card-item-sub">Consulting methodology</div>
  </div>

  <div class="now-card-item">
    <div class="now-card-item-label">Location</div>
    <div class="now-card-item-value">Kansas City</div>
  </div>

  <div class="now-card-footer">
    <a href="/now/" class="now-card-link">Full now page <span>&rarr;</span></a>
  </div>
</div>
```

- [ ] **Step 11: Create SubscribeCta.astro**

Create `site/src/components/SubscribeCta.astro`:

```astro
<section class="subscribe-cta-section">
  <h2 class="subscribe-cta-title">Subscribe to The Cocktail Napkin</h2>
  <p class="subscribe-cta-body">New writing, periodically. No spam, no schedule — just work and thinking as it comes together.</p>
  <div class="subscribe-cta-actions">
    <a href="/#/portal/signup" class="hero-cta">Subscribe</a>
  </div>
</section>
```

- [ ] **Step 12: Create a placeholder homepage so dev server can boot**

Create `site/src/pages/index.astro`:

```astro
---
import BaseLayout from '~/layouts/BaseLayout.astro';
---

<BaseLayout title="Jeremy Fuksa — placeholder">
  <main style="padding: 4rem; max-width: 720px; margin: 0 auto;">
    <h1>Astro skeleton boots.</h1>
    <p>Real homepage lands in Task 6.</p>
  </main>
</BaseLayout>
```

- [ ] **Step 13: Boot the dev server and verify visually**

Run: `cd site && pnpm dev`
Open `http://localhost:4321/` in a browser.
Expected: Header (with logo, name, nav links) and footer render with proper CSS, theme toggle works (click moon/sun), dark mode follows system preference.

Run `astro check`: `cd site && pnpm check`
Expected: 0 errors.

Compare the rendered header/footer side by side with `http://localhost:2368/` (the live Ghost theme). Visual parity should be near-perfect — same colors, fonts, spacing.

If anything looks off: the most likely culprit is the active-link class name (Step 2). Inspect element on the live site, find the active nav link's class, update `SiteHeader.astro`.

- [ ] **Step 14: Commit**

```bash
git add site/src/layouts site/src/components site/src/pages/index.astro site/src/lib/format.ts site/public/scripts
git commit -m "feat(site): port BaseLayout, header, footer, and shared post-card components"
```

---

## Task 5: Build the writing collection (post index, post detail, tag pages)

**Files:**
- Create: `site/src/pages/writing/index.astro`
- Create: `site/src/pages/writing/page/[page].astro`
- Create: `site/src/pages/writing/[slug].astro`
- Create: `site/src/pages/tag/[slug].astro`

This is the core Ghost-fed content. After this task, `/writing/`, `/writing/<slug>/`, and `/tag/<slug>/` all work end-to-end.

- [ ] **Step 1: Create the paginated writing index**

Create `site/src/pages/writing/index.astro`:

```astro
---
import BaseLayout from '~/layouts/BaseLayout.astro';
import PostCard from '~/components/PostCard.astro';
import { getAllPosts, getAllTags } from '~/lib/ghost';

const POSTS_PER_PAGE = 15;
const allPosts = await getAllPosts();
const allTags = await getAllTags();
const totalPages = Math.ceil(allPosts.length / POSTS_PER_PAGE);
const posts = allPosts.slice(0, POSTS_PER_PAGE);
---

<BaseLayout title="Writing — Jeremy Fuksa" description="Essays and notes on design, AI, and design systems.">
  <div class="writing-layout writing-layout-single">
    <div class="page-header">
      <div class="page-header-left">
        <h1>Writing</h1>
      </div>
      <span class="page-header-count">{allPosts.length} posts</span>
    </div>

    <div class="filter-bar">
      <a href="/writing/" class="filter-chip active">All</a>
      {allTags.map((tag) => (
        <a href={`/tag/${tag.slug}/`} class="filter-chip">{tag.name}</a>
      ))}
    </div>

    <main>
      {posts.map((post) => <PostCard post={post} />)}

      {totalPages > 1 && (
        <div class="pagination">
          <span class="page-number">Page 1 of {totalPages}</span>
          <a href="/writing/page/2/">Older &rarr;</a>
        </div>
      )}
    </main>
  </div>
</BaseLayout>
```

`POSTS_PER_PAGE = 15` matches `theme/package.json` `posts_per_page`.

- [ ] **Step 2: Create paginated subsequent pages**

Create `site/src/pages/writing/page/[page].astro`:

```astro
---
import type { GetStaticPaths } from 'astro';
import BaseLayout from '~/layouts/BaseLayout.astro';
import PostCard from '~/components/PostCard.astro';
import { getAllPosts, getAllTags } from '~/lib/ghost';

const POSTS_PER_PAGE = 15;

export const getStaticPaths = (async () => {
  const all = await getAllPosts();
  const totalPages = Math.ceil(all.length / POSTS_PER_PAGE);
  // Pages 2..N (page 1 is /writing/)
  const pages = [];
  for (let i = 2; i <= totalPages; i++) {
    pages.push({
      params: { page: String(i) },
      props: {
        pageNum: i,
        totalPages,
        posts: all.slice((i - 1) * POSTS_PER_PAGE, i * POSTS_PER_PAGE),
        totalCount: all.length,
      },
    });
  }
  return pages;
}) satisfies GetStaticPaths;

const { pageNum, totalPages, posts, totalCount } = Astro.props;
const allTags = await getAllTags();
const prevUrl = pageNum === 2 ? '/writing/' : `/writing/page/${pageNum - 1}/`;
const nextUrl = pageNum < totalPages ? `/writing/page/${pageNum + 1}/` : null;
---

<BaseLayout title={`Writing (page ${pageNum}) — Jeremy Fuksa`}>
  <div class="writing-layout writing-layout-single">
    <div class="page-header">
      <div class="page-header-left">
        <h1>Writing</h1>
      </div>
      <span class="page-header-count">{totalCount} posts</span>
    </div>

    <div class="filter-bar">
      <a href="/writing/" class="filter-chip">All</a>
      {allTags.map((tag) => (
        <a href={`/tag/${tag.slug}/`} class="filter-chip">{tag.name}</a>
      ))}
    </div>

    <main>
      {posts.map((post) => <PostCard post={post} />)}

      <div class="pagination">
        <a href={prevUrl}>&larr; Newer</a>
        <span class="page-number">Page {pageNum} of {totalPages}</span>
        {nextUrl && <a href={nextUrl}>Older &rarr;</a>}
      </div>
    </main>
  </div>
</BaseLayout>
```

- [ ] **Step 3: Create the single-post detail page**

Create `site/src/pages/writing/[slug].astro`. This is the biggest component — it ports `theme/post.hbs` (89 lines) including TOC sidebar, related posts, and the share/footer sections.

```astro
---
import type { GetStaticPaths } from 'astro';
import BaseLayout from '~/layouts/BaseLayout.astro';
import IconShare from '~/components/IconShare.astro';
import TagPill from '~/components/TagPill.astro';
import PostCard from '~/components/PostCard.astro';
import { getAllPosts } from '~/lib/ghost';
import { ghostImageUrl, isoDate, shortDate, readingTime } from '~/lib/format';
import type { GhostPost } from '~/lib/ghost.types';

export const getStaticPaths = (async () => {
  const posts = await getAllPosts();
  return posts.map((post) => ({
    params: { slug: post.slug },
    props: { post, allPosts: posts },
  }));
}) satisfies GetStaticPaths;

const { post, allPosts } = Astro.props as { post: GhostPost; allPosts: GhostPost[] };
const featureImage = ghostImageUrl(post.feature_image, 'l');
const ogImage = ghostImageUrl(post.feature_image, 'xl') ?? undefined;
const readtime = readingTime(post.reading_time);

const related = post.primary_tag
  ? allPosts
      .filter((p) => p.id !== post.id && p.tags.some((t) => t.slug === post.primary_tag!.slug))
      .slice(0, 3)
  : [];

const more = allPosts.filter((p) => p.id !== post.id).slice(0, 3);
---

<BaseLayout
  title={`${post.title} — Jeremy Fuksa`}
  description={post.custom_excerpt ?? post.excerpt}
  ogImage={ogImage}
>
  <header class="post-header">
    <a href="/writing/" class="post-header-back">&larr; All writing</a>
    <h1 class="post-header-title">{post.title}</h1>
    <div class="post-header-meta">
      <TagPill tags={post.tags} />
      <span class="post-card-date">
        <time datetime={isoDate(post.published_at)}>{shortDate(post.published_at)}</time>
      </span>
      {readtime && <span class="post-card-readtime">{readtime}</span>}
      <a class="post-share-inline" href="#/share" aria-label="Share this post">
        <IconShare />Share
      </a>
    </div>
    {post.custom_excerpt && <p class="post-header-excerpt">{post.custom_excerpt}</p>}
    {featureImage && (
      <figure class="post-header-image">
        <img src={featureImage} alt={post.title} />
        {post.feature_image_caption && (
          <figcaption set:html={post.feature_image_caption} />
        )}
      </figure>
    )}
    {post.primary_author && (
      <div class="post-header-byline">
        {post.primary_author.profile_image ? (
          <img class="post-header-avatar" src={post.primary_author.profile_image} alt={post.primary_author.name} />
        ) : (
          <div class="post-header-avatar"></div>
        )}
        <div>
          <div class="post-header-author-name">{post.primary_author.name}</div>
          {post.primary_author.bio && (
            <div class="post-header-author-role">{post.primary_author.bio}</div>
          )}
        </div>
      </div>
    )}
  </header>

  <div class="post-layout">
    <article class="post-content gh-content" set:html={post.html} />

    <aside class="post-sidebar">
      <div class="post-sidebar-title">On this page</div>
      <nav class="toc"></nav>

      {related.length > 0 && (
        <>
          <div class="post-sidebar-title">Related</div>
          {related.map((r) => (
            <div class="post-card">
              <a href={`/writing/${r.slug}/`}>
                <h4 class="post-card-title">{r.title}</h4>
              </a>
              <span class="post-card-date">{shortDate(r.published_at)}</span>
            </div>
          ))}
        </>
      )}
    </aside>
  </div>

  <section class="post-share" aria-label="Share">
    <div class="post-share-label">Enjoyed this?</div>
    <a class="post-share-cta" href="#/share">
      <IconShare />
      Share this post
    </a>
  </section>

  <footer class="post-footer">
    <div class="post-footer-title">More writing</div>
    {more.map((m) => <PostCard post={m} />)}
  </footer>
</BaseLayout>
```

The TOC is generated client-side by `main.js` from `<h2>` headings inside `.gh-content` — no server-side work needed. Same for the reading-progress bar.

`set:html={post.html}` injects Ghost's rendered HTML directly. Headings, code blocks, images all carry over because Ghost's renderer already produces clean HTML.

- [ ] **Step 4: Create the tag page**

Create `site/src/pages/tag/[slug].astro`:

```astro
---
import type { GetStaticPaths } from 'astro';
import BaseLayout from '~/layouts/BaseLayout.astro';
import PostCard from '~/components/PostCard.astro';
import { getAllTags, getPostsByTag } from '~/lib/ghost';

export const getStaticPaths = (async () => {
  const tags = await getAllTags();
  const out = await Promise.all(
    tags.map(async (tag) => ({
      params: { slug: tag.slug },
      props: {
        tag,
        posts: await getPostsByTag(tag.slug),
        allTags: tags,
      },
    })),
  );
  return out;
}) satisfies GetStaticPaths;

const { tag, posts, allTags } = Astro.props;
---

<BaseLayout title={`${tag.name} — Jeremy Fuksa`}>
  <div class="writing-layout writing-layout-single">
    <div class="page-header">
      <div class="page-header-left">
        <h1>{tag.name}</h1>
      </div>
      <span class="page-header-count">{posts.length} posts</span>
    </div>

    <div class="filter-bar">
      <a href="/writing/" class="filter-chip">All</a>
      {allTags.map((t) => (
        <a href={`/tag/${t.slug}/`} class={`filter-chip ${t.slug === tag.slug ? 'active' : ''}`}>{t.name}</a>
      ))}
    </div>

    <main>
      {posts.map((post) => <PostCard post={post} />)}
    </main>
  </div>
</BaseLayout>
```

- [ ] **Step 5: Boot dev server and verify**

Run: `cd site && pnpm dev`
Visit:
- `http://localhost:4321/writing/` — list of all posts, paginated to 15.
- `http://localhost:4321/writing/<slug>/` — pick any slug from the list. Body content renders. TOC populates. Reading-progress bar tracks. Theme toggle persists.
- `http://localhost:4321/writing/page/2/` (only if you have >15 posts)
- `http://localhost:4321/tag/<existing-tag>/` — filter chip shows active.

Compare each of the three views side-by-side with `http://localhost:2368/<same-url>/`. Visual parity expected.

- [ ] **Step 6: Run astro check**

Run: `cd site && pnpm check`
Expected: 0 errors. Type-check should pass cleanly with the strict tsconfig.

- [ ] **Step 7: Commit**

```bash
git add site/src/pages/writing site/src/pages/tag
git commit -m "feat(site): port writing index, post detail, and tag pages from Ghost templates"
```

---

## Task 6: Build the homepage

**Files:**
- Modify: `site/src/pages/index.astro` (replace placeholder)

The homepage composes hero, featured-work grid (hardcoded today, becoming a content-collection consumer in Task 7), latest post (featured or fallback), and previous posts sidebar. It's where the "headless" idea earns its keep — local content + Ghost data on one page.

- [ ] **Step 1: Replace placeholder with the full homepage**

Replace `site/src/pages/index.astro`:

```astro
---
import BaseLayout from '~/layouts/BaseLayout.astro';
import PostCardFeatured from '~/components/PostCardFeatured.astro';
import SidebarPostLink from '~/components/SidebarPostLink.astro';
import { getAllPosts } from '~/lib/ghost';

const allPosts = await getAllPosts();
const featuredPosts = allPosts.filter((p) => p.featured);
const heroPost = featuredPosts[0] ?? allPosts[0];
const sidebarPosts = (featuredPosts.length > 0 ? featuredPosts.slice(1, 6) : allPosts.slice(1, 6));
---

<BaseLayout
  title="Jeremy Fuksa — The Cocktail Napkin"
  description="Design systems, UX strategy, and what design practice becomes when AI does the making."
>
  <div class="home-bg">

  <section class="hero">
    <div class="hero-inner">
      <h1 class="hero-name">Jeremy Fuksa</h1>
      <p class="hero-positioning">I follow my creative thoughts wherever they take me. Right now they've got me figuring out what design practice becomes when AI does the making.</p>
    </div>
  </section>

  <section class="featured-work">
    <div class="featured-work-inner">
      <div class="featured-work-grid">
        <a href="/work/domain-foundation/" class="featured-work-card">
          <span class="featured-work-label">Methodology</span>
          <h2 class="featured-work-title">Domain Foundation</h2>
          <p class="featured-work-body">Encoding institutional design expertise as layered, machine-readable knowledge an AI can reason with. Because default models produce default output.</p>
          <span class="featured-work-link">Read the case study &rarr;</span>
        </a>

        <a href="/work/moonbird/" class="featured-work-card">
          <span class="featured-work-label">Case study</span>
          <h2 class="featured-work-title">Moonbird</h2>
          <p class="featured-work-body">A year inside Oracle Health figuring out what design practice becomes when AI does the making. The research that produced Domain Foundation.</p>
          <span class="featured-work-link">Read the case study &rarr;</span>
        </a>

        <a href="/work/redwood-health-design/" class="featured-work-card">
          <span class="featured-work-label">Case study</span>
          <h2 class="featured-work-title">Two Components That Didn't Ship</h2>
          <p class="featured-work-body">Health-specific components on Oracle's Redwood design system. The ones I remember best are the two we decided to kill.</p>
          <span class="featured-work-link">Read the case study &rarr;</span>
        </a>
      </div>
      <a href="/work/" class="featured-work-all">See all work &rarr;</a>
    </div>
  </section>

  <div class="home-writing-grid">
    <main>
      <span class="section-title">Latest</span>
      {heroPost && <PostCardFeatured post={heroPost} />}
    </main>

    <aside class="sidebar">
      <span class="section-title">Previous Writing</span>
      <nav class="sidebar-posts">
        {sidebarPosts.map((post) => <SidebarPostLink post={post} />)}
        <a href="/writing/" class="sidebar-posts-all">All posts &rarr;</a>
      </nav>
    </aside>
  </div>

  </div>
</BaseLayout>
```

The original homepage also pulled a `slug:testimonial` Ghost page and a `tag:hash-methodology` page collection. Decision: drop both for now — testimonial content moves to local MDX or inline if/when needed, and the methodology trio was speculative future content. If either turns out to be in active use on production, add them back as inline content in this file (we are explicitly moving non-post content out of Ghost).

Verify with the user / production site if either section is currently visible: `curl -s https://jeremyfuksa.com/ | grep -i 'testimonial\|methodology-trio'`. If present, port the content inline; if not, the simpler homepage above ships.

- [ ] **Step 2: Verify the moonbird URL**

The original `custom-home.hbs` links to `/moonbird/` (no `/work/` prefix), but `routes.yaml` registers it as `/work/moonbird/`. Verify by reading `theme/routes.yaml`:

```bash
grep moonbird theme/routes.yaml
```

This shows `routes:` has `/work/moonbird/`, so the homepage link `/moonbird/` is a Ghost-internal redirect or a typo. Use `/work/moonbird/` in the new site (consistent with all other case studies). The old `/moonbird/` path goes into the redirects map (Task 11).

- [ ] **Step 3: Visual diff against production**

Run: `cd site && pnpm dev`
Visit `http://localhost:4321/`. Compare side-by-side with `http://localhost:2368/` (live Ghost rendering).

Differences expected: testimonial and methodology trio absent (intentional). All else visually identical.

- [ ] **Step 4: Commit**

```bash
git add site/src/pages/index.astro
git commit -m "feat(site): port homepage with hero, featured work, and Ghost-fed latest posts"
```

---

## Task 7: Convert case studies to MDX content collection

**Files:**
- Create: `site/src/content/config.ts`
- Create: `site/src/content/case-studies/terra-design-system.mdx`
- Create: `site/src/content/case-studies/seven-years-in-healthcare-ux.mdx`
- Create: `site/src/content/case-studies/domain-foundation.mdx`
- Create: `site/src/content/case-studies/redwood-health-design.mdx`
- Create: `site/src/content/case-studies/moonbird.mdx`
- Create: `site/src/components/CaseStudyLayout.astro`
- Create: `site/src/pages/work/[slug].astro`

This is the architectural payoff. Five near-duplicate Handlebars templates collapse into one layout + five MDX content files with frontmatter.

- [ ] **Step 1: Define the content collection schema**

Create `site/src/content/config.ts`:

```ts
import { defineCollection, z } from 'astro:content';

const factSchema = z.object({
  label: z.string(),
  value: z.string(),
});

const statSchema = z.object({
  value: z.string(),
  label: z.string(),
});

const linkSchema = z.object({
  label: z.string(),
  href: z.string().url(),
});

const caseStudies = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    eyebrow: z.string(),         // e.g. "Systems work · 2018–2024"
    tagline: z.string(),         // HTML allowed for <em>
    role: z.string(),
    organization: z.string().optional(),
    timeline: z.string(),
    pullquote: z.string().optional(),
    facts: z.array(factSchema).optional(),
    stats: z.array(statSchema).optional(),
    links: z.array(linkSchema).optional(),
    readingTime: z.number().optional(),  // minutes; falls back to MDX-derived
    order: z.number(),                   // for /work/ list ordering
    excerpt: z.string(),                 // for og:description and /work/ list
  }),
});

export const collections = { 'case-studies': caseStudies };
```

- [ ] **Step 2: Extract case-study body content from drafts/**

The drafts directory has the source content for all five case studies. List them:

```bash
ls drafts/*.md
```

Expected output includes `domain-foundation.md`, `moonbird-case-study.md`, `redwood-health-design.md`, `seven-years-in-healthcare-ux.md`, `terra-design-system.md`.

These markdown files are the case-study *bodies* that get pasted into Ghost today. They become the MDX bodies directly — no rewriting.

- [ ] **Step 3: Create terra-design-system.mdx**

Create `site/src/content/case-studies/terra-design-system.mdx`:

```mdx
---
title: "Terra Design System"
eyebrow: "Systems work · 2018–2024"
tagline: "Healthcare UI components don't get to be approximately right. Three and a half years closing the gap between the standard and what the engineer built in good faith."
role: "UX Designer → UX Design Manager"
organization: "Cerner / Oracle Health"
timeline: "2018–2024"
order: 5
excerpt: "Open-source React component library. 80+ components, 200+ icons, WCAG 2.1 AA. Built and led at Cerner / Oracle Health."
stats:
  - { value: "80+", label: "React components" }
  - { value: "200+", label: "Icons" }
  - { value: "1,500", label: "Healthcare orgs" }
  - { value: "195", label: "Countries" }
  - { value: "125+", label: "Design standards" }
  - { value: "150+", label: "A11y guidelines" }
links:
  - { label: "GitHub: terra-core ↗", href: "https://github.com/cerner/terra-core" }
  - { label: "GitHub: terra-framework ↗", href: "https://github.com/cerner/terra-framework" }
  - { label: "GitHub: one-cerner-style-icons ↗", href: "https://github.com/oracle-samples/one-cerner-style-icons" }
  - { label: "Engineering blog: One Cerner Style Icons ↗", href: "https://engineering.cerner.com/blog/one-cerner-style-icons/" }
---

import { contents of drafts/terra-design-system.md here }
```

For the body, copy `drafts/terra-design-system.md` content (everything except its own frontmatter, if any) directly under the closing `---`. That's the case-study prose.

Concretely, run:

```bash
cat drafts/terra-design-system.md
```

Read its content, strip any leading frontmatter or H1 (the H1 becomes redundant since the layout renders `title` as the page H1), and paste the rest below the frontmatter in the `.mdx` file.

- [ ] **Step 4: Create seven-years-in-healthcare-ux.mdx**

Create `site/src/content/case-studies/seven-years-in-healthcare-ux.mdx`:

```mdx
---
title: "Seven Years in Healthcare UX"
eyebrow: "Leadership · 2018–2026"
tagline: "Twelve reports across eight locations and three continents, two years with no promotions on the table, and one closing question that kept the conversations honest."
role: "UX Designer → Senior UX Designer → UX Design Manager"
organization: "Cerner / Oracle Health"
timeline: "2018–2026"
order: 4
excerpt: "Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition."
facts:
  - { label: "Reports", value: "12 → 5 (attrition + restructuring)" }
  - { label: "Distribution", value: "8 locations, 3 continents" }
  - { label: "Drought", value: "2 years with no promotions available" }
  - { label: "Outcome", value: "3 promotions earned during the drought" }
---

{ body content from drafts/seven-years-in-healthcare-ux.md }
```

- [ ] **Step 5: Create domain-foundation.mdx**

Create `site/src/content/case-studies/domain-foundation.mdx`:

```mdx
---
title: "Domain Foundation"
eyebrow: "Methodology · 2025–ongoing"
tagline: "Encode institutional knowledge as layers, each owned by the role that produces it, and let the model compose from all of them at generation time."
role: "Creator and primary researcher"
timeline: "2025–ongoing"
order: 1
excerpt: "Encoding institutional design expertise as layered, machine-readable knowledge an AI can reason with."
facts:
  - { label: "Layers", value: "Universal · Domain · Component · Role" }
  - { label: "Architecture", value: "Vector DB + MCP server + LLM" }
  - { label: "Pivot", value: "In-Figma metadata → retrievable knowledge base" }
  - { label: "Origin", value: "Winter break 2025–2026" }
---

{ body content from drafts/domain-foundation.md }
```

- [ ] **Step 6: Create redwood-health-design.mdx**

Create `site/src/content/case-studies/redwood-health-design.mdx`:

```mdx
---
title: "Two Components That Didn't Ship"
eyebrow: "Systems work · 2024–2026"
tagline: "Two components shipped. Two we'd already designed and decided to kill. The decisions about what <em>not</em> to build were the work."
role: "UX Designer, Redwood Health Design team"
organization: "Oracle Health (Redwood Design System)"
timeline: "2024–2026"
order: 3
excerpt: "Health-specific components on Oracle's Redwood design system. The ones I remember best are the two we decided to kill."
facts:
  - { label: "Shipped", value: "Page Summary, Object ID, health-aware timestamp" }
  - { label: "Descoped", value: "Name truncator, pronoun notification" }
  - { label: "Team", value: "6-person Health Design inside ~100-person Redwood org" }
links:
  - { label: "Redwood design system ↗", href: "https://redwood.oracle.com/" }
---

{ body content from drafts/redwood-health-design.md }
```

- [ ] **Step 7: Create moonbird.mdx**

Create `site/src/content/case-studies/moonbird.mdx`:

```mdx
---
title: "Moonbird"
eyebrow: "Research · 2025–2026"
tagline: "The opening question was defensive: how do we keep a non-designer from generating something that doesn't match our design system. Answering that tells you what <em>not</em> to allow, not what to build."
role: "UX Designer, AI design research"
organization: "Oracle Health"
timeline: "2025–2026"
order: 2
excerpt: "A year inside Oracle Health figuring out what design practice becomes when AI does the making. The research that produced Domain Foundation."
pullquote: "The first thing said, in the first meeting, was that AI in the hands of engineering and PM was going to take our jobs."
---

{ body content from drafts/moonbird-case-study.md }
```

- [ ] **Step 8: Create the CaseStudyLayout component**

Create `site/src/components/CaseStudyLayout.astro`:

```astro
---
import IconShare from './IconShare.astro';
import SubscribeCta from './SubscribeCta.astro';
import { readingTime } from '~/lib/format';

interface Props {
  title: string;
  eyebrow: string;
  tagline: string;
  role: string;
  organization?: string;
  timeline: string;
  pullquote?: string;
  facts?: { label: string; value: string }[];
  stats?: { value: string; label: string }[];
  links?: { label: string; href: string }[];
  readingMinutes?: number;
}

const {
  title,
  eyebrow,
  tagline,
  role,
  organization,
  timeline,
  pullquote,
  facts,
  stats,
  links,
  readingMinutes,
} = Astro.props;

const readtime = readingTime(readingMinutes);
---

<div class="casestudy-page">
  <a href="/work/" class="casestudy-back">← Work</a>

  <header class="casestudy-header">
    <div class="casestudy-eyebrow">{eyebrow}</div>
    <h1 class="casestudy-title">{title}</h1>
    <p class="casestudy-tagline" set:html={tagline}></p>
    <div class="post-header-meta">
      {readtime && <span class="post-card-readtime">{readtime}</span>}
      <a class="post-share-inline" href="#/share" aria-label="Share this case study">
        <IconShare />Share
      </a>
    </div>
  </header>

  <div class="casestudy-body">
    <div class="casestudy-prose gh-content">
      <slot />
    </div>

    <aside class="casestudy-sidebar">
      <div class="cs-meta-group">
        <div class="cs-meta-label">Role</div>
        <div class="cs-meta-value">{role}</div>
      </div>
      {organization && (
        <div class="cs-meta-group">
          <div class="cs-meta-label">Organization</div>
          <div class="cs-meta-value">{organization}</div>
        </div>
      )}
      <div class="cs-meta-group">
        <div class="cs-meta-label">Timeline</div>
        <div class="cs-meta-value">{timeline}</div>
      </div>

      {stats && stats.length > 0 && (
        <>
          <hr class="cs-divider" />
          <div class="cs-stats">
            {stats.map((s) => (
              <div class="cs-stat">
                <div class="cs-stat-value">{s.value}</div>
                <div class="cs-stat-label">{s.label}</div>
              </div>
            ))}
          </div>
        </>
      )}

      {facts && facts.length > 0 && (
        <>
          <hr class="cs-divider" />
          <dl class="cs-fact-list">
            {facts.map((f) => (
              <div>
                <dt>{f.label}</dt>
                <dd>{f.value}</dd>
              </div>
            ))}
          </dl>
        </>
      )}

      {pullquote && (
        <>
          <hr class="cs-divider" />
          <blockquote class="cs-pullquote">{pullquote}</blockquote>
        </>
      )}

      {links && links.length > 0 && (
        <>
          <hr class="cs-divider" />
          {links.map((l) => (
            <a href={l.href} class="cs-link" target="_blank" rel="noopener">{l.label}</a>
          ))}
        </>
      )}
    </aside>
  </div>

  <section class="post-share" aria-label="Share">
    <div class="post-share-label">Enjoyed this?</div>
    <a class="post-share-cta" href="#/share">
      <IconShare />
      Share this case study
    </a>
  </section>

  <SubscribeCta />
</div>
```

Note `gh-content` class is added to the prose container so `main.js` picks up TOC and reading-progress on case studies the same way it does on posts.

- [ ] **Step 9: Create the dynamic case-study page**

Create `site/src/pages/work/[slug].astro`:

```astro
---
import type { GetStaticPaths } from 'astro';
import { getCollection } from 'astro:content';
import BaseLayout from '~/layouts/BaseLayout.astro';
import CaseStudyLayout from '~/components/CaseStudyLayout.astro';

export const getStaticPaths = (async () => {
  const studies = await getCollection('case-studies');
  return studies.map((entry) => ({
    params: { slug: entry.slug },
    props: { entry },
  }));
}) satisfies GetStaticPaths;

const { entry } = Astro.props;
const { Content, remarkPluginFrontmatter } = await entry.render();
const readingMinutes =
  entry.data.readingTime ?? remarkPluginFrontmatter?.minutesRead;
---

<BaseLayout
  title={`${entry.data.title} — Jeremy Fuksa`}
  description={entry.data.excerpt}
>
  <CaseStudyLayout
    title={entry.data.title}
    eyebrow={entry.data.eyebrow}
    tagline={entry.data.tagline}
    role={entry.data.role}
    organization={entry.data.organization}
    timeline={entry.data.timeline}
    pullquote={entry.data.pullquote}
    facts={entry.data.facts}
    stats={entry.data.stats}
    links={entry.data.links}
    readingMinutes={readingMinutes}
  >
    <Content />
  </CaseStudyLayout>
</BaseLayout>
```

`remarkPluginFrontmatter?.minutesRead` is populated only if you've added a remark reading-time plugin. Don't add one — fall back to `entry.data.readingTime` from frontmatter (set manually in MDX) or omit. The runtime check handles both cases.

- [ ] **Step 10: Verify dev server renders all five case studies**

Run: `cd site && pnpm dev`
Visit each:
- `http://localhost:4321/work/domain-foundation/`
- `http://localhost:4321/work/moonbird/`
- `http://localhost:4321/work/redwood-health-design/`
- `http://localhost:4321/work/seven-years-in-healthcare-ux/`
- `http://localhost:4321/work/terra-design-system/`

Each should render header, sidebar (with appropriate facts/stats/links), prose body, share section, subscribe CTA. Side-by-side compare with `http://localhost:2368/work/<slug>/`.

- [ ] **Step 11: Run astro check**

Run: `cd site && pnpm check`
Expected: 0 errors. Content collection schemas validate at build time — any frontmatter mismatch shows up here.

- [ ] **Step 12: Commit**

```bash
git add site/src/content site/src/components/CaseStudyLayout.astro site/src/pages/work/[slug].astro
git commit -m "feat(site): convert case studies to MDX content collection with shared layout"
```

---

## Task 8: Build the work index page

**Files:**
- Create: `site/src/pages/work/index.astro`

The work index lists all five case studies in `order` ascending, plus the "Work with me" CTA.

- [ ] **Step 1: Create the work index**

Create `site/src/pages/work/index.astro`:

```astro
---
import { getCollection } from 'astro:content';
import BaseLayout from '~/layouts/BaseLayout.astro';

const studies = (await getCollection('case-studies')).sort(
  (a, b) => a.data.order - b.data.order,
);
---

<BaseLayout title="Work — Jeremy Fuksa" description="Selected case studies in design systems, healthcare UX, and AI-augmented design.">
  <div class="work-page">
    <header class="work-header">
      <h1>Work</h1>
      <p class="work-intro">Selected case studies — design systems, healthcare UX, and the research that became Domain Foundation.</p>
    </header>

    <div class="work-list">
      {studies.map((s) => (
        <a href={`/work/${s.slug}/`} class="work-row">
          <div class="work-row-meta">{s.data.eyebrow}</div>
          <div class="work-row-title">{s.data.title}</div>
          <div class="work-row-excerpt">{s.data.excerpt}</div>
        </a>
      ))}
    </div>

    <section id="work-with-me" class="work-cta-section">
      <h2 class="work-cta-title">Work with me</h2>
      <p class="work-cta-body">Available for design system engagements, UX strategy consulting, and senior design leadership roles. Based in Kansas City, working with teams anywhere.</p>
      <div class="work-cta-actions">
        <a href="mailto:hello@jeremyfuksa.com" class="hero-cta">Get in touch</a>
        <a href="/about/" class="hero-cta-secondary">About me &rarr;</a>
      </div>
    </section>
  </div>
</BaseLayout>
```

The `eyebrow` carries the meta string (e.g. "Methodology · 2025–ongoing") — it replaces the original `work-row-meta` line. Layout matches `theme/custom-work.hbs` lines 24–50.

- [ ] **Step 2: Verify all five rows appear in expected order**

Run: `cd site && pnpm dev`
Visit `http://localhost:4321/work/`.
Order should be: 1 Domain Foundation, 2 Moonbird, 3 Redwood Health Design, 4 Seven Years in Healthcare UX, 5 Terra Design System (matches the `order` frontmatter values from Task 7).

Compare with `http://localhost:2368/work/`. Visual parity expected.

- [ ] **Step 3: Commit**

```bash
git add site/src/pages/work/index.astro
git commit -m "feat(site): port work index page driven by case-studies collection"
```

---

## Task 9: Build the now and about pages

**Files:**
- Create: `site/src/pages/now.astro`
- Create: `site/src/pages/about.astro`

Both pages currently get hardcoded content from `custom-now.hbs` and `page-about.hbs`. They become plain Astro pages.

- [ ] **Step 1: Create now.astro**

Create `site/src/pages/now.astro`. Port `theme/custom-now.hbs` literally — replace `{{date format="MMM YYYY"}}` with a build-time computed string, and keep the section structure (Work, Building, Listening, Watching, Radio):

```astro
---
import BaseLayout from '~/layouts/BaseLayout.astro';
import { monthYear } from '~/lib/format';

const updated = monthYear(new Date().toISOString());
---

<BaseLayout
  title="Now — Jeremy Fuksa"
  description="What I'm working on, building, and paying attention to right now."
>
  <div class="now-page">
    <h1>Now</h1>
    <div class="now-page-updated">
      <span class="now-page-dot"></span>
      <span>Updated {updated} · Kansas City</span>
    </div>

    <p class="now-page-intro">I got laid off from Oracle in early 2026. After eight years of enterprise pace, the open schedule takes some getting used to. I'm using it to tinker, write, and pay attention to things I haven't had time for in a while.</p>
    <hr class="now-page-divider" />

    <section class="now-section">
      <div class="now-section-header">
        <span class="now-section-label">Work</span>
        <hr class="now-section-rule" />
      </div>
      <div class="now-item">
        <div class="now-item-label">Status</div>
        <div>
          <div class="now-item-value">Independent <span class="now-status now-status-active">Active</span></div>
          <div class="now-item-sub">Laid off from Oracle in early 2026</div>
        </div>
      </div>
      <div class="now-item">
        <div class="now-item-label">Looking for</div>
        <div>
          <div class="now-item-value">UX Director or senior design leadership, or consulting</div>
          <div class="now-item-sub">Design systems, AI-augmented design process, and the messy middle where institutional knowledge has to keep up with the tooling</div>
        </div>
      </div>
    </section>

    <section class="now-section">
      <div class="now-section-header">
        <span class="now-section-label">Building</span>
        <hr class="now-section-rule" />
      </div>
      <div class="now-item">
        <div class="now-item-label">This site</div>
        <div>
          <div class="now-item-value">The Cocktail Napkin</div>
          <div class="now-item-sub">Writing more than I have in years</div>
        </div>
      </div>
      <div class="now-item">
        <div class="now-item-label">Software</div>
        <div>
          <div class="now-item-value">Bear Paw</div>
          <div class="now-item-sub">Cross-platform control and telemetry system for Uniden analog scanners. Personal project, scratch-my-own-itch.</div>
        </div>
      </div>
      <div class="now-item">
        <div class="now-item-label">Hardware</div>
        <div>
          <div class="now-item-value">An idea on the breadboard</div>
          <div class="now-item-sub">More when it works</div>
        </div>
      </div>
      <div class="now-item">
        <div class="now-item-label">Otherwise</div>
        <div>
          <div class="now-item-value">Puttering around the house and trying to be cool</div>
        </div>
      </div>
    </section>

    <section class="now-section">
      <div class="now-section-header">
        <span class="now-section-label">Listening</span>
        <hr class="now-section-rule" />
      </div>
      <div class="now-item">
        <div class="now-item-label">Project</div>
        <div>
          <div class="now-item-value">Breaking the algorithm</div>
          <div class="now-item-sub">Trying to get Apple Music to introduce me to music that's just outside of my algorithm's Venn diagram</div>
        </div>
      </div>
    </section>

    <section class="now-section">
      <div class="now-section-header">
        <span class="now-section-label">Watching</span>
        <hr class="now-section-rule" />
      </div>
      <div class="now-item">
        <div class="now-item-label">British TV run</div>
        <div>
          <div class="now-item-value"><em>Saturday Night Live UK</em>, <em>Toast of London</em> (again), <em>Toast of Tinseltown</em>, <em>The Cleaner</em> (again), <em>Riot Women</em>, <em>The IT Crowd</em> (again)</div>
        </div>
      </div>
    </section>

    <section class="now-section">
      <div class="now-section-header">
        <span class="now-section-label">Radio</span>
        <hr class="now-section-rule" />
      </div>
      <div class="now-item">
        <div class="now-item-label">Callsign</div>
        <div>
          <div class="now-item-value">KF0NUI</div>
          <div class="now-item-sub">Amateur radio is a seasonal interest for me — storm season is approaching in Kansas City, so it's becoming that season again</div>
        </div>
      </div>
    </section>

    <div class="now-footer-note">
      <p>This is a <a href="https://nownownow.com/about">now page</a>. If you have your own site, you should make one too.</p>
    </div>
  </div>
</BaseLayout>
```

`monthYear` was added to `format.ts` in Task 4 step 7. The displayed date now updates automatically on every build — when the user wants to update Now content, they edit this file and rebuild.

- [ ] **Step 2: Create about.astro**

Create `site/src/pages/about.astro`. Port `theme/page-about.hbs`. The body content comes from the live Ghost about page — the user needs to provide it or we extract from production.

To extract the current about-page body:

```bash
curl -s https://jeremyfuksa.com/about/ | grep -A 9999 'about-prose' | head -200
```

Then strip the surrounding HTML (the `<div class="gh-content about-prose">` wrapper and everything outside it). Paste the body inside the `<div class="gh-content about-prose">` slot below.

```astro
---
import BaseLayout from '~/layouts/BaseLayout.astro';
---

<BaseLayout
  title="About — Jeremy Fuksa"
  description="Designer, design systems engineer, occasional radio operator. Based in Kansas City."
>
  <article class="about-page">
    <header class="about-header">
      <h1>About</h1>
      <p class="about-lede">{/* lede sentence — extract from current production /about/ page */}</p>
    </header>

    <div class="about-layout">
      <div class="gh-content about-prose">
        {/* Body prose — paste from current production /about/ page */}
      </div>

      <aside class="about-sidebar">
        <div class="about-sidebar-block">
          <div class="about-sidebar-label">Based in</div>
          <div class="about-sidebar-value">Kansas City, MO</div>
        </div>
        <div class="about-sidebar-block">
          <div class="about-sidebar-label">Practice</div>
          <div class="about-sidebar-value">Design systems, UX strategy, AI-augmented design</div>
        </div>
        <div class="about-sidebar-block">
          <div class="about-sidebar-label">Elsewhere</div>
          <ul class="about-sidebar-links">
            <li><a href="/writing/">Writing</a></li>
            <li><a href="/work/">Work</a></li>
            <li><a href="/now/">Now</a></li>
            <li><a href="https://linkedin.com/in/jeremyfuksa">LinkedIn</a></li>
            <li><a href="https://github.com/jeremyfuksa">GitHub</a></li>
          </ul>
        </div>
      </aside>
    </div>

    <section id="work-with-me" class="about-cta-section">
      <h2 class="about-cta-title">Work with me</h2>
      <p class="about-cta-body">Available for design system engagements, UX strategy consulting, and senior design leadership roles. Working with teams anywhere.</p>
      <div class="about-cta-actions">
        <a href="mailto:hello@jeremyfuksa.com" class="hero-cta">Get in touch</a>
        <a href="/work/" class="hero-cta-secondary">See my work &rarr;</a>
      </div>
    </section>
  </article>
</BaseLayout>
```

**Required before commit:** the `{/* paste from production */}` comment must be replaced with real prose. Pull from production via the curl command above, or have the user paste their preferred about copy.

- [ ] **Step 3: Verify both pages**

Run: `cd site && pnpm dev`
Visit `http://localhost:4321/now/` and `http://localhost:4321/about/`.

- [ ] **Step 4: Commit**

```bash
git add site/src/pages/now.astro site/src/pages/about.astro
git commit -m "feat(site): port now and about pages as static Astro routes"
```

---

## Task 10: Add RSS feed and 404 page

**Files:**
- Create: `site/src/pages/rss.xml.ts`
- Create: `site/src/pages/404.astro`

The existing site exposes `/rss/` (Ghost's default). Match it.

- [ ] **Step 1: Verify Ghost's current RSS URL**

Run: `curl -sI https://jeremyfuksa.com/rss/ | head -3`
Expected: 200 OK, content-type RSS XML.

If the URL is `/rss/` (with trailing slash), we'll emit at `/rss.xml` and add a redirect from `/rss/` (Task 11).

- [ ] **Step 2: Create the RSS feed endpoint**

Create `site/src/pages/rss.xml.ts`:

```ts
import rss from '@astrojs/rss';
import type { APIContext } from 'astro';
import { getAllPosts } from '~/lib/ghost';

export async function GET(context: APIContext) {
  const posts = await getAllPosts();
  return rss({
    title: 'The Cocktail Napkin — Jeremy Fuksa',
    description: 'Essays and notes on design, AI, and design systems.',
    site: context.site!,
    items: posts.map((post) => ({
      title: post.title,
      description: post.custom_excerpt ?? post.excerpt,
      pubDate: new Date(post.published_at),
      link: `/writing/${post.slug}/`,
      content: post.html,
    })),
    customData: '<language>en-us</language>',
  });
}
```

- [ ] **Step 3: Create 404.astro**

Create `site/src/pages/404.astro`:

```astro
---
import BaseLayout from '~/layouts/BaseLayout.astro';
---

<BaseLayout title="Not found — Jeremy Fuksa">
  <div class="error-page">
    <div class="error-glyph" style="--logo-glyph: url('/images/flame.svg')" aria-hidden="true"></div>
    <h1 class="error-code">404</h1>
    <p class="error-message">That page didn't make it.</p>
    <a href="/" class="error-link">Back to home &rarr;</a>
  </div>
</BaseLayout>
```

- [ ] **Step 4: Verify**

Run: `cd site && pnpm build && pnpm preview`

Visit `http://localhost:4321/rss.xml` — XML feed should validate (paste into https://validator.w3.org/feed/ if needed).

Visit `http://localhost:4321/this-page-does-not-exist/` — 404 page renders. Note: in dev mode 404 doesn't render the same as in preview/static-host mode; the build+preview is the truthful test.

- [ ] **Step 5: Commit**

```bash
git add site/src/pages/rss.xml.ts site/src/pages/404.astro
git commit -m "feat(site): add RSS feed and 404 page"
```

---

## Task 11: Build the redirects map for legacy URLs

**Files:**
- Create: `site/src/redirects.json`
- Modify: `site/astro.config.mjs`
- Create: `site/tests/redirects.test.ts`

The current site has at least one bare-prefix URL (`/moonbird/`) and a Ghost-served `/rss/` URL. Build a centralized redirects map and wire it into Astro's static redirect support.

- [ ] **Step 1: Inventory legacy URLs**

Audit every internal link in `theme/` files for paths that won't exist on the new site:

```bash
grep -rohE 'href="/[a-z0-9/-]+/"' theme/ | sort -u
```

Cross-reference each with the new Astro route map. Likely candidates needing redirects:
- `/moonbird/` → `/work/moonbird/` (typo / convenience link in `custom-home.hbs`)
- `/rss/` → `/rss.xml`

Plus any URL the Ghost site has been serving that doesn't have an Astro equivalent: page slugs that were redirected via `page.hbs` (the `<meta refresh>` redirect from `/page/...` to `/about/`).

- [ ] **Step 2: Write the failing redirect test**

Create `site/tests/redirects.test.ts`:

```ts
import { describe, expect, it } from 'vitest';
import redirects from '../src/redirects.json';

describe('redirects', () => {
  it('redirects legacy /moonbird/ to /work/moonbird/', () => {
    expect(redirects['/moonbird/']).toBe('/work/moonbird/');
  });

  it('redirects /rss/ to /rss.xml', () => {
    expect(redirects['/rss/']).toBe('/rss.xml');
  });

  it('all redirect targets are absolute paths starting with /', () => {
    for (const target of Object.values(redirects)) {
      expect(target).toMatch(/^\//);
    }
  });

  it('no redirect target is also a redirect source (no chains)', () => {
    const sources = new Set(Object.keys(redirects));
    for (const target of Object.values(redirects)) {
      expect(sources.has(target)).toBe(false);
    }
  });
});
```

- [ ] **Step 3: Run test to verify it fails**

Run: `cd site && pnpm vitest run tests/redirects.test.ts`
Expected: FAIL with `Cannot find module '../src/redirects.json'`.

- [ ] **Step 4: Create the redirects JSON**

Create `site/src/redirects.json`:

```json
{
  "/moonbird/": "/work/moonbird/",
  "/rss/": "/rss.xml"
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `cd site && pnpm vitest run tests/redirects.test.ts`
Expected: All 4 tests pass.

- [ ] **Step 6: Wire redirects into astro.config.mjs**

Modify `site/astro.config.mjs`:

```js
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import redirects from './src/redirects.json' with { type: 'json' };

export default defineConfig({
  site: 'https://jeremyfuksa.com',
  output: 'static',
  trailingSlash: 'always',
  build: {
    format: 'directory',
  },
  redirects,
  integrations: [mdx(), sitemap()],
});
```

`with { type: 'json' }` is the standard JSON import attribute (Node 22+). If your Node version errors on this, fall back to:

```js
import { readFileSync } from 'node:fs';
const redirects = JSON.parse(readFileSync('./src/redirects.json', 'utf8'));
```

- [ ] **Step 7: Verify redirects build correctly**

Run: `cd site && pnpm build`
Expected: Build output in `site/dist/` includes `moonbird/index.html` and `rss/index.html` containing `<meta http-equiv="refresh">` redirects.

Run: `cd site && pnpm preview`
Visit `http://localhost:4321/moonbird/` — should redirect to `/work/moonbird/`.

- [ ] **Step 8: Commit**

```bash
git add site/src/redirects.json site/astro.config.mjs site/tests/redirects.test.ts
git commit -m "feat(site): add redirects map for legacy URLs with contract tests"
```

---

## Task 12: Site-wide build verification and parity audit

**Files:**
- Create: `docs/superpowers/specs/2026-04-25-astro-parity-audit.md` (audit findings)

Before declaring the migration complete, do a full rendered build and a page-by-page comparison.

- [ ] **Step 1: Full production build**

Run: `cd site && pnpm build`
Expected: build completes with 0 errors. Note any warnings.

Inspect `site/dist/` directory structure:

```bash
find site/dist -type f -name '*.html' | sort
```

Expected paths (at minimum):
- `dist/index.html`
- `dist/about/index.html`
- `dist/now/index.html`
- `dist/work/index.html`
- `dist/work/<each-case-study>/index.html` (5)
- `dist/writing/index.html`
- `dist/writing/<each-post>/index.html`
- `dist/tag/<each-tag>/index.html`
- `dist/404.html`
- `dist/rss.xml`
- `dist/sitemap-index.xml`
- `dist/moonbird/index.html` (redirect)
- `dist/rss/index.html` (redirect)

- [ ] **Step 2: Run all checks**

Run in parallel:
- `cd site && pnpm check` — TypeScript check
- `cd site && pnpm vitest run` — full test suite

Expected: 0 errors across both.

- [ ] **Step 3: Run preview server**

Run: `cd site && pnpm preview`
Server runs at `http://localhost:4321/`. This serves the actual built output, not dev-mode hot-reload — the truthful representation of what gets deployed.

- [ ] **Step 4: Page-by-page parity audit**

Open two browsers side-by-side: Astro on `http://localhost:4321/` (preview) and Ghost on `http://localhost:2368/`.

Visit and compare every URL:

```
/                                 — homepage
/writing/                         — writing index
/writing/<5 random posts>         — post details, including ones with feature images, code blocks, blockquotes
/writing/page/2/                  — paginated index (skip if <16 posts)
/tag/<3 random tags>/             — tag pages
/work/                            — work index
/work/domain-foundation/
/work/moonbird/
/work/redwood-health-design/
/work/seven-years-in-healthcare-ux/
/work/terra-design-system/        — all 5 case studies
/now/
/about/
/404 (or any /nope/ URL)
```

For each: spot-check fonts, colors, spacing, hover states, dark-mode toggle, theme persistence, mobile breakpoints (resize browser), TOC scroll-spy on long posts, reading-progress bar.

Document discrepancies in `docs/superpowers/specs/2026-04-25-astro-parity-audit.md` as a punch list. Each item: page, observed difference, expected, severity (blocker / cosmetic / acceptable-divergence).

- [ ] **Step 5: Resolve any blockers found**

For each blocker, create a follow-up task in this plan or fix inline. Re-run audit after each fix.

Cosmetic and acceptable-divergence items go into a follow-up plan.

- [ ] **Step 6: Run gscan-equivalent for Astro (lighthouse-style audit)**

Optional but recommended. From `site/`:

```bash
pnpm dlx @lhci/cli@latest autorun --collect.staticDistDir=./dist --collect.numberOfRuns=1 --upload.target=temporary-public-storage 2>/dev/null || \
  npx lighthouse http://localhost:4321/ --output=html --output-path=./lighthouse-home.html --view
```

Target: Performance > 95, Accessibility > 95, Best Practices > 95, SEO > 95 — homepage and a typical post.

- [ ] **Step 7: Commit audit document**

```bash
git add docs/superpowers/specs/2026-04-25-astro-parity-audit.md
git commit -m "docs: parity audit results for Astro migration"
```

---

## Task 13: Documentation and dev-loop updates

**Files:**
- Modify: `CLAUDE.md`
- Modify: `README.md`
- Create: `site/README.md`

Update the existing project docs to reflect the dual-system reality (Ghost backend + Astro frontend) until the cutover is decided.

- [ ] **Step 1: Create site/README.md**

Create `site/README.md`:

```markdown
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
```

- [ ] **Step 2: Update root README.md**

Read the current `README.md` and append a new section after the existing intro:

```markdown
## Architecture (April 2026 onward)

This repo contains two systems:

- **`theme/`** — the original Ghost Handlebars theme. Still functional; will be retired once the Astro site cuts over to production.
- **`site/`** — an Astro static site that consumes Ghost as a headless content source for posts only. All other pages (home, work, case studies, now, about) live as Astro routes / MDX files.

Until cutover, both systems can run concurrently:
- Ghost dev: `docker compose up -d` → `http://localhost:2368/`
- Astro dev: `cd site && pnpm dev` → `http://localhost:4321/`

See [site/README.md](./site/README.md) for the Astro workflow.
```

- [ ] **Step 3: Update CLAUDE.md**

Modify `CLAUDE.md` — add a new section near the top (after "Project Overview"), and adjust the "Development Workflow" section.

Replace the "Project Overview" section with:

```markdown
## Project Overview

This repo contains two coexisting systems for jeremyfuksa.com during a migration to a headless architecture:

- **`theme/`** — the original "The Cocktail Napkin" Ghost 6 Handlebars theme. No build step; CSS and JS served directly. Deployed as a zip to Ghost Admin (or via the Admin API).
- **`site/`** — an Astro static site consuming Ghost as a headless source for posts. All non-post content (home, work, case studies, now, about) is local. Build with `cd site && pnpm build`.

The end state is the Astro site in production with Ghost serving as a content-only backend. The Handlebars theme remains in the repo until cutover, then gets archived.
```

In the "Development Workflow" section, add:

```markdown
### Astro frontend (site/)

For pages outside the writing collection, work in `site/`:

```bash
cd site
pnpm dev          # http://localhost:4321/
pnpm test
pnpm build
```

The Astro site fetches posts from the local Docker Ghost via Content API. See `site/README.md`.
```

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.md README.md site/README.md
git commit -m "docs: document the dual Ghost-theme + Astro-site architecture during migration"
```

---

## Task 14: Vestigial cleanup inventory and removal

**Files:**
- Create: `docs/superpowers/specs/2026-04-25-astro-vestigial-inventory.md`
- Modify: `package.json` (root) — likely remove campfire sync script
- Modify: `.gitignore` — remove rules for now-defunct paths
- Modify: `dev/setup.sh` (potentially)
- Delete (post-cutover only): various

This task happens **in two halves**: half A (now, before cutover) is an inventory of what's vestigial and a removal of anything that's already safe to delete; half B (after cutover, in a separate plan) deletes the Ghost-theme-specific assets once Ghost is no longer driving the public site.

**Important constraint:** the existing Handlebars theme stays intact and shippable until cutover. Anything that exists *only* to support the theme stays put until the Astro site is in production. Pre-cutover deletions are limited to things that are dead weight regardless of which system is live.

### Half A — Inventory and pre-cutover safe deletions

- [ ] **Step 1: Inventory all candidates**

Walk the repo and classify each top-level file/directory as: `KEEP` (still needed in end state), `MIGRATE` (move into `site/`), `ARCHIVE` (move to `archive/` at cutover), `DELETE` (safe to remove now), or `DECIDE` (needs user input).

Run:

```bash
ls -la /Users/jeremyfuksa/Dev/ghost
```

Expected classification (verify each against current state):

| Path | Status | Notes |
|------|--------|-------|
| `theme/` | ARCHIVE at cutover | The Handlebars theme. Stays until Ghost stops driving the public site. |
| `site/` | KEEP | New Astro site (this plan). |
| `dev/setup.sh` | KEEP | Still needed for local Ghost dev. |
| `dev/deploy-theme.mjs` | ARCHIVE at cutover | Handlebars-theme upload script. |
| `dev/deploy-page.mjs` | DELETE post-cutover | Pushes content to Ghost Pages — Pages are no longer the architecture. |
| `dev/deploy-post.mjs` | KEEP (or ARCHIVE) | Pushes posts to Ghost. Useful if drafts in `drafts/` keep getting authored locally. Decide with user. |
| `docker-compose.yml` | KEEP | Still drives local Ghost. |
| `ghost-data/` (gitignored) | KEEP | Ghost's local DB volume. |
| `the-cocktail-napkin.zip` | DELETE now | Stale build artifact. Already gitignored via `*.zip`. |
| `node_modules/` (root) | KEEP | Used by `dev/*.mjs` scripts and campfire sync. |
| `package.json` (root) | MODIFY | `sync-campfire` script becomes vestigial post-cutover. Pre-cutover: keep, since the theme still uses `campfire.css`. |
| `package-lock.json` (root) | KEEP | Pairs with root `package.json`. |
| `drafts/` | DECIDE with user | Source markdown for case studies and posts. The case-study `.md` files have been migrated into MDX (Task 7). The post drafts (e.g. `jeremy-os-post.md`) may still be the authoring path. Likely KEEP. |
| `docs/` | KEEP | Plans and specs. |
| `.playwright-mcp/` (gitignored) | DELETE now | Stale per gitignore semantics — but it's already gitignored, so just remove from working tree. |
| `.worktrees/` (gitignored) | KEEP | Worktrees state. |
| `.superpowers/` (gitignored) | KEEP | Skill state. |
| `README.md` | MODIFY | Already updated in Task 13. |
| `CLAUDE.md` | MODIFY | Already updated in Task 13. |
| `.env` (gitignored) | KEEP | Ghost Admin API key for `dev/deploy-*.mjs` scripts. |
| `.mcp.json` | KEEP | MCP server config. |

**Inside `theme/`** (all ARCHIVE at cutover; nothing deletes pre-cutover):

| Path | End state |
|------|-----------|
| `theme/*.hbs` (16 templates) | Archive |
| `theme/partials/*.hbs` (10 partials) | Archive |
| `theme/assets/css/*.css` | Already copied verbatim into `site/src/styles/`. Source of truth becomes Astro post-cutover. |
| `theme/assets/js/main.js` | Already copied verbatim into `site/public/scripts/`. Source of truth becomes Astro. |
| `theme/assets/images/` | Already copied into `site/public/images/`. |
| `theme/routes.yaml` | Archive (no equivalent in Astro). |
| `theme/package.json` | Archive (Ghost theme manifest, not a Node project). |

**Inside `dev/`** scripts that target Ghost:

| Path | End state |
|------|-----------|
| `dev/setup.sh` | Keep — still seeds Ghost. May eventually slim down (no need to "activate the theme" if Ghost is using default Casper post-cutover). Defer changes. |
| `dev/deploy-theme.mjs` | Archive at cutover. |
| `dev/deploy-page.mjs` | Delete at cutover (Pages no longer in architecture). |
| `dev/deploy-post.mjs` | Keep if drafts → Ghost is still the authoring flow. |

- [ ] **Step 2: Save the inventory**

Create `docs/superpowers/specs/2026-04-25-astro-vestigial-inventory.md` and paste the table above plus the cutover plan checklist below. This is the source of truth at cutover time.

- [ ] **Step 3: Remove the stale build artifact**

Run from repo root:

```bash
ls the-cocktail-napkin.zip 2>/dev/null && rm the-cocktail-napkin.zip
```

Expected: file removed, no error.

This is safe because (a) it's gitignored, (b) it's regenerated by the existing zip script when needed.

- [ ] **Step 4: Remove the .playwright-mcp working-tree directory**

Run from repo root:

```bash
ls .playwright-mcp 2>/dev/null && rm -rf .playwright-mcp
```

Already gitignored. Stale working state, safe to remove. If future Playwright work needs it, it gets recreated.

- [ ] **Step 5: Run gscan one last time on the Handlebars theme**

Just to confirm we haven't accidentally broken the still-shipping theme during the migration work:

```bash
cd theme && npx gscan .
```

Expected: 0 errors, 1 warning (custom fonts — known-acceptable per CLAUDE.md).

- [ ] **Step 6: Commit pre-cutover cleanup**

```bash
git add -A docs/superpowers/specs/2026-04-25-astro-vestigial-inventory.md
git rm --cached the-cocktail-napkin.zip 2>/dev/null || true
git commit -m "chore: inventory vestigial files and remove pre-cutover dead artifacts"
```

(`git rm --cached` only runs if the file was somehow tracked despite the gitignore — safe no-op otherwise.)

### Half B — Post-cutover deletions (executed in a separate plan)

This is the punch list to execute after Ghost is verified to no longer drive the public site (DNS cut over, Astro site live, monitoring clean for 48 hours).

The actions in Half B are documented here for completeness but **must not be executed during this plan**. They go into the post-cutover plan referenced by Task 14 below.

```
1. Move theme/ → archive/the-cocktail-napkin-handlebars-theme/
2. Delete dev/deploy-theme.mjs (or move to archive/)
3. Delete dev/deploy-page.mjs (Ghost Pages no longer in architecture)
4. Confirm with user: keep or delete dev/deploy-post.mjs
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

Each item gets explicit verification — grep for callers, confirm with user, run tests.

- [ ] **Step 7: Commit the half-B punch list**

The half-B punch list is already inside `docs/superpowers/specs/2026-04-25-astro-vestigial-inventory.md` from Step 2. Confirm it's there:

```bash
grep -A 20 "Half B" docs/superpowers/specs/2026-04-25-astro-vestigial-inventory.md
```

Expected: the 11-step punch list shows up.

If it's missing (or you skipped Step 2), add it now and commit.

---

## Task 15: Pre-cutover preparation (deferred decisions)

This task does not produce code changes — it documents the post-migration decisions still needed before cutover. The actual cutover is a separate plan once these are answered.

- [ ] **Step 1: Document open decisions**

Create `docs/superpowers/specs/2026-04-25-astro-cutover-prep.md`:

```markdown
# Astro cutover preparation — decisions still needed

## 1. Hosting

Pick one for the Astro static output:
- **Netlify** — simplest deploys, good free tier, build hooks first-class.
- **Vercel** — same shape, slightly better edge functions if ever needed.
- **Cloudflare Pages** — best CDN, build hooks via API.

Decision factors: existing accounts, build minutes pricing, edge-function needs (probably none).

## 2. Ghost hosting

Where does Ghost live in the new world?
- **Same Docker container, separate subdomain (e.g. `cms.jeremyfuksa.com`)** — clean separation, Astro fetches over HTTPS, Ghost-served URLs (`/content/images/*`) stay valid via absolute URLs.
- **Ghost(Pro) hosted** — offload ops, ~$11/mo; same subdomain pattern.
- **Stays on existing host** — depends on how the current production site is deployed.

The Content API key changes are trivial — `.env` swap.

## 3. Webhook → rebuild

Ghost emits webhooks on `post.published`, `post.updated`, `post.deleted`. The hosting provider's deploy-hook URL goes here:
- Netlify: Site settings → Build & deploy → Build hooks → create.
- Vercel: Deploy hooks in project settings.
- Cloudflare Pages: API token + curl to deployments endpoint.

Set up: Ghost Admin → Settings → Integrations → custom integration → Webhooks → add three (one per event).

## 4. Image handling

Posts reference `/content/images/...` URLs. Two options:
- **Pull through (recommended):** Astro builds reference Ghost-hosted image URLs. Ghost serves them. Zero migration work.
- **Mirror at build time:** download images during build, rewrite URLs to local. Adds build complexity, removes Ghost-as-runtime dependency for image traffic.

Default: pull through. Revisit only if Ghost hosting becomes problematic.

## 5. URL preservation checklist

Before cutover, confirm every production URL maps. Crawl current site:

\`\`\`bash
wget --spider --recursive --level=3 --no-verbose https://jeremyfuksa.com 2>&1 | grep '^--' | awk '{print $3}' | sort -u > old-urls.txt
\`\`\`

Diff against `find site/dist -name 'index.html' | sed 's|site/dist||; s|/index.html|/|'`. Add any missing paths to `site/src/redirects.json`.

## 6. Members / Portal

Current site has `/#/portal/signup` links pointing at Ghost's Portal. After cutover:
- If Ghost is on a subdomain, change the URL to the absolute `https://cms.jeremyfuksa.com/#/portal/signup`.
- Or: drop members entirely until needed.

## 7. Search

Ghost has a built-in `/search/` (Sodo Search). The Astro site doesn't. Decision deferred — likely add Pagefind (zero-config static search) post-cutover only if anyone misses it.

## 8. RSS subscribers

Existing RSS subscribers point at Ghost's `/rss/`. The new RSS at `/rss.xml` has the same content; subscribers get redirected (Task 11 redirect map). No data migration.

## Cutover steps (separate plan)

1. Deploy Astro site to chosen host on a staging URL.
2. Run full crawl/parity audit against staging.
3. Set Ghost webhook → host deploy hook.
4. Switch DNS A/CNAME for `jeremyfuksa.com` to the host.
5. (If Ghost moves) update DNS for `cms.jeremyfuksa.com`.
6. Update `.env GHOST_URL` to production Ghost URL; redeploy.
7. Monitor logs and error rates for 48 hours.
8. Archive `theme/` directory (move to `archive/the-cocktail-napkin-handlebars-theme/`); remove root `package.json` campfire-sync script if no longer needed.
```

- [ ] **Step 2: Commit**

```bash
git add docs/superpowers/specs/2026-04-25-astro-cutover-prep.md
git commit -m "docs: capture deferred decisions for the Astro cutover plan"
```

---

## Self-review notes

**Spec coverage check (against the conversation):**
- Ghost owns posts; Astro owns everything else: ✓ Tasks 5 (writing/post/tag) vs Tasks 6–9 (home/work/case-studies/now/about).
- Case studies in MDX with shared layout: ✓ Task 7.
- Design system preserved verbatim: ✓ Task 3.
- Vanilla JS preserved: ✓ Task 3 + Task 4 step 1.
- URL preservation including `/writing/<slug>/`, `/tag/<slug>/`, `/work/<slug>/`: ✓ Task 5 + Task 8.
- RSS at parity: ✓ Task 10 + Task 11 redirect.
- Webhook-driven rebuild: ✓ Task 15 (deferred decisions).
- Hosting decision deferred: ✓ Task 15.
- Two-system coexistence during migration: ✓ Task 13 (docs).
- Vestigial cleanup: ✓ Task 14 (pre-cutover inventory + safe deletions; post-cutover punch list).

**Type consistency check:**
- `GhostPost`, `GhostTag`, `GhostAuthor` defined in Task 2, imported by all post-rendering tasks (5, 6, 10).
- `getAllPosts`, `getPostBySlug`, `getPostsByTag`, `getAllTags` defined in Task 2, used in Tasks 5, 6, 10, 11.
- `ghostImageUrl`, `isoDate`, `shortDate`, `monthYear`, `readingTime` defined in Task 4 step 7, used in Tasks 4 (PostCard), 5 (post detail), 7 (CaseStudyLayout), 9 (now).
- Case-study schema fields (`facts`, `stats`, `links`, `pullquote`, `eyebrow`, `tagline`, etc.) defined in Task 7 step 1, consumed by `CaseStudyLayout.astro` (Task 7 step 8).
- `redirects.json` shape: flat `Record<string, string>` — used in Task 11 step 4 (creation), step 6 (config consumption), step 2 (test).

**Outstanding placeholder requiring user input before commit:**
- Task 9 step 2 (`about.astro`): the prose body is `{/* paste from production */}`. The plan expects the engineer to extract from `https://jeremyfuksa.com/about/` via curl, which is documented in step 2 itself. Not a blocker; it's a documented step.

**Known fragility:**
- The active-link class in `SiteHeader.astro` (Task 4 step 2) is a guess (`nav-current`). Step 2 documents how to verify against the existing CSS. If wrong, easy fix.
- `import.meta.env` vs `process.env` for Vitest (Task 2 step 8) has a fallback documented inline.
- The `with { type: 'json' }` import attribute (Task 11 step 6) has a fallback documented inline for older Node versions.
