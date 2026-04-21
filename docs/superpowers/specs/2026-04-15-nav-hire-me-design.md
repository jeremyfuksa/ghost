# Nav redesign: "Hire me" CTA button

**Date:** 2026-04-15
**Status:** Approved

## Problem

The Ghost site navigation contains two items — "Work" (href: `/work/`) and "Work with me" (href: `/work/`) — that link to the exact same URL. This is redundant and wastes a nav slot on a non-distinct action. It signals that the nav was set up casually rather than intentionally.

## Decision

Replace "Work with me" with a visually distinct "Hire me" button that links directly to email (`mailto:hello@jeremyfuksa.com`). This makes the two nav items serve different purposes:

- **Work** — navigates to the portfolio page
- **Hire me** — opens a compose window to the contact email directly

## Scope

This change touches three files:

1. `theme/partials/navigation.hbs` — match condition and CSS class
2. `theme/assets/css/components.css` — `.nav-cta-btn` button styles
3. `static/work.html` — static counterpart nav (kept in sync per workflow)

Ghost Admin navigation settings must also be updated manually (not a code file):
- Change label from "Work with me" → "Hire me"
- Change URL from `/work/` → `mailto:hello@jeremyfuksa.com`

## Implementation

### navigation.hbs

Change the `{{#match}}` condition from `"Work with me"` to `"Hire me"` and apply class `nav-cta-btn` instead of `nav-cta`:

```handlebars
{{#match label "Hire me"}}
  <li><a href="{{url}}" class="nav-cta-btn">{{label}}</a></li>
{{else}}
  <li><a href="{{url}}" class="{{link_class for=url}}">{{label}}</a></li>
{{/match}}
```

Note: `link_class` is intentionally omitted on the `nav-cta-btn` item — it would never match since `mailto:` URLs don't correspond to Ghost page routes, and the button's active appearance is always its default styled state.

### components.css — `.nav-cta-btn`

Add a filled amber button style alongside the existing `.nav-cta` text link style:

```css
.nav-cta-btn {
  background: var(--color-accent-text);
  color: var(--color-surface) !important;
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius-sm);
  font-weight: var(--weight-semibold);
  font-size: var(--text-sm);
  text-decoration: none;
  transition: opacity var(--transition-fast);
}

.nav-cta-btn:hover {
  opacity: 0.85;
}
```

Token mappings assumed from existing `campfire.css` / `tokens.css`. Exact token names verified at implementation time against the actual token files.

### static/work.html

Update the nav `<li>` for the CTA:

```html
<li><a href="mailto:hello@jeremyfuksa.com" class="nav-cta-btn">Hire me</a></li>
```

Remove the old "Work with me" list item.

## What does NOT change

- "Work" nav link — stays as-is, links to `/work/`
- The `#work-with-me` section on the work page — it's a contextually appropriate end-of-page CTA and serves a different purpose than the nav
- All other nav items

## Deployment

After code changes are complete:

1. Repackage theme: `cd theme && zip -r ../the-cocktail-napkin.zip . -x "*.DS_Store" -x "*node_modules*"`
2. Upload theme zip to Ghost Admin (jeremyfuksa.com)
3. In Ghost Admin > Navigation: update label to "Hire me", URL to `mailto:hello@jeremyfuksa.com`
