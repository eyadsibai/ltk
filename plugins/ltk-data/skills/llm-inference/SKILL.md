---
name: llm-inference
description: Use when "LLM inference", "serving LLM", "vLLM", "llama.cpp", "GGUF", "text generation", "model serving", "inference optimization", "KV cache", "continuous batching", "speculative decoding", "local LLM", "CPU inference"
version: 1.0.0
---

# LLM Inference

High-performance inference engines for serving large language models.

---

## Engine Comparison

| Engine | Best For | Hardware | Throughput | Setup |
|--------|----------|----------|------------|-------|
| **vLLM** | Production serving | GPU | Highest | Medium |
| **llama.cpp** | Local/edge, CPU | CPU/GPU | Good | Easy |
| **TGI** | HuggingFace models | GPU | High | Easy |
| **Ollama** | Local desktop | CPU/GPU | Good | Easiest |
| **TensorRT-LLM** | NVIDIA production | NVIDIA GPU | Highest | Complex |

---

## Decision Guide

| Scenario | Recommendation |
|----------|----------------|
| Production API server | vLLM or TGI |
| Maximum throughput | vLLM |
| Local development | Ollama or llama.cpp |
| CPU-only deployment | llama.cpp |
| Edge/embedded | llama.cpp |
| Apple Silicon | llama.cpp with Metal |
| Quick experimentation | Ollama |
| Privacy-sensitive (no cloud) | llama.cpp |

---

## vLLM

Production-grade serving with PagedAttention for optimal GPU memory usage.

### Key Innovations

| Feature | What It Does |
|---------|--------------|
| **PagedAttention** | Non-contiguous KV cache, better memory utilization |
| **Continuous batching** | Dynamic request grouping for throughput |
| **Speculative decoding** | Small model drafts, large model verifies |

**Strengths**: Highest throughput, OpenAI-compatible API, multi-GPU
**Limitations**: GPU required, more complex setup

**Key concept**: Serves OpenAI-compatible endpoints—drop-in replacement for OpenAI API.

---

## llama.cpp

C++ inference for running models anywhere—laptops, phones, Raspberry Pi.

### Quantization Formats (GGUF)

| Format | Size (7B) | Quality | Use Case |
|--------|-----------|---------|----------|
| **Q8_0** | ~7 GB | Highest | When you have RAM |
| **Q6_K** | ~6 GB | High | Good balance |
| **Q5_K_M** | ~5 GB | Good | Balanced |
| **Q4_K_M** | ~4 GB | OK | Memory constrained |
| **Q2_K** | ~2.5 GB | Low | Minimum viable |

**Recommendation**: Q4_K_M for best quality/size balance.

### Memory Requirements

| Model Size | Q4_K_M | RAM Needed |
|------------|--------|------------|
| 7B | ~4 GB | 8 GB |
| 13B | ~7 GB | 16 GB |
| 30B | ~17 GB | 32 GB |
| 70B | ~38 GB | 64 GB |

### Platform Optimization

| Platform | Key Setting |
|----------|-------------|
| **Apple Silicon** | `n_gpu_layers=-1` (Metal offload) |
| **CUDA GPU** | `n_gpu_layers=-1` + `offload_kqv=True` |
| **CPU only** | `n_gpu_layers=0` + set `n_threads` to core count |

**Strengths**: Runs anywhere, GGUF format, Metal/CUDA support
**Limitations**: Lower throughput than vLLM, single-user focused

**Key concept**: GGUF format + quantization = run large models on consumer hardware.

---

## Key Optimization Concepts

| Technique | What It Does | When to Use |
|-----------|--------------|-------------|
| **KV Cache** | Reuse attention computations | Always (automatic) |
| **Continuous Batching** | Group requests dynamically | High-throughput serving |
| **Tensor Parallelism** | Split model across GPUs | Large models |
| **Quantization** | Reduce precision (fp16→int4) | Memory constrained |
| **Speculative Decoding** | Small model drafts, large verifies | Latency sensitive |
| **GPU Offloading** | Move layers to GPU | When GPU available |

---

## Common Parameters

| Parameter | Purpose | Typical Value |
|-----------|---------|---------------|
| **n_ctx** | Context window size | 2048-8192 |
| **n_gpu_layers** | Layers to offload | -1 (all) or 0 (none) |
| **temperature** | Randomness | 0.0-1.0 |
| **max_tokens** | Output limit | 100-2000 |
| **n_threads** | CPU threads | Match core count |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Out of memory | Reduce n_ctx, use smaller quant |
| Slow inference | Enable GPU offload, use faster quant |
| Model won't load | Check GGUF integrity, check RAM |
| Metal not working | Reinstall with `-DLLAMA_METAL=on` |
| Poor quality | Use higher quant (Q5_K_M, Q6_K) |

## Resources

- vLLM: <https://docs.vllm.ai>
- llama.cpp: <https://github.com/ggerganov/llama.cpp>
- TGI: <https://huggingface.co/docs/text-generation-inference>
- Ollama: <https://ollama.ai>
- GGUF Models: <https://huggingface.co/TheBloke>
