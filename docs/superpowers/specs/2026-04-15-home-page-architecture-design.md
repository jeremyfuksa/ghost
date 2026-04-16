# Home Page Architecture Redesign — Design Spec

**Date:** 2026-04-15
**Status:** Approved

---

## Overview

Rework the home page below the hero. Remove the hero CTA buttons. Replace the current two-column post grid + sidebar (with now-card, bio blurb, topics) with three stacked sections: featured work card, latest post + older posts sidebar, and a placeholder logo wall.

---

## Hero Changes

- Remove the `<div class="hero-actions">` block (and its two children: `.hero-cta` and `.hero-cta-secondary`) from both `static/home.html` and `theme/custom-home.hbs`.
- The `.hero-cta` and `.hero-cta-secondary` base CSS rules in `components.css` are kept — they may be used elsewhere. Only remove the markup from the hero.

---

## Section 1: Featured Work

A full-width dark card below the hero, introducing the featured project.

**Section label:** `Featured Work` (small uppercase mono label above the card, same style as existing `.section-title`)

**Card content (hardcoded in both static and HBS — no Ghost data fetch):**

- Tag line: `Experiments · AI-Augmented Design` (small uppercase mono, accent color)
- Title: `Domain Foundation`
- Body copy: *Fast doesn't matter in design when the output is just averaged training data. Domain Foundation is a methodology for building the knowledge layer that makes AI tools produce work that actually reflects your domain — not everyone else's.*
- Link: `Read the case study →` linking to `/work/domain-foundation/` (static: `page.html`)

**Styling:** Dark card (`--bg-inverse` or equivalent dark background), cream title, muted white body, accent-colored tag line and link. Consistent with the Domain Foundation card treatment explored in brainstorming (option A — text only, no gradient header, no stats).

**HTML structure:**
```html
<section class="featured-work">
  <div class="featured-work-inner">
    <span class="section-title">Featured Work</span>
    <div class="featured-work-card">
      <span class="featured-work-tag">Experiments · AI-Augmented Design</span>
      <h2 class="featured-work-title">Domain Foundation</h2>
      <p class="featured-work-body">Fast doesn't matter in design when the output is just averaged training data. Domain Foundation is a methodology for building the knowledge layer that makes AI tools produce work that actually reflects your domain — not everyone else's.</p>
      <a href="/work/domain-foundation/" class="featured-work-link">Read the case study →</a>
    </div>
  </div>
</section>
```

---

## Section 2: Latest Post + Older Posts Sidebar

A two-column grid replacing the current `home-grid`. Same grid structure (main + aside), new content.

**Left column — latest post (prominent)**

One post card, displayed larger than the current `.post-card` style. No feature image needed. Shows: tag + date (mono, muted), title (large, heading font), excerpt, read time + "Read →" link.

In Ghost: `{{#get "posts" limit="1"}}` — single latest post.
In static: one hardcoded post card example.

A new CSS class `.post-card-featured` handles the larger treatment — bigger title size, more padding — rather than modifying the existing `.post-card`.

A `Latest` section label (small uppercase mono) sits above the card.

**Right column — older posts (bare list)**

A bare list of 4–5 older post titles, each a plain link. No dates, no excerpts, no images. Separator between items. Followed by `All posts →` link at the bottom.

In Ghost: `{{#get "posts" limit="5" offset="1"}}`.
In static: 4 hardcoded post title links.

No section header on the sidebar — just the list, starting from the top of the column.

**HTML structure (sidebar):**
```html
<aside class="sidebar">
  <nav class="sidebar-posts">
    <a href="/writing/post-slug/" class="sidebar-post-link">Post title here</a>
    <!-- repeat -->
    <a href="/writing/" class="sidebar-posts-all">All posts →</a>
  </nav>
</aside>
```

---

## Section 3: Worked With (Placeholder)

A simple section at the bottom of the page with a `Worked with` label and placeholder logo slots. Fully hardcoded — no Ghost data. Will be replaced with real logos in a future pass.

Four placeholder logo slots (empty divs styled as grey rectangles). No links.

**HTML structure:**
```html
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

---

## CSS

New rules needed in `components.css`:

- `.featured-work` — section wrapper, max-width + padding
- `.featured-work-inner` — inner container
- `.featured-work-card` — dark background card
- `.featured-work-tag` — small uppercase mono, accent color
- `.featured-work-title` — heading font, cream color
- `.featured-work-body` — body text, muted white
- `.featured-work-link` — accent color, mono font
- `.post-card-featured` — larger post card treatment for the latest post
- `.sidebar-posts` — flex column list
- `.sidebar-post-link` — plain link with bottom border separator
- `.sidebar-posts-all` — "All posts →" accent link
- `.worked-with` — section wrapper
- `.worked-with-inner` — inner container
- `.worked-with-label` — small uppercase mono label
- `.worked-with-logos` — flex row of logo slots
- `.worked-with-logo-placeholder` — grey rectangle placeholder

All values use CSS custom property tokens. No hardcoded pixels except documented exceptions.

---

## Ghost Template Changes (`theme/custom-home.hbs`)

- Remove `hero-actions` div
- Replace current `home-grid` content with the three new sections
- Latest post: `{{#get "posts" limit="1"}}`
- Sidebar posts: `{{#get "posts" limit="5" offset="1"}}`
- Featured work card and worked-with section: hardcoded markup

---

## Static File Changes (`static/home.html`)

- Remove `hero-actions` div
- Replace current `home-grid` with the three new sections
- All content hardcoded (no Ghost helpers)
- Post links use `post.html` placeholder href
- Featured work link uses `page.html` placeholder href
- Update sync date comment to 2026-04-15

---

## Files Changed

| File | Change |
|---|---|
| `static/home.html` | Remove hero-actions, replace home-grid with 3 new sections |
| `theme/custom-home.hbs` | Remove hero-actions, replace home-grid with 3 new sections + Ghost helpers |
| `theme/assets/css/components.css` | New CSS rules for all new sections and components |
