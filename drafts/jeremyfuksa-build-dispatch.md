**SEO Description:** The site you're reading, rebuilt against an encoded corpus — every structural change goes through a model instead of a designer opening a Figma file.

**Thumbnail Description:** The Workshop at working hours, curtains closed, zone-specific task lighting. Central butcher-block island in focus — a laptop open to a VS Code window, the visible file tree showing `theme/assets/css/` with `tokens.css` selected. A small printed card pinned near the keyboard reads "hairline 0.5px". The pendant light over the island throws warm directional light onto the wood. Exposed brick and plaster walls in the background; the mezzanine railing visible up and to the right. Style: the locked Workshop prompt — cinematic photorealism, anamorphic lens, natural film grain, shallow depth of field, warm cinematic color grading, motivated lighting from practical sources. No people visible. 16:9.

**Alt Text / Caption:** The butcher-block island under the pendant, an open laptop showing the site's token file.

## Syndication

### Facebook
Wrote up how jeremyfuksa.com actually gets built — every structural decision runs through a model against an encoded set of rules instead of me opening Figma files and hoping I remember the spacing from last week. [link]

*Post: Thursday 7:30pm CT after publication.*

### LinkedIn
A year ago I built jeremyfuksa.com by hand and it drifted — inconsistent spacing, one-off colors, Tuesday decisions contradicting Friday decisions. Today every rule that used to live in my head lives in a file a model can reach, and the site builds itself against them. Ninety-minute sessions now do what used to take a weekend. [link]

#OpenToWork #UXDesign #DesignStrategy #AIDesign

*Post: Thursday 8:30am CT after publication.*

### Threads
The constraint on jeremyfuksa.com that predates everything else: analog signal in a chrome frame.

The content is messy and personal. The container has to be precise enough that the mess reads as deliberate.

Half-pixel borders. Tight leading. System fonts. Rules I can't re-derive every session without losing a day. [link]

*Post: Thursday 8:00pm CT after publication.*

---

# Analog Signal in a Chrome Frame

That's the design constraint that predates everything else on jeremyfuksa.com. The content is messy and personal — a Red Dirt songwriter, an amateur radio hobbyist, a designer who got laid off — and the container has to be precise enough that the mess reads as deliberate. Hairline borders at half a pixel. Fraunces for headings with intentionally tight leading. System fonts for body text because a webfont would overstate it. Two accent colors, one decorative and one readable, and I don't let them get conflated.

A year ago I built this site by opening Figma files and writing CSS by hand. It drifted. Inconsistent spacing, one-off colors, decisions I made on Tuesday contradicted by decisions I made on Friday. Today every one of those rules lives in a file a model can reach.

## The Rules, Written Down

A skill called `campfire-css` holds the design system — tokens for every value, no raw hex, no custom font imports, nothing that escapes the system. `jeremy-voice` holds the voice for every word of prose on the site. `cocktail-napkin-theme` holds the Ghost-specific architecture: the static-first workflow where design happens in `static/*.html` files before porting to Handlebars templates, the `custom-*.hbs` pattern, the rule that borders use `var(--border-hairline)` at 0.5px because the hairline weight is deliberate and a 1px replacement would kill the whole thing.

Every rule I'd been half-remembering session to session is in a file now. A model running against those files makes the same decision I would make with all the context loaded at once — which I never have, because I'm a human with a brain that forgets.

## The Deploy

There's a sixty-eight-line JavaScript file called `dev/deploy-theme.mjs` that mints a short-lived JWT from an Admin API key, uploads a zipped theme to Ghost's admin endpoint, and activates it. Four seconds from one terminal command to a live site. I didn't type any of it — Claude Code wrote the whole file in a session.

The reason it was worth writing is that a prior handoff claimed the Admin API didn't have theme-management scope. The claim was wrong. One HTTP call proved it, and the SSH-to-the-droplet workaround the handoff recommended fell away.

## Ninety Minutes, End to End

I restructured the Work page from a flat list of case studies into three orbits — Frameworks, Demonstrations, Case Studies. Three sections, each with an intro paragraph, each with a different relationship to the primary IP. Ninety-minute session with Claude Code, end to end. That includes reading the current state of the theme, restructuring the Handlebars template, adding CSS before the consolidated mobile media block, verifying locally in the Docker dev container, bumping the theme version, committing, packaging, deploying, verifying live, and writing a post-mortem of where the handoff was wrong.

The skills carried most of that. `cocktail-napkin-theme` knew where the mobile media block was and why not to break it. `campfire-css` kept the new sections on-system. `jeremy-voice` kept the intro copy from drifting into content-strategist mush.

I made three judgment calls: how many orbits, what to name them, which case studies belonged in which.

## What the Skills Don't Do

They don't make the decisions. They hold the context so I can make decisions fresh each time without re-researching the invariants. The hairline weight is 0.5px because it's 0.5px. The deploy path is the script because that's the script. Freed from re-deriving those, the session becomes entirely about the thing that actually needs thinking.

## The Gaps

The site has a photography gap. I take pictures. Printmaking too. Neither practice is encoded. If a post involves a photograph I took, the thumbnail prompt still has to be written from scratch, and the specific choices I'd make about image selection for that post can't be reached by anything running against the files.

Most of the gaps are like this. Not places where the methodology failed — places where I haven't written the encoding yet. The list is its own artifact.

## The Part That Travels

The order matters. You can't encode what you haven't named. You can't name what you haven't noticed is a recurring decision. And the recurring decisions are almost never the ones that feel most important in the moment — they're the small ones that get remade over and over because nobody wrote them down.

This site is a proof at one-practitioner scale. The deploy script doesn't care that I'm one person instead of a design system team. The hairline rule doesn't care either. The machinery works at any scale that has recurring decisions.

The next pass will be faster than this one.
