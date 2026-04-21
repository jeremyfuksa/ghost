# `/work/` Rebuild — Deployment Notes

## Why this isn't a one-click publish

The `/work/` page on jeremyfuksa.com is not a Ghost page with editable body content. The Ghost API shows the page body as empty — all the rendered content (header, card list, CTA) is hardcoded in a custom theme template, almost certainly `page-work.hbs`.

Two things follow from that:

1. **Updating the page through the Ghost Admin API won't change the rendered output.** The template ignores the page body.
2. **The integration token you provided doesn't have theme-management scope** (the `/themes/` endpoint returns 403 for the key in use). Even if it did, uploading a whole theme via API would overwrite everything, which is the wrong tool for a single-template edit.

So this is a file-on-server change. Fifteen minutes of work on your end, once you're at a terminal.

---

## What's in this drop

| File | Where it goes |
| --- | --- |
| `page-work.hbs` | Replaces the existing file of the same name in your active theme directory |
| `work-orbit.css` | Rules to append to your theme's `components.css` (or the equivalent source file that feeds it) |
| `work-page-content.md` | Archival markdown of the copy — no deployment action; keep for future edits |
| `README-deployment.md` | This file |

---

## Deployment — SSH path

```bash
# 1. SSH to the DigitalOcean droplet.
ssh your-user@jeremyfuksa.com   # adjust to your actual host alias

# 2. Locate the theme. Ghost 6 keeps themes at:
#    /var/lib/ghost/content/themes/<active-theme-name>/
#    Or wherever your Docker volume mounts it — check docker-compose.yml if unsure.
cd /var/lib/ghost/content/themes/<active-theme>

# 3. Back up the existing template before replacing:
cp page-work.hbs page-work.hbs.bak.$(date +%Y%m%d)

# 4. Upload the new page-work.hbs to replace it (from your laptop):
#    scp /path/to/downloads/page-work.hbs your-user@jeremyfuksa.com:/var/lib/ghost/content/themes/<active-theme>/

# 5. Append the new CSS to components.css (or the source file it's compiled from).
#    If your theme uses a build step (PostCSS, Sass, etc.), edit the source and rebuild.
#    If components.css is hand-authored and imported directly, append to it.
cat work-orbit.css >> /var/lib/ghost/content/themes/<active-theme>/assets/css/components.css

# 6. Restart Ghost so the theme reloads (method depends on your setup):
#    Docker:   docker compose restart ghost
#    systemd:  sudo systemctl restart ghost
#    ghost-cli: ghost restart
```

---

## Post-deploy verification

Load `https://jeremyfuksa.com/work/` with a hard refresh. Confirm:

- [ ] Page intro reads: "The work falls into three groups..."
- [ ] Three `<h2>` section headings appear with the amber underline matching the existing `<h1>` underline style
- [ ] Frameworks section shows one card: Domain Foundation (meta reads "Methodology hub · 2023–ongoing")
- [ ] Demonstrations section has only its intro paragraph — no cards, no placeholder boxes
- [ ] Case Studies section shows three cards: Terra, Seven Years, Two Components That Didn't Ship
- [ ] "Work with me" section at the bottom is unchanged
- [ ] Card hover states work (amber left border, slight background tint)

---

## Known gaps / next steps

- **Demonstrations orbit is intentionally empty-state.** "Publishing as they're ready" is honest; no placeholder cards. Individual dispatches (Skill Ecosystem first) get written up and linked in as they ship.
- **Framework pages don't exist yet.** Domain Foundation currently stands as the single methodology hub. The seven individual framework pages (Validation Stack, Role Inversion Model, Four-Layer Knowledge Architecture, Velocity Paradox, plus three I don't have named) are the next batch of content production. Once drafted, they'll need their own cards in the Frameworks orbit, which means another template edit.
- **CSS classes introduced:** `.work-orbit`, `.work-orbit-header`, `.work-orbit-title`, `.work-orbit-intro`. Naming matches the existing `work-*` convention.
- **Design tokens used:** Only existing Campfire tokens (`--spacing-*`, `--text-*`, `--leading-*`, `--color-accent-ui`, `--text-secondary`, `--font-sans`, `--prose-max`). No new variables introduced.

---

## If something looks wrong

Roll back:

```bash
cd /var/lib/ghost/content/themes/<active-theme>
mv page-work.hbs.bak.YYYYMMDD page-work.hbs
# Revert the CSS append — git diff components.css if under version control, otherwise
# manually remove the "Work Page — Orbit Sections" block.
# Then restart Ghost.
```
