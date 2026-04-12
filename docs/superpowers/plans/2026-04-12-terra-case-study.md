# Terra Case Study Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a public Terra Design System case study page at `/work/terra-design-system/` using a reusable per-case-study template pattern, and seed it into the local Ghost database.

**Architecture:** New `.casestudy-*` CSS classes appended to `components.css`. Each case study is a Ghost page with its own `custom-casestudy-{slug}.hbs` template — sidebar metadata hardcoded in the template, prose authored in Ghost Admin and rendered via `{{content}}`. The Terra page is seeded via an extension to `dev/setup.sh` using Python for safe JSON encoding.

**Tech Stack:** Ghost 6 Handlebars theme, vanilla CSS (design tokens from campfire.css + tokens.css), bash + Python for Ghost Admin API seeding.

---

## File Map

| Action | File | Responsibility |
|--------|------|----------------|
| Modify | `theme/assets/css/components.css` | Add all `.casestudy-*` and `.cs-*` styles |
| Create | `static/casestudy-terra.html` | Static design companion for the case study page |
| Create | `theme/custom-casestudy-terra.hbs` | Terra case study Ghost template |
| Modify | `theme/routes.yaml` | Add `/work/terra-design-system/` route |
| Modify | `theme/custom-work.hbs` | Upgrade Systems work card to real link |
| Modify | `static/work.html` | Same upgrade in static companion |
| Modify | `dev/setup.sh` | Seed Terra page into Ghost database |

---

## Task 1: Add casestudy CSS to components.css

**Files:**
- Modify: `theme/assets/css/components.css` (append after line 2369)

- [ ] **Step 1: Append the casestudy component styles**

Open `theme/assets/css/components.css` and add the following block at the very end of the file:

```css
/* ============================
   Case Study
   ============================ */

.casestudy-page {
  max-width: var(--content-max);
  margin: 0 auto;
  padding: var(--spacing-12) var(--spacing-8) var(--spacing-20);
}

.casestudy-back {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  color: var(--text-muted);
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: var(--spacing-2);
  margin-bottom: var(--spacing-8);
  letter-spacing: var(--tracking-wide);
}

.casestudy-back:hover {
  color: var(--color-accent-text);
}

.casestudy-header {
  margin-bottom: var(--spacing-10);
  padding-bottom: var(--spacing-8);
  border-bottom: var(--border-hairline) solid var(--border-default);
}

.casestudy-eyebrow {
  font-family: var(--font-mono);
  font-size: var(--text-2xs);
  text-transform: uppercase;
  letter-spacing: var(--tracking-widest);
  color: var(--color-accent-text);
  margin-bottom: var(--spacing-3);
}

.casestudy-title {
  font-family: var(--font-heading);
  font-size: var(--text-4xl);
  font-weight: 400;
  font-variation-settings: 'WONK' 1, 'opsz' 72;
  line-height: var(--leading-h1);
  color: var(--color-text-heading);
  margin-bottom: var(--spacing-3);
}

.casestudy-tagline {
  font-size: var(--text-base);
  color: var(--text-secondary);
  max-width: var(--prose-max);
  line-height: var(--leading-lg);
}

.casestudy-body {
  display: grid;
  grid-template-columns: 1fr 280px;
  gap: var(--spacing-16);
  align-items: start;
}

/* Prose */

.casestudy-prose {
  min-width: 0;
}

.casestudy-prose h2 {
  font-family: var(--font-heading);
  font-size: var(--text-xl);
  font-weight: 350;
  font-variation-settings: 'WONK' 1, 'opsz' 72;
  color: var(--color-text-heading);
  margin-top: var(--spacing-10);
  margin-bottom: var(--spacing-4);
  padding-top: var(--spacing-10);
  border-top: var(--border-hairline) solid var(--border-default);
}

.casestudy-prose h2:first-of-type {
  margin-top: 0;
  padding-top: 0;
  border-top: none;
}

.casestudy-prose p {
  font-size: var(--text-base);
  line-height: var(--leading-lg);
  color: var(--text-secondary);
  margin-bottom: var(--spacing-4);
}

.casestudy-prose p:last-child {
  margin-bottom: 0;
}

.casestudy-prose strong {
  font-weight: 600;
  color: var(--text-primary);
}

/* Sidebar */

.casestudy-sidebar {
  position: sticky;
  top: var(--spacing-6);
}

.cs-meta-group {
  margin-bottom: var(--spacing-5);
}

.cs-meta-label {
  font-family: var(--font-mono);
  font-size: var(--text-2xs);
  text-transform: uppercase;
  letter-spacing: var(--tracking-widest);
  color: var(--text-muted);
  margin-bottom: var(--spacing-1);
}

.cs-meta-value {
  font-family: var(--font-sans);
  font-size: var(--text-sm);
  color: var(--text-primary);
  line-height: var(--leading-sm);
}

.cs-divider {
  border: none;
  border-top: var(--border-hairline) solid var(--border-default);
  margin: var(--spacing-5) 0;
}

.cs-stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--spacing-3);
}

.cs-stat {
  background: var(--color-tag-bg);
  border-radius: var(--radius-sm);
  padding: var(--spacing-3);
}

.cs-stat-value {
  font-family: var(--font-heading);
  font-size: var(--text-2xl);
  font-weight: 400;
  font-variation-settings: 'WONK' 1, 'opsz' 72;
  color: var(--color-text-heading);
  line-height: 1;
  margin-bottom: var(--spacing-1);
}

.cs-stat-label {
  font-family: var(--font-mono);
  font-size: var(--text-3xs);
  text-transform: uppercase;
  letter-spacing: var(--tracking-wider);
  color: var(--text-muted);
  line-height: var(--leading-xs);
}

.cs-link {
  display: inline-flex;
  align-items: center;
  gap: var(--spacing-1);
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  color: var(--color-accent-text);
  text-decoration: none;
  margin-top: var(--spacing-4);
}

.cs-link:hover {
  color: var(--color-accent-hover);
  text-decoration: underline;
}

/* Mobile */

@media (max-width: 768px) {
  .casestudy-body {
    grid-template-columns: 1fr;
  }

  .casestudy-sidebar {
    position: static;
    order: -1;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "feat: add casestudy CSS component styles"
```

---

## Task 2: Create static/casestudy-terra.html

**Files:**
- Create: `static/casestudy-terra.html`

- [ ] **Step 1: Create the static companion file**

Create `static/casestudy-terra.html` with the following content:

```html
<!--
  STATIC SOURCE for: theme/custom-casestudy-terra.hbs
  Last synced: 2026-04-12

  Handlebars differences:
  - {{#page}} context removed
  - {{title}} replaced with hardcoded "Terra Design System"
  - {{content}} replaced with full prose HTML
-->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Terra Design System — The Cocktail Napkin</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,WONK@9..144,100..900,0..1&display=swap" rel="stylesheet">
  <script>
    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.documentElement.classList.add('dark');
    }
  </script>
  <link rel="stylesheet" href="../theme/assets/css/campfire.css">
  <link rel="stylesheet" href="../theme/assets/css/tokens.css">
  <link rel="stylesheet" href="../theme/assets/css/base.css">
  <link rel="stylesheet" href="../theme/assets/css/components.css">
</head>
<body class="page-template">

  <header class="nav">
    <div class="nav-inner">
      <a href="home.html" class="nav-brand">
        <div class="nav-logo">
          <svg viewBox="0 0 80 70" xmlns="http://www.w3.org/2000/svg" fill="none" width="18" height="16">
            <path d="M40,5 C22,5 8,19 8,37 C8,52 17,63 30,67 C26,59 29,49 40,44 C51,49 54,59 50,67 C63,63 72,52 72,37 C72,19 58,5 40,5Z" fill="var(--color-logo-fg)" opacity="0.85"/>
          </svg>
        </div>
        <div class="nav-name-stack">
          <span class="nav-site-name">The Cocktail Napkin</span>
          <span class="nav-author-name">Jeremy Fuksa</span>
        </div>
      </a>
      <nav>
        <ul class="nav-links">
          <li><a href="writing.html">Writing</a></li>
          <li><a href="work.html" class="nav-current">Work</a></li>
          <li><a href="now.html">Now</a></li>
          <li><a href="page.html">About</a></li>
          <li><a href="work.html#work-with-me" class="nav-cta">Work with me</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <div class="site-content">
    <div class="casestudy-page">
      <a href="work.html" class="casestudy-back">← Work</a>

      <header class="casestudy-header">
        <div class="casestudy-eyebrow">Systems work</div>
        <h1 class="casestudy-title">Terra Design System</h1>
        <p class="casestudy-tagline">Open-source React component library serving hundreds of teams across enterprise healthcare.</p>
      </header>

      <div class="casestudy-body">
        <div class="casestudy-prose">
          <h2>Overview</h2>
          <p>Terra is Cerner's open-source design system — 80+ React components, 200+ icons, and a comprehensive standards library built for healthcare applications at global scale. It provides the UI foundation for Cerner's Millennium platform: roughly 60 integrated clinical solutions used by approximately 1,500 healthcare organizations in 195 countries.</p>
          <p>I was one of two UX designers embedded with the Terra engineering team who worked directly in the React codebase. My role was ensuring that what got built actually matched what was designed — bridging the gap between UX standards and engineering implementation at the component level.</p>

          <h2>The Problem</h2>
          <p>Healthcare UI components don't get to be approximately right. A focus-trap bug in an alert component propagates across every product that consumes it. An icon that fails contrast requirements shows up in operating rooms and emergency departments.</p>
          <p>Terra's architecture solves this at scale — every consuming team inherits accessible, internationalized, responsive components without rebuilding that work themselves. But that architecture only works if the components faithfully implement the design standards. Catching those failures requires someone who can read both languages.</p>

          <h2>My Role</h2>
          <p><strong>PR review and UX sign-off.</strong> I reviewed pull requests for UX correctness — not just whether a component rendered, but whether focus management, keyboard navigation, and interaction behavior matched the published design standards and accessibility guidelines (125+ standards, 150+ accessibility guidelines targeting WCAG 2.1 AA).</p>
          <p><strong>In-code UX problem solving.</strong> When components had UX issues that required both design judgment and code-level debugging to resolve, I was one of two designers with the React fluency to work through them directly in the monorepo alongside engineers.</p>
          <p><strong>Icon library ownership.</strong> I maintained the Terra icon library — 200+ icons in a dedicated Git repository that the engineering team consumed into the component system. Full ownership of the pipeline from design asset to published repo.</p>
          <p><strong>Design advisory.</strong> I didn't design Terra's components, but I advised on the proper construction of every component that came through — ensuring that interaction specifications, accessibility requirements, and visual standards were correctly interpreted and implemented.</p>

          <h2>The System</h2>
          <p>Terra's component ecosystem spans three repositories: terra-core (foundational components — buttons, alerts, forms), terra-framework (composed, higher-order patterns — navigation, layouts, modals), and terra-clinical (healthcare-specific components).</p>
          <p>Every component ships with accessibility, responsive design, internationalization, and cross-browser support built in. The consuming team gets all of that by default. At the scale of hundreds of product teams, each component represents engineering-weeks of accessibility and responsive work that would otherwise be duplicated — or more likely, done inconsistently or skipped entirely.</p>
          <p>The system is open source under an Apache 2.0 license. The code, the contribution guidelines, and the component documentation are all publicly available on GitHub.</p>

          <h2>Outcomes</h2>
          <p>80+ React components across three repositories, consumed by hundreds of product teams. 200+ icons maintained and published through a dedicated pipeline. 125+ design standards and 150+ accessibility guidelines implemented and verified at the component level. WCAG 2.1 AA targeted conformance baked into every component — keyboard navigation, screen reader support, focus management, color contrast. Global deployment across ~60 Millennium solutions, ~1,500 healthcare organizations, 195 countries. Open source — publicly verifiable on GitHub under the Cerner organization.</p>

          <h2>What Happened Next</h2>
          <p>In mid-2022, a few months before Oracle completed its $28.3 billion acquisition of Cerner, I moved from this hands-in-code IC role into design management — eventually leading a team of up to 12 across the US and India through the organizational transition.</p>
          <p>The leadership story is its own case study. But this is where it started: in the gap between what was designed and what was built, making sure the intent survived.</p>
        </div>

        <aside class="casestudy-sidebar">
          <div class="cs-meta-group">
            <div class="cs-meta-label">Role</div>
            <div class="cs-meta-value">UX Designer → UX Design Manager</div>
          </div>
          <div class="cs-meta-group">
            <div class="cs-meta-label">Organization</div>
            <div class="cs-meta-value">Cerner / Oracle Health</div>
          </div>
          <div class="cs-meta-group">
            <div class="cs-meta-label">Timeline</div>
            <div class="cs-meta-value">2018–2024</div>
          </div>
          <div class="cs-meta-group">
            <div class="cs-meta-label">Scope</div>
            <div class="cs-meta-value">Open-source React component library serving hundreds of teams across enterprise healthcare</div>
          </div>

          <hr class="cs-divider">

          <div class="cs-stats">
            <div class="cs-stat">
              <div class="cs-stat-value">80+</div>
              <div class="cs-stat-label">React components</div>
            </div>
            <div class="cs-stat">
              <div class="cs-stat-value">200+</div>
              <div class="cs-stat-label">Icons</div>
            </div>
            <div class="cs-stat">
              <div class="cs-stat-value">1,500</div>
              <div class="cs-stat-label">Healthcare orgs</div>
            </div>
            <div class="cs-stat">
              <div class="cs-stat-value">195</div>
              <div class="cs-stat-label">Countries</div>
            </div>
          </div>

          <hr class="cs-divider">

          <a href="https://github.com/cerner/terra-core" class="cs-link" target="_blank" rel="noopener">GitHub: terra-core ↗</a>
          <a href="https://github.com/cerner/terra-framework" class="cs-link" target="_blank" rel="noopener">GitHub: terra-framework ↗</a>
        </aside>
      </div>
    </div>
  </div>

  <footer class="site-footer">
    <div class="footer-inner">
      <div class="footer-brand">
        <span class="footer-brand-name">Jeremy Fuksa</span>
        <span class="footer-tagline">Jeremy Fuksa · Kansas City · KF0NUI</span>
      </div>
      <nav>
        <ul class="footer-nav">
          <li><a href="writing.html">Writing</a></li>
          <li><a href="work.html">Work</a></li>
          <li><a href="now.html">Now</a></li>
          <li><a href="page.html">About</a></li>
        </ul>
      </nav>
      <span class="footer-copy">&copy; 2026</span>
    </div>
  </footer>

</body>
</html>
```

- [ ] **Step 2: Open in browser and verify layout**

```bash
open static/casestudy-terra.html
```

Check: sidebar displays to the right of prose, stat grid is 2×2, back link appears, eyebrow is amber, H2s have hairline top borders (except "Overview").

- [ ] **Step 3: Commit**

```bash
git add static/casestudy-terra.html
git commit -m "feat: add casestudy-terra static companion"
```

---

## Task 3: Create theme/custom-casestudy-terra.hbs

**Files:**
- Create: `theme/custom-casestudy-terra.hbs`

- [ ] **Step 1: Create the HBS template**

Create `theme/custom-casestudy-terra.hbs`:

```handlebars
{{!< default}}

{{#page}}
<div class="casestudy-page">
  <a href="/work/" class="casestudy-back">← Work</a>

  <header class="casestudy-header">
    <div class="casestudy-eyebrow">Systems work</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">Open-source React component library serving hundreds of teams across enterprise healthcare.</p>
  </header>

  <div class="casestudy-body">
    <div class="casestudy-prose">
      {{content}}
    </div>

    <aside class="casestudy-sidebar">
      <div class="cs-meta-group">
        <div class="cs-meta-label">Role</div>
        <div class="cs-meta-value">UX Designer → UX Design Manager</div>
      </div>
      <div class="cs-meta-group">
        <div class="cs-meta-label">Organization</div>
        <div class="cs-meta-value">Cerner / Oracle Health</div>
      </div>
      <div class="cs-meta-group">
        <div class="cs-meta-label">Timeline</div>
        <div class="cs-meta-value">2018–2024</div>
      </div>
      <div class="cs-meta-group">
        <div class="cs-meta-label">Scope</div>
        <div class="cs-meta-value">Open-source React component library serving hundreds of teams across enterprise healthcare</div>
      </div>

      <hr class="cs-divider">

      <div class="cs-stats">
        <div class="cs-stat">
          <div class="cs-stat-value">80+</div>
          <div class="cs-stat-label">React components</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">200+</div>
          <div class="cs-stat-label">Icons</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">1,500</div>
          <div class="cs-stat-label">Healthcare orgs</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">195</div>
          <div class="cs-stat-label">Countries</div>
        </div>
      </div>

      <hr class="cs-divider">

      <a href="https://github.com/cerner/terra-core" class="cs-link" target="_blank" rel="noopener">GitHub: terra-core ↗</a>
      <a href="https://github.com/cerner/terra-framework" class="cs-link" target="_blank" rel="noopener">GitHub: terra-framework ↗</a>
    </aside>
  </div>
</div>
{{/page}}
```

- [ ] **Step 2: Commit**

```bash
git add theme/custom-casestudy-terra.hbs
git commit -m "feat: add custom-casestudy-terra HBS template"
```

---

## Task 4: Update routes.yaml

**Files:**
- Modify: `theme/routes.yaml`

- [ ] **Step 1: Add the Terra route**

Replace the contents of `theme/routes.yaml` with:

```yaml
routes:
  /:
    template: custom-home
    data: page.home
  /work/terra-design-system/:
    template: custom-casestudy-terra
    data: page.terra-design-system

collections:
  /writing/:
    permalink: /writing/{slug}/
    template: index

taxonomies:
  tag: /tag/{slug}/
```

- [ ] **Step 2: Commit**

```bash
git add theme/routes.yaml
git commit -m "feat: add /work/terra-design-system/ route"
```

---

## Task 5: Upgrade Systems work card on work page

**Files:**
- Modify: `theme/custom-work.hbs`
- Modify: `static/work.html`

- [ ] **Step 1: Update custom-work.hbs**

In `theme/custom-work.hbs`, find the Systems work category block (lines ~55–67) and replace the static placeholder card with a real link card:

Find:
```handlebars
    {{!-- Systems work --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Systems work</span>
      </div>
      <div class="work-category-body">
        <div class="work-card work-card-static">
          <h3 class="work-card-title">Design systems that ship</h3>
          <p class="work-card-excerpt">Tokens, components, governance, adoption. What it actually takes to make a design system stick — beyond the Figma library.</p>
          <span class="work-card-meta">Ongoing practice</span>
        </div>
      </div>
    </div>
```

Replace with:
```handlebars
    {{!-- Systems work --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Systems work</span>
      </div>
      <div class="work-category-body">
        <a href="/work/terra-design-system/" class="work-card">
          <h3 class="work-card-title">Terra Design System</h3>
          <p class="work-card-excerpt">Open-source React component library. 80+ components, 200+ icons, WCAG 2.1 AA. Cerner / Oracle Health, 2018–2024.</p>
          <span class="work-card-meta">2018–2024</span>
        </a>
      </div>
    </div>
```

- [ ] **Step 2: Update static/work.html**

In `static/work.html`, find the equivalent Systems work block (~lines 84–95) and replace with:

```html
        <div class="work-category">
          <div class="work-category-header">
            <span class="work-category-label">Systems work</span>
          </div>
          <div class="work-category-body">
            <a href="casestudy-terra.html" class="work-card">
              <h3 class="work-card-title">Terra Design System</h3>
              <p class="work-card-excerpt">Open-source React component library. 80+ components, 200+ icons, WCAG 2.1 AA. Cerner / Oracle Health, 2018–2024.</p>
              <span class="work-card-meta">2018–2024</span>
            </a>
          </div>
        </div>
```

- [ ] **Step 3: Commit**

```bash
git add theme/custom-work.hbs static/work.html
git commit -m "feat: link Terra case study from work page"
```

---

## Task 6: Seed Terra page via setup.sh

**Files:**
- Modify: `dev/setup.sh`

- [ ] **Step 1: Add seed call for terra-design-system**

In `dev/setup.sh`, find the content seeding block (around line 178, after the existing `seed_page` calls and before the navigation block). Add the following after the existing `seed_page "about" ...` line:

```bash
# Terra Design System case study — uses Python for safe JSON encoding of long HTML
TERRA_SLUG="terra-design-system"
TERRA_EXISTING=$(api GET "/ghost/api/admin/pages/slug/$TERRA_SLUG/" 2>/dev/null || echo "")
if echo "$TERRA_EXISTING" | grep -q "\"slug\":\"$TERRA_SLUG\""; then
  log "Page '$TERRA_SLUG' exists — skipping."
else
  TERRA_BODY=$(python3 - <<'PYEOF'
import json

html = """<h2>Overview</h2>
<p>Terra is Cerner\u2019s open-source design system \u2014 80+ React components, 200+ icons, and a comprehensive standards library built for healthcare applications at global scale. It provides the UI foundation for Cerner\u2019s Millennium platform: roughly 60 integrated clinical solutions used by approximately 1,500 healthcare organizations in 195 countries.</p>
<p>I was one of two UX designers embedded with the Terra engineering team who worked directly in the React codebase. My role was ensuring that what got built actually matched what was designed \u2014 bridging the gap between UX standards and engineering implementation at the component level.</p>
<h2>The Problem</h2>
<p>Healthcare UI components don\u2019t get to be approximately right. A focus-trap bug in an alert component propagates across every product that consumes it. An icon that fails contrast requirements shows up in operating rooms and emergency departments.</p>
<p>Terra\u2019s architecture solves this at scale \u2014 every consuming team inherits accessible, internationalized, responsive components without rebuilding that work themselves. But that architecture only works if the components faithfully implement the design standards. Catching those failures requires someone who can read both languages.</p>
<h2>My Role</h2>
<p><strong>PR review and UX sign-off.</strong> I reviewed pull requests for UX correctness \u2014 not just whether a component rendered, but whether focus management, keyboard navigation, and interaction behavior matched the published design standards and accessibility guidelines (125+ standards, 150+ accessibility guidelines targeting WCAG 2.1 AA).</p>
<p><strong>In-code UX problem solving.</strong> When components had UX issues that required both design judgment and code-level debugging to resolve, I was one of two designers with the React fluency to work through them directly in the monorepo alongside engineers.</p>
<p><strong>Icon library ownership.</strong> I maintained the Terra icon library \u2014 200+ icons in a dedicated Git repository that the engineering team consumed into the component system. Full ownership of the pipeline from design asset to published repo.</p>
<p><strong>Design advisory.</strong> I didn\u2019t design Terra\u2019s components, but I advised on the proper construction of every component that came through \u2014 ensuring that interaction specifications, accessibility requirements, and visual standards were correctly interpreted and implemented.</p>
<h2>The System</h2>
<p>Terra\u2019s component ecosystem spans three repositories: terra-core (foundational components \u2014 buttons, alerts, forms), terra-framework (composed, higher-order patterns \u2014 navigation, layouts, modals), and terra-clinical (healthcare-specific components).</p>
<p>Every component ships with accessibility, responsive design, internationalization, and cross-browser support built in. The consuming team gets all of that by default. At the scale of hundreds of product teams, each component represents engineering-weeks of accessibility and responsive work that would otherwise be duplicated \u2014 or more likely, done inconsistently or skipped entirely.</p>
<p>The system is open source under an Apache 2.0 license. The code, the contribution guidelines, and the component documentation are all publicly available on GitHub.</p>
<h2>Outcomes</h2>
<p>80+ React components across three repositories, consumed by hundreds of product teams. 200+ icons maintained and published through a dedicated pipeline. 125+ design standards and 150+ accessibility guidelines implemented and verified at the component level. WCAG 2.1 AA targeted conformance baked into every component \u2014 keyboard navigation, screen reader support, focus management, color contrast. Global deployment across ~60 Millennium solutions, ~1,500 healthcare organizations, 195 countries. Open source \u2014 publicly verifiable on GitHub under the Cerner organization.</p>
<h2>What Happened Next</h2>
<p>In mid-2022, a few months before Oracle completed its $28.3 billion acquisition of Cerner, I moved from this hands-in-code IC role into design management \u2014 eventually leading a team of up to 12 across the US and India through the organizational transition.</p>
<p>The leadership story is its own case study. But this is where it started: in the gap between what was designed and what was built, making sure the intent survived.</p>"""

data = {
    "pages": [{
        "title": "Terra Design System",
        "slug": "terra-design-system",
        "status": "published",
        "html": html,
        "custom_template": "custom-casestudy-terra"
    }]
}
print(json.dumps(data))
PYEOF
)
  if api POST "/ghost/api/admin/pages/?source=html" "$TERRA_BODY" >/dev/null 2>&1; then
    log "Created page '$TERRA_SLUG'."
  else
    err "Failed to create page '$TERRA_SLUG'."
  fi
fi
```

- [ ] **Step 2: Commit setup.sh**

```bash
git add dev/setup.sh
git commit -m "feat: seed terra-design-system page in setup.sh"
```

- [ ] **Step 3: Verify Docker is running**

```bash
docker compose ps
```

Expected output includes a `ghost` container with status `Up`. If not running:

```bash
docker compose up -d
# Wait ~10 seconds for Ghost to start
```

- [ ] **Step 4: Upload the updated routes.yaml to Ghost**

```bash
COOKIES=$(mktemp)
curl -s -c "$COOKIES" \
  -X POST http://localhost:2368/ghost/api/admin/session/ \
  -H "Content-Type: application/json" \
  -H "Origin: http://localhost:2368" \
  -H "Accept-Version: v5.0" \
  --data '{"username":"dev@local.test","password":"DevLocal12345!"}'

curl -s -b "$COOKIES" \
  -X POST http://localhost:2368/ghost/api/admin/settings/routes/yaml/ \
  -H "Origin: http://localhost:2368" \
  -H "Accept-Version: v5.0" \
  -F "routes=@theme/routes.yaml;type=application/x-yaml"

rm -f "$COOKIES"
```

Expected: JSON response with `{"routes":"..."}` content.

- [ ] **Step 5: Run setup.sh to seed the Terra page**

```bash
bash dev/setup.sh
```

Expected output includes:
```
==> Created page 'terra-design-system'.
```

(If it says "exists — skipping", the page was already created. That's fine.)

---

## Task 7: End-to-end browser verification

No file changes — verification only.

- [ ] **Step 1: Open the case study page**

```bash
open http://localhost:2368/work/terra-design-system/
```

Verify:
- Two-column layout: prose left, sidebar right
- Eyebrow "Systems work" in amber
- H1 "Terra Design System" in Fraunces
- All six H2 sections render with hairline top borders (except "Overview")
- Sidebar shows Role / Organization / Timeline / Scope
- 2×2 stat grid with warm background tiles
- GitHub links at bottom of sidebar

- [ ] **Step 2: Check the work page card**

```bash
open http://localhost:2368/work/
```

Verify the "Systems work" category shows a clickable Terra card that links to the case study page.

- [ ] **Step 3: Check dark mode**

In macOS System Settings → Appearance → Dark. Reload both pages.

Verify: stat tiles use dark `--color-tag-bg`, text colors invert correctly, eyebrow amber stays legible.

- [ ] **Step 4: Check mobile layout**

In browser DevTools, set viewport to 375px wide. Reload the case study page.

Verify: sidebar appears above the prose (order: -1), single-column layout, no horizontal overflow.

- [ ] **Step 5: Run gscan**

```bash
cd theme && npx gscan . && cd ..
```

Expected: 0 errors (1 warning for custom fonts is normal).

- [ ] **Step 6: Final commit**

```bash
git add -A
git status
# Confirm no unexpected files staged
git commit -m "chore: post-verification cleanup (if any)" --allow-empty
```

---

## Self-Review Notes

**Spec coverage check:**
- ✅ Public, standalone page at `/work/terra-design-system/`
- ✅ Sidebar layout (C) with Role, Org, Timeline, Scope, stats, GitHub links
- ✅ Per-case-study template architecture (A)
- ✅ CSS classes follow spec exactly
- ✅ Token usage: `--color-tag-bg`, `--color-accent-text`, `--border-hairline`, `--font-heading`, `--font-mono`
- ✅ Ghost content seeded via `dev/setup.sh`
- ✅ routes.yaml updated
- ✅ Work page card upgraded from placeholder to real link
- ✅ Static companions created and updated
- ✅ Dark mode handled by existing token system (no extra work needed)
- ✅ Mobile: sidebar collapses above prose via `order: -1`
