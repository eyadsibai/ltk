---
name: llama-cpp-inference
description: Use when "llama.cpp", "local LLM", "GGUF models", "CPU inference", "edge deployment", or asking about "quantized models", "M1/M2 inference", "offline LLM", "low resource inference", "local AI"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/12-inference-serving/llama-cpp -->

# llama.cpp Local LLM Inference

Run LLMs locally on CPU/Metal/CUDA with GGUF quantized models.

## When to Use

- Running LLMs locally on laptops/desktops
- CPU-only or Apple Silicon (M1/M2/M3) inference
- Edge deployment with limited resources
- Privacy-sensitive applications (no cloud)
- Single-user local applications

## Quick Start

### Python Bindings

```bash
pip install llama-cpp-python

# With Metal support (macOS)
CMAKE_ARGS="-DLLAMA_METAL=on" pip install llama-cpp-python

# With CUDA support
CMAKE_ARGS="-DLLAMA_CUDA=on" pip install llama-cpp-python
```

### Basic Usage

```python
from llama_cpp import Llama

llm = Llama(
    model_path="./models/llama-2-7b-chat.Q4_K_M.gguf",
    n_ctx=4096,  # Context window
    n_gpu_layers=35  # GPU offload (0 for CPU only)
)

output = llm(
    "Q: What is the capital of France?\nA:",
    max_tokens=100,
    temperature=0.7,
    stop=["Q:"]
)
print(output["choices"][0]["text"])
```

### Chat Completions

```python
from llama_cpp import Llama

llm = Llama(
    model_path="./models/llama-2-7b-chat.Q4_K_M.gguf",
    chat_format="llama-2"  # or "chatml", "mistral-instruct"
)

response = llm.create_chat_completion(
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "What is machine learning?"}
    ],
    temperature=0.7
)
print(response["choices"][0]["message"]["content"])
```

## Server Mode

```bash
# Start OpenAI-compatible server
python -m llama_cpp.server \
    --model ./models/llama-2-7b-chat.Q4_K_M.gguf \
    --n_ctx 4096 \
    --n_gpu_layers 35 \
    --host 0.0.0.0 \
    --port 8000
```

### Query with OpenAI SDK

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:8000/v1", api_key="not-needed")

response = client.chat.completions.create(
    model="llama-2-7b-chat",
    messages=[{"role": "user", "content": "Hello!"}]
)
print(response.choices[0].message.content)
```

## Quantization Levels

| Quant | Size (7B) | Quality | Speed |
|-------|-----------|---------|-------|
| Q2_K | ~2.5 GB | Low | Fastest |
| Q4_K_M | ~4 GB | Good | Fast |
| Q5_K_M | ~5 GB | Better | Medium |
| Q6_K | ~6 GB | High | Slower |
| Q8_0 | ~7 GB | Highest | Slowest |

Recommendation: **Q4_K_M** for best balance of quality/speed.

## Download GGUF Models

```python
from huggingface_hub import hf_hub_download

# Download quantized model
model_path = hf_hub_download(
    repo_id="TheBloke/Llama-2-7B-Chat-GGUF",
    filename="llama-2-7b-chat.Q4_K_M.gguf"
)
```

## Performance Optimization

### Apple Silicon (M1/M2/M3)

```python
llm = Llama(
    model_path="model.gguf",
    n_gpu_layers=-1,  # Offload all layers to Metal
    n_ctx=4096,
    use_mmap=True,
    use_mlock=True
)
```

### CPU Only

```python
llm = Llama(
    model_path="model.gguf",
    n_gpu_layers=0,
    n_threads=8,  # Match your CPU cores
    n_ctx=2048  # Reduce for memory
)
```

### CUDA GPU

```python
llm = Llama(
    model_path="model.gguf",
    n_gpu_layers=-1,  # Offload all to GPU
    n_ctx=8192,
    offload_kqv=True
)
```

## Memory Requirements

| Model | Q4_K_M | RAM Needed |
|-------|--------|------------|
| 7B | ~4 GB | 8 GB |
| 13B | ~7 GB | 16 GB |
| 30B | ~17 GB | 32 GB |
| 70B | ~38 GB | 64 GB |

## Common Issues

**Model loading fails:**

- Check GGUF file integrity
- Ensure enough RAM available
- Reduce `n_ctx` if memory constrained

**Slow inference:**

- Enable GPU offloading (`n_gpu_layers=-1`)
- Use faster quantization (Q4_K_M vs Q6_K)
- Reduce context window

**Metal not working (macOS):**

```bash
CMAKE_ARGS="-DLLAMA_METAL=on" pip install llama-cpp-python --force-reinstall
```

## vs Alternatives

| Tool | Best For |
|------|----------|
| **llama.cpp** | Local/edge, CPU/Metal, single-user |
| vLLM | Production APIs, high throughput |
| TensorRT-LLM | NVIDIA GPUs, maximum performance |
| Ollama | Simpler local setup, less control |

## Resources

- GitHub: <https://github.com/ggerganov/llama.cpp>
- Python Bindings: <https://github.com/abetlen/llama-cpp-python>
- GGUF Models: <https://huggingface.co/TheBloke>
