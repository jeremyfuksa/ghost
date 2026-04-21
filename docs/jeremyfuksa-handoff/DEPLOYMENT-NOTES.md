# `/work/` Rebuild — Deployment Notes

## Defer to CLAUDE.md

This repo has a documented theme-deploy workflow in CLAUDE.md. Follow it. Do not SSH-edit files on the droplet. Do not duplicate the steps here — they drift.

The short version of what CLAUDE.md covers, so you know what to expect:

- `theme/package.json` version bump before packaging
- Git commit with the version bump
- Zip the theme directory
- Upload via `dev/deploy-theme.mjs`, which uses the Admin API key in `.env`
- The `.env` key has full theme upload + activate scope (verified in session). No 403.

If any of that has shifted, CLAUDE.md wins.

## What's in this drop

| File | Role |
| --- | --- |
| `custom-work.hbs` | Proposed template. Diff against existing `theme/custom-work.hbs` — do not blindly replace. Preserves `{{#if custom_excerpt}}`, `{{#if feature_image}}`, `{{#if content}}` fallbacks for Ghost-Admin editability. |
| `work-orbit.css` | Rules to insert in `components.css`. Group with existing `.work-*` rules, before the consolidated mobile `@media` block. No `cat >>`. |
| `work-page-content.md` | Archival markdown of the copy. Not deployed. |
| `work-page-preview.html` | Self-contained preview rendered against live site CSS. Open in a browser to sanity-check the structure before packaging. |
| `HANDOFF.md` | The briefing. Read first. |
| `INITIAL_PROMPT.md` | Paste-ready first-turn prompt. |
| `about-page-rewrite.md` | Archival, already live. Reference only. |

## Post-deploy verification checklist

Load `https://jeremyfuksa.com/work/` with a hard refresh. Confirm:

- [ ] Page intro reads (fallback): "The work falls into three groups. The methodology is Domain Foundation — an architecture for encoding design expertise into AI-reachable form. Demonstrations are how it runs in practice. Case studies are the client-facing enterprise work."
- [ ] Three `<h2>` section headings appear (Methodology / Demonstrations / Case Studies) with the amber underline matching the existing `<h1>` treatment
- [ ] Methodology section shows one card: Domain Foundation (meta: "Methodology · 2023–ongoing")
- [ ] Demonstrations section has only its intro paragraph — no cards, no placeholder boxes
- [ ] Case Studies section shows three cards: Terra, Seven Years, Two Components That Didn't Ship
- [ ] "Work with me" section at the bottom is unchanged
- [ ] Card hover states work (amber left border, slight background tint) — requires visual check at the terminal; cannot be headlessly verified

## If something looks wrong

Revert via git, redeploy. Don't edit on the droplet to patch.

---

_Verified: 2026-04-21. Facts about deploy paths, API scope, and template filenames were corrected in a review cycle against the repo. If you're reading this more than a few weeks out, re-verify against CLAUDE.md before acting on anything here._
