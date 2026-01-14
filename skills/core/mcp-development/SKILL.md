---
name: mcp-development
description: Use when building "MCP server", "Model Context Protocol", creating "Claude tools", "MCP tools", or asking about "FastMCP", "MCP SDK", "tool development for LLMs", "external API integration for Claude"
version: 1.0.0
---

<!-- Adapted from: awesome-claude-skills/mcp-builder -->

# MCP Server Development Guide

Build high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services.

## Core Principles

### Build for Workflows, Not Just API Endpoints

- Don't simply wrap existing API endpoints
- Consolidate related operations (e.g., `schedule_event` that checks availability AND creates event)
- Focus on tools that enable complete tasks
- Consider what workflows agents actually need

### Optimize for Limited Context

- Agents have constrained context windows - make every token count
- Return high-signal information, not exhaustive data dumps
- Provide "concise" vs "detailed" response format options
- Default to human-readable identifiers over technical codes

### Design Actionable Error Messages

- Error messages should guide agents toward correct usage
- Suggest specific next steps: "Try using filter='active_only'"
- Make errors educational, not just diagnostic

## Development Phases

### Phase 1: Research and Planning

1. **Study MCP Protocol**: Fetch `https://modelcontextprotocol.io/llms-full.txt`
2. **Study SDK Docs**:
   - Python: `https://raw.githubusercontent.com/modelcontextprotocol/python-sdk/main/README.md`
   - TypeScript: `https://raw.githubusercontent.com/modelcontextprotocol/typescript-sdk/main/README.md`
3. **Study Target API**: Read ALL available documentation
4. **Create Implementation Plan**

### Phase 2: Implementation

#### Python (FastMCP)

```python
from mcp.server import Server
from pydantic import BaseModel, Field

server = Server("my-server")

class SearchInput(BaseModel):
    query: str = Field(..., description="Search query", min_length=1)
    limit: int = Field(10, description="Max results", ge=1, le=100)

@server.tool()
async def search(input: SearchInput) -> str:
    """Search for items matching the query.

    Args:
        query: The search term to find
        limit: Maximum number of results (default: 10)

    Returns:
        Formatted search results with titles and descriptions

    Examples:
        - search(query="python tutorials", limit=5)
        - search(query="error handling")
    """
    # Implementation
    pass
```

#### TypeScript (MCP SDK)

```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { z } from "zod";

const server = new Server({ name: "my-server", version: "1.0.0" });

const SearchSchema = z.object({
  query: z.string().min(1).describe("Search query"),
  limit: z.number().min(1).max(100).default(10).describe("Max results"),
}).strict();

server.registerTool({
  name: "search",
  description: "Search for items matching the query",
  inputSchema: SearchSchema,
  handler: async ({ query, limit }) => {
    // Implementation
  },
});
```

### Phase 3: Quality Review

#### Tool Annotations

```python
@server.tool(
    annotations={
        "readOnlyHint": True,      # For read-only operations
        "destructiveHint": False,  # For non-destructive operations
        "idempotentHint": True,    # If repeated calls have same effect
        "openWorldHint": True,     # If interacting with external systems
    }
)
```

#### Quality Checklist

- [ ] No duplicated code between tools
- [ ] Shared logic extracted into functions
- [ ] Similar operations return similar formats
- [ ] All external calls have error handling
- [ ] Full type coverage
- [ ] Every tool has comprehensive docstrings

### Phase 4: Testing

**Important**: MCP servers are long-running processes. Don't run directly in main process.

**Safe testing approaches:**

- Use evaluation harness (recommended)
- Run server in tmux
- Use timeout: `timeout 5s python server.py`

## Response Format Guidelines

### JSON (for programmatic use)

```python
return json.dumps({
    "results": items,
    "total": len(items),
    "query": query
}, indent=2)
```

### Markdown (for human readability)

```python
return f"""## Search Results for "{query}"

Found {len(items)} results:

{format_items_as_list(items)}
"""
```

## Best Practices

1. **Character Limits**: Implement ~25,000 token limit with truncation
2. **Pagination**: Support `limit` and `offset` parameters
3. **Error Messages**: Include suggested next actions
4. **Consistent Naming**: Group related tools with prefixes
5. **Validation**: Use Pydantic (Python) or Zod (TypeScript)
