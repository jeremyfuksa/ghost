**SEO Description:** What a skill is, how to build one, and what happens when you run enough of them to form a connected system — told through the files on one practitioner's laptop.

**Thumbnail Description:** The Workshop at golden hour, mezzanine in focus. One of the AI test machines is on, screen displaying a dense tree of folders — skill directories, each with its own SKILL.md. The desk below catches warm directional light through the cracked north curtains; the KC skyline is a thin slice behind the glass. A Fira Code-printed page is pinned to the corkboard with "jeremy-voice" visible. Workshop consistency anchors: butcher block island in foreground (out of focus), exposed brick on the right, the mezzanine railing leading the eye up. Style: the locked Workshop prompt — cinematic photorealism, anamorphic lens, natural film grain, shallow depth of field, warm cinematic color grading, motivated lighting from practical sources. No people visible. 16:9.

**Alt Text / Caption:** A mezzanine screen showing a skill directory tree, warmed by golden hour through the north window.

## Syndication

### Facebook
New post — what a skill actually is, how to build one, and what happens when you have enough of them to run your whole life through. [link]

*Post: Wednesday 8:00pm CT after publication.*

### LinkedIn
If you've spent any real time with AI, you've hit the wall where the output sounds competent but generic — nothing in it that makes the work specifically yours or your team's. I wrote up what gets you past that wall: the anatomy of a skill, how to build one, and what happens at organizational scale when the person down the hall who makes the whole thing run finally gets her expertise encoded. [link]

#OpenToWork #UXDesign #AIDesign #DesignStrategy

*Post: Tuesday 12:30pm CT after publication.*

### Threads
A folder. A markdown file. Some examples.

That's it. That's enough to steer a model that's read most of what's been written on the internet.

The ratio is ridiculous. [link]

*Post: Wednesday 8:30pm CT after publication.*

---

# The Skill Ecosystem

If you've spent any real time with AI, you've hit the wall where the output sounds competent but generic — nothing in it that makes the work specifically yours, or your team's, or your organization's. Skills are how you get past that wall.

A skill is two things in one folder. The first is a rulebook — a document that tells a model how to work in your specific domain: what matters, what doesn't, what the mistakes look like. The second is reference material the rules operate on — examples, source artifacts. Drop them in a directory and a model can load them at the moment the work happens.

That's the whole process, and almost everything you do repeatedly with AI is a candidate. Anything that needs to stay on voice. Any workflow you run more than twice. Any output that has to conform to rules a generic model doesn't know. Skills are what makes a model behave the same way across those runs instead of drifting a little further from your intent every session.

## Inside the Rulebook

The folder structure is minimal:

```
my-skill/
  SKILL.md
  references/
    positive-examples.md
    anti-patterns.md
    calibration.md
    ...however many more the skill needs
```

The `SKILL.md` is the only required file. Everything else is optional and earns its place only if the rulebook can't stand alone.

**What goes in `SKILL.md`.** A short frontmatter block naming the skill and describing when it should trigger, then the rulebook itself. Some of the best rulebooks open with a single load-bearing rule with everything underneath elaborating on it. Others work by being thorough — a structured inventory, carefully organized, with no single rule doing outsized work.

What matters is that the rulebook reflects how the domain actually works and breaks, not how you wish it were organized. Sometimes writing the skill is the right time to clean up a sloppy process — the rulebook becomes the target, and your future work pulls toward it. Other times the mess is the point, because the workflow accounts for edge cases nobody else caught. Encoding the tidy version would strip out exactly the thing that makes the skill worth having.

**What goes in `references/`.** As many files as the skill needs. Three types of file tend to pull their weight across most skills.

*Positive examples.* Actual artifacts from your own work that show what the rule looks like when it lands correctly. If the skill is about writing voice, these are published posts. If it's about visual consistency, these are approved images. The model uses these as a target — "make the output more like these."

*Anti-patterns.* Examples of what the work looks like when it drifts. The specific failure modes, named and shown. If the skill is about writing, this is a catalog of the AI-sounding constructions you've caught the model producing — the "not X, but Y" fragment pairs, the unnecessary hedges, the closers that summarize what you just said.

*Calibration material.* The stuff that anchors judgment. For a voice skill, it's a list of phrases you actually say versus phrases you don't. For a domain skill, it's the specific terminology your organization uses versus the generic version of that terminology. The model uses this to tell whether its output is on-model before it shows you.

## A Small Working Example

Here's a skill small enough to show in full. The domain is the everyday question "how are you?" — universal, near-daily, and with a surprisingly narrow band of good answers between the autopilot lie and the oversharing dump.

```markdown
---
name: how-are-you-reply
description: Use when replying to "how are you?" from someone who is not close family or a therapist — in passing, in text, in a hallway, at the grocery store.
---

# How-Are-You Reply

## The rule

Give a real answer, not the whole truth. The failure mode isn't dishonesty. It's collapsing to either pole — "good!" (autopilot, tells them nothing) or a full state-of-me dump (burdens a person who asked a social question).

The target is the narrow band in between: one specific, true thing, small enough to hand over without asking anything of the other person.

## When this skill doesn't apply

- Close family, close friends, or anyone actually asking. Drop the rule; give them the real thing.
- Therapist or doctor. Wrong context entirely.
- When I'm the one initiating. This is for replies, not opens.
```

The `references/` folder for this one has three files.

**`positive-examples.md`** — replies that landed:

> *"Tired in a good way — big weekend."*
> *"Pretty okay. Got a thing on my mind but nothing I can't handle."*
> *"Honestly kind of great today, first time in a minute."*

Each one is one specific true thing. Small enough to hand over. Doesn't ask the other person to do anything with it.

**`anti-patterns.md`** — the two failure modes, named:

> *Autopilot.* "Good!" / "Fine, you?" / "Can't complain." Tells the other person nothing, reads as performance, closes the exchange before it could be real.
>
> *The dump.* "Well, I've been having a rough week, my back's been acting up, and I had this whole thing with my sister—" A question about your state became a monologue about it. The asker didn't sign up for that.

**`calibration.md`** — the narrow-band diagnostic:

> Can this reply be delivered in one breath without the other person needing to respond substantively? If yes, probably in the band. If no, check whether this is actually a close-family / actually-asking situation, and if not, trim it.

Each of those pieces earns its place.

- The **frontmatter** tells a model when to reach for this skill — not just "how are you?" in any context, but the specific passing-social version where the failure mode is real.
- The **rule** is a diagnostic. Not "be honest" (too vague) or "say one thing" (too mechanical). It's a description of the narrow band where good answers live, with the two failure modes named.
- The **"when this skill doesn't apply" section** is load-bearing. Skills get stronger when they name their own edges. A model that knows this skill doesn't apply to close family won't apply the rule when a family member asks, even though the phrase is the same.
- The **positive examples** give the model a target. Not descriptions of good answers — actual good answers. The model calibrates against the texture of those, not a paraphrase.
- The **anti-patterns** name the two failure modes sharply. A skill that only shows positive examples can drift toward averaging; a skill that also shows what the drift looks like can catch it.
- The **calibration file** is the one-breath diagnostic — a lightweight check the model can apply before producing output.

This skill is small enough to exist on one screen, and it still has all the parts of a real one. Scale it up — more domains, more context, more calibration — and you're not doing anything structurally different. You're just doing more of it.

## Plain Markdown Outlasts the Tooling

What's strange about all of this is how little it takes to steer something so big. A folder, a markdown file, a few examples. Yes, the more you put in the better it gets — but the ratio is ridiculous. A handful of paragraphs of text changes how a multi-billion-parameter model behaves in your domain.

One person's working practice, or an organization encoding institutional expertise across hundreds of skills — the shape doesn't change. Skills are the load-bearing piece of [Domain Foundation](/work/domain-foundation/), the methodology I built out of the Moonbird research at Oracle Health. The mechanism is foundational at whatever scale you're working at.
