---
name: FastAPI Testing
description: This skill should be used when the user asks about "testing FastAPI", "FastAPI tests", "API testing", "test FastAPI endpoints", "mock FastAPI dependencies", "TestClient", "async API tests"
version: 1.0.0
---

# FastAPI Testing

Patterns for testing FastAPI applications.

## Core Concepts

### Test Clients

| Client | Use Case | Async Support |
|--------|----------|---------------|
| **TestClient** | Sync tests (most cases) | No |
| **AsyncClient (httpx)** | Async endpoints, lifespan events | Yes |

**Key concept**: TestClient wraps the ASGI app - no server needed.

---

## Dependency Override Pattern

FastAPI's killer feature for testing: replace any dependency.

**How it works:**

1. Define test version of dependency
2. Add to `app.dependency_overrides[original] = test_version`
3. Run tests
4. Clear overrides after test

**Common overrides:**

- Database session → test database or mock
- Auth/current user → test user or bypassed auth
- External services → mocked responses

---

## Test Patterns

### CRUD Testing Checklist

| Operation | Happy Path | Error Cases |
|-----------|------------|-------------|
| **Create** | Returns 201, correct data | 400 validation, 409 duplicate |
| **Read** | Returns 200, correct data | 404 not found |
| **Update** | Returns 200, updated data | 404, 400 validation |
| **Delete** | Returns 204 | 404 not found |

### Validation Testing

Use parametrize for boundary conditions:

- Valid inputs → expected success
- Invalid email format → 422
- Missing required fields → 422
- Too short/long values → 422

---

## Database Testing Strategies

| Strategy | Pros | Cons |
|----------|------|------|
| **In-memory SQLite** | Fast, isolated | Different from prod DB |
| **Test database** | Realistic | Slower, needs setup |
| **Transactions + rollback** | Fast, realistic | Complex setup |
| **Mocked repository** | Fastest | Less integration coverage |

**Key concept**: Use function-scoped fixtures to ensure test isolation.

---

## Project Structure

```
tests/
├── conftest.py       # Shared fixtures (client, db, auth)
├── test_users.py     # Endpoint tests
├── test_auth.py      # Auth-specific tests
└── factories/        # Test data factories
```

---

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Shared state between tests | Use function-scoped fixtures |
| Forgetting to clear overrides | Use fixture with cleanup |
| Testing implementation not behavior | Focus on HTTP responses |
| Missing async marks | Add `@pytest.mark.asyncio` |
| SQLite vs Postgres differences | Use same DB type for important tests |

---

## Quick Reference

**Test client fixture pattern**: Create client, set overrides, yield, clear overrides

**Protected endpoint testing**: Override `get_current_user` dependency

**File upload testing**: Use `files={"file": (name, content, mimetype)}`

## Resources

- FastAPI Testing: <https://fastapi.tiangolo.com/tutorial/testing/>
- HTTPX AsyncClient: <https://www.python-httpx.org/>
