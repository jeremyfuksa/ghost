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
<p>Terra is Cerner\u2019s open-source design system \u2014 80+ React components, 200+ icons, and a comprehensive standards library built for healthcare applications at global scale. It provides the UI foundation for Cerner\u2019s Millennium platform: roughly 60 integrated clinical solutions used by approximately 1,500 healthcare organizations in 195 countries.</p>
<p>I was one of two UX designers embedded with the Terra engineering team who worked directly in the React codebase. My role was ensuring that what got built actually matched what was designed \u2014 bridging the gap between UX standards and engineering implementation at the component level.</p>
<h2>The Problem</h2>
<p>Healthcare UI components don\u2019t get to be approximately right. A focus-trap bug in an alert component propagates across every product that consumes it. An icon that fails contrast requirements shows up in operating rooms and emergency departments.</p>
<p>Terra\u2019s architecture solves this at scale \u2014 every consuming team inherits accessible, internationalized, responsive components without rebuilding that work themselves. But that architecture only works if the components faithfully implement the design standards. Catching those failures requires someone who can read both languages.</p>
<h2>My Role</h2>
<p><strong>PR review and UX sign-off.</strong> I reviewed pull requests for UX correctness \u2014 not just whether a component rendered, but whether focus management, keyboard navigation, and interaction behavior matched the published design standards and accessibility guidelines (125+ standards, 150+ accessibility guidelines targeting WCAG 2.1 AA).</p>
<p><strong>In-code UX problem solving.</strong> When components had UX issues that required both design judgment and code-level debugging to resolve, I was one of two designers with the React fluency to work through them directly in the monorepo alongside engineers.</p>
<p><strong>Icon library ownership.</strong> I maintained the Terra icon library \u2014 200+ icons in a dedicated Git repository that the engineering team consumed into the component system. Full ownership of the pipeline from design asset to published repo.</p>
<p><strong>Design advisory.</strong> I didn\u2019t design Terra\u2019s components, but I advised on the proper construction of every component that came through \u2014 ensuring that interaction specifications, accessibility requirements, and visual standards were correctly interpreted and implemented.</p>
<h2>The System</h2>
<p>Terra\u2019s component ecosystem spans three repositories: terra-core (foundational components \u2014 buttons, alerts, forms), terra-framework (composed, higher-order patterns \u2014 navigation, layouts, modals), and terra-clinical (healthcare-specific components).</p>
<p>Every component ships with accessibility, responsive design, internationalization, and cross-browser support built in. The consuming team gets all of that by default. At the scale of hundreds of product teams, each component represents engineering-weeks of accessibility and responsive work that would otherwise be duplicated \u2014 or more likely, done inconsistently or skipped entirely.</p>
<p>The system is open source under an Apache 2.0 license. The code, the contribution guidelines, and the component documentation are all publicly available on GitHub.</p>
<h2>Outcomes</h2>
<p>80+ React components across three repositories, consumed by hundreds of product teams. 200+ icons maintained and published through a dedicated pipeline. 125+ design standards and 150+ accessibility guidelines implemented and verified at the component level. WCAG 2.1 AA targeted conformance baked into every component \u2014 keyboard navigation, screen reader support, focus management, color contrast. Global deployment across ~60 Millennium solutions, ~1,500 healthcare organizations, 195 countries. Open source \u2014 publicly verifiable on GitHub under the Cerner organization.</p>
<h2>What Happened Next</h2>
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

html = """<h2>Overview</h2>
<p>AI design tools generate fast. They don\u2019t generate right \u2014 at least not without help. The gap isn\u2019t in the model\u2019s capability. It\u2019s in what the model knows about your specific domain, your users, your constraints, and why your design decisions exist.</p>
<p>Domain Foundation is a structured approach to closing that gap. It\u2019s a methodology for building the knowledge layer that AI tools need to produce work that reflects real organizational expertise instead of averaged training data. I built it. I tested it. I documented what worked and what didn\u2019t. This case study covers the thinking, the architecture, and the findings.</p>
<h2>The Problem</h2>
<p>Design systems tell AI tools <em>what</em> to build. They don\u2019t tell them <em>why</em>.</p>
<p>A component library encodes visual tokens, spacing rules, and interaction patterns. That\u2019s the what. But the reasoning behind those patterns \u2014 when a particular component is dangerous to use in a clinical context, why a specific workflow exists for medication ordering, what accessibility constraints are non-negotiable versus preferred \u2014 that knowledge lives in people\u2019s heads. When those people leave, the knowledge goes with them.</p>
<p>AI tools trained on general data can produce design output that looks correct. It follows the tokens. It uses the right components. But without domain expertise, it can\u2019t distinguish between a layout that meets the requirements and a layout that meets the requirements <em>and won\u2019t get a nurse killed at 3 AM</em>.</p>
<p>The problem isn\u2019t AI capability. It\u2019s AI context.</p>
<h2>The Insight</h2>
<p>Design systems need to become brains, not libraries.</p>
<p>The shift is from documentation \u2014 \u201chere\u2019s how to use this button\u201d \u2014 to machine-queryable intelligence \u2014 \u201chere\u2019s why this pattern exists, when it\u2019s safe to deviate, and what breaks if you get it wrong.\u201d That means encoding the institutional knowledge that experienced designers carry, the stuff that\u2019s never written down because everyone who needs it just knows it, into a structure that AI tools can consume alongside visual tokens and component specs.</p>
<h2>The Architecture</h2>
<p>Domain Foundation uses a four-layer knowledge model. Each layer has different owners, different update cadences, and different levels of stability.</p>
<p><strong>Base layer \u2014 universal.</strong> Design principles, accessibility requirements, and interaction fundamentals that don\u2019t change across projects. Owned by the design system team.</p>
<p><strong>Domain layer \u2014 industry.</strong> Clinical safety reasoning, regulatory constraints, compliance requirements, healthcare-specific interaction patterns. Owned by domain experts.</p>
<p><strong>Component layer \u2014 artifact-specific.</strong> Intent metadata for individual components: when to use, when not to use, what breaks if misapplied. Owned by component authors.</p>
<p><strong>Role layer \u2014 user context.</strong> The specific needs, workflows, and constraints of different user types. A nurse navigating a medication administration record has different requirements than a billing specialist reviewing claims. Owned by researchers.</p>
<p>These layers compose at generation time. The AI draws from all four simultaneously. Different experts own different layers, which means the knowledge governance problem is distributed rather than centralized.</p>
<h2>What I Built and Tested</h2>
<p>This wasn\u2019t theoretical. I built working systems and ran structured experiments. Nine findings came out of that work.</p>
<p><strong>On knowledge structure:</strong> External prompt references hosted as GitHub gists function as living knowledge artifacts \u2014 updates propagate automatically to every session. Mixed-structure prompting (prose for rationale, bullets for constraints, IF/THEN for conditional logic) significantly outperforms uniform formatting. There\u2019s a practical ceiling of roughly 3,500 tokens for individual guidelines documents before retrieval quality degrades.</p>
<p><strong>On generation fidelity:</strong> Descriptive layer naming alone achieves approximately 90% generation fidelity in Figma Make \u2014 meaning clear, structured naming of design layers does most of the heavy lifting before any additional knowledge is injected. The delta between bare prompts and domain-enriched prompts reveals exactly how much institutional context the AI actually needs for any given task.</p>
<p><strong>On architecture:</strong> The knowledge base must be designed for both semantic (vector) retrieval and file-based retrieval simultaneously, because different tools consume knowledge differently. AI tools always fetch the latest version of external references \u2014 version pinning must be managed externally, not assumed. Pencil libraries in Figma cannot support internal component logic, a fundamental platform limitation that no amount of optimization will solve.</p>
<p><strong>On workflow:</strong> A bootstrap-navigate-validate pattern keeps context windows lean: load safety-critical rules at session start, navigate domain knowledge on-demand during generation, run full validation server-side after generation completes. This solves the context window problem that everyone building knowledge-enhanced AI systems encounters.</p>
<h2>The Frameworks</h2>
<p>The experiment findings produced seven original frameworks.</p>
<p><strong>The Validation Stack</strong> \u2014 A five-tier model for evaluating AI-generated output, ordered by cost and time investment: internal coherence (seconds), expert intuition (minutes), stakeholder alignment (hours), directional user signal (days), behavioral validation (weeks). Every tier catches different failure modes. Skipping tiers doesn\u2019t save time \u2014 it moves the cost downstream.</p>
<p><strong>The Role Inversion Model</strong> \u2014 Designers shift from generators to validators. Researchers become reality anchors. Strategists become reasoning validators. System architects become safety systems architects. The people who thrive aren\u2019t the most skilled generators \u2014 they\u2019re the ones who built careers on <em>getting to right</em> rather than <em>being right</em>.</p>
<p><strong>The Velocity Paradox</strong> \u2014 AI compresses generation time but not validation time. Organizations that optimize for speed without building validation architecture pay exponentially \u2014 they just pay later and all at once.</p>
<p><strong>Design Systems as Executable Knowledge</strong> \u2014 The shift from documentation to machine-queryable intelligence. The design system becomes infrastructure that AI tools consume, not reference material that humans read.</p>
<p><strong>The \u201cBeing Right vs. Getting to Right\u201d Divide</strong> \u2014 Who thrives in AI-augmented workflows isn\u2019t predicted by skill type or seniority. It\u2019s predicted by identity orientation. People whose professional identity is tied to being the expert source of correct answers struggle. People whose identity is tied to navigating toward correct answers adapt.</p>
<p><strong>The Four-Layer Knowledge Architecture</strong> \u2014 Described above. Base, domain, component, and role layers with distributed governance.</p>
<p><strong>The Bootstrap-Navigate-Validate Pattern</strong> \u2014 The technical workflow architecture for keeping AI sessions lean while maintaining constraint coverage.</p>
<h2>The Technical Stack</h2>
<p>The architecture itself is not proprietary. It\u2019s an emerging pattern: vectorized database \u2192 MCP server \u2192 LLM.</p>
<p>The value isn\u2019t in the stack diagram. It\u2019s in knowing what to put in the database (institutional knowledge, not just documentation), how to structure it (four-layer model with governance), and how to govern it (staging layer, confidence scoring, human curation).</p>
<p>The system supports dual-path delivery: an ideal path through vectorization and semantic retrieval, and a fallback path through direct file routing. Same knowledge base structure serves both. Graceful degradation is built in.</p>
<h2>Why This Matters</h2>
<p>Every organization adopting AI design tools is about to discover that their design system isn\u2019t enough. They have the visual layer. They\u2019re missing the reasoning layer. The AI can build what you show it. It can\u2019t know what you know.</p>
<p>The companies that figure this out early will have AI tools that produce work reflecting genuine organizational expertise. The ones that don\u2019t will have AI tools that produce plausible-looking work that misses every domain-specific constraint that makes their product safe, accessible, and effective.</p>
<p>Domain Foundation is how you build the layer that makes the difference.</p>
<h2>Current Status</h2>
<p>The methodology is complete and validated. The repackaging for broader market application \u2014 removing employer-specific references, generalizing healthcare examples to any high-stakes domain \u2014 is underway.</p>
<p>The frameworks and findings are domain-agnostic. Healthcare made them sharp. They apply anywhere the design decisions have consequences.</p>"""

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
