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

This directory is bind-mounted into `astro-web` at `/etc/nginx/conf.d`
via `/home/admin/docker-compose.yml`:

```yaml
volumes:
  - ./jeremyfuksa.com/deploy/nginx:/etc/nginx/conf.d:ro
```

To apply config changes after editing `default.conf`:

```bash
ssh admin@161.35.226.162
docker exec astro-web nginx -t && docker exec astro-web nginx -s reload
```

Note: `Edit`-style atomic-rename writes change the file's inode, which
breaks single-file bind mounts. Mounting the whole directory avoids
that — edits propagate without recreating the container.

## Verify

```bash
curl -sI https://jeremyfuksa.com/ | grep -i ^link
curl -sI -H 'Accept: text/markdown' https://jeremyfuksa.com/about/ | grep -i content-type
curl -sI https://jeremyfuksa.com/about/ | grep -i content-type   # should still be text/html
```
