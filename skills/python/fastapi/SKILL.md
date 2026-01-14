---
name: FastAPI
description: This skill should be used when the user asks about "FastAPI", "FastAPI routes", "FastAPI dependencies", "Pydantic models", "FastAPI middleware", "API endpoints", "OpenAPI", or mentions FastAPI development.
version: 1.0.0
---

# FastAPI Development

Guidance for building APIs with FastAPI following best practices.

## Basic Structure

```python
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel

app = FastAPI(
    title="My API",
    description="API description",
    version="1.0.0",
)

class ItemCreate(BaseModel):
    name: str
    price: float

class Item(ItemCreate):
    id: int

    class Config:
        from_attributes = True

@app.post("/items", response_model=Item, status_code=201)
async def create_item(item: ItemCreate):
    return Item(id=1, **item.model_dump())
```

## Dependency Injection

```python
from fastapi import Depends
from typing import Annotated

async def get_db():
    db = Database()
    try:
        yield db
    finally:
        await db.close()

async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    db: Annotated[Database, Depends(get_db)],
) -> User:
    user = await db.get_user_by_token(token)
    if not user:
        raise HTTPException(status_code=401)
    return user

# Type alias for reuse
CurrentUser = Annotated[User, Depends(get_current_user)]

@app.get("/me")
async def get_me(user: CurrentUser):
    return user
```

## Request Validation

```python
from pydantic import BaseModel, Field, field_validator

class UserCreate(BaseModel):
    email: str = Field(..., pattern=r"^[\w\.-]+@[\w\.-]+\.\w+$")
    password: str = Field(..., min_length=8)
    age: int = Field(..., ge=0, le=150)

    @field_validator("email")
    @classmethod
    def email_lowercase(cls, v: str) -> str:
        return v.lower()
```

## Error Handling

```python
from fastapi import HTTPException
from fastapi.responses import JSONResponse

class AppException(Exception):
    def __init__(self, code: str, message: str, status: int = 400):
        self.code = code
        self.message = message
        self.status = status

@app.exception_handler(AppException)
async def app_exception_handler(request, exc: AppException):
    return JSONResponse(
        status_code=exc.status,
        content={"code": exc.code, "message": exc.message},
    )

# Usage
raise AppException("USER_NOT_FOUND", "User does not exist", 404)
```

## Router Organization

```python
# routers/users.py
from fastapi import APIRouter

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/")
async def list_users():
    ...

@router.get("/{user_id}")
async def get_user(user_id: int):
    ...

# main.py
from routers import users, items

app.include_router(users.router)
app.include_router(items.router)
```

## Background Tasks

```python
from fastapi import BackgroundTasks

def send_email(email: str, message: str):
    # Slow operation
    ...

@app.post("/notify")
async def notify(
    email: str,
    background_tasks: BackgroundTasks,
):
    background_tasks.add_task(send_email, email, "Hello!")
    return {"status": "queued"}
```

## Testing

```python
from fastapi.testclient import TestClient
import pytest

@pytest.fixture
def client():
    return TestClient(app)

def test_create_item(client):
    response = client.post("/items", json={"name": "Test", "price": 9.99})
    assert response.status_code == 201
    assert response.json()["name"] == "Test"

# Async tests
import pytest_asyncio
from httpx import AsyncClient

@pytest_asyncio.fixture
async def async_client():
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client

@pytest.mark.asyncio
async def test_async_endpoint(async_client):
    response = await async_client.get("/")
    assert response.status_code == 200
```

## Project Structure

```
my_api/
├── src/
│   └── my_api/
│       ├── __init__.py
│       ├── main.py
│       ├── config.py
│       ├── dependencies.py
│       ├── routers/
│       │   ├── __init__.py
│       │   ├── users.py
│       │   └── items.py
│       ├── models/
│       │   ├── __init__.py
│       │   └── user.py
│       ├── schemas/
│       │   ├── __init__.py
│       │   └── user.py
│       └── services/
│           └── user_service.py
├── tests/
├── pyproject.toml
└── Dockerfile
```
