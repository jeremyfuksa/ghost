# Domain Foundation Case Study Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a public "Domain Foundation" case study page at `/work/domain-foundation/` following the per-case-study template pattern, with a sidebar containing 3 metadata fields and a 2×2 stats grid, and upgrade the Experiments work page card to a real link.

**Architecture:** No new CSS is needed — all required casestudy classes already exist in `components.css`. The pattern is identical to Terra (HBS template, hardcoded sidebar, `{{content}}` prose, stats grid) except with 3 metadata fields instead of 4 and no external links. Page seeded via `dev/setup.sh` using Python JSON encoding.

**Tech Stack:** Ghost 6 Handlebars theme, vanilla CSS (existing design tokens), bash + Python for Ghost Admin API seeding.

---

## File Map

| Action | File | Responsibility |
|--------|------|----------------|
| Create | `static/casestudy-domain-foundation.html` | Static design companion |
| Create | `theme/custom-casestudy-domain-foundation.hbs` | Domain Foundation Ghost template |
| Modify | `theme/routes.yaml` | Add `/work/domain-foundation/` route |
| Modify | `theme/custom-work.hbs` | Upgrade Experiments placeholder to real link card (lines 83–95) |
| Modify | `static/work.html` | Same upgrade in static companion (lines 110–121) |
| Modify | `dev/setup.sh` | Seed Domain Foundation page + assign template |

---

## Task 1: Create static/casestudy-domain-foundation.html

**Files:**
- Create: `static/casestudy-domain-foundation.html`

- [ ] **Step 1: Create the static companion file**

Create `static/casestudy-domain-foundation.html` with this exact content:

```html
<!--
  STATIC SOURCE for: theme/custom-casestudy-domain-foundation.hbs
  Last synced: 2026-04-12

  Handlebars differences:
  - {{#page}} context removed
  - {{title}} replaced with hardcoded "Domain Foundation"
  - {{content}} replaced with full prose HTML
-->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Domain Foundation — The Cocktail Napkin</title>
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
        <div class="casestudy-eyebrow">Experiments</div>
        <h1 class="casestudy-title">Domain Foundation</h1>
        <p class="casestudy-tagline">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.</p>
      </header>

      <div class="casestudy-body">
        <div class="casestudy-prose">

          <h2>Overview</h2>
          <p>AI design tools generate fast. They don't generate right — at least not without help. The gap isn't in the model's capability. It's in what the model knows about your specific domain, your users, your constraints, and why your design decisions exist.</p>
          <p>Domain Foundation is a structured approach to closing that gap. It's a methodology for building the knowledge layer that AI tools need to produce work that reflects real organizational expertise instead of averaged training data. I built it. I tested it. I documented what worked and what didn't. This case study covers the thinking, the architecture, and the findings.</p>

          <h2>The Problem</h2>
          <p>Design systems tell AI tools <em>what</em> to build. They don't tell them <em>why</em>.</p>
          <p>A component library encodes visual tokens, spacing rules, and interaction patterns. That's the what. But the reasoning behind those patterns — when a particular component is dangerous to use in a clinical context, why a specific workflow exists for medication ordering, what accessibility constraints are non-negotiable versus preferred — that knowledge lives in people's heads. When those people leave, the knowledge goes with them.</p>
          <p>AI tools trained on general data can produce design output that looks correct. It follows the tokens. It uses the right components. But without domain expertise, it can't distinguish between a layout that meets the requirements and a layout that meets the requirements <em>and won't get a nurse killed at 3 AM</em>.</p>
          <p>The problem isn't AI capability. It's AI context.</p>

          <h2>The Insight</h2>
          <p>Design systems need to become brains, not libraries.</p>
          <p>The shift is from documentation — "here's how to use this button" — to machine-queryable intelligence — "here's why this pattern exists, when it's safe to deviate, and what breaks if you get it wrong." That means encoding the institutional knowledge that experienced designers carry, the stuff that's never written down because everyone who needs it just knows it, into a structure that AI tools can consume alongside visual tokens and component specs.</p>

          <h2>The Architecture</h2>
          <p>Domain Foundation uses a four-layer knowledge model. Each layer has different owners, different update cadences, and different levels of stability.</p>
          <p><strong>Base layer — universal.</strong> Design principles, accessibility requirements, and interaction fundamentals that don't change across projects. Owned by the design system team.</p>
          <p><strong>Domain layer — industry.</strong> Clinical safety reasoning, regulatory constraints, compliance requirements, healthcare-specific interaction patterns. Owned by domain experts.</p>
          <p><strong>Component layer — artifact-specific.</strong> Intent metadata for individual components: when to use, when not to use, what breaks if misapplied. Owned by component authors.</p>
          <p><strong>Role layer — user context.</strong> The specific needs, workflows, and constraints of different user types. A nurse navigating a medication administration record has different requirements than a billing specialist reviewing claims. Owned by researchers.</p>
          <p>These layers compose at generation time. The AI draws from all four simultaneously. Different experts own different layers, which means the knowledge governance problem is distributed rather than centralized.</p>

          <h2>What I Built and Tested</h2>
          <p>This wasn't theoretical. I built working systems and ran structured experiments. Nine findings came out of that work.</p>
          <p><strong>On knowledge structure:</strong> External prompt references hosted as GitHub gists function as living knowledge artifacts — updates propagate automatically to every session. Mixed-structure prompting (prose for rationale, bullets for constraints, IF/THEN for conditional logic) significantly outperforms uniform formatting. There's a practical ceiling of roughly 3,500 tokens for individual guidelines documents before retrieval quality degrades.</p>
          <p><strong>On generation fidelity:</strong> Descriptive layer naming alone achieves approximately 90% generation fidelity in Figma Make — meaning clear, structured naming of design layers does most of the heavy lifting before any additional knowledge is injected. The delta between bare prompts and domain-enriched prompts reveals exactly how much institutional context the AI actually needs for any given task.</p>
          <p><strong>On architecture:</strong> The knowledge base must be designed for both semantic (vector) retrieval and file-based retrieval simultaneously, because different tools consume knowledge differently. AI tools always fetch the latest version of external references — version pinning must be managed externally, not assumed. Pencil libraries in Figma cannot support internal component logic, a fundamental platform limitation that no amount of optimization will solve.</p>
          <p><strong>On workflow:</strong> A bootstrap-navigate-validate pattern keeps context windows lean: load safety-critical rules at session start, navigate domain knowledge on-demand during generation, run full validation server-side after generation completes. This solves the context window problem that everyone building knowledge-enhanced AI systems encounters.</p>

          <h2>The Frameworks</h2>
          <p>The experiment findings produced seven original frameworks.</p>
          <p><strong>The Validation Stack</strong> — A five-tier model for evaluating AI-generated output, ordered by cost and time investment: internal coherence (seconds), expert intuition (minutes), stakeholder alignment (hours), directional user signal (days), behavioral validation (weeks). Every tier catches different failure modes. Skipping tiers doesn't save time — it moves the cost downstream.</p>
          <p><strong>The Role Inversion Model</strong> — Designers shift from generators to validators. Researchers become reality anchors. Strategists become reasoning validators. System architects become safety systems architects. The people who thrive aren't the most skilled generators — they're the ones who built careers on <em>getting to right</em> rather than <em>being right</em>.</p>
          <p><strong>The Velocity Paradox</strong> — AI compresses generation time but not validation time. Organizations that optimize for speed without building validation architecture pay exponentially — they just pay later and all at once.</p>
          <p><strong>Design Systems as Executable Knowledge</strong> — The shift from documentation to machine-queryable intelligence. The design system becomes infrastructure that AI tools consume, not reference material that humans read.</p>
          <p><strong>The "Being Right vs. Getting to Right" Divide</strong> — Who thrives in AI-augmented workflows isn't predicted by skill type or seniority. It's predicted by identity orientation. People whose professional identity is tied to being the expert source of correct answers struggle. People whose identity is tied to navigating toward correct answers adapt.</p>
          <p><strong>The Four-Layer Knowledge Architecture</strong> — Described above. Base, domain, component, and role layers with distributed governance.</p>
          <p><strong>The Bootstrap-Navigate-Validate Pattern</strong> — The technical workflow architecture for keeping AI sessions lean while maintaining constraint coverage.</p>

          <h2>The Technical Stack</h2>
          <p>The architecture itself is not proprietary. It's an emerging pattern: vectorized database → MCP server → LLM.</p>
          <p>The value isn't in the stack diagram. It's in knowing what to put in the database (institutional knowledge, not just documentation), how to structure it (four-layer model with governance), and how to govern it (staging layer, confidence scoring, human curation).</p>
          <p>The system supports dual-path delivery: an ideal path through vectorization and semantic retrieval, and a fallback path through direct file routing. Same knowledge base structure serves both. Graceful degradation is built in.</p>

          <h2>Why This Matters</h2>
          <p>Every organization adopting AI design tools is about to discover that their design system isn't enough. They have the visual layer. They're missing the reasoning layer. The AI can build what you show it. It can't know what you know.</p>
          <p>The companies that figure this out early will have AI tools that produce work reflecting genuine organizational expertise. The ones that don't will have AI tools that produce plausible-looking work that misses every domain-specific constraint that makes their product safe, accessible, and effective.</p>
          <p>Domain Foundation is how you build the layer that makes the difference.</p>

          <h2>Current Status</h2>
          <p>The methodology is complete and validated. The repackaging for broader market application — removing employer-specific references, generalizing healthcare examples to any high-stakes domain — is underway.</p>
          <p>The frameworks and findings are domain-agnostic. Healthcare made them sharp. They apply anywhere the design decisions have consequences.</p>

        </div>

        <aside class="casestudy-sidebar">
          <div class="cs-meta-group">
            <div class="cs-meta-label">Role</div>
            <div class="cs-meta-value">Creator and primary researcher</div>
          </div>
          <div class="cs-meta-group">
            <div class="cs-meta-label">Timeline</div>
            <div class="cs-meta-value">2023–2024, ongoing</div>
          </div>
          <div class="cs-meta-group">
            <div class="cs-meta-label">Scope</div>
            <div class="cs-meta-value">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows</div>
          </div>

          <hr class="cs-divider">

          <div class="cs-stats">
            <div class="cs-stat">
              <div class="cs-stat-value">9</div>
              <div class="cs-stat-label">Findings</div>
            </div>
            <div class="cs-stat">
              <div class="cs-stat-value">7</div>
              <div class="cs-stat-label">Frameworks</div>
            </div>
            <div class="cs-stat">
              <div class="cs-stat-value">4</div>
              <div class="cs-stat-label">Knowledge layers</div>
            </div>
            <div class="cs-stat">
              <div class="cs-stat-value">5</div>
              <div class="cs-stat-label">Validation tiers</div>
            </div>
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
open static/casestudy-domain-foundation.html
```

Check: two-column layout, eyebrow "Experiments" in amber, H1 in Fraunces, all 9 H2 sections, sidebar has 3 metadata fields + divider + 2×2 stats grid, no links after stats.

- [ ] **Step 3: Commit**

```bash
git add static/casestudy-domain-foundation.html
git commit -m "feat: add casestudy-domain-foundation static companion"
```

---

## Task 2: Create theme/custom-casestudy-domain-foundation.hbs

**Files:**
- Create: `theme/custom-casestudy-domain-foundation.hbs`

- [ ] **Step 1: Create the HBS template**

Create `theme/custom-casestudy-domain-foundation.hbs`:

```handlebars
{{!< default}}

{{#page}}
<div class="casestudy-page">
  <a href="/work/" class="casestudy-back">← Work</a>

  <header class="casestudy-header">
    <div class="casestudy-eyebrow">Experiments</div>
    <h1 class="casestudy-title">{{title}}</h1>
    <p class="casestudy-tagline">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.</p>
  </header>

  <div class="casestudy-body">
    <div class="casestudy-prose">
      {{content}}
    </div>

    <aside class="casestudy-sidebar">
      <div class="cs-meta-group">
        <div class="cs-meta-label">Role</div>
        <div class="cs-meta-value">Creator and primary researcher</div>
      </div>
      <div class="cs-meta-group">
        <div class="cs-meta-label">Timeline</div>
        <div class="cs-meta-value">2023–2024, ongoing</div>
      </div>
      <div class="cs-meta-group">
        <div class="cs-meta-label">Scope</div>
        <div class="cs-meta-value">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows</div>
      </div>

      <hr class="cs-divider">

      <div class="cs-stats">
        <div class="cs-stat">
          <div class="cs-stat-value">9</div>
          <div class="cs-stat-label">Findings</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">7</div>
          <div class="cs-stat-label">Frameworks</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">4</div>
          <div class="cs-stat-label">Knowledge layers</div>
        </div>
        <div class="cs-stat">
          <div class="cs-stat-value">5</div>
          <div class="cs-stat-label">Validation tiers</div>
        </div>
      </div>
    </aside>
  </div>
</div>
{{/page}}
```

- [ ] **Step 2: Commit**

```bash
git add theme/custom-casestudy-domain-foundation.hbs
git commit -m "feat: add custom-casestudy-domain-foundation HBS template"
```

---

## Task 3: Update routes.yaml

**Files:**
- Modify: `theme/routes.yaml`

- [ ] **Step 1: Add the Domain Foundation route**

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
  /work/domain-foundation/:
    template: custom-casestudy-domain-foundation
    data: page.domain-foundation

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
git commit -m "feat: add /work/domain-foundation/ route"
```

---

## Task 4: Upgrade Experiments card on work page

**Files:**
- Modify: `theme/custom-work.hbs` (lines 83–95)
- Modify: `static/work.html` (lines 110–121)

- [ ] **Step 1: Update custom-work.hbs**

In `theme/custom-work.hbs`, find the Experiments block (lines 83–95):

```handlebars
    {{!-- Experiments --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Experiments</span>
      </div>
      <div class="work-category-body">
        <div class="work-card work-card-static">
          <h3 class="work-card-title">AI-augmented design workflows</h3>
          <p class="work-card-excerpt">What changes when AI is part of the toolchain — and what stubbornly doesn't. Live experiments, current as of this week.</p>
          <span class="work-card-meta">In progress</span>
        </div>
      </div>
    </div>
```

Replace with:

```handlebars
    {{!-- Experiments --}}
    <div class="work-category">
      <div class="work-category-header">
        <span class="work-category-label">Experiments</span>
      </div>
      <div class="work-category-body">
        <a href="/work/domain-foundation/" class="work-card">
          <h3 class="work-card-title">Domain Foundation</h3>
          <p class="work-card-excerpt">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.</p>
          <span class="work-card-meta">2023–ongoing</span>
        </a>
      </div>
    </div>
```

- [ ] **Step 2: Update static/work.html**

In `static/work.html`, find the Experiments block (lines 110–121):

```html
        <div class="work-category">
          <div class="work-category-header">
            <span class="work-category-label">Experiments</span>
          </div>
          <div class="work-category-body">
            <div class="work-card work-card-static">
              <h3 class="work-card-title">AI-augmented design workflows</h3>
              <p class="work-card-excerpt">What changes when AI is part of the toolchain — and what stubbornly doesn't.</p>
              <span class="work-card-meta">In progress</span>
            </div>
          </div>
        </div>
```

Replace with:

```html
        <div class="work-category">
          <div class="work-category-header">
            <span class="work-category-label">Experiments</span>
          </div>
          <div class="work-category-body">
            <a href="casestudy-domain-foundation.html" class="work-card">
              <h3 class="work-card-title">Domain Foundation</h3>
              <p class="work-card-excerpt">A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.</p>
              <span class="work-card-meta">2023–ongoing</span>
            </a>
          </div>
        </div>
```

Also update the sync date comment at the top of `static/work.html` to `Last synced: 2026-04-12` if not already current.

- [ ] **Step 3: Commit**

```bash
git add theme/custom-work.hbs static/work.html
git commit -m "feat: link Domain Foundation case study from work page"
```

---

## Task 5: Seed Domain Foundation page via setup.sh

**Files:**
- Modify: `dev/setup.sh`

**Edit 1:** After line 296 (closing `fi` of Cerner block), before line 298 (`# Test posts removed`), insert the Domain Foundation seeding block.

**Edit 2:** In the Re-sync block (around line 311), add the assign_template call after the Cerner line.

- [ ] **Step 1: Insert Domain Foundation seeding block**

In `dev/setup.sh`, after the closing `fi` of the Cerner block (line 296), insert:

```bash
# Domain Foundation case study — uses Python for safe JSON encoding of long HTML
DF_SLUG="domain-foundation"
DF_EXISTING=$(api GET "/ghost/api/admin/pages/slug/$DF_SLUG/" 2>/dev/null || echo "")
if echo "$DF_EXISTING" | grep -q "\"slug\":\"$DF_SLUG\""; then
  log "Page '$DF_SLUG' exists — skipping."
else
  DF_BODY=$(python3 - <<'PYEOF'
import json

html = """<h2>Overview</h2>
<p>AI design tools generate fast. They don\u2019t generate right \u2014 at least not without help. The gap isn\u2019t in the model\u2019s capability. It\u2019s in what the model knows about your specific domain, your users, your constraints, and why your design decisions exist.</p>
<p>Domain Foundation is a structured approach to closing that gap. It\u2019s a methodology for building the knowledge layer that AI tools need to produce work that reflects real organizational expertise instead of averaged training data. I built it. I tested it. I documented what worked and what didn\u2019t. This case study covers the thinking, the architecture, and the findings.</p>
<h2>The Problem</h2>
<p>Design systems tell AI tools <em>what</em> to build. They don\u2019t tell them <em>why</em>.</p>
<p>A component library encodes visual tokens, spacing rules, and interaction patterns. That\u2019s the what. But the reasoning behind those patterns \u2014 when a particular component is dangerous to use in a clinical context, why a specific workflow exists for medication ordering, what accessibility constraints are non-negotiable versus preferred \u2014 that knowledge lives in people\u2019s heads. When those people leave, the knowledge goes with them.</p>
<p>AI tools trained on general data can produce design output that looks correct. It follows the tokens. It uses the right components. But without domain expertise, it can\u2019t distinguish between a layout that meets the requirements and a layout that meets the requirements <em>and won\u2019t get a nurse killed at 3 AM</em>.</p>
<p>The problem isn\u2019t AI capability. It\u2019s AI context.</p>
<h2>The Insight</h2>
<p>Design systems need to become brains, not libraries.</p>
<p>The shift is from documentation \u2014 \u201chere\u2019s how to use this button\u201d \u2014 to machine-queryable intelligence \u2014 \u201chere\u2019s why this pattern exists, when it\u2019s safe to deviate, and what breaks if you get it wrong.\u201d That means encoding the institutional knowledge that experienced designers carry, the stuff that\u2019s never written down because everyone who needs it just knows it, into a structure that AI tools can consume alongside visual tokens and component specs.</p>
<h2>The Architecture</h2>
<p>Domain Foundation uses a four-layer knowledge model. Each layer has different owners, different update cadences, and different levels of stability.</p>
<p><strong>Base layer \u2014 universal.</strong> Design principles, accessibility requirements, and interaction fundamentals that don\u2019t change across projects. Owned by the design system team.</p>
<p><strong>Domain layer \u2014 industry.</strong> Clinical safety reasoning, regulatory constraints, compliance requirements, healthcare-specific interaction patterns. Owned by domain experts.</p>
<p><strong>Component layer \u2014 artifact-specific.</strong> Intent metadata for individual components: when to use, when not to use, what breaks if misapplied. Owned by component authors.</p>
<p><strong>Role layer \u2014 user context.</strong> The specific needs, workflows, and constraints of different user types. A nurse navigating a medication administration record has different requirements than a billing specialist reviewing claims. Owned by researchers.</p>
<p>These layers compose at generation time. The AI draws from all four simultaneously. Different experts own different layers, which means the knowledge governance problem is distributed rather than centralized.</p>
<h2>What I Built and Tested</h2>
<p>This wasn\u2019t theoretical. I built working systems and ran structured experiments. Nine findings came out of that work.</p>
<p><strong>On knowledge structure:</strong> External prompt references hosted as GitHub gists function as living knowledge artifacts \u2014 updates propagate automatically to every session. Mixed-structure prompting (prose for rationale, bullets for constraints, IF/THEN for conditional logic) significantly outperforms uniform formatting. There\u2019s a practical ceiling of roughly 3,500 tokens for individual guidelines documents before retrieval quality degrades.</p>
<p><strong>On generation fidelity:</strong> Descriptive layer naming alone achieves approximately 90% generation fidelity in Figma Make \u2014 meaning clear, structured naming of design layers does most of the heavy lifting before any additional knowledge is injected. The delta between bare prompts and domain-enriched prompts reveals exactly how much institutional context the AI actually needs for any given task.</p>
<p><strong>On architecture:</strong> The knowledge base must be designed for both semantic (vector) retrieval and file-based retrieval simultaneously, because different tools consume knowledge differently. AI tools always fetch the latest version of external references \u2014 version pinning must be managed externally, not assumed. Pencil libraries in Figma cannot support internal component logic, a fundamental platform limitation that no amount of optimization will solve.</p>
<p><strong>On workflow:</strong> A bootstrap-navigate-validate pattern keeps context windows lean: load safety-critical rules at session start, navigate domain knowledge on-demand during generation, run full validation server-side after generation completes. This solves the context window problem that everyone building knowledge-enhanced AI systems encounters.</p>
<h2>The Frameworks</h2>
<p>The experiment findings produced seven original frameworks.</p>
<p><strong>The Validation Stack</strong> \u2014 A five-tier model for evaluating AI-generated output, ordered by cost and time investment: internal coherence (seconds), expert intuition (minutes), stakeholder alignment (hours), directional user signal (days), behavioral validation (weeks). Every tier catches different failure modes. Skipping tiers doesn\u2019t save time \u2014 it moves the cost downstream.</p>
<p><strong>The Role Inversion Model</strong> \u2014 Designers shift from generators to validators. Researchers become reality anchors. Strategists become reasoning validators. System architects become safety systems architects. The people who thrive aren\u2019t the most skilled generators \u2014 they\u2019re the ones who built careers on <em>getting to right</em> rather than <em>being right</em>.</p>
<p><strong>The Velocity Paradox</strong> \u2014 AI compresses generation time but not validation time. Organizations that optimize for speed without building validation architecture pay exponentially \u2014 they just pay later and all at once.</p>
<p><strong>Design Systems as Executable Knowledge</strong> \u2014 The shift from documentation to machine-queryable intelligence. The design system becomes infrastructure that AI tools consume, not reference material that humans read.</p>
<p><strong>The \u201cBeing Right vs. Getting to Right\u201d Divide</strong> \u2014 Who thrives in AI-augmented workflows isn\u2019t predicted by skill type or seniority. It\u2019s predicted by identity orientation. People whose professional identity is tied to being the expert source of correct answers struggle. People whose identity is tied to navigating toward correct answers adapt.</p>
<p><strong>The Four-Layer Knowledge Architecture</strong> \u2014 Described above. Base, domain, component, and role layers with distributed governance.</p>
<p><strong>The Bootstrap-Navigate-Validate Pattern</strong> \u2014 The technical workflow architecture for keeping AI sessions lean while maintaining constraint coverage.</p>
<h2>The Technical Stack</h2>
<p>The architecture itself is not proprietary. It\u2019s an emerging pattern: vectorized database \u2192 MCP server \u2192 LLM.</p>
<p>The value isn\u2019t in the stack diagram. It\u2019s in knowing what to put in the database (institutional knowledge, not just documentation), how to structure it (four-layer model with governance), and how to govern it (staging layer, confidence scoring, human curation).</p>
<p>The system supports dual-path delivery: an ideal path through vectorization and semantic retrieval, and a fallback path through direct file routing. Same knowledge base structure serves both. Graceful degradation is built in.</p>
<h2>Why This Matters</h2>
<p>Every organization adopting AI design tools is about to discover that their design system isn\u2019t enough. They have the visual layer. They\u2019re missing the reasoning layer. The AI can build what you show it. It can\u2019t know what you know.</p>
<p>The companies that figure this out early will have AI tools that produce work reflecting genuine organizational expertise. The ones that don\u2019t will have AI tools that produce plausible-looking work that misses every domain-specific constraint that makes their product safe, accessible, and effective.</p>
<p>Domain Foundation is how you build the layer that makes the difference.</p>
<h2>Current Status</h2>
<p>The methodology is complete and validated. The repackaging for broader market application \u2014 removing employer-specific references, generalizing healthcare examples to any high-stakes domain \u2014 is underway.</p>
<p>The frameworks and findings are domain-agnostic. Healthcare made them sharp. They apply anywhere the design decisions have consequences.</p>"""

data = {
    "pages": [{
        "title": "Domain Foundation",
        "slug": "domain-foundation",
        "status": "published",
        "html": html,
        "custom_template": "custom-casestudy-domain-foundation"
    }]
}
print(json.dumps(data))
PYEOF
)
  if api POST "/ghost/api/admin/pages/?source=html" "$DF_BODY" >/dev/null 2>&1; then
    log "Created page '$DF_SLUG'."
  else
    err "Failed to create page '$DF_SLUG'."
  fi
fi
```

- [ ] **Step 2: Add assign_template call**

In `dev/setup.sh`, in the Re-sync block, find:

```bash
assign_template "seven-years-in-healthcare-ux" "custom-casestudy-cerner"
```

Replace with:

```bash
assign_template "seven-years-in-healthcare-ux" "custom-casestudy-cerner"
assign_template "domain-foundation" "custom-casestudy-domain-foundation"
```

- [ ] **Step 3: Commit**

```bash
git add dev/setup.sh
git commit -m "feat: seed domain-foundation page in setup.sh"
```

---

## Task 6: Upload routes and run setup.sh

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
==> Created page 'domain-foundation'.
```

(If it says "exists — skipping", the page was previously created. That's fine.)

---

## Task 7: End-to-end browser verification

No file changes — verification only.

- [ ] **Step 1: Open the case study page**

```bash
open http://localhost:2368/work/domain-foundation/
```

Verify:
- Two-column layout: prose left, sidebar right
- Eyebrow "Experiments" in amber
- H1 "Domain Foundation" in Fraunces
- All 9 H2 sections render with hairline top borders (except "Overview")
- Sidebar shows exactly 3 metadata fields: Role, Timeline, Scope
- One hairline divider below metadata
- 2×2 stats grid: 9 Findings / 7 Frameworks / 4 Knowledge layers / 5 Validation tiers
- Sidebar ends after stats — no links below

- [ ] **Step 2: Check the work page**

```bash
open http://localhost:2368/work/
```

Verify: "Experiments" category shows a clickable Domain Foundation card linking to `/work/domain-foundation/`, meta "2023–ongoing".

- [ ] **Step 3: Check dark mode**

macOS System Settings → Appearance → Dark. Reload both pages.

Verify: stat tiles use dark `--color-tag-bg`, text colors invert, eyebrow amber stays legible.

- [ ] **Step 4: Check mobile layout**

Browser DevTools → 375px viewport. Reload case study page.

Verify: sidebar appears above prose (order: -1), single-column layout, no horizontal overflow.

- [ ] **Step 5: Run gscan**

```bash
cd theme && npx gscan . && cd ..
```

Expected: 0 errors (1 warning for custom fonts is normal).

---

## Self-Review Notes

**Spec coverage:**
- ✅ Public, standalone page at `/work/domain-foundation/`
- ✅ Eyebrow "Experiments", correct tagline
- ✅ Template `custom-casestudy-domain-foundation.hbs`
- ✅ Sidebar: 3 metadata fields (Role, Timeline, Scope — no Organization)
- ✅ Sidebar: cs-divider before stats, no second divider after stats
- ✅ 2×2 stats: 9 Findings, 7 Frameworks, 4 Knowledge layers, 5 Validation tiers
- ✅ No external links in sidebar
- ✅ All 9 prose H2 sections in correct order
- ✅ Routes.yaml updated
- ✅ Experiments work page card upgraded from placeholder to real link
- ✅ Static companion created and updated
- ✅ Ghost page seeded via setup.sh with Python JSON encoding
- ✅ assign_template added to re-sync block
- ✅ No new CSS needed — all classes already exist
