---
name: vllm-serving
description: Use when "vLLM", "LLM serving", "PagedAttention", "model inference server", "OpenAI-compatible API", or asking about "high throughput inference", "continuous batching", "deploying LLMs", "inference latency", "tensor parallelism"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/12-inference-serving/vllm -->

# vLLM - High-Performance LLM Serving

High-throughput LLM serving with PagedAttention and continuous batching.

## When to Use

- Deploying production LLM APIs (100+ req/sec)
- Serving OpenAI-compatible endpoints
- Limited GPU memory but need large models
- Multi-user applications (chatbots, assistants)
- Need low latency with high throughput

## Quick Start

```bash
pip install vllm
```

### Basic Offline Inference

```python
from vllm import LLM, SamplingParams

llm = LLM(model="meta-llama/Llama-3-8B-Instruct")
sampling = SamplingParams(temperature=0.7, max_tokens=256)

outputs = llm.generate(["Explain quantum computing"], sampling)
print(outputs[0].outputs[0].text)
```

### OpenAI-Compatible Server

```bash
vllm serve meta-llama/Llama-3-8B-Instruct

# Query with OpenAI SDK
python -c "
from openai import OpenAI
client = OpenAI(base_url='http://localhost:8000/v1', api_key='EMPTY')
print(client.chat.completions.create(
    model='meta-llama/Llama-3-8B-Instruct',
    messages=[{'role': 'user', 'content': 'Hello!'}]
).choices[0].message.content)
"
```

## Server Configuration

### Single GPU (7B-13B models)

```bash
vllm serve meta-llama/Llama-3-8B-Instruct \
  --gpu-memory-utilization 0.9 \
  --max-model-len 8192 \
  --port 8000
```

### Multi-GPU (30B-70B models)

```bash
vllm serve meta-llama/Llama-2-70b-hf \
  --tensor-parallel-size 4 \
  --gpu-memory-utilization 0.9 \
  --quantization awq \
  --port 8000
```

### Production with Monitoring

```bash
vllm serve meta-llama/Llama-3-8B-Instruct \
  --gpu-memory-utilization 0.9 \
  --enable-prefix-caching \
  --enable-metrics \
  --metrics-port 9090 \
  --port 8000 \
  --host 0.0.0.0
```

## Quantization Options

| Method | Best For | VRAM Reduction |
|--------|----------|----------------|
| AWQ | 70B models, minimal accuracy loss | ~4x |
| GPTQ | Wide model support, good compression | ~4x |
| FP8 | H100 GPUs, fastest inference | ~2x |

```bash
# Using pre-quantized model
vllm serve TheBloke/Llama-2-70B-AWQ \
  --quantization awq \
  --tensor-parallel-size 1 \
  --gpu-memory-utilization 0.95
```

## Key Metrics

Monitor via Prometheus (port 9090):

- `vllm:time_to_first_token_seconds` - Latency
- `vllm:num_requests_running` - Active requests
- `vllm:gpu_cache_usage_perc` - KV cache utilization

### Performance Targets

| Metric | Target |
|--------|--------|
| TTFT (short prompts) | < 500ms |
| Throughput | > 100 req/sec |
| GPU Utilization | > 80% |

## Common Issues

**Out of memory:**

```bash
vllm serve MODEL \
  --gpu-memory-utilization 0.7 \
  --max-model-len 4096
```

**Slow first token (TTFT > 1s):**

```bash
vllm serve MODEL --enable-prefix-caching
```

**Model not found:**

```bash
vllm serve MODEL --trust-remote-code
```

**Low throughput (<50 req/sec):**

```bash
vllm serve MODEL --max-num-seqs 512
```

## vs Alternatives

| Tool | Best For |
|------|----------|
| **vLLM** | Production APIs, high throughput |
| llama.cpp | CPU/edge inference, single-user |
| TensorRT-LLM | NVIDIA-only, maximum performance |
| HuggingFace | Research, prototyping |

## Hardware Requirements

| Model Size | GPU Recommendation |
|------------|-------------------|
| 7B-13B | 1x A10 (24GB) or A100 (40GB) |
| 30B-40B | 2x A100 (40GB) with tensor parallelism |
| 70B+ | 4x A100 (40GB) or 2x A100 (80GB) |

## Resources

- Docs: <https://docs.vllm.ai>
- GitHub: <https://github.com/vllm-project/vllm>
