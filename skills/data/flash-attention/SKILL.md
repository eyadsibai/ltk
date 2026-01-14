---
name: flash-attention
description: Use when "Flash Attention", "attention optimization", "transformer speedup", "memory-efficient attention", or asking about "SDPA", "long context", "GPU memory", "attention performance", "sequence length optimization"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/10-optimization/flash-attention -->

# Flash Attention - Fast Memory-Efficient Attention

2-4x speedup and 10-20x memory reduction for transformer attention.

## When to Use

- Training transformers with sequences >512 tokens
- Running inference with long context (>2K tokens)
- GPU memory constrained (OOM with standard attention)
- Need speedup without accuracy loss

## Quick Start

### PyTorch Native (PyTorch 2.2+)

```python
import torch
import torch.nn.functional as F

q = torch.randn(2, 8, 512, 64, device='cuda', dtype=torch.float16)
k = torch.randn(2, 8, 512, 64, device='cuda', dtype=torch.float16)
v = torch.randn(2, 8, 512, 64, device='cuda', dtype=torch.float16)

# Automatically uses Flash Attention if available
out = F.scaled_dot_product_attention(q, k, v)
```

### flash-attn Library

```bash
pip install flash-attn --no-build-isolation
```

```python
from flash_attn import flash_attn_func

# q, k, v: [batch, seqlen, nheads, headdim]
out = flash_attn_func(q, k, v, dropout_p=0.0, causal=True)
```

## Enable in Existing Models

```python
# Before (standard attention)
attn_weights = torch.softmax(q @ k.transpose(-2, -1) / math.sqrt(d_k), dim=-1)
out = attn_weights @ v

# After (Flash Attention)
out = F.scaled_dot_product_attention(q, k, v, attn_mask=mask)
```

### Force Flash Attention Backend

```python
with torch.backends.cuda.sdp_kernel(
    enable_flash=True,
    enable_math=False,
    enable_mem_efficient=False
):
    out = F.scaled_dot_product_attention(q, k, v)
```

## Advanced Features

### Multi-Query Attention

```python
from flash_attn import flash_attn_func

# q: [batch, seq, num_q_heads, dim]
# k, v: [batch, seq, num_kv_heads, dim]  # Fewer KV heads
out = flash_attn_func(q, k, v)  # Automatically handles MQA
```

### Sliding Window Attention

```python
# Attend to window of 256 tokens before/after
out = flash_attn_func(
    q, k, v,
    window_size=(256, 256),
    causal=True
)
```

## Performance by Sequence Length

| Sequence Length | Speedup |
|-----------------|---------|
| <512 tokens | 10-20% |
| 512-2K tokens | 2-3x |
| >2K tokens | 3-4x |

## HuggingFace Integration

```python
from transformers import AutoModelForCausalLM

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-2-7b-hf",
    attn_implementation="flash_attention_2",
    torch_dtype=torch.float16
)
```

## Common Issues

**ImportError: cannot import flash_attn:**

```bash
pip install flash-attn --no-build-isolation
```

**Slower than expected:**
Flash Attention benefits increase with sequence length. Verify sequences are >512 tokens.

**CUDA error:**

```python
import torch
print(torch.cuda.get_device_capability())
# Needs >= (7, 5) for Turing+
```

**GPU Support:**

- Ampere (A100, A10): Full support
- Turing (T4): Supported
- Volta (V100): Not supported

## Hardware Requirements

- **GPU**: NVIDIA Ampere+ (A100, A10, A30) or AMD MI200+
- **CUDA**: 12.0+ (11.8 minimum)
- **PyTorch**: 2.2+ for native support

## Resources

- Paper: "FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness"
- GitHub: <https://github.com/Dao-AILab/flash-attention>
- PyTorch docs: <https://pytorch.org/docs/stable/generated/torch.nn.functional.scaled_dot_product_attention.html>
