---
name: video-downloader
description: Use when "downloading videos", "saving YouTube videos", "converting to MP3", "video quality", or asking about "yt-dlp", "video formats", "audio extraction"
version: 1.0.0
---

<!-- Adapted from: awesome-claude-skills/video-downloader -->

# Video Downloader Guide

Download videos with customizable quality and format options using yt-dlp.

## When to Use

- Downloading videos from YouTube and other sites
- Saving videos for offline viewing
- Extracting audio as MP3
- Choosing specific quality settings
- Converting between video formats

## Quick Start

```bash
# Basic download (best quality)
yt-dlp "https://www.youtube.com/watch?v=VIDEO_ID"

# Specify quality
yt-dlp -f "bestvideo[height<=1080]+bestaudio" "URL"

# Audio only as MP3
yt-dlp -x --audio-format mp3 "URL"
```

## Quality Options

| Quality | Command Flag |
|---------|-------------|
| Best | `-f best` (default) |
| 1080p | `-f "bestvideo[height<=1080]+bestaudio"` |
| 720p | `-f "bestvideo[height<=720]+bestaudio"` |
| 480p | `-f "bestvideo[height<=480]+bestaudio"` |
| 360p | `-f "bestvideo[height<=360]+bestaudio"` |
| Worst | `-f worst` |

## Format Options

| Format | Command |
|--------|---------|
| MP4 | `--merge-output-format mp4` |
| WebM | `--merge-output-format webm` |
| MKV | `--merge-output-format mkv` |

## Audio Extraction

```bash
# Extract as MP3
yt-dlp -x --audio-format mp3 "URL"

# Extract as M4A (better quality)
yt-dlp -x --audio-format m4a "URL"

# Best audio quality
yt-dlp -x --audio-quality 0 "URL"
```

## Custom Output

```bash
# Custom output directory
yt-dlp -o "/path/to/dir/%(title)s.%(ext)s" "URL"

# Custom filename template
yt-dlp -o "%(upload_date)s-%(title)s.%(ext)s" "URL"
```

## Playlist Handling

```bash
# Download entire playlist
yt-dlp "PLAYLIST_URL"

# Skip playlists (single video only)
yt-dlp --no-playlist "URL"

# Download specific items from playlist
yt-dlp --playlist-items 1-5 "PLAYLIST_URL"
```

## Installation

```bash
# macOS
brew install yt-dlp

# pip
pip install yt-dlp

# Update
yt-dlp -U
```

## Common Examples

```bash
# 1080p MP4 to specific folder
yt-dlp -f "bestvideo[height<=1080]+bestaudio" \
       --merge-output-format mp4 \
       -o "~/Videos/%(title)s.%(ext)s" "URL"

# Audio only as high-quality MP3
yt-dlp -x --audio-format mp3 --audio-quality 0 "URL"

# Download with subtitles
yt-dlp --write-subs --sub-lang en "URL"

# List available formats
yt-dlp -F "URL"
```

## Important Notes

- Video filename generated from video title
- Higher quality = larger file size
- Some sites may have restrictions
- Keep yt-dlp updated for best compatibility
