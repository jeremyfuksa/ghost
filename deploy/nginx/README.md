# nginx config for `astro-web`

`default.conf` is a drop-in replacement for the stock
`/etc/nginx/conf.d/default.conf` inside the `astro-web` container. It adds:

- Homepage `Link:` response headers (RFC 8288) advertising sitemap, RSS,
  author, and the markdown companion.
- `Accept: text/markdown` content negotiation. Trailing-slash URLs rewrite
  to their `.md` companion when the client prefers markdown
  (e.g. `/about/` → `/about.md`, `/work/foo/` → `/work/foo.md`,
  `/` → `/index.md`). HTML stays the default for browsers.

## Deploy

The cleanest path is to bind-mount this file at
`/etc/nginx/conf.d/default.conf` in the prod compose file. Quick path
without touching compose:

```bash
ssh admin@161.35.226.162
docker cp /home/admin/jeremyfuksa.com/deploy/nginx/default.conf astro-web:/etc/nginx/conf.d/default.conf
docker exec astro-web nginx -t
docker exec astro-web nginx -s reload
```

## Verify

```bash
curl -sI https://jeremyfuksa.com/ | grep -i ^link
curl -sI -H 'Accept: text/markdown' https://jeremyfuksa.com/about/ | grep -i content-type
curl -sI https://jeremyfuksa.com/about/ | grep -i content-type   # should still be text/html
```
