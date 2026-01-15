---
name: cqrs
description: Use when implementing CQRS pattern, separating read and write models, optimizing query performance, or asking about "CQRS", "Command Query Responsibility Segregation", "read model", "write model", "command bus", "query bus"
version: 1.0.0
---

# CQRS Implementation

Command Query Responsibility Segregation for scalable architectures.

## Architecture

```
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
       ┌─────────────┐          ┌─────────────┐
       │  Commands   │          │   Queries   │
       │    API      │          │    API      │
       └──────┬──────┘          └──────┬──────┘
              │                         │
              ▼                         ▼
       ┌─────────────┐          ┌─────────────┐
       │   Write     │─────────►│    Read     │
       │   Model     │  Events  │   Model     │
       └─────────────┘          └─────────────┘
```

## Command Infrastructure

```python
@dataclass
class Command:
    command_id: str = field(default_factory=lambda: str(uuid.uuid4()))
    timestamp: datetime = field(default_factory=datetime.utcnow)

@dataclass
class CreateOrder(Command):
    customer_id: str
    items: list
    shipping_address: dict

class CommandHandler(ABC, Generic[T]):
    @abstractmethod
    async def handle(self, command: T) -> Any:
        pass

class CommandBus:
    def __init__(self):
        self._handlers: Dict[Type[Command], CommandHandler] = {}

    def register(self, command_type, handler):
        self._handlers[command_type] = handler

    async def dispatch(self, command: Command) -> Any:
        handler = self._handlers.get(type(command))
        return await handler.handle(command)
```

## Query Infrastructure

```python
@dataclass
class GetOrderById(Query):
    order_id: str

@dataclass
class OrderView:
    order_id: str
    customer_id: str
    status: str
    total_amount: float
    created_at: datetime

class GetOrderByIdHandler(QueryHandler[GetOrderById, OrderView]):
    async def handle(self, query: GetOrderById) -> Optional[OrderView]:
        row = await self.read_db.fetchrow(
            "SELECT * FROM order_views WHERE order_id = $1",
            query.order_id
        )
        return OrderView(**dict(row)) if row else None
```

## FastAPI Integration

```python
# Command endpoints (POST, PUT, DELETE)
@app.post("/orders")
async def create_order(request: CreateOrderRequest, command_bus: CommandBus = Depends()):
    command = CreateOrder(
        customer_id=request.customer_id,
        items=request.items
    )
    order_id = await command_bus.dispatch(command)
    return {"order_id": order_id}

# Query endpoints (GET)
@app.get("/orders/{order_id}")
async def get_order(order_id: str, query_bus: QueryBus = Depends()):
    query = GetOrderById(order_id=order_id)
    return await query_bus.dispatch(query)
```

## Read Model Synchronization

```python
class ReadModelSynchronizer:
    async def sync_projection(self, projection: Projection):
        checkpoint = await self._get_checkpoint(projection.name)
        events = await self.event_store.read_all(from_position=checkpoint)

        for event in events:
            if event.event_type in projection.handles():
                await projection.apply(event)
            await self._save_checkpoint(projection.name, event.position)

    async def rebuild_projection(self, projection_name: str):
        projection = self.projections[projection_name]
        await projection.clear()
        await self._save_checkpoint(projection_name, 0)
        # Rebuild from beginning
```

## Eventual Consistency

```python
async def query_after_command(self, query, expected_version, stream_id, timeout=5.0):
    """Read-your-writes consistency."""
    start = time.time()
    while time.time() - start < timeout:
        projection_version = await self._get_projection_version(stream_id)
        if projection_version >= expected_version:
            return await self.execute_query(query)
        await asyncio.sleep(0.1)

    return {"data": await self.execute_query(query), "_warning": "May be stale"}
```

## Best Practices

1. **Separate command and query models** - Different optimization needs
2. **Accept eventual consistency** - Define acceptable lag
3. **Validate in command handlers** - Before state change
4. **Denormalize read models** - Optimize for queries
5. **Version your events** - For schema evolution

## When to Use CQRS

**Good for:**

- Different read/write scaling needs
- Complex query requirements
- Event-sourced systems
- High-performance reporting

**Not for:**

- Simple CRUD applications
- No scaling requirements
- Small data sets
