---
name: deepspeed-training
description: Use when "DeepSpeed", "ZeRO optimization", "distributed training", "multi-GPU training", or asking about "pipeline parallelism", "model parallelism", "gradient checkpointing", "memory optimization", "large model training"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/08-distributed-training/deepspeed -->

# DeepSpeed Distributed Training

Microsoft's deep learning optimization library for large-scale training.

## When to Use

- Training large models across multiple GPUs
- Model doesn't fit in single GPU memory
- Need ZeRO optimization for memory efficiency
- Training with pipeline/tensor parallelism
- Fine-tuning large language models

## Quick Start

```bash
pip install deepspeed
```

### Basic Training Script

```python
import deepspeed
import torch

model = MyModel()
optimizer = torch.optim.Adam(model.parameters())

# Initialize DeepSpeed
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

### DeepSpeed Config (ds_config.json)

```json
{
  "train_batch_size": 32,
  "gradient_accumulation_steps": 1,
  "fp16": {
    "enabled": true,
    "loss_scale": 0
  },
  "zero_optimization": {
    "stage": 2,
    "offload_optimizer": {
      "device": "cpu"
    }
  }
}
```

## ZeRO Optimization Stages

| Stage | Memory Savings | What's Partitioned |
|-------|---------------|-------------------|
| ZeRO-1 | ~4x | Optimizer states |
| ZeRO-2 | ~8x | + Gradients |
| ZeRO-3 | ~N x | + Parameters |

### ZeRO Stage 2 (Recommended Start)

```json
{
  "zero_optimization": {
    "stage": 2,
    "allgather_partitions": true,
    "reduce_scatter": true
  }
}
```

### ZeRO Stage 3 (Maximum Memory Savings)

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

## With HuggingFace Transformers

```python
from transformers import Trainer, TrainingArguments

training_args = TrainingArguments(
    output_dir="./output",
    per_device_train_batch_size=4,
    deepspeed="ds_config.json",
    fp16=True
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset
)

trainer.train()
```

## Launch Commands

```bash
# Single node, 4 GPUs
deepspeed --num_gpus=4 train.py --deepspeed_config ds_config.json

# Multi-node
deepspeed --hostfile=hostfile.txt train.py --deepspeed_config ds_config.json
```

## Common Configurations

### Memory-Efficient Fine-Tuning

```json
{
  "train_batch_size": 16,
  "fp16": {"enabled": true},
  "zero_optimization": {
    "stage": 2,
    "offload_optimizer": {"device": "cpu"}
  },
  "gradient_checkpointing": true
}
```

### Maximum Throughput

```json
{
  "train_batch_size": 64,
  "bf16": {"enabled": true},
  "zero_optimization": {
    "stage": 1
  },
  "gradient_accumulation_steps": 4
}
```

## Debugging

```bash
# Check DeepSpeed installation
ds_report

# Enable verbose logging
deepspeed --num_gpus=4 train.py --deepspeed_config ds_config.json 2>&1 | tee train.log
```

## Common Issues

**OOM with ZeRO-2:** Try ZeRO-3 or enable CPU offload.

**Slow training with CPU offload:** Use NVMe offload or reduce offload.

**Gradient overflow:** Enable loss scaling in fp16 config.

## vs Alternatives

| Tool | Best For |
|------|----------|
| **DeepSpeed** | Large models, ZeRO optimization |
| FSDP | PyTorch native, simpler setup |
| Megatron | Maximum scale, expert users |

## Resources

- GitHub: <https://github.com/microsoft/DeepSpeed>
- Docs: <https://www.deepspeed.ai/>
- HuggingFace Integration: <https://huggingface.co/docs/transformers/main_classes/deepspeed>
