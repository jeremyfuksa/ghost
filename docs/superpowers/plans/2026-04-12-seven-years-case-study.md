# Seven Years in Healthcare UX — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a public "Seven Years in Healthcare UX" case study page at `/work/seven-years-in-healthcare-ux/` following the per-case-study template pattern established by Terra, including table CSS for the timeline section and upgrading the Leadership narratives work page card.

**Architecture:** All casestudy CSS is already in `components.css` — only new table rules need adding. The Cerner case study follows the same pattern as Terra: Ghost page + `custom-casestudy-cerner.hbs` template with hardcoded sidebar metadata and `{{content}}` for prose. Page seeded via `dev/setup.sh` using Python JSON encoding. Static companion mirrors the HBS template for local iteration.

**Tech Stack:** Ghost 6 Handlebars theme, vanilla CSS (design tokens from campfire.css + tokens.css), bash + Python for Ghost Admin API seeding.

---

## File Map

| Action | File | Responsibility |
|--------|------|----------------|
| Modify | `theme/assets/css/components.css` | Add `.casestudy-prose table/th/td` styles (insert after line 2474) |
| Create | `static/casestudy-cerner.html` | Static design companion for the Cerner case study |
| Create | `theme/custom-casestudy-cerner.hbs` | Cerner case study Ghost template |
| Modify | `theme/routes.yaml` | Add `/work/seven-years-in-healthcare-ux/` route |
| Modify | `theme/custom-work.hbs` | Upgrade Leadership narratives placeholder to real link card |
| Modify | `static/work.html` | Same upgrade in static companion |
| Modify | `dev/setup.sh` | Seed Cerner page + assign template |

---

## Task 1: Add table CSS to components.css

**Files:**
- Modify: `theme/assets/css/components.css` (insert after line 2474)

The casestudy block is already present. This task only adds the table rules. Insert them between `.casestudy-prose strong` (ends line 2474) and `/* Sidebar */` (line 2476).

- [ ] **Step 1: Insert table styles**

In `theme/assets/css/components.css`, find this block (lines 2471–2475):

```css
.casestudy-prose strong {
  font-weight: 600;
  color: var(--text-primary);
}
```

Replace with:

```css
.casestudy-prose strong {
  font-weight: 600;
  color: var(--text-primary);
}

.casestudy-prose a {
  color: var(--color-accent-text);
  text-decoration: none;
}

.casestudy-prose a:hover {
  text-decoration: underline;
}

.casestudy-prose table {
  width: 100%;
  border-collapse: collapse;
  margin-top: var(--spacing-5);
  font-size: var(--text-sm);
}

.casestudy-prose th {
  font-family: var(--font-mono);
  font-size: var(--text-2xs);
  text-transform: uppercase;
  letter-spacing: var(--tracking-widest);
  color: var(--text-tertiary);
  text-align: left;
  padding: var(--spacing-2) var(--spacing-3);
  border-bottom: var(--border-hairline) solid var(--border-default);
  font-weight: 500;
}

.casestudy-prose td {
  padding: var(--spacing-3);
  border-bottom: var(--border-hairline) solid var(--border-subtle);
  color: var(--text-secondary);
  vertical-align: top;
  line-height: var(--leading-sm);
}

.casestudy-prose tr:last-child td {
  border-bottom: none;
}

.casestudy-prose td:first-child {
  font-weight: 500;
  color: var(--text-primary);
}

.casestudy-prose td:nth-child(2) {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  color: var(--text-tertiary);
  white-space: nowrap;
}
```

- [ ] **Step 2: Verify in static file**

Open `static/casestudy-terra.html` in browser (`open static/casestudy-terra.html`) — existing Terra content should be unaffected (no tables there). If you have the Cerner static file already, open that instead.

- [ ] **Step 3: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "feat: add table and link styles to casestudy-prose"
```

---

## Task 2: Create static/casestudy-cerner.html

**Files:**
- Create: `static/casestudy-cerner.html`

- [ ] **Step 1: Create the static companion file**

Create `static/casestudy-cerner.html` with this content:

```html
<!--
  STATIC SOURCE for: theme/custom-casestudy-cerner.hbs
  Last synced: 2026-04-12

  Handlebars differences:
  - {{#page}} context removed
  - {{title}} replaced with hardcoded "Seven Years in Healthcare UX"
  - {{content}} replaced with full prose HTML
-->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Seven Years in Healthcare UX — The Cocktail Napkin</title>
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
        <div class="casestudy-eyebrow">Leadership narratives</div>
        <h1 class="casestudy-title">Seven Years in Healthcare UX</h1>
        <p class="casestudy-tagline">Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.</p>
      </header>

      <div class="casestudy-body">
        <div class="casestudy-prose">

          <h2>Overview</h2>
          <p>I joined Cerner in 2018 as a UX designer on the revenue cycle product. Three months later I moved to the UX Foundations team, where I spent three and a half years working directly in the Terra design system codebase alongside engineers. In mid-2022 I moved into design management, eventually leading designers across Kansas City, New York City, Brussels, Bangalore, Puducherry, Chennai, Florida, and North Carolina — through Oracle's acquisition of Cerner and everything that came with it.</p>
          <p>This is the full arc.</p>

          <h2>Revenue Cycle: Learning the Domain</h2>
          <p>My first assignment was middle office revenue cycle — the claims processing, denials management, and compliance work that keeps hospitals financially solvent. Not the clinical-facing work that makes it into conference talks. The operational infrastructure that revenue cycle teams stare at all day.</p>
          <p>The Millennium interface I walked into was dense. Aggressively dense. Data tables packed with status codes, payer information, denial reasons, dollar amounts, and dates — all competing for attention at the same priority level.</p>
          <p>My instinct was that the density was the problem. Information running together, no hierarchy, no clear path for the eye. I built a widget for care teams to check whether a patient's stay was still compliant — a specific, bounded piece of the larger workflow.</p>
          <p>What I learned in those three months changed how I thought about enterprise healthcare design. Providers want the density. They have reasons. A clinician managing a patient panel needs to scan large volumes of information quickly without drilling into detail views. The density isn't a design failure — it's a design requirement. The problem isn't how much data is on the screen. The problem is when that data runs together and distinctions disappear.</p>
          <p>That tension — between the density users need and the clarity they deserve — stayed with me for the next seven years.</p>

          <h2>Terra: Working in the Gap</h2>
          <p>Three months after joining, I moved to the UX Foundations team and the Terra design system. The details of that work are covered in a <a href="casestudy-terra.html">separate case study</a>, but the short version: I was one of two UX designers who could work directly in the React codebase alongside the Terra engineering team. I reviewed pull requests for UX correctness, resolved interaction and accessibility issues in code, owned the 200+ icon library, and advised on the construction of every component that came through.</p>
          <p>The role was defined by the space between design intent and engineering implementation — making sure that what got built actually honored the 125+ design standards and 150+ accessibility guidelines the system was built on.</p>
          <p>I did that work for roughly three and a half years.</p>

          <h2>Management: A Different Job</h2>
          <p>In mid-2022, a few months before Oracle completed its $28.3 billion acquisition of Cerner, I moved into design management. My hands-on IC work in the codebase effectively ended. The job became people.</p>
          <p>At its peak, I managed 12 designers spread across eight locations: Kansas City, New York City, Brussels, Bangalore, Puducherry, Chennai, Florida, and North Carolina. The work was mentoring, advocacy, career development, and keeping design quality consistent across a team that spanned three continents and rarely shared a time zone.</p>
          <p>Then Oracle's organizational philosophy took hold. Design managers were expected to operate as 80% IC, 20% manager. The team contracted through attrition and restructuring — people resigned, roles were consolidated. I went from twelve reports to five: three in Kansas City, one in New York, one in North Carolina.</p>
          <p>The shift wasn't just headcount. It was a fundamentally different idea of what design management means. At Cerner, managing designers was the job. Under Oracle, it was something you did on the side of your "real" work. I don't think those two philosophies are compatible, but I operated under both.</p>

          <h2>What I Protected</h2>
          <p>The period after the acquisition was not friendly to individual contributors. Promotions were nearly impossible to push through. Raises were rare. The organizational message, intended or not, was that growth had stopped.</p>
          <p>I got three of my reports promoted — with pay raises — during that window. It required building airtight justification packages and advocating through layers of new leadership who had no context on these designers' contributions. It was the most important management work I did at Oracle, and none of it shows up in a portfolio as a deliverable.</p>

          <h2>What I Carried Out</h2>
          <p>Seven years in healthcare enterprise UX taught me things that don't fit in a case study section header.</p>
          <p>Data density is a design requirement, not a design problem. The people using the software know more about their needs than you do — your job is to bring clarity to their requirements, not to override them with your preferences.</p>
          <p>Design systems are a coordination problem with a design surface. The components are the visible layer. The real work is the governance, the standards, the translation fidelity between what's specified and what ships.</p>
          <p>Management is advocacy. The deliverable is other people's growth. When the organization makes growth impossible, making it happen anyway is the job.</p>
          <p>The IC work and the management work both mattered. But they were different jobs, and pretending they're the same job done at different altitudes isn't honest.</p>

          <h2>Timeline</h2>
          <table>
            <thead>
              <tr>
                <th>Phase</th>
                <th>Dates</th>
                <th>Role</th>
                <th>Scope</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Revenue Cycle</td>
                <td>Sep–Dec 2018</td>
                <td>UX Designer</td>
                <td>Middle office product, patient stay compliance widget</td>
              </tr>
              <tr>
                <td>Terra / UX Foundations</td>
                <td>Dec 2018–Mid 2022</td>
                <td>Senior UX Designer</td>
                <td>Design system engineering partnership, PR review, icon library, design advisory</td>
              </tr>
              <tr>
                <td>Design Management</td>
                <td>Mid 2022–2024</td>
                <td>UX Design Manager</td>
                <td>5–12 reports across 8 locations, 3 continents; team leadership through Oracle acquisition</td>
              </tr>
            </tbody>
          </table>

        </div>

        <aside class="casestudy-sidebar">
          <div class="cs-meta-group">
            <div class="cs-meta-label">Role</div>
            <div class="cs-meta-value">UX Designer → Senior UX Designer → UX Design Manager</div>
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
            <div class="cs-meta-value">Revenue cycle product design, design system engineering partnership, distributed team leadership through a $28B acquisition</div>
          </div>
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
open static/casestudy-cerner.html
```

Check:
- Two-column layout: prose left, sidebar right
- Eyebrow "Leadership narratives" in amber
- H1 "Seven Years in Healthcare UX" in Fraunces
- All H2s have hairline top borders (except "Overview" — first-of-type rule removes it)
- Timeline table renders with mono column headers and hairline row separators
- Dates column is mono/muted
- Phase column is slightly bolder
- Sidebar shows 4 fields only — no stats grid, no links

- [ ] **Step 3: Commit**

```bash
git add static/casestudy-cerner.html
git commit -m "feat: add casestudy-cerner static companion"
```

---

## Task 3: Create theme/custom-casestudy-cerner.hbs

**Files:**
- Create: `theme/custom-casestudy-cerner.hbs`

- [ ] **Step 1: Create the HBS template**

Create `theme/custom-casestudy-cerner.hbs`:

```handlebars
{{!< default}}

{{#page}}
<div class="casestudy-page">
  <a href="/work/" class="casestudy-back">← Work</a>

  <header class="casestudy-header">
    <div class="casestudy-eyebrow">Leadership narratives</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.</p>
  </header>

  <div class="casestudy-body">
    <div class="casestudy-prose">
      {{content}}
    </div>

    <aside class="casestudy-sidebar">
      <div class="cs-meta-group">
        <div class="cs-meta-label">Role</div>
        <div class="cs-meta-value">UX Designer → Senior UX Designer → UX Design Manager</div>
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
        <div class="cs-meta-value">Revenue cycle product design, design system engineering partnership, distributed team leadership through a $28B acquisition</div>
      </div>
    </aside>
  </div>
</div>
{{/page}}
```

- [ ] **Step 2: Commit**

```bash
git add theme/custom-casestudy-cerner.hbs
git commit -m "feat: add custom-casestudy-cerner HBS template"
```

---

## Task 4: Update routes.yaml

**Files:**
- Modify: `theme/routes.yaml`

- [ ] **Step 1: Add the Cerner route**

Replace the contents of `theme/routes.yaml` with:

```yaml
routes:
  /:
    template: custom-home
    data: page.home
  /work/terra-design-system/:
    template: custom-casestudy-terra
    data: page.terra-design-system
  /work/seven-years-in-healthcare-ux/:
    template: custom-casestudy-cerner
    data: page.seven-years-in-healthcare-ux

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
git commit -m "feat: add /work/seven-years-in-healthcare-ux/ route"
```

---

## Task 5: Upgrade Leadership narratives card on work page

**Files:**
- Modify: `theme/custom-work.hbs` (lines 69–81)
- Modify: `static/work.html` (lines 97–108)

- [ ] **Step 1: Update custom-work.hbs**

In `theme/custom-work.hbs`, find the Leadership narratives block (lines 69–81):

```handlebars
    {{!-- Leadership narratives --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Leadership narratives</span>
      </div>
      <div class="work-category-body">
        <div class="work-card work-card-static">
          <h3 class="work-card-title">UX strategy tied to outcomes</h3>
          <p class="work-card-excerpt">Translating design work into the language the business uses to make decisions. Frameworks, artifacts, anti-patterns.</p>
          <span class="work-card-meta">Ongoing practice</span>
        </div>
      </div>
    </div>
```

Replace with:

```handlebars
    {{!-- Leadership narratives --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Leadership narratives</span>
      </div>
      <div class="work-category-body">
        <a href="/work/seven-years-in-healthcare-ux/" class="work-card">
          <h3 class="work-card-title">Seven Years in Healthcare UX</h3>
          <p class="work-card-excerpt">Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.</p>
          <span class="work-card-meta">2018–2024</span>
        </a>
      </div>
    </div>
```

- [ ] **Step 2: Update static/work.html**

In `static/work.html`, find the Leadership narratives block (lines 97–108):

```html
        <div class="work-category">
          <div class="work-category-header">
            <span class="work-category-label">Leadership narratives</span>
          </div>
          <div class="work-category-body">
            <div class="work-card work-card-static">
              <h3 class="work-card-title">UX strategy tied to outcomes</h3>
              <p class="work-card-excerpt">Translating design work into the language the business uses to make decisions. Frameworks, artifacts, anti-patterns.</p>
              <span class="work-card-meta">Ongoing practice</span>
            </div>
          </div>
        </div>
```

Replace with:

```html
        <div class="work-category">
          <div class="work-category-header">
            <span class="work-category-label">Leadership narratives</span>
          </div>
          <div class="work-category-body">
            <a href="casestudy-cerner.html" class="work-card">
              <h3 class="work-card-title">Seven Years in Healthcare UX</h3>
              <p class="work-card-excerpt">Revenue cycle product design, design system engineering, and distributed team leadership through a $28B acquisition.</p>
              <span class="work-card-meta">2018–2024</span>
            </a>
          </div>
        </div>
```

Also update the sync date comment at the top of `static/work.html` from its current date to `2026-04-12`.

- [ ] **Step 3: Commit**

```bash
git add theme/custom-work.hbs static/work.html
git commit -m "feat: link Seven Years case study from work page"
```

---

## Task 6: Seed Cerner page via setup.sh

**Files:**
- Modify: `dev/setup.sh`

The Terra seeding block ends at line 231 (`fi`). Insert the Cerner block immediately after (line 232), before the `# Test posts removed` comment.

- [ ] **Step 1: Add seed block for seven-years-in-healthcare-ux**

In `dev/setup.sh`, after the closing `fi` of the Terra block (line 231), add:

```bash
# Seven Years in Healthcare UX case study — uses Python for safe JSON encoding of long HTML
CERNER_SLUG="seven-years-in-healthcare-ux"
CERNER_EXISTING=$(api GET "/ghost/api/admin/pages/slug/$CERNER_SLUG/" 2>/dev/null || echo "")
if echo "$CERNER_EXISTING" | grep -q "\"slug\":\"$CERNER_SLUG\""; then
  log "Page '$CERNER_SLUG' exists — skipping."
else
  CERNER_BODY=$(python3 - <<'PYEOF'
import json

html = """<h2>Overview</h2>
<p>I joined Cerner in 2018 as a UX designer on the revenue cycle product. Three months later I moved to the UX Foundations team, where I spent three and a half years working directly in the Terra design system codebase alongside engineers. In mid-2022 I moved into design management, eventually leading designers across Kansas City, New York City, Brussels, Bangalore, Puducherry, Chennai, Florida, and North Carolina \u2014 through Oracle\u2019s acquisition of Cerner and everything that came with it.</p>
<p>This is the full arc.</p>
<h2>Revenue Cycle: Learning the Domain</h2>
<p>My first assignment was middle office revenue cycle \u2014 the claims processing, denials management, and compliance work that keeps hospitals financially solvent. Not the clinical-facing work that makes it into conference talks. The operational infrastructure that revenue cycle teams stare at all day.</p>
<p>The Millennium interface I walked into was dense. Aggressively dense. Data tables packed with status codes, payer information, denial reasons, dollar amounts, and dates \u2014 all competing for attention at the same priority level.</p>
<p>My instinct was that the density was the problem. Information running together, no hierarchy, no clear path for the eye. I built a widget for care teams to check whether a patient\u2019s stay was still compliant \u2014 a specific, bounded piece of the larger workflow.</p>
<p>What I learned in those three months changed how I thought about enterprise healthcare design. Providers want the density. They have reasons. A clinician managing a patient panel needs to scan large volumes of information quickly without drilling into detail views. The density isn\u2019t a design failure \u2014 it\u2019s a design requirement. The problem isn\u2019t how much data is on the screen. The problem is when that data runs together and distinctions disappear.</p>
<p>That tension \u2014 between the density users need and the clarity they deserve \u2014 stayed with me for the next seven years.</p>
<h2>Terra: Working in the Gap</h2>
<p>Three months after joining, I moved to the UX Foundations team and the Terra design system. The details of that work are covered in a <a href="/work/terra-design-system/">separate case study</a>, but the short version: I was one of two UX designers who could work directly in the React codebase alongside the Terra engineering team. I reviewed pull requests for UX correctness, resolved interaction and accessibility issues in code, owned the 200+ icon library, and advised on the construction of every component that came through.</p>
<p>The role was defined by the space between design intent and engineering implementation \u2014 making sure that what got built actually honored the 125+ design standards and 150+ accessibility guidelines the system was built on.</p>
<p>I did that work for roughly three and a half years.</p>
<h2>Management: A Different Job</h2>
<p>In mid-2022, a few months before Oracle completed its $28.3 billion acquisition of Cerner, I moved into design management. My hands-on IC work in the codebase effectively ended. The job became people.</p>
<p>At its peak, I managed 12 designers spread across eight locations: Kansas City, New York City, Brussels, Bangalore, Puducherry, Chennai, Florida, and North Carolina. The work was mentoring, advocacy, career development, and keeping design quality consistent across a team that spanned three continents and rarely shared a time zone.</p>
<p>Then Oracle\u2019s organizational philosophy took hold. Design managers were expected to operate as 80% IC, 20% manager. The team contracted through attrition and restructuring \u2014 people resigned, roles were consolidated. I went from twelve reports to five: three in Kansas City, one in New York, one in North Carolina.</p>
<p>The shift wasn\u2019t just headcount. It was a fundamentally different idea of what design management means. At Cerner, managing designers was the job. Under Oracle, it was something you did on the side of your \u201creal\u201d work. I don\u2019t think those two philosophies are compatible, but I operated under both.</p>
<h2>What I Protected</h2>
<p>The period after the acquisition was not friendly to individual contributors. Promotions were nearly impossible to push through. Raises were rare. The organizational message, intended or not, was that growth had stopped.</p>
<p>I got three of my reports promoted \u2014 with pay raises \u2014 during that window. It required building airtight justification packages and advocating through layers of new leadership who had no context on these designers\u2019 contributions. It was the most important management work I did at Oracle, and none of it shows up in a portfolio as a deliverable.</p>
<h2>What I Carried Out</h2>
<p>Seven years in healthcare enterprise UX taught me things that don\u2019t fit in a case study section header.</p>
<p>Data density is a design requirement, not a design problem. The people using the software know more about their needs than you do \u2014 your job is to bring clarity to their requirements, not to override them with your preferences.</p>
<p>Design systems are a coordination problem with a design surface. The components are the visible layer. The real work is the governance, the standards, the translation fidelity between what\u2019s specified and what ships.</p>
<p>Management is advocacy. The deliverable is other people\u2019s growth. When the organization makes growth impossible, making it happen anyway is the job.</p>
<p>The IC work and the management work both mattered. But they were different jobs, and pretending they\u2019re the same job done at different altitudes isn\u2019t honest.</p>
<h2>Timeline</h2>
<table>
<thead><tr><th>Phase</th><th>Dates</th><th>Role</th><th>Scope</th></tr></thead>
<tbody>
<tr><td>Revenue Cycle</td><td>Sep\u2013Dec 2018</td><td>UX Designer</td><td>Middle office product, patient stay compliance widget</td></tr>
<tr><td>Terra / UX Foundations</td><td>Dec 2018\u2013Mid 2022</td><td>Senior UX Designer</td><td>Design system engineering partnership, PR review, icon library, design advisory</td></tr>
<tr><td>Design Management</td><td>Mid 2022\u20132024</td><td>UX Design Manager</td><td>5\u201312 reports across 8 locations, 3 continents; team leadership through Oracle acquisition</td></tr>
</tbody>
</table>"""

data = {
    "pages": [{
        "title": "Seven Years in Healthcare UX",
        "slug": "seven-years-in-healthcare-ux",
        "status": "published",
        "html": html,
        "custom_template": "custom-casestudy-cerner"
    }]
}
print(json.dumps(data))
PYEOF
)
  if api POST "/ghost/api/admin/pages/?source=html" "$CERNER_BODY" >/dev/null 2>&1; then
    log "Created page '$CERNER_SLUG'."
  else
    err "Failed to create page '$CERNER_SLUG'."
  fi
fi
```

- [ ] **Step 2: Add assign_template call**

In `dev/setup.sh`, in the Re-sync custom templates block (around line 242), add the Cerner line after the Terra line:

Find:
```bash
assign_template "terra-design-system" "custom-casestudy-terra"
```

Replace with:
```bash
assign_template "terra-design-system" "custom-casestudy-terra"
assign_template "seven-years-in-healthcare-ux" "custom-casestudy-cerner"
```

- [ ] **Step 3: Commit**

```bash
git add dev/setup.sh
git commit -m "feat: seed seven-years-in-healthcare-ux page in setup.sh"
```

---

## Task 7: Upload routes and run setup.sh

No new files — deployment steps only.

- [ ] **Step 1: Verify Docker is running**

```bash
docker compose ps
```

Expected: `ghost` container with status `Up`. If not:

```bash
docker compose up -d
sleep 10
```

- [ ] **Step 2: Upload the updated routes.yaml to Ghost**

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

Expected: JSON response containing `"routes"` key.

- [ ] **Step 3: Run setup.sh**

```bash
bash dev/setup.sh
```

Expected output includes:
```
==> Created page 'seven-years-in-healthcare-ux'.
```

(If it says "exists — skipping", page was previously created. That's fine.)

---

## Task 8: End-to-end browser verification

No file changes — verification only.

- [ ] **Step 1: Open the Cerner case study page**

```bash
open http://localhost:2368/work/seven-years-in-healthcare-ux/
```

Verify:
- Two-column layout: prose left, sidebar right
- Eyebrow "Leadership narratives" in amber
- H1 "Seven Years in Healthcare UX" in Fraunces
- All H2s have hairline top borders (except "Overview" — first-of-type rule)
- "Terra: Working in the Gap" section contains a live link to `/work/terra-design-system/`
- Timeline table renders at bottom of prose with mono column headers
- Dates column is mono/muted
- Phase column is slightly bolder than other columns
- Sidebar shows exactly 4 fields: Role, Organization, Timeline, Scope — no stats grid, no links

- [ ] **Step 2: Check the work page**

```bash
open http://localhost:2368/work/
```

Verify:
- "Leadership narratives" category shows a clickable card linking to the Cerner case study
- Card title: "Seven Years in Healthcare UX"
- Card meta: "2018–2024"

- [ ] **Step 3: Check dark mode**

In macOS System Settings → Appearance → Dark. Reload both pages.

Verify: text colors invert correctly, eyebrow amber stays legible, table borders remain visible, sidebar metadata is readable.

- [ ] **Step 4: Check mobile layout**

In browser DevTools, set viewport to 375px wide. Reload the case study page.

Verify: sidebar appears above the prose (order: -1), single-column layout, table scrolls or wraps without horizontal overflow on the page container.

- [ ] **Step 5: Run gscan**

```bash
cd theme && npx gscan . && cd ..
```

Expected: 0 errors (1 warning for custom fonts is normal).

- [ ] **Step 6: Final commit if any cleanup needed**

```bash
git status
# If clean, nothing to do. If any stray changes:
git add <file>
git commit -m "chore: post-verification cleanup"
```

---

## Self-Review Notes

**Spec coverage check:**
- ✅ Public, standalone page at `/work/seven-years-in-healthcare-ux/`
- ✅ Two-column layout, sidebar 4 fields only (no stats, no links)
- ✅ Per-case-study template `custom-casestudy-cerner.hbs`
- ✅ Eyebrow "Leadership narratives", tagline matches spec
- ✅ Timeline as HTML table in prose (approach A confirmed by user)
- ✅ Artifacts section omitted
- ✅ Table CSS uses tokens only: `--font-mono`, `--text-tertiary`, `--border-hairline`, `--border-default`, `--border-subtle`, `--text-primary`, `--spacing-*`
- ✅ Link styles added to `.casestudy-prose a` (needed for Terra cross-link in prose)
- ✅ Routes.yaml updated with Cerner route
- ✅ Leadership narratives work page card upgraded
- ✅ Static companions created and updated
- ✅ Ghost page seeded via setup.sh with Python JSON encoding
- ✅ assign_template added to re-sync block
- ✅ Mobile handled by existing `order: -1` / single-column rules
- ✅ Dark mode handled by existing token system
