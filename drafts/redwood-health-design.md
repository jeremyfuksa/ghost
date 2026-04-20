# Two Components That Didn't Ship

**Role:** UX Designer, Redwood Health Design team
**Organization:** Oracle Health (Redwood Design System)
**Timeline:** June 2024 – March 2026
**Scope:** Health-specific component authoring on Oracle's Redwood design system.
**Links:** [Redwood design system](https://redwood.oracle.com/)

---

## Overview

After the Redwood theme for Terra was shelved, I moved onto the [Redwood](https://redwood.oracle.com/) design team — specifically the Health Design team, a six-person group inside a roughly 100-person system organization. Redwood is Oracle's cross-product design system; the Health Design team existed because generic Redwood components couldn't carry the clinical requirements Oracle Health's apps needed.

The job didn't resemble Terra at all. No code. No pull request reviews. I worked in Figma and handed off specs to engineering. We met with the engineers on a regular cadence to see how the designs were translating into code, so I could see what was shipping — but I no longer had the access to go elbows-deep and fix things in the codebase myself. The work was upstream of implementation in a way it hadn't been in years.

## The shape of the work

The pattern across everything we built was the same: an all-purpose design system can't encode clinical context, so health-specific components have to. What looks like a reasonable product decision in a generalized setting becomes a safety or privacy liability in a clinical one.

I shipped three main components: a Page Summary for medical summaries, with an API to consume an AI-generated rich-text summary of a patient record; an Object ID component carrying the patient identity surface (date of birth, age, birth sex, self-reported pronouns, health ID); and a health-aware timestamp for patient age — hours for neonates, days for young infants, weeks and months as the child grew, years beyond that.

But the decisions I remember best were the ones about what to stop building.

## The name truncator

Patient names are harder than they look. Patient name display is a safety-critical surface — the [Joint Commission](https://www.jointcommission.org/standards/standard-faqs/home-care/national-patient-safety-goals-npsg/000001545/) in the US, and patient-safety frameworks across the UK, EU, Canada, and Australia all treat it that way. The name on a patient header is one of the two identifiers a clinician uses to confirm they're treating the right person. International patients frequently have multi-part names — three, four, five tokens, handled natively by [FHIR's HumanName element](https://build.fhir.org/datatypes.html#HumanName) — and Oracle Health shipped into all of those jurisdictions at once.

We designed a context-aware truncator that reflowed the name intelligently as the viewport changed — preserving the identifying tokens, collapsing the optional ones, adjusting across breakpoints. It was a good piece of design. It solved the problem it was aimed at.

We descoped it because solving that problem created a worse one. A hallway workstation, a bedside tablet, the same patient record — sometimes all within the same minute. A truncator that makes different choices at different breakpoints produces the same patient looking different across the two devices, which is exactly the kind of cross-device friction the two-identifier rule is supposed to guard against. The dumb solution (ellipsis) produced the same output everywhere. The smart solution undermined the consistency that made the name a reliable identifier in the first place. We stopped.

## The pronoun notification

The Object ID component showed self-reported pronouns alongside birth sex. We sketched several concepts for a notification that would flag a mismatch to the provider when intake had captured both. Small feature, straightforward to build.

We designed it. We spent real time on it. And we killed it because we worked through the deployment context and realized the feature could out a patient.

Patients aren't always alone in an exam room. Younger patients may have put their preferred pronouns in without telling a family member who happens to be in the room. A mismatch notification on the provider's screen outs the patient two ways. 

The first is the provider's demeanor — even a clinician who says nothing different will shift how they engage: body language, eye contact, the pause before they speak, how they address the patient. Anyone else in the room can read the shift, even if they can't name it. The second is the screen itself, which is readable to anyone in line of sight — a parent leaning in, a spouse seated beside the patient. Pronoun data stored in a patient's EHR is protected health information, and the patient hasn't consented to a family member seeing it just because the clinic room is small. A feature intended as a small win for provider-patient rapport became a vector for non-consensual disclosure. 

## What I learned there

Most design system work is enforcement. This work was judgment — adding clinical context a general-purpose system couldn't carry, and being willing to say "this shouldn't ship" about features we'd already built.

It's a different skill from Terra. At Terra, my job was closing the gap between what the standard said and what the engineer built. On the Health Design team, my job was closing the gap between what the product decision recommended and what the patient context required.

I missed working in code less than I expected. Upstream work had its own weight, and knowing when to kill a feature you've already built — with the team standing to make the decision stick — turned out to be its own craft.

## What happened next

Two years, two shipped components, two descoped ones, and a handful of sub-components in various states of done. Not a long chapter. A defined one.

In my June 2025 performance review, my top goal for the next year was that whatever I worked on next had to be centered on AI. The Page Summary component had already put me one degree away from the AI work at Oracle Health; the segue was short. In September I got asked to be the designer of the AI design process for Oracle design. Six months later the layoff came.

[The Context Layer](domain-foundation.md) is its own case study. It's where the thread picked up.
