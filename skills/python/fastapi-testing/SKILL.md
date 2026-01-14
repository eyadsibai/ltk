---
name: FastAPI Testing
description: This skill should be used when the user asks about "testing FastAPI", "FastAPI tests", "API testing", "test FastAPI endpoints", "mock FastAPI dependencies", "TestClient", "async API tests", or mentions testing FastAPI applications specifically.
version: 1.0.0
---

# FastAPI Testing

Specialized guidance for testing FastAPI applications - combines API patterns with pytest best practices.

## Why This Skill?

While `fastapi` and `pytest` skills cover their domains, this skill provides:
- FastAPI-specific test patterns
- Dependency injection testing
- Async endpoint testing
- Common FastAPI testing pitfalls

## Test Setup

### Basic Test Client

```python
import pytest
from fastapi.testclient import TestClient
from app.main import app

@pytest.fixture
def client():
    return TestClient(app)

def test_read_root(client):
    response = client.get("/")
    assert response.status_code == 200
```

### Async Test Client

```python
import pytest
from httpx import AsyncClient, ASGITransport
from app.main import app

@pytest.fixture
async def async_client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        yield client

@pytest.mark.asyncio
async def test_async_endpoint(async_client):
    response = await async_client.get("/async-endpoint")
    assert response.status_code == 200
```

## Testing with Dependencies

### Override Dependencies

```python
from app.main import app
from app.dependencies import get_db, get_current_user

# Mock database
def override_get_db():
    db = TestDatabase()
    try:
        yield db
    finally:
        db.close()

# Mock authentication
def override_get_current_user():
    return User(id=1, email="test@example.com")

@pytest.fixture
def client():
    app.dependency_overrides[get_db] = override_get_db
    app.dependency_overrides[get_current_user] = override_get_current_user
    yield TestClient(app)
    app.dependency_overrides.clear()
```

### Testing Protected Endpoints

```python
@pytest.fixture
def authenticated_client(client):
    # Override auth dependency
    app.dependency_overrides[get_current_user] = lambda: User(id=1, role="admin")
    yield client
    app.dependency_overrides.clear()

def test_admin_endpoint(authenticated_client):
    response = authenticated_client.get("/admin/users")
    assert response.status_code == 200
```

## Common Test Patterns

### Testing CRUD Operations

```python
class TestUserAPI:
    def test_create_user(self, client):
        response = client.post("/users", json={
            "email": "new@example.com",
            "password": "secret123"
        })
        assert response.status_code == 201
        assert response.json()["email"] == "new@example.com"
        assert "id" in response.json()

    def test_create_user_duplicate_email(self, client, existing_user):
        response = client.post("/users", json={
            "email": existing_user.email,
            "password": "secret123"
        })
        assert response.status_code == 400
        assert "already exists" in response.json()["detail"]

    def test_get_user(self, client, existing_user):
        response = client.get(f"/users/{existing_user.id}")
        assert response.status_code == 200
        assert response.json()["id"] == existing_user.id

    def test_get_user_not_found(self, client):
        response = client.get("/users/99999")
        assert response.status_code == 404
```

### Testing Validation

```python
@pytest.mark.parametrize("payload,expected_status", [
    ({"email": "valid@email.com", "password": "12345678"}, 201),
    ({"email": "invalid", "password": "12345678"}, 422),  # Invalid email
    ({"email": "valid@email.com", "password": "123"}, 422),  # Short password
    ({"email": "", "password": "12345678"}, 422),  # Empty email
    ({}, 422),  # Missing fields
])
def test_user_validation(client, payload, expected_status):
    response = client.post("/users", json=payload)
    assert response.status_code == expected_status
```

### Testing File Uploads

```python
def test_upload_file(client):
    files = {"file": ("test.txt", b"file content", "text/plain")}
    response = client.post("/upload", files=files)
    assert response.status_code == 200
    assert response.json()["filename"] == "test.txt"
```

## Database Testing

### Test Database Fixture

```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.database import Base

@pytest.fixture(scope="function")
def test_db():
    # In-memory SQLite for tests
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    TestSession = sessionmaker(bind=engine)

    db = TestSession()
    try:
        yield db
    finally:
        db.close()
        Base.metadata.drop_all(engine)

@pytest.fixture
def client(test_db):
    def override_get_db():
        yield test_db

    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()
```

## Project Structure

```
tests/
├── conftest.py          # Shared fixtures
├── test_users.py        # User endpoint tests
├── test_items.py        # Item endpoint tests
├── test_auth.py         # Authentication tests
└── factories/
    └── user_factory.py  # Test data factories
```

## conftest.py Template

```python
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.main import app
from app.database import Base, get_db
from app.models import User

@pytest.fixture(scope="session")
def engine():
    return create_engine("sqlite:///:memory:")

@pytest.fixture(scope="function")
def db(engine):
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)
    session = Session()
    yield session
    session.close()
    Base.metadata.drop_all(engine)

@pytest.fixture
def client(db):
    app.dependency_overrides[get_db] = lambda: db
    yield TestClient(app)
    app.dependency_overrides.clear()

@pytest.fixture
def test_user(db):
    user = User(email="test@example.com", hashed_password="...")
    db.add(user)
    db.commit()
    return user
```

## Common Pitfalls

1. **Forgetting to clear overrides**: Always clear `app.dependency_overrides`
2. **Shared state between tests**: Use function-scoped fixtures
3. **Testing implementation details**: Test behavior, not internals
4. **Missing async marks**: Use `@pytest.mark.asyncio` for async tests
