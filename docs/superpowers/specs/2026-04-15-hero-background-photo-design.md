# Hero Background Photo — Design Spec

**Date:** 2026-04-15
**Status:** Approved

---

## Overview

Add a full-bleed background photo to the home page hero section. The photo fades to the page background at the bottom so it blends seamlessly into the content below. Text is forced to light/cream values over the photo regardless of the user's light/dark mode preference, since the dark overlay ensures consistent contrast either way.

---

## Image

- **File:** `theme/assets/images/jeremy-hero.jpg`
- The photo is added to `theme/assets/images/` and packaged with the theme zip.
- In the static HTML file (`static/home.html`), the image is referenced via a relative path: `../theme/assets/images/jeremy-hero.jpg`.
- In `theme/custom-home.hbs`, the image is referenced via Ghost's asset helper: `{{asset "images/jeremy-hero.jpg"}}`.

---

## CSS — `.hero`

The `.hero` rule gains two background layers stacked via `background-image`:

1. **Dark overlay gradient** (top layer): `linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.5) 60%, <page-bg> 100%)`
   - Light mode fade target: `#f7f8f9` (maps to `--neutral-50` / `--bg-base`)
   - Dark mode fade target: `#1c1f26` (maps to `--neutral-950` / `--bg-base` in `.dark`)
   - Two separate rules are needed since CSS custom properties can't be used inside `rgba()` gradient stops for the fade color.
2. **Photo** (bottom layer): `url(...)` — `background-size: cover`, `background-position: center top`

The existing `border-bottom` on `.hero` is removed — the gradient fade replaces that visual separator.

`background-repeat: no-repeat` on `.hero`.

---

## Text Colors

A scoped block targets all text descendants of `.hero` and forces light values, overriding both light and dark mode:

| Element | Color |
|---|---|
| `.hero-eyebrow` | `rgba(255,255,255,0.75)` |
| `.hero-name` | `#ffffff` |
| `.hero-positioning` | `rgba(255,255,255,0.85)` |
| `.hero-proof` (spans) | `rgba(255,255,255,0.65)` |
| `.hero-meta-dot` | `rgba(255,255,255,0.4)` |
| `.hero-cta-secondary` | `rgba(255,255,255,0.85)` |

The `.hero-cta` button keeps its existing accent background — no change needed there.

These overrides use the same selectors already present in `components.css`, scoped inside a `.hero { }` block so they only apply within the hero.

---

## Dark Mode

Two gradient rules are needed in `components.css`:

- **Default / light mode:** fade to `#f7f8f9`
- **Dark mode** (`.dark .hero` or `@media (prefers-color-scheme: dark)` + `:root:not([data-theme="light"]) .hero`): fade to `#1c1f26`

Follow the same dual-rule pattern already used for `.home-bg::before` in `components.css` (lines 675–695).

---

## Static File Sync

`static/home.html` shares the same CSS files, so all style changes apply automatically. The only change needed in the HTML is none — the image reference is in CSS, not in markup.

The sync date comment at the top of `static/home.html` does not need updating (no structural HTML change).

---

## Files Changed

| File | Change |
|---|---|
| `theme/assets/images/jeremy-hero.jpg` | New file — hero photo |
| `theme/assets/css/components.css` | `.hero` background, text color overrides, dark mode gradient |
| `theme/custom-home.hbs` | No change needed (image is in CSS) |
| `static/home.html` | No change needed (image path is in CSS, relative path works) |
