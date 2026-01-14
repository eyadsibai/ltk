---
name: Pytest
description: This skill should be used when the user asks about "pytest", "writing tests", "test fixtures", "parametrize", "mocking", "test coverage", "conftest", or mentions Python testing.
version: 1.0.0
---

# Pytest Testing

Guidance for writing effective tests with pytest.

## Basic Tests

```python
def test_addition():
    assert 1 + 1 == 2

def test_exception():
    with pytest.raises(ValueError, match="invalid"):
        raise ValueError("invalid input")

def test_approximate():
    assert 0.1 + 0.2 == pytest.approx(0.3)
```

## Fixtures

```python
import pytest

@pytest.fixture
def user():
    return User(name="Test", email="test@example.com")

@pytest.fixture
def db():
    """Database with automatic cleanup."""
    database = Database()
    yield database
    database.cleanup()

def test_user_save(user, db):
    db.save(user)
    assert db.get(user.id) == user
```

### Fixture Scopes

```python
@pytest.fixture(scope="function")  # Default, runs per test
def per_test():
    ...

@pytest.fixture(scope="class")  # Once per test class
def per_class():
    ...

@pytest.fixture(scope="module")  # Once per module
def per_module():
    ...

@pytest.fixture(scope="session")  # Once per test session
def per_session():
    ...
```

### conftest.py

```python
# tests/conftest.py - fixtures available to all tests
import pytest

@pytest.fixture
def app():
    return create_app(testing=True)

@pytest.fixture
def client(app):
    return app.test_client()

@pytest.fixture(autouse=True)
def reset_database(db):
    """Automatically reset DB before each test."""
    db.reset()
```

## Parametrize

```python
@pytest.mark.parametrize("input,expected", [
    ("hello", 5),
    ("world", 5),
    ("", 0),
])
def test_length(input, expected):
    assert len(input) == expected

# Multiple parameters
@pytest.mark.parametrize("x", [1, 2])
@pytest.mark.parametrize("y", [10, 20])
def test_multiply(x, y):
    assert x * y in [10, 20, 40]

# With IDs
@pytest.mark.parametrize("input,expected", [
    pytest.param("hello", 5, id="normal"),
    pytest.param("", 0, id="empty"),
    pytest.param(None, None, id="none", marks=pytest.mark.xfail),
])
def test_with_ids(input, expected):
    ...
```

## Mocking

```python
from unittest.mock import Mock, patch, MagicMock

def test_with_mock():
    mock_api = Mock()
    mock_api.get_user.return_value = {"id": 1, "name": "Test"}

    result = service.fetch_user(mock_api, 1)

    mock_api.get_user.assert_called_once_with(1)
    assert result["name"] == "Test"

@patch("mymodule.external_api")
def test_with_patch(mock_api):
    mock_api.fetch.return_value = "data"
    result = my_function()
    assert result == "data"

# Async mocking
@pytest.mark.asyncio
async def test_async_mock():
    mock = MagicMock()
    mock.fetch = AsyncMock(return_value="data")
    result = await mock.fetch()
    assert result == "data"
```

## Markers

```python
# Mark slow tests
@pytest.mark.slow
def test_slow_operation():
    ...

# Skip conditionally
@pytest.mark.skipif(sys.platform == "win32", reason="Unix only")
def test_unix_feature():
    ...

# Expected failures
@pytest.mark.xfail(reason="Known bug #123")
def test_known_bug():
    ...

# Run with: pytest -m "not slow"
```

### Custom Markers (pyproject.toml)

```toml
[tool.pytest.ini_options]
markers = [
    "slow: marks tests as slow",
    "integration: integration tests",
    "e2e: end-to-end tests",
]
```

## Async Tests

```python
import pytest

@pytest.mark.asyncio
async def test_async_function():
    result = await async_fetch()
    assert result == expected

# Async fixtures
@pytest_asyncio.fixture
async def async_db():
    db = await Database.connect()
    yield db
    await db.close()
```

## Coverage

```bash
# Run with coverage
pytest --cov=src --cov-report=html --cov-report=term-missing

# Fail if coverage below threshold
pytest --cov=src --cov-fail-under=80
```

### Coverage Config

```toml
[tool.coverage.run]
source = ["src"]
branch = true

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
]
```

## Test Organization

```
tests/
├── conftest.py           # Shared fixtures
├── unit/
│   ├── test_models.py
│   └── test_utils.py
├── integration/
│   ├── conftest.py       # Integration-specific fixtures
│   └── test_api.py
└── e2e/
    └── test_workflows.py
```

## Useful Commands

```bash
# Run all tests
pytest

# Verbose output
pytest -v

# Stop on first failure
pytest -x

# Run specific test
pytest tests/test_file.py::test_function

# Run tests matching pattern
pytest -k "user and not slow"

# Show print statements
pytest -s

# Parallel execution
pytest -n auto
```
