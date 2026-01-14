---
name: faiss
description: Use when "FAISS", "Facebook similarity search", "vector similarity", or asking about "k-NN search", "billion-scale vectors", "GPU similarity search", "IVF index", "HNSW index", "product quantization"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/15-rag/faiss -->

# FAISS - Efficient Similarity Search

Facebook AI's library for billion-scale vector similarity search.

## When to Use

- Fast similarity search on large datasets (millions/billions)
- GPU acceleration needed
- Pure vector similarity (no metadata filtering)
- High throughput, low latency critical
- Offline/batch processing of embeddings

## Quick Start

```bash
# CPU only
pip install faiss-cpu

# GPU support
pip install faiss-gpu
```

```python
import faiss
import numpy as np

# Sample data: 1000 vectors, 128 dimensions
d = 128
nb = 1000
vectors = np.random.random((nb, d)).astype('float32')

# Create index
index = faiss.IndexFlatL2(d)  # L2 distance
index.add(vectors)

# Search
k = 5  # Find 5 nearest neighbors
query = np.random.random((1, d)).astype('float32')
distances, indices = index.search(query, k)

print(f"Nearest neighbors: {indices}")
print(f"Distances: {distances}")
```

## Index Types

### Flat (Exact Search)

```python
# L2 (Euclidean) distance
index = faiss.IndexFlatL2(d)

# Inner product (cosine similarity if normalized)
index = faiss.IndexFlatIP(d)

# Slowest, most accurate
```

### IVF (Fast Approximate)

```python
# Create quantizer
quantizer = faiss.IndexFlatL2(d)

# IVF index with 100 clusters
nlist = 100
index = faiss.IndexIVFFlat(quantizer, d, nlist)

# Train on data
index.train(vectors)
index.add(vectors)

# Search (nprobe = clusters to search)
index.nprobe = 10
distances, indices = index.search(query, k)
```

### HNSW (Best Quality/Speed)

```python
# HNSW index
M = 32  # Connections per layer
index = faiss.IndexHNSWFlat(d, M)

# No training needed
index.add(vectors)
distances, indices = index.search(query, k)
```

### Product Quantization (Memory Efficient)

```python
# PQ reduces memory by 16-32x
m = 8   # Number of subquantizers
nbits = 8
index = faiss.IndexPQ(d, m, nbits)

index.train(vectors)
index.add(vectors)
```

## GPU Acceleration

```python
# Single GPU
res = faiss.StandardGpuResources()
index_cpu = faiss.IndexFlatL2(d)
index_gpu = faiss.index_cpu_to_gpu(res, 0, index_cpu)  # GPU 0

# Multi-GPU
index_gpu = faiss.index_cpu_to_all_gpus(index_cpu)

# 10-100x faster than CPU
```

## Save and Load

```python
# Save
faiss.write_index(index, "vectors.index")

# Load
index = faiss.read_index("vectors.index")
```

## LangChain Integration

```python
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings

# Create vector store
vectorstore = FAISS.from_documents(docs, OpenAIEmbeddings())

# Save
vectorstore.save_local("faiss_index")

# Load
vectorstore = FAISS.load_local(
    "faiss_index",
    OpenAIEmbeddings(),
    allow_dangerous_deserialization=True
)

# Search
results = vectorstore.similarity_search("query", k=5)
```

## Index Selection Guide

| Index Type | Build Time | Search Time | Memory | Accuracy |
|------------|------------|-------------|--------|----------|
| Flat | Fast | Slow | High | 100% |
| IVF | Medium | Fast | Medium | 95-99% |
| HNSW | Slow | Fastest | High | 99% |
| PQ | Medium | Fast | Low | 90-95% |

**Recommendations:**

- `< 10K vectors`: Flat (exact)
- `10K - 1M vectors`: IVF
- `> 1M vectors`: HNSW or IVF+PQ
- `Limited memory`: PQ

## Best Practices

1. **Normalize for cosine similarity** - Use IndexFlatIP with L2-normalized vectors
2. **Use GPU for large datasets** - 10-100x faster
3. **Save trained indices** - Training is expensive
4. **Tune nprobe/ef_search** - Balance speed vs accuracy
5. **Batch queries** - Better GPU utilization
6. **Use PQ for memory constraints** - 16-32x compression

## vs Alternatives

| Tool | Best For |
|------|----------|
| **FAISS** | Speed, GPU, billions of vectors |
| Chroma | Metadata filtering, developer-friendly |
| Pinecone | Managed cloud, auto-scaling |
| Qdrant | High performance, Rust-based |

## Resources

- GitHub: <https://github.com/facebookresearch/faiss>
- Wiki: <https://github.com/facebookresearch/faiss/wiki>
