**SEO Description:** What personal infrastructure looks like when you stop treating tools as tools and start treating them as subsystems sharing one context.

**Thumbnail Description:** The Workshop at night. KC skyline visible through the cracked north curtains — downtown lights, the Moonliner rocket on the TWA/Barkley building. Mezzanine in focus: two AI test machines running, one screen showing an OmniFocus project list (JS — Foundation, JS — Pipeline), the other showing an Obsidian vault with nested folders. A mesh radio node with a small LED sits next to the machines. The physical desk below the mezzanine dark except for a pendant-lit section of the butcher block island showing a small paper notebook open — the analog anchor. Style: the locked Workshop prompt — cinematic photorealism, anamorphic lens, natural film grain, shallow depth of field, warm cinematic color grading, motivated lighting from practical sources. 16:9.

**Alt Text / Caption:** The mezzanine at night — OmniFocus on one screen, Obsidian on the other, KC skyline in the glass.

---

# Jeremy OS

The phrase started as a joke. I was trying to explain to someone what I meant by "I run my life on my own stack," and every time I tried it came out sounding like I had five separate productivity apps and no coherent story about why. Which was true for a while, and is not true anymore. The shift was small. I stopped calling them tools.

A tool is a thing you pick up for a specific job. An operating system is a thing that holds state for you, across jobs, because the jobs have something to do with each other. That's the frame that made the pile coherent.

Commitment lives in OmniFocus. Projects, tags, defer dates, flagged items that mean "I intend to work on this today." There's a skill called `omnifocus-expert` that knows the eight projects I actually have (four for the job search, three for life, one inbox), the seven tags I actually use, and the rule that a flagged task is a commitment for the day rather than a wish for the future. When I capture a task in conversation with Claude, the skill routes it — inbox if context is unclear, the right project if it isn't, a defer date if it's genuinely time-gated. The system stays accurate because the capture step is cheap.

Thinking lives in Obsidian. Four zones: one for the research practice from my last job, one for hyperfocus projects, one for songwriting, one for AI workflow assets. A skill called `obsidian-pkm` describes the structure; a separate skill called `obsidian-cli` covers the command-line interface for automated vault operations. Together they're the difference between a note system and a knowledge system — any skill can route a thought into the right zone with the right frontmatter without me thinking about it.

Procedural knowledge lives in skills. Twenty-six of them, each a `SKILL.md` and for a few, a `references/` subfolder for corpus material. I [wrote about this](/work/skill-ecosystem/) at length. The relevant point here is that skills don't just govern work — they hold context the other subsystems reach for. `omnifocus-expert` knows that the Content Engine project is deferred until mid-May. `obsidian-pkm` knows the frontmatter and tag schema the research zone requires. The rulebooks for how other systems behave live here.

Automation lives in n8n, self-hosted alongside the rest. A skill called `n8n-workflow-designer` covers patterns — daily brief, webhook-to-action, polling, idempotency. What n8n actually does: reads from Obsidian when a review cycle needs vault-wide context, writes to OmniFocus when an outside signal implies a new task, posts briefings where I'll see them. The workflows aren't impressive individually. What they do is let the other subsystems talk to each other without me being the one carrying messages.

Physical-world state lives in Home Assistant — a 2013 Mac Pro running Ubuntu Server in my basement, Home Assistant Container (not Supervised, which means no add-on store and manual orchestration for everything). The `home-assistant-expert` skill knows that specific stack. Lights, climate, a local voice pipeline slowly being built out, Z-Wave and Zigbee devices throughout the house. The OS extends into the physical world because the physical world is where the work actually happens — walking to the mesh radio node to check its uplink isn't a productivity concern, it's a location in the day.

## The claim the OS framing is making

Tools get compared. "Which note-taking app is best." "OmniFocus vs. Things vs. Todoist." That framing misses what's actually happening when a working system gets built over years. The apps are fungible. What isn't fungible is the accumulated context — the knowledge of my own projects, my own tags, my own vault structure, my own automation patterns, my own physical-world state. Moving from OmniFocus to Things wouldn't cost me the app. It would cost me the encoding.

This is the difference between owning software and running an OS. An OS is what's left when you've stopped thinking about which apps you're using and started thinking about the context they're preserving on your behalf.

## Where it breaks

The OS is not complete. There are seams. OmniFocus and Obsidian don't share a URL scheme — if I want to link a task to a note, I paste a path and hope it doesn't rot. The n8n instance has ten workflows I've sketched and three that actually run. The Home Assistant voice pipeline works for the simple things and crashes on anything complex; I've been meaning to rebuild it on Wyoming for four months. The photography zone of the Workshop doesn't have its own skill yet, so image decisions still happen in my head rather than through the corpus.

Some of the seams are because the encoding is hard. Some are because I haven't done it yet. The gap list is getting written down, which is itself the first move — you can't close a seam you haven't noticed.

## What I watch to know it's working

Two signals.

One: the end-of-session capture prompt. At the close of a working session in Claude Code, the `omnifocus-expert` skill prompts me to capture what's worth preserving. I do it by habit now. The sessions I close without capturing are the ones where the work didn't compound; the sessions I close with a half-dozen items routed to the right projects are the ones that actually moved the ball. The capture ritual is diagnostic.

Two: whether I can come back to a thing I half-finished last week and pick it up in under five minutes. If I can, the OS is holding state correctly. If I can't — if I spend twenty minutes re-reading my own notes to reconstruct what I was doing — the encoding has a gap.

Both signals are subjective. That's fine. The goal isn't a dashboard of metrics. The goal is a system where the background context stays warm, so the foreground session can be about the thing that actually matters.

## The part that travels

I don't think most people should build what I've built. Twenty-six skills is a lot. Four Obsidian zones is a lot. A self-hosted n8n instance is a lot. The specific configuration is mine because the specific practice is mine.

What travels is the frame. If the tools in your life aren't tools — if they're subsystems sharing context, and you've noticed that they are — the question changes. It stops being "which app should I use" and starts being "where does the context live, and what encoding does it need to stay warm across sessions."

That question is answerable at any scale. Mine happens to be one person with a mesh radio hobby and an ex-enterprise job. Yours will be different. The frame is the same.
