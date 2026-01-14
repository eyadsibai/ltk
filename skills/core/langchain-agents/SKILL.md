---
name: langchain-agents
description: Use when "LangChain", "LLM chains", "ReAct agents", "tool calling", or asking about "RAG pipelines", "conversation memory", "document QA", "agent tools", "LangSmith"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/14-agents/langchain -->

# LangChain - LLM Applications with Agents & RAG

The most popular framework for building LLM-powered applications.

## When to Use

- Building agents with tool calling and reasoning (ReAct pattern)
- Implementing RAG (retrieval-augmented generation) pipelines
- Need to swap LLM providers easily (OpenAI, Anthropic, Google)
- Creating chatbots with conversation memory
- Rapid prototyping of LLM applications

## Quick Start

```bash
pip install -U langchain langchain-anthropic langchain-community
```

### Basic Usage

```python
from langchain_anthropic import ChatAnthropic

llm = ChatAnthropic(model="claude-sonnet-4-5-20250929")
response = llm.invoke("Explain quantum computing in 2 sentences")
print(response.content)
```

### Create an Agent

```python
from langchain.agents import create_agent
from langchain_anthropic import ChatAnthropic

def get_weather(city: str) -> str:
    """Get current weather for a city."""
    return f"It's sunny in {city}, 72°F"

agent = create_agent(
    model=ChatAnthropic(model="claude-sonnet-4-5-20250929"),
    tools=[get_weather],
    system_prompt="You are a helpful assistant."
)

result = agent.invoke({"messages": [{"role": "user", "content": "What's the weather in Paris?"}]})
```

## RAG Pipeline

```python
from langchain_community.document_loaders import WebBaseLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain_chroma import Chroma
from langchain.chains import RetrievalQA

# 1. Load documents
loader = WebBaseLoader("https://docs.python.org/3/tutorial/")
docs = loader.load()

# 2. Split into chunks
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs)

# 3. Create vector store
vectorstore = Chroma.from_documents(documents=splits, embedding=OpenAIEmbeddings())

# 4. Create QA chain
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=vectorstore.as_retriever(search_kwargs={"k": 4}),
    return_source_documents=True
)

# 5. Query
result = qa_chain({"query": "What are Python decorators?"})
```

## Conversation Memory

```python
from langchain.memory import ConversationBufferMemory
from langchain.chains import ConversationChain

memory = ConversationBufferMemory()
conversation = ConversationChain(llm=llm, memory=memory, verbose=True)

conversation.predict(input="Hi, I'm Alice")
conversation.predict(input="What's my name?")  # Remembers "Alice"
```

## Structured Output

```python
from langchain_core.pydantic_v1 import BaseModel, Field

class WeatherReport(BaseModel):
    city: str = Field(description="City name")
    temperature: float = Field(description="Temperature in Fahrenheit")
    condition: str = Field(description="Weather condition")

structured_llm = llm.with_structured_output(WeatherReport)
result = structured_llm.invoke("What's the weather in SF? It's 65F and sunny")
```

## Document Loaders

```python
# Web pages
from langchain_community.document_loaders import WebBaseLoader
loader = WebBaseLoader("https://example.com")

# PDFs
from langchain_community.document_loaders import PyPDFLoader
loader = PyPDFLoader("paper.pdf")

# GitHub
from langchain_community.document_loaders import GithubFileLoader
loader = GithubFileLoader(repo="user/repo", file_filter=lambda x: x.endswith(".py"))
```

## Vector Stores

```python
# Chroma (local)
from langchain_chroma import Chroma
vectorstore = Chroma.from_documents(docs, OpenAIEmbeddings())

# FAISS
from langchain_community.vectorstores import FAISS
vectorstore = FAISS.from_documents(docs, OpenAIEmbeddings())
```

## LangSmith Observability

```python
import os
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_API_KEY"] = "your-api-key"

# All chains/agents automatically traced
```

## Best Practices

1. **Start simple** - Use `create_agent()` for most cases
2. **Enable streaming** - Better UX for long responses
3. **Use LangSmith** - Essential for debugging agents
4. **Optimize chunk size** - 500-1000 chars for RAG
5. **Cache embeddings** - Expensive, cache when possible

## vs LangGraph

| Feature | LangChain | LangGraph |
|---------|-----------|-----------|
| Best for | Quick agents, RAG | Complex workflows |
| Code to start | <10 lines | ~30 lines |
| Stateful workflows | Limited | Native |

## Resources

- GitHub: <https://github.com/langchain-ai/langchain>
- Docs: <https://docs.langchain.com>
- LangSmith: <https://smith.langchain.com>
