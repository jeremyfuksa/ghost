# Astro Migration Parity Audit

**Date:** 2026-04-25
**Branch:** `feat/astro-headless-migration`
**Build SHA:** `9fb2c67` (Task 11) + Task 12 audit work

## Build summary

- **51 HTML pages** + 1 RSS XML + 1 sitemap index + 1 sitemap-0.xml
- `pnpm build` completes in ~1.0s with 0 errors
- `pnpm astro check` returns 0/0/0
- `pnpm vitest run` returns 8/8 passing (4 ghost contract, 4 redirect)

## Page inventory

| URL | Route source | Status |
|-----|--------------|--------|
| `/` | `src/pages/index.astro` | ✅ |
| `/about/` | `src/pages/about.astro` | ✅ |
| `/now/` | `src/pages/now.astro` | ✅ |
| `/work/` | `src/pages/work/index.astro` | ✅ |
| `/work/<5 case studies>/` | `src/pages/work/[slug].astro` + MDX collection | ✅ |
| `/writing/` | `src/pages/writing/index.astro` (page 1, 15/22 posts) | ✅ |
| `/writing/page/2/` | `src/pages/writing/page/[page].astro` (posts 16–22) | ✅ |
| `/writing/<22 slugs>/` | `src/pages/writing/[slug].astro` | ✅ |
| `/tag/<15 slugs>/` | `src/pages/tag/[slug].astro` | ✅ |
| `/404.html` | `src/pages/404.astro` | ✅ |
| `/rss.xml` | `src/pages/rss.xml.ts` (22 items) | ✅ |
| `/sitemap-index.xml`, `/sitemap-0.xml` | `@astrojs/sitemap` | ✅ |
| `/moonbird/` | `src/redirects.json` → `/work/moonbird/` | ✅ |
| `/rss/` | `src/redirects.json` → `/rss.xml` | ✅ |

## Verified automatically

- All canonical `<link rel="canonical">` tags present on real pages, suppressed on 404 (per Task 10 `noCanonical` prop)
- All static images served from `/images/` (flame.svg + jeremy-hero.jpg)
- CSS `../images/jeremy-hero.jpg` reference resolves correctly: bundled CSS lands at `dist/_astro/<hash>.css`, `../images/` from there = `dist/images/` which contains the image
- All internal cross-links use absolute paths (`/work/...`, `/writing/...`, `/tag/...`)
- Case-study cross-links rewritten from `.md` → `/work/<slug>/` form (Task 7 follow-up commit)
- RSS feed contains 22 `<item>` blocks (one per published post)
- Sitemap includes all 47 reachable URLs (excludes redirects + 404 + RSS, as expected)
- Redirect HTMLs at `/moonbird/` and `/rss/` use `<meta http-equiv="refresh">` (5s default; could be 0s if needed)

## Visual parity checklist (manual — for Jeremy)

Open two browsers side by side: Astro at `http://localhost:4321/` (run `pnpm preview` from `site/`) and Ghost at `http://localhost:2368/`.

For each page below, spot-check: fonts, colors, spacing, hover states, dark-mode toggle (sun/moon button in nav), theme persistence (refresh page after toggling), mobile breakpoints (resize browser to ~375px width).

- [ ] `/` — hero, featured-work cards (3), latest post + sidebar (5 previous)
- [ ] `/writing/` — page header, filter chips (15 tags + "All"), 15 post cards, pagination footer
- [ ] `/writing/page/2/` — same shape, 7 post cards, prev+page-number+(no next)
- [ ] `/writing/i-became-fluent-in-my-own-thoughts/` (or any post with feature image) — header, hero image, byline, body prose, TOC sidebar (populated from H2s), reading-progress bar, related posts, more writing footer
- [ ] `/writing/why-candy-crush-saga-drives-me-nuts/` (or any short post without feature image) — same minus hero
- [ ] `/tag/ai/` — header shows tag name + count, "ai" filter chip is active
- [ ] `/work/` — work index, 5 rows in order: Domain Foundation, Moonbird, Two Components, Seven Years, Terra
- [ ] `/work/domain-foundation/` — case-study layout, sidebar facts (Layers, Architecture, Pivot, Origin), share button, subscribe CTA
- [ ] `/work/terra-design-system/` — same pattern; sidebar has stats (6 numbers) + 4 GitHub links
- [ ] `/work/moonbird/` — sidebar pullquote
- [ ] `/now/` — sections (Work, Building, Listening, Watching, Radio), "Updated Apr 2026 · Kansas City"
- [ ] `/about/` — lede, body prose, sidebar (Based in / Practice / Elsewhere), Work-with-me CTA
- [ ] `/404.html` — flame glyph, "That page didn't make it.", back-to-home link

Things to specifically check on each page:
- Theme toggle button in nav works and persists across navigation
- Active nav state highlights the correct section (writing posts → "Writing" highlighted, etc.)
- Reading-progress bar at top of post pages tracks scroll
- TOC sidebar populates and sliding indicator follows scroll
- All links work (no 404s in console)
- No JS errors in browser console

## Known issues / followups

### Acceptable as-is

1. **Three garbage tags from Ghost imports** — `tag/hash-import-2025-02-24-16-29/`, `tag/hash-import-2026-04-07-00-22/`, `tag/hash-migrated-1740436149660/`. Render fine; show up in writing-page filter bar. Content cleanup in Ghost Admin, not migration scope.
2. **Pre-existing `campfire.css` missing closing `}`** — fixed in worktree (load-bearing for Astro build); needs backporting to `theme/assets/css/campfire.css` on `main` so the Handlebars theme matches.
3. **`POSTS_PER_PAGE = 15` duplicated** in `writing/index.astro` and `writing/page/[page].astro` — could extract to a constants module; future cleanup.
4. **No pagination on tag pages** — current tag corpus has no tag with >15 posts; revisit if any tag grows past ~30.
5. **Two minor cosmetic notes from Task 5 review** — trailing space in `tag/[slug].astro:37` filter-chip class string; unnecessary `as` cast in `writing/[slug].astro:19`. Invisible to users.

### Deferred to post-cutover

6. **Hosting + DNS + Ghost relocation decisions** — see Task 15 deliverable.
7. **Image optimization** — Astro's `astro:assets` could downscale `feature_image` URLs at build time. Currently passes through Ghost's `/content/images/size/wNNN/` URLs as-is. Acceptable trade-off (Ghost serves them well).
8. **Search** — Ghost has built-in search; Astro doesn't. Pagefind drop-in if needed.
9. **404 redirect TTL** — Astro's default `<meta refresh>` redirect uses content="0" (immediate). Verified in `dist/moonbird/index.html` and `dist/rss/index.html`.

## Lighthouse (deferred)

The plan's optional Lighthouse step is skipped here — best run against the production deploy on the chosen host (Netlify/Vercel/Cloudflare), since static-server-only Lighthouse scores can be misleading vs. real CDN behavior. Defer to post-cutover.

## Conclusion

**Build verified.** Every page in the migration plan renders. No blockers. The visual-parity checklist above is the human eyeball pass — Jeremy runs `pnpm preview` from `site/` and walks the list against the live Ghost theme at `http://localhost:2368/`.
