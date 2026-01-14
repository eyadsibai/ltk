---
name: sentence-transformers
description: Use when "Sentence Transformers", "SBERT", "text embeddings", or asking about "semantic similarity", "sentence embeddings", "semantic search", "embedding models", "all-MiniLM", "all-mpnet", "multilingual embeddings"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/15-rag/sentence-transformers -->

# Sentence Transformers - Text Embeddings

Framework for state-of-the-art sentence, text, and image embeddings.

## When to Use

- Generate embeddings for RAG pipelines
- Semantic similarity and search
- Text clustering and classification
- Multilingual embeddings (100+ languages)
- Local embeddings (no API needed)
- Cost-effective alternative to OpenAI embeddings

## Quick Start

```bash
pip install sentence-transformers
```

```python
from sentence_transformers import SentenceTransformer

# Load model
model = SentenceTransformer('all-MiniLM-L6-v2')

# Generate embeddings
sentences = [
    "This is an example sentence",
    "Each sentence is converted to a vector"
]

embeddings = model.encode(sentences)
print(embeddings.shape)  # (2, 384)

# Cosine similarity
from sentence_transformers.util import cos_sim
similarity = cos_sim(embeddings[0], embeddings[1])
print(f"Similarity: {similarity.item():.4f}")
```

## Popular Models

### General Purpose

```python
# Fast, good quality (384 dim)
model = SentenceTransformer('all-MiniLM-L6-v2')

# Better quality (768 dim)
model = SentenceTransformer('all-mpnet-base-v2')

# Best quality (1024 dim, slower)
model = SentenceTransformer('all-roberta-large-v1')
```

### Multilingual

```python
# 50+ languages
model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')

# 100+ languages
model = SentenceTransformer('paraphrase-multilingual-mpnet-base-v2')
```

## Semantic Search

```python
from sentence_transformers import SentenceTransformer, util

model = SentenceTransformer('all-MiniLM-L6-v2')

# Corpus
corpus = [
    "Python is a programming language",
    "Machine learning uses algorithms",
    "Neural networks are powerful"
]

# Encode corpus
corpus_embeddings = model.encode(corpus, convert_to_tensor=True)

# Query
query = "What is Python?"
query_embedding = model.encode(query, convert_to_tensor=True)

# Find most similar
hits = util.semantic_search(query_embedding, corpus_embeddings, top_k=3)
print(hits)
```

## Batch Encoding

```python
# Efficient batch processing
embeddings = model.encode(
    sentences,
    batch_size=32,
    show_progress_bar=True,
    convert_to_tensor=False  # or True for PyTorch tensors
)
```

## Similarity Functions

```python
from sentence_transformers.util import cos_sim, dot_score

# Cosine similarity
similarity = cos_sim(embedding1, embedding2)

# Dot product
similarity = dot_score(embedding1, embedding2)

# Pairwise similarity matrix
similarities = cos_sim(embeddings, embeddings)
```

## Fine-Tuning

```python
from sentence_transformers import InputExample, losses
from torch.utils.data import DataLoader

# Training data
train_examples = [
    InputExample(texts=['sentence 1', 'sentence 2'], label=0.8),
    InputExample(texts=['sentence 3', 'sentence 4'], label=0.3),
]

train_dataloader = DataLoader(train_examples, batch_size=16)
train_loss = losses.CosineSimilarityLoss(model)

# Train
model.fit(
    train_objectives=[(train_dataloader, train_loss)],
    epochs=10,
    warmup_steps=100
)

# Save
model.save('my-finetuned-model')
```

## LangChain Integration

```python
from langchain_community.embeddings import HuggingFaceEmbeddings

embeddings = HuggingFaceEmbeddings(
    model_name="sentence-transformers/all-mpnet-base-v2"
)

# Use with vector stores
from langchain_chroma import Chroma

vectorstore = Chroma.from_documents(
    documents=docs,
    embedding=embeddings
)
```

## Model Selection Guide

| Model | Dimensions | Speed | Quality | Use Case |
|-------|------------|-------|---------|----------|
| all-MiniLM-L6-v2 | 384 | Fast | Good | Prototyping |
| all-mpnet-base-v2 | 768 | Medium | Better | Production RAG |
| all-roberta-large-v1 | 1024 | Slow | Best | High accuracy |
| paraphrase-multilingual | 768 | Medium | Good | Multilingual |

## Performance

| Model | Speed (sentences/sec) | Memory | Dimension |
|-------|----------------------|---------|-----------|
| MiniLM | ~2000 | 120MB | 384 |
| MPNet | ~600 | 420MB | 768 |
| RoBERTa | ~300 | 1.3GB | 1024 |

## Best Practices

1. **Start with all-MiniLM-L6-v2** - Good baseline
2. **Use GPU if available** - 10x faster
3. **Batch encoding** - More efficient
4. **Cache embeddings** - Expensive to recompute
5. **Fine-tune for domain** - Improves quality
6. **Normalize for cosine** - Better similarity scores

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Sentence Transformers** | Local, free, customizable |
| OpenAI Embeddings | Highest quality, API-based |
| Cohere Embed | Managed service |
| Instructor | Task-specific instructions |

## Resources

- GitHub: <https://github.com/UKPLab/sentence-transformers>
- Models: <https://huggingface.co/sentence-transformers>
- Docs: <https://www.sbert.net>
