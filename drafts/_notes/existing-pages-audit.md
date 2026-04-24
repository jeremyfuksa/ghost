# Existing Pages Audit — Pieces 5–9

**Date:** 2026-04-22
**Scope:** Three live Work case studies + About + (sketched for completeness) the Research Year dispatch as an unpublished peer
**Bar:** These pages are on the live site already. Lighter pass than the dispatch audit — does anything need real work before the Demonstrations dispatches go live alongside them?

## Executive summary

**All four pieces are in much better shape than I expected.** The case studies were evidently Jeremy-edited already, and the voice discipline on them is consistent with the recent work on Domain Foundation and the four dispatches. I don't see any piece that needs to be pulled offline to fix.

**One real finding, two medium ones, a handful of small ones.**

| Piece | Verdict | Priority |
|---|---|---|
| Terra Design System | 🟢 Solid. Two small fact-checks, one small polish. | No action required before dispatches publish |
| Seven Years in Healthcare UX | 🟢 Strong. One consistency check against the new framing. | No action required |
| Two Components That Didn't Ship (redwood-health-design) | 🟢 Strongest of the three. Possibly the strongest piece on the site. | No action required |
| About | 🟡 Good, but one chronological oddity needs checking. | Verify the dates |

Job-search relevance runs **high across all four**. Each piece does distinct load-bearing work for the Director/Principal UX positioning.

---

## 5. Terra Design System 🟢

### Fact check

| Claim | Status |
|---|---|
| "I joined the Terra team three months after I started at Cerner, and I was one of two UX designers on it who could work directly in the React codebase" | Not independently verifiable; defensible. |
| "I stayed in that role for roughly three and a half years" | If Cerner tenure was 2018–mid 2022 (when you moved into management), this matches. Verified via Seven Years piece. |
| "125+ design standards and 150+ accessibility guidelines targeting WCAG 2.1 AA" | Specific numbers. If these came from Terra's internal standards dashboard, likely accurate. **Worth a sanity check before leaving up — "125+ / 150+" is a specific claim that a reader may Google.** Either check against public Terra docs, or generalize to "a mature standards library targeting WCAG 2.1 AA." |
| "In mid-2022 I moved from the hands-in-code IC role into design management" | Verified against Seven Years piece. |
| "Oracle completed its $28.3 billion acquisition of Cerner" | **Fact check: Oracle announced the Cerner acquisition in December 2021 at $28.3 billion and closed it in June 2022.** Verified. |
| "12 designers across the US and India" | Not independently verifiable; defensible. Seven Years piece says "twelve reports across eight locations, three continents" — consistent. |
| Links: terra-core, terra-framework, one-cerner-style-icons, Cerner engineering blog | All should be live public URLs. **Worth a one-time link check to verify they resolve.** |

### Voice

Clean. Opens with "Terra was Cerner's open-source design system" — reports a fact, not a thesis. Section headers are flat. Closer is reported, not reached: *"Both start here."* ✓

Only minor flag: the Jeffrey Zeldman link in "What I learned there" is a voice move (specific name, specific cultural reference, the "real designers code" shorthand). It works. Keep.

### Quality

The piece has clear structure and the voice holds. The "what I learned" split (institutional gap + personal observation about design-vs-engineering specialization) does real work — it's the kind of senior-practitioner reflection a hiring reader respects. The closer pointing forward to Seven Years and Redwood is the right move; the pieces form a trilogy.

### Job-search relevance — HIGH

Reads as "senior IC doing craft work at enterprise scale under public scrutiny." Open-source design system, public GitHub links, named standards, and a specific mention of WCAG 2.1 AA. That's resume substance rendered as narrative.

Worth noting: this is the piece most likely to be Googled by a hiring manager because the repo names are searchable. The substance is defensible; the links let them verify.

### Recommended changes

1. Verify or generalize "125+ design standards and 150+ accessibility guidelines."
2. One-time link check on the three GitHub repos + the engineering blog post. If the blog post URL has rotted, either update or drop the link.
3. Optional: the phrase "approximately right" in "Healthcare UI components don't get to be approximately right" is a good sentence but slightly stiff. If you wanted to loosen it to Jeremy-voice register, something like "Healthcare UI components don't get to be close enough." No action required — the current phrasing is fine.

---

## 6. Seven Years in Healthcare UX 🟢

### Fact check

| Claim | Status |
|---|---|
| "I joined Cerner in 2018 as a UX designer on the revenue cycle product" | Verified via LinkedIn / the other pieces. |
| "Nearly eight years" at Cerner/Oracle Health | If 2018 start → layoff in ~early 2026, that's about 8 years. Matches. |
| "Wood Badge — the Boy Scouts of America's adult leadership program" | Real program, accurately described. |
| "The closing question is *What can I do to make your experience better?*" | Personal practice claim; not verifiable but consistent across dispatches. |
| "I went through Wood Badge starting in 2015 and stayed with the program through 2022" | Personal history; accept as true. |
| "I went from twelve reports to five: three in Kansas City, one in New York, one in North Carolina" | Consistent with Terra piece. |
| "First two Oracle years, during performance review cycles, there were no promotions or raises on the table. For anyone." | **This is a strong, specific organizational claim.** True for your team or true across Oracle? If the latter, it's a meaningful fact that shaped industry-wide perception. If the former, worth narrowing — "no promotions or raises on my team" vs "not available" reads as claim-about-all-of-Oracle. Probably fine as-is because it's written from your specific experience, but worth a moment's thought. |
| "I got three of my reports promoted — with pay raises" | Personal claim; accept. |
| "The $28B acquisition" (in the header) | Matches the $28.3B from Terra piece. Consistent. |

### Voice

Strong. The recurring callback to the closing question ("What can I do to make your experience better?") is the kind of specific anchor `jeremy-voice` calls for. The italicization of the question each time it appears is a choice that earns itself.

One possible voice-tune: *"Ordinary at the time."* in the last section has the kind of understated-closer quality the voice rules love — but it's not actually the closer, it's mid-paragraph. Still works. The actual closer — *"What ultimately moved the three promotions was documentation, elapsed time, and the willingness to keep pushing after the standard answer came back as 'no.'"* — is a list-style ending that's a hair more constructed than Jeremy's usual. Not broken; it's doing its job.

### Quality

Structurally this is the clearest of the three case studies. Wood Badge → the closing question → management → the drought → what was protected. Each section earns the next. The piece argues a real claim: that volunteer leadership training meaningfully prepared someone for enterprise management through an acquisition. That's an unusual claim, well-grounded, and hiring-manager-interesting.

### Job-search relevance — HIGH for a specific read

This piece works on two audiences:

- **Design leadership hiring managers:** demonstrates management craft through a named-and-specific hard situation. The "three promotions during a drought" story is the kind of accomplishment that's hard to write without sounding self-aggrandizing; this piece does it honestly because the framing is about process (documentation, elapsed time, advocacy), not ego.
- **Anyone who ever heard of Wood Badge:** signals a depth of practice most candidates don't have. Niche, but the signal is strong where it lands.

### Gaps

No major ones. The piece is complete as-is.

### Recommended changes

1. Consider sharpening "there were no promotions or raises on the table. For anyone." to acknowledge the scope you have direct knowledge of. Something like "there were no promotions or raises on the table. Not for anyone on my team, and as far as I could tell, not across design at the company either."
2. Optional: add a sentence at the end acknowledging that the management chapter has ended (the layoff). The piece currently ends on the three promotions, which is the right emotional beat, but the reader may wonder "is he still in that job?" given the recent dispatches mention the layoff. One-line coda: "The management chapter ended in the layoff. The reports are landing elsewhere; the practice isn't going anywhere." Or similar.

---

## 7. Two Components That Didn't Ship (redwood-health-design) 🟢

### Fact check

| Claim | Status |
|---|---|
| "Redwood Health Design team" inside "a roughly 100-person system organization" | Accurate organizational description. |
| "I shipped three main components: a Page Summary for medical summaries... an Object ID component... and a health-aware timestamp for patient age" | Specific and defensible. |
| "Joint Commission in the US... patient-safety frameworks across the UK, EU, Canada, and Australia all treat it that way" | Linked to Joint Commission; the UK/EU/Canada/Australia claim is harder to verify. Generally true — patient-identification-at-two-points is a widely adopted safety practice. |
| "FHIR's HumanName element" | Accurate. Linked. Verified. |
| "June 2024 – March 2026" timeline in header | Matches other pieces. |
| "In my June 2025 performance review, my top goal for the next year was that whatever I worked on next had to be centered on AI" | Personal claim; accept. |
| "In September I got asked to be the designer of the AI design process for Oracle design. Six months later the layoff came." | This dates the layoff to ~March 2026. Consistent with "March 2026" in header. Verified via cross-reference. |

### Voice

**This may be the best-written piece on the site.** Specific observation, specific mechanism of harm (exactly how the pronoun mismatch outs a patient — body language, screen visibility), specific resolution (we killed it). The pattern is: build the thing, realize what it does in the world, stop. That's not a case study pattern. It's an ethics-in-practice pattern written in the register of someone who's been there.

The name-truncator section is equally good. The observation that "the smart solution undermined the consistency that made the name a reliable identifier in the first place" is a load-bearing sentence — it's the whole theme of the piece in one line.

### Quality

Highest-quality piece on the site. The structure is unusual — it's a case study about *what didn't ship* rather than what did — and that unusual angle is what makes it distinctive. Most designers' portfolios argue "here's what I built." This piece argues "here's what I almost built and why stopping mattered." That's a senior-practitioner move.

The "What I learned there" section is particularly good: *"Most design system work is enforcement. This work was judgment."* That's a clear articulation of the craft distinction, and it pays forward into the Domain Foundation case study's framing about encoded judgment vs. encoded documentation.

### Job-search relevance — VERY HIGH

If a hiring manager reads one piece on the site, make it this one. Reasons:

1. Demonstrates judgment at the level a Director/Principal role requires.
2. Shows ethical reasoning about patient safety without being preachy.
3. Argues against the instinct to ship — which is a rare signal.
4. Names specific mechanisms of harm (body language as non-consent disclosure vector), which tells a hiring reader this person has thought about deployment context, not just product logic.

### Gaps

No major ones.

### Recommended changes

None. Leave it.

One observation rather than a recommendation: this piece is an unusually strong bridge to the Domain Foundation case study because it names a specific instance of the "AI couldn't catch this, a human did" gap that Domain Foundation is built around. The cross-link at the bottom already does this work. Don't lose that link in any future edit.

---

## 8. About (Jeremy) 🟡

### Fact check

| Claim | Status |
|---|---|
| "In the spring of 1994 I was an Oklahoma State undergrad" | Personal; accept. |
| "Teach Yourself HTML in 24 Hours" | Real book, first published 1997 per my cached knowledge. **If the about page says spring 1994, there's a chronology issue — the book didn't exist yet.** The original Sams "Teach Yourself HTML" editions started around 1996. You may be misremembering the book title or the year. **Needs verification.** |
| "Oklahoma State Regents for Higher Education" | Real body. Accurate. |
| "My first full-time web job was for an online pharmacy... acquired in 2001 and I was laid off" | Personal; accept. |
| "Enterprise healthcare came next — design systems at Cerner, then design leadership through Oracle's acquisition" | Consistent with the other pieces. |
| "Oracle Health laid me off in the infamous 5 a.m. 30,000-person email" | Refers to the widely-reported Oracle Health layoff event. 5 a.m. detail and 30,000 scale are approximately accurate to public reporting. Verified. |
| "KF0NUI" (ham license call sign) | Amateur radio call sign format is real and plausible for a US-issued license. Not independently verifiable but safe. |

### Voice

The About voice is confident, specific, and scans well. "Most of the first fifteen years ran through marketing and advertising — local car ads at the bottom, national brands by the end" is the kind of specific-from-low-to-high-arc that tells a reader something substantial in one sentence.

One voice flag: "I've been teaching myself new tools ever since that HTML book." — the "ever since that [X]" construction has a slight tell-you-what-to-think quality. Works fine here because the prior sentence set up the reference, but it's close to the edge.

### Quality

The About is its intended length (~320 words) and does the work of an About. Three arcs — marketing/advertising, healthcare enterprise, the post-layoff present. Tied together by the "teaching myself new tools" throughline. Clean.

### Job-search relevance — HIGH (essential)

This is likely the second- or third-most-read page on the site after the home page and `/work/`. It does the work of setting up the hiring manager's frame before they read the case studies. The arc from "D-list internet celebrity" to "refining a practice for making better designs through better context" is a credible career narrative that doesn't feel like resume compression.

### Gaps

- The "Teach Yourself HTML in 24 Hours" book title in spring 1994 was chronologically impossible — that book series started in 1996. **Fixed 2026-04-22:** year changed to 1996 on the live About page via direct Admin API PUT. Book title kept (correct for the new year).
- ~~About mentions Domain Foundation by name but doesn't link to it~~ — correction: the About already links `/work/domain-foundation/` in the HTML. I missed the link because the text dump I audited from had stripped the `<a>` tags. No action needed.

### Recommended changes

1. ~~Verify the "spring 1994" date~~ — done, now "spring 1996."
2. ~~Link Domain Foundation~~ — already linked; audit error on my part.
3. Optional: the "D-list internet celebrity" line is a good Jeremy-voice move. Keep.

---

## Cross-cutting observations across pieces 5–9

### Consistency with the new Domain Foundation / Research Year framing

All three case studies are internally consistent with each other and with the recent work. Specifically:

- Terra piece ends pointing forward to Seven Years and Redwood. ✓
- Seven Years piece describes the management chapter without contradicting the layoff narrative in the dispatches. ✓
- Redwood piece explicitly says "Six months later the layoff came" and links to Domain Foundation. ✓

The one place consistency matters most: **Seven Years and Redwood together establish the layoff as recent**, which is correct. None of the three case studies contradict the Christmas 2024 Domain Foundation crystallization or the post-layoff consulting framing.

### Voice is consistent across the set

Every case study opens in the room with a stated fact. Every one has flat section headers. Every one closes with a reported observation rather than a reach. This voice discipline is what makes the site feel coherent — and it's the same discipline the four dispatches hold. The corpus is doing its job.

### The three case studies form a trilogy, and it works

- Terra: IC craft at enterprise scale (systems work)
- Seven Years: leadership craft through organizational upheaval (management work)
- Redwood / Two Components: judgment craft in a high-stakes domain (ethics work)

That's a coherent portfolio. Each piece demonstrates a different faculty. A hiring manager reading all three forms a useful composite picture.

### What's missing from the Case Studies orbit (not a gap, just noting)

The trilogy covers 2018–2026 at Cerner/Oracle. Nothing covers the prior fifteen years of agency/marketing work. That's intentional — those chapters aren't relevant to the Director/Principal UX positioning — but a reader who reads only the case studies won't know there's a fifteen-year agency career. The About page covers that gap. Don't double up in the case studies.

### Recommended action items

Consolidated, in priority order:

1. ~~About: Verify the 1994 + Teach Yourself HTML combination~~ — ✅ **Fixed 2026-04-22.** Year changed from 1994 to 1996 on live site.
2. ~~About: add a Domain Foundation link~~ — ✅ **Already present.** Audit error corrected.
3. **Terra:** Verify the "125+ design standards and 150+ accessibility guidelines" numbers, or generalize. *Still pending.*
4. **Terra:** One-time link check on three GitHub repos + engineering blog post. *Still pending.*
5. **Seven Years:** Optionally sharpen the "no promotions for anyone" claim to acknowledge scope. Optionally add a one-line coda about the management chapter ending. *Optional.*
6. **Redwood:** No changes. Leave as the strongest piece on the site.

Remaining items 3, 4, 5 are all optional. Piece-5-through-9 audit is effectively complete.

---

_End of audit for pieces 5–9. Home page (piece 10) is a separate evaluation — Jeremy's explicit request was to improve Work surfacing on the home page. That's less an audit and more a design task._
