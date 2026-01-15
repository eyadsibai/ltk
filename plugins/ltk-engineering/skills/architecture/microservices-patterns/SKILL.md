---
name: microservices-patterns
description: Use when designing microservices architectures, decomposing monoliths, implementing service boundaries, inter-service communication, or asking about "microservices", "service decomposition", "API gateway", "circuit breaker", "distributed systems"
version: 1.0.0
---

# Microservices Patterns

Design microservices architectures with service boundaries, event-driven communication, and resilience patterns.

## Service Decomposition Strategies

### By Business Capability

- Organize services around business functions
- Each service owns its domain
- Example: OrderService, PaymentService, InventoryService

### By Subdomain (DDD)

- Core domain, supporting subdomains
- Bounded contexts map to services
- Clear ownership and responsibility

### Strangler Fig Pattern

- Gradually extract from monolith
- New functionality as microservices
- Proxy routes to old/new systems

## Communication Patterns

### Synchronous (Request/Response)

```python
from tenacity import retry, stop_after_attempt, wait_exponential

class ServiceClient:
    def __init__(self, base_url: str):
        self.base_url = base_url
        self.client = httpx.AsyncClient(timeout=5.0)

    @retry(stop=stop_after_attempt(3), wait=wait_exponential(min=2, max=10))
    async def get(self, path: str, **kwargs):
        response = await self.client.get(f"{self.base_url}{path}", **kwargs)
        response.raise_for_status()
        return response.json()
```

### Asynchronous (Events/Messages)

```python
from aiokafka import AIOKafkaProducer

class EventBus:
    async def publish(self, event: DomainEvent):
        await self.producer.send_and_wait(
            event.event_type,
            value=asdict(event),
            key=event.aggregate_id.encode()
        )
```

## Resilience Patterns

### Circuit Breaker

```python
class CircuitBreaker:
    def __init__(self, failure_threshold=5, recovery_timeout=30):
        self.failure_threshold = failure_threshold
        self.recovery_timeout = recovery_timeout
        self.state = CircuitState.CLOSED

    async def call(self, func, *args, **kwargs):
        if self.state == CircuitState.OPEN:
            if self._should_attempt_reset():
                self.state = CircuitState.HALF_OPEN
            else:
                raise CircuitBreakerOpenError()

        try:
            result = await func(*args, **kwargs)
            self._on_success()
            return result
        except Exception:
            self._on_failure()
            raise
```

### Bulkhead Pattern

- Isolate resources per service
- Limit impact of failures
- Prevent cascade failures

## API Gateway Pattern

```python
class APIGateway:
    @circuit(failure_threshold=5, recovery_timeout=30)
    async def call_service(self, service_url: str, path: str, **kwargs):
        response = await self.http_client.request("GET", f"{service_url}{path}", **kwargs)
        response.raise_for_status()
        return response.json()

    async def aggregate(self, order_id: str) -> dict:
        # Parallel requests to multiple services
        order, payment, inventory = await asyncio.gather(
            self.call_order_service(f"/orders/{order_id}"),
            self.call_payment_service(f"/payments/order/{order_id}"),
            self.call_inventory_service(f"/reservations/order/{order_id}"),
            return_exceptions=True
        )
        return {"order": order, "payment": payment, "inventory": inventory}
```

## Data Management

### Database Per Service

- Each service owns its data
- No shared databases
- Loose coupling

### Saga Pattern for Distributed Transactions

- See saga-orchestration skill for details

## Best Practices

1. **Service Boundaries**: Align with business capabilities
2. **Database Per Service**: No shared databases
3. **API Contracts**: Versioned, backward compatible
4. **Async When Possible**: Events over direct calls
5. **Circuit Breakers**: Fail fast on service failures
6. **Distributed Tracing**: Track requests across services
7. **Health Checks**: Liveness and readiness probes

## Common Pitfalls

- **Distributed Monolith**: Tightly coupled services
- **Chatty Services**: Too many inter-service calls
- **No Circuit Breakers**: Cascade failures
- **Synchronous Everything**: Tight coupling
- **Ignoring Network Failures**: Assuming reliable network
