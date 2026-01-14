---
name: accelerate
description: Use when "HuggingFace Accelerate", "distributed training", "multi-GPU training", or asking about "DDP", "FSDP", "DeepSpeed integration", "mixed precision", "gradient accumulation", "accelerate launch"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/08-distributed-training/accelerate -->

# HuggingFace Accelerate - Unified Distributed Training

Simplify distributed training with 4 lines of code. Works with DDP, DeepSpeed, FSDP.

## When to Use

- Scale PyTorch training to multi-GPU/multi-node
- Need unified API for DDP, DeepSpeed, FSDP
- Want minimal code changes for distributed training
- HuggingFace ecosystem integration

## Quick Start

```bash
pip install accelerate
```

**Add 4 lines to any PyTorch script:**

```python
import torch
from accelerate import Accelerator  # +1

accelerator = Accelerator()  # +2

model = torch.nn.Linear(10, 2)
optimizer = torch.optim.Adam(model.parameters())
dataloader = torch.utils.data.DataLoader(dataset, batch_size=32)

model, optimizer, dataloader = accelerator.prepare(model, optimizer, dataloader)  # +3

for batch in dataloader:
    optimizer.zero_grad()
    loss = model(batch).mean()
    accelerator.backward(loss)  # +4
    optimizer.step()
```

**Run:**

```bash
# Single GPU
accelerate launch train.py

# Multi-GPU (8 GPUs)
accelerate launch --multi_gpu --num_processes 8 train.py
```

## Interactive Configuration

```bash
accelerate config
```

Questions:

- Which machine? (single/multi GPU/TPU/CPU)
- Mixed precision? (no/fp16/bf16/fp8)
- DeepSpeed? (no/yes)

## Mixed Precision Training

```python
# FP16 (with gradient scaling)
accelerator = Accelerator(mixed_precision='fp16')

# BF16 (more stable, no scaling)
accelerator = Accelerator(mixed_precision='bf16')

# FP8 (H100+ GPUs)
accelerator = Accelerator(mixed_precision='fp8')

model, optimizer, dataloader = accelerator.prepare(model, optimizer, dataloader)
# Everything else is automatic
```

## DeepSpeed Integration

```python
from accelerate import Accelerator

accelerator = Accelerator(
    mixed_precision='bf16',
    deepspeed_plugin={
        "zero_stage": 2,  # ZeRO-2
        "offload_optimizer": False,
        "gradient_accumulation_steps": 4
    }
)

# Same code as before
model, optimizer, dataloader = accelerator.prepare(model, optimizer, dataloader)
```

## FSDP (Fully Sharded Data Parallel)

```python
from accelerate import Accelerator, FullyShardedDataParallelPlugin

fsdp_plugin = FullyShardedDataParallelPlugin(
    sharding_strategy="FULL_SHARD",  # ZeRO-3 equivalent
    auto_wrap_policy="TRANSFORMER_AUTO_WRAP",
    cpu_offload=False
)

accelerator = Accelerator(
    mixed_precision='bf16',
    fsdp_plugin=fsdp_plugin
)
```

## Gradient Accumulation

```python
accelerator = Accelerator(gradient_accumulation_steps=4)

model, optimizer, dataloader = accelerator.prepare(model, optimizer, dataloader)

for batch in dataloader:
    with accelerator.accumulate(model):  # Handles accumulation
        optimizer.zero_grad()
        loss = model(batch)
        accelerator.backward(loss)
        optimizer.step()
```

**Effective batch size**: `batch_size * num_gpus * gradient_accumulation_steps`

## Checkpointing

```python
# Save (only on main process)
if accelerator.is_main_process:
    accelerator.save_state('checkpoint/')

# Load (all processes)
accelerator.load_state('checkpoint/')
```

## Multi-Node Training

```bash
# On head node
accelerate launch --multi_gpu --num_processes 16 \
  --num_machines 2 --machine_rank 0 \
  --main_process_ip $MASTER_ADDR \
  train.py

# On worker node
accelerate launch --multi_gpu --num_processes 16 \
  --num_machines 2 --machine_rank 1 \
  --main_process_ip $MASTER_ADDR \
  train.py
```

## Common Issues

**Wrong device placement:**

```python
# DON'T manually move to device
# batch = batch.to('cuda')  # Wrong

# Accelerate handles it automatically after prepare()
```

**Reproducibility:**

```python
from accelerate.utils import set_seed
set_seed(42)  # Same results across runs
```

## Best Practices

1. **Use `accelerator.prepare()`** for model, optimizer, dataloader
2. **Use `accelerator.backward(loss)`** instead of `loss.backward()`
3. **Don't manually move tensors** to devices
4. **Use `with accelerator.accumulate(model)`** for gradient accumulation
5. **Check `accelerator.is_main_process`** for logging/saving

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Accelerate** | Simplest, unified API, HuggingFace ecosystem |
| PyTorch Lightning | High-level abstractions, callbacks |
| Ray Train | Multi-node orchestration, hyperparameter tuning |
| DeepSpeed | Maximum performance, direct API control |

## Resources

- Docs: <https://huggingface.co/docs/accelerate>
- GitHub: <https://github.com/huggingface/accelerate>
