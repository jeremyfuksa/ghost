Swap a font in the Ghost theme. The user will specify a font name and role.

## Arguments
- `$ARGUMENTS` — font name and role, e.g. "Barlow for body" or "Fraunces for headings" or just "Inter" (defaults to body)

## Steps

1. Parse the font name and role (heading or body) from the arguments. If no role is specified, default to body.

2. Update `theme/assets/css/tokens.css`:
   - For headings: update the `--font-heading` variable value
   - For body: update the `--font-primary` variable value
   - Keep the fallback stack appropriate (serif fonts get `'Georgia', serif`; sans-serif get `system-ui, sans-serif`)

3. Update the Google Fonts `<link>` URL in `theme/default.hbs`. Replace only the relevant `family=` parameter in the URL. Keep other font families intact. Use the correct Google Fonts URL format for the new font (check if it's a variable font needing axis ranges vs discrete weights).

4. Tell the user to hard refresh (`Cmd+Shift+R`) to see the change.

## Important
- Do NOT change font-weight values unless the user asks
- Do NOT change letter-spacing unless the user asks
- Preserve all other fonts in the Google Fonts link (e.g. keep Fira Code, keep the other heading/body font)
- If the font is a variable font, use range syntax (e.g. `wght@100..900`) instead of discrete weights
