**SEO Description:** The site you're reading as a working demonstration — every structural change goes through Claude against an encoded corpus, not a designer opening a Figma file.

**Thumbnail Description:** The Workshop at working hours, curtains closed, zone-specific task lighting. Central butcher-block island in focus — a laptop open to a VS Code window, the visible file tree showing `theme/assets/css/` with `tokens.css` selected. A small printed card pinned near the keyboard reads "hairline 0.5px". The pendant light over the island throws warm directional light onto the wood. Exposed brick and plaster walls in the background; the mezzanine railing visible up and to the right. Style: the locked Workshop prompt — cinematic photorealism, anamorphic lens, natural film grain, shallow depth of field, warm cinematic color grading, motivated lighting from practical sources. No people visible. 16:9.

**Alt Text / Caption:** The butcher-block island under the pendant, an open laptop showing the site's token file.

---

# jeremyfuksa.com, Rebuilt Against a Corpus

The Ghost theme for this site has a file called `dev/deploy-theme.mjs`. Sixty-eight lines of JavaScript. It mints a short-lived JWT from an Admin API key, uploads a zipped theme to Ghost's admin endpoint, activates it. Four seconds from `node dev/deploy-theme.mjs` to a live site running new code.

I wrote none of it by hand.

A prior version of the handoff I was working from said the Admin API didn't have theme-management scope — that deploys had to happen over SSH, editing files directly on the production droplet. The claim was wrong. Claude Code tested it with a single POST, got a 200, and the SSH workaround fell away. The deploy script exists because the assumption that blocked it turned out to be false, and the only cost of checking was one HTTP call.

That's a small thing. But it's the whole posture of how this site gets built now.

## The corpus this site runs on

A skill called `campfire-css` enforces the Campfire design system as the single source of truth for every CSS and component decision — no raw hex, no `bg-blue-600`, no custom font imports, tokens for everything. A skill called `jeremy-voice` enforces the voice for every word of prose on the site. A skill called `cocktail-napkin-theme` encodes the Ghost-specific architecture: the static-first workflow where design happens in `static/*.html` files before porting to Handlebars templates, the `custom-*.hbs` pattern, the rule that borders use `var(--border-hairline)` at 0.5px because the hairline weight is deliberate and replacing it with 1px would kill the whole thing.

None of those skills existed when I built the first version of this site a year ago. I was opening Figma files and writing CSS by hand. The site built slowly and drifted from its own conventions — inconsistent spacing, one-off colors, decisions I made on Tuesday contradicted by decisions I made on Friday.

The corpus is the difference. Every rule I'd been half-remembering from session to session is in a file now. A model running against those files makes the same decision I would make if I had all the context loaded at once — which I never do, because I'm a human with a brain that forgets.

## What changed in practice

I restructured the Work page from a flat list of case studies into a three-orbit architecture — Frameworks, Demonstrations, Case Studies. Three sections, each with an intro paragraph, each with a different relationship to the primary IP. Shipped in a ninety-minute session with Claude Code, end to end. That includes: reading the current state of the theme, restructuring the Handlebars template, adding CSS for the new orbit sections before the consolidated mobile media block, verifying locally in the Docker dev container, bumping the theme version, committing, packaging, deploying, verifying live, and writing a post-mortem of where the handoff document was wrong.

The corpus carried most of that. The `cocktail-napkin-theme` skill told Claude where the mobile media block was and why not to break it. `campfire-css` kept the new orbit sections on-system. `jeremy-voice` kept the intro copy from drifting into content-strategist mush. What I did was make the three judgment calls: how many orbits, what to name them, which case studies belonged in which.

That ratio — me making the judgment calls, the corpus handling the execution — is the work.

## The constraint that shaped it

The site has one design constraint that predates all the skills: **analog signal in a chrome frame**. The content is messy and personal — a Red Dirt songwriter, an amateur radio hobbyist, a designer who got laid off — and the container has to be precise enough that the content reads as deliberate rather than chaotic. Hairline borders. Fraunces for headings with intentionally tight leading. A system font stack for body text because a webfont would overstate it. Two accent colors — one decorative, one readable — that never get conflated.

Every skill on the site is serving that constraint. A corpus that permitted loose typography would produce a site where the mess read as mess. The precision of the rules is what makes the content inside them register as a choice.

## What breaks without the corpus

Last week I hit a case where the handoff document I was working from said the Admin API couldn't upload themes. I spent about ten minutes writing a fallback plan — SSH to the droplet, edit files by hand, give up on the git-tracked workflow. Then I tested the original claim, got the 200, and threw the fallback plan away.

That was ten minutes of wasted planning against a false premise. Without the corpus, there's more of that kind of waste — not because any individual decision is hard, but because the background context keeps evaporating between sessions. You spend your cognitive budget reconstructing what you already knew last week.

The corpus doesn't make the decisions. It holds the context so I can make the decisions fresh each time without re-researching the invariants. The hairline weight is 0.5px because it's 0.5px. The deploy path is the script because that's the script. Freed from having to re-derive those, the session becomes entirely about the thing that actually needs thinking.

## What's not encoded yet

The site has a photography gap. I take pictures — printmaking too — and neither practice is encoded as a skill. Which means if a post involves a photograph I took, the thumbnail prompt for it still has to be written from scratch, and the specific choices I'd make about image selection for a particular post can't be applied by a model running against a corpus. They're still in my head.

Most of the gaps in the site are like this. Not places where the methodology failed — places where I haven't written the encoding yet. The list of those is its own artifact, and seeing it written down is most of why I know what to work on next.

## The part that generalizes

I keep telling people building design operations at their own companies that the order matters. You can't encode what you haven't named. You can't name what you haven't noticed is a recurring decision. And the recurring decisions are almost never the ones that feel most important in the moment — they're the small ones that get remade over and over because nobody wrote them down.

This site is a proof at one-practitioner scale that the methodology pays for itself. The deploy script doesn't care that I'm one person instead of a design system team. The hairline rule doesn't care either. The machinery works at any scale that has recurring decisions, which turns out to be any scale that makes anything at all.

The last pass of this site rebuild took ninety minutes. The one before that took three hours. The one before that, a week. The curve doesn't plateau — it steepens. Each decision encoded is one fewer decision to make next time, which frees up the session to encode the next one.

The next pass will be faster than this one. I already know what's missing.
