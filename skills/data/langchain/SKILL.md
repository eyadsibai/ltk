---
name: langchain
description: Use when "LangChain", "LLM applications", "RAG pipeline", "ReAct agents", or asking about "chatbot memory", "vector store retrieval", "tool calling", "chains", "prompt templates", "document loaders"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/14-agents/langchain -->

# LangChain - Build LLM Applications

Framework for building LLM-powered applications with agents, chains, and RAG.

## When to Use

- Building agents with tool calling (ReAct pattern)
- Implementing RAG pipelines
- Creating chatbots with conversation memory
- Swapping LLM providers easily
- Rapid prototyping of LLM applications

## Quick Start

```bash
pip install langchain langchain-openai langchain-anthropic langchain-community
```

```python
from langchain_anthropic import ChatAnthropic

llm = ChatAnthropic(model="claude-sonnet-4-5-20250929")
response = llm.invoke("Explain quantum computing in 2 sentences")
print(response.content)
```

## Chains (Sequential Operations)

```python
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate

prompt = PromptTemplate(
    input_variables=["topic"],
    template="Write a 3-sentence summary about {topic}"
)

chain = LLMChain(llm=llm, prompt=prompt)
result = chain.run(topic="machine learning")
```

## Agents (Tool-Using)

```python
from langchain.agents import create_tool_calling_agent, AgentExecutor
from langchain.tools import Tool

def get_weather(city: str) -> str:
    return f"It's sunny in {city}, 72°F"

calculator = Tool(
    name="Calculator",
    func=lambda x: eval(x),
    description="Useful for math calculations"
)

agent = create_tool_calling_agent(
    llm=llm,
    tools=[calculator],
    prompt="Answer questions using available tools"
)

executor = AgentExecutor(agent=agent, tools=[calculator])
result = executor.invoke({"input": "What is 25 * 17?"})
```

## Memory (Conversation History)

```python
from langchain.memory import ConversationBufferMemory
from langchain.chains import ConversationChain

memory = ConversationBufferMemory()
conversation = ConversationChain(llm=llm, memory=memory)

conversation.predict(input="Hi, I'm Alice")
conversation.predict(input="What's my name?")  # Remembers "Alice"
```

## RAG (Retrieval-Augmented Generation)

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
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200
)
splits = text_splitter.split_documents(docs)

# 3. Create vector store
vectorstore = Chroma.from_documents(
    documents=splits,
    embedding=OpenAIEmbeddings()
)

# 4. Create retriever
retriever = vectorstore.as_retriever(search_kwargs={"k": 4})

# 5. Create QA chain
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=retriever,
    return_source_documents=True
)

# 6. Query
result = qa_chain({"query": "What are Python decorators?"})
```

## Structured Output

```python
from langchain_core.pydantic_v1 import BaseModel, Field

class WeatherReport(BaseModel):
    city: str = Field(description="City name")
    temperature: float = Field(description="Temperature in Fahrenheit")

structured_llm = llm.with_structured_output(WeatherReport)
result = structured_llm.invoke("Weather in SF: 65F and sunny")
# result.city, result.temperature
```

## Document Loaders

```python
from langchain_community.document_loaders import (
    WebBaseLoader,      # Web pages
    PyPDFLoader,        # PDFs
    CSVLoader,          # CSV files
    TextLoader,         # Plain text
    DirectoryLoader,    # Directory of files
)

loader = PyPDFLoader("paper.pdf")
docs = loader.load()
```

## Text Splitters

```python
from langchain.text_splitter import (
    RecursiveCharacterTextSplitter,  # General text
    PythonCodeTextSplitter,          # Python code
    MarkdownTextSplitter,            # Markdown
)

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    separators=["\n\n", "\n", " ", ""]
)
chunks = splitter.split_documents(docs)
```

## Vector Stores

```python
from langchain_chroma import Chroma
from langchain_community.vectorstores import FAISS

# Chroma (local, persistent)
vectorstore = Chroma.from_documents(
    documents=docs,
    embedding=OpenAIEmbeddings(),
    persist_directory="./chroma_db"
)

# FAISS (in-memory, fast)
vectorstore = FAISS.from_documents(docs, OpenAIEmbeddings())
vectorstore.save_local("faiss_index")
```

## Streaming

```python
for chunk in llm.stream("Write a poem"):
    print(chunk.content, end="", flush=True)
```

## LangSmith (Observability)

```python
import os
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_API_KEY"] = "your-api-key"
os.environ["LANGCHAIN_PROJECT"] = "my-project"

# All chains/agents automatically traced
```

## Best Practices

1. **Start simple** with chains, use agents when needed
2. **Enable streaming** for better UX
3. **Use LangSmith** for debugging
4. **Optimize chunk size** (500-1000 chars for RAG)
5. **Cache embeddings** - they're expensive
6. **Add error handling** - tools can fail

## vs Alternatives

| Framework | Best For |
|-----------|----------|
| **LangChain** | Quick agents, RAG, prototyping |
| LlamaIndex | RAG-focused, document Q&A |
| LangGraph | Complex stateful workflows |
| Haystack | Production search pipelines |

## Resources

- Docs: <https://docs.langchain.com>
- GitHub: <https://github.com/langchain-ai/langchain>
- LangSmith: <https://smith.langchain.com>
