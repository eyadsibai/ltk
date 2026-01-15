---
name: Pytest
description: This skill should be used when the user asks about "pytest", "writing tests", "test fixtures", "parametrize", "mocking", "test coverage", "conftest"
version: 1.0.0
---

# Pytest Testing

Guidance for writing effective tests with pytest.

## Core Concepts

### Fixtures

Reusable test setup/teardown. Use `yield` for cleanup.

**Scopes:**

| Scope | Runs | Use Case |
|-------|------|----------|
| `function` | Each test | Default, isolated |
| `class` | Once per class | Shared state in class |
| `module` | Once per file | Expensive setup |
| `session` | Once total | DB connections, servers |

**Key concept**: `conftest.py` makes fixtures available to all tests in directory.

---

### Parametrize

Test multiple inputs without repeating code.

**Key concept**: Generates separate test for each parameter set - failures are isolated.

**Use `pytest.param()` for:**

- Custom test IDs
- Expected failures (`marks=pytest.mark.xfail`)
- Conditional skips

---

### Markers

Tag tests for filtering and special behavior.

| Built-in | Purpose |
|----------|---------|
| `@pytest.mark.skip` | Always skip |
| `@pytest.mark.skipif(condition)` | Conditional skip |
| `@pytest.mark.xfail` | Expected failure |
| `@pytest.mark.asyncio` | Async test (with pytest-asyncio) |

**Custom markers**: Define in `pyproject.toml`, run with `pytest -m "marker"`

---

### Mocking

| Tool | Use Case |
|------|----------|
| `Mock()` | Create fake object |
| `patch()` | Replace import |
| `MagicMock()` | Mock with magic methods |
| `AsyncMock()` | Mock async functions |

**Key concept**: Patch where the thing is *used*, not where it's *defined*.

---

## Test Organization

```
tests/
├── conftest.py          # Shared fixtures
├── unit/                # Fast, isolated
├── integration/         # Multiple components
└── e2e/                 # Full system
```

---

## Coverage

**Key thresholds:**

- 80%+ is good coverage
- 100% is often overkill
- Branch coverage catches conditionals

**Config in `pyproject.toml`**: Set `source`, `branch=true`, `fail_under`

---

## Common Commands

| Command | Purpose |
|---------|---------|
| `pytest -v` | Verbose output |
| `pytest -x` | Stop on first failure |
| `pytest -k "pattern"` | Filter by name |
| `pytest -m "marker"` | Filter by marker |
| `pytest -s` | Show print output |
| `pytest -n auto` | Parallel (pytest-xdist) |
| `pytest --cov=src` | With coverage |

---

## Best Practices

| Practice | Why |
|----------|-----|
| One assertion per test | Clear failures |
| Descriptive test names | Self-documenting |
| Arrange-Act-Assert | Consistent structure |
| Test behavior, not implementation | Refactor-proof |
| Use factories for test data | Maintainable |
| Keep tests fast | Run often |

## Resources

- Pytest docs: <https://docs.pytest.org/>
- pytest-asyncio: <https://pytest-asyncio.readthedocs.io/>
