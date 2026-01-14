---
name: Branding
description: This skill should be used when the user asks about "branding", "brand identity", "logo design", "color palette", "brand guidelines", "visual identity", "brand voice", "style guide", or mentions brand-related decisions.
version: 1.0.0
---

# Branding

Guidance for creating and maintaining consistent brand identity.

## Brand Identity Components

### Visual Elements

1. **Logo**: Primary mark, variations, clear space
2. **Color Palette**: Primary, secondary, accent colors
3. **Typography**: Heading and body fonts
4. **Imagery Style**: Photo style, illustrations, icons
5. **Patterns/Textures**: Supporting visual elements

### Brand Voice

1. **Tone**: Formal/casual, serious/playful
2. **Personality**: How the brand "speaks"
3. **Values**: What the brand stands for
4. **Messaging**: Key phrases and taglines

## Color Palette Structure

### Primary Colors
Main brand colors (1-2):
```
Primary:     #2563EB (Blue)
Primary Dark: #1D4ED8
Primary Light: #3B82F6
```

### Secondary Colors
Supporting colors (2-3):
```
Secondary:   #10B981 (Green)
Accent:      #F59E0B (Amber)
```

### Neutral Colors
For text, backgrounds, borders:
```
Gray 900: #111827 (Text)
Gray 600: #4B5563 (Secondary text)
Gray 400: #9CA3AF (Placeholder)
Gray 200: #E5E7EB (Borders)
Gray 100: #F3F4F6 (Backgrounds)
Gray 50:  #F9FAFB (Light backgrounds)
```

### Semantic Colors
For feedback states:
```
Success: #10B981
Warning: #F59E0B
Error:   #EF4444
Info:    #3B82F6
```

## Typography System

### Font Selection

**Heading Font**: Display/impact
- Sans-serif: Inter, Poppins, Montserrat
- Serif: Playfair Display, Merriweather

**Body Font**: Readability
- Sans-serif: Inter, Open Sans, Roboto
- Serif: Georgia, Source Serif Pro

### Font Pairing Examples

```
Modern Tech:     Inter (headings + body)
Professional:    Montserrat + Open Sans
Editorial:       Playfair Display + Source Sans Pro
Friendly:        Poppins + Nunito
```

## Logo Guidelines

### Logo Versions

1. **Primary**: Full logo with wordmark
2. **Compact**: Logo mark only
3. **Horizontal**: Wide layout
4. **Vertical**: Stacked layout

### Clear Space

Minimum padding around logo:
```
┌─────────────────────┐
│         X           │
│    ┌─────────┐      │
│  X │  LOGO   │ X    │
│    └─────────┘      │
│         X           │
└─────────────────────┘
X = height of logo mark
```

### Logo Don'ts

- Don't stretch or distort
- Don't change colors arbitrarily
- Don't add effects (shadows, gradients)
- Don't place on busy backgrounds
- Don't rotate or flip

## Brand Voice Guidelines

### Tone Spectrum

```
Formal ←————————————→ Casual
Serious ←———————————→ Playful
Technical ←—————————→ Simple
Reserved ←——————————→ Enthusiastic
```

### Writing Style

**Do:**
- Use active voice
- Be concise
- Address user directly ("you")
- Use contractions for casual tone

**Don't:**
- Use jargon unnecessarily
- Be condescending
- Use passive voice
- Over-promise

### Example Messages

| Context | Too Formal | On Brand | Too Casual |
|---------|------------|----------|------------|
| Success | "Operation completed successfully" | "Done! Your changes are saved" | "Yay! Nailed it!" |
| Error | "An error has occurred" | "Something went wrong. Try again?" | "Oops! That broke" |

## Brand Guidelines Document

### Structure

```markdown
# Brand Guidelines

## Brand Story
- Mission
- Vision
- Values

## Logo
- Primary logo
- Variations
- Clear space
- Incorrect usage

## Color
- Primary palette
- Secondary palette
- Usage examples

## Typography
- Font families
- Type scale
- Usage guidelines

## Imagery
- Photography style
- Illustration style
- Icon style

## Voice & Tone
- Brand personality
- Writing guidelines
- Example copy

## Applications
- Business cards
- Social media
- Website
- Email templates
```

## Implementation Checklist

- [ ] Logo files in all formats (SVG, PNG, various sizes)
- [ ] Color palette documented with hex/RGB values
- [ ] Typography defined with web fonts
- [ ] Brand guidelines document created
- [ ] Templates for common uses
- [ ] Asset library organized
