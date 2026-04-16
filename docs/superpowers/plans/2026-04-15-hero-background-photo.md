# Hero Background Photo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a full-bleed background photo to the home page hero section that fades to the page background at the bottom, with forced-light text for readability over the dark overlay.

**Architecture:** The photo is stored in `theme/assets/images/` and referenced entirely via CSS `background-image` — no markup changes. A dark semi-transparent overlay gradient is stacked on top of the photo in CSS, and the gradient fades to the page background color at the bottom. Text elements inside `.hero` are overridden to light/white values in a scoped CSS block. Two gradient variants (light mode, dark mode) follow the pattern already established for `.home-bg::before`.

**Tech Stack:** Vanilla CSS, Ghost Handlebars theme (no build step)

---

### Task 1: Add the photo to theme assets

**Files:**
- Create: `theme/assets/images/jeremy-hero.jpg`

The user has the photo in the conversation. It needs to be saved to `theme/assets/images/jeremy-hero.jpg`. This directory may not exist yet.

- [ ] **Step 1: Create the images directory**

```bash
mkdir -p theme/assets/images
```

- [ ] **Step 2: Save the photo**

Save the hero photo as `theme/assets/images/jeremy-hero.jpg`. The file was provided in the conversation as a JPEG image of Jeremy Fuksa standing in front of a forest background, wearing a dark jacket, looking slightly to the right.

- [ ] **Step 3: Verify the file exists**

```bash
ls -lh theme/assets/images/jeremy-hero.jpg
```

Expected: file listed with a reasonable size (likely 100KB–2MB for a full-quality photo).

- [ ] **Step 4: Commit**

```bash
git add theme/assets/images/jeremy-hero.jpg
git commit -m "feat: add hero background photo to theme assets"
```

---

### Task 2: Update `.hero` CSS — background image and overlay

**Files:**
- Modify: `theme/assets/css/components.css` (around line 706)

The current `.hero` rule is:

```css
.hero {
  padding: var(--spacing-24) var(--spacing-20);
  border-bottom: var(--border-hairline) solid var(--border-default);
}
```

- [ ] **Step 1: Replace the `.hero` rule**

Replace the existing `.hero` rule with:

```css
.hero {
  padding: var(--spacing-24) var(--spacing-20);
  background-image:
    linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.5) 60%, #f7f8f9 100%),
    url(../images/jeremy-hero.jpg);
  background-size: cover;
  background-position: center top;
  background-repeat: no-repeat;
}
```

Note: `border-bottom` is intentionally removed — the gradient fade replaces that visual separator. The light-mode fade target `#f7f8f9` is the value of `--neutral-50` / `--bg-base` in light mode.

- [ ] **Step 2: Open `static/home.html` in a browser and verify**

```bash
open static/home.html
```

Expected: hero section shows the photo full-bleed with a dark overlay. Text may not be readable yet (that's Task 3). The bottom of the hero should fade to the page background.

- [ ] **Step 3: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "feat: add full-bleed background photo to hero section"
```

---

### Task 3: Add dark mode gradient variant

**Files:**
- Modify: `theme/assets/css/components.css` (after the `.hero` rule, around line 712)

The dark mode page background is `#1c1f26` (`--neutral-950`). The fade target must be hardcoded (CSS custom properties can't be used inside `rgba()` stops). Follow the same dual-rule pattern used for `.home-bg::before` at lines 675–695.

- [ ] **Step 1: Add dark mode rules after the `.hero` rule**

After the `.hero` rule (and before `.hero-inner`), add:

```css
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) .hero {
    background-image:
      linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.5) 60%, #1c1f26 100%),
      url(../images/jeremy-hero.jpg);
  }
}

:root[data-theme="dark"] .hero {
  background-image:
    linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.5) 60%, #1c1f26 100%),
    url(../images/jeremy-hero.jpg);
}
```

- [ ] **Step 2: Verify dark mode in browser**

In `static/home.html`, temporarily add `class="dark"` to `<html>` and reload. The fade at the bottom should shift to the dark background color. Remove the temporary class when done.

- [ ] **Step 3: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "feat: add dark mode gradient variant for hero background"
```

---

### Task 4: Force light text colors inside `.hero`

**Files:**
- Modify: `theme/assets/css/components.css` (after the dark mode rules added in Task 3)

The existing text elements inside `.hero` use theme color tokens that will be too dark or wrong-colored over the photo. Override them to light/white values. These overrides must be high-specificity enough to beat both light and dark mode token values.

- [ ] **Step 1: Add scoped text color overrides**

After the dark mode `.hero` rules, add:

```css
/* Hero text — always light over photo background */
.hero .hero-eyebrow {
  color: rgba(255, 255, 255, 0.75);
}

.hero .hero-name {
  color: #ffffff;
}

.hero .hero-positioning {
  color: rgba(255, 255, 255, 0.85);
}

.hero .hero-proof {
  color: rgba(255, 255, 255, 0.65);
}

.hero .hero-meta-dot {
  background: rgba(255, 255, 255, 0.4);
}

.hero .hero-cta-secondary {
  color: rgba(255, 255, 255, 0.85);
}

.hero .hero-cta-secondary:hover {
  color: rgba(255, 255, 255, 1);
}
```

Note: `.hero-cta` (the button) is intentionally excluded — its accent background color is still readable and correct as-is.

- [ ] **Step 2: Open `static/home.html` in a browser and verify all text is readable**

```bash
open static/home.html
```

Check:
- Eyebrow text ("Independent Design Leader") is visible white/translucent
- Name ("Jeremy Fuksa") is bright white
- Positioning paragraph is clearly readable
- Proof pills (15+ years, Design Systems, etc.) are visible
- Separator dots between proof items are visible
- "See my work →" link is readable
- "Work with me" button still has its orange/amber background

- [ ] **Step 3: Verify dark mode text also looks correct**

Add `class="dark"` to `<html>` in `static/home.html`, reload, and confirm text is still light and readable. Remove the class when done.

- [ ] **Step 4: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "feat: force light text colors in hero over photo background"
```

---

### Task 5: Verify the Ghost HBS template path

**Files:**
- Read: `theme/custom-home.hbs`
- Potentially modify: `theme/assets/css/components.css` (image URL path)

The CSS `url(../images/jeremy-hero.jpg)` path is relative to the CSS file location (`theme/assets/css/`). Going up one level (`../`) lands in `theme/assets/`, then `images/jeremy-hero.jpg` resolves to `theme/assets/images/jeremy-hero.jpg`. This is correct for both the static file and Ghost (Ghost serves theme assets from the same relative structure).

- [ ] **Step 1: Confirm the relative path resolves correctly from the CSS file**

The CSS file is at `theme/assets/css/components.css`. The image is at `theme/assets/images/jeremy-hero.jpg`. The relative path from the CSS file is `../images/jeremy-hero.jpg`. Verify this by checking the image loads in the static browser preview from Task 4 Step 2.

- [ ] **Step 2: Check custom-home.hbs for any inline styles or background references that might conflict**

```bash
grep -n "hero\|background\|img" theme/custom-home.hbs
```

Expected: no inline background styles on the hero element. If any exist, remove them.

- [ ] **Step 3: Commit if any HBS changes were needed**

Only commit if Step 2 found something that needed changing:

```bash
git add theme/custom-home.hbs
git commit -m "fix: remove conflicting background style from hero in HBS template"
```

---

### Task 6: Final visual QA

No code changes — this is a verification pass.

- [ ] **Step 1: Full light mode review**

```bash
open static/home.html
```

Walk through visually:
- Photo fills the hero top-to-bottom
- Dark overlay makes text readable without being too heavy
- Bottom of hero fades cleanly to `#f7f8f9` (light page background)
- No hard edge where the hero ends
- All hero text is white/light
- CTA button retains its accent color
- Content below the hero (post cards, sidebar) looks normal

- [ ] **Step 2: Full dark mode review**

Add `class="dark"` to `<html>` in `static/home.html`, reload:
- Bottom of hero fades cleanly to `#1c1f26` (dark page background)
- Text still readable
- No visual seam at hero bottom

Remove the class when done.

- [ ] **Step 3: Mobile viewport check**

Use browser devtools to resize to 375px wide. Check:
- Photo still fills the hero at mobile width
- `background-position: center top` keeps the face visible
- Text doesn't overflow

- [ ] **Step 4: Final commit if any tweaks were made**

If any CSS adjustments were needed during QA (overlay opacity, background-position, min-height, etc.):

```bash
git add theme/assets/css/components.css
git commit -m "fix: hero photo QA adjustments"
```
