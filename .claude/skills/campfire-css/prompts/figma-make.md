# Figma Make Prompt Template

Use this template when asked for `/figma-make` or a Figma Make-ready prompt. Transform the feature description into the format below using campfire vocabulary.

---

## Template

```
Design a [COMPONENT/SCREEN NAME] using the Campfire Design System.

**Visual Identity**
- Font: Manrope (sans-serif, weights 300–800), Fira Code (mono)
- Primary color: #4c627d (Cello blue-steel)
- Neutral scale: blue-grey anchored at #2b303b (900) / #1c1f26 (950)
- Accent: warm terracotta #a8654f (secondary-600)
- Warning amber: #ef991f
- Danger: #dc3a38

**Design Tokens to Apply**
- Background: neutral-50 (#f7f8f9) light / neutral-950 (#1c1f26) dark
- Subtle surface: neutral-100 (#edeef1)
- Primary text: neutral-900 (#2b303b)
- Secondary text: neutral-600 (#5e6371)
- Interactive: primary-600 (#4c627d)
- Border: neutral-200 (#d8dbe0)
- Border radius default: 8px (0.5rem)
- Focus ring: 3px solid rgba(76, 98, 125, 0.15)

**Shadow Scale**
- Cards/surfaces: 0 1px 3px rgba(76,98,125,.12), 0 1px 2px rgba(76,98,125,.08)
- Elevated (dropdowns, modals): 0 10px 15px rgba(76,98,125,.12)

**Layout & Spacing**
- Base unit: 4px
- Standard padding: 16px (p-4) for containers, 8px (p-2) for compact elements
- Gap between related elements: 8–12px
- Section spacing: 24–32px

**Component Specifications**
[DESCRIBE THE SPECIFIC COMPONENT OR SCREEN HERE]

**Tone & Aesthetic**
Warm, professional, approachable. Not cold or clinical. Think quiet confidence — refined but not precious. The neutral scale should feel like weathered steel, not cold corporate grey. Campfire warmth comes from the terracotta secondary palette bleeding into shadows and accents, not from bright colors.

**Mode**
Design in [light / dark / both] mode.

**Accessibility**
- Minimum 4.5:1 contrast ratio for body text
- 3:1 for large text and UI components
- Focus states visible and branded (campfire focus ring)
- Interactive elements minimum 44x44px touch target
```

---

## How to Use

1. Replace `[COMPONENT/SCREEN NAME]` with what's being designed
2. Replace `[DESCRIBE THE SPECIFIC COMPONENT OR SCREEN HERE]` with the feature spec — be specific about states, variants, content, interactions
3. Replace `[light / dark / both]` with the target mode
4. Paste the completed prompt directly into Figma Make

---

## Example: Login Form

```
Design a Login Form using the Campfire Design System.

**Visual Identity**
[...paste standard block...]

**Component Specifications**
A centered login card with:
- Card surface: bg-subtle (neutral-100), 8px radius, shadow-sm
- Card width: 400px max, full-width on mobile
- Heading: "Welcome back" — h3 size (30px), semibold, neutral-900
- Subheading: "Sign in to your account" — body-small, neutral-600
- Email input: full-width, labeled "Email", placeholder "you@example.com"
- Password input: full-width, labeled "Password", with show/hide toggle (Lucide Eye / EyeOff icon)
- "Forgot password?" link — right-aligned below password, primary-600, text-sm
- Primary CTA button: full-width, "Sign in", primary-600 background, 40px height
- Divider with "or" text
- "Continue with Google" outline button, full-width
- Footer: "Don't have an account? Sign up" — centered, text-sm, neutral-600 with primary-600 link

States to show: default, focused (email), error (invalid email with danger-600 message below input).

**Mode**
Both light and dark.
```

---

## Quick Reference: Campfire Color Names for Figma

| Token Name | Hex | Use |
|------------|-----|-----|
| Primary 600 (Cello) | #4c627d | Buttons, links, interactive |
| Primary 400 | #8098b0 | Dark mode interactive |
| Neutral 50 | #f7f8f9 | Light page bg |
| Neutral 100 | #edeef1 | Cards, sidebars |
| Neutral 200 | #d8dbe0 | Borders, inputs |
| Neutral 600 | #5e6371 | Secondary text |
| Neutral 900 | #2b303b | Primary text |
| Neutral 950 | #1c1f26 | Dark page bg |
| Secondary 600 (Terracotta) | #a8654f | Accents, illustrations |
| Warning 600 (Amber) | #ef991f | Warning states |
| Danger 600 | #dc3a38 | Error states |
| Success 600 | #739038 | Success states |
