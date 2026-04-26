# Astro cutover preparation — decisions still needed

**Date:** 2026-04-25
**Status:** Migration branch (`feat/astro-headless-migration`) is implementation-complete and parity-audited. This doc captures the decisions still needed before cutover, then the cutover steps themselves.

The actual cutover is a separate plan once the decisions below are made.

---

## 1. Hosting

Pick one for the Astro static output:

- **Netlify** — simplest deploys, good free tier, build hooks first-class. Generous free build minutes. Default recommendation unless you have a reason otherwise.
- **Vercel** — similar shape to Netlify, slightly better edge functions if ever needed (we don't need them).
- **Cloudflare Pages** — best CDN, build hooks via API, more setup overhead. Good if you already have Cloudflare in your stack.

**Decision factors:** existing accounts, build minutes pricing (none of this approaches limits — site is ~50 pages), edge-function needs (probably none).

**Default if no preference:** Netlify.

---

## 2. Ghost hosting

Where does Ghost live in the new world?

- **Same Docker container, separate subdomain (e.g. `cms.jeremyfuksa.com`)** — clean separation, Astro fetches over HTTPS, Ghost-served URLs (`/content/images/*`) stay valid via absolute URLs. You keep ops control.
- **Ghost(Pro) hosted** — offload ops to Ghost's team, ~$11/mo on the lowest tier. Same subdomain pattern. Migration takes ~30 min via Ghost's import/export.
- **Stays on existing host** — depends on how production Ghost is deployed today (this needs to be confirmed with you).

The Content API key changes are trivial — `.env` swap on the Astro host.

**Default if no preference:** ask — depends on where production Ghost actually is now.

---

## 3. Webhook → rebuild

Ghost emits webhooks on `post.published`, `post.updated`, `post.deleted`. The hosting provider's deploy-hook URL goes here:

- **Netlify:** Site settings → Build & deploy → Build hooks → create. Returns a URL like `https://api.netlify.com/build_hooks/<hash>`.
- **Vercel:** Deploy hooks in project settings.
- **Cloudflare Pages:** API token + curl to `/accounts/<id>/pages/projects/<name>/deployments`.

**Set up:** Ghost Admin → Settings → Integrations → custom integration → Webhooks → add three webhooks (one per event), each pointing at the deploy-hook URL.

Result: every publish in Ghost triggers a fresh Astro build within ~60-90 seconds.

---

## 4. Image handling

Posts reference `/content/images/...` URLs. Two options:

- **Pull through (recommended):** Astro builds reference Ghost-hosted image URLs. Ghost serves them. Zero migration work.
- **Mirror at build time:** download images during build, rewrite URLs to local. Adds build complexity, removes Ghost-as-runtime dependency for image traffic.

**Default:** pull through. Revisit only if Ghost hosting becomes problematic (e.g. you decide to run Ghost only locally and stop hosting it publicly).

---

## 5. URL preservation checklist

Before cutover, confirm every production URL maps. Crawl the live site:

```bash
wget --spider --recursive --level=3 --no-verbose https://jeremyfuksa.com 2>&1 \
  | grep '^--' | awk '{print $3}' | sort -u > old-urls.txt
```

Diff against:

```bash
find site/dist -name 'index.html' \
  | sed 's|site/dist||; s|/index.html|/|' \
  | sort -u > new-urls.txt
```

```bash
comm -23 old-urls.txt new-urls.txt > urls-without-target.txt
```

Add any missing paths to `site/src/redirects.json`. The map already covers `/moonbird/` → `/work/moonbird/` and `/rss/` → `/rss.xml`. Likely additional candidates discoverable from the crawl: `/page/<n>/` (Ghost pagination), any `/page/<slug>/` pages we haven't migrated.

---

## 6. Members / Portal

Current site has `/#/portal/signup` links pointing at Ghost's Portal. After cutover:

- If Ghost is on a subdomain, change the URL to the absolute `https://cms.jeremyfuksa.com/#/portal/signup`.
- Or: drop members entirely until needed.

Affected files in `site/`:
- `src/components/SiteFooter.astro` line ~46 (`/#/portal/signup`)
- `src/components/SubscribeCta.astro` line ~6 (`/#/portal/signup`)

If Portal stays on the same root domain (Ghost on `jeremyfuksa.com` with Astro reverse-proxying), no change needed.

---

## 7. Search

Ghost has built-in search (Sodo Search). The Astro site doesn't.

**Decision deferred** — likely add [Pagefind](https://pagefind.app/) (zero-config static search) post-cutover only if anyone misses it. Pagefind generates an index from `dist/` at build time, no runtime dependency.

If you want it before cutover, it's a 10-line addition to `site/package.json` (`postbuild: pagefind --site dist`) plus a small UI component.

---

## 8. RSS subscribers

Existing RSS subscribers point at Ghost's `/rss/`. The new RSS at `/rss.xml` has the same content; subscribers get redirected (Task 11 redirect map). No data migration needed.

**Verify before cutover:** that the redirect actually works in the production host's serving setup. Netlify and Vercel both honor Astro's redirect HTML output (`<meta http-equiv="refresh">`). Cloudflare Pages also does. If you want a 301 instead of meta-refresh (slightly better for RSS readers), most hosts support `_redirects` files — Astro can also emit those via [@astrojs/netlify](https://docs.astro.build/en/guides/integrations-guide/netlify/) / [@astrojs/vercel](https://docs.astro.build/en/guides/integrations-guide/vercel/) adapters, but that requires switching from `output: 'static'` to a hybrid setup.

---

## 9. CI

There's none yet. Recommend post-cutover:

- GitHub Actions workflow on `feat/*` branches: `pnpm install`, `pnpm check`, `pnpm test`, `pnpm build`. Optional Lighthouse against `pnpm preview`.
- Branch protection on `main` requiring the workflow to pass.

Cheap; one workflow file. Defer to after first deploy works.

---

## Cutover steps (separate plan)

These are the steps the cutover plan should cover. Each one is checkpointable; pause and verify between.

1. **Pick host (decision §1) and create account/project.**
2. **Connect repo, set build command and output dir.** Build: `cd site && pnpm install && pnpm build`. Output: `site/dist`. Set `GHOST_URL` and `GHOST_CONTENT_API_KEY` env vars in the host's settings (using prod Ghost URL + key, not local).
3. **Deploy on a staging URL first.** E.g. `astro-jeremyfuksa.netlify.app`.
4. **Run full crawl/parity audit against staging.** Use the URL diff from §5. Fix any 404s.
5. **Set up Ghost webhook → host deploy hook (§3).** Test by editing a draft in Ghost and confirming it triggers a build within 90s.
6. **Switch DNS A/CNAME for `jeremyfuksa.com`** to the host. TTL at the registrar should be lowered ~24h before cutover so the swap propagates fast.
7. **(If Ghost moves) update DNS for `cms.jeremyfuksa.com`** and update `GHOST_URL` env var on the Astro host; redeploy.
8. **Monitor logs and error rates for 48 hours.** Watch for 404s in host analytics, broken images, missing redirects. Real RSS subscribers will retry the next morning — a 24-hour wait shows whether the redirect from `/rss/` is honored.
9. **Execute Half B of the vestigial cleanup punch list** (`docs/superpowers/specs/2026-04-25-astro-vestigial-inventory.md`). Archive `theme/`, drop deprecated scripts, slim docs, update `dev/setup.sh`.
10. **Backport the campfire.css missing-`}` fix to `main`** if it hasn't already happened (one-line append; see vestigial doc).

Estimated effort: 2–4 hours of focused work, plus 48h monitoring. Most of it is hosting/DNS plumbing rather than code.

---

## What's in the migration branch right now

- 51 HTML pages + RSS + sitemap, all building cleanly (`pnpm build` ~1s)
- 0 errors / 0 warnings on `pnpm astro check`
- 8/8 tests passing on `pnpm vitest run` (4 Ghost API contract, 4 redirect tests)
- All 5 case studies as MDX in `src/content/case-studies/` with Zod-validated frontmatter
- Two redirects (`/moonbird/`, `/rss/`)
- Parity audit doc with manual visual checklist (`docs/superpowers/specs/2026-04-25-astro-parity-audit.md`)
- Vestigial inventory + post-cutover punch list (`docs/superpowers/specs/2026-04-25-astro-vestigial-inventory.md`)

The only thing missing from "ready to cutover" is the decisions in this doc.
