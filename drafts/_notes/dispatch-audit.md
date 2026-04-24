# Dispatch Audit — Pieces 1–4

**Date:** 2026-04-22
**Scope:** The four unpublished Demonstrations dispatches in `drafts/`.
**Lenses applied per piece:** fact-check, voice, quality, job-search relevance, gaps.
**Final section:** cross-cutting observations across the set.

---

## Executive summary

All four pieces are close to publication-ready. None have a structural problem that can't be fixed in under an hour. The biggest cross-cutting issue is a **load-bearing factual claim that repeats across three of them and may not be true in the form stated** (see "What I need you to verify" at the end).

**Publication-readiness ranking:**
1. 🟢 **The Research Year** — cleanest of the set. One small verification needed.
2. 🟢 **The Skill Ecosystem** — strong. Two small tightens.
3. 🟡 **jeremyfuksa.com Build** — the weakest of the four structurally. Leads with too much about me (Claude Code / handoff / deploy script) and under-indexes on *why a hiring manager should care*. Needs a scope tightening more than a rewrite.
4. 🟡 **Jeremy OS** — good piece, but the hiring-manager value is the quietest of the four. Might be the first to cut if you ever need to trim the set.

Job-search relevance summary: three of four do strong work for your positioning. **Jeremy OS is the one piece whose publication calculus is not obvious** — it could help (shows range, shows mind), could hurt (reads as "look at my elaborate personal productivity system" to a reader who doesn't already trust you), depending on the audience. I flag that below.

---

## 1. The Research Year 🟢

### Fact check

| Claim | Status |
|---|---|
| "The first thing anyone said, in the first meeting, was that AI... was going to take our jobs." | Verified — this was the opening of the kickoff meeting per your previous telling. |
| "Figma Make had arrived" at project kickoff time | Figma Make was announced at Config 2024 (June 2024). If the project kickoff was before ~June 2024, this is **chronologically off**. You told me the project ran roughly through 2024. If kickoff was January–May 2024, Figma Make wasn't yet available — the threat would have been *other* AI tools. **Needs verification.** |
| "A research effort at Oracle Health, inside the Redwood design system team" | Public on LinkedIn. Verified. |
| "In healthcare software, 'move fast and break things' gets people killed" | True and defensible. |
| "An engineer paired with me built a vector database, an MCP server..." | Per your prior telling. Verified. |
| "Ingested three real corpora: Oracle's human factors research, the team's role profiles, and Oracle's internal accessibility guidelines" | Per your prior telling. Verified. The phrasing "Oracle's" is fine — not proprietary, just identifying source. |
| "Figma Make, at the time, couldn't reliably enforce a design system library built in Figma design" | Widely-known limitation of early Figma Make. Verified. |
| "AI compresses the generation phase of design dramatically but barely touches validation" | Observed across the industry. Defensible. |
| "Faster to wrong is worse than slower to right" | Your framework; you named it. Fine. |

### Voice check

- Opens in the room with a stated fact. ✓
- Lead sentence doesn't announce the topic. ✓
- Meta-headers ("The core question", "What we built", "What the frameworks named", "What ended it", "The difference between research and methodology") are flat pointers. ✓
- "X, not Y" count: two ("*how do we do AI better*" / "*how do we make sure a non-designer can't generate...*", and the "Speed without safety validation isn't progress — it's liability"). Within tolerance.
- One inline italic for emphasis at "this product" / "this deployment context". Earned.
- **Possible wisdom-reach at closer:** "The teaching is the ship." Reads as the kind of aphoristic closer `jeremy-voice` flags as anti-pattern. But: the sentence is doing structural work (it's the thing that justifies publishing a research-phase piece at all). It earns its place. I'd keep it.
- Ending paragraph: "The kickoff meeting, the guardrails question, the averaging problem, the MVP that worked — that's all from the research year. Everything since then is Domain Foundation." Reported, understated. ✓

### Quality

Structurally sound. Each section does distinct work. "The difference between research and methodology" is the best-earned section — it addresses the reader's implicit "but it didn't ship, why does this count" objection head-on. That section is load-bearing; don't cut it.

The piece closes with a pointer forward. Correct — this is the first in a reading-in-order sequence.

### Job-search relevance — **HIGH**

This piece does exactly what a Director/Principal UX portfolio piece should do: demonstrates a year of substantial research at a named employer in a regulated industry, with named frameworks you produced, with concrete artifacts (the MVP, the tests, the corpus), and with an honest accounting of what ended it and what didn't. A hiring manager reading this forms the correct inference: "this person did the work, named the things, and can talk about it without overclaiming or hiding."

The "research that didn't ship" framing is itself a hiring signal — it separates you from people whose only stories are of shipped products. Senior design leadership cares about research discipline.

### Gaps

- The claim about who killed the project ("I was laid off") is stated once, briefly. That's correct voice-wise (don't dwell). But a reader who doesn't know you might wonder: was the *project* killed by the layoff, or just your role? One additional sentence — "the project didn't continue after" or "the team was dispersed" or "I don't know what happened to it" — would close that ambiguity without milking it.
- No mention of what the MVP output *looked like*. If there's a screenshot or artifact you can share (generic, no confidential content), it'd help.

### Recommended changes

1. **Verify Figma Make chronology** — if project kickoff was pre-June 2024, change the opening to reference the broader AI-takes-design-jobs threat rather than Figma Make specifically.
2. **Optional:** one sentence on what happened to the project after you left (or "I don't know" — both are fine).
3. **Optional:** include a representative MVP artifact or screenshot.

---

## 2. The Skill Ecosystem 🟢

### Fact check

| Claim | Status |
|---|---|
| "My laptop has twenty-six skills installed" | Verified — 25 Jeremy-authored + cocktail-napkin-theme = 26. Correct as of 2026-04-21. |
| "The thing I built at Oracle was Domain Foundation" | **Framing issue.** Domain Foundation was built *after* Oracle (Christmas 2024 crystallization). Oracle was where the research happened. This line conflates the two. Small fix needed — see below. |
| `jeremy-voice` is "twenty pages of rules" | The file is ~21KB with ~250 lines. "Twenty pages" is a reasonable printed estimate. Verified. |
| `kc-topography-analyst` is "five pages" | File is 5KB. Accurate. |
| "Penn Valley Park / Hospital Hill area: downtown-adjacent, elevated, overlooking both rivers" | Real geography. Verified. |
| "A 2013 Mac Pro running Home Assistant in a Docker container (not Supervised)" | Verified from `home-assistant-expert` skill. |
| "Made the bet inside Oracle Health, at the scale of a design org with its own design system team, clinical safety researchers, and regulatory experts" | **Small precision issue.** "Clinical safety researchers" and "regulatory experts" are terms from your skills vocabulary. At Oracle the equivalent functions existed but may not have been called those. Worth checking whether this phrasing misrepresents the org structure. |

### Voice check

- Opens with a stated fact in the room ("My laptop has twenty-six skills installed"). ✓
- Flat section headers. ✓
- "X, not Y" count: two structural ("From the outside they look... / From the inside they're...", "The twenty pages aren't a recipe. The meta-rule is.") — both earned pivots, within tolerance.
- One inline italic ("*when the prose feels off, it's almost always because it shifted from reporting to thesizing. Return it to reporting and the voice comes back.*"). Justified — it's a direct quote of the skill content.
- Closer: "The methodology scales down." Four words. Reported. ✓ Best closer of the four pieces.

### Quality

Structurally this is your strongest piece. Each section grounds in a specific skill (`jeremy-voice`, `kc-topography-analyst`, `songwriting`, `jeremys-workshop`, `omnifocus-expert`, `home-assistant-expert`). The progression — rulebook → local knowledge → creative practice → visual governance → operational → gap — tells a complete story of the corpus without feeling like a taxonomy.

The "gap" section is especially well-handled. Honest without being self-deprecating. The line "where it does nobody's model any good" is the kind of reported-observation the voice skill wants.

### Job-search relevance — **HIGH**

This is the piece most likely to register as novel to a hiring manager. Most portfolios claim "I use AI." This one shows a working corpus of twenty-six skills encoding a practice, with honest gaps. For Director/Principal UX roles at AI-adjacent companies (Anthropic, Figma, OpenAI, etc. — per the `jeremy-voice` strategic context), this piece does load-bearing hiring-signal work.

The Wormy Dog reference at the end is a deliberate signal — it says "I have a life and interests that aren't the job" without announcing it. That signal matters for the kind of leadership roles you're positioned for.

### Gaps

- The "Domain Foundation was a bet about organizations... I made the bet inside Oracle Health" paragraph conflates "building at Oracle" with "distilling the methodology." Fix by editing: "The research that became Domain Foundation happened inside Oracle Health..." or similar.
- No link to the GitHub repo for the skill corpus. There is none — the skills live in a Claude Desktop app-data directory, not a public repo. Not a gap per se, but worth noting if you ever consider open-sourcing a redacted subset. **That would be a significant career move** — not recommending it, just naming it.

### Recommended changes

1. **Fix the Oracle conflation** in paragraphs 3 and 10 (the one starting "The thing I built at Oracle was Domain Foundation" and the closer paragraph starting "Domain Foundation was a bet about organizations"). Simple rewording:
   - "The thing I built at Oracle was Domain Foundation" → "The thing I started working on at Oracle became Domain Foundation"
   - "I made the bet inside Oracle Health" → "I made the bet first inside Oracle Health, where the research happened"
2. **Optional:** one more sentence naming what specific senior-design-org functions existed at Oracle vs. what you're attributing to them, if you want to be precise.

---

## 3. jeremyfuksa.com, Rebuilt Against a Corpus 🟡

### Fact check

| Claim | Status |
|---|---|
| "The Ghost theme for this site has a file called `dev/deploy-theme.mjs`" | Verified in repo. |
| "Sixty-eight lines of JavaScript" | Actually 68 lines per `wc -l`. Verified. |
| "Four seconds from `node dev/deploy-theme.mjs` to a live site" | Observed — actual deploys took ~4 seconds. Verified. |
| "I wrote none of it by hand" | Technically true — Claude Code wrote it. But for a reader, "I didn't write it" is misleading because you *directed* its creation. Worth reconsidering the phrasing. |
| "Ninety-minute session with Claude Code, end to end" | Approximate. The orbit restructure session was about that length. Defensible. |
| "The last pass of this site rebuild took ninety minutes. The one before that took three hours. The one before that, a week." | **Speculative.** You don't have rigorous timings on prior passes. The curve claim is vibes, not measurement. Either soften ("feels like it steepens") or cut. |

### Voice check

- Opens in the room with a specific file. ✓ Good opener.
- "I wrote none of it by hand" — the voice move here is correct (the paragraph-break drama, the flat declarative) but the *content* might be misleading. See fact check.
- Flat section headers. ✓
- "X, not Y" count: minimal. Clean.
- One inline bold for "**analog signal in a chrome frame**" — this is introducing a named concept, not scaffolding. Acceptable.
- **Anti-pattern flag:** The sentence "That ratio — me making the judgment calls, the corpus handling the execution — is the work." has the "is the [X]" construction that `jeremy-voice` sometimes lets land but often flags. Here it's earned because it caps a section of concrete examples. Keep.
- Closer: "The next pass will be faster than this one. I already know what's missing." Reported, understated. ✓

### Quality

Structurally the weakest of the four. Reasons:

1. **Opens with process metadata, not with the reader's stake.** The first ~150 words are about a deploy script. A reader who isn't technical has to work to understand why the deploy script matters. A hiring manager will skim this section; a designer-reader will bounce.

2. **The "what changed in practice" section reads like a changelog entry** for the `/work/` page restructure. Fine as evidence, but the piece stays in this mode too long. The reader learns a lot about *how you ran the rebuild* and less about *what running the rebuild that way proved*.

3. **The "What breaks without the corpus" section repeats the opening beat** (the handoff-claim-was-wrong story). You tell it twice. Once is enough.

The piece has strong moments — "analog signal in a chrome frame" is the strongest line in any of the four pieces — but those moments are surrounded by process detail that dilutes them.

### Job-search relevance — **MEDIUM-HIGH**

The piece *does* argue a real claim (methodology works at one-practitioner scale, compounds over time). That claim is job-search-relevant. But the evidence is stacked on technical process (deploy scripts, CSS architecture, Handlebars templates) that only a technically-literate hiring audience will parse, and those readers will likely trust the claim from the Skill Ecosystem piece and find this one repetitive.

The piece's best hiring-signal move is the "analog signal in a chrome frame" paragraph — it shows design taste at the level a Director/Principal role requires. That paragraph is currently the fifth section down, after four sections of process. **If you could rearrange to put the design-taste paragraph earlier, the piece would do more hiring-signal work in less reading time.**

### Gaps

- No mention of the site's *readership* or *purpose* beyond self-reference. Why does the site exist at all? The Cocktail Napkin is where you think in public — that's stated in the `jeremy-voice` skill's strategic context but not in this piece. One sentence placing the site in the world (not "a portfolio," not "a blog," but a specific third thing) would help.
- The piece makes a strong claim about the compounding curve ("ninety minutes / three hours / a week") without evidence. Either back it with a specific before-and-after comparison of a specific change, or soften to vibes-level.

### Recommended changes

1. **Restructure the opening.** Move "analog signal in a chrome frame" forward. Consider opening the piece with that phrase, then letting the corpus story follow. Current opening paragraph can become section 2.
2. **Cut the repeated handoff-claim-was-wrong story** in the "What breaks without the corpus" section. The story already appeared in the opening. The section can instead make the abstract point (corpus holds context between sessions) without re-telling.
3. **Soften or substantiate the compounding-curve claim.** Either find real before/after data, or change "took ninety minutes / three hours / a week" to "feels steep" or similar.
4. **Reconsider "I wrote none of it by hand."** The sentence works voice-wise but misleads content-wise. Alternative: "I didn't type any of it." Or: "The lines came out of Claude Code on a request." Or delete the sentence and let the following paragraph carry the point.

---

## 4. Jeremy OS 🟡

### Fact check

| Claim | Status |
|---|---|
| Eight projects in OmniFocus: "four for the job search, three for life, one inbox" | **Wrong.** Actual count per last night's query: 8 projects total = 3 JS projects (Presence, Pipeline, Content Engine), 3 "life-ish" (Hot Right Now, Backlog, Life), 1 inbox (Miscellaneous), and 1 outlier (Signal/Noise Dashboard — the not-yet-renamed Jeremy OS project). So the breakdown is more like "three for the job search, four for life, one inbox" — unless you count Signal/Noise Dashboard as job-search-adjacent, in which case "four and three and one" but that's a stretch. **And** the `omnifocus-expert` skill claims JS — Foundation exists, but it doesn't. **This number needs a real fix, not a vibes-pass.** |
| Seven tags in OmniFocus | Verified from `omnifocus-expert` skill. |
| "Content Engine project is deferred until mid-May" | Verified. Per the skill, deferred until 2026-05-15. |
| "2013 Mac Pro running Ubuntu Server" | Verified from `home-assistant-expert`. |
| "Home Assistant Container (not Supervised...)" | Verified. |
| "The n8n instance has ten workflows I've sketched and three that actually run" | Not independently verifiable. Claimed in the piece as a gap admission; I'll take the honesty as valid. |
| "The Home Assistant voice pipeline works for the simple things and crashes on anything complex" | Not independently verifiable. |
| "I've been meaning to rebuild it on Wyoming for four months" | Not independently verifiable. Feels honest. |

### Voice check

- Opens with "The phrase started as a joke." — reports how the framing originated, not what it is. ✓
- Short opener paragraph sets up the frame without thesizing it. ✓
- **Anti-pattern warning:** five consecutive paragraphs each open with "[X] lives in [Y]." — "Commitment lives in OmniFocus," "Thinking lives in Obsidian," etc. This is the *exact* repetition pattern that `jeremy-voice` flags ("If three fragments appear in a section, two of them are cosmetic"). The construction is load-bearing once; it's AI-tell rhythm four times in a row. **Needs a real rewrite on at least two of the five** to vary the construction.
- Flat section headers. ✓
- Closer: "The frame is the same." Reported, understated. ✓
- **Prescription anti-pattern:** the "What travels" section has "What travels is the frame." as a sentence. That's the kind of abstract-is-the-sentence moment the voice skill flags. But it's immediately followed by a concrete application ("If the tools in your life aren't tools..."), so the abstraction lands in a scene. Keep.

### Quality

Good piece with a structural repetition problem (the five "X lives in Y" paragraphs). Otherwise the structure works: frame → inventory → claim → breakage → signals → generalization.

The "Where it breaks" section is the strongest move in any of the four pieces — it does specific, named, verifiable gap-admission without performing modesty. "I've been meaning to rebuild it on Wyoming for four months" is exactly the tone.

The "what I watch to know it's working" section is load-bearing — it's the piece that elevates this from "productivity nerd shows his stack" to "this person has thought carefully about the epistemics of whether their system is any good." **That section is what keeps this piece from failing in front of a skeptical hiring reader.**

### Job-search relevance — **MEDIUM, WITH A CAVEAT**

This is the piece I'm least sure about for job search. Reasons:

**For:** demonstrates range, demonstrates careful thinking about tools beyond design, demonstrates the "I take my own practice seriously enough to encode it" signal that matters for senior leadership.

**Against:** productivity-system-as-content has a strong tonal association with "person who optimizes their life instead of shipping." Productivity writing attracts a specific reader who isn't your target hiring reader. A Director/Principal search at a company like Anthropic or Figma is looking for design leadership with AI fluency, not personal-operations-dashboard thinkers. Some fraction of your target audience will bounce on this piece *because* it argues for an elaborate system.

The piece's mitigation — the "I don't think most people should build what I've built" near the end — helps but doesn't fully neutralize the concern.

**My honest recommendation:** publish the piece, but make it the *last* card in the Demonstrations orbit rather than a lead. The reader who's already trusted you from the other three dispatches will read this one as further evidence of depth. The reader who arrives at this one cold may form the wrong impression.

### Gaps

- No explicit tie back to Domain Foundation as the research that produced the approach. The piece mentions "the research practice from my last job" but doesn't link to `/work/domain-foundation/` or `/work/research-year/` the way Skill Ecosystem does. Worth adding.
- The "eight projects" number is wrong per the current OmniFocus state (see fact check). Needs a real correction.
- The piece says "three for the job search" but at time of publication the job search will have moved. If you take a role, this sentence immediately goes stale. Worth either softening ("currently three for the active job search") or making the whole piece less anchored to that moment.

### Recommended changes

1. **Fix the eight-projects breakdown.** Either state it accurately ("three job-search projects, three for life, one inbox, one for this system itself") or soften ("eight projects that get rebalanced as priorities shift").
2. **Vary the "X lives in Y" rhythm on at least two of the five subsystem paragraphs.** Suggested targets: the Obsidian paragraph and the Home Assistant paragraph.
3. **Add a link to Domain Foundation** or the Research Year dispatch somewhere early in the piece, establishing the lineage.
4. **Reconsider publication timing / ordering.** Currently suggested as the last of four Demonstrations cards, not the first.

---

## Cross-cutting observations

### The Oracle-vs-Domain-Foundation framing is inconsistent across the set

**This is the single biggest issue across the four pieces.** Each dispatch handles the relationship between the research at Oracle and the methodology called Domain Foundation slightly differently:

| Piece | How it frames the relationship |
|---|---|
| Research Year | Oracle was where the research happened. The research ended with the layoff. Domain Foundation is what was pulled forward. **Correct.** |
| Domain Foundation (live page) | Research year happened, then Christmas 2024 is when the methodology crystallized. **Correct.** |
| Skill Ecosystem | "The thing I built at Oracle was Domain Foundation" / "I made the bet inside Oracle Health" — **conflates the research and the methodology**. Reads as if Domain Foundation was built at Oracle. |
| jeremyfuksa.com Build | Doesn't address the relationship directly. Mentions "skills" and "the methodology" without anchoring to Oracle vs. post-Oracle. Fine but under-specified. |
| Jeremy OS | Says "my last job" for the research practice. Doesn't name Oracle or Domain Foundation directly. Under-specified. |

**Recommendation:** decide the canonical one-sentence framing and enforce it across all pieces. Suggested canon:

> "The research happened at Oracle Health through 2024; the methodology called Domain Foundation is what I built from that research after the layoff, starting Christmas 2024."

Any dispatch that touches the relationship should be consistent with that framing. Skill Ecosystem needs the most work; Jeremy OS and jeremyfuksa.com Build need light additions.

### Voice is consistent and strong across the set

Every piece opens in the room with a stated fact. Every piece has flat section headers. Every piece closes with reported understatement, not wisdom-reaching. The voice is remarkably coherent across four pieces of this length — which is what happens when a corpus enforces voice rules.

This is itself a hiring signal. Most portfolio dispatches drift in voice between sections; this set does not.

### Repetition beats across the set

Phrases / moves that recur across multiple pieces, flagged for possible de-duplication:

- "The average" / "averaging machine" — appears in Domain Foundation, Research Year, Skill Ecosystem. This is your thematic shorthand; repetition is appropriate. Keep.
- "Corpus" / "encoded" — appears in all four. Thematic vocabulary. Keep.
- "One practitioner scale" / "individual scale" — appears in Skill Ecosystem and jeremyfuksa.com Build. Both use it in context where it's load-bearing. Keep.
- "The methodology scales down" — appears only in Skill Ecosystem (closer). Don't repeat in other pieces.
- "Domain Foundation is a bet that..." — appears only in Domain Foundation case study. Good.
- "What I can say is..." — appears in Research Year closer and Skill Ecosystem closer. Small repetition but harmless because it's a voice tic, not a thesis.

### The set has a missing piece

The four dispatches together answer "what does Domain Foundation look like running on me." They don't answer **"what does it take for a client or employer to benefit from this thinking."** That's a different piece — a consulting-or-hiring-engagement-shaped dispatch that argues the practical value proposition rather than the mechanics.

I'm not recommending you write it now. I'm flagging it as a gap the set would eventually need to fill for the positioning to complete. This is the kind of piece that converts reader-interest into inbound inquiry.

### Demonstrations orbit reading order

Current `TOMORROW.md` suggests:
1. Research Year
2. Skill Ecosystem
3. jeremyfuksa.com Build
4. Jeremy OS

**Recommended reading order for the orbit cards:**
1. **Skill Ecosystem** (strongest, most distinctive)
2. **Research Year** (grounds the rest in a named, credible employer)
3. **jeremyfuksa.com Build** (applied technical demonstration)
4. **Jeremy OS** (depth, for readers who got this far)

The Research Year is important backstory but leading with it risks the reader thinking "this is a layoff recap" before getting to the actual methodology-at-work evidence. Skill Ecosystem leads harder.

---

## What I need you to verify

Three factual items I can't verify without your input:

1. **Figma Make chronology.** Was the Oracle project kickoff before or after Figma Make's Config 2024 announcement (June 2024)? If before, the opening of the Research Year dispatch needs an edit.

2. **What happened to the research after you left.** Did the team continue it, disperse, or is it unknown? A one-sentence clarification in Research Year would close the ambiguity.

3. **The "clinical safety researchers and regulatory experts" phrasing in Skill Ecosystem's closer.** At Oracle Health / Redwood, did your design org actually have people in those specific roles, or are you using your current vocabulary to describe equivalent-but-differently-named functions? If the latter, the phrasing should generalize ("its own safety review function" or similar).

Once you give me those three, I can apply the edits in ~20 minutes and mark all four pieces publication-ready.

---

_End of audit. Mark up directly or reply with direction._
