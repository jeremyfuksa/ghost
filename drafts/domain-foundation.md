# Domain Foundation

**Role:** Creator and primary researcher
**Timeline:** 2023–2024, ongoing
**Scope:** A methodology for encoding organizational design expertise into machine-readable knowledge systems for AI-assisted design workflows.

**Sidebar stats:** _(removed — counting "frameworks" contradicted the voice rewrite)_

---

## How I got here

I started working seriously with AI design tools in 2023 and kept noticing the same thing: they generated fast, and they generated wrong. Not broken — *plausible*. The output looked right until you held it up against anything that required actual domain expertise. A healthcare layout that met every stated requirement and would also quietly get a nurse killed at 3 AM.

The wrongness wasn't a model capability problem. It was a context problem. The model didn't know what I knew, and I had no good way to tell it.

Domain Foundation came out of trying to solve that. It's a methodology for building the knowledge layer that AI tools need in order to produce work that reflects real organizational expertise instead of averaged training data. I built it, I tested it, and this is what came out of it.

## The gap

Design systems tell AI tools what to build. They don't tell them why. A component library encodes visual tokens, spacing, interaction patterns — that's the what. The reasoning — when a particular component is dangerous to use, why a specific workflow exists, what accessibility constraints are non-negotiable versus preferred — lives in experienced people's heads. When those people leave, the reasoning leaves with them. AI tools trained on general data fill that gap with plausible averages, and you only find out it was plausible-but-wrong after it ships.

## What I built

The architecture I landed on is a four-layer knowledge model, chosen mostly because it matched how the knowledge is actually owned in the organizations I was designing for. A base layer of universal design principles and accessibility fundamentals, owned by the design system team. A domain layer of industry-specific reasoning — clinical safety, regulatory constraints — owned by domain experts. A component layer of per-artifact intent metadata (when to use, when not to), owned by component authors. A role layer describing the needs and constraints of different user types, owned by researchers. The AI composes from all four at generation time, which distributes the governance problem instead of centralizing it on the design system team.

The technical shape is the emerging pattern — vector database, MCP server, LLM — but the shape isn't the interesting part. What goes into the database is. Institutional knowledge, not documentation.

## What testing it actually taught me

Some of what I learned was what I expected. A lot wasn't.

The retrieval ceiling is real. Individual guidelines documents start to degrade around 3,500 tokens — past that, the model stops reliably surfacing the relevant constraints. I'd assumed longer was better. Longer wasn't better.

Mixed-structure prompting outperforms uniform formatting by a surprising margin. Prose for rationale, bullets for constraints, IF/THEN for conditional logic. Engineering-pretty uniform JSON loses to a messier, human-shaped mix.

The workflow that worked best was bootstrap-navigate-validate: load safety-critical rules at session start, fetch domain knowledge on demand during generation, run full validation server-side after. This solved the context-window problem I spent a month fighting head-on before giving up and going around it.

The most uncomfortable finding wasn't technical. AI compresses generation time but not validation time. Every team I watched optimizing for "how fast can we produce" was quietly accruing a validation debt that showed up weeks later, all at once. Speed without validation architecture isn't speed. It's a deferred invoice.

And finally: descriptive layer naming alone, with no additional knowledge injection, gets you roughly 90% of the way there in Figma Make. The boring work of naming things carefully does more than any prompt engineering stunt.

## Where this sits

This is methodology, not product. It's hard to demo. Half the value is in what you choose to put in the knowledge base, and the choosing is the expertise — not the structure. I'm in the middle of generalizing the healthcare-specific examples so the same methodology can travel to other high-stakes domains. Healthcare made the thinking sharp, but the work isn't healthcare-specific. It applies anywhere the design decisions have consequences.
