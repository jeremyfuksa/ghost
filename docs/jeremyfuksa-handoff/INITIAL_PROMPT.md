# Initial Prompt for Claude Code

_Paste this as your first message to Claude Code after placing the handoff files in your project directory._

---

I'm handing this project off from a long Claude web conversation. Before you do anything, read `HANDOFF.md` in the project root — it contains full context on what we're building, what's already done, the architecture, constraints, voice rules, and the next task queue.

The immediate work is the `/work/` rebuild on jeremyfuksa.com. New theme template and CSS are already drafted and waiting in the handoff bundle. Start with Task #1 in `HANDOFF.md` (deploy the `/work/` rebuild via SSH to the DigitalOcean droplet). Before you run anything on the server, show me the deploy plan and the exact commands you intend to run. I'll approve, then you execute.

Use the `jeremy-voice` skill for any prose in my voice. Use the `campfire-css` skill for any frontend code. Use only existing Campfire design tokens — do not invent new CSS variables. For task capture, use the `omnifocus-expert` skill proactively whenever we identify new work.

Working style: propose → execute → report. Flag confidence level when uncertain. Don't Socratic-dialogue every step. End responses declaratively.

When you've read the handoff, confirm with: (a) the first next task you plan to tackle, (b) anything in `HANDOFF.md` that's unclear or seems wrong, and (c) one question whose answer would most reduce your uncertainty before you start.
