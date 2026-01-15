---
name: saga-orchestration
description: Use when implementing distributed transactions, coordinating multi-service workflows, handling compensating transactions, or asking about "saga pattern", "distributed transactions", "compensating actions", "workflow orchestration", "choreography vs orchestration"
version: 1.0.0
---

# Saga Orchestration

Patterns for managing distributed transactions and long-running business processes.

## Saga Types

### Choreography

```
┌─────┐  ┌─────┐  ┌─────┐
│Svc A│─►│Svc B│─►│Svc C│
└─────┘  └─────┘  └─────┘
   │        │        │
   ▼        ▼        ▼
 Event    Event    Event
```

- Services react to events
- Decentralized control
- Good for simple flows

### Orchestration

```
     ┌─────────────┐
     │ Orchestrator│
     └──────┬──────┘
            │
      ┌─────┼─────┐
      ▼     ▼     ▼
   ┌────┐┌────┐┌────┐
   │Svc1││Svc2││Svc3│
   └────┘└────┘└────┘
```

- Central coordinator
- Explicit control flow
- Better for complex flows

## Saga States

| State | Description |
|-------|-------------|
| **Started** | Saga initiated |
| **Pending** | Waiting for step |
| **Compensating** | Rolling back |
| **Completed** | All steps succeeded |
| **Failed** | Failed after compensation |

## Orchestrator Implementation

```python
@dataclass
class SagaStep:
    name: str
    action: str
    compensation: str
    status: str = "pending"

class SagaOrchestrator:
    async def execute(self, data: dict) -> SagaResult:
        completed_steps = []
        context = {"data": data}

        for step in self.steps:
            result = await step.action(context)
            if not result.success:
                await self.compensate(completed_steps, context)
                return SagaResult(status="failed", error=result.error)

            completed_steps.append(step)
            context.update(result.data)

        return SagaResult(status="completed", data=context)

    async def compensate(self, completed_steps, context):
        for step in reversed(completed_steps):
            await step.compensation(context)
```

## Order Fulfillment Saga Example

```python
class OrderFulfillmentSaga(SagaOrchestrator):
    def define_steps(self, data):
        return [
            SagaStep("reserve_inventory",
                     action=self.reserve_inventory,
                     compensation=self.release_inventory),
            SagaStep("process_payment",
                     action=self.process_payment,
                     compensation=self.refund_payment),
            SagaStep("create_shipment",
                     action=self.create_shipment,
                     compensation=self.cancel_shipment),
        ]
```

## Choreography Example

```python
class OrderChoreographySaga:
    def __init__(self, event_bus):
        self.event_bus = event_bus
        event_bus.subscribe("OrderCreated", self._on_order_created)
        event_bus.subscribe("InventoryReserved", self._on_inventory_reserved)
        event_bus.subscribe("PaymentFailed", self._on_payment_failed)

    async def _on_order_created(self, event):
        await self.event_bus.publish("ReserveInventory", {
            "order_id": event["order_id"],
            "items": event["items"]
        })

    async def _on_payment_failed(self, event):
        # Compensation
        await self.event_bus.publish("ReleaseInventory", {
            "reservation_id": event["reservation_id"]
        })
```

## Best Practices

1. **Make steps idempotent** - Safe to retry
2. **Design compensations carefully** - Must always work
3. **Use correlation IDs** - For tracing across services
4. **Implement timeouts** - Don't wait forever
5. **Log everything** - For debugging failures

## When to Use

**Orchestration:**

- Complex multi-step workflows
- Need visibility into saga state
- Central error handling

**Choreography:**

- Simple event flows
- Loose coupling required
- Independent service teams
