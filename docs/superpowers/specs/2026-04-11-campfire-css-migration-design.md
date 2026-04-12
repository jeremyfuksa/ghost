# Campfire CSS Design System Migration

**Date:** 2026-04-11  
**Package:** `@jeremyfuksa/campfire@latest` (currently 0.2.0)  
**Scope:** Full token migration — replace current token vocabulary with campfire's canonical naming throughout the Ghost theme.

---

## Goals

- Install `@jeremyfuksa/campfire` as the authoritative CSS design system
- Replace all old token names in `base.css` and `components.css` with campfire's naming conventions
- Retain theme-specific tokens that campfire doesn't define (Fraunces heading font, nav/footer/accent colors, layout vars)
- Keep Fraunces for headings; campfire handles body typography (Manrope)
- Wire dark mode to campfire's `.dark` class via system-preference detection

---

## Approach

**Option 1 selected:** Extract from npm. A root `package.json` installs campfire as a dev dependency. A sync script copies `styles.css` from `node_modules` into `theme/assets/css/campfire.css`. The theme never edits `campfire.css` — it's regenerated on update.

---

## File Changes

### New files
- `/package.json` — root npm manifest with campfire dev dependency + sync script
- `/.gitignore` — add `node_modules/` and `package-lock.json` (dev tooling only, not committed)
- `theme/assets/css/campfire.css` — copied from npm via `npm run sync-campfire`, never edited

### Modified files
- `theme/assets/css/screen.css` — updated import order
- `theme/assets/css/tokens.css` — rewritten as overrides-only file
- `theme/assets/css/base.css` — token rename pass
- `theme/assets/css/components.css` — token rename pass (largest change)
- `theme/default.hbs` — dark mode script + campfire.css link
- `static/*.html` (8 files) — campfire.css link added

---

## CSS Import Order

### `screen.css` (used by Ghost in production)
```css
@import 'campfire.css';   /* foundation: palette + semantic tokens + typography globals */
@import 'tokens.css';     /* theme overrides: Fraunces, nav/footer/accent colors, layout vars */
@import 'base.css';
@import 'components.css';
```

### Static HTML files (loaded via `<link>` tags, `@import` fails over `file://`)
```html
<link rel="stylesheet" href="../theme/assets/css/campfire.css">
<link rel="stylesheet" href="../theme/assets/css/tokens.css">
<link rel="stylesheet" href="../theme/assets/css/base.css">
<link rel="stylesheet" href="../theme/assets/css/components.css">
```

---

## Root `package.json`

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

Run `npm install && npm run sync-campfire` to install and copy campfire's CSS. Re-run `npm run sync-campfire` after any campfire update.

---

## `tokens.css` — Overrides Only

After migration, `tokens.css` holds only what campfire doesn't define. The raw palette block (`--primary-*`, `--secondary-*`, `--neutral-*`), spacing tokens, radius tokens, weight tokens, and generic semantic color tokens are all removed — campfire owns those.

### Stays in `tokens.css`

**Typography (theme-specific):**
- `--font-heading: 'Fraunces', Georgia, serif`
- `--color-text-heading` — warm brown (light) / cream (dark)
- `--leading-h1`, `--leading-h2`, `--leading-h3`, `--leading-xs` through `--leading-5xl`
- `--tracking-tight`, `--tracking-snug`, `--tracking-wide`, `--tracking-wider`, `--tracking-widest`

**Layout:**
- `--content-max`, `--prose-max`, `--nav-height`, `--sidebar-home`, `--sidebar-writing`

**Borders (hairline weights, not in campfire):**
- `--border-hairline: 0.5px`
- `--border-thin: 1.5px`
- `--border-blockquote: 2px`

**Sizing:**
- `--size-dot-sm`, `--size-dot`, `--size-avatar`, `--size-card-thumb`, `--size-card-image`, `--size-featured-image`, `--size-featured-image-sm`

**Theme accent colors (amber — not in campfire):**
- `--color-accent-ui`, `--color-accent-text`, `--color-accent-hover`, `--color-accent-subtle`

**Page/component-specific colors:**
- Nav: `--color-nav-bg`, `--color-nav-border`, `--color-nav-author`, `--color-nav-link`, `--color-nav-active`, `--color-nav-active-border`, `--color-nav-cta`, `--color-nav-cta-hover`
- Footer: `--color-footer-bg`, `--color-footer-text`, `--color-footer-copy`, `--color-footer-nav-hover`, `--color-footer-tagline`
- Now page: `--color-now-bg`, `--color-now-border`, `--color-now-accent`
- Tags: `--color-tag-bg`, `--color-tag-text`
- Links: `--color-link`, `--color-link-hover`
- Logo: `--color-logo-bg`, `--color-logo-fg`
- Misc: `--color-eyebrow`, `--color-section-label`, `--color-blockquote-rule`, `--color-toc-active`

**Status aliases (point to campfire palette):**
- `--color-success: var(--success-500)`
- `--color-warning: var(--warning-500)`
- `--color-danger: var(--danger-500)`

**Dark mode:** Theme-specific dark overrides use `.dark` selector (matching campfire's approach), replacing the previous `@media (prefers-color-scheme: dark)` blocks.

---

## Token Rename Map

Full find-and-replace pass on `base.css` and `components.css`.

### Colors
| Old | New |
|-----|-----|
| `--color-bg` | `--bg-base` |
| `--color-surface` | `--bg-subtle` |
| `--color-surface-2` | `--bg-muted` |
| `--color-surface-3` | `--bg-muted` |
| `--color-border` | `--border-default` |
| `--color-border-light` | `--border-subtle` |
| `--color-text-primary` | `--text-primary` |
| `--color-text-secondary` | `--text-secondary` |
| `--color-text-muted` | `--text-tertiary` |
| `--color-text-subtle` | `--text-tertiary` |

### Spacing
| Old | New |
|-----|-----|
| `--space-1` | `--spacing-1` |
| `--space-2` | `--spacing-2` |
| `--space-3` | `--spacing-3` |
| `--space-4` | `--spacing-4` |
| `--space-5` | `--spacing-5` |
| `--space-6` | `--spacing-6` |
| `--space-8` | `--spacing-8` |
| `--space-10` | `--spacing-10` |
| `--space-12` | `--spacing-12` |
| `--space-16` | `--spacing-16` |
| `--space-20` | `--spacing-20` |
| `--space-24` | `--spacing-24` |

### Border Radius
| Old | New |
|-----|-----|
| `--rounded-sm` | `--radius-sm` |
| `--rounded-base` | `--radius-base` |
| `--rounded-md` | `--radius-md` |
| `--rounded-lg` | `--radius-lg` |
| `--rounded-xl` | `--radius-xl` |
| `--rounded-2xl` | `--radius-2xl` |
| `--rounded-full` | `--radius-full` |

### Font Weights
| Old | New |
|-----|-----|
| `--weight-light` | `--font-weight-light` |
| `--weight-regular` | `--font-weight-regular` |
| `--weight-medium` | `--font-weight-medium` |
| `--weight-semibold` | `--font-weight-semibold` |
| `--weight-bold` | `--font-weight-bold` |

### Font Families
| Old | New |
|-----|-----|
| `var(--font-primary)` | remove (campfire sets body font on `body` globally) |
| `var(--font-primary-sm)` | remove |

### No rename needed
`--text-*` (same names in campfire, values change from px → rem automatically), `--font-mono` (identical), `--leading-*`, `--tracking-*`, `--color-accent-*`, `--color-nav-*`, `--color-footer-*`, `--color-now-*`, `--color-text-heading`, `--font-heading`.

---

## Dark Mode Bridge

Campfire uses `.dark` on `<html>`. The theme keeps system-preference only (no toggle).

**Inline script added to `default.hbs` `<head>` before CSS links:**

```html
<script>
  if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
    document.documentElement.classList.add('dark');
  }
</script>
```

3 lines, vanilla JS, runs before first paint to prevent flash. Not a toggle — detection only.

The `@media (prefers-color-scheme: dark)` and `[data-theme="dark"]` blocks in `tokens.css` are removed and replaced with `.dark :root` / `.dark` selector blocks.

---

## Constraints Preserved

- All values continue to use CSS custom properties — no hardcoded pixels in `components.css`
- Fraunces heading font and variation settings unchanged
- Prose max-width `680px` unchanged
- No new JS dependencies beyond the 3-line dark mode detection snippet
- Hairline border weights (`0.5px`) unchanged
- `--color-accent-ui` vs `--color-accent-text` distinction preserved
