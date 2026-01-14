---
name: trl
description: Use when "TRL", "Transformer Reinforcement Learning", "RLHF", "DPO training", or asking about "preference alignment", "SFT trainer", "reward model", "PPO training", "GRPO", "fine-tune with human feedback"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/06-post-training/trl-fine-tuning -->

# TRL - Transformer Reinforcement Learning

Post-training methods for aligning LLMs with human preferences.

## When to Use

- Supervised Fine-Tuning (SFT) for instruction following
- DPO for preference alignment without reward model
- PPO/GRPO for reinforcement learning with rewards
- Training reward models
- RLHF pipelines

## Quick Start

```bash
pip install trl transformers datasets peft accelerate
```

### Supervised Fine-Tuning (SFT)

```python
from trl import SFTTrainer

trainer = SFTTrainer(
    model="Qwen/Qwen2.5-0.5B",
    train_dataset=dataset,  # Prompt-completion pairs
)
trainer.train()
```

### DPO (Direct Preference Optimization)

```python
from trl import DPOTrainer, DPOConfig

config = DPOConfig(output_dir="model-dpo", beta=0.1)
trainer = DPOTrainer(
    model=model,
    args=config,
    train_dataset=preference_dataset,  # chosen/rejected pairs
    processing_class=tokenizer
)
trainer.train()
```

## SFT Training

```python
from transformers import AutoModelForCausalLM, AutoTokenizer
from trl import SFTTrainer, SFTConfig
from datasets import load_dataset

model = AutoModelForCausalLM.from_pretrained("Qwen/Qwen2.5-0.5B")
tokenizer = AutoTokenizer.from_pretrained("Qwen/Qwen2.5-0.5B")

dataset = load_dataset("trl-lib/Capybara", split="train")

training_args = SFTConfig(
    output_dir="Qwen2.5-0.5B-SFT",
    per_device_train_batch_size=4,
    num_train_epochs=1,
    learning_rate=2e-5,
)

trainer = SFTTrainer(
    model=model,
    args=training_args,
    train_dataset=dataset,
    tokenizer=tokenizer
)
trainer.train()
trainer.save_model()
```

## DPO Training

Dataset format:

```json
{
  "prompt": "What is the capital of France?",
  "chosen": "The capital of France is Paris.",
  "rejected": "I don't know."
}
```

```python
from trl import DPOTrainer, DPOConfig

config = DPOConfig(
    output_dir="model-DPO",
    per_device_train_batch_size=4,
    learning_rate=5e-7,
    beta=0.1,  # KL penalty strength
    max_prompt_length=512,
    max_length=1024,
)

trainer = DPOTrainer(
    model=model,
    args=config,
    train_dataset=preference_dataset,
    processing_class=tokenizer
)
trainer.train()
```

## Reward Model Training

```python
from transformers import AutoModelForSequenceClassification
from trl import RewardTrainer, RewardConfig

model = AutoModelForSequenceClassification.from_pretrained(
    "Qwen2.5-0.5B-SFT",
    num_labels=1  # Single reward score
)

config = RewardConfig(
    output_dir="reward-model",
    per_device_train_batch_size=2,
    learning_rate=1e-5,
)

trainer = RewardTrainer(
    model=model,
    args=config,
    processing_class=tokenizer,
    train_dataset=preference_dataset
)
trainer.train()
```

## GRPO (Memory-Efficient RL)

```python
from trl import GRPOTrainer, GRPOConfig

def reward_function(completions, **kwargs):
    """Custom reward function."""
    return [len(c.split()) for c in completions]  # Example: reward length

config = GRPOConfig(
    output_dir="model-GRPO",
    per_device_train_batch_size=4,
    num_generations=4,
    max_new_tokens=128,
)

trainer = GRPOTrainer(
    model="Qwen/Qwen2-0.5B-Instruct",
    reward_funcs=reward_function,
    args=config,
    train_dataset=prompts_dataset
)
trainer.train()
```

## CLI Usage

```bash
# SFT
trl sft --model_name_or_path Qwen/Qwen2.5-0.5B \
    --dataset_name trl-lib/Capybara \
    --output_dir model-sft

# DPO
trl dpo --model_name_or_path model-sft \
    --dataset_name argilla/Capybara-Preferences \
    --output_dir model-dpo \
    --beta 0.1
```

## Method Selection Guide

| Method | When to Use |
|--------|-------------|
| **SFT** | Have prompt-completion pairs, basic instruction following |
| **DPO** | Have preferences, want simple alignment (no reward model) |
| **PPO** | Have reward model, need maximum control |
| **GRPO** | Memory-constrained, want online RL |
| **Reward Model** | Building RLHF pipeline |

## Common Issues

**OOM during DPO:**

```python
config = DPOConfig(
    per_device_train_batch_size=1,
    max_length=512,
    gradient_accumulation_steps=8
)
model.gradient_checkpointing_enable()
```

**Poor alignment quality:**

```python
# Adjust beta (higher = more conservative)
config = DPOConfig(beta=0.5)  # Default 0.1
```

## Best Practices

1. **Start with SFT** before DPO/PPO
2. **Use LoRA** to reduce memory
3. **Enable gradient checkpointing** for large models
4. **Tune beta** for DPO (0.1-0.5 range)
5. **Validate preference data** quality

## Resources

- Docs: <https://huggingface.co/docs/trl>
- GitHub: <https://github.com/huggingface/trl>
