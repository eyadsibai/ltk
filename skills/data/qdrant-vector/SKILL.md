---
name: qdrant-vector
description: Use when "Qdrant", "vector database", "vector search", "semantic search", "embedding storage", or asking about "HNSW index", "similarity search", "RAG retrieval", "vector filtering", "hybrid search"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/15-rag/qdrant -->

# Qdrant Vector Database

High-performance vector similarity search for RAG and semantic search.

## When to Use

- Building production RAG systems requiring low latency
- Need hybrid search (vectors + metadata filtering)
- Require horizontal scaling with sharding/replication
- Want on-premise deployment with full data control
- Need multi-vector storage per record (dense + sparse)

## Quick Start

```bash
# Python client
pip install qdrant-client

# Docker (recommended for development)
docker run -p 6333:6333 -p 6334:6334 qdrant/qdrant
```

### Basic Usage

```python
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct

client = QdrantClient(host="localhost", port=6333)

# Create collection
client.create_collection(
    collection_name="documents",
    vectors_config=VectorParams(size=384, distance=Distance.COSINE)
)

# Insert vectors with payload
client.upsert(
    collection_name="documents",
    points=[
        PointStruct(
            id=1,
            vector=[0.1, 0.2, ...],  # 384-dim vector
            payload={"title": "Doc 1", "category": "tech"}
        )
    ]
)

# Search with filtering
results = client.search(
    collection_name="documents",
    query_vector=[0.15, 0.25, ...],
    query_filter={
        "must": [{"key": "category", "match": {"value": "tech"}}]
    },
    limit=10
)
```

## Distance Metrics

| Metric | Use Case | Range |
|--------|----------|-------|
| COSINE | Text embeddings, normalized vectors | 0 to 2 |
| EUCLID | Spatial data, image features | 0 to infinity |
| DOT | Recommendations, unnormalized | -infinity to infinity |

## RAG Integration

### With Sentence Transformers

```python
from sentence_transformers import SentenceTransformer
from qdrant_client import QdrantClient
from qdrant_client.models import VectorParams, Distance, PointStruct

encoder = SentenceTransformer("all-MiniLM-L6-v2")
client = QdrantClient(host="localhost", port=6333)

client.create_collection(
    collection_name="knowledge_base",
    vectors_config=VectorParams(size=384, distance=Distance.COSINE)
)

# Index documents
documents = [
    {"id": 1, "text": "Python is a programming language"},
    {"id": 2, "text": "Machine learning uses algorithms"},
]

points = [
    PointStruct(
        id=doc["id"],
        vector=encoder.encode(doc["text"]).tolist(),
        payload={"text": doc["text"]}
    )
    for doc in documents
]
client.upsert(collection_name="knowledge_base", points=points)

# RAG retrieval
def retrieve(query: str, top_k: int = 5):
    query_vector = encoder.encode(query).tolist()
    results = client.search(
        collection_name="knowledge_base",
        query_vector=query_vector,
        limit=top_k
    )
    return [{"text": r.payload["text"], "score": r.score} for r in results]
```

### With LangChain

```python
from langchain_community.vectorstores import Qdrant
from langchain_community.embeddings import HuggingFaceEmbeddings

embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
vectorstore = Qdrant.from_documents(
    documents, embeddings,
    url="http://localhost:6333",
    collection_name="docs"
)
retriever = vectorstore.as_retriever(search_kwargs={"k": 5})
```

## Filtered Search

```python
from qdrant_client.models import Filter, FieldCondition, MatchValue, Range

results = client.search(
    collection_name="documents",
    query_vector=query_embedding,
    query_filter=Filter(
        must=[
            FieldCondition(key="category", match=MatchValue(value="tech")),
            FieldCondition(key="timestamp", range=Range(gte=1699000000))
        ],
        must_not=[
            FieldCondition(key="status", match=MatchValue(value="archived"))
        ]
    ),
    limit=10
)
```

## Quantization (Memory Optimization)

```python
from qdrant_client.models import ScalarQuantization, ScalarQuantizationConfig, ScalarType

# 4x memory reduction
client.create_collection(
    collection_name="quantized",
    vectors_config=VectorParams(size=384, distance=Distance.COSINE),
    quantization_config=ScalarQuantization(
        scalar=ScalarQuantizationConfig(
            type=ScalarType.INT8,
            quantile=0.99,
            always_ram=True
        )
    )
)
```

## Payload Indexing

```python
from qdrant_client.models import PayloadSchemaType

# Create index for faster filtering
client.create_payload_index(
    collection_name="documents",
    field_name="category",
    field_schema=PayloadSchemaType.KEYWORD
)
```

## Common Issues

**Slow search with filters:** Create payload index for filtered fields.

**Out of memory:** Enable quantization and on-disk storage.

**Connection issues:**

```python
client = QdrantClient(
    host="localhost",
    port=6333,
    timeout=30,
    prefer_grpc=True  # gRPC for better performance
)
```

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Qdrant** | Production RAG, filtering, on-premise |
| Chroma | Simpler setup, embedded use cases |
| FAISS | Maximum raw speed, batch processing |
| Pinecone | Fully managed, zero ops |

## Resources

- GitHub: <https://github.com/qdrant/qdrant>
- Docs: <https://qdrant.tech/documentation/>
- Cloud: <https://cloud.qdrant.io>
