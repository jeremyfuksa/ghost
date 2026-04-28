Swap a font in the Astro site. The user will specify a font name and role.

## Arguments
- `$ARGUMENTS` — font name and role, e.g. "Barlow for body" or "Fraunces for headings" or just "Inter" (defaults to body)

## Steps

1. Parse the font name and role (heading or body) from the arguments. If no role is specified, default to body.

2. Update `site/src/styles/tokens.css`:
   - For headings: update the `--font-heading` variable value
   - For body: update the `--font-primary` variable value
   - Keep the fallback stack appropriate (serif fonts get `'Georgia', serif`; sans-serif get `system-ui, sans-serif`)

3. Update the Google Fonts `<link>` URL in `site/src/layouts/BaseLayout.astro`. Replace only the relevant `family=` parameter in the URL. Keep other font families intact. Use the correct Google Fonts URL format for the new font (check if it's a variable font needing axis ranges vs discrete weights).

4. Tell the user to hard refresh (`Cmd+Shift+R`) to see the change. If they're not running `pnpm dev`, they'll need to deploy via `git push origin main && ssh admin@161.35.226.162 'docker exec webhook /scripts/rebuild-astro.sh'` to see it on prod.

## Important
- Do NOT change font-weight values unless the user asks
- Do NOT change letter-spacing unless the user asks
- Preserve all other fonts in the Google Fonts link (e.g. keep Fira Code, keep the other heading/body font)
- If the font is a variable font, use range syntax (e.g. `wght@100..900`) instead of discrete weights
