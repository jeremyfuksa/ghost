# Terra Design System

**Role:** UX Designer → UX Design Manager
**Organization:** Cerner / Oracle Health
**Timeline:** 2018–2024
**Scope:** Open-source React component library serving hundreds of teams across enterprise healthcare.

**Sidebar stats:** 80+ React components · 200+ icons · 1,500 healthcare orgs · 195 countries
**Links:** [terra-core](https://github.com/cerner/terra-core) · [terra-framework](https://github.com/cerner/terra-framework)

---

## Overview

Terra is Cerner's open-source design system — the React component library that provides the UI foundation for the Millennium platform. I joined the Terra team three months after I started at Cerner, and I was one of two UX designers on it who could work directly in the React codebase alongside the engineers. I stayed in that role for roughly three and a half years.

## Why the role existed

Healthcare UI components don't get to be approximately right. A focus-trap bug in an alert component propagates across every product that consumes it. An icon that fails contrast requirements shows up in operating rooms and emergency departments. Every consuming team inherits whatever actually ships, whether or not it matches the standards.

So the architecture's promise — accessible, internationalized, responsive components built once, consumed everywhere — only works if the components faithfully implement those standards. Catching the places they don't requires someone who can read both the standards document and the pull request and push back on the difference. That was the job.

## What the work actually looked like

Most days I was in the Terra monorepo reading pull requests. Not rubber-stamping them. Actually reading them — walking through the interaction logic, checking focus management against the standards we'd published, flagging the places where an engineer's reasonable implementation had quietly diverged from the intended behavior. When something was wrong in a way that needed both design judgment and React fluency to resolve, I was one of two designers on the team who could fix it in code rather than throw it back over the wall with a spec.

Alongside that, I owned the icon library — a dedicated Git repository the engineering team consumed into the component system, maintained end-to-end from design asset to published package. And I was the design advisor on the construction of every new component that came through, which meant a lot of arguing about tab order, screen reader announcements, and which interaction patterns the design standards actually required versus which ones had been convenient to document.

The standards we were enforcing weren't small. The system was built on 125+ design standards and 150+ accessibility guidelines targeting WCAG 2.1 AA. My job was making sure what shipped actually honored them.

## What I learned there

A design system isn't a components problem. It's an interpretation problem. The gap between what the standard says and what the engineer built in good faith is where accessibility actually dies, and closing that gap requires someone who can read the diff — not someone who writes the spec harder.

The other thing I learned: being the designer who works in the code changes what design means as a job. I spent three and a half years not producing Figma files that anyone cared about, and the work mattered more than most of the Figma files I'd produced before that.

## What happened next

In mid-2022, a few months before Oracle completed its $28.3 billion acquisition of Cerner, I moved from this hands-in-code IC role into design management — eventually leading a team of up to 12 across the US and India through the organizational transition.

The leadership story is its own case study. But this is where it started: in the gap between what was designed and what was built, making sure the intent survived.
