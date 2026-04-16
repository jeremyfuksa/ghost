# Home Page Architecture Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the home page below-hero content with three new sections: a featured work card (Domain Foundation), a latest post + older posts sidebar grid, and a placeholder "Worked with" logo wall — while removing the hero CTA buttons.

**Architecture:** All changes are HTML markup + CSS only — no JavaScript, no Ghost data model changes. The HBS template uses Ghost's `{{#get}}` helper for dynamic post data; the static HTML file mirrors the structure with hardcoded content. New CSS classes are added to `components.css` following the existing token-based pattern.

**Tech Stack:** Vanilla CSS (token-based, no preprocessor), Ghost 6 Handlebars templates, static HTML for design iteration

---

## File Map

| File | What changes |
|---|---|
| `theme/custom-home.hbs` | Remove hero-actions div; replace home-grid with 3 new sections + Ghost helpers |
| `static/home.html` | Remove hero-actions div; replace home-grid with 3 new sections (hardcoded) |
| `theme/assets/css/components.css` | Add CSS for all new sections; no removals |

---

### Task 1: Remove hero CTA buttons from both files

**Files:**
- Modify: `theme/custom-home.hbs`
- Modify: `static/home.html`

The hero currently has a `<div class="hero-actions">` block in both files. Remove it entirely from both. Do NOT touch the `.hero-cta` or `.hero-cta-secondary` CSS rules — they may be used elsewhere.

- [ ] **Step 1: Remove hero-actions from `theme/custom-home.hbs`**

Open `theme/custom-home.hbs`. Find and remove this block (lines 18–21):

```html
    <div class="hero-actions">
      <a href="/work/" class="hero-cta">Work with me</a>
      <a href="/work/" class="hero-cta-secondary">See my work &rarr;</a>
    </div>
```

The file after removal should have the hero ending with the closing `</div>` of `.hero-proof`, then `</div>` closing `.hero-inner`, then `</section>`.

- [ ] **Step 2: Remove hero-actions from `static/home.html`**

Open `static/home.html`. Find and remove this block (around lines 84–88):

```html
        <div class="hero-actions">
          <a href="page.html" class="hero-cta">Work with me</a>
          <a href="page.html" class="hero-cta-secondary">See my work &rarr;</a>
        </div>
```

- [ ] **Step 3: Verify in browser**

```bash
open static/home.html
```

Expected: hero ends after the proof pills. No buttons visible.

- [ ] **Step 4: Commit**

```bash
git add theme/custom-home.hbs static/home.html
git commit -m "feat: remove hero CTA buttons"
```

---

### Task 2: Add CSS for Featured Work section

**Files:**
- Modify: `theme/assets/css/components.css` (append to the Home Page section, after existing hero rules)

The featured work card uses a dark background. The card title uses the cream heading color (`--color-text-heading` which is `#f5e6d0` in dark mode — but since this card is always dark, hardcode the cream value or use the token directly knowing it resolves correctly in both modes because the card background forces the dark context visually). Use `var(--color-text-heading)` — in dark mode it's already cream; in light mode it will be warm brown which still reads fine on a dark card background.

- [ ] **Step 1: Read the end of the Home Page section in components.css**

Read `theme/assets/css/components.css` from around line 795 onward to find where the hero section ends and identify the correct insertion point (after the last hero-related rule, before any other section).

- [ ] **Step 2: Add Featured Work CSS**

After the last hero rule block, add:

```css
/* ---------- Featured Work ---------- */

.featured-work {
  max-width: var(--content-max);
  margin: 0 auto;
  padding: var(--spacing-8) var(--spacing-8) 0;
}

.featured-work-inner > .section-title {
  display: block;
  margin-bottom: var(--spacing-4);
}

.featured-work-card {
  background: var(--bg-emphasis);
  border-radius: var(--radius-lg);
  padding: var(--spacing-8) var(--spacing-10);
  display: flex;
  flex-direction: column;
  gap: var(--spacing-3);
}

.featured-work-tag {
  font-size: var(--text-xs);
  font-weight: var(--font-weight-bold);
  letter-spacing: var(--tracking-widest);
  text-transform: uppercase;
  font-family: var(--font-mono);
  color: var(--color-accent-ui);
}

.featured-work-title {
  font-size: var(--text-2xl);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-heading);
  line-height: var(--leading-tight);
  margin: 0;
}

.featured-work-body {
  font-size: var(--text-base);
  line-height: var(--leading-base);
  color: var(--text-secondary);
  max-width: 640px;
  margin: 0;
}

.featured-work-link {
  font-size: var(--text-sm);
  font-weight: var(--font-weight-semibold);
  font-family: var(--font-mono);
  color: var(--color-accent-text);
  margin-top: var(--spacing-1);
  transition: color var(--transition-fast);
}

.featured-work-link:hover {
  color: var(--color-accent-hover);
}
```

- [ ] **Step 3: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "feat: add featured work section CSS"
```

---

### Task 3: Add CSS for home writing grid and sidebar posts

**Files:**
- Modify: `theme/assets/css/components.css` (append after featured work CSS)

The writing grid reuses the existing `home-grid` structure and dimensions. The `.post-card-featured` class extends the existing post card with a larger title. The sidebar post list is a new bare-links pattern.

- [ ] **Step 1: Add writing grid and sidebar CSS**

After the featured work CSS block, add:

```css
/* ---------- Home Writing Grid ---------- */

.home-writing-grid {
  display: grid;
  grid-template-columns: 1fr clamp(220px, 28%, 340px);
  gap: clamp(32px, 5vw, 64px);
  max-width: var(--content-max);
  margin: 0 auto;
  padding: var(--spacing-8) var(--spacing-8) var(--spacing-12);
}

.home-writing-grid > main > .section-title {
  display: block;
  margin-bottom: var(--spacing-4);
}

.post-card-featured {
  padding: var(--spacing-6) 0;
  border-bottom: none;
}

.post-card-featured .post-card-meta {
  margin-bottom: var(--spacing-3);
}

.post-card-featured .post-card-title {
  font-size: var(--text-3xl);
  letter-spacing: var(--tracking-tight);
  margin-bottom: var(--spacing-3);
  line-height: var(--leading-tight);
}

.post-card-featured .post-card-excerpt {
  font-size: var(--text-lg);
  line-height: var(--leading-lg);
  margin-bottom: var(--spacing-4);
}

/* Sidebar bare post list */

.sidebar-posts {
  display: flex;
  flex-direction: column;
  padding-top: var(--spacing-1);
}

.sidebar-post-link {
  display: block;
  font-size: var(--text-sm);
  line-height: var(--leading-base);
  color: var(--text-primary);
  padding: var(--spacing-3) 0;
  border-bottom: var(--border-hairline) solid var(--border-subtle);
  transition: color var(--transition-fast);
}

.sidebar-post-link:hover {
  color: var(--color-accent-text);
}

.sidebar-posts-all {
  display: block;
  font-size: var(--text-xs);
  font-family: var(--font-mono);
  font-weight: var(--font-weight-semibold);
  color: var(--color-accent-text);
  margin-top: var(--spacing-4);
  transition: color var(--transition-fast);
}

.sidebar-posts-all:hover {
  color: var(--color-accent-hover);
}
```

- [ ] **Step 2: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "feat: add home writing grid and sidebar posts CSS"
```

---

### Task 4: Add CSS for Worked With section

**Files:**
- Modify: `theme/assets/css/components.css` (append after writing grid CSS)

- [ ] **Step 1: Add Worked With CSS**

After the writing grid CSS block, add:

```css
/* ---------- Worked With ---------- */

.worked-with {
  max-width: var(--content-max);
  margin: 0 auto;
  padding: var(--spacing-8) var(--spacing-8) var(--spacing-16);
  border-top: var(--border-hairline) solid var(--border-subtle);
}

.worked-with-label {
  display: block;
  font-size: var(--text-xs);
  font-weight: var(--font-weight-bold);
  letter-spacing: var(--tracking-widest);
  text-transform: uppercase;
  font-family: var(--font-mono);
  color: var(--color-section-label);
  margin-bottom: var(--spacing-5);
}

.worked-with-logos {
  display: flex;
  align-items: center;
  gap: var(--spacing-8);
  flex-wrap: wrap;
}

.worked-with-logo-placeholder {
  width: 80px;
  height: 28px;
  background: var(--border-subtle);
  border-radius: var(--radius-sm);
  opacity: 0.5;
}
```

- [ ] **Step 2: Commit**

```bash
git add theme/assets/css/components.css
git commit -m "feat: add worked with section CSS"
```

---

### Task 5: Update `static/home.html` — replace home-grid with new sections

**Files:**
- Modify: `static/home.html`

Replace the entire `<div class="home-grid">...</div>` block with the three new sections. All content is hardcoded. Post links use `post.html` as placeholder href. Featured work link uses `page.html`.

- [ ] **Step 1: Replace home-grid in static/home.html**

Find and remove the entire `<div class="home-grid">` block (from the opening tag to its closing `</div>`, including the now-card, sidebar-about, sidebar-topics). Replace it with:

```html
    <section class="featured-work">
      <div class="featured-work-inner">
        <span class="section-title">Featured Work</span>
        <div class="featured-work-card">
          <span class="featured-work-tag">Experiments · AI-Augmented Design</span>
          <h2 class="featured-work-title">Domain Foundation</h2>
          <p class="featured-work-body">Fast doesn't matter in design when the output is just averaged training data. Domain Foundation is a methodology for building the knowledge layer that makes AI tools produce work that actually reflects your domain — not everyone else's.</p>
          <a href="page.html" class="featured-work-link">Read the case study &rarr;</a>
        </div>
      </div>
    </section>

    <div class="home-writing-grid">
      <main>
        <span class="section-title">Latest</span>
        <article class="post-card-featured">
          <div class="post-card-meta">
            <a href="tag.html" class="tag">AI</a>
            <span class="post-card-date"><time>Mar 22, 2026</time></span>
          </div>
          <a href="post.html"><h3 class="post-card-title">Prompt engineering is just design research with a different cursor</h3></a>
          <p class="post-card-excerpt">The skills that make someone good at user interviews turn out to be the same skills that make someone good at working with LLMs.</p>
          <div class="post-card-footer">
            <span class="post-card-readtime">5 min read</span>
            <a href="post.html" class="post-card-read-link">Read <span>&rarr;</span></a>
          </div>
        </article>
      </main>

      <aside class="sidebar">
        <nav class="sidebar-posts">
          <a href="post.html" class="sidebar-post-link">Why your design system needs a positioning statement</a>
          <a href="post.html" class="sidebar-post-link">The senior IC trap: when "staying technical" becomes a ceiling</a>
          <a href="post.html" class="sidebar-post-link">How I structure AI-assisted design reviews</a>
          <a href="post.html" class="sidebar-post-link">What makes a design system actually adopted</a>
          <a href="writing.html" class="sidebar-posts-all">All posts &rarr;</a>
        </nav>
      </aside>
    </div>

    <section class="worked-with">
      <div class="worked-with-inner">
        <span class="worked-with-label">Worked with</span>
        <div class="worked-with-logos">
          <div class="worked-with-logo-placeholder"></div>
          <div class="worked-with-logo-placeholder"></div>
          <div class="worked-with-logo-placeholder"></div>
          <div class="worked-with-logo-placeholder"></div>
        </div>
      </div>
    </section>
```

- [ ] **Step 2: Update the sync date comment at the top of static/home.html**

Find the comment near the top of the file:
```html
  Last synced: 2026-04-01
```
Change it to:
```html
  Last synced: 2026-04-15
```

- [ ] **Step 3: Open in browser and do a visual check**

```bash
open static/home.html
```

Check:
- Featured Work section appears below the hero with a dark card
- Domain Foundation title, tag, body copy, and link are all visible
- Writing grid shows latest post (large title) on the left, bare post list on the right
- Worked With section appears at the bottom with 4 grey placeholder rectangles
- No hero buttons visible

- [ ] **Step 4: Commit**

```bash
git add static/home.html
git commit -m "feat: replace home-grid with new sections in static/home.html"
```

---

### Task 6: Update `theme/custom-home.hbs` — replace home-grid with new sections

**Files:**
- Modify: `theme/custom-home.hbs`

Same structure as the static file but using Ghost Handlebars helpers for dynamic post data. The featured work card and worked-with section remain hardcoded.

- [ ] **Step 1: Replace home-grid in custom-home.hbs**

Find and remove the entire `<div class="home-grid">` block (from opening tag to its closing `</div>`, including the now-card partial, sidebar-about, and everything in the aside). Replace it with:

```handlebars
<section class="featured-work">
  <div class="featured-work-inner">
    <span class="section-title">Featured Work</span>
    <div class="featured-work-card">
      <span class="featured-work-tag">Experiments · AI-Augmented Design</span>
      <h2 class="featured-work-title">Domain Foundation</h2>
      <p class="featured-work-body">Fast doesn't matter in design when the output is just averaged training data. Domain Foundation is a methodology for building the knowledge layer that makes AI tools produce work that actually reflects your domain — not everyone else's.</p>
      <a href="/work/domain-foundation/" class="featured-work-link">Read the case study &rarr;</a>
    </div>
  </div>
</section>

<div class="home-writing-grid">
  <main>
    <span class="section-title">Latest</span>
    {{#get "posts" limit="1"}}
      {{#foreach posts}}
        <article class="post-card-featured">
          <div class="post-card-meta">
            {{#if primary_tag}}<a href="{{primary_tag.url}}" class="tag">{{primary_tag.name}}</a>{{/if}}
            <span class="post-card-date"><time datetime="{{date format="YYYY-MM-DD"}}">{{date format="MMM D, YYYY"}}</time></span>
          </div>
          <a href="{{url}}"><h3 class="post-card-title">{{title}}</h3></a>
          {{#if custom_excerpt}}<p class="post-card-excerpt">{{custom_excerpt}}</p>{{else}}<p class="post-card-excerpt">{{excerpt}}</p>{{/if}}
          <div class="post-card-footer">
            <span class="post-card-readtime">{{reading_time}}</span>
            <a href="{{url}}" class="post-card-read-link">Read <span>&rarr;</span></a>
          </div>
        </article>
      {{/foreach}}
    {{/get}}
  </main>

  <aside class="sidebar">
    <nav class="sidebar-posts">
      {{#get "posts" limit="5" offset="1"}}
        {{#foreach posts}}
          <a href="{{url}}" class="sidebar-post-link">{{title}}</a>
        {{/foreach}}
      {{/get}}
      <a href="/writing/" class="sidebar-posts-all">All posts &rarr;</a>
    </nav>
  </aside>
</div>

<section class="worked-with">
  <div class="worked-with-inner">
    <span class="worked-with-label">Worked with</span>
    <div class="worked-with-logos">
      <div class="worked-with-logo-placeholder"></div>
      <div class="worked-with-logo-placeholder"></div>
      <div class="worked-with-logo-placeholder"></div>
      <div class="worked-with-logo-placeholder"></div>
    </div>
  </div>
</section>
```

- [ ] **Step 2: Commit**

```bash
git add theme/custom-home.hbs
git commit -m "feat: replace home-grid with new sections in custom-home.hbs"
```

---

### Task 7: Final visual QA

No code changes — verification pass only.

- [ ] **Step 1: Static file full check**

```bash
open static/home.html
```

Walk through:
- Hero: no CTA buttons, proof pills still present
- Featured Work: dark card, tag in accent color, "Domain Foundation" title, body copy, "Read the case study →" link
- Writing grid: "Latest" label, featured post card with large title, excerpt, read link on left; bare post list on right; "All posts →" at bottom of sidebar
- Worked With: label + 4 grey placeholder rectangles
- No leftover now-card, sidebar-about, or topics markup

- [ ] **Step 2: Dark mode check**

Add `class="dark"` to `<html>` in `static/home.html`, reload. Check:
- Featured work card still reads clearly (dark card on dark bg — check contrast)
- Sidebar post links are visible
- Worked-with placeholders visible

Remove the class when done.

- [ ] **Step 3: Mobile check**

Open browser devtools, resize to 375px wide. Check:
- Writing grid stacks to single column (sidebar falls below main)
- Featured work card text doesn't overflow
- Worked-with logos wrap cleanly

- [ ] **Step 4: Commit any QA fixes**

If any CSS adjustments were needed:

```bash
git add theme/assets/css/components.css static/home.html
git commit -m "fix: home page architecture QA adjustments"
```
