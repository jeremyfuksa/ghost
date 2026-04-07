#!/usr/bin/env bash
# First-run setup for local Ghost dev instance
# Idempotent: safe to re-run.

set -euo pipefail

GHOST_URL="${GHOST_URL:-http://localhost:2368}"
ADMIN_EMAIL="${ADMIN_EMAIL:-dev@local.test}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-DevLocal12345!}"
ADMIN_NAME="${ADMIN_NAME:-Jeremy}"
BLOG_TITLE="${BLOG_TITLE:-The Cocktail Napkin (local)}"
THEME_NAME="the-cocktail-napkin"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COOKIES="$(mktemp)"
trap 'rm -f "$COOKIES"' EXIT

log() { printf '\033[36m==>\033[0m %s\n' "$*"; }
err() { printf '\033[31m!!\033[0m %s\n' "$*" >&2; }

# 1. Wait for Ghost to be ready
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

# 2. Complete owner setup (idempotent: 200 if new, 403 if already done)
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

# 3. Sign in to get session cookie
log "Signing in..."
SIGNIN_BODY=$(cat <<JSON
{"username":"$ADMIN_EMAIL","password":"$ADMIN_PASSWORD"}
JSON
)
SIGNIN_HTTP=$(curl -s -o /tmp/ghost-signin.out -w "%{http_code}" \
  -c "$COOKIES" \
  -X POST "$GHOST_URL/ghost/api/admin/session/" \
  -H "Content-Type: application/json" \
  -H "Origin: $GHOST_URL" \
  -H "Accept-Version: v5.0" \
  --data "$SIGNIN_BODY" || true)
if [ "$SIGNIN_HTTP" != "201" ] && [ "$SIGNIN_HTTP" != "200" ]; then
  err "Sign in failed: HTTP $SIGNIN_HTTP"
  cat /tmp/ghost-signin.out
  exit 1
fi
log "Signed in."

api() {
  # api METHOD PATH [data-file]
  local method="$1"; local path="$2"; local data="${3:-}"
  if [ -n "$data" ]; then
    curl -fsS -b "$COOKIES" \
      -X "$method" "$GHOST_URL$path" \
      -H "Content-Type: application/json" \
      -H "Origin: $GHOST_URL" \
      -H "Accept-Version: v5.0" \
      --data "$data"
  else
    curl -fsS -b "$COOKIES" \
      -X "$method" "$GHOST_URL$path" \
      -H "Origin: $GHOST_URL" \
      -H "Accept-Version: v5.0"
  fi
}

# 4. Activate theme
log "Activating theme '$THEME_NAME'..."
if api PUT "/ghost/api/admin/themes/$THEME_NAME/activate/" >/dev/null 2>&1; then
  log "Theme activated."
else
  err "Theme activation failed (theme may not be detected yet)."
fi

# 5. Upload routes.yaml
log "Uploading routes.yaml..."
if curl -fsS -b "$COOKIES" \
  -X POST "$GHOST_URL/ghost/api/admin/settings/routes/yaml/" \
  -H "Origin: $GHOST_URL" \
  -H "Accept-Version: v5.0" \
  -F "routes=@$REPO_ROOT/theme/routes.yaml;type=application/x-yaml" \
  >/dev/null 2>&1; then
  log "Routes uploaded."
else
  err "Routes upload failed (non-fatal — upload via Admin UI)."
fi

# 6. Seed content (only if missing — check by slug)
seed_page() {
  local slug="$1"; local title="$2"; local template="$3"; local html="$4"
  local existing
  existing=$(api GET "/ghost/api/admin/pages/slug/$slug/" 2>/dev/null || echo "")
  if echo "$existing" | grep -q "\"slug\":\"$slug\""; then
    log "Page '$slug' exists — skipping."
    return
  fi
  local tpl_field=""
  if [ -n "$template" ]; then
    tpl_field=",\"custom_template\":\"$template\""
  fi
  local body
  body=$(cat <<JSON
{"pages":[{"title":"$title","slug":"$slug","status":"published","html":"$html"$tpl_field}]}
JSON
)
  if api POST "/ghost/api/admin/pages/?source=html" "$body" >/dev/null 2>&1; then
    log "Created page '$slug'."
  else
    err "Failed to create page '$slug'."
  fi
}

assign_template() {
  # assign_template SLUG CUSTOM_TEMPLATE
  # Re-assigns a custom_template to an existing page (idempotent).
  local slug="$1"; local template="$2"
  local payload
  payload=$(/usr/bin/curl -fsS -b "$COOKIES" \
    "$GHOST_URL/ghost/api/admin/pages/slug/$slug/" \
    -H "Accept-Version: v5.0" 2>/dev/null || echo "")
  if [ -z "$payload" ]; then return; fi
  local page_id updated_at
  page_id=$(echo "$payload" | python3 -c "import sys,json;print(json.load(sys.stdin)['pages'][0]['id'])" 2>/dev/null || echo "")
  updated_at=$(echo "$payload" | python3 -c "import sys,json;print(json.load(sys.stdin)['pages'][0]['updated_at'])" 2>/dev/null || echo "")
  if [ -z "$page_id" ] || [ -z "$updated_at" ]; then return; fi
  /usr/bin/curl -fsS -b "$COOKIES" \
    -X PUT "$GHOST_URL/ghost/api/admin/pages/$page_id/" \
    -H "Content-Type: application/json" \
    -H "Origin: $GHOST_URL" \
    -H "Accept-Version: v5.0" \
    --data "{\"pages\":[{\"custom_template\":\"$template\",\"updated_at\":\"$updated_at\"}]}" >/dev/null 2>&1 || true
}

seed_post() {
  local slug="$1"; local title="$2"; local tag="$3"; local html="$4"
  local existing
  existing=$(api GET "/ghost/api/admin/posts/slug/$slug/" 2>/dev/null || echo "")
  if echo "$existing" | grep -q "\"slug\":\"$slug\""; then
    log "Post '$slug' exists — skipping."
    return
  fi
  local body
  body=$(cat <<JSON
{"posts":[{"title":"$title","slug":"$slug","status":"published","html":"$html","tags":[{"name":"$tag"}]}]}
JSON
)
  if api POST "/ghost/api/admin/posts/?source=html" "$body" >/dev/null 2>&1; then
    log "Created post '$slug'."
  else
    err "Failed to create post '$slug'."
  fi
}

log "Seeding content..."
seed_page "home" "Home" "" "<p>Home page placeholder. The custom-home template renders hardcoded markup.</p>"
seed_page "now" "Now" "custom-now" "<p>Local dev seed. Static fallback content renders from the template.</p>"
seed_page "work" "Work" "custom-work" "<p>Portfolio page — content rendered by custom-work template.</p>"
seed_page "about" "About" "custom-about" "<p>I help organizations build design systems that ship, UX strategies tied to business outcomes, and AI-augmented workflows that amplify craft. 15+ years across enterprise SaaS, healthcare, and product design.</p><p>Based in Kansas City. Available for consulting and senior design roles.</p>"

# Test posts removed — real content imported from prod export.

# Set primary navigation
log "Setting navigation..."
NAV_BODY='{"settings":[{"key":"navigation","value":"[{\"label\":\"Writing\",\"url\":\"/writing/\"},{\"label\":\"Work\",\"url\":\"/work/\"},{\"label\":\"Now\",\"url\":\"/now/\"},{\"label\":\"About\",\"url\":\"/about/\"},{\"label\":\"Work with me\",\"url\":\"/work/#work-with-me\"}]"},{"key":"secondary_navigation","value":"[{\"label\":\"Writing\",\"url\":\"/writing/\"},{\"label\":\"Work\",\"url\":\"/work/\"},{\"label\":\"Now\",\"url\":\"/now/\"},{\"label\":\"About\",\"url\":\"/about/\"}]"}]}'
api PUT "/ghost/api/admin/settings/" "$NAV_BODY" >/dev/null 2>&1 && log "Navigation set." || err "Navigation update failed."

# Re-sync custom templates (in case templates were added after pages were created)
log "Re-syncing custom templates..."
assign_template "now"   "custom-now"
assign_template "work"  "custom-work"
assign_template "about" "custom-about"

log "Done."
log "Site:  $GHOST_URL"
log "Admin: $GHOST_URL/ghost/"
log "Login: $ADMIN_EMAIL / $ADMIN_PASSWORD"
