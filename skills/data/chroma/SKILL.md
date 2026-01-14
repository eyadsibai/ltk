---
name: chroma
description: Use when "Chroma", "ChromaDB", "embedding database", or asking about "vector database", "semantic search database", "store embeddings", "metadata filtering", "document retrieval", "local vector store"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/15-rag/chroma -->

# Chroma - Open-Source Vector Database

AI-native embedding database for building LLM applications.

## When to Use

- Building RAG applications
- Local/self-hosted vector database
- Storing embeddings with metadata
- Semantic search over documents
- Prototyping in notebooks
- Open-source solution needed

## Quick Start

```bash
pip install chromadb
```

```python
import chromadb

# Create client
client = chromadb.Client()

# Create collection
collection = client.create_collection(name="my_collection")

# Add documents
collection.add(
    documents=["This is document 1", "This is document 2"],
    metadatas=[{"source": "doc1"}, {"source": "doc2"}],
    ids=["id1", "id2"]
)

# Query
results = collection.query(
    query_texts=["document about topic"],
    n_results=2
)
print(results)
```

## Persistent Storage

```python
# Persist to disk
client = chromadb.PersistentClient(path="./chroma_db")

collection = client.create_collection("my_docs")
collection.add(documents=["Doc 1"], ids=["id1"])

# Data persisted automatically
# Reload with same path later
```

## Collections

```python
# Create
collection = client.create_collection("my_docs")

# Get existing
collection = client.get_collection("my_docs")

# Get or create
collection = client.get_or_create_collection("my_docs")

# Delete
client.delete_collection("my_docs")
```

## Add Documents

```python
# With auto-embeddings
collection.add(
    documents=["Doc 1", "Doc 2"],
    metadatas=[{"source": "web"}, {"source": "pdf"}],
    ids=["id1", "id2"]
)

# With custom embeddings
collection.add(
    embeddings=[[0.1, 0.2, ...], [0.3, 0.4, ...]],
    documents=["Doc 1", "Doc 2"],
    ids=["id1", "id2"]
)
```

## Query (Similarity Search)

```python
# Basic query
results = collection.query(
    query_texts=["machine learning tutorial"],
    n_results=5
)

# Access results
results["documents"]    # Matching documents
results["metadatas"]    # Metadata for each
results["distances"]    # Similarity scores
results["ids"]          # Document IDs
```

## Metadata Filtering

```python
# Exact match
results = collection.query(
    query_texts=["query"],
    where={"source": "web"}
)

# Comparison operators
results = collection.query(
    query_texts=["query"],
    where={"page": {"$gt": 10}}  # $gt, $gte, $lt, $lte, $ne
)

# Logical operators
results = collection.query(
    query_texts=["query"],
    where={
        "$and": [
            {"category": "tutorial"},
            {"difficulty": {"$lte": 3}}
        ]
    }
)

# Contains
results = collection.query(
    query_texts=["query"],
    where={"tags": {"$in": ["python", "ml"]}}
)
```

## Embedding Functions

```python
from chromadb.utils import embedding_functions

# OpenAI embeddings
openai_ef = embedding_functions.OpenAIEmbeddingFunction(
    api_key="your-key",
    model_name="text-embedding-3-small"
)

collection = client.create_collection(
    name="openai_docs",
    embedding_function=openai_ef
)

# HuggingFace embeddings
hf_ef = embedding_functions.HuggingFaceEmbeddingFunction(
    api_key="your-key",
    model_name="sentence-transformers/all-mpnet-base-v2"
)
```

## Update and Delete

```python
# Update
collection.update(
    ids=["id1"],
    documents=["Updated content"],
    metadatas=[{"source": "updated"}]
)

# Delete by ID
collection.delete(ids=["id1", "id2"])

# Delete with filter
collection.delete(where={"source": "outdated"})
```

## LangChain Integration

```python
from langchain_chroma import Chroma
from langchain_openai import OpenAIEmbeddings

# Create vector store
vectorstore = Chroma.from_documents(
    documents=docs,
    embedding=OpenAIEmbeddings(),
    persist_directory="./chroma_db"
)

# Query
results = vectorstore.similarity_search("machine learning", k=3)

# As retriever
retriever = vectorstore.as_retriever(search_kwargs={"k": 5})
```

## LlamaIndex Integration

```python
from llama_index.vector_stores.chroma import ChromaVectorStore
from llama_index.core import VectorStoreIndex, StorageContext
import chromadb

# Initialize Chroma
db = chromadb.PersistentClient(path="./chroma_db")
collection = db.get_or_create_collection("my_collection")

# Create vector store
vector_store = ChromaVectorStore(chroma_collection=collection)
storage_context = StorageContext.from_defaults(vector_store=vector_store)

# Create index
index = VectorStoreIndex.from_documents(documents, storage_context=storage_context)
```

## Server Mode

```bash
# Run server
chroma run --path ./chroma_db --port 8000
```

```python
# Connect to server
client = chromadb.HttpClient(host="localhost", port=8000)
collection = client.get_or_create_collection("my_docs")
```

## Best Practices

1. **Use persistent client** - Don't lose data on restart
2. **Add metadata** - Enables filtering and tracking
3. **Batch operations** - Add multiple docs at once
4. **Use unique IDs** - Avoid collisions
5. **Choose right embedding model** - Balance speed/quality
6. **Use server mode for production** - Multi-user support

## Performance

| Operation | Latency |
|-----------|---------|
| Add 100 docs | ~1-3s (with embedding) |
| Query (top 10) | ~50-200ms |
| Metadata filter | ~10-50ms |

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Chroma** | Local dev, open-source, metadata filtering |
| FAISS | Pure similarity, GPU, billions of vectors |
| Pinecone | Managed cloud, auto-scaling |
| Weaviate | Production, ML-native database |

## Resources

- GitHub: <https://github.com/chroma-core/chroma>
- Docs: <https://docs.trychroma.com>
