---
name: FastAPI
description: This skill should be used when the user asks about "FastAPI", "FastAPI routes", "FastAPI dependencies", "Pydantic models", "FastAPI middleware", "API endpoints", "OpenAPI", or mentions FastAPI development.
version: 1.0.0
---

# FastAPI Development

Guidance for building APIs with FastAPI following best practices.

---

## Core Concepts

### Route Decorators

| Decorator | HTTP Method | Use Case |
|-----------|-------------|----------|
| `@app.get()` | GET | Retrieve data |
| `@app.post()` | POST | Create resource |
| `@app.put()` | PUT | Full update |
| `@app.patch()` | PATCH | Partial update |
| `@app.delete()` | DELETE | Remove resource |

### Response Status Codes

| Code | Meaning | When to Use |
|------|---------|-------------|
| **200** | OK | Successful GET/PUT/PATCH |
| **201** | Created | Successful POST |
| **204** | No Content | Successful DELETE |
| **400** | Bad Request | Invalid input |
| **401** | Unauthorized | Authentication required |
| **403** | Forbidden | No permission |
| **404** | Not Found | Resource doesn't exist |
| **422** | Unprocessable | Validation failed |

---

## Dependency Injection

**Key concept**: Dependencies are functions that FastAPI calls before your route handler. Use `yield` for cleanup logic.

| Pattern | Use Case |
|---------|----------|
| **Simple function** | Get config, compute values |
| **Generator (yield)** | Database sessions, connections |
| **Class-based** | Complex dependencies with state |
| **Nested dependencies** | Dependencies that depend on other dependencies |

### Common Dependencies

| Dependency | Purpose |
|------------|---------|
| **get_db** | Database session (yield for cleanup) |
| **get_current_user** | Authentication + user retrieval |
| **get_settings** | Configuration singleton |
| **rate_limiter** | Request throttling |

**Key concept**: Use `Annotated[Type, Depends(func)]` for cleaner type hints and reusability.

---

## Pydantic Models

### Model Patterns

| Pattern | Purpose |
|---------|---------|
| **Base model** | Shared fields |
| **Create model** | Input for POST (no id) |
| **Update model** | Partial updates (all Optional) |
| **Response model** | Output (includes id, timestamps) |
| **DB model** | Internal with `from_attributes = True` |

### Validation Features

| Feature | Purpose |
|---------|---------|
| **Field(...)** | Required with constraints |
| **Field(default=...)** | Optional with default |
| **field_validator** | Custom validation logic |
| **model_validator** | Cross-field validation |
| **pattern=** | Regex validation |
| **ge=, le=** | Numeric bounds |
| **min_length=, max_length=** | String/list length |

---

## Error Handling

| Approach | Use Case |
|----------|----------|
| **HTTPException** | Simple errors with status code |
| **Custom exception class** | Structured error responses |
| **@app.exception_handler** | Global error handling |
| **RequestValidationError** | Customize validation errors |

**Key concept**: Create custom exception classes for consistent error response format across your API.

---

## Router Organization

| Concept | Purpose |
|---------|---------|
| **APIRouter** | Group related endpoints |
| **prefix** | URL prefix for all routes |
| **tags** | OpenAPI documentation grouping |
| **dependencies** | Router-level dependencies |

### Project Structure

| Directory | Contents |
|-----------|----------|
| **routers/** | Route handlers by domain |
| **models/** | SQLAlchemy/database models |
| **schemas/** | Pydantic request/response models |
| **services/** | Business logic |
| **dependencies.py** | Shared dependencies |
| **config.py** | Settings and configuration |

---

## Background Tasks

| Method | Use Case |
|--------|----------|
| **BackgroundTasks** | Simple async tasks (email, logging) |
| **Celery** | Heavy tasks, retries, scheduling |
| **ARQ** | Async Redis queue |

**Key concept**: BackgroundTasks run after response is sent—good for non-critical operations that shouldn't block the response.

---

## Testing Patterns

| Client | Use Case |
|--------|----------|
| **TestClient** | Sync tests (most common) |
| **AsyncClient (httpx)** | Async tests, lifespan events |

### Dependency Override Pattern

1. Create test version of dependency
2. Set `app.dependency_overrides[original] = test_version`
3. Run tests
4. Clear overrides after

**Key concept**: Override `get_db` for test database, `get_current_user` for auth bypass.

---

## Best Practices

| Practice | Why |
|----------|-----|
| Use response_model | Control output, hide internal fields |
| Use dependency injection | Testable, reusable code |
| Separate schemas from DB models | Decouple API from database |
| Use routers for organization | Maintainable as API grows |
| Add OpenAPI descriptions | Self-documenting API |
| Use async for I/O | Better concurrency |

## Resources

- Docs: <https://fastapi.tiangolo.com/>
- Tutorial: <https://fastapi.tiangolo.com/tutorial/>
