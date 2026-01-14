---
name: image-enhancement
description: Use when "improving image quality", "enhancing screenshots", "upscaling images", "sharpening photos", or asking about "image optimization", "screenshot quality", "resolution improvement"
version: 1.0.0
---

<!-- Adapted from: awesome-claude-skills/image-enhancer -->

# Image Enhancement Guide

Improve image quality for documentation, presentations, and social media.

## When to Use

- Improving screenshot quality for blog posts
- Enhancing images for social media
- Preparing images for presentations
- Upscaling low-resolution images
- Sharpening blurry photos
- Cleaning up compressed images

## Enhancement Workflow

1. **Analyze** - Check resolution, sharpness, artifacts
2. **Enhance** - Apply appropriate improvements
3. **Optimize** - Adjust for intended use case
4. **Save** - Preserve original, save enhanced version

## Python Enhancement Script

```python
from PIL import Image, ImageEnhance, ImageFilter

def enhance_image(input_path, output_path):
    img = Image.open(input_path)

    # Upscale if small
    if img.width < 1920:
        scale = 1920 / img.width
        new_size = (int(img.width * scale), int(img.height * scale))
        img = img.resize(new_size, Image.LANCZOS)

    # Sharpen
    img = img.filter(ImageFilter.SHARPEN)

    # Enhance contrast slightly
    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(1.1)

    img.save(output_path, quality=95)
    return img.size

# Usage
enhance_image('screenshot.png', 'screenshot-enhanced.png')
```

## ImageMagick Commands

```bash
# Sharpen image
convert input.png -sharpen 0x1 output.png

# Upscale 2x with good quality
convert input.png -resize 200% -filter Lanczos output.png

# Remove compression artifacts
convert input.jpg -enhance output.jpg

# Batch process folder
for f in *.png; do
    convert "$f" -sharpen 0x1 "enhanced-$f"
done
```

## Optimization by Use Case

| Use Case | Resolution | Format | Quality |
|----------|------------|--------|---------|
| Web/Blog | 1920px wide | PNG/WebP | 85-95% |
| Social Media | Platform-specific | JPG | 90% |
| Presentations | 2560px+ | PNG | 95% |
| Print | 300 DPI minimum | PNG/TIFF | 100% |

## Social Media Sizes

| Platform | Recommended Size |
|----------|-----------------|
| Twitter | 1200x675 |
| LinkedIn | 1200x627 |
| Instagram | 1080x1080 |
| Facebook | 1200x630 |

## Tips

- Always keep original files as backup
- PNG for screenshots (lossless)
- JPG for photos (smaller size)
- WebP for web (best compression)
- Batch process for multiple files

## Required Tools

```bash
# Python
pip install Pillow

# ImageMagick
sudo apt-get install imagemagick

# For advanced upscaling
pip install opencv-python
```
