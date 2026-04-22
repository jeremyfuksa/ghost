**SEO Description:** The research phase that became Domain Foundation — what I was doing for the year before the layoff, scrubbed of names and made portable.

**Thumbnail Description:** The Workshop mezzanine at late afternoon, curtains cracked letting warm directional light onto the workspace. Two AI test machines visible, one screen showing a dense diagram of concentric rings — a validation stack visualization — in muted colors. A small paper notebook open on the desk beside the machines, filled with quick arrows and crossed-out words. The brick and plaster of the north wall visible to the left; the KC skyline a blur through the glass. The space reads as a research environment: clean, concentrated, mid-thought. Style: the locked Workshop prompt — cinematic photorealism, anamorphic lens, natural film grain, shallow depth of field, warm cinematic color grading, motivated lighting from practical sources. No people visible. 16:9.

**Alt Text / Caption:** A validation-stack diagram on a mezzanine screen, afternoon light cracking through the curtains.

---

# The Research Year

The first thing anyone said, in the first meeting, was that AI in the hands of engineering and PM was going to take our jobs.

Not a metaphor. Figma Make had arrived, and a PM with no design training could generate a layout that looked real enough to circulate. The work a design team protected was, suddenly, something anyone could do plausibly enough to win an argument in a standup.

The question we opened with wasn't *how do we do AI better.* It was *how do we make sure a non-designer can't generate something that doesn't match our design system.*

I worked on it for about a year. A research effort at Oracle Health, inside the Redwood design system team, trying to figure out what design practice becomes when AI does all the making. The constraint that shaped every decision was that in healthcare software, "move fast and break things" gets people killed. Speed without safety validation isn't progress — it's liability.

That constraint turned out to sharpen everything.

## The core question

We started with guardrails. How do you make AI output that cannot deviate from the design system, regardless of who drove it? The standard answer is "give the model the design system documentation." It isn't enough. A component library tells a model what a button looks like. It doesn't tell the model which button is wrong for this workflow, or why a particular layout shouldn't exist in a clinical context even though every element in it is compliant.

Guardrails meant giving the generation pipeline access not just to the components but to the reasoning behind them.

That's the move that opened everything else. Once we were feeding the model reasoning and not just components, a second question came up: can AI actually produce novel design, or is it always a weighted average of training data? It's the average. That's what the technology is. Given a general model and a commodity prompt, you get the commodity output.

The only way out is to feed the model something no other organization has. Human factors research. Internal safety guidelines written down only in fragments. Accessibility standards as they apply to *this* product in *this* deployment context. Regulatory constraints tuned to real conditions.

Institutional knowledge, not documentation. That's where the project's center of gravity ended up.

## What we built

An engineer paired with me built a vector database, an MCP server, and the tooling to query it. We connected the pipeline to a commercial LLM and ingested three real corpora: Oracle's human factors research, the team's role profiles, and Oracle's internal accessibility guidelines.

The first test was small. We asked the system for information about a user persona we'd ingested. It answered accurately. Retrieval worked.

The second test was the one that mattered. We fed the system a persona plus a matching role profile, along with the context from an ongoing team conversation about a component pattern — something we'd been discussing but hadn't yet designed. We asked it to produce the pattern. It did a respectable job. The reasoning the team had been doing for weeks came back as a concrete artifact in seconds, shaped by the context we'd given the model access to.

What it didn't do was render correctly against the design system. Figma Make, at the time, couldn't reliably enforce a design system library built in Figma design — the output needed substantial rework to match the real component library. The reasoning layer worked. The production layer was the bottleneck.

## What the frameworks named

The research produced a handful of named observations I still use.

The validation stack — that AI compresses the generation phase of design dramatically but barely touches validation. Internal coherence checks compress to seconds; behavioral validation in clinical settings doesn't compress at all. The consequence: validation architecture becomes a more important discipline than design generation.

The role inversion — that designers shift from generators to validators as the generation timeline collapses. The bottleneck moves. What had been the hard part becomes the easy part. What had been the easy part becomes the hard part.

The velocity paradox — faster to wrong is worse than slower to right. AI compresses everything except the validation that tells you which answer to trust.

The who-thrives-who-struggles split — the hardest transition isn't for people who weren't detail-oriented. It's for people whose identity was built on craft and pixel perfection. The instinct to go more detailed is running toward the fire.

None of these are proprietary concepts. They're observations any team doing this work would eventually arrive at. Writing them down gave them names; the names gave them staying power. That's all.

## What ended it

I was laid off. The research project ended with me. The MVP was working — two tests demonstrating the core claim, plus the pipeline and the ingested corpora — but it wasn't productionized. What I had when I walked out the door was a year of thinking, a working proof-of-concept, and the observation that the methodology was more portable than the vendor tooling it had been running on.

The portable part is [Domain Foundation](/work/domain-foundation/). The research that produced it is what this dispatch is for.

## The difference between research and methodology

A research phase is legitimate even when it doesn't ship. That's a thing that's true of research and isn't true of product. This one didn't ship — it ended. But the year I spent on it is the reason the thinking I do now has the shape it has, and it's the reason the frameworks named in this post survive at all. The research was the work. The methodology is what I pulled forward out of it when the organization stopped being the container for the work.

That's a distinction worth naming because the portfolio instinct is to only show what shipped. What I can say about a research project is that it taught me something worth keeping. The teaching is the ship.

## What's in the Domain Foundation half

That research year was the research. Domain Foundation is what I built from it — the methodology stripped of the specific vendor pipeline, generalized past the healthcare constraint, and portable to any high-stakes domain. If you're reading this in order, [that's the next piece](/work/domain-foundation/).

The kickoff meeting, the guardrails question, the averaging problem, the MVP that worked — that's all from the research year. Everything since then is Domain Foundation.
