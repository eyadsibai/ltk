---
name: whisper
description: Use when "Whisper", "OpenAI Whisper", "speech recognition", or asking about "speech-to-text", "transcription", "audio transcription", "multilingual ASR", "translate audio", "podcast transcription"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/18-multimodal/whisper -->

# Whisper - Robust Speech Recognition

OpenAI's multilingual speech recognition model. Supports 99 languages.

## When to Use

- Speech-to-text transcription
- Podcast/video transcription
- Meeting notes automation
- Translation to English
- Noisy audio transcription
- Multilingual audio processing

## Quick Start

```bash
# Requires Python 3.8-3.11
pip install -U openai-whisper

# Requires ffmpeg
# macOS: brew install ffmpeg
# Ubuntu: sudo apt install ffmpeg
```

```python
import whisper

# Load model
model = whisper.load_model("base")

# Transcribe
result = model.transcribe("audio.mp3")
print(result["text"])

# With timestamps
for segment in result["segments"]:
    print(f"[{segment['start']:.2f}s - {segment['end']:.2f}s] {segment['text']}")
```

## Model Sizes

```python
model = whisper.load_model("turbo")  # Recommended: fast + good quality
```

| Model | Parameters | Speed | VRAM | Use Case |
|-------|------------|-------|------|----------|
| tiny | 39M | ~32x | ~1 GB | Prototyping |
| base | 74M | ~16x | ~1 GB | Quick tests |
| small | 244M | ~6x | ~2 GB | Good quality |
| turbo | 809M | ~8x | ~6 GB | **Recommended** |
| large | 1550M | 1x | ~10 GB | Maximum quality |

## Transcription Options

### Specify Language

```python
# Auto-detect (default)
result = model.transcribe("audio.mp3")

# Specify language (faster)
result = model.transcribe("audio.mp3", language="en")
```

### Translation to English

```python
# Translate non-English audio to English
result = model.transcribe("spanish.mp3", task="translate")
```

### Word-Level Timestamps

```python
result = model.transcribe("audio.mp3", word_timestamps=True)

for segment in result["segments"]:
    for word in segment["words"]:
        print(f"{word['word']} ({word['start']:.2f}s - {word['end']:.2f}s)")
```

### Improve Accuracy with Context

```python
result = model.transcribe(
    "audio.mp3",
    initial_prompt="This is a technical podcast about machine learning."
)
```

## CLI Usage

```bash
# Basic transcription
whisper audio.mp3

# Specify model
whisper audio.mp3 --model turbo

# Output formats
whisper audio.mp3 --output_format txt   # Plain text
whisper audio.mp3 --output_format srt   # Subtitles
whisper audio.mp3 --output_format vtt   # WebVTT
whisper audio.mp3 --output_format json  # JSON with timestamps

# Translation
whisper spanish.mp3 --task translate
```

## Batch Processing

```python
audio_files = ["file1.mp3", "file2.mp3", "file3.mp3"]

for audio_file in audio_files:
    result = model.transcribe(audio_file)
    output_file = audio_file.replace(".mp3", ".txt")
    with open(output_file, "w") as f:
        f.write(result["text"])
```

## Faster Alternative: faster-whisper

```bash
pip install faster-whisper  # 4x faster
```

```python
from faster_whisper import WhisperModel

model = WhisperModel("base", device="cuda", compute_type="float16")

segments, info = model.transcribe("audio.mp3", beam_size=5)

for segment in segments:
    print(f"[{segment.start:.2f}s -> {segment.end:.2f}s] {segment.text}")
```

## GPU Acceleration

```python
# Auto GPU if available
model = whisper.load_model("turbo")

# Force CPU
model = whisper.load_model("turbo", device="cpu")

# Force GPU
model = whisper.load_model("turbo", device="cuda")
```

## Subtitle Generation

```bash
# Generate SRT subtitles
whisper video.mp4 --output_format srt

# Output: video.srt
```

## Best Practices

1. **Use turbo model** - Best speed/quality for most cases
2. **Specify language** - Faster than auto-detect
3. **Add initial prompt** - Improves technical terms
4. **Use GPU** - 10-20× faster
5. **Split long audio** - <30 min chunks work best
6. **Use faster-whisper** - 4× faster than openai-whisper

## Supported Languages

Top languages: English, Spanish, French, German, Italian, Portuguese, Russian, Japanese, Korean, Chinese + 89 more.

## Limitations

- May hallucinate on silent/noise sections
- Accuracy degrades on >30 min audio
- No speaker diarization
- Real-time latency not suitable for live captioning

## Resources

- GitHub: <https://github.com/openai/whisper>
- Paper: <https://arxiv.org/abs/2212.04356>
