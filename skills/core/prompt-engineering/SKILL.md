---
name: prompt-engineering
description: Use when "writing prompts", "prompt optimization", "few-shot learning", "chain of thought", or asking about "RAG systems", "agent workflows", "LLM integration", "prompt templates"
version: 1.0.0
---

<!-- Adapted from: claude-skills/engineering-team/senior-prompt-engineer -->

# Prompt Engineering Guide

Effective prompts, RAG systems, and agent workflows.

## When to Use

- Optimizing LLM prompts
- Building RAG systems
- Designing agent workflows
- Creating few-shot examples
- Structuring chain-of-thought reasoning

## Prompt Patterns

### Basic Structure

```
[Role/Context]
You are an expert {domain} assistant.

[Task]
{Clear instruction of what to do}

[Format]
Respond in {format specification}.

[Examples] (optional)
Example input: {input}
Example output: {output}

[Constraints]
- {Constraint 1}
- {Constraint 2}
```

### Chain of Thought

```
Solve this step by step:

1. First, identify the key elements
2. Then, analyze the relationships
3. Finally, provide your conclusion

Show your reasoning for each step.
```

### Few-Shot Learning

```
Here are examples of the task:

Input: "The movie was absolutely terrible"
Output: {"sentiment": "negative", "confidence": 0.95}

Input: "I loved every minute of it"
Output: {"sentiment": "positive", "confidence": 0.92}

Now analyze this:
Input: "{user_input}"
Output:
```

## RAG System Design

### Architecture

```
Query → Embedding → Vector Search → Context Retrieval → LLM → Response
```

### Implementation

```python
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.chains import RetrievalQA

# Create vector store
embeddings = OpenAIEmbeddings()
vectorstore = Chroma.from_documents(docs, embeddings)

# Create RAG chain
qa = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(k=3)
)

# Query
response = qa.run("What is the refund policy?")
```

### Chunking Strategies

| Strategy | Best For |
|----------|----------|
| Fixed size (512 tokens) | General documents |
| Sentence-based | Precise retrieval |
| Paragraph-based | Context preservation |
| Semantic chunking | Mixed content types |

## Agent Patterns

### ReAct Pattern

```
Thought: I need to find the user's order history
Action: search_orders(user_id="123")
Observation: Found 3 orders: [...]
Thought: Now I can answer the question
Action: respond("Your recent orders are...")
```

### Tool Calling

```python
tools = [
    {
        "name": "search_database",
        "description": "Search the product database",
        "parameters": {
            "query": {"type": "string"},
            "limit": {"type": "integer", "default": 10}
        }
    }
]

response = client.chat.completions.create(
    model="gpt-4",
    messages=messages,
    tools=tools,
    tool_choice="auto"
)
```

## Optimization Techniques

### Token Efficiency

- Remove redundant instructions
- Use abbreviations in examples
- Compress context with summaries
- Cache common prompts

### Quality Improvement

- Add specific examples
- Use structured output formats
- Include edge case handling
- Add confidence scoring

### Testing Framework

```python
def evaluate_prompt(prompt_template, test_cases):
    """Evaluate prompt against test cases."""
    results = []
    for case in test_cases:
        response = llm(prompt_template.format(**case['input']))
        score = evaluate_response(response, case['expected'])
        results.append({
            'input': case['input'],
            'expected': case['expected'],
            'actual': response,
            'score': score
        })
    return results
```

## Best Practices

### Prompt Design

- Be specific and explicit
- Provide clear examples
- Specify output format
- Handle edge cases
- Test with diverse inputs

### RAG Systems

- Choose appropriate chunk sizes
- Use metadata filtering
- Implement re-ranking
- Monitor retrieval quality
- Handle no-results gracefully

### Agent Design

- Define clear tool boundaries
- Implement fallbacks
- Log all actions
- Set iteration limits
- Handle errors gracefully

## Common Patterns

### Extraction

```
Extract the following from the text:
- Names (list of strings)
- Dates (ISO format)
- Amounts (numbers with currency)

Text: {input}

Output as JSON.
```

### Classification

```
Classify the following into one of these categories:
- Technical Support
- Billing
- General Inquiry
- Complaint

Message: {input}

Respond with just the category name.
```

### Summarization

```
Summarize the following in 3 bullet points:
- Focus on key decisions
- Include action items
- Note any deadlines

Text: {input}
```
