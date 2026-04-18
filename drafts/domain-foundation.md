# The Context Layer

**Role:** Creator and primary researcher
**Timeline:** 2023–2024, ongoing
**Organization:** Oracle (Redwood Design System)
**Scope:** A methodology for encoding institutional design expertise into AI-assisted design workflows.

---

## The kickoff

The first thing anyone said, in the first meeting, was that AI in the hands of engineering and PM was going to take our jobs.

Not a metaphor. Figma Make had arrived, and a PM with no design training could generate a layout that looked real enough to circulate. The work a design team protected was, suddenly, something anyone could do plausibly enough to win an argument in a standup.

The question we opened with wasn't *how do we do AI better.* It was *how do we make sure a non-designer can't generate something that doesn't match Redwood.*

## The pattern that has served me well

Every technology I care about, I learned by using it before I was supposed to.

In college it was Photoshop and After Effects. I should have been in class. I was in the lab instead, making things the coursework wasn't asking for. The habit cost me grades and gained me a career.

In 2023 it was image generation — the era of postage-stamp output that couldn't render a face, Will Smith eating spaghetti, early Midjourney. From there into ChatGPT: copy the code into the chat window, paste the result back, rinse and repeat until the bug was fixed. When I learned about Claude and Claude Code, I realized something had shifted for me. I now had the power to make anything I wanted, as long as I had the clarity to say what I wanted.

That last clause turned out to be the whole problem.

## First question: guardrails

The first version of the project was narrow. How do you make AI output that cannot deviate from the design system, regardless of who drove it?

The standard answer is "give the model the design system documentation." It isn't enough. A component library tells a model what a button looks like. It doesn't tell the model which button is wrong for this workflow, or why a particular layout shouldn't exist in a clinical context even though every element in it is compliant.

Guardrails meant giving the generation pipeline access not just to the components but to the reasoning behind them.

## Second question: differentiation

Once we were rolling, a second question opened: **can AI actually produce novel design, or is it always a weighted average of training data?**

It's the average. That's what the tech is. Given a general model and a commodity prompt, you get the commodity output — the same thing every other team gets when they reach for AI without doing more work than asking for a design.

The only way out is to feed the model something no other organization has. The things that tend to live in experienced people's heads: human factors research, internal safety guidelines written down only in fragments, accessibility standards as they apply to *this* product in *this* deployment context, regulatory constraints tuned to real conditions.

That's the context layer. It converts an averaging machine into a machine that reflects specific institutional expertise.

The architecture we landed on is four layers, chosen because it matched how the knowledge is actually *owned* inside a design group. A base layer of universal design principles, owned by the design system team. A domain layer of industry-specific reasoning, owned by domain experts. A component layer of per-artifact intent metadata — when to use, when not to — owned by component authors. A role layer describing user types and their constraints, owned by researchers. The model composes from all four at generation time, which distributes governance instead of centralizing it on the design system team.

That's the design group's portion. Other institutional knowledge — customer feedback, Jira tickets, and everything else — lives in other systems and needs its own ingestion story. The four-layer model is what we built because it's what our team owned. The larger context problem extends past it.

The technical shape — vector database, MCP server, LLM — isn't the interesting part. What goes into the database is. Institutional knowledge, not documentation.

## Third question: the toolchain

If the context layer works, the next question is unavoidable: what do you feed its output *into*?

We tried Figma Make. The output pipeline wasn't reliable enough for governed generation at the time. We looked at going straight into Codex for component work. It worked differently — better for some tasks, worse for others.

Different outputs wanted different tools, and accepting that was the structural decision that made everything else work.

## The shadow practice

Through 2024 I'd been building my own practice around AI collaboration. Not vendor tools. Not official processes. Just figuring out what the tech was actually good at when a designer used it for real work.

What I did was small. I wasn't generating Figma frames. I was asking a language model to pressure-test my thinking — edge cases, interaction logic, the things I hadn't caught on my own. The artifact was always mine. The thoroughness behind it was multi-authored.

By the time the kickoff happened, I'd been ahead of the curve for a year.

## The gap the methodology exists to close

My design team killed a feature for privacy reasons. The AI didn't catch it. A designer on the team did. The [full story](redwood-health-pod.md) is its own case study; the part that matters here is what the AI missed. It could reason at the surface — workflow, provider needs, clinical framing. It couldn't carry the deployment context. Human expertise killed the feature, not the AI's.

The Context Layer is a bet that the *why* can be captured in a form a model can use, so that the judgment of people like my colleague doesn't walk out the door when they do. (now that I'm on the other side of this, I have a whole new set of thoughts and questions about that)

Design teams whose expertise is encoded — literally, as a retrievable knowledge base tied to the generation pipeline — will do work that doesn't look like everyone else's. Design teams whose expertise lives only in people's heads will produce outputs a PM with a good prompt can already reproduce. That gap is going to decide which design organizations matter a few years from now.

## What the MVP proved

An engineer on the project built the vector database, the MCP, and the tooling to query it. We connected the pipeline to ChatGPT 5.4 and ingested three real corpora: Oracle's Human Factors research, the team's role profiles, and Oracle's internal accessibility guidelines. Links to additional internal research hung off the rest.

The first test was small. We asked the system for information about a user persona we'd ingested. It answered accurately. Retrieval worked. The corpus was real.

The second test was the one that mattered. We fed the system a persona plus a matching role profile, along with the context from an ongoing team conversation about a component pattern — something we'd been talking about but had not yet designed. We asked it to produce the pattern. It did a respectable job. The reasoning the team had been doing for weeks came back as a concrete artifact in seconds, shaped by the institutional context we'd given the model access to.

What it didn't do was render correctly against the design system. Figma Make, at the time, couldn't reliably enforce a design system library built in Figma design — the output we got needed substantial rework to match the real component library. The reasoning layer worked. The production layer was the bottleneck, which is why the toolchain question became a live one.

The layoff ended the project early. What we had was a working MVP and two tests demonstrating the core claim — institutional context, encoded and retrievable, shapes what a model produces — was real.

## Where this sits

This is methodology, not product. It's hard to demo. Half the value is in what you choose to put in the knowledge base, and the choosing is the expertise — not the structure. I'm generalizing the healthcare-specific examples so the same methodology can travel to other high-stakes domains. Healthcare made the thinking sharp, but the work isn't healthcare-specific. It applies anywhere the design decisions have consequences.

The formal project the Context Layer came out of was in active development when the layoff ended it. What I'm carrying forward is the pattern.

The people I find myself talking to now are ones who've arrived at the same realization I did eighteen months ago: default models produce default output, and if you want design that reflects real institutional insight, you have to put that insight somewhere the model can actually reach. They're early in asking the question. I'm further along in answering it, because I spent a year and a half building toward it inside a real enterprise product. Those conversations are where the work is sitting right now.

The college habit — learning tools before the institution caught up to them — landed, this time, on the problem I think matters most in design for the next decade. The Context Layer is the mature expression of twenty-five years of that habit. It's also just one answer to a problem that's going to need many.
