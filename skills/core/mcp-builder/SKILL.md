---
name: mcp-builder
description: This skill should be used when building MCP (Model Context Protocol) servers to integrate external APIs or services. Covers agent-centric design, Python (FastMCP) and TypeScript implementations.
version: 1.0.0
---

# MCP Server Development Guide

Create high-quality MCP (Model Context Protocol) servers that enable LLMs to effectively interact with external services.

## Overview

An MCP server provides tools that allow LLMs to access external services and APIs. Quality is measured by how well it enables LLMs to accomplish real-world tasks.

## Agent-Centric Design Principles

### Build for Workflows, Not Endpoints

- Don't simply wrap API endpoints - build workflow tools
- Consolidate related operations (e.g., `schedule_event` checks availability AND creates)
- Focus on complete tasks, not individual API calls

### Optimize for Limited Context

- Agents have constrained context windows - every token counts
- Return high-signal information, not data dumps
- Provide "concise" vs "detailed" response options
- Default to human-readable identifiers (names over IDs)

### Design Actionable Error Messages

- Errors should guide agents toward correct usage
- Suggest specific next steps: "Try using filter='active_only'"
- Make errors educational, not just diagnostic

### Follow Natural Task Subdivisions

- Tool names should reflect how humans think about tasks
- Group related tools with consistent prefixes
- Design around natural workflows

## Development Workflow

### Phase 1: Research and Planning

1. **Study MCP Protocol**: Fetch `https://modelcontextprotocol.io/llms-full.txt`
2. **Study API Documentation**: Read ALL available API docs
3. **Plan Tools**: List most valuable operations to implement
4. **Plan Utilities**: Identify common patterns, pagination, error handling

### Phase 2: Implementation

#### Project Structure

**Python (FastMCP):**

```
my-mcp-server/
├── server.py          # Main server with @mcp.tool decorators
├── requirements.txt   # Dependencies
└── README.md
```

**TypeScript:**

```
my-mcp-server/
├── src/
│   └── index.ts       # Main server with registerTool
├── package.json
├── tsconfig.json
└── README.md
```

#### Tool Implementation Pattern

**Python:**

```python
from mcp.server import Server
from pydantic import BaseModel, Field

mcp = Server("my-server")

class SearchInput(BaseModel):
    query: str = Field(..., description="Search query", min_length=1)
    limit: int = Field(10, description="Max results", ge=1, le=100)

@mcp.tool()
async def search_items(input: SearchInput) -> str:
    """
    Search for items in the database.

    Use this tool when you need to find items matching a query.
    Returns a list of matching items with their IDs and names.

    Args:
        query: The search term to match against item names
        limit: Maximum number of results (default: 10)

    Returns:
        JSON array of matching items

    Example:
        search_items(query="laptop", limit=5)
    """
    # Implementation here
    pass
```

**TypeScript:**

```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { z } from "zod";

const server = new Server({ name: "my-server", version: "1.0.0" });

const SearchInputSchema = z.object({
  query: z.string().min(1).describe("Search query"),
  limit: z.number().int().min(1).max(100).default(10).describe("Max results"),
}).strict();

server.registerTool({
  name: "search_items",
  description: "Search for items in the database",
  inputSchema: SearchInputSchema,
  annotations: {
    readOnlyHint: true,
    idempotentHint: true,
  },
  handler: async (input) => {
    // Implementation here
  },
});
```

### Phase 3: Quality Checks

#### Tool Annotations

Always include appropriate annotations:

| Annotation | Use When |
|------------|----------|
| `readOnlyHint: true` | Tool only reads data |
| `destructiveHint: true` | Tool deletes or modifies data |
| `idempotentHint: true` | Repeated calls have same effect |
| `openWorldHint: true` | Interacts with external systems |

#### Quality Checklist

- [ ] All tools have comprehensive docstrings
- [ ] Input validation with clear constraints
- [ ] Error messages guide toward correct usage
- [ ] Response formats are consistent
- [ ] Character limits respected (~25k tokens max)
- [ ] Pagination supported for list operations
- [ ] No hardcoded secrets or credentials

### Phase 4: Testing

**Important**: MCP servers are long-running processes. Don't run directly - they'll hang.

**Safe testing approaches:**

- Use evaluation harness (manages server lifecycle)
- Run server in tmux
- Use timeout: `timeout 5s python server.py`

## Best Practices

### Response Formats

Support both JSON and Markdown:

```python
def format_response(data: dict, format: str = "json") -> str:
    if format == "markdown":
        return format_as_markdown(data)
    return json.dumps(data, indent=2)
```

### Error Handling

```python
try:
    result = await api_call()
except RateLimitError:
    return "Rate limited. Try again in 60 seconds or reduce batch size."
except AuthError:
    return "Authentication failed. Verify API credentials are configured."
except NotFoundError as e:
    return f"Resource not found: {e.resource_id}. Try listing available resources first."
```

### Pagination

```python
@mcp.tool()
async def list_items(limit: int = 50, cursor: str = None) -> str:
    """
    List items with pagination.

    Returns up to `limit` items. If more exist, response includes
    `next_cursor` - pass this as `cursor` to get next page.
    """
    pass
```

### Character Limits

```python
CHARACTER_LIMIT = 25000

def truncate_response(content: str, limit: int = CHARACTER_LIMIT) -> str:
    if len(content) > limit:
        return content[:limit] + "\n\n[Truncated. Use pagination or filters.]"
    return content
```

## Common Patterns

### CRUD Operations

```
create_[resource]  - Create new resource
get_[resource]     - Get single resource by ID
list_[resources]   - List resources with filters
update_[resource]  - Update existing resource
delete_[resource]  - Delete resource
```

### Search and Filter

```
search_[resources] - Full-text search
filter_[resources] - Structured filtering
```

### Workflow Tools

```
# Instead of separate API calls:
schedule_meeting   # Checks availability AND creates meeting
send_report        # Generates AND sends report
```

## References

- MCP Protocol: <https://modelcontextprotocol.io>
- Python SDK: <https://github.com/modelcontextprotocol/python-sdk>
- TypeScript SDK: <https://github.com/modelcontextprotocol/typescript-sdk>
