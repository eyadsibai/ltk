---
name: llamaindex
description: Use when "LlamaIndex", "llama-index", "document Q&A", or asking about "data connectors", "vector indices", "query engines", "document retrieval", "knowledge base", "LlamaHub"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/14-agents/llamaindex -->

# LlamaIndex - Data Framework for LLM Applications

Connect LLMs with your data. Best for RAG and document Q&A.

## When to Use

- Building RAG applications over documents
- Document question-answering
- Ingesting data from multiple sources (300+ connectors)
- Creating knowledge bases
- Structured data extraction

## Quick Start

```bash
pip install llama-index
```

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

# Load documents
documents = SimpleDirectoryReader("data").load_data()

# Create index
index = VectorStoreIndex.from_documents(documents)

# Query
query_engine = index.as_query_engine()
response = query_engine.query("What is this document about?")
print(response)
```

## Data Connectors

```python
from llama_index.core import SimpleDirectoryReader

# Directory of files (PDF, DOCX, TXT, MD)
documents = SimpleDirectoryReader("./data").load_data()

# Web pages
from llama_index.readers.web import SimpleWebPageReader
documents = SimpleWebPageReader().load_data(["https://example.com"])

# GitHub
from llama_index.readers.github import GithubRepositoryReader
documents = GithubRepositoryReader(owner="user", repo="repo").load_data(branch="main")
```

## Index Types

```python
from llama_index.core import VectorStoreIndex, ListIndex, TreeIndex

# Vector index (most common - semantic search)
index = VectorStoreIndex.from_documents(documents)

# Save index
index.storage_context.persist(persist_dir="./storage")

# Load index
from llama_index.core import load_index_from_storage, StorageContext
storage_context = StorageContext.from_defaults(persist_dir="./storage")
index = load_index_from_storage(storage_context)
```

## Query Engine

```python
# Basic query
query_engine = index.as_query_engine()
response = query_engine.query("What is the main topic?")

# Streaming
query_engine = index.as_query_engine(streaming=True)
response = query_engine.query("Explain the topic")
for text in response.response_gen:
    print(text, end="", flush=True)

# Custom config
query_engine = index.as_query_engine(
    similarity_top_k=3,
    response_mode="compact"
)
```

## Chat Engine (Conversational)

```python
chat_engine = index.as_chat_engine(
    chat_mode="condense_plus_context",
    verbose=True
)

response1 = chat_engine.chat("What is Python?")
response2 = chat_engine.chat("Can you give examples?")  # Remembers context
```

## Custom LLM and Embeddings

```python
from llama_index.llms.anthropic import Anthropic
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.core import Settings

# Set global LLM
Settings.llm = Anthropic(model="claude-sonnet-4-5-20250929")

# Set embeddings
Settings.embed_model = HuggingFaceEmbedding(
    model_name="sentence-transformers/all-mpnet-base-v2"
)

# Now all queries use these settings
index = VectorStoreIndex.from_documents(documents)
```

## Vector Store Integration

```python
# Chroma
from llama_index.vector_stores.chroma import ChromaVectorStore
import chromadb

db = chromadb.PersistentClient(path="./chroma_db")
collection = db.get_or_create_collection("my_collection")
vector_store = ChromaVectorStore(chroma_collection=collection)

from llama_index.core import StorageContext
storage_context = StorageContext.from_defaults(vector_store=vector_store)
index = VectorStoreIndex.from_documents(documents, storage_context=storage_context)
```

## Agents with Tools

```python
from llama_index.core.agent import FunctionAgent
from llama_index.core.tools import QueryEngineTool
from llama_index.llms.openai import OpenAI

# Create tool from query engine
query_tool = QueryEngineTool.from_defaults(
    query_engine=index.as_query_engine(),
    name="docs_search",
    description="Search documentation"
)

# Create agent
agent = FunctionAgent.from_tools(
    tools=[query_tool],
    llm=OpenAI(model="gpt-4o")
)

response = agent.chat("What does the documentation say about X?")
```

## Metadata Filtering

```python
from llama_index.core.vector_stores import MetadataFilters, ExactMatchFilter

filters = MetadataFilters(
    filters=[ExactMatchFilter(key="category", value="tutorial")]
)

retriever = index.as_retriever(similarity_top_k=3, filters=filters)
query_engine = index.as_query_engine(filters=filters)
```

## Best Practices

1. **Use vector indices** for most cases
2. **Save indices to disk** - avoid re-indexing
3. **Chunk properly** - 512-1024 tokens optimal
4. **Add metadata** - enables filtering
5. **Use streaming** for better UX
6. **Persist storage** - don't lose your index

## vs Alternatives

| Framework | Best For |
|-----------|----------|
| **LlamaIndex** | RAG, document Q&A, data ingestion |
| LangChain | Agents, general LLM apps |
| Haystack | Production search pipelines |

## Resources

- Docs: <https://developers.llamaindex.ai>
- GitHub: <https://github.com/run-llama/llama_index>
- LlamaHub: <https://llamahub.ai>
