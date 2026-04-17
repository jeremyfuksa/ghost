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

# Terra Design System case study — uses Python for safe JSON encoding of long HTML
TERRA_SLUG="terra-design-system"
TERRA_EXISTING=$(api GET "/ghost/api/admin/pages/slug/$TERRA_SLUG/" 2>/dev/null || echo "")
if echo "$TERRA_EXISTING" | grep -q "\"slug\":\"$TERRA_SLUG\""; then
  log "Page '$TERRA_SLUG' exists — skipping."
else
  TERRA_BODY=$(python3 - <<'PYEOF'
import json

html = """<h2>Overview</h2>
<p>Terra is Cerner\u2019s open-source design system \u2014 the React component library that provides the UI foundation for the Millennium platform. I joined the Terra team three months after I started at Cerner, and I was one of two UX designers on it who could work directly in the React codebase alongside the engineers. I stayed in that role for roughly three and a half years.</p>
<h2>Why the role existed</h2>
<p>Healthcare UI components don\u2019t get to be approximately right. A focus-trap bug in an alert component propagates across every product that consumes it. An icon that fails contrast requirements shows up in operating rooms and emergency departments. Every consuming team inherits whatever actually ships, whether or not it matches the standards.</p>
<p>So the architecture\u2019s promise \u2014 accessible, internationalized, responsive components built once, consumed everywhere \u2014 only works if the components faithfully implement those standards. Catching the places they don\u2019t requires someone who can read both the standards document and the pull request and push back on the difference. That was the job.</p>
<h2>What the work actually looked like</h2>
<p>Most days I was in the Terra monorepo reading pull requests. Not rubber-stamping them. Actually reading them \u2014 walking through the interaction logic, checking focus management against the standards we\u2019d published, flagging the places where an engineer\u2019s reasonable implementation had quietly diverged from the intended behavior. When something was wrong in a way that needed both design judgment and React fluency to resolve, I was one of two designers on the team who could fix it in code rather than throw it back over the wall with a spec.</p>
<p>Alongside that, I owned the icon library \u2014 a dedicated Git repository the engineering team consumed into the component system, maintained end-to-end from design asset to published package. And I was the design advisor on the construction of every new component that came through, which meant a lot of arguing about tab order, screen reader announcements, and which interaction patterns the design standards actually required versus which ones had been convenient to document.</p>
<p>The standards we were enforcing weren\u2019t small. The system was built on 125+ design standards and 150+ accessibility guidelines targeting WCAG 2.1 AA. My job was making sure what shipped actually honored them.</p>
<h2>What I learned there</h2>
<p>A design system isn\u2019t a components problem. It\u2019s an interpretation problem. The gap between what the standard says and what the engineer built in good faith is where accessibility actually dies, and closing that gap requires someone who can read the diff \u2014 not someone who writes the spec harder.</p>
<p>The other thing I learned: being the designer who works in the code changes what design means as a job. I spent three and a half years not producing Figma files that anyone cared about, and the work mattered more than most of the Figma files I\u2019d produced before that.</p>
<h2>What happened next</h2>
<p>In mid-2022, a few months before Oracle completed its $28.3 billion acquisition of Cerner, I moved from this hands-in-code IC role into design management \u2014 eventually leading a team of up to 12 across the US and India through the organizational transition.</p>
<p>The leadership story is its own case study. But this is where it started: in the gap between what was designed and what was built, making sure the intent survived.</p>"""

data = {
    "pages": [{
        "title": "Terra Design System",
        "slug": "terra-design-system",
        "status": "published",
        "html": html,
        "custom_template": "custom-casestudy-terra"
    }]
}
print(json.dumps(data))
PYEOF
)
  if api POST "/ghost/api/admin/pages/?source=html" "$TERRA_BODY" >/dev/null 2>&1; then
    log "Created page '$TERRA_SLUG'."
  else
    err "Failed to create page '$TERRA_SLUG'."
  fi
fi

# Seven Years in Healthcare UX case study — uses Python for safe JSON encoding of long HTML
CERNER_SLUG="seven-years-in-healthcare-ux"
CERNER_EXISTING=$(api GET "/ghost/api/admin/pages/slug/$CERNER_SLUG/" 2>/dev/null || echo "")
if echo "$CERNER_EXISTING" | grep -q "\"slug\":\"$CERNER_SLUG\""; then
  log "Page '$CERNER_SLUG' exists — skipping."
else
  CERNER_BODY=$(python3 - <<'PYEOF'
import json

html = """<h2>Overview</h2>
<p>I joined Cerner in 2018 as a UX designer on the revenue cycle product. Three months later I moved to the UX Foundations team, where I spent three and a half years working directly in the Terra design system codebase alongside engineers. In mid-2022 I moved into design management, eventually leading designers across Kansas City, New York City, Brussels, Bangalore, Puducherry, Chennai, Florida, and North Carolina \u2014 through Oracle\u2019s acquisition of Cerner and everything that came with it.</p>
<p>This is the full arc.</p>
<h2>Revenue Cycle: Learning the Domain</h2>
<p>My first assignment was middle office revenue cycle \u2014 the claims processing, denials management, and compliance work that keeps hospitals financially solvent. Not the clinical-facing work that makes it into conference talks. The operational infrastructure that revenue cycle teams stare at all day.</p>
<p>The Millennium interface I walked into was dense. Aggressively dense. Data tables packed with status codes, payer information, denial reasons, dollar amounts, and dates \u2014 all competing for attention at the same priority level.</p>
<p>My instinct was that the density was the problem. Information running together, no hierarchy, no clear path for the eye. I built a widget for care teams to check whether a patient\u2019s stay was still compliant \u2014 a specific, bounded piece of the larger workflow.</p>
<p>What I learned in those three months changed how I thought about enterprise healthcare design. Providers want the density. They have reasons. A clinician managing a patient panel needs to scan large volumes of information quickly without drilling into detail views. The density isn\u2019t a design failure \u2014 it\u2019s a design requirement. The problem isn\u2019t how much data is on the screen. The problem is when that data runs together and distinctions disappear.</p>
<p>That tension \u2014 between the density users need and the clarity they deserve \u2014 stayed with me for the next seven years.</p>
<h2>Terra: Working in the Gap</h2>
<p>Three months after joining, I moved to the UX Foundations team and the Terra design system. The details of that work are covered in a <a href="/work/terra-design-system/">separate case study</a>, but the short version: I was one of two UX designers who could work directly in the React codebase alongside the Terra engineering team. I reviewed pull requests for UX correctness, resolved interaction and accessibility issues in code, owned the 200+ icon library, and advised on the construction of every component that came through.</p>
<p>The role was defined by the space between design intent and engineering implementation \u2014 making sure that what got built actually honored the 125+ design standards and 150+ accessibility guidelines the system was built on.</p>
<p>I did that work for roughly three and a half years.</p>
<h2>Management: A Different Job</h2>
<p>In mid-2022, a few months before Oracle completed its $28.3 billion acquisition of Cerner, I moved into design management. My hands-on IC work in the codebase effectively ended. The job became people.</p>
<p>At its peak, I managed 12 designers spread across eight locations: Kansas City, New York City, Brussels, Bangalore, Puducherry, Chennai, Florida, and North Carolina. The work was mentoring, advocacy, career development, and keeping design quality consistent across a team that spanned three continents and rarely shared a time zone.</p>
<p>Then Oracle\u2019s organizational philosophy took hold. Design managers were expected to operate as 80% IC, 20% manager. The team contracted through attrition and restructuring \u2014 people resigned, roles were consolidated. I went from twelve reports to five: three in Kansas City, one in New York, one in North Carolina.</p>
<p>The shift wasn\u2019t just headcount. It was a fundamentally different idea of what design management means. At Cerner, managing designers was the job. Under Oracle, it was something you did on the side of your \u201creal\u201d work. I don\u2019t think those two philosophies are compatible, but I operated under both.</p>
<h2>What I Protected</h2>
<p>The period after the acquisition was not friendly to individual contributors. Promotions were nearly impossible to push through. Raises were rare. The organizational message, intended or not, was that growth had stopped.</p>
<p>I got three of my reports promoted \u2014 with pay raises \u2014 during that window. It required building airtight justification packages and advocating through layers of new leadership who had no context on these designers\u2019 contributions. It was the most important management work I did at Oracle, and none of it shows up in a portfolio as a deliverable.</p>
<h2>What I Carried Out</h2>
<p>Seven years in healthcare enterprise UX taught me things that don\u2019t fit in a case study section header.</p>
<p>Data density is a design requirement, not a design problem. The people using the software know more about their needs than you do \u2014 your job is to bring clarity to their requirements, not to override them with your preferences.</p>
<p>Design systems are a coordination problem with a design surface. The components are the visible layer. The real work is the governance, the standards, the translation fidelity between what\u2019s specified and what ships.</p>
<p>Management is advocacy. The deliverable is other people\u2019s growth. When the organization makes growth impossible, making it happen anyway is the job.</p>
<p>The IC work and the management work both mattered. But they were different jobs, and pretending they\u2019re the same job done at different altitudes isn\u2019t honest.</p>
<h2>Timeline</h2>
<table>
<thead><tr><th>Phase</th><th>Dates</th><th>Role</th><th>Scope</th></tr></thead>
<tbody>
<tr><td>Revenue Cycle</td><td>Sep\u2013Dec 2018</td><td>UX Designer</td><td>Middle office product, patient stay compliance widget</td></tr>
<tr><td>Terra / UX Foundations</td><td>Dec 2018\u2013Mid 2022</td><td>Senior UX Designer</td><td>Design system engineering partnership, PR review, icon library, design advisory</td></tr>
<tr><td>Design Management</td><td>Mid 2022\u20132024</td><td>UX Design Manager</td><td>5\u201312 reports across 8 locations, 3 continents; team leadership through Oracle acquisition</td></tr>
</tbody>
</table>"""

data = {
    "pages": [{
        "title": "Seven Years in Healthcare UX",
        "slug": "seven-years-in-healthcare-ux",
        "status": "published",
        "html": html,
        "custom_template": "custom-casestudy-cerner"
    }]
}
print(json.dumps(data))
PYEOF
)
  if api POST "/ghost/api/admin/pages/?source=html" "$CERNER_BODY" >/dev/null 2>&1; then
    log "Created page '$CERNER_SLUG'."
  else
    err "Failed to create page '$CERNER_SLUG'."
  fi
fi

# Domain Foundation case study — uses Python for safe JSON encoding of long HTML
DF_SLUG="domain-foundation"
DF_EXISTING=$(api GET "/ghost/api/admin/pages/slug/$DF_SLUG/" 2>/dev/null || echo "")
if echo "$DF_EXISTING" | grep -q "\"slug\":\"$DF_SLUG\""; then
  log "Page '$DF_SLUG' exists — skipping."
else
  DF_BODY=$(python3 - <<'PYEOF'
import json

html = """<h2>How I got here</h2>
<p>I started working seriously with AI design tools in 2023 and kept noticing the same thing: they generated fast, and they generated wrong. Not broken \u2014 <em>plausible</em>. The output looked right until you held it up against anything that required actual domain expertise. A healthcare layout that met every stated requirement and would also quietly get a nurse killed at 3 AM.</p>
<p>The wrongness wasn\u2019t a model capability problem. It was a context problem. The model didn\u2019t know what I knew, and I had no good way to tell it.</p>
<p>Domain Foundation came out of trying to solve that. It\u2019s a methodology for building the knowledge layer that AI tools need in order to produce work that reflects real organizational expertise instead of averaged training data. I built it, I tested it, and this is what came out of it.</p>
<h2>The gap</h2>
<p>Design systems tell AI tools what to build. They don\u2019t tell them why. A component library encodes visual tokens, spacing, interaction patterns \u2014 that\u2019s the what. The reasoning \u2014 when a particular component is dangerous to use, why a specific workflow exists, what accessibility constraints are non-negotiable versus preferred \u2014 lives in experienced people\u2019s heads. When those people leave, the reasoning leaves with them. AI tools trained on general data fill that gap with plausible averages, and you only find out it was plausible-but-wrong after it ships.</p>
<h2>What I built</h2>
<p>The architecture I landed on is a four-layer knowledge model, chosen mostly because it matched how the knowledge is actually owned in the organizations I was designing for. A base layer of universal design principles and accessibility fundamentals, owned by the design system team. A domain layer of industry-specific reasoning \u2014 clinical safety, regulatory constraints \u2014 owned by domain experts. A component layer of per-artifact intent metadata (when to use, when not to), owned by component authors. A role layer describing the needs and constraints of different user types, owned by researchers. The AI composes from all four at generation time, which distributes the governance problem instead of centralizing it on the design system team.</p>
<p>The technical shape is the emerging pattern \u2014 vector database, MCP server, LLM \u2014 but the shape isn\u2019t the interesting part. What goes into the database is. Institutional knowledge, not documentation.</p>
<h2>What testing it actually taught me</h2>
<p>Some of what I learned was what I expected. A lot wasn\u2019t.</p>
<p>The retrieval ceiling is real. Individual guidelines documents start to degrade around 3,500 tokens \u2014 past that, the model stops reliably surfacing the relevant constraints. I\u2019d assumed longer was better. Longer wasn\u2019t better.</p>
<p>Mixed-structure prompting outperforms uniform formatting by a surprising margin. Prose for rationale, bullets for constraints, IF/THEN for conditional logic. Engineering-pretty uniform JSON loses to a messier, human-shaped mix.</p>
<p>The workflow that worked best was bootstrap-navigate-validate: load safety-critical rules at session start, fetch domain knowledge on demand during generation, run full validation server-side after. This solved the context-window problem I spent a month fighting head-on before giving up and going around it.</p>
<p>The most uncomfortable finding wasn\u2019t technical. AI compresses generation time but not validation time. Every team I watched optimizing for \u201chow fast can we produce\u201d was quietly accruing a validation debt that showed up weeks later, all at once. Speed without validation architecture isn\u2019t speed. It\u2019s a deferred invoice.</p>
<p>And finally: descriptive layer naming alone, with no additional knowledge injection, gets you roughly 90% of the way there in Figma Make. The boring work of naming things carefully does more than any prompt engineering stunt.</p>
<h2>Where this sits</h2>
<p>This is methodology, not product. It\u2019s hard to demo. Half the value is in what you choose to put in the knowledge base, and the choosing is the expertise \u2014 not the structure. I\u2019m in the middle of generalizing the healthcare-specific examples so the same methodology can travel to other high-stakes domains. Healthcare made the thinking sharp, but the work isn\u2019t healthcare-specific. It applies anywhere the design decisions have consequences.</p>"""

data = {
    "pages": [{
        "title": "Domain Foundation",
        "slug": "domain-foundation",
        "status": "published",
        "html": html,
        "custom_template": "custom-casestudy-domain-foundation"
    }]
}
print(json.dumps(data))
PYEOF
)
  if api POST "/ghost/api/admin/pages/?source=html" "$DF_BODY" >/dev/null 2>&1; then
    log "Created page '$DF_SLUG'."
  else
    err "Failed to create page '$DF_SLUG'."
  fi
fi

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
assign_template "terra-design-system" "custom-casestudy-terra"
assign_template "seven-years-in-healthcare-ux" "custom-casestudy-cerner"
assign_template "domain-foundation" "custom-casestudy-domain-foundation"

log "Done."
log "Site:  $GHOST_URL"
log "Admin: $GHOST_URL/ghost/"
log "Login: $ADMIN_EMAIL / $ADMIN_PASSWORD"
