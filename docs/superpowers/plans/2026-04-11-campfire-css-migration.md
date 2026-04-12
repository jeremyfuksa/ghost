# Campfire CSS Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Ghost theme's custom token vocabulary with `@jeremyfuksa/campfire`'s canonical CSS custom property names throughout all CSS files.

**Architecture:** Install campfire as a root-level dev dependency, copy its `styles.css` into the theme assets as `campfire.css`, rewrite `tokens.css` as a thin overrides file for theme-specific tokens, then do a systematic rename pass across `base.css` and `components.css` to use campfire's naming conventions. Dark mode bridges campfire's `.dark` class via a 3-line inline script in `default.hbs`.

**Tech Stack:** Pure CSS (no preprocessor), Ghost 6 Handlebars theme, npm (dev tooling only), Docker for local preview.

**Spec:** `docs/superpowers/specs/2026-04-11-campfire-css-migration-design.md`

---

## File Map

| File | Action | What changes |
|------|--------|--------------|
| `/package.json` | Create | Root npm manifest; campfire dev dep + sync script |
| `/.gitignore` | Create | Ignore `node_modules/`, `package-lock.json` |
| `theme/assets/css/campfire.css` | Create | Copied from npm; never edited manually |
| `theme/assets/css/tokens.css` | Rewrite | Overrides-only; remove campfire-owned tokens; dark mode → `.dark` selector |
| `theme/assets/css/screen.css` | Modify | Add `campfire.css` as first import |
| `theme/assets/css/base.css` | Modify | 14 token renames; remove `font-family` from body (campfire owns it) |
| `theme/assets/css/components.css` | Modify | ~415 token renames across colors, spacing, radius, weights, font-family |
| `theme/default.hbs` | Modify | Dark mode detection script; Manrope added to Google Fonts URL |
| `static/home.html` | Modify | Add campfire.css link; add Manrope to Google Fonts URL |
| `static/writing.html` | Modify | Same |
| `static/post.html` | Modify | Same |
| `static/about.html` | Modify | Same |
| `static/now.html` | Modify | Same |
| `static/work.html` | Modify | Same |
| `static/page.html` | Modify | Same |
| `static/tag.html` | Modify | Same |
| `static/error.html` | Modify | Same |

---

## Task 1: npm setup and campfire extraction

**Files:**
- Create: `/Users/jeremyfuksa/Dev/ghost/package.json`
- Create: `/Users/jeremyfuksa/Dev/ghost/.gitignore`
- Create: `theme/assets/css/campfire.css` (via npm script)

- [ ] **Step 1: Create root package.json**

  ```json
  {
    "devDependencies": {
      "@jeremyfuksa/campfire": "latest"
    },
    "scripts": {
      "sync-campfire": "cp node_modules/@jeremyfuksa/campfire/styles.css theme/assets/css/campfire.css"
    }
  }
  ```

  Save to `/Users/jeremyfuksa/Dev/ghost/package.json`.

- [ ] **Step 2: Create .gitignore**

  Create `/Users/jeremyfuksa/Dev/ghost/.gitignore`:
  ```
  node_modules/
  package-lock.json
  ```

- [ ] **Step 3: Install and sync**

  ```bash
  cd /Users/jeremyfuksa/Dev/ghost
  npm install
  npm run sync-campfire
  ```

  Expected: `theme/assets/css/campfire.css` now exists.

- [ ] **Step 4: Check campfire.css for duplicate font imports**

  ```bash
  grep -i "fonts.googleapis\|@font-face\|manrope" theme/assets/css/campfire.css | head -10
  ```

  If campfire.css includes `@import url(...)` for Manrope, note it — we'll add Manrope to the Google Fonts URL in default.hbs anyway (for the preconnect hint), but the duplicate import is harmless.

- [ ] **Step 5: Commit**

  ```bash
  git add package.json .gitignore theme/assets/css/campfire.css
  git commit -m "feat: install @jeremyfuksa/campfire and extract styles.css"
  ```

---

## Task 2: Rewrite tokens.css

**Files:**
- Modify: `theme/assets/css/tokens.css`

Replace the entire file. The new version only defines what campfire doesn't cover. All palette tokens, spacing, radius, weight, and generic semantic color tokens are removed — campfire owns those via `campfire.css`.

- [ ] **Step 1: Replace tokens.css with the overrides-only version**

  Write this as the full content of `theme/assets/css/tokens.css`:

  ```css
  /* ==========================================================================
     Design Tokens — Theme Overrides
     Extends @jeremyfuksa/campfire. Only defines what campfire doesn't cover.
     ========================================================================== */

  :root {
    /* Heading font — campfire uses Manrope for body; Fraunces stays for headings */
    --font-heading: 'Fraunces', 'Georgia', serif;

    /* Named body font stack — used by components that explicitly reset font-family */
    --font-sans: Manrope, -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;

    /* Extended type scale — not in campfire */
    --text-3xs: 0.625rem;  /* 10px */
    --text-2xs: 0.6875rem; /* 11px */

    /* Line heights — used in heading rules in base.css */
    --leading-h1: 48px;
    --leading-h2: 33px;
    --leading-h3: 28px;
    --leading-xs: 16px;
    --leading-sm: 20px;
    --leading-base: 24px;
    --leading-lg: 28px;
    --leading-xl: 32px;
    --leading-2xl: 32px;
    --leading-3xl: 40px;
    --leading-4xl: 44px;
    --leading-5xl: 56px;

    /* Letter spacing */
    --tracking-tight: -0.02em;
    --tracking-snug: -0.01em;
    --tracking-wide: 0.02em;
    --tracking-wider: 0.06em;
    --tracking-widest: 0.1em;

    /* Transitions */
    --transition-fast: 150ms ease;
    --transition-base: 200ms ease;
    --transition-medium: 300ms ease;

    /* Hairline border widths — campfire only defines semantic border color tokens */
    --border-hairline: 0.5px;
    --border-thin: 1.5px;
    --border-blockquote: 2px;

    /* Sizing */
    --size-dot-sm: 3px;
    --size-dot: 6px;
    --size-avatar: 32px;
    --size-card-thumb: 180px;
    --size-card-image: 120px;
    --size-featured-image: 320px;
    --size-featured-image-sm: 200px;

    /* Layout */
    --content-max: 1200px;
    --prose-max: 680px;
    --nav-height: 64px;
    --sidebar-home: 340px;
    --sidebar-writing: 280px;
    --sidebar-post: 240px;
    --now-label-width: 160px;

    /* Heading color — warm brown, not in campfire semantic tokens */
    --color-text-heading: #3d3028;

    /* Accent — amber, not in campfire's interactive palette */
    --color-accent-ui: #d97706;
    --color-accent-text: #b45309;
    --color-accent-hover: #92400e;
    --color-accent-subtle: #faf6f5;

    /* Tags */
    --color-tag-bg: #f5ebe8;
    --color-tag-text: #623e34;

    /* Links */
    --color-link: #4c627d;
    --color-link-hover: #b45309;

    /* Logo chip */
    --color-logo-bg: #2b303b;
    --color-logo-fg: #f7f8f9;

    /* Now card */
    --color-now-bg: #fff8f0;
    --color-now-border: #c9998a;
    --color-now-accent: #b45309;

    /* Nav */
    --color-nav-bg: #faf7f3;
    --color-nav-border: #ede4dc;
    --color-nav-author: #8d5443;
    --color-nav-link: #4c627d;
    --color-nav-active: var(--text-primary);
    --color-nav-active-border: var(--color-accent-ui);
    --color-nav-cta: var(--color-accent-text);
    --color-nav-cta-hover: var(--color-accent-hover);

    /* Footer */
    --color-footer-bg: var(--color-link);
    --color-footer-border: var(--border-subtle);
    --color-footer-text: var(--color-accent-subtle);
    --color-footer-copy: var(--color-accent-subtle);
    --color-footer-nav-hover: #ffffff;
    --color-footer-tagline: #607a97;

    /* Palette accents (surgical use in nav/section labels/etc.) */
    --color-eyebrow: #8d5443;
    --color-section-label: #4c627d;
    --color-blockquote-rule: #a8654f;
    --color-toc-active: #3e4f66;

    /* Status — aliased to campfire palette tokens */
    --color-success: var(--success-600);
    --color-warning: var(--warning-600);
    --color-danger: var(--danger-600);
  }

  /* Dark mode — theme-specific overrides only.
     Campfire handles --bg-base, --text-primary, etc. via .dark on <html>.
     Only override tokens that campfire doesn't define. */
  .dark {
    --color-text-heading: #f5e6d0;

    --color-accent-ui: #f5a855;
    --color-accent-text: #f5a855;
    --color-accent-hover: #ffc05c;
    --color-accent-subtle: #341f19;

    --color-tag-bg: #341f19;
    --color-tag-text: #dbbdb3;

    --color-link: #8098b0;
    --color-link-hover: #f5a855;

    --color-logo-bg: #f7f8f9;
    --color-logo-fg: #1c1f26;

    --color-now-bg: #231a0e;
    --color-now-border: #a8654f;
    --color-now-accent: #f5a855;

    --color-eyebrow: #dbbdb3;
    --color-section-label: #acbbcc;
    --color-blockquote-rule: #c9998a;
    --color-toc-active: #acbbcc;
    --color-footer-tagline: #8098b0;

    --color-nav-bg: #8a3308;
    --color-nav-border: #a84012;
    --color-nav-author: #b37a5e;
    --color-nav-link: #d6b49c;
    --color-nav-active: #ffffff;
    --color-nav-active-border: var(--color-text-heading);
    --color-nav-cta: #ffffff;
    --color-nav-cta-hover: #ffe8c8;

    --color-footer-bg: #303a49;
    --color-footer-text: var(--text-secondary);
    --color-footer-copy: var(--text-secondary);
    --color-footer-nav-hover: var(--text-primary);
  }
  ```

- [ ] **Step 2: Commit**

  ```bash
  git add theme/assets/css/tokens.css
  git commit -m "refactor: rewrite tokens.css as campfire overrides-only file"
  ```

---

## Task 3: Update screen.css import order

**Files:**
- Modify: `theme/assets/css/screen.css`

- [ ] **Step 1: Replace screen.css content**

  ```css
  /* ==========================================================================
     The Cocktail Napkin — Main Stylesheet
     ========================================================================== */

  @import 'campfire.css';   /* foundation: palette + semantic tokens + typography globals */
  @import 'tokens.css';     /* theme overrides: Fraunces, nav/footer/accent colors, layout vars */
  @import 'base.css';
  @import 'components.css';
  ```

- [ ] **Step 2: Commit**

  ```bash
  git add theme/assets/css/screen.css
  git commit -m "refactor: add campfire.css as first import in screen.css"
  ```

---

## Task 4: Update default.hbs — dark mode script and Manrope font

**Files:**
- Modify: `theme/default.hbs`

- [ ] **Step 1: Add Manrope to the Google Fonts URL**

  Find the existing Google Fonts link in `default.hbs`:
  ```html
  <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,WONK@9..144,100..900,0..1&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
  ```

  Replace with:
  ```html
  <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,WONK@9..144,100..900,0..1&family=Fira+Code:wght@400;500&family=Manrope:wght@400;500;600;700&display=swap" rel="stylesheet">
  ```

- [ ] **Step 2: Add dark mode detection script before the CSS link**

  Find:
  ```html
    <link rel="stylesheet" href="{{asset "css/screen.css"}}">
  ```

  Replace with:
  ```html
    <script>
      if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
        document.documentElement.classList.add('dark');
      }
    </script>
    <link rel="stylesheet" href="{{asset "css/screen.css"}}">
  ```

- [ ] **Step 3: Commit**

  ```bash
  git add theme/default.hbs
  git commit -m "feat: add dark mode class detection and Manrope font to default.hbs"
  ```

---

## Task 5: Update all static HTML files

**Files:**
- Modify: `static/home.html`, `static/writing.html`, `static/post.html`, `static/about.html`, `static/now.html`, `static/work.html`, `static/page.html`, `static/tag.html`, `static/error.html`

Each static file currently has this CSS block (using home.html as example):
```html
<link rel="stylesheet" href="../theme/assets/css/tokens.css">
<link rel="stylesheet" href="../theme/assets/css/base.css">
<link rel="stylesheet" href="../theme/assets/css/components.css">
```

- [ ] **Step 1: Update Google Fonts URL in all static files**

  ```bash
  cd /Users/jeremyfuksa/Dev/ghost
  sed -i '' 's|family=Fira+Code:wght@400;500&display=swap|family=Fira+Code:wght@400;500\&family=Manrope:wght@400;500;600;700\&display=swap|g' static/*.html
  ```

  Verify:
  ```bash
  grep "Manrope" static/home.html
  ```
  Expected: one line with `family=Manrope:wght@400;500;600;700`.

- [ ] **Step 2: Add campfire.css as first CSS link in all static files**

  ```bash
  sed -i '' 's|<link rel="stylesheet" href="../theme/assets/css/tokens.css">|<link rel="stylesheet" href="../theme/assets/css/campfire.css">\n  <link rel="stylesheet" href="../theme/assets/css/tokens.css">|g' static/*.html
  ```

  Verify:
  ```bash
  grep -A3 "campfire.css" static/home.html
  ```
  Expected:
  ```
  <link rel="stylesheet" href="../theme/assets/css/campfire.css">
    <link rel="stylesheet" href="../theme/assets/css/tokens.css">
    <link rel="stylesheet" href="../theme/assets/css/base.css">
  ```

- [ ] **Step 3: Add dark mode detection script to each static file**

  Each static file has `<head>`. Add the dark mode script just before the campfire.css link. Use Python (sed quoting is unreliable for multi-line insertions on macOS):

  ```bash
  python3 - <<'EOF'
  import os, glob

  SCRIPT = '''\
    <script>
      if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
        document.documentElement.classList.add('dark');
      }
    </script>
  '''
  TARGET = '  <link rel="stylesheet" href="../theme/assets/css/campfire.css">'

  for path in glob.glob('static/*.html'):
      content = open(path).read()
      if 'prefers-color-scheme' not in content:
          content = content.replace(TARGET, SCRIPT + TARGET)
          open(path, 'w').write(content)
          print(f'Updated {path}')
      else:
          print(f'Skipped {path} (already has dark mode script)')
  EOF
  ```

  Verify:
  ```bash
  grep -B1 -A4 "prefers-color-scheme" static/home.html
  ```
  Expected: the 3-line script block immediately above the campfire.css link.

- [ ] **Step 4: Commit**

  ```bash
  git add static/
  git commit -m "refactor: add campfire.css link and dark mode script to all static files"
  ```

---

## Task 6: Token rename — base.css

**Files:**
- Modify: `theme/assets/css/base.css`

14 token references to update. Do these as explicit edits rather than sed — the file is small and each change is easy to verify.

- [ ] **Step 1: Update body rule — remove font-family, rename remaining tokens**

  Find:
  ```css
  body {
    font-family: var(--font-primary);
    font-size: var(--text-base);
    line-height: var(--leading-base);
    font-weight: var(--weight-regular);
    color: var(--color-text-primary);
    background-color: var(--color-bg);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
  ```

  Replace with:
  ```css
  body {
    font-size: var(--text-base);
    line-height: var(--leading-base);
    font-weight: var(--font-weight-regular);
    color: var(--text-primary);
    background-color: var(--bg-base);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
  ```

  (Remove `font-family` — campfire sets this on body globally. Rename `--weight-regular` → `--font-weight-regular`, `--color-text-primary` → `--text-primary`, `--color-bg` → `--bg-base`.)

- [ ] **Step 2: Update heading margin and spacing references**

  Find all `var(--space-` references in base.css and rename:

  ```bash
  sed -i '' 's/var(--space-\([0-9]*\))/var(--spacing-\1)/g' theme/assets/css/base.css
  ```

  Verify:
  ```bash
  grep "var(--space-" theme/assets/css/base.css
  ```
  Expected: no output (all replaced).

- [ ] **Step 3: Verify base.css has no remaining old token names**

  ```bash
  grep -n "var(--color-bg\b\|var(--color-text-primary\|var(--weight-\|var(--font-primary\|var(--space-" theme/assets/css/base.css
  ```
  Expected: no output.

- [ ] **Step 4: Commit**

  ```bash
  git add theme/assets/css/base.css
  git commit -m "refactor: rename tokens in base.css to campfire conventions"
  ```

---

## Task 7: Token rename — components.css color tokens

**Files:**
- Modify: `theme/assets/css/components.css`

109 color token references. Use sed for systematic replacement. Order matters — replace more-specific patterns before less-specific ones (e.g. `surface-2` before `surface`).

- [ ] **Step 1: Run color token renames**

  ```bash
  cd /Users/jeremyfuksa/Dev/ghost
  sed -i '' \
    -e 's/var(--color-surface-2)/var(--bg-muted)/g' \
    -e 's/var(--color-surface-3)/var(--bg-muted)/g' \
    -e 's/var(--color-surface)/var(--bg-subtle)/g' \
    -e 's/var(--color-bg)/var(--bg-base)/g' \
    -e 's/var(--color-border-light)/var(--border-subtle)/g' \
    -e 's/var(--color-border)/var(--border-default)/g' \
    -e 's/var(--color-text-secondary)/var(--text-secondary)/g' \
    -e 's/var(--color-text-primary)/var(--text-primary)/g' \
    -e 's/var(--color-text-muted)/var(--text-tertiary)/g' \
    -e 's/var(--color-text-subtle)/var(--text-tertiary)/g' \
    theme/assets/css/components.css
  ```

- [ ] **Step 2: Verify no old color token names remain**

  ```bash
  grep -c "var(--color-bg)\|var(--color-surface\|var(--color-border)\|var(--color-border-light)\|var(--color-text-primary)\|var(--color-text-secondary)\|var(--color-text-muted)\|var(--color-text-subtle)" theme/assets/css/components.css
  ```
  Expected: `0`

- [ ] **Step 3: Commit**

  ```bash
  git add theme/assets/css/components.css
  git commit -m "refactor: rename color tokens in components.css to campfire conventions"
  ```

---

## Task 8: Token rename — components.css spacing tokens

**Files:**
- Modify: `theme/assets/css/components.css`

224 spacing token references.

- [ ] **Step 1: Run spacing token rename**

  ```bash
  sed -i '' 's/var(--space-\([0-9]*\))/var(--spacing-\1)/g' theme/assets/css/components.css
  ```

- [ ] **Step 2: Verify no old spacing tokens remain**

  ```bash
  grep -c "var(--space-" theme/assets/css/components.css
  ```
  Expected: `0`

- [ ] **Step 3: Commit**

  ```bash
  git add theme/assets/css/components.css
  git commit -m "refactor: rename spacing tokens in components.css to campfire conventions"
  ```

---

## Task 9: Token rename — components.css radius tokens

**Files:**
- Modify: `theme/assets/css/components.css`

30 radius token references.

- [ ] **Step 1: Run radius token rename**

  ```bash
  sed -i '' 's/var(--rounded-\([a-z0-9]*\))/var(--radius-\1)/g' theme/assets/css/components.css
  ```

- [ ] **Step 2: Verify no old radius tokens remain**

  ```bash
  grep -c "var(--rounded-" theme/assets/css/components.css
  ```
  Expected: `0`

- [ ] **Step 3: Commit**

  ```bash
  git add theme/assets/css/components.css
  git commit -m "refactor: rename radius tokens in components.css to campfire conventions"
  ```

---

## Task 10: Token rename — components.css font weight tokens

**Files:**
- Modify: `theme/assets/css/components.css`

44 font weight token references.

- [ ] **Step 1: Run font weight token rename**

  ```bash
  sed -i '' 's/var(--weight-\([a-z]*\))/var(--font-weight-\1)/g' theme/assets/css/components.css
  ```

- [ ] **Step 2: Verify no old weight tokens remain**

  ```bash
  grep -c "var(--weight-" theme/assets/css/components.css
  ```
  Expected: `0`

- [ ] **Step 3: Commit**

  ```bash
  git add theme/assets/css/components.css
  git commit -m "refactor: rename font-weight tokens in components.css to campfire conventions"
  ```

---

## Task 11: Token rename — components.css font-family tokens

**Files:**
- Modify: `theme/assets/css/components.css`

8 font-family token references (all `--font-primary` or `--font-primary-sm`). Replace with `--font-sans` (defined in tokens.css as the Manrope stack).

- [ ] **Step 1: Run font-family token rename**

  ```bash
  sed -i '' \
    -e 's/var(--font-primary-sm)/var(--font-sans)/g' \
    -e 's/var(--font-primary)/var(--font-sans)/g' \
    theme/assets/css/components.css
  ```

- [ ] **Step 2: Verify no old font-family tokens remain**

  ```bash
  grep -c "var(--font-primary" theme/assets/css/components.css
  ```
  Expected: `0`

- [ ] **Step 3: Commit**

  ```bash
  git add theme/assets/css/components.css
  git commit -m "refactor: rename font-family tokens in components.css to campfire conventions"
  ```

---

## Task 12: Full verification pass

**Files:** No changes — verification only.

- [ ] **Step 1: Confirm no unrenamed tokens remain in base.css or components.css**

  ```bash
  grep -n "var(--space-\|var(--rounded-\|var(--weight-\|var(--font-primary\|var(--color-bg)\|var(--color-surface\|var(--color-border)\|var(--color-border-light)\|var(--color-text-primary\|var(--color-text-secondary\|var(--color-text-muted\|var(--color-text-subtle" theme/assets/css/base.css theme/assets/css/components.css
  ```
  Expected: no output.

- [ ] **Step 2: Confirm campfire.css is in place**

  ```bash
  ls -lh theme/assets/css/campfire.css
  ```
  Expected: file exists, non-zero size.

- [ ] **Step 3: Open Docker Ghost instance and verify visually**

  ```bash
  docker compose up -d
  ```

  Open each URL and confirm the page renders correctly (no missing colors, correct fonts, dark mode works on a device/browser set to dark):
  - `http://localhost:2368/` — home page
  - `http://localhost:2368/writing/` — writing index
  - `http://localhost:2368/about/` — about page
  - `http://localhost:2368/now/` — now page
  - Any post URL — post page

- [ ] **Step 4: Open static files in browser and verify they render correctly**

  ```bash
  open static/home.html
  open static/post.html
  open static/now.html
  ```

  Confirm: fonts load (Fraunces for headings, Manrope for body), colors match expected theme, dark mode applies when system is set to dark.

- [ ] **Step 5: Run gscan to validate theme compatibility**

  ```bash
  cd theme && npx gscan . && cd ..
  ```
  Expected: 0 errors. 1 warning about custom fonts is normal and acceptable.

- [ ] **Step 6: Final commit**

  ```bash
  git add -A
  git commit -m "feat: migrate Ghost theme to @jeremyfuksa/campfire design system tokens"
  ```
