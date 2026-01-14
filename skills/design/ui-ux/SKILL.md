---
name: UI/UX Design
description: This skill should be used when the user asks about "UI design", "UX design", "user interface", "user experience", "wireframes", "mockups", "design patterns", "design system", "component design", "layout", or mentions UI/UX decisions.
version: 1.0.0
---

# UI/UX Design

Guidance for user interface and user experience design decisions.

## Core Principles

### Visual Hierarchy

Establish clear importance levels:
1. **Size**: Larger elements draw attention first
2. **Color**: Contrast guides the eye
3. **Spacing**: White space creates groupings
4. **Position**: Top-left reads first (in LTR languages)

### Consistency

- Use consistent spacing scale (4px, 8px, 16px, 24px, 32px, 48px)
- Maintain consistent component patterns
- Follow platform conventions (Material, iOS, Web)

### Feedback

Every action needs feedback:
- **Immediate**: Button press states
- **Progress**: Loading indicators
- **Completion**: Success/error messages

## Layout Patterns

### Card Layout
```
┌─────────────────┐
│     Image       │
├─────────────────┤
│ Title           │
│ Description     │
│ [Action Button] │
└─────────────────┘
```
Use for: Collections, products, articles

### List Layout
```
┌──┬──────────────┐
│##│ Title        │
│  │ Subtitle     │
└──┴──────────────┘
```
Use for: Settings, navigation, data tables

### Dashboard Layout
```
┌────────┬────────┬────────┐
│ Metric │ Metric │ Metric │
├────────┴────────┴────────┤
│      Main Chart          │
├─────────────┬────────────┤
│   Table     │  Activity  │
└─────────────┴────────────┘
```

## Component Design

### Buttons

| Type | Use Case |
|------|----------|
| Primary | Main action (1 per view) |
| Secondary | Alternative actions |
| Tertiary/Ghost | Low-emphasis actions |
| Destructive | Delete, remove actions |

### Forms

- Label above input (not placeholder-only)
- Show validation inline
- Group related fields
- Mark optional fields, not required
- Provide helpful error messages

### Navigation

- **Top nav**: Global, persistent
- **Side nav**: Complex apps, many sections
- **Bottom nav**: Mobile, 3-5 items max
- **Breadcrumbs**: Deep hierarchies

## Responsive Design

### Breakpoints

```css
/* Mobile first */
/* Default: Mobile (< 640px) */
@media (min-width: 640px)  { /* Tablet */ }
@media (min-width: 1024px) { /* Desktop */ }
@media (min-width: 1280px) { /* Large desktop */ }
```

### Adaptation Strategies

- **Stack**: Columns become rows on mobile
- **Hide**: Show/hide elements by importance
- **Resize**: Proportional scaling
- **Reflow**: Different layouts per breakpoint

## Color Usage

### Semantic Colors

| Color | Meaning |
|-------|---------|
| Blue | Primary actions, links |
| Green | Success, positive |
| Yellow/Orange | Warning, attention |
| Red | Error, destructive |
| Gray | Neutral, disabled |

### Contrast Requirements

- Text on background: 4.5:1 minimum (WCAG AA)
- Large text: 3:1 minimum
- Interactive elements: 3:1 minimum

## Typography

### Scale

```
xs:  12px  - Labels, captions
sm:  14px  - Body small
base: 16px - Body default
lg:  18px  - Body large
xl:  20px  - Heading small
2xl: 24px  - Heading medium
3xl: 30px  - Heading large
4xl: 36px  - Display
```

### Line Height

- Headings: 1.2 - 1.3
- Body text: 1.5 - 1.6
- UI elements: 1.0 - 1.25

## UX Patterns

### Empty States

Show when no data:
- Friendly illustration
- Explain what goes here
- Provide action to add first item

### Loading States

- Skeleton screens > spinners
- Progressive loading
- Optimistic UI when safe

### Error Handling

- Explain what went wrong
- Suggest how to fix
- Provide recovery action
- Don't blame the user

## Design Checklist

- [ ] Clear visual hierarchy
- [ ] Consistent spacing and alignment
- [ ] Responsive across devices
- [ ] Accessible color contrast
- [ ] Clear interactive states
- [ ] Helpful error messages
- [ ] Loading feedback
- [ ] Empty state design
