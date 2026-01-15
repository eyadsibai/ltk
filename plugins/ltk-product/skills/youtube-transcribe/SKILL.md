---
name: youtube-transcribe
description: Use when "youtube transcript", "extract subtitles", "video captions", "get transcript", "video to text"
version: 1.0.0
---

# YouTube Transcript Extraction

Extract subtitles and transcripts from YouTube videos.

---

## Methods

| Method | Tool | When to Use |
|--------|------|-------------|
| **CLI** | yt-dlp | Fast, reliable, preferred |
| **Browser** | Chrome automation | Fallback when CLI fails |
| **API** | youtube-transcript-api | Python programmatic access |

---

## yt-dlp Method (Preferred)

### Basic Command

```bash
yt-dlp --write-auto-sub --write-sub --sub-lang en --skip-download -o "%(title)s.%(ext)s" "VIDEO_URL"
```

### Key Flags

| Flag | Purpose |
|------|---------|
| `--write-sub` | Download manual subtitles |
| `--write-auto-sub` | Download auto-generated subtitles |
| `--sub-lang LANG` | Specify language (en, zh-Hans, etc.) |
| `--skip-download` | Don't download video |
| `--cookies-from-browser chrome` | Use browser cookies for restricted videos |

### Common Issues

| Issue | Solution |
|-------|----------|
| Sign-in required | Add `--cookies-from-browser chrome` |
| No subtitles found | Video has no captions available |
| Age-restricted | Use cookies from logged-in browser |

---

## Browser Automation Fallback

When CLI fails, use browser automation:

1. **Open video page** - Navigate to YouTube URL
2. **Expand description** - Click "...more" button
3. **Open transcript** - Click "Show transcript" button
4. **Extract text** - Query DOM for transcript segments

### DOM Selectors

| Element | Selector |
|---------|----------|
| Transcript segments | `ytd-transcript-segment-renderer` |
| Timestamp | `.segment-timestamp` |
| Text | `.segment-text` |

---

## Output Formats

| Format | Extension | Use Case |
|--------|-----------|----------|
| **VTT** | .vtt | Web standard, includes timing |
| **SRT** | .srt | Video editing, media players |
| **TXT** | .txt | Plain text, no timing |

### Convert VTT to Plain Text

```bash
# Strip timing and formatting
sed '/^[0-9]/d; /^$/d; /WEBVTT/d; /-->/d' video.vtt > video.txt
```

---

## Language Codes

| Language | Code |
|----------|------|
| English | `en` |
| Chinese (Simplified) | `zh-Hans` |
| Chinese (Traditional) | `zh-Hant` |
| Spanish | `es` |
| Multiple | `en,es,zh-Hans` |

---

## Best Practices

| Practice | Why |
|----------|-----|
| Try manual subs first | Higher quality than auto-generated |
| Use cookies for restricted | Avoids sign-in errors |
| Check multiple languages | Some videos have better subs in other languages |
| Verify transcript exists | Not all videos have captions |
