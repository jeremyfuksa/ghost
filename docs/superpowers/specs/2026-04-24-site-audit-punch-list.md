# Site Audit — Punch List

**Date:** 2026-04-24
**Scope:** Code, performance, and "obvious cleanup" findings from a full-site audit. Design-judgment items (home featured-work treatment, case-study sidebar) live in the companion spec at `2026-04-24-design-experience-spec.md`.

This is a triage list. P0 = ship-blocking (broken UX, performance hits, doc/code drift). P1 = real wins, no judgment call. P2 = nice-to-have if you're already in the file.

---

## P0 — Fix soon

### 1. `campfire.css` is mostly dead weight
**File:** [theme/assets/css/campfire.css](theme/assets/css/campfire.css)

It's 3,815 lines. Of those, only ~400 lines are actually used:
- Lines 1–~400: Tailwind preflight reset (used)
- Lines 2341–2540: palette + semantic color tokens (used heavily — `--primary-*`, `--secondary-*`, `--text-primary`, `--bg-base`, etc.)
- Lines 2549–2700: dark-mode palette tokens (used)
- **Lines 410–2340 and 2707–end (~3,400 lines): Tailwind utility classes (`.flex`, `.grid-cols-3`, dialog/sheet/checkbox component utilities, etc.) — zero references in any `.hbs` template.**

Plus: line 1 imports Google Fonts for **Manrope**, which the site doesn't render anywhere (body is system UI, headings are Fraunces). That's a blocking external request on every page for a font that's never used.

**Action:** Strip campfire.css down to preflight + token blocks. Drop the Manrope `@import`. Expected size reduction: ~85% of the file. Keep the file name (it's the foundation per the comment), just gut the unused output.

### 2. FontAwesome kit on every page for ~10 glyphs
**File:** [theme/default.hbs:18](theme/default.hbs#L18)

The kit JS (~80–100KB blocking script) loads on every page. Current usage across the entire theme:
- `fa-share-nodes` — share button (5 templates)
- `fa-pen-nib`, `fa-briefcase`, `fa-circle-dot`, `fa-linkedin`, `fa-github` — about page only

**Action:** Inline 6 SVG glyphs in `theme/assets/icons/` (or as Handlebars partials), drop the kit. Saves a network request and a render-blocker on first paint.

### 3. Share buttons go nowhere
**Files:** [theme/post.hbs:15-17](theme/post.hbs#L15-L17), [theme/post.hbs:73-78](theme/post.hbs#L73-L78), and all 5 case-study templates

Every share affordance is `<a href="#/share">`. That's a placeholder fragment that does nothing — clicking it just adds `#/share` to the URL.

**Action:** Either (a) remove all share UI, or (b) wire it up to a real share target (Web Share API with mailto/twitter/linkedin fallback). Two share buttons on the same post (one in header meta, one big block at the end) is also redundant — pick one.

### 4. CLAUDE.md is out of date in two ways
**File:** [CLAUDE.md](CLAUDE.md)

- Says: *"Dark mode is system-preference only (`prefers-color-scheme`). No JS toggle."*
  Reality: [theme/partials/header.hbs:14](theme/partials/header.hbs#L14) renders a `.theme-toggle` button; [theme/assets/js/main.js](theme/assets/js/main.js) wires it up with localStorage persistence. Both system preference *and* manual toggle work.
- Says: *"No JS dependencies. Vanilla JS only, kept minimal (TOC scroll spy is the only behavior)."*
  Reality: `main.js` does six things — theme toggle, TOC scroll spy + sliding indicator, heading anchor links, reading progress bar, scroll-reveal animations, cursor spotlight on featured-work cards.

**Action:** Decide which is the source of truth. If the JS is staying, update CLAUDE.md to describe what's actually there. If the docs are right, strip the JS back.

### 5. `custom-work.hbs` hardcodes the case-study list
**File:** [theme/custom-work.hbs:24-50](theme/custom-work.hbs#L24-L50)

Adding/reordering a case study requires editing HBS, zipping, and deploying. The case studies themselves are Ghost pages tagged appropriately — they could be queried via `{{#get "pages" filter="tag:hash-case-study"}}` like the home page already does for the methodology trio.

**Action:** Convert `.work-list` to a Ghost query (probably `tag:hash-case-study` ordered by `published_at desc` or a custom order field). Same change applies to the home `featured-work` grid — it hardcodes the same three.

---

## P1 — Real wins, no judgment call

### 6. Split `components.css` (3,460 lines, one file)
**File:** [theme/assets/css/components.css](theme/assets/css/components.css)

It's already sectioned with comment banners. Splitting into named files makes navigation by filename, not line number, and makes diffs sane:

```
components/
  _index.css          # @imports the rest
  layout.css          # site-content, page wrappers, responsive padding (line 3192)
  hero.css            # 794–930
  featured-work.css   # 932–1034
  home-writing.css    # 1206– (post cards, sidebar)
  post-card.css       # post-card, post-card-featured
  post-page.css       # post-header, post-layout, post-sidebar, toc
  case-study.css      # 2899– (cs-meta, cs-stats)
  about.css           # 2707–
  work-page.css       # 2544–
  now.css
  share.css           # 3388–
  polish.css          # 3234– (selection, focus, anchors, reveal)
  responsive.css      # 3192– consolidated media block
```

No build step needed — `screen.css` already uses `@import` chains, and Ghost serves them. Cost: a handful of extra HTTP requests *during dev only* (Ghost concatenates+minifies in production, IIRC — verify). If that's a concern, keep the splits in source and add a tiny concat step.

### 7. `tokens.css` declares `--font-sans: Manrope, ...` but nothing uses Manrope
**File:** [theme/assets/css/tokens.css:11](theme/assets/css/tokens.css#L11)

Body is system UI. The Manrope reference is leftover from when campfire.css was a real Tailwind theme.

**Action:** Drop "Manrope" from the `--font-sans` stack. Remove the comment on line 7 referencing it.

### 8. `.theme-toggle` button has no visible-by-default focus styling consistent with rest of site
**File:** [theme/assets/js/main.js:13-36](theme/assets/js/main.js#L13-L36)

Cosmetic but worth checking — keyboard users tabbing through the nav should see a focus ring on the toggle. Verify against `polish.css` focus rules.

### 9. Case-study sidebar duplicates the header tagline
**Examples:**
- [terra:10](theme/custom-casestudy-terra.hbs#L10) tagline: *"Open-source React component library serving hundreds of teams across enterprise healthcare."*
  [terra:33](theme/custom-casestudy-terra.hbs#L33) "Scope" field: *"Open-source React component library serving hundreds of teams across enterprise healthcare"*
- Same pattern on Cerner, Domain Foundation, Moonbird, Redwood.

**Action:** Either kill the Scope field entirely (the tagline already says it) or make Scope a meaningfully different summary — e.g., year-by-year scope shifts, deliverables count, what was *cut* from scope. See companion design spec for the broader case-study redesign.

### 10. Reading-progress bar appends to `<body>` from JS
**File:** [theme/assets/js/main.js:127-129](theme/assets/js/main.js#L127-L129)

It's a single `<div>` injected at runtime. Causes a microscopic layout flash on slow connections. Consider rendering it directly in `default.hbs` and just driving `width` from JS.

### 11. Hero photo + featured-work card overlap is the source of "heaviness"
**Files:** [theme/assets/css/components.css:794-803](theme/assets/css/components.css#L794-L803), [components.css:934-940](theme/assets/css/components.css#L934-L940)

Hero is a portrait photo with a 0.45→0.55 dark gradient. Featured-work block has `margin-top: -64px` so 3 chunky teal cards (`#75acaf`) crash into the bottom of the photo. That's the "competing with the hero" feeling.

**Action:** Two paths — see companion design spec. Either change the cards or change the relationship.

---

## P2 — While you're in there

### 12. Page-wrapper padding uses inconsistent token mixes
Some pages use `padding: var(--spacing-12) var(--spacing-8) var(--spacing-20)`; some don't. Worth a sweep when you're already in the relevant CSS.

### 13. `home-bg::before` has both `:root:not([data-theme="light"])` and `:root[data-theme="dark"]` selectors stacked
**File:** [components.css:761-772](theme/assets/css/components.css#L761-L772)

This pattern is everywhere — system-preference + manual toggle both need to win. It works, but it's verbose and easy to forget one side. A `[data-theme="dark"]` attribute set by JS at boot (sync with system unless user has overridden) collapses both branches into one selector.

### 14. `static/*.html` and `theme/*.hbs` drift detection
There's no tooling that warns when a static file's "last sync" date is older than its HBS counterpart's modified time. A 10-line shell check in `dev/` could surface drift in CI / pre-commit.

### 15. Two `:root` blocks
campfire.css defines a `:root` (line 2341), tokens.css defines another (line 6). Cascading is correct (later wins), but a single source of truth is easier to reason about. Could be done as part of #1.

### 16. Author template is a stub
**File:** [theme/author.hbs](theme/author.hbs) — 6 lines, uses default page rendering.

If you're a single-author site (you are), Ghost's author URLs are dead weight. Consider a `routes.yaml` redirect from `/author/jeremy/` → `/about/`.

### 17. `error.hbs` is 8 lines
**File:** [theme/error.hbs](theme/error.hbs)

Probably fine, but worth a glance — does it match the site personality? Static `error.html` exists and is presumably more designed.

---

## What's good (don't touch)

- **Token system in `tokens.css`** is well-organized, well-commented, and the discipline is real (no hardcoded pixels in CSS, exceptions documented in CLAUDE.md).
- **Static-first workflow** is unusual and good — the bind-mount + Docker setup means iteration is fast and visual.
- **Routes config** is clean.
- **Three-CSS-file architecture** (tokens / base / components) is sensible. The problem is one of those files is 3.4k lines, not the architecture itself.
- **Variable Fraunces** with `WONK 1, opsz 72` is a nice typographic choice and well-implemented.
- **Two accent-color roles** (`--color-accent-ui` decorative vs `--color-accent-text` readable) is a good system that prevents WCAG misuse.

---

## Suggested order of work

1. **Land the docs fix first** (#4) — one commit, prevents future you from re-creating the same drift.
2. **Strip campfire.css** (#1) — biggest perf win, lowest risk (dead code).
3. **Drop FontAwesome** (#2) — second-biggest perf win.
4. **Decide on share UX** (#3) — broken UX is more important to fix than dead bytes.
5. **Convert work-page list to Ghost query** (#5) — unlocks editing in Admin.
6. **Then decide** whether to tackle the case-study redesign + featured-work redesign (the design spec) before the components.css split (#6), or after. The split is purely structural; the redesign actually changes the experience.
