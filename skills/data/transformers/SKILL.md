---
name: transformers
description: Use when "HuggingFace Transformers", "pre-trained models", "pipeline API", or asking about "text generation", "text classification", "question answering", "NER", "fine-tuning transformers", "AutoModel", "Trainer API"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/transformers -->

# HuggingFace Transformers

Access thousands of pre-trained models for NLP, vision, audio, and multimodal tasks.

## When to Use

- Quick inference with pipelines
- Text generation, classification, QA, NER
- Image classification, object detection
- Fine-tuning on custom datasets
- Loading pre-trained models from HuggingFace Hub

## Quick Start

```bash
pip install torch transformers datasets
```

```python
from transformers import pipeline

# Text generation
generator = pipeline("text-generation", model="gpt2")
result = generator("The future of AI is", max_length=50)

# Text classification
classifier = pipeline("text-classification")
result = classifier("This movie was excellent!")

# Question answering
qa = pipeline("question-answering")
result = qa(question="What is AI?", context="AI is artificial intelligence...")
```

## Pipeline Tasks

```python
# NLP tasks
pipeline("text-generation")        # Generate text
pipeline("text-classification")    # Sentiment, etc.
pipeline("question-answering")     # Extract answers
pipeline("summarization")          # Summarize text
pipeline("translation_en_to_fr")   # Translate
pipeline("ner")                    # Named entity recognition
pipeline("fill-mask")              # Predict masked words

# Vision tasks
pipeline("image-classification")
pipeline("object-detection")

# Audio tasks
pipeline("automatic-speech-recognition")
pipeline("audio-classification")
```

## Custom Model Usage

```python
from transformers import AutoModelForCausalLM, AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("gpt2")
model = AutoModelForCausalLM.from_pretrained("gpt2")

inputs = tokenizer("Hello, I am", return_tensors="pt")
outputs = model.generate(**inputs, max_new_tokens=50)
text = tokenizer.decode(outputs[0])
```

## Device Placement

```python
# Auto device mapping (GPU if available)
model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-2-7b-hf",
    device_map="auto",
    torch_dtype="auto"
)

# Specific device
model = AutoModelForCausalLM.from_pretrained("gpt2").to("cuda")
```

## Generation Parameters

```python
outputs = model.generate(
    inputs["input_ids"],
    max_new_tokens=100,
    temperature=0.7,      # Randomness (0=deterministic, 1=random)
    top_p=0.9,            # Nucleus sampling
    top_k=50,             # Top-k sampling
    do_sample=True,       # Enable sampling
    num_beams=4,          # Beam search (set do_sample=False)
    repetition_penalty=1.2
)
```

## Fine-Tuning with Trainer

```python
from transformers import Trainer, TrainingArguments, AutoModelForSequenceClassification

model = AutoModelForSequenceClassification.from_pretrained("bert-base-uncased", num_labels=2)

training_args = TrainingArguments(
    output_dir="./results",
    num_train_epochs=3,
    per_device_train_batch_size=8,
    per_device_eval_batch_size=8,
    learning_rate=2e-5,
    weight_decay=0.01,
    evaluation_strategy="epoch",
    save_strategy="epoch",
    load_best_model_at_end=True,
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=eval_dataset,
)

trainer.train()
trainer.save_model("./my-model")
```

## Tokenization

```python
from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")

# Single text
encoded = tokenizer("Hello world", return_tensors="pt")
# encoded.input_ids, encoded.attention_mask

# Batch with padding
encoded = tokenizer(
    ["Hello", "Hello world"],
    padding=True,
    truncation=True,
    max_length=512,
    return_tensors="pt"
)
```

## Save and Load

```python
# Save locally
model.save_pretrained("./my-model")
tokenizer.save_pretrained("./my-model")

# Load locally
model = AutoModel.from_pretrained("./my-model")

# Push to Hub
model.push_to_hub("my-username/my-model")
tokenizer.push_to_hub("my-username/my-model")
```

## Quantization

```python
from transformers import BitsAndBytesConfig

# 4-bit quantization
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_compute_dtype="float16"
)

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-2-7b-hf",
    quantization_config=bnb_config,
    device_map="auto"
)
```

## Best Practices

1. **Use pipelines** for quick inference
2. **Use device_map="auto"** for automatic GPU placement
3. **Use torch_dtype="auto"** for optimal precision
4. **Batch inputs** for better throughput
5. **Use quantization** for large models on limited GPU
6. **Fine-tune with Trainer** for best practices built-in

## Resources

- Docs: <https://huggingface.co/docs/transformers>
- Model Hub: <https://huggingface.co/models>
- Course: <https://huggingface.co/course>
