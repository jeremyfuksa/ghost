# Home Page — Work Surfacing Proposal

**Date:** 2026-04-22
**Scope:** Improve how `/` surfaces Work, per your note: *"there needs to be a better surfacing of my work on the homepage."*

## Current state

The live home page (`custom-home.hbs`) has five sections in order:

1. **Hero** — Name + one-sentence positioning + three meta-dots ("30 years · AI-Augmented Design · UX Strategy · Design Systems")
2. **Featured Work** — One card, currently Domain Foundation
3. **Testimonial** — *Conditional; template queries for page slug `testimonial`. Not rendering because no such page exists.*
4. **Methodology trio** — *Conditional; template queries for `tag:hash-methodology`. Not rendering because no pages are tagged.*
5. **Writing grid** — Featured latest post + sidebar of 5 previous posts

What renders today: hero → one work card → writing grid. The two methodology / testimonial sections are silently absent.

## What's wrong with this

A hiring manager landing at `jeremyfuksa.com` in 2026 needs to form three impressions fast:

1. This person is senior.
2. This person has a body of work.
3. This person has a point of view.

The current home page delivers #1 (the hero's "30 years" + specialty tags) and #3 (the featured work card's thesis). It under-delivers on **#2 — the existence of a body of work**. The reader sees one case study link. The fact that there are three more case studies, a reworked Work index with three orbits, and four Demonstrations dispatches either coming or recently published isn't surfaced anywhere on the home page. The reader has to click into `/work/` to discover the portfolio.

That's a real gap. Home pages for senior practitioners are generally expected to telegraph the portfolio's breadth, not just its headline piece.

## What I'd propose

Rather than one big redesign, a focused addition: **insert a "The Work" section between Featured Work and the Writing grid**. It surfaces the three-orbit structure directly on the home page — headings, short blurbs, one representative card per orbit, and a "See everything" link to `/work/`.

### Proposed section structure

Eyebrow label: **"The Work"**

Three horizontal or vertical tiles:

**Tile 1 — Frameworks**
- Eyebrow: "Methodology"
- Title: Domain Foundation
- Blurb: "A methodology for encoding institutional design expertise into AI-reachable knowledge systems."
- Link: `/work/domain-foundation/`

**Tile 2 — Demonstrations**
- Eyebrow: "Applied practice"
- Title: *depends on what's published* — leading candidate: **The Skill Ecosystem** once it's live (strongest dispatch per the audit)
- Blurb: "Twenty-six encoded skills running a one-person design practice. Domain Foundation at individual scale."
- Link: `/writing/skill-ecosystem/`

**Tile 3 — Case Studies**
- Eyebrow: "Shipped work"
- Title: **Two Components That Didn't Ship** (the strongest case study per the audit)
- Blurb: "Health-specific components on Oracle's Redwood design system. The ones I remember best are the two we decided to kill."
- Link: `/work/redwood-health-design/`

Below the three tiles: a single "See all work →" link to `/work/`.

### Why these three picks (not others)

- **Domain Foundation for Frameworks:** only piece in the orbit. Obvious.
- **Skill Ecosystem for Demonstrations:** per the dispatch audit, this is the strongest of the four dispatches and the most hiring-signal-dense. "Twenty-six encoded skills" is a claim that stops scroll.
- **Two Components That Didn't Ship for Case Studies:** per the audit, this is the strongest-written piece on the site. Argues judgment over output — the most Director/Principal-relevant signal the Work section contains.

The alternative Case Studies pick would be Terra (broader reach, more searchable), but Redwood shows thinking that Terra demonstrates in less distilled form.

### Where this lands visually

Between the Featured Work section and the Writing grid, so the page becomes:

1. Hero
2. Featured Work (Domain Foundation, unchanged)
3. **The Work (new — three tiles)**
4. Writing grid (unchanged)

This keeps Featured Work as the lead emphasis (Domain Foundation is the current thing you want people reading) and adds the portfolio breadth underneath without moving existing content.

## Implementation options

### Option A — Hardcoded template (recommended)

Add the three tiles directly to `custom-home.hbs` with hardcoded titles, blurbs, and URLs. Simple, fast to deploy, no Ghost-admin dependency. Mirrors how the `/work/` template hardcodes its orbit content.

Pros: ships immediately. No risk of missing data. Visually coherent with rest of site.
Cons: any future swap of which piece is featured in each tile requires a theme edit and redeploy.

### Option B — Use Ghost's page query

Use `{{#get "pages" ...}}` queries similar to how the existing methodology-trio and testimonial sections are implemented. Each tile would query for a specific slug or tag.

Pros: swap featured pieces via Ghost Admin without a theme change.
Cons: requires tagging or managing the queried pages in Ghost Admin. More complexity for a feature that doesn't need it.

### Option C — Hybrid

Hardcode structure and blurbs; use Ghost `{{#get}}` only to pull the titles from the live pages. This guards against title drift between the home page and the actual case studies.

Pros: titles stay synchronized with source-of-truth.
Cons: more template complexity than A without much gain — titles don't change often.

**My recommendation: A.** The three tiles telegraph a fixed architectural claim (three orbits). The specific pieces surfaced in each tile can change occasionally, but when they do, it's a deliberate editorial decision worth a theme commit. Hardcoding keeps the editorial decision visible in git.

## Styling

Campfire tokens, pattern matching the existing `.featured-work-card` styling. Three tiles in a grid that collapses to a stack on mobile. Hairline borders. Eyebrow in `--color-accent-ui`, title in heading stack, blurb in body.

One design question worth flagging: should "The Work" tiles look *different* from Featured Work, to signal that Featured Work is the lead and The Work is the breadth section? Or should they share visual language to feel like one unified home?

My read: subtle differentiation. Featured Work stays the visually dominant card (bigger, more padding, the "Featured Work" eyebrow remains). The Work tiles are smaller, three-across, more index-shaped than feature-shaped. That signals hierarchy: feature → breadth → writing.

## What's gained vs. what's lost

**Gained:**
- Home page surfaces all three Work orbits without requiring a click
- Strongest pieces from each orbit get front-door attention
- Portfolio depth is communicated on the page a hiring manager sees first
- "See all work →" gives an explicit path to `/work/` for readers who want more

**Lost:**
- Nothing structurally. The existing Featured Work section stays. The writing grid stays. The conditional sections (testimonial, methodology-trio) stay in place for future use.

## One thing this proposal is NOT doing

The existing `methodology-trio` section in the template queries for `tag:hash-methodology` and doesn't render because nothing is tagged. A reasonable alternative path would be to tag three things and let the template fill. I'm not proposing that because the conditional section's existing label ("How I think") and structure don't match the three-orbit story — it's a legacy section that's been superseded by the three-orbit model on `/work/`. Better to add a new section built for the current architecture than retrofit one that wasn't.

Worth considering separately whether to delete the unused methodology-trio and testimonial template sections entirely. They render nothing today; they'd render nothing after this change either. Leaving them as dead code is fine; removing them is fine. Not critical either way.

## Dependencies

This proposal **depends on the three Demonstrations dispatches being published** (or at least the Skill Ecosystem dispatch being live at `/writing/skill-ecosystem/`), because tile 2 links there. If we implement the home page change first, tile 2 would link to a 404 until the dispatch publishes.

Sequence options:

1. **Publish dispatches first, then home page.** Cleanest. Tile links work from moment of deploy.
2. **Home page first with tile 2 pointing at a temporary destination.** Possible but awkward. Not recommended.
3. **Home page change and dispatch publishing in the same deploy batch.** The right answer — one theme deploy, the home page update and the orbit-cards-on-`/work/` go live together along with the published dispatches.

## Recommended next step

Treat the home page change as part of the same deploy batch as the Demonstrations orbit cards and the dispatch publication, per TOMORROW.md's publication plan. Sequencing within that batch:

1. Publish four posts as drafts via `deploy-post.mjs`
2. Review drafts in Ghost Admin, promote to published
3. Edit `custom-work.hbs` to add three Demonstrations cards (Skill Ecosystem, Research Year, jeremyfuksa.com Build)
4. Edit `custom-home.hbs` to add the new "The Work" section
5. Bump theme to 1.8.2
6. Deploy theme
7. Verify `/` and `/work/` both render the new surfaces

This is ~15 minutes of editing plus one theme deploy. Fits inside the existing publication plan without adding significant scope.

---

_Ready for your sign-off on the proposed section structure, the three featured picks, Option A for implementation, and the sequencing. Or redirect any of them._
