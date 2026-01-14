---
name: deepspeed
description: Use when "DeepSpeed", "ZeRO optimizer", "ZeRO-3", or asking about "memory-efficient training", "CPU offloading", "pipeline parallelism", "1-bit Adam", "large model training", "Microsoft distributed training"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/08-distributed-training/deepspeed -->

# DeepSpeed - Large-Scale Distributed Training

Microsoft's library for memory-efficient training with ZeRO optimization.

## When to Use

- Training models too large for single GPU
- ZeRO optimizer stages (1, 2, 3)
- CPU/NVMe offloading for huge models
- Pipeline and tensor parallelism
- Maximum training efficiency

## Quick Start

```bash
pip install deepspeed
```

```python
import deepspeed
import torch

model = MyModel()
optimizer = torch.optim.AdamW(model.parameters())

# Wrap with DeepSpeed
model_engine, optimizer, _, _ = deepspeed.initialize(
    model=model,
    optimizer=optimizer,
    config="ds_config.json"
)

# Training loop
for batch in dataloader:
    loss = model_engine(batch)
    model_engine.backward(loss)
    model_engine.step()
```

## ZeRO Optimization Stages

### ZeRO-1: Optimizer State Partitioning

```json
{
    "zero_optimization": {
        "stage": 1
    }
}
```

Memory reduction: ~4x for optimizer states

### ZeRO-2: Gradient Partitioning

```json
{
    "zero_optimization": {
        "stage": 2,
        "allgather_bucket_size": 5e8,
        "reduce_bucket_size": 5e8
    }
}
```

Memory reduction: ~8x

### ZeRO-3: Parameter Partitioning

```json
{
    "zero_optimization": {
        "stage": 3,
        "offload_param": {
            "device": "cpu"
        },
        "offload_optimizer": {
            "device": "cpu"
        }
    }
}
```

Memory reduction: Linear with GPU count

## Full Configuration Example

```json
{
    "train_batch_size": 32,
    "gradient_accumulation_steps": 4,
    "fp16": {
        "enabled": true,
        "loss_scale": 0,
        "initial_scale_power": 16
    },
    "zero_optimization": {
        "stage": 2,
        "offload_optimizer": {
            "device": "cpu",
            "pin_memory": true
        },
        "allgather_bucket_size": 5e8,
        "reduce_bucket_size": 5e8
    },
    "optimizer": {
        "type": "AdamW",
        "params": {
            "lr": 1e-5,
            "weight_decay": 0.01
        }
    },
    "scheduler": {
        "type": "WarmupLR",
        "params": {
            "warmup_min_lr": 0,
            "warmup_max_lr": 1e-5,
            "warmup_num_steps": 1000
        }
    }
}
```

## HuggingFace Integration

```python
from transformers import TrainingArguments, Trainer

training_args = TrainingArguments(
    output_dir="./output",
    deepspeed="ds_config.json",  # DeepSpeed config file
    per_device_train_batch_size=4,
    gradient_accumulation_steps=8,
    fp16=True,
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
)

trainer.train()
```

## Accelerate Integration

```python
from accelerate import Accelerator

accelerator = Accelerator(
    mixed_precision='bf16',
    deepspeed_plugin={
        "zero_stage": 2,
        "offload_optimizer": False,
        "gradient_accumulation_steps": 4
    }
)

model, optimizer, dataloader = accelerator.prepare(model, optimizer, dataloader)
```

## CPU Offloading

```json
{
    "zero_optimization": {
        "stage": 3,
        "offload_param": {
            "device": "cpu",
            "pin_memory": true
        },
        "offload_optimizer": {
            "device": "cpu",
            "pin_memory": true
        }
    }
}
```

## Mixed Precision

```json
{
    "fp16": {
        "enabled": true,
        "loss_scale": 0,
        "initial_scale_power": 16
    }
}
```

Or BF16 (more stable):

```json
{
    "bf16": {
        "enabled": true
    }
}
```

## Launch Training

```bash
# Single node, multi-GPU
deepspeed train.py --deepspeed_config ds_config.json

# With specific GPUs
deepspeed --include localhost:0,1,2,3 train.py

# Multi-node
deepspeed --hostfile hostfile train.py
```

## ZeRO Stage Selection Guide

| Stage | Memory Savings | Speed | Use Case |
|-------|---------------|-------|----------|
| ZeRO-1 | ~4x | Fastest | Large batch training |
| ZeRO-2 | ~8x | Fast | Most use cases |
| ZeRO-3 | Linear | Slower | Huge models (100B+) |
| ZeRO-3 + Offload | Maximum | Slowest | Limited GPU memory |

## Common Issues

**OOM with ZeRO-2:**

Switch to ZeRO-3 or enable CPU offloading.

**Slow training with offloading:**

Ensure `pin_memory: true` and use fast CPU.

**Gradient overflow:**

Reduce learning rate or use BF16 instead of FP16.

## Best Practices

1. **Start with ZeRO-2** - Best balance of speed and memory
2. **Use ZeRO-3** only for huge models (70B+)
3. **Enable gradient checkpointing** for more memory savings
4. **Use BF16** when available (more stable than FP16)
5. **Pin memory** when using CPU offloading

## vs Alternatives

| Tool | Best For |
|------|----------|
| **DeepSpeed** | Maximum memory efficiency, huge models |
| FSDP | PyTorch native, simpler API |
| Accelerate | Unified API, HuggingFace ecosystem |
| Megatron-LM | NVIDIA GPUs, tensor parallelism |

## Resources

- Docs: <https://www.deepspeed.ai>
- GitHub: <https://github.com/microsoft/DeepSpeed>
