# Nav "Hire me" CTA Button Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the redundant "Work with me" nav link (which duplicates the "Work" link) with a visually distinct amber button labeled "Hire me" that links directly to `mailto:hello@jeremyfuksa.com`.

**Architecture:** Three file edits — the Handlebars navigation partial (match condition + class name), the CSS components file (new `.nav-cta-btn` rule), and the static HTML counterpart — plus a manual Ghost Admin navigation update documented as a deployment step.

**Tech Stack:** Ghost 6 Handlebars templates, vanilla CSS with custom property tokens, no build step.

---

## File Map

| File | Change |
|---|---|
| `theme/partials/navigation.hbs` | Change match label from `"Work with me"` → `"Hire me"`, class from `nav-cta` → `nav-cta-btn` |
| `theme/assets/css/components.css` | Add `.nav-links .nav-cta-btn` and `.nav-links .nav-cta-btn:hover` rules after existing `.nav-cta` block (lines 136–143) |
| `static/work.html` | Update CTA nav item: label → "Hire me", href → `mailto:hello@jeremyfuksa.com`, class → `nav-cta-btn` |

---

## Task 1: Update navigation.hbs

**Files:**
- Modify: `theme/partials/navigation.hbs`

This project has no automated tests for Handlebars templates — verification is visual via browser. The steps below reflect that.

- [ ] **Step 1: Edit navigation.hbs**

Replace the entire file content with:

```handlebars
{{#foreach navigation}}
  {{#match label "Hire me"}}
    <li><a href="{{url}}" class="nav-cta-btn">{{label}}</a></li>
  {{else}}
    <li><a href="{{url}}" class="{{link_class for=url}}">{{label}}</a></li>
  {{/match}}
{{/foreach}}
```

Note: `link_class` is intentionally omitted on the `nav-cta-btn` branch. `mailto:` URLs don't match Ghost page routes, so `link_class` would always return empty. The button's styled appearance is its permanent state.

- [ ] **Step 2: Commit**

```bash
git add theme/partials/navigation.hbs
git commit -m "feat: update nav partial to match Hire me CTA label"
```

---

## Task 2: Add .nav-cta-btn CSS

**Files:**
- Modify: `theme/assets/css/components.css` (after line 143, after the `.nav-cta:hover` block)

The existing `.nav-cta` block (lines 136–143) is a text-link style. The new `.nav-cta-btn` is a filled button. Add it immediately after.

- [ ] **Step 1: Open components.css and locate the nav-cta block**

Find this existing block (around line 136):

```css
.nav-links .nav-cta {
  color: var(--color-nav-cta);
  font-weight: var(--font-weight-semibold);
}

.nav-links .nav-cta:hover {
  color: var(--color-nav-cta-hover);
}
```

- [ ] **Step 2: Add .nav-cta-btn immediately after .nav-cta:hover closing brace**

Insert these rules:

```css
.nav-links .nav-cta-btn {
  background: var(--color-accent-text);
  color: var(--bg-subtle);
  padding: var(--spacing-1) var(--spacing-3);
  border-radius: var(--radius-sm);
  font-weight: var(--font-weight-semibold);
  font-size: var(--text-sm);
  text-decoration: none;
  transition: opacity var(--transition-fast);
}

.nav-links .nav-cta-btn:hover {
  opacity: 0.85;
}
```

Token reference (all defined in campfire.css or tokens.css):
- `--color-accent-text`: `#b45309` light / `#f5a855` dark (amber)
- `--bg-subtle`: cream/white surface color used for button text on dark backgrounds (same as `.hero-cta`)
- `--spacing-1`: `0.25rem` (top/bottom padding)
- `--spacing-3`: `0.75rem` (left/right padding)
- `--radius-sm`: `0.375rem`
- `--font-weight-semibold`: `600`
- `--text-sm`: `0.875rem`
- `--transition-fast`: `150ms ease`

- [ ] **Step 3: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "feat: add nav-cta-btn filled button style"
```

---

## Task 3: Update static/work.html nav

**Files:**
- Modify: `static/work.html`

The static file mirrors the live theme. Per the project workflow, HTML structural changes must be kept in sync.

- [ ] **Step 1: Edit the CTA nav item in static/work.html**

Find this existing line (around line 50):

```html
<li><a href="work.html#work-with-me" class="nav-cta">Work with me</a></li>
```

Replace it with:

```html
<li><a href="mailto:hello@jeremyfuksa.com" class="nav-cta-btn">Hire me</a></li>
```

- [ ] **Step 2: Commit**

```bash
git add static/work.html
git commit -m "feat: update static work.html nav to Hire me CTA"
```

---

## Task 4: Verify locally

- [ ] **Step 1: Check Docker is running**

```bash
docker compose ps
```

Expected: Ghost container running. If not: `docker compose up -d`

- [ ] **Step 2: Open the local site in a browser**

Navigate to: `http://localhost:2368/work/`

Confirm:
- Nav shows: Writing · Work · Now · About · **[Hire me button]**
- "Hire me" renders as a filled amber button, not a text link
- Clicking "Hire me" opens a mail compose window to `hello@jeremyfuksa.com`
- "Work" nav item is still present and links to `/work/`
- "Work" nav item shows as active when on the work page

- [ ] **Step 3: Check dark mode**

Toggle system dark mode or use browser devtools to emulate `prefers-color-scheme: dark`.

Confirm:
- "Hire me" button is still visible and legible in dark mode (amber background with cream text)

---

## Task 5: Package and deploy

- [ ] **Step 1: Package theme**

```bash
cd /Users/jeremyfuksa/Dev/ghost/theme && zip -r ../the-cocktail-napkin.zip . -x "*.DS_Store" -x "*node_modules*"
```

Expected: `the-cocktail-napkin.zip` created/overwritten in the repo root.

- [ ] **Step 2: Upload theme to Ghost Admin**

1. Go to Ghost Admin: `https://beta.jeremyfuksa.com/ghost/`
2. Settings > Design > Change theme > Upload theme
3. Upload `the-cocktail-napkin.zip`
4. Activate the theme

- [ ] **Step 3: Update Ghost Admin navigation**

1. In Ghost Admin: Settings > Navigation
2. Find the "Work with me" entry
3. Change label to: `Hire me`
4. Change URL to: `mailto:hello@jeremyfuksa.com`
5. Save

- [ ] **Step 4: Verify production**

Navigate to `https://jeremyfuksa.com/work/`

Confirm:
- "Hire me" amber button appears in nav
- Clicking it opens a mail compose window to `hello@jeremyfuksa.com`
- No "Work with me" text link remains
