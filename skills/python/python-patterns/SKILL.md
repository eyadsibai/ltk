---
name: Python Patterns
description: This skill should be used when the user asks about "Python best practices", "Pythonic code", "Python patterns", "Python idioms", "type hints", "dataclasses", "async Python", "Python decorators", "context managers", or mentions Python-specific coding patterns.
version: 1.0.0
---

# Python Patterns

Guidance for writing idiomatic, modern Python code following best practices.

## Modern Python Features

### Type Hints (Python 3.9+)

```python
# Basic types
def greet(name: str) -> str:
    return f"Hello, {name}"

# Collections (no need for typing module in 3.9+)
def process(items: list[str]) -> dict[str, int]:
    return {item: len(item) for item in items}

# Optional values
def find_user(user_id: int) -> User | None:
    ...

# Union types
def parse(value: str | int) -> str:
    return str(value)
```

### Dataclasses

```python
from dataclasses import dataclass, field

@dataclass
class User:
    name: str
    email: str
    age: int = 0
    tags: list[str] = field(default_factory=list)

    def __post_init__(self):
        self.email = self.email.lower()

# Frozen (immutable)
@dataclass(frozen=True)
class Config:
    host: str
    port: int
```

### Context Managers

```python
from contextlib import contextmanager

@contextmanager
def managed_resource(name: str):
    print(f"Acquiring {name}")
    resource = acquire(name)
    try:
        yield resource
    finally:
        print(f"Releasing {name}")
        resource.release()

# Usage
with managed_resource("db") as db:
    db.query(...)
```

### Decorators

```python
import functools
from typing import Callable, TypeVar

T = TypeVar("T")

def retry(attempts: int = 3):
    def decorator(func: Callable[..., T]) -> Callable[..., T]:
        @functools.wraps(func)
        def wrapper(*args, **kwargs) -> T:
            for attempt in range(attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == attempts - 1:
                        raise
            raise RuntimeError("Should not reach here")
        return wrapper
    return decorator

@retry(attempts=3)
def fetch_data():
    ...
```

## Async Python

### Basic Async/Await

```python
import asyncio

async def fetch_user(user_id: int) -> User:
    async with aiohttp.ClientSession() as session:
        async with session.get(f"/users/{user_id}") as resp:
            data = await resp.json()
            return User(**data)

async def fetch_all_users(user_ids: list[int]) -> list[User]:
    tasks = [fetch_user(uid) for uid in user_ids]
    return await asyncio.gather(*tasks)
```

### Async Context Managers

```python
from contextlib import asynccontextmanager

@asynccontextmanager
async def get_db_connection():
    conn = await create_connection()
    try:
        yield conn
    finally:
        await conn.close()
```

## Pythonic Idioms

### Comprehensions

```python
# List comprehension
squares = [x**2 for x in range(10) if x % 2 == 0]

# Dict comprehension
word_lengths = {word: len(word) for word in words}

# Set comprehension
unique_lengths = {len(word) for word in words}

# Generator expression (memory efficient)
sum_squares = sum(x**2 for x in range(1000000))
```

### Unpacking

```python
# Multiple assignment
a, b = b, a  # Swap

# Extended unpacking
first, *middle, last = [1, 2, 3, 4, 5]

# Dict unpacking
defaults = {"timeout": 30, "retries": 3}
config = {**defaults, "timeout": 60}  # Override
```

### EAFP (Easier to Ask Forgiveness)

```python
# Pythonic (EAFP)
try:
    value = my_dict[key]
except KeyError:
    value = default

# Or use .get()
value = my_dict.get(key, default)

# Not Pythonic (LBYL)
if key in my_dict:
    value = my_dict[key]
else:
    value = default
```

## Project Structure

```
my_project/
├── src/
│   └── my_package/
│       ├── __init__.py
│       ├── main.py
│       ├── models/
│       ├── services/
│       └── utils/
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   └── test_main.py
├── pyproject.toml
├── README.md
└── .python-version
```

## pyproject.toml Template

```toml
[project]
name = "my-package"
version = "0.1.0"
description = "Description"
requires-python = ">=3.11"
dependencies = [
    "httpx>=0.24",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "black>=23.0",
    "mypy>=1.0",
    "ruff>=0.1",
]

[tool.black]
line-length = 88

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W"]

[tool.mypy]
python_version = "3.11"
strict = true

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --tb=short"
```
