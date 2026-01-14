---
name: unsloth-finetuning
description: Use when "Unsloth", "fast fine-tuning", "efficient LoRA", "QLoRA training", or asking about "2x faster training", "memory-efficient fine-tuning", "Llama fine-tuning", "Mistral fine-tuning", "low-memory training"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/03-fine-tuning/unsloth -->

# Unsloth Fast Fine-Tuning

2-5x faster training with 50-80% less memory using optimized kernels.

## When to Use

- Fine-tuning LLMs with limited GPU memory
- Need faster LoRA/QLoRA training
- Training Llama, Mistral, Gemma, or Qwen models
- Want efficient training without code changes

## Quick Start

```bash
pip install unsloth
```

### Basic Fine-Tuning

```python
from unsloth import FastLanguageModel

# Load model with 4-bit quantization
model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/llama-3-8b-bnb-4bit",
    max_seq_length=2048,
    load_in_4bit=True,
    dtype=None  # Auto-detect
)

# Add LoRA adapters
model = FastLanguageModel.get_peft_model(
    model,
    r=16,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj",
                   "gate_proj", "up_proj", "down_proj"],
    lora_alpha=16,
    lora_dropout=0,
    bias="none"
)
```

### Training with TRL

```python
from trl import SFTTrainer
from transformers import TrainingArguments

trainer = SFTTrainer(
    model=model,
    tokenizer=tokenizer,
    train_dataset=dataset,
    dataset_text_field="text",
    max_seq_length=2048,
    args=TrainingArguments(
        per_device_train_batch_size=2,
        gradient_accumulation_steps=4,
        warmup_steps=5,
        max_steps=60,
        learning_rate=2e-4,
        fp16=not torch.cuda.is_bf16_supported(),
        bf16=torch.cuda.is_bf16_supported(),
        output_dir="outputs",
    ),
)

trainer.train()
```

## Supported Models

| Model | Memory (4-bit) | Speed Improvement |
|-------|----------------|-------------------|
| Llama 3 8B | ~5 GB | 2-3x |
| Mistral 7B | ~4 GB | 2-3x |
| Gemma 7B | ~4 GB | 2-3x |
| Qwen 2 7B | ~4 GB | 2x |

## Memory Comparison

| Method | Llama 7B Memory |
|--------|-----------------|
| Full Fine-tune | ~28 GB |
| LoRA | ~14 GB |
| QLoRA | ~7 GB |
| Unsloth QLoRA | ~3.5 GB |

## Chat Format Training

```python
from unsloth import FastLanguageModel

# Use chat template
dataset = dataset.map(
    lambda x: {"text": tokenizer.apply_chat_template(
        [{"role": "user", "content": x["question"]},
         {"role": "assistant", "content": x["answer"]}],
        tokenize=False
    )}
)
```

## Save and Export

```python
# Save LoRA adapters
model.save_pretrained("lora_adapters")

# Merge and save full model
model.save_pretrained_merged("merged_model", tokenizer)

# Export to GGUF for llama.cpp
model.save_pretrained_gguf("gguf_model", tokenizer, quantization_method="q4_k_m")
```

## Common Issues

**CUDA OOM:** Reduce batch size or sequence length, enable gradient checkpointing.

**Slow training:** Ensure you're using FastLanguageModel, not regular transformers.

**Model not supported:** Check Unsloth's supported model list.

## Best Practices

1. **Use 4-bit quantization** for maximum memory savings
2. **Set proper LoRA rank** (r=16 or r=32)
3. **Use gradient checkpointing** for long sequences
4. **Export to GGUF** for llama.cpp deployment

## vs Alternatives

| Tool | Speed | Memory | Ease of Use |
|------|-------|--------|-------------|
| **Unsloth** | 2-5x | Best | Easy |
| PEFT/LoRA | 1x | Good | Easy |
| Axolotl | 1x | Good | Config-based |
| LLaMA-Factory | 1x | Good | GUI available |

## Resources

- GitHub: <https://github.com/unslothai/unsloth>
- Docs: <https://docs.unsloth.ai/>
- Colab: <https://colab.research.google.com/drive/1Ys44kVvmeZtnICzWz0xgpRnrIOjZAuxp>
