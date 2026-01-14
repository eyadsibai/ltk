---
name: pptx-processing
description: Use when working with "PowerPoint", "presentations", "PPTX files", "slides", "slide decks", or asking about "presentation creation", "slide design", "speaker notes"
version: 1.0.0
---

<!-- Adapted from: awesome-claude-skills/document-skills/pptx -->

# PowerPoint Processing Guide

Create, edit, and analyze presentations (.pptx files).

## Decision Tree

```
What do you need to do?
├─ Read/Analyze → Use markitdown for text extraction
├─ Create New (no template) → Use html2pptx workflow
├─ Create New (with template) → Use template workflow
└─ Edit Existing → Use OOXML editing
```

## Reading Presentations

```bash
# Extract text to markdown
python -m markitdown presentation.pptx
```

### Key PPTX Structure

```
pptx (ZIP archive)
├── ppt/presentation.xml      # Main metadata
├── ppt/slides/slide{N}.xml   # Slide content
├── ppt/notesSlides/          # Speaker notes
├── ppt/slideLayouts/         # Layout templates
├── ppt/slideMasters/         # Master slides
├── ppt/theme/                # Colors and fonts
└── ppt/media/                # Images
```

## Creating Presentations

### Design Principles

1. **Match content to subject** - Choose colors that reflect the topic
2. **Use web-safe fonts** - Arial, Helvetica, Georgia, Verdana, Tahoma
3. **Clear hierarchy** - Size, weight, color for emphasis
4. **Consistency** - Repeat patterns across slides

### Color Palette Examples

| Style | Colors |
|-------|--------|
| Classic Blue | Navy #1C2833, Slate #2E4053, Silver #AAB7B8 |
| Bold Red | Red #C0392B, Orange #F39C12, Yellow #F1C40F |
| Forest Green | Black #191A19, Green #4E9F3D, White #FFFFFF |
| Black & Gold | Gold #BF9A4A, Black #000000, Cream #F4F6F6 |

### Layout Tips

- **Two-column preferred** - Header + two columns for charts/tables
- **Full-slide** - Let important content take entire slide
- **Never stack vertically** - Don't put charts below text

## Converting to Images

```bash
# PPTX → PDF
soffice --headless --convert-to pdf presentation.pptx

# PDF → Images
pdftoppm -jpeg -r 150 presentation.pdf slide
# Creates: slide-1.jpg, slide-2.jpg, etc.
```

## Creating Thumbnails

```bash
# Create thumbnail grid for review
python scripts/thumbnail.py presentation.pptx --cols 4
```

## Required Tools

```bash
# Text extraction
pip install "markitdown[pptx]"

# PDF conversion
sudo apt-get install libreoffice poppler-utils

# For html2pptx workflow
npm install pptxgenjs playwright sharp
```

## Best Practices

- State design approach before writing code
- Use consistent visual language
- Ensure text contrast and readability
- Validate thumbnails after generation
- Keep slide count manageable
