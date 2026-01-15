---
name: Python Patterns
description: This skill should be used when the user asks about "Python best practices", "Pythonic code", "Python patterns", "Python idioms", "type hints", "dataclasses", "async Python", "Python decorators", "context managers"
version: 1.0.0
---

# Python Patterns

Guidance for writing idiomatic, modern Python code.

## Modern Python Features (3.9+)

| Feature | Purpose | Key Concept |
|---------|---------|-------------|
| **Type hints** | Static analysis | `def func(x: str) -> int:` |
| **Dataclasses** | Structured data | Auto `__init__`, `__repr__`, etc. |
| **Context managers** | Resource cleanup | `with` statement guarantees cleanup |
| **Decorators** | Cross-cutting concerns | Wrap functions to add behavior |
| **Async/await** | Concurrent I/O | Non-blocking operations |

---

## Type Hints

**Modern syntax (3.10+)**: Use `|` for unions, built-in types for generics.

| Old | Modern |
|-----|--------|
| `Optional[str]` | `str \| None` |
| `Union[str, int]` | `str \| int` |
| `List[str]` | `list[str]` |
| `Dict[str, int]` | `dict[str, int]` |

**Key concept**: Type hints are for tooling (mypy, IDEs) - no runtime enforcement.

---

## Dataclasses vs Alternatives

| Use | For |
|-----|-----|
| `@dataclass` | Mutable data with methods |
| `@dataclass(frozen=True)` | Immutable, hashable |
| `NamedTuple` | Lightweight, tuple semantics |
| `TypedDict` | Dict with known keys |
| `Pydantic` | Validation, serialization |

---

## Context Managers

Use for any resource that needs cleanup: files, connections, locks, transactions.

**Pattern**: Acquire in `__enter__`, release in `__exit__` (or use `@contextmanager` with `yield`)

---

## Decorators

| Pattern | Use Case |
|---------|----------|
| Simple decorator | Logging, timing |
| Decorator with args | Configurable behavior |
| Class decorator | Modify class definition |
| `@functools.wraps` | Preserve function metadata |

---

## Async Python

**When to use**: I/O-bound operations (HTTP requests, DB queries, file I/O)

**When NOT to use**: CPU-bound operations (use `multiprocessing` instead)

| Concept | Purpose |
|---------|---------|
| `async def` | Define coroutine |
| `await` | Suspend until complete |
| `asyncio.gather()` | Run multiple concurrently |
| `async with` | Async context manager |
| `async for` | Async iteration |

---

## Pythonic Idioms

| Instead of | Use |
|------------|-----|
| `if len(x) > 0:` | `if x:` |
| `for i in range(len(x)):` | `for item in x:` or `enumerate()` |
| `d.has_key(k)` | `k in d` |
| `try/if exists` (LBYL) | `try/except` (EAFP) |
| Manual swap | `a, b = b, a` |

---

## Project Structure

```
my_project/
├── src/my_package/     # Source code
├── tests/              # Test files
├── pyproject.toml      # Project config
└── README.md
```

**Key concept**: Use `src/` layout to prevent import confusion.

---

## Tooling

| Tool | Purpose |
|------|---------|
| **ruff** | Fast linter + formatter |
| **mypy** | Type checking |
| **pytest** | Testing |
| **uv/pip** | Dependencies |

## Resources

- Python docs: <https://docs.python.org/3/>
- Real Python: <https://realpython.com/>
