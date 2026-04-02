Regenerate `preview.html` to match the current state of the Ghost theme.

The preview is a single static HTML file that renders all page templates with hardcoded mock content. It exists because Ghost templates use Handlebars and can't render without a Ghost server.

## Steps

1. Read the current state of these files:
   - `theme/assets/css/tokens.css` — for current font families, colors, spacing
   - `theme/assets/css/base.css` — for heading weights, letter-spacing, line-heights
   - `theme/assets/css/components.css` — for component styles
   - `theme/default.hbs` — for the Google Fonts `<link>` URL
   - `theme/partials/header.hbs` — for nav structure
   - `theme/partials/footer.hbs` — for footer structure
   - `theme/custom-home.hbs` — for home page layout
   - `theme/post.hbs` — for post page layout
   - `theme/index.hbs` — for writing index layout
   - `theme/custom-now.hbs` — for now page layout
   - `theme/error.hbs` — for error page layout

2. Rewrite `preview.html` to reflect the current templates:
   - Use the same Google Fonts `<link>` as `default.hbs`
   - Load CSS files directly: `theme/assets/css/tokens.css`, `theme/assets/css/base.css`, `theme/assets/css/components.css`
   - Render each page section separated by `4px solid var(--color-accent-ui)` dividers
   - Use gray placeholder divs for images (with dimension labels in mono font)
   - Keep the mock content realistic (post titles, excerpts, dates, tags)
   - Include all page types: home, post, writing index, now, 404

3. Tell the user to hard refresh to see the updated preview.

## Important
- The preview must work from `file://` protocol (no server needed)
- CSS is loaded via direct `<link>` tags, not via `screen.css` `@import` (which fails on `file://`)
- All links should use `#anchor` hrefs, not real paths
- Mock content should feel realistic, not "lorem ipsum"
