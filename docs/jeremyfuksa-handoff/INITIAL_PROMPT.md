# Initial Prompt for Claude Code

Paste the block below into your first Claude Code turn.

---

```
I'm handing you a staged rebuild of the /work/ page on jeremyfuksa.com — new Ghost theme template, new CSS, new copy — prepared in a web conversation and zipped into the bundle in this directory.

Before you do anything, read the following in order:

1. CLAUDE.md in the theme repo root. This is the source of truth for the deploy workflow, versioning, and any existing conventions. If anything in the handoff contradicts CLAUDE.md, CLAUDE.md wins.
2. HANDOFF.md in this bundle. It explains the project, the architecture (three orbits with Methodology as singular — Domain Foundation is the methodology, NOT one of seven frameworks), the critical constraints, and the prioritized task list with blockers.
3. The jeremy-voice SKILL.md before writing or revising any prose in my voice.
4. The campfire-css SKILL.md before writing or reviewing any frontend code on this site.

The proposed custom-work.hbs is a diff target, not a drop-in replacement. Diff it against the existing theme/custom-work.hbs and preserve any {{#if}} conditional blocks in the live file that allow editing via Ghost Admin without a redeploy. The proposal preserves custom_excerpt, feature_image, and content fallbacks; if the live file has more, keep them.

The work-orbit.css rules belong grouped with the existing .work-* rules in components.css, before the consolidated mobile @media block. Don't cat >> to end-of-file — that would land after the @media block.

Use the omnifocus-expert skill any time something enters or leaves my task system. Capture proactively.

Then do three things:
1. Confirm the next task you're ready to execute (Task 1 in HANDOFF.md — deploy the /work/ rebuild per CLAUDE.md's documented workflow).
2. List any details that are unclear or you'd want to verify with me at the terminal before running commands. Specifically: what existing conditional blocks in theme/custom-work.hbs need preserving, where exactly the CSS insertion point in components.css is, and whether the deploy workflow in CLAUDE.md has changed since this handoff was written.
3. Ask me one question — the one with the highest uncertainty cost.

Don't touch anything on the server until I've confirmed your deploy plan.
```

---

## Notes on this prompt

- First instruction is read CLAUDE.md, so the repo's documented workflow takes precedence over anything stale in the handoff.
- It names the diff-don't-replace rule for `custom-work.hbs` and the CSS placement rule explicitly, since those were the two places the handoff most easily trips up a literal-minded execution.
- The "one question with the highest uncertainty cost" framing encourages honest calibration rather than a polite checklist.
- It explicitly flags the "three orbits with Methodology as singular" point so the earlier seven-frameworks misread isn't re-inherited from any context.
