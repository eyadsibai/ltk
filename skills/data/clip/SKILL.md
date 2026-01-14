---
name: clip
description: Use when "CLIP", "OpenAI CLIP", "vision-language model", or asking about "zero-shot image classification", "image-text similarity", "semantic image search", "content moderation", "cross-modal retrieval"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/18-multimodal/clip -->

# CLIP - Contrastive Language-Image Pre-Training

OpenAI's model connecting vision and language. Zero-shot image classification without training.

## When to Use

- Zero-shot image classification
- Image-text similarity matching
- Semantic image search
- Content moderation
- Cross-modal retrieval (image↔text)

## Quick Start

```bash
pip install git+https://github.com/openai/CLIP.git
pip install torch torchvision ftfy regex tqdm
```

```python
import torch
import clip
from PIL import Image

# Load model
device = "cuda" if torch.cuda.is_available() else "cpu"
model, preprocess = clip.load("ViT-B/32", device=device)

# Load image
image = preprocess(Image.open("photo.jpg")).unsqueeze(0).to(device)

# Define labels
text = clip.tokenize(["a dog", "a cat", "a bird"]).to(device)

# Compute similarity
with torch.no_grad():
    logits_per_image, _ = model(image, text)
    probs = logits_per_image.softmax(dim=-1).cpu().numpy()

labels = ["a dog", "a cat", "a bird"]
for label, prob in zip(labels, probs[0]):
    print(f"{label}: {prob:.2%}")
```

## Available Models

```python
# Models (sorted by quality)
models = ["RN50", "RN101", "ViT-B/32", "ViT-B/16", "ViT-L/14"]
model, preprocess = clip.load("ViT-B/32")  # Recommended
```

| Model | Parameters | Speed | Quality |
|-------|------------|-------|---------|
| RN50 | 102M | Fast | Good |
| ViT-B/32 | 151M | Medium | Better |
| ViT-L/14 | 428M | Slow | Best |

## Image-Text Similarity

```python
# Compute embeddings
image_features = model.encode_image(image)
text_features = model.encode_text(text)

# Normalize
image_features /= image_features.norm(dim=-1, keepdim=True)
text_features /= text_features.norm(dim=-1, keepdim=True)

# Cosine similarity
similarity = (image_features @ text_features.T).item()
print(f"Similarity: {similarity:.4f}")
```

## Semantic Image Search

```python
# Index images
image_embeddings = []
for img_path in image_paths:
    image = preprocess(Image.open(img_path)).unsqueeze(0).to(device)
    with torch.no_grad():
        embedding = model.encode_image(image)
        embedding /= embedding.norm(dim=-1, keepdim=True)
    image_embeddings.append(embedding)

image_embeddings = torch.cat(image_embeddings)

# Search with text
query = "a sunset over the ocean"
text_input = clip.tokenize([query]).to(device)
with torch.no_grad():
    text_embedding = model.encode_text(text_input)
    text_embedding /= text_embedding.norm(dim=-1, keepdim=True)

# Find most similar
similarities = (text_embedding @ image_embeddings.T).squeeze(0)
top_k = similarities.topk(5)

for idx, score in zip(top_k.indices, top_k.values):
    print(f"{image_paths[idx]}: {score:.3f}")
```

## Content Moderation

```python
categories = ["safe for work", "not safe for work", "violent content"]
text = clip.tokenize(categories).to(device)

with torch.no_grad():
    logits_per_image, _ = model(image, text)
    probs = logits_per_image.softmax(dim=-1)

max_idx = probs.argmax().item()
print(f"Category: {categories[max_idx]} ({probs[0, max_idx]:.2%})")
```

## Batch Processing

```python
# Multiple images
images = [preprocess(Image.open(f"img{i}.jpg")) for i in range(10)]
images = torch.stack(images).to(device)

with torch.no_grad():
    image_features = model.encode_image(images)
    image_features /= image_features.norm(dim=-1, keepdim=True)

# Similarity matrix (10 images x 3 texts)
similarities = image_features @ text_features.T
```

## Integration with Vector Databases

```python
import chromadb

client = chromadb.Client()
collection = client.create_collection("image_embeddings")

for img_path, embedding in zip(image_paths, image_embeddings):
    collection.add(
        embeddings=[embedding.cpu().numpy().tolist()],
        metadatas=[{"path": img_path}],
        ids=[img_path]
    )

# Query with text
results = collection.query(
    query_embeddings=[text_embedding.cpu().numpy().tolist()],
    n_results=5
)
```

## Best Practices

1. **Use ViT-B/32** for most cases - good balance
2. **Normalize embeddings** for cosine similarity
3. **Batch processing** for efficiency
4. **Cache embeddings** - expensive to recompute
5. **Use descriptive labels** for better zero-shot
6. **GPU recommended** - 10-50× faster

## Limitations

- Not for fine-grained classification
- Requires descriptive text labels
- May have dataset biases
- No bounding boxes (whole image only)
- Limited spatial understanding

## Resources

- GitHub: <https://github.com/openai/CLIP>
- Paper: <https://arxiv.org/abs/2103.00020>
