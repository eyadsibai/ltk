---
name: vllm
description: Use when "vLLM", "LLM serving", "PagedAttention", or asking about "high-throughput inference", "OpenAI compatible server", "LLM deployment", "continuous batching", "GPU inference", "serve LLM"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/12-inference-serving/vllm -->

# vLLM - High-Performance LLM Serving

Fast LLM inference with PagedAttention and continuous batching. 24x higher throughput than standard transformers.

## When to Use

- Deploy production LLM APIs (100+ req/sec)
- Serve OpenAI-compatible endpoints
- Need high throughput with low latency
- Limited GPU memory for large models
- Multi-user applications (chatbots, assistants)

## Quick Start

```bash
pip install vllm
```

### Offline Inference

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
```

```python
from openai import OpenAI

client = OpenAI(base_url='http://localhost:8000/v1', api_key='EMPTY')
response = client.chat.completions.create(
    model='meta-llama/Llama-3-8B-Instruct',
    messages=[{'role': 'user', 'content': 'Hello!'}]
)
print(response.choices[0].message.content)
```

## Server Configuration

```bash
# Basic server
vllm serve meta-llama/Llama-3-8B-Instruct \
  --gpu-memory-utilization 0.9 \
  --max-model-len 8192 \
  --port 8000

# Large models with tensor parallelism
vllm serve meta-llama/Llama-2-70b-hf \
  --tensor-parallel-size 4 \
  --gpu-memory-utilization 0.9 \
  --quantization awq

# Production with metrics
vllm serve meta-llama/Llama-3-8B-Instruct \
  --enable-prefix-caching \
  --enable-metrics \
  --metrics-port 9090 \
  --host 0.0.0.0
```

## Quantization

```bash
# AWQ (best for 70B models)
vllm serve TheBloke/Llama-2-70B-AWQ \
  --quantization awq \
  --tensor-parallel-size 1

# GPTQ
vllm serve model-id --quantization gptq

# FP8 (H100 GPUs)
vllm serve model-id --quantization fp8
```

## Batch Inference

```python
from vllm import LLM, SamplingParams

llm = LLM(
    model="meta-llama/Llama-3-8B-Instruct",
    tensor_parallel_size=2,
    gpu_memory_utilization=0.9
)

sampling = SamplingParams(
    temperature=0.7,
    top_p=0.95,
    max_tokens=512,
    stop=["</s>", "\n\n"]
)

prompts = ["Prompt 1", "Prompt 2", ...]  # 1000s of prompts
outputs = llm.generate(prompts, sampling)  # Automatically batched

for output in outputs:
    print(output.outputs[0].text)
```

## Sampling Parameters

```python
sampling = SamplingParams(
    temperature=0.7,      # Randomness (0=deterministic)
    top_p=0.95,           # Nucleus sampling
    top_k=50,             # Top-k sampling
    max_tokens=512,       # Max output length
    stop=["</s>"],        # Stop sequences
    repetition_penalty=1.1
)
```

## Hardware Requirements

| Model Size | GPU Configuration |
|------------|-------------------|
| 7B-13B | 1x A10 (24GB) or A100 (40GB) |
| 30B-40B | 2x A100 (40GB) with tensor parallelism |
| 70B+ | 4x A100 (40GB) or use AWQ/GPTQ |

## Common Issues

**Out of memory:**

```bash
vllm serve MODEL \
  --gpu-memory-utilization 0.7 \
  --max-model-len 4096

# Or use quantization
vllm serve MODEL --quantization awq
```

**Slow first token:**

```bash
# Enable prefix caching
vllm serve MODEL --enable-prefix-caching

# Enable chunked prefill for long prompts
vllm serve MODEL --enable-chunked-prefill
```

**Low throughput:**

```bash
# Increase concurrent sequences
vllm serve MODEL --max-num-seqs 512
```

## Docker Deployment

```bash
docker run --gpus all -p 8000:8000 \
  vllm/vllm-openai:latest \
  --model meta-llama/Llama-3-8B-Instruct \
  --gpu-memory-utilization 0.9 \
  --enable-prefix-caching
```

## Monitoring

```bash
# Enable Prometheus metrics
vllm serve MODEL --enable-metrics --metrics-port 9090

# Key metrics
curl http://localhost:9090/metrics | grep vllm
# vllm:time_to_first_token_seconds
# vllm:num_requests_running
# vllm:gpu_cache_usage_perc
```

## Best Practices

1. **Use tensor parallelism** for large models (power of 2 GPUs)
2. **Enable prefix caching** for repeated prompts
3. **Use AWQ/GPTQ** for 70B+ models on limited VRAM
4. **Set gpu-memory-utilization** to 0.9 for max throughput
5. **Monitor TTFT and throughput** for production

## vs Alternatives

| Tool | Best For |
|------|----------|
| **vLLM** | High-throughput production APIs |
| llama.cpp | CPU/edge, single-user |
| TensorRT-LLM | NVIDIA-only, maximum performance |
| HuggingFace TGI | HuggingFace ecosystem |

## Resources

- Docs: <https://docs.vllm.ai>
- GitHub: <https://github.com/vllm-project/vllm>
- Paper: "PagedAttention" (SOSP 2023)
