# Skill Ecosystem — Pre-Publication Audit

**Purpose:** Assess the 37-skill corpus against the Domain Foundation thesis (encoded institutional expertise, retrievable, owned by the role that produces it) before writing the public Skill Ecosystem dispatch. Identify what's publication-grade, what needs refinement, what should be merged, and what should be cut.

**Audit date:** 2026-04-21
**Auditor:** Claude Code, reading all SKILL.md files in `~/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/.../skills/`

---

## Executive summary

- **37 skills total.** 8 are stock Anthropic/Cowork utilities (not Jeremy's IP — out of scope for the dispatch). **29 are Jeremy-authored.**
- **The corpus is strong.** Most Jeremy-authored skills are genuinely institutional-expertise artifacts, not recipe cards. Several are load-bearing in a way that matches the Domain Foundation thesis exactly — they encode *why*, not just *what*.
- **Two immediate quality wins** before publication:
  1. Resolve the `cli-expert` ↔ `unix-expert` overlap. They're close enough in scope to confuse the corpus's story.
  2. Decide what `documentation-expert` and `doc-coauthoring` are each *for* — one is a stance skill, the other a workflow skill. Right now the triggering descriptions blur them.
- **Two gaps worth naming:** there's no skill for the ghost-theme build practice itself (this site), and no skill for the photography/printmaking adjacent work that shows up in the Workshop spec but has no encoding.
- **Recommended dispatch shortlist:** ~12 skills. Detailed shortlist and justification at the bottom.

---

## Scope and provenance

### Excluded — stock Anthropic / Cowork utilities (8)

Not Jeremy's IP; out of scope for the public dispatch even though they live in the same corpus:

| Skill | Why excluded |
|---|---|
| `canvas-design` | Stock Anthropic design-philosophy generator. License frontmatter ("Complete terms in LICENSE.txt"). |
| `mcp-builder` | Stock Anthropic MCP server builder. License frontmatter. |
| `skill-creator` | Stock Anthropic skill authoring tool. References `eval-viewer/generate_review.py`. |
| `theme-factory` | Stock Anthropic artifact theming toolkit. 10 preset themes. License frontmatter. |
| `web-artifacts-builder` | Stock Anthropic web artifact scaffolding. License frontmatter. |
| `schedule` | Stock Claude utility for creating scheduled tasks. Generic. |
| `setup-cowork` | Stock Cowork onboarding. "Help the user get Cowork configured for their work." |
| `consolidate-memory` | Stock memory-management utility. Generic. |
| (`docx`, `pptx`, `xlsx`, `pdf`) | Stock Anthropic file handlers. Previously excluded. |

### In scope — Jeremy-authored (29)

Everything that follows is one of Jeremy's skills.

---

## The 29 Jeremy-authored skills — per-skill assessment

For each skill: one-line summary, quality score (🟢 publication-ready / 🟡 needs refinement / 🔴 cut or merge), and notes.

### Voice, writing, and creative

#### 🟢 `jeremy-voice` (21KB + references/case-studies.md)
**What it does:** Defines the voice for all prose under Jeremy's byline — blog posts, portfolio case studies, emails, etc. Includes a "meta-rule" (reporting, not thesizing), anti-patterns catalog, calibration references to live posts, per-medium extensions.

**Assessment:** The most mature skill in the corpus. This is what "encoded institutional expertise" looks like. The meta-rule is load-bearing; the anti-patterns catalog is specific enough to actually catch drift; the references/ file (case-studies.md) shows the corpus-extension pattern in action.

**Refinement before publication:** None needed. This is the skill to feature as the flagship example.

**One note:** The "Post Deliverables" section at the bottom (SEO description, thumbnail, alt text) is blog-post-specific and interrupts the flow of the core voice rules. Consider moving to its own `references/blog-deliverables.md` file, matching the pattern already used for `references/case-studies.md`. Structural tidy, not a content problem.

#### 🟢 `jeremys-workshop` (6KB + references/workshop-spec.md)
**What it does:** Defines a persistent fictional creative space (Crossroads district KC workshop) used as the recurring setting for all Cocktail Napkin blog thumbnails. Ensures visual consistency across AI-generated images.

**Assessment:** A genuinely novel skill move — using a skill not to govern text or code but to govern visual output across time. The workshop spec is load-bearing world-building that makes every generated thumbnail recognizable as "that room again." Strongest demonstration of the references/ pattern being used for its intended purpose (corpus material distinct from meta-rules).

**Refinement before publication:** None needed. The skill is disciplined about its own scope ("This file is the usage guide. The spec is the source of truth.") which is exactly the right architectural move.

#### 🟢 `content-strategist` (4KB)
**What it does:** General-purpose audience-first content thinking — the four narrative jobs, voice vs. tone, cognitive economy, content review protocol.

**Assessment:** Clean, senior-level thinking. Doesn't overlap with `jeremy-voice` because this one is a stance skill for content generally (useful when writing in *someone else's* voice, for clients), whereas `jeremy-voice` is specifically Jeremy's.

**Refinement before publication:** One tightening pass — the "Clarity Standards" section reads slightly generic compared to the rest. "Cut adjectives that don't load-bear" is the good specific line in that section; the surrounding bullets (active voice, specificity over vagueness) are standard. Not broken, just less distinctive than the rest of the skill.

#### 🟢 `songwriting` (7KB)
**What it does:** Oklahoma Red Dirt / Americana songwriting practice. Archaeological framing ("the song already exists — excavate, don't generate"), cultural specificity (named venues, artists, geographic precision), formatting-as-musical-notation rule.

**Assessment:** Unusually good. The archaeological framing is the right load-bearing claim for collaborative creative work with AI — it's the songwriting version of "reporting, not thesizing" from `jeremy-voice`. The specificity about Wormy Dog, nicotine lights, Stoney LaRue is exactly the kind of institutional knowledge that converts an averaging model into something that reflects a specific practitioner.

**Refinement before publication:** None needed for quality. For the dispatch: flag this as proof that the methodology scales beyond enterprise design work into creative practice.

---

### AI / workflow / knowledge

#### 🟢 `moonbird-oracle` (9KB)
**What it does:** Governs work on Project Moonbird (the Oracle research on AI-partnered UX methodology in healthcare). Includes the validation stack, role evolution framework, velocity paradox, "who thrives vs. who struggles," filing rules, anti-bloat guardrail.

**Assessment:** This is Domain Foundation's origin document living as a skill. The frameworks here (Validation Stack, Role Inversion, Velocity Paradox) are the pre-distillation versions of the ideas the case study works with.

**Publication caveat:** This skill is the one where the seven-frameworks narrative came from. Per the updated handoff, the external-facing framing collapsed those into a single methodology (Domain Foundation). This skill, as it stands, still reads like a live research project — which is true internally. **The dispatch needs to acknowledge this mismatch gracefully:** the Moonbird skill is the internal research vault; the Domain Foundation case study is the external distillation. Both are legitimate. Don't pretend the skill is the public thing.

**Refinement:** Minor. The "Exploration Agenda" section with "must explore / should explore / could explore" is now stale — those decisions landed during the layoff. Consider either updating or moving to an archive section noting the research phase ended.

#### 🟡 `obsidian-pkm` (7KB)
**What it does:** Describes the actual structure of Jeremy's Obsidian vault — four zones (Moonbird / Tism / Songwriting / Agents), where new content goes, frontmatter schema.

**Assessment:** Solid. Useful. Specific.

**Refinement before publication:** Two small issues.
1. The vault structure references the `Moonbird/Library/Meta/Project Instructions.md` etc. as required reading — worth verifying those files still exist and say what the skill claims (i.e., the Moonbird vault is still live after the layoff). Stale cross-reference risk.
2. The **🧠 Tism** zone name uses an emoji in the folder name that may not survive all text encodings. If this is worth preserving as personal identity, keep it; if it's going to cause tool breakage over time, consider a regular name with a frontmatter tag for the identity signal. (Low priority — not a skill-level issue.)

#### 🟡 `obsidian-cli` (14KB)
**What it does:** Comprehensive reference for the official Obsidian CLI (v1.12+). Commands, syntax, scripting patterns, gotchas.

**Assessment:** Well-structured, genuinely useful. But **this one is the closest in the corpus to "what could be derived from docs"** — a lot of it is command syntax and flag references that Obsidian themselves publish. The value-add over reading Obsidian's docs is the *scripting patterns* and *gotchas* sections.

**Refinement before publication:** Compress the pure command reference (a page of `obsidian verb thing=value` examples) into a tighter "cheat sheet" section, and expand the patterns and gotchas. The patterns are the institutional-knowledge half; the flag reference is just re-encoded documentation.

This is the weakest fit for the Domain Foundation thesis because it under-indexes on encoded expertise relative to content you could get from vendor docs. Still publication-grade; just not a leading example.

#### 🟢 `omnifocus-expert` (8KB)
**What it does:** Governs all OmniFocus interactions. Includes Jeremy's actual project structure (JS — Foundation / Presence / Pipeline / etc.), tags, daily review workflow, weekly review workflow, capture conventions, end-of-session prompt, priority rules ("Content Engine deferred until May 15 2026").

**Assessment:** Excellent. This is encoded institutional knowledge at practitioner scale. The specifics — named projects, specific tags, deferred dates, "flag = commitment not wish" — are what make it real. A generic task-management skill would be worthless; this one works because it knows what system it's governing.

**Refinement before publication:** The "Content Engine deferred until May 15 2026" date is date-sensitive and will go stale. Consider adding a dated marker (e.g. "As of 2026-04-21: Content Engine deferred until 2026-05-15") or a reminder to update. Not fatal — memory file already tracks the May 15 date — but the skill claims "Don't surface Content Engine tasks before May 15 2026" which becomes a stale instruction after May 15.

#### 🟢 `n8n-workflow-designer` (7KB)
**What it does:** n8n automation platform — data model, triggers, core nodes, expressions, workflow patterns (daily brief, webhook-to-action, polling), error handling, idempotency, Jeremy's self-hosted considerations.

**Assessment:** Strong. The "This array-of-items model is the most important thing to internalize" call-out is load-bearing — it's the single thing that makes n8n make sense, and it's the thing every tutorial buries.

**Refinement before publication:** None needed. The workflow patterns section ties the skill to Jeremy's actual automation backlog (AI news curator, weekly review, etc.) which makes it specific to his practice, not generic.

#### 🔴 → merge candidate: `cli-expert` + `unix-expert`
**What `cli-expert` does (5KB):** Building, debugging, designing CLIs. TTY detection, XDG compliance, argument architecture, distribution (Homebrew, npm, etc.), shell completions.

**What `unix-expert` does (5KB):** Shell scripting, sysadmin, Jeremy's platforms (macOS + Ubuntu Server), BSD vs GNU differences, observability hierarchy.

**Assessment:** These are actually different — `cli-expert` is about **building tools users run**, `unix-expert` is about **operating a Unix system**. But the descriptions overlap enough ("shell scripting" appears in both trigger lists) that Claude might invoke the wrong one.

**Recommendation:** Keep both, but sharpen the trigger descriptions so the split is unambiguous:
- `cli-expert` triggers on: "build a CLI tool", "design a command-line interface", "Homebrew distribution", anything where the output is a published tool.
- `unix-expert` triggers on: "debug this shell script", "sysadmin on my Mac Pro", "why is this permission wrong", anything where the output is fixing/administering an existing system.

Move "shell scripting" trigger out of `cli-expert` (it belongs to `unix-expert`). Clarifies the split without losing either skill's content.

#### 🔴 → clarify scope: `documentation-expert` + `doc-coauthoring`
**What `documentation-expert` does (5KB):** Diátaxis framework (tutorial / how-to / reference / explanation), time-to-dopamine metric, cognitive economy, audit/architect/writer modes.

**What `doc-coauthoring` does (16KB):** A specific three-stage workflow (Context Gathering → Refinement & Structure → Reader Testing) for collaboratively writing a doc with the user in real-time.

**Assessment:** Legitimately different — one is a philosophical stance on what good documentation is, the other is a procedural workflow for co-writing a doc. But both descriptions trigger on "write docs" phrasings.

**Recommendation:** Keep both. Rewrite `doc-coauthoring`'s description to lead with "Guide the user through a structured three-stage co-authoring process for..." — emphasize that this is a **process skill**, not a stance skill. And add to `documentation-expert`'s description: "For collaborative co-writing workflows, use `doc-coauthoring` instead." Cross-references in both directions.

#### 🟢 `typescript-node` (8KB)
**What it does:** TypeScript and Node.js development — type system fundamentals, async patterns, module architecture, build tooling, Electron main/renderer, IPC.

**Assessment:** Solid technical reference. Less distinctive than the "practice" skills but appropriate for a language/runtime skill.

**Refinement before publication:** None needed. Worth featuring in the dispatch as proof that the ecosystem includes deep technical skills alongside craft skills — the point being that the same encoding methodology works across domains.

#### 🟢 `docker-expert` (4KB)
**What it does:** Dockerfile / compose patterns, security, multi-stage builds, debugging.

**Assessment:** Tight and opinionated. "Layer caching is your primary optimization tool" as the lede is the right kind of load-bearing claim.

**Refinement before publication:** None needed.

---

### Design / UX

#### 🟢 `campfire-css` (8KB + references/tokens.md)
**What it does:** Enforces the Campfire Design System as single source of truth for CSS / UI / frontend work. Mandatory rules (tokens only, no hardcoded values), component primitives, prohibited patterns, Figma Make prompt generation pointer.

**Assessment:** This is the design-system version of `jeremy-voice` — it's the rulebook that makes automated generation safe. The prohibited-patterns table ("Why / Alternative") is the specific thing that prevents AI from drifting off-system. Very strong.

**Refinement before publication:** None needed. But: verify that `references/tokens.md` exists and is up-to-date with Campfire 0.2.0 — the skill claims it's there but I didn't read it.

#### 🟢 `figma-expert` (5KB)
**What it does:** Figma architecture, component system design, variables/tokens, Code Connect, metadata injection, audit protocol.

**Assessment:** Good. Covers advanced Figma use beyond basic drawing.

**Refinement:** Consider cross-linking more explicitly to `figma-make-prompt-engineer` — the skill mentions it but doesn't set up a clear handoff.

#### 🟢 `figma-make-prompt-engineer` (5KB)
**What it does:** Converting a spec into a Figma Make (AI generation) prompt. The three-layer formula (Scope / Specifics / Style), workflow, prompt structure template.

**Assessment:** Tightly scoped, clearly different from `figma-expert`. The "what Figma Make can/can't do" section is load-bearing expectation-management.

**Refinement before publication:** None needed.

#### 🟡 `desktop-app-design-expert` (4KB) and `mobile-app-design-expert` (5KB)
**What they do:** Platform-specific UX patterns — HIG/Fluent for desktop, iOS HIG/Material for mobile.

**Assessment:** Both are solid platform-native thinking skills. They read slightly more as general senior-designer knowledge than as uniquely-Jeremy encoded expertise, though.

**Refinement before publication:** Consider whether these are demonstrating the *methodology* or just being good platform-design references. If the dispatch needs to show range across domains, keep both. If it needs to show depth, these might not lead.

**One note:** Neither skill actually names specific products Jeremy has worked on (unlike e.g. `omnifocus-expert` naming his project structure). They're more "generic senior designer thinking" than "Jeremy's specific practice." That's legitimate — not every skill needs to be personally indexed — but it's worth knowing.

#### 🟡 `product-council` (10KB)
**What it does:** A 5-phase pipeline (Soul → Innovation → Design → Critique → Blueprint) for turning a vague idea into a build-ready spec. Each phase has a named deliverable.

**Assessment:** A real, named methodology. Strong. The Belief System (Enemy / Ritual / Totem) framing is distinctive and useful.

**Refinement before publication:** The "Specialist Bench" section at the end — invoking `cli-expert`, `docker-expert`, etc. after the blueprint — is the right architectural move (skills composing with other skills) but the specific list will drift as the corpus evolves. Consider a lighter-weight pointer rather than a named list.

---

### Radio / physical world / home

#### 🟢 `meshtastic-expert` (5KB)
**What it does:** Meshtastic LoRa mesh — hardware reference, RF physics, firmware config, triage protocol, Python CLI reference.

**Assessment:** Solid technical practitioner knowledge. The "Triage Protocol" section (4 questions to establish context, 5 categories of common issues) is the institutional-expertise half.

**Refinement before publication:** None needed.

#### 🟢 `kc-topography-analyst` (5KB)
**What it does:** Kansas City terrain analysis for Meshtastic node placement. Three topographic zones, strategic high-point hierarchy, propagation principles, confidence/verification standards.

**Assessment:** This is the skill that most clearly proves the thesis **scales to personal-practitioner level**. It is ridiculously specific — "Penn Valley Park / Hospital Hill area: downtown-adjacent, elevated, overlooking both rivers" is not something you'd find in any general resource. It's Jeremy's knowledge of his city applied to his hobby. If the dispatch argues that the methodology works at individual scale, this is exhibit A.

**Refinement before publication:** None needed. This is as good as it gets at the "encoded local expertise" end of the spectrum.

#### 🟢 `sstv-expert` (5KB)
**What it does:** Slow Scan Television — frequency mapping, VIS decoding, mode reference, software architecture for SSTV apps.

**Assessment:** Tight technical reference with just enough Jeremy-specific context (the SSTeVe app) to tie it to practice.

**Refinement before publication:** Cross-link to the `obsidian-pkm` mention of SSTeVe — the two skills know about each other but don't link to each other. Minor.

#### 🟢 `home-assistant-expert` (5KB)
**What it does:** Home Assistant config on Jeremy's specific stack (Mac Pro / Ubuntu / Docker Container deployment / UniFi / Wyoming voice). Safety, local control priority, WAF (Wife/Household Acceptance Factor), automation patterns.

**Assessment:** The specificity of "2013 Mac Pro running Ubuntu Server, Home Assistant Container (not Supervised/OS)" matters — it shapes every recommendation (no add-on store, manual orchestration, etc.). Another strong exhibit of "encoded local expertise."

**Refinement before publication:** None needed.

---

## Redundancy / overlap summary

Three overlaps flagged above, with recommended actions:

1. **`cli-expert` ↔ `unix-expert`** — sharpen trigger descriptions to separate "build a CLI tool" from "administer a Unix system." Move "shell scripting" out of `cli-expert`'s triggers.
2. **`documentation-expert` ↔ `doc-coauthoring`** — rewrite `doc-coauthoring`'s description to emphasize it's a **process skill**. Add cross-references in both directions.
3. **`figma-expert` ↔ `figma-make-prompt-engineer`** — strengthen the handoff between them; they're clearly different scopes but the boundary could be made explicit.

---

## Gaps — what's missing

The corpus is strong but not complete. Two gaps visible from the outside:

1. **No skill for the Ghost / The Cocktail Napkin theme build itself.** This is the site we're deploying to. `campfire-css` covers general Campfire work, but the specific Ghost 6 theme architecture ("static-first" workflow, `custom-*.hbs` templates, `dev/deploy-theme.mjs`, version-bump-before-package rule) lives in `CLAUDE.md` and nowhere else. Making a `cocktail-napkin-theme` skill would encode that institutional knowledge the same way `omnifocus-expert` encodes the task-system knowledge.

2. **No skill for photography / printmaking / physical-craft workflow.** The Workshop spec in `jeremys-workshop` names the woodworking zone, the bar, the music studio — but the actual creative practices that happen in those zones aren't encoded. The songwriting one is; the others aren't. If the dispatch argues for end-to-end encoding of a practitioner's practice, the honest observation is that the photography half is gap.

Optional to fix before the dispatch. Calling them out in the dispatch itself ("here's what I've encoded, here's what I haven't yet, here's why") would actually strengthen the credibility of the piece — nobody believes a corpus that claims to be complete.

---

## Cross-cutting quality observations

Things that are true across most or all of the Jeremy-authored skills, worth naming:

**The good:**
- Trigger descriptions are unusually thorough and precise. Most skills list 8–15 specific trigger phrases rather than generic ones. This is expensive to write and the reason triggering feels reliable.
- Most skills use the Response Structure / Output Format pattern — a numbered section at the end listing what the response should cover. This makes the skill's output predictable.
- The "X vs. Y" distinctions are usually well-handled. (Campfire vs raw Tailwind, GNU vs BSD, Scottie vs Martin modes.)

**The patterns that could travel further:**
- Only 4 skills use the `references/` subfolder pattern (`campfire-css`, `jeremy-voice`, `jeremys-workshop`, `skill-creator`). Several other skills would benefit from the same split — specifically `obsidian-cli` (the command reference would live better as `references/commands.md`), `moonbird-oracle` (the tag taxonomy and frontmatter schemas could be `references/vault-schema.md`), and `omnifocus-expert` (the project structure and tag inventory could be `references/system-architecture.md`). This is a structural improvement opportunity across the corpus.

**The honest gap:**
- The corpus reflects what Jeremy's been working on heavily (voice, design systems, healthcare UX, radio, KC-specific stuff, OmniFocus, Obsidian). It under-reflects: photography, printmaking, physical craft, and his broader design portfolio (non-Redwood work). That's fine — skills are built in response to recurring needs. Worth naming in the dispatch so the reader doesn't assume the corpus claims to be comprehensive.

---

## Recommended dispatch shortlist (12 skills)

In descending order of "load-bearing for the Domain Foundation thesis":

1. **`jeremy-voice`** — flagship. The meta-rule + anti-patterns + calibration references pattern is the mature version of what every skill is reaching for.
2. **`campfire-css`** — the design-system analogue: encoded design-system enforcement for automated generation.
3. **`omnifocus-expert`** — proof that the methodology encodes operational knowledge (project structure, priority rules, deferred dates) and not just craft knowledge.
4. **`kc-topography-analyst`** — proof that the methodology scales down to individual-local-expertise. "Penn Valley Park / Hospital Hill" is the kind of specific that an averaging model can't reach.
5. **`jeremys-workshop`** — proof that the methodology extends to governing *visual* output across time, not just text and code. Novel.
6. **`songwriting`** — proof that the methodology works in creative practice (not just technical practice). The archaeological framing mirrors `jeremy-voice`'s reporting-not-thesizing.
7. **`moonbird-oracle`** — the research skill that Domain Foundation distilled from. Exhibit, with the caveat about mismatched framing (internal research vs. external distillation).
8. **`home-assistant-expert`** — another "encoded personal stack" skill, different domain. Shows range.
9. **`meshtastic-expert`** + 10. **`sstv-expert`** — the radio pair. Evidence that the methodology covers hobby practice at technical depth. Pair with `kc-topography-analyst` for the "local RF" story.
11. **`n8n-workflow-designer`** — the automation backbone. Ties several other skills together (workflows that touch OmniFocus, Obsidian, daily brief patterns).
12. **`product-council`** — the most explicitly "named methodology" skill. Belief System / Innovation Brief / etc. is a structural echo of Domain Foundation's four layers.

**Features that would strengthen any skill-specific writeup:**
- The `references/` decomposition pattern (shown as the architectural move)
- Trigger-description design as a real discipline (not just prose)
- Cross-skill composition (e.g., `figma-make-prompt-engineer` invoked by `campfire-css`)

---

## Final recommendations before dispatch drafting

**Do these first (small, fast):**
1. Decide fate of the `cli-expert` ↔ `unix-expert` overlap (recommended: sharpen trigger descriptions).
2. Add process-vs-stance clarification to `doc-coauthoring` description.
3. Update `omnifocus-expert` to handle the May 15 2026 Content Engine deferral gracefully (it's going to go stale in ~3 weeks).

**Consider these (medium effort):**
4. Fold the two `references/` opportunities mentioned above (`obsidian-cli` command reference, `omnifocus-expert` system architecture) into proper reference files. The architectural pattern is part of what the dispatch will argue, so showing more than 4/29 skills using it strengthens the case.

**Don't need to do before the dispatch, but worth noting to the reader in the dispatch:**
5. The photography / printmaking / physical-craft gap. Honest naming of the gap builds credibility.

**Separately:** cut or archive the eight stock Anthropic / Cowork skills from the set, or at least clearly partition them so the "my ecosystem" claim doesn't accidentally include them. Current layout mixes them in the same directory.

---

_End of audit. Mark up directly in this file or reply with direction._
