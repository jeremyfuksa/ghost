---
name: campfire-css
description: Enforce Campfire Design System conventions in all CSS, UI, and frontend code generation. Use this skill whenever writing React components, HTML/CSS, Tailwind classes, shadcn/ui usage, or any visual UI code — including vibe coding sessions, Cursor prompts, Claude Code tasks, and Figma Make prompts. Triggers on: "build a component", "style this", "create a UI", "write a page", "campfire theme", "use campfire", any request to generate or review frontend code. Also use when asked to generate a Figma Make prompt (/figma-make). ALWAYS use this skill for any frontend work — it defines the mandatory guardrails.
---

# Campfire CSS Skill

This skill enforces the Campfire Design System as the single source of truth for all CSS, component, and UI code generation. Every vibe coding session — whether in Cursor, Claude Code, or Figma Make — must follow these rules without deviation.

**Package:** `@jeremyfuksa/campfire@0.2.0`  
**Docs:** https://jeremyfuksa.github.io/campfire  
**Repo:** https://github.com/jeremyfuksa/campfire

---

## Setup (every new project)

```bash
npm install @jeremyfuksa/campfire
```

```ts
// Root entry file (main.tsx / app.tsx)
import '@jeremyfuksa/campfire/styles.css';
```

```tsx
// Wrap app root
import { ThemeProvider } from '@jeremyfuksa/campfire';

function App() {
  return (
    <ThemeProvider defaultTheme="system" storageKey="app-theme">
      {/* app */}
    </ThemeProvider>
  );
}
```

---

## Mandatory Rules

### 1. Tokens Only — No Hardcoded Values

**NEVER** use raw hex colors, pixel values for spacing, or hardcoded font sizes. **ALWAYS** use campfire CSS custom properties.

```tsx
// ❌ WRONG
<div style={{ color: '#4c627d', padding: '16px', fontSize: '14px' }} />
<div className="text-blue-600 p-4 text-sm" />  // raw Tailwind only

// ✅ RIGHT
<div className="text-primary p-4 text-sm" />   // campfire-bridged Tailwind
<div style={{ color: 'var(--interactive-default)', padding: 'var(--spacing-4)' }} />
```

### 2. Color Token Reference

Use semantic tokens, not raw palette values. See `references/tokens.md` for the full list.

| Role | Light | Dark |
|------|-------|------|
| Page background | `--bg-base` (neutral-50) | `--bg-base` (neutral-950) |
| Subtle surface | `--bg-subtle` (neutral-100) | `--bg-subtle` (neutral-900) |
| Muted surface | `--bg-muted` (neutral-200) | `--bg-muted` (neutral-800) |
| Primary text | `--text-primary` | `--text-primary` |
| Secondary text | `--text-secondary` | `--text-secondary` |
| Interactive | `--interactive-default` (primary-600) | `--interactive-default` (primary-400) |
| Border | `--border-default` | `--border-default` |

### 3. Typography

```css
/* Font stack — campfire sets these on body */
font-family: Manrope, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
font-family: 'Fira Code', ui-monospace, monospace;  /* mono — use --font-mono */
```

Use heading tokens for semantic headings, never arbitrary font sizes:

```tsx
// ❌ WRONG
<h2 className="text-2xl font-bold" />

// ✅ RIGHT — campfire globals handle h1-h6 sizing automatically
<h2>Section Title</h2>

// For non-semantic display text, use label/body tokens:
className="text-sm font-medium"   // --label-base
className="text-base"             // --body-base
className="text-lg"               // --body-large
```

### 4. Icons — Lucide React Only

```tsx
import { Settings, ChevronRight, X } from 'lucide-react';

// ❌ WRONG: Font Awesome, Heroicons, custom SVG inline without sizing
// ✅ RIGHT: Lucide with explicit size
<Settings className="size-4" />
<ChevronRight className="size-4 text-muted-foreground" />
```

### 5. Component Primitives — Use Campfire's shadcn Components

Import from `@jeremyfuksa/campfire`, not directly from shadcn or Radix.

```tsx
// ❌ WRONG
import { Button } from '@/components/ui/button';
import { Button } from 'shadcn/ui';

// ✅ RIGHT
import { Button } from '@jeremyfuksa/campfire';
import { Card, CardHeader, CardContent } from '@jeremyfuksa/campfire';
import { Input, Label, Select } from '@jeremyfuksa/campfire';
```

Available primitives: Button, Card, Input, Label, Select, Dialog, Sheet, Popover, Tooltip, Badge, Avatar, Checkbox, Switch, Tabs, Accordion, Alert, Toast (Sonner), Command (cmdk), DropdownMenu, NavigationMenu, Separator, Skeleton, Slider, Toggle.

### 6. Tailwind — Campfire-Bridged Classes Only

The campfire `styles.css` maps all shadcn/Tailwind semantic class names through campfire tokens. Use the semantic class names, not raw Tailwind color classes.

```tsx
// ✅ Use these — they resolve through campfire tokens
bg-background      bg-card        bg-primary     bg-muted
text-foreground    text-primary   text-muted-foreground
border-input       border-border  ring-ring
bg-destructive     text-destructive-foreground

// ❌ Avoid raw Tailwind color classes (they bypass campfire)
bg-blue-600   text-gray-500   border-slate-200   bg-zinc-900
```

### 7. Radius — Use Campfire Scale

```tsx
// campfire radius tokens
rounded-sm   // --radius-sm: 0.375rem
rounded      // --radius-base: 0.5rem  ← default for most components
rounded-md   // --radius-md: 0.75rem
rounded-lg   // --radius-lg: 1rem
rounded-xl   // --radius-xl: 1.25rem
rounded-full // pills and avatars
```

### 8. Shadows — Use Campfire Shadow Tokens

```css
box-shadow: var(--shadow-xs);    /* subtle lift */
box-shadow: var(--shadow-sm);    /* cards, sheets */
box-shadow: var(--shadow-base);  /* dropdowns */
box-shadow: var(--shadow-md);    /* modals */
box-shadow: var(--shadow-focus); /* focus rings — applied by campfire globals */
```

Never write raw `box-shadow` values. Cards automatically get `var(--shadow-sm)` via `.campfire-card` or `[class*=card]` selectors.

### 9. Dark Mode

Dark mode is handled by the `ThemeProvider`. Add the `.dark` class to a parent element or let the provider manage it. Never write duplicate color values for dark — use semantic tokens which flip automatically.

```tsx
// ❌ WRONG — manual dark mode overrides
<div className="bg-white dark:bg-gray-900" />

// ✅ RIGHT — semantic token flips automatically
<div className="bg-background" />
```

### 10. Spacing — Campfire Scale

Use Tailwind spacing utilities which map to campfire's spacing tokens (4px base unit).

```
p-1 = 4px   p-2 = 8px   p-3 = 12px   p-4 = 16px
p-5 = 20px  p-6 = 24px  p-8 = 32px   p-10 = 40px
```

---

## Component Patterns

### Card
```tsx
import { Card, CardHeader, CardTitle, CardContent } from '@jeremyfuksa/campfire';

<Card>
  <CardHeader>
    <CardTitle>Title</CardTitle>
  </CardHeader>
  <CardContent>Content</CardContent>
</Card>
```

### Form Field
```tsx
import { Input, Label } from '@jeremyfuksa/campfire';

<div className="space-y-1.5">
  <Label htmlFor="email">Email</Label>
  <Input id="email" type="email" placeholder="you@example.com" />
</div>
```

### Button Variants
```tsx
import { Button } from '@jeremyfuksa/campfire';

<Button>Primary</Button>
<Button variant="secondary">Secondary</Button>
<Button variant="outline">Outline</Button>
<Button variant="ghost">Ghost</Button>
<Button variant="destructive">Delete</Button>
<Button size="sm">Small</Button>
<Button size="lg">Large</Button>
```

---

## Prohibited Patterns

| Pattern | Why | Alternative |
|---------|-----|-------------|
| Raw hex colors in className or style | Bypasses token system | Use `--` CSS vars or semantic Tailwind classes |
| `font-awesome`, `fa-*` classes | Replaced by Lucide | `import { X } from 'lucide-react'` |
| `bg-blue-*`, `text-gray-*` etc | Bypasses campfire palette | `bg-primary`, `text-muted-foreground` |
| `dark:` Tailwind variants for color | Duplicates what tokens handle | Use semantic tokens |
| Inline `style={{ color: '#...' }}` | Not themeable | `style={{ color: 'var(--text-primary)' }}` |
| `@import` of external font CDNs | campfire stylesheet handles fonts | Import `@jeremyfuksa/campfire/styles.css` once |
| Importing shadcn components directly | May not use campfire tokens | Import from `@jeremyfuksa/campfire` |

---

## Generating a Figma Make Prompt

When asked for `/figma-make` or a Figma Make-ready prompt, read `prompts/figma-make.md` and use the template there to transform the feature description into a Figma Make input using campfire vocabulary.

---

## Reference Files

- `references/tokens.md` — Complete CSS custom property dictionary (colors, type, spacing, radius, shadow)
- `prompts/figma-make.md` — Figma Make prompt template using campfire vocabulary
