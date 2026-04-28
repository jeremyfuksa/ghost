#!/usr/bin/env bash
# First-run setup for the local headless Ghost dev instance.
# Idempotent: safe to re-run.
#
# Ghost is a headless CMS for posts only — pages, navigation, theme, and
# routes are owned by the Astro site in `site/`. This script only creates
# the owner account so you can log in to write posts.

set -euo pipefail

GHOST_URL="${GHOST_URL:-http://localhost:2368}"
ADMIN_EMAIL="${ADMIN_EMAIL:-dev@local.test}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-DevLocal12345!}"
ADMIN_NAME="${ADMIN_NAME:-Jeremy}"
BLOG_TITLE="${BLOG_TITLE:-The Cocktail Napkin (local)}"

log() { printf '\033[36m==>\033[0m %s\n' "$*"; }
err() { printf '\033[31m!!\033[0m %s\n' "$*" >&2; }

log "Waiting for Ghost at $GHOST_URL..."
for i in $(seq 1 60); do
  if curl -fsS -o /dev/null "$GHOST_URL/ghost/api/admin/site/" 2>/dev/null; then
    log "Ghost is up."
    break
  fi
  sleep 2
  if [ "$i" -eq 60 ]; then
    err "Ghost did not become ready after 120s"
    exit 1
  fi
done

log "Setting up owner account..."
SETUP_BODY=$(cat <<JSON
{"setup":[{"name":"$ADMIN_NAME","email":"$ADMIN_EMAIL","password":"$ADMIN_PASSWORD","blogTitle":"$BLOG_TITLE"}]}
JSON
)
SETUP_HTTP=$(curl -s -o /tmp/ghost-setup.out -w "%{http_code}" \
  -X POST "$GHOST_URL/ghost/api/admin/authentication/setup/" \
  -H "Content-Type: application/json" \
  -H "Origin: $GHOST_URL" \
  -H "Accept-Version: v5.0" \
  --data "$SETUP_BODY" || true)
case "$SETUP_HTTP" in
  201|200) log "Owner created." ;;
  403) log "Setup already complete — continuing." ;;
  *) err "Setup returned HTTP $SETUP_HTTP"; cat /tmp/ghost-setup.out; echo; ;;
esac

log "Done."
log "Site:  $GHOST_URL"
log "Admin: $GHOST_URL/ghost/"
log "Login: $ADMIN_EMAIL / $ADMIN_PASSWORD"
log ""
log "Next: in Ghost Admin → Settings → Integrations, create a custom"
log "integration and copy the Content API Key into site/.env"
log "(see site/.env.example)."
