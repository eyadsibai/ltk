---
name: docx-processing
description: Use when working with "Word documents", "DOCX files", "tracked changes", "document editing", "docx creation", or asking about "Word file manipulation", "document comments", "redlining documents"
version: 1.0.0
---

<!-- Adapted from: awesome-claude-skills/document-skills/docx -->

# DOCX Processing Guide

Create, edit, and analyze Word documents (.docx files).

## Decision Tree

```
What do you need to do?
├─ Read/Analyze → Use pandoc for text extraction
├─ Create New → Use docx-js (JavaScript)
└─ Edit Existing
    ├─ Simple changes → Basic OOXML editing
    └─ Professional/Legal → Redlining workflow (tracked changes)
```

## Reading Documents

### Text Extraction with Pandoc

```bash
# Convert to markdown (preserves structure)
pandoc document.docx -o output.md

# Include tracked changes
pandoc --track-changes=all document.docx -o output.md
```

### Raw XML Access

DOCX files are ZIP archives containing XML:

```bash
# Unpack to see structure
unzip document.docx -d unpacked/
```

Key files:

- `word/document.xml` - Main content
- `word/comments.xml` - Comments
- `word/media/` - Images and media

## Creating New Documents

Use **docx-js** (JavaScript library):

```javascript
import { Document, Packer, Paragraph, TextRun } from "docx";
import * as fs from "fs";

const doc = new Document({
  sections: [{
    children: [
      new Paragraph({
        children: [
          new TextRun({ text: "Hello World", bold: true }),
        ],
      }),
    ],
  }],
});

Packer.toBuffer(doc).then((buffer) => {
  fs.writeFileSync("output.docx", buffer);
});
```

Install: `npm install docx`

## Editing Existing Documents

### For Simple Changes

Use Python with python-docx:

```python
from docx import Document

doc = Document('input.docx')
for para in doc.paragraphs:
    if 'old text' in para.text:
        para.text = para.text.replace('old text', 'new text')
doc.save('output.docx')
```

### For Tracked Changes (Redlining)

Professional documents require tracked changes:

1. **Extract current content:**

   ```bash
   pandoc --track-changes=all document.docx -o current.md
   ```

2. **Unpack document:**

   ```bash
   unzip document.docx -d unpacked/
   ```

3. **Edit XML directly** with tracked change markers:

   ```xml
   <!-- Deletion -->
   <w:del><w:r><w:delText>old text</w:delText></w:r></w:del>

   <!-- Insertion -->
   <w:ins><w:r><w:t>new text</w:t></w:r></w:ins>
   ```

4. **Repack document:**

   ```bash
   cd unpacked && zip -r ../output.docx *
   ```

## Converting to Images

```bash
# DOCX → PDF
soffice --headless --convert-to pdf document.docx

# PDF → Images
pdftoppm -jpeg -r 150 document.pdf page
# Creates: page-1.jpg, page-2.jpg, etc.
```

## Required Tools

```bash
# Text extraction
sudo apt-get install pandoc

# PDF conversion
sudo apt-get install libreoffice poppler-utils

# JavaScript creation
npm install docx

# Python editing
pip install python-docx
```

## Best Practices

- **Minimal edits**: Only mark text that actually changes
- **Preserve formatting**: Keep original run styles when possible
- **Batch changes**: Group related edits together
- **Verify output**: Always check final document opens correctly
