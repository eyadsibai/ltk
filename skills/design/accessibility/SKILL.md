---
name: Accessibility
description: This skill should be used when the user asks about "accessibility", "a11y", "WCAG", "screen readers", "keyboard navigation", "ARIA", "accessible design", "inclusive design", or mentions making apps accessible.
version: 1.0.0
---

# Accessibility (a11y)

Guidance for creating accessible web applications following WCAG guidelines.

## Core Principles (POUR)

1. **Perceivable**: Content can be perceived by all senses
2. **Operable**: Interface can be operated by everyone
3. **Understandable**: Content and UI are understandable
4. **Robust**: Works with assistive technologies

## Quick Wins

### Images

```html
<!-- Informative image -->
<img src="chart.png" alt="Sales grew 25% in Q4 2024">

<!-- Decorative image -->
<img src="decoration.png" alt="" role="presentation">
```

### Buttons & Links

```html
<!-- Good: Descriptive -->
<button>Add to cart</button>
<a href="/docs">View documentation</a>

<!-- Bad: Vague -->
<button>Click here</button>
<a href="/docs">Read more</a>
```

### Forms

```html
<label for="email">Email address</label>
<input type="email" id="email" aria-describedby="email-hint">
<span id="email-hint">We'll never share your email</span>
```

### Headings

```html
<!-- Proper hierarchy -->
<h1>Page Title</h1>
  <h2>Section</h2>
    <h3>Subsection</h3>
  <h2>Another Section</h2>
```

## Color & Contrast

### Minimum Contrast Ratios

| Element | WCAG AA | WCAG AAA |
|---------|---------|----------|
| Normal text | 4.5:1 | 7:1 |
| Large text (18px+) | 3:1 | 4.5:1 |
| UI components | 3:1 | 3:1 |

### Don't Rely on Color Alone

```html
<!-- Bad: Color only -->
<span style="color: red">Error</span>

<!-- Good: Color + icon + text -->
<span style="color: red">
  <svg aria-hidden="true">...</svg>
  Error: Email is required
</span>
```

## Keyboard Navigation

### Focus Management

```css
/* Visible focus indicator */
:focus {
  outline: 2px solid #2563EB;
  outline-offset: 2px;
}

/* Don't remove focus styles! */
:focus { outline: none; } /* BAD */
```

### Tab Order

```html
<!-- Natural order follows DOM -->
<nav>
  <a href="/">Home</a>      <!-- Tab 1 -->
  <a href="/about">About</a> <!-- Tab 2 -->
</nav>

<!-- Skip link for keyboard users -->
<a href="#main" class="skip-link">Skip to content</a>
```

### Keyboard Shortcuts

- `Tab`: Move forward
- `Shift+Tab`: Move backward
- `Enter/Space`: Activate
- `Escape`: Close/cancel
- `Arrow keys`: Navigate within components

## ARIA Basics

### When to Use ARIA

1. **First**: Use semantic HTML
2. **Then**: Add ARIA only if needed

```html
<!-- Semantic HTML (preferred) -->
<button>Submit</button>
<nav>...</nav>

<!-- ARIA when needed -->
<div role="button" tabindex="0">Submit</div>
<div role="navigation">...</div>
```

### Common ARIA Attributes

```html
<!-- Labeling -->
<button aria-label="Close dialog">×</button>
<div aria-labelledby="section-title">...</div>

<!-- State -->
<button aria-expanded="false">Menu</button>
<div aria-hidden="true">Decorative content</div>

<!-- Live regions -->
<div aria-live="polite">Status updates here</div>
<div role="alert">Error message</div>
```

## Component Patterns

### Modal Dialog

```html
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title">
  <h2 id="dialog-title">Confirm Action</h2>
  <p>Are you sure?</p>
  <button>Cancel</button>
  <button>Confirm</button>
</div>
```

### Tabs

```html
<div role="tablist">
  <button role="tab" aria-selected="true" aria-controls="panel1">Tab 1</button>
  <button role="tab" aria-selected="false" aria-controls="panel2">Tab 2</button>
</div>
<div role="tabpanel" id="panel1">Content 1</div>
<div role="tabpanel" id="panel2" hidden>Content 2</div>
```

## Testing Checklist

### Automated Testing

- [ ] Run axe or Lighthouse accessibility audit
- [ ] Check color contrast with WebAIM checker
- [ ] Validate HTML

### Manual Testing

- [ ] Navigate with keyboard only (no mouse)
- [ ] Test with screen reader (VoiceOver, NVDA)
- [ ] Zoom to 200% - is content usable?
- [ ] Disable CSS - is content logical?

### Screen Reader Testing

```
macOS: VoiceOver (Cmd + F5)
Windows: NVDA (free) or JAWS
Mobile: TalkBack (Android), VoiceOver (iOS)
```

## Quick Reference

| Issue | Solution |
|-------|----------|
| Image without alt | Add descriptive alt text |
| Low contrast | Increase to 4.5:1 minimum |
| Missing labels | Add `<label>` or aria-label |
| No focus visible | Add visible focus styles |
| Mouse-only | Add keyboard support |
| Auto-playing media | Add pause controls |
