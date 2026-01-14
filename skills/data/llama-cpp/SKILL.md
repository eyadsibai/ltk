---
name: llama-cpp
description: Use when "llama.cpp", "GGUF", "CPU inference", "Apple Silicon inference", or asking about "run LLM locally", "M1/M2/M3 inference", "quantized models", "edge deployment", "non-NVIDIA inference"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/12-inference-serving/llama-cpp -->

# llama.cpp - CPU/Apple Silicon LLM Inference

Run LLMs on CPU, Apple Silicon, and consumer GPUs without NVIDIA hardware.

## When to Use

- Running on CPU-only machines
- Apple Silicon (M1/M2/M3/M4 Macs)
- AMD or Intel GPUs (no CUDA)
- Edge deployment (Raspberry Pi, embedded)
- Simple deployment without Docker/Python

## Quick Start

```bash
# macOS/Linux
brew install llama.cpp

# Or build from source
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make

# With Metal (Apple Silicon)
make LLAMA_METAL=1

# With CUDA (NVIDIA)
make LLAMA_CUDA=1
```

### Download Model

```bash
# Download GGUF model from HuggingFace
huggingface-cli download \
    TheBloke/Llama-2-7B-Chat-GGUF \
    llama-2-7b-chat.Q4_K_M.gguf \
    --local-dir models/
```

### Run Inference

```bash
# Simple generation
./llama-cli \
    -m models/llama-2-7b-chat.Q4_K_M.gguf \
    -p "Explain quantum computing" \
    -n 256

# Interactive chat
./llama-cli \
    -m models/llama-2-7b-chat.Q4_K_M.gguf \
    --interactive
```

## Server Mode (OpenAI Compatible)

```bash
# Start server
./llama-server \
    -m models/llama-2-7b-chat.Q4_K_M.gguf \
    --host 0.0.0.0 \
    --port 8080 \
    -ngl 32  # Offload 32 layers to GPU
```

```bash
# Query with curl
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama-2-7b-chat",
    "messages": [{"role": "user", "content": "Hello!"}],
    "temperature": 0.7
  }'
```

## Quantization Formats

| Format | Bits | Size (7B) | Speed | Quality |
|--------|------|-----------|-------|---------|
| **Q4_K_M** | 4.5 | 4.1 GB | Fast | Good (Recommended) |
| Q5_K_M | 5.5 | 4.8 GB | Medium | Better |
| Q6_K | 6.5 | 5.5 GB | Slower | Best |
| Q8_0 | 8.0 | 7.0 GB | Slow | Excellent |
| Q2_K | 2.5 | 2.7 GB | Fastest | Poor |

## Hardware Acceleration

### Apple Silicon (Metal)

```bash
make LLAMA_METAL=1
./llama-cli -m model.gguf -ngl 999  # Offload all layers
# M3 Max: ~50 tokens/sec on Llama 2-7B Q4_K_M
```

### NVIDIA GPUs (CUDA)

```bash
make LLAMA_CUDA=1
./llama-cli -m model.gguf -ngl 35  # Offload 35 layers
```

### AMD GPUs (ROCm)

```bash
make LLAMA_HIP=1
./llama-cli -m model.gguf -ngl 999
```

## Context Size

```bash
# Increase context (default 512)
./llama-cli -m model.gguf -c 4096  # 4K context

# Very long context
./llama-cli -m model.gguf -c 32768  # 32K context
```

## JSON Output

```bash
# Constrained generation with grammar
./llama-cli \
    -m model.gguf \
    -p "Generate a person: " \
    --grammar-file grammars/json.gbnf
```

## Performance Benchmarks

### CPU (Llama 2-7B Q4_K_M)

| CPU | Threads | Speed |
|-----|---------|-------|
| Apple M3 Max | 16 | 50 tok/s |
| AMD Ryzen 9 7950X | 32 | 35 tok/s |
| Intel i9-13900K | 32 | 30 tok/s |

### GPU Acceleration

| GPU | Speed |
|-----|-------|
| NVIDIA RTX 4090 | 120 tok/s |
| Apple M3 Max (Metal) | 50 tok/s |
| AMD MI250 | 70 tok/s |

## Supported Models

- Llama 2/3 (7B, 13B, 70B, 405B)
- Mistral 7B, Mixtral 8x7B
- Phi-3, Gemma, Qwen
- Code Llama
- LLaVA (vision), Whisper (audio)

Find GGUF models: <https://huggingface.co/models?library=gguf>

## vs Alternatives

| Tool | Best For |
|------|----------|
| **llama.cpp** | CPU, Apple Silicon, edge deployment |
| vLLM | NVIDIA GPUs, high throughput |
| TensorRT-LLM | NVIDIA datacenter, maximum performance |

## Resources

- GitHub: <https://github.com/ggerganov/llama.cpp>
- Models: <https://huggingface.co/models?library=gguf>
