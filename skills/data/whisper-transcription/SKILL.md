---
name: whisper-transcription
description: Use when "Whisper", "speech-to-text", "audio transcription", "ASR", or asking about "transcribe audio", "podcast transcription", "voice recognition", "multilingual speech", "subtitle generation"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/18-multimodal/whisper -->

# Whisper Speech Recognition

OpenAI's multilingual speech recognition model.

## When to Use

- Speech-to-text transcription (99 languages)
- Podcast/video transcription
- Meeting notes automation
- Translation to English
- Noisy audio transcription
- Subtitle generation

## Quick Start

```bash
pip install -U openai-whisper

# Requires ffmpeg
# macOS: brew install ffmpeg
# Ubuntu: sudo apt install ffmpeg
```

### Basic Transcription

```python
import whisper

model = whisper.load_model("base")
result = model.transcribe("audio.mp3")

print(result["text"])

# Access segments with timestamps
for segment in result["segments"]:
    print(f"[{segment['start']:.2f}s - {segment['end']:.2f}s] {segment['text']}")
```

## Model Sizes

| Model | Parameters | Speed | VRAM |
|-------|------------|-------|------|
| tiny | 39M | ~32x | ~1 GB |
| base | 74M | ~16x | ~1 GB |
| small | 244M | ~6x | ~2 GB |
| medium | 769M | ~2x | ~5 GB |
| large | 1550M | 1x | ~10 GB |
| turbo | 809M | ~8x | ~6 GB |

**Recommendation:** Use `turbo` for best speed/quality, `base` for prototyping.

```python
model = whisper.load_model("turbo")
```

## Transcription Options

### Language Specification

```python
# Auto-detect
result = model.transcribe("audio.mp3")

# Specify language (faster)
result = model.transcribe("audio.mp3", language="en")
```

### Translation to English

```python
result = model.transcribe("spanish.mp3", task="translate")
# Input: Spanish audio -> Output: English text
```

### Initial Prompt (Improve Accuracy)

```python
result = model.transcribe(
    "audio.mp3",
    initial_prompt="This is a technical podcast about machine learning and AI."
)
```

### Word-Level Timestamps

```python
result = model.transcribe("audio.mp3", word_timestamps=True)

for segment in result["segments"]:
    for word in segment["words"]:
        print(f"{word['word']} ({word['start']:.2f}s - {word['end']:.2f}s)")
```

## Command Line

```bash
# Basic transcription
whisper audio.mp3 --model turbo

# Output formats
whisper audio.mp3 --output_format srt    # Subtitles
whisper audio.mp3 --output_format vtt    # WebVTT
whisper audio.mp3 --output_format json   # JSON with timestamps

# Translation
whisper spanish.mp3 --task translate
```

## GPU Acceleration

```python
# Automatically uses GPU if available
model = whisper.load_model("turbo")

# Force CPU
model = whisper.load_model("turbo", device="cpu")

# Force GPU (10-20x faster)
model = whisper.load_model("turbo", device="cuda")
```

## Faster-Whisper (4x Speed)

```python
# pip install faster-whisper
from faster_whisper import WhisperModel

model = WhisperModel("base", device="cuda", compute_type="float16")
segments, info = model.transcribe("audio.mp3", beam_size=5)

for segment in segments:
    print(f"[{segment.start:.2f}s -> {segment.end:.2f}s] {segment.text}")
```

## LangChain Integration

```python
from langchain.document_loaders import WhisperTranscriptionLoader
from langchain_chroma import Chroma
from langchain_openai import OpenAIEmbeddings

loader = WhisperTranscriptionLoader(file_path="audio.mp3")
docs = loader.load()

# Use in RAG
vectorstore = Chroma.from_documents(docs, OpenAIEmbeddings())
```

## Best Practices

1. **Use turbo model** - Best speed/quality for English
2. **Specify language** - Faster than auto-detect
3. **Add initial prompt** - Improves technical terms
4. **Use GPU** - 10-20x faster
5. **Split long audio** - <30 min chunks
6. **Use faster-whisper** - 4x faster than openai-whisper

## Limitations

- May hallucinate on silent sections
- Degrades on >30 min audio
- No speaker diarization
- Quality varies by accent

## Resources

- GitHub: <https://github.com/openai/whisper>
- Paper: <https://arxiv.org/abs/2212.04356>
- faster-whisper: <https://github.com/SYSTRAN/faster-whisper>
