# Campfire Token Reference

Complete CSS custom property dictionary for `@jeremyfuksa/campfire@0.2.0`.

---

## Color Palette (Raw)

### Primary (Blue Steel / Cello)
```css
--primary-50:  #f5f7f9
--primary-100: #ebeef2
--primary-200: #d2dae3
--primary-300: #acbbcc
--primary-400: #8098b0   /* dark mode interactive */
--primary-500: #607a97
--primary-600: #4c627d   /* light mode interactive */
--primary-700: #3e4f66
--primary-800: #364456
--primary-900: #303a49
--primary-950: #1f2530
```

### Secondary (Terracotta)
```css
--secondary-50:  #faf6f5
--secondary-100: #f5ebe8
--secondary-200: #ead8d2
--secondary-300: #dbbdb3
--secondary-400: #c9998a
--secondary-500: #b87b6a
--secondary-600: #a8654f
--secondary-700: #8d5443
--secondary-800: #75473a
--secondary-900: #623e34
--secondary-950: #341f19
```

### Neutral (Blue-Grey / Black Rock)
```css
--neutral-50:  #f7f8f9
--neutral-100: #edeef1
--neutral-200: #d8dbe0
--neutral-300: #b8bcc5
--neutral-400: #9299a5
--neutral-500: #747b8a
--neutral-600: #5e6371
--neutral-700: #4d515c
--neutral-800: #42454e
--neutral-900: #2b303b
--neutral-950: #1c1f26
```

### Status
```css
--success-500: #8fb14b
--success-600: #739038
--success-700: #5a6f2d

--warning-500: #f9c574   /* Warning Amber light */
--warning-600: #ef991f   /* Warning Amber mid */
--warning-700: #d97706

--danger-500: #e75351
--danger-600: #dc3a38
--danger-700: #be2b29

--info-500: #b8c5d9
--info-600: #a3b2c9
--info-700: #8899b3
```

---

## Semantic Tokens

### Backgrounds
```css
/* Light mode default */
--bg-base:      var(--neutral-50)    /* page background */
--bg-subtle:    var(--neutral-100)   /* cards, sidebars */
--bg-muted:     var(--neutral-200)   /* inputs, disabled areas */
--bg-emphasis:  var(--neutral-900)   /* inverted sections */

/* Dark mode overrides (applied via .dark class) */
--bg-base:      var(--neutral-950)
--bg-subtle:    var(--neutral-900)
--bg-muted:     var(--neutral-800)
--bg-emphasis:  var(--neutral-50)
```

### Text
```css
--text-primary:   var(--neutral-900)  /* main body text */
--text-secondary: var(--neutral-600)  /* captions, metadata */
--text-tertiary:  var(--neutral-500)  /* placeholders */
--text-disabled:  var(--neutral-400)
--text-inverse:   var(--neutral-50)   /* text on dark/primary bg */
```

### Borders
```css
--border-default: var(--neutral-200)
--border-strong:  var(--neutral-300)
--border-subtle:  var(--neutral-100)
```

### Interactive
```css
--interactive-default:  var(--primary-600)  /* buttons, links, focus */
--interactive-hover:    var(--primary-700)
--interactive-active:   var(--primary-800)
--interactive-disabled: var(--neutral-300)
```

---

## shadcn/Tailwind Bridge

These are the semantic class names that resolve through campfire tokens:

```css
--background:           var(--bg-base)
--foreground:           var(--text-primary)
--card:                 var(--bg-base)
--card-foreground:      var(--text-primary)
--popover:              var(--bg-base)
--popover-foreground:   var(--text-primary)
--primary:              var(--interactive-default)
--primary-foreground:   var(--text-inverse)
--secondary:            var(--bg-subtle)
--secondary-foreground: var(--text-primary)
--muted:                var(--bg-muted)
--muted-foreground:     var(--text-secondary)
--accent:               var(--bg-subtle)
--accent-foreground:    var(--text-primary)
--destructive:          var(--danger-600)
--destructive-foreground: var(--text-inverse)
--border:               var(--border-default)
--input:                var(--border-default)
--ring:                 var(--interactive-default)
--radius:               var(--radius-base)
```

---

## Typography

### Font Families
```css
/* Applied to body — do not override */
font-family: Manrope, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;

/* Mono — use for code, technical values */
--font-mono: 'Fira Code', ui-monospace, SFMono-Regular, Menlo, Monaco, monospace;
```

### Type Scale
```css
--text-xs:   0.75rem   /* 12px */
--text-sm:   0.875rem  /* 14px */
--text-base: 1rem      /* 16px */
--text-lg:   1.125rem  /* 18px */
--text-xl:   1.25rem   /* 20px */
--text-2xl:  1.5rem    /* 24px */
--text-3xl:  1.875rem  /* 30px */
--text-4xl:  2.25rem   /* 36px */
--text-5xl:  3rem      /* 48px */
--text-6xl:  3.75rem   /* 60px */
```

### Font Weights
```css
--font-weight-light:     300
--font-weight-regular:   400
--font-weight-medium:    500
--font-weight-semibold:  600
--font-weight-bold:      700
--font-weight-extrabold: 800
```

### Heading Scale (auto-applied to h1–h6)
| Tag | Size | Weight | Letter Spacing |
|-----|------|--------|----------------|
| h1 | 3rem (48px) | 700 | -0.015em |
| h2 | 2.25rem (36px) | 600 | -0.01em |
| h3 | 1.875rem (30px) | 600 | -0.005em |
| h4 | 1.5rem (24px) | 600 | 0 |
| h5 | 1.25rem (20px) | 500 | 0 |
| h6 | 1.125rem (18px) | 500 | 0 |

### Body/Label Tokens
```css
--body-large:  1.125rem / 400 / lh 1.7
--body-base:   1rem     / 400 / lh 1.6
--body-small:  0.875rem / 400 / lh 1.5

--label-large: 1rem     / 500
--label-base:  0.875rem / 500
--label-small: 0.75rem  / 500
```

---

## Spacing Scale
```css
--spacing-0:  0
--spacing-1:  0.25rem   /* 4px  */
--spacing-2:  0.5rem    /* 8px  */
--spacing-3:  0.75rem   /* 12px */
--spacing-4:  1rem      /* 16px */
--spacing-5:  1.25rem   /* 20px */
--spacing-6:  1.5rem    /* 24px */
--spacing-8:  2rem      /* 32px */
--spacing-10: 2.5rem    /* 40px */
--spacing-12: 3rem      /* 48px */
--spacing-16: 4rem      /* 64px */
--spacing-20: 5rem      /* 80px */
--spacing-24: 6rem      /* 96px */
--spacing-32: 8rem      /* 128px */
--spacing-40: 10rem     /* 160px */
--spacing-48: 12rem     /* 192px */
```

---

## Border Radius
```css
--radius-none: 0
--radius-sm:   0.375rem  /* 6px  — small elements */
--radius-base: 0.5rem    /* 8px  — default (inputs, buttons, cards) */
--radius-md:   0.75rem   /* 12px — larger cards */
--radius-lg:   1rem      /* 16px */
--radius-xl:   1.25rem   /* 20px */
--radius-2xl:  1.75rem   /* 28px */
--radius-full: 9999px    /* pills, avatars */
```

---

## Shadows
```css
--shadow-xs:    0 1px 2px rgba(76, 98, 125, .08)
--shadow-sm:    0 1px 3px rgba(76, 98, 125, .12), 0 1px 2px rgba(76, 98, 125, .08)
--shadow-base:  0 4px 6px rgba(76, 98, 125, .10), 0 2px 4px rgba(76, 98, 125, .06)
--shadow-md:    0 10px 15px rgba(76, 98, 125, .12), 0 4px 6px rgba(76, 98, 125, .08)
--shadow-lg:    0 20px 25px rgba(76, 98, 125, .14), 0 8px 10px rgba(76, 98, 125, .06)
--shadow-xl:    0 25px 50px rgba(76, 98, 125, .18)
--shadow-glow:  0 0 20px rgba(76, 98, 125, .15)
--shadow-focus: 0 0 0 3px rgba(76, 98, 125, .15)  /* auto-applied on :focus-visible */
```

Shadow tint is derived from `--primary-600` RGB values, so shadows feel warm and on-brand rather than neutral black.
