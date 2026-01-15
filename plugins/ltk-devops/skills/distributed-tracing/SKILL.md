---
name: distributed-tracing
description: Use when implementing distributed tracing, using Jaeger or Tempo, debugging microservices latency, or asking about "tracing", "Jaeger", "OpenTelemetry", "spans", "traces", "observability"
version: 1.0.0
---

# Distributed Tracing

Implement distributed tracing with Jaeger and OpenTelemetry for request flow visibility.

## Trace Structure

```
Trace (Request ID: abc123)
  ↓
Span (frontend) [100ms]
  ↓
Span (api-gateway) [80ms]
  ├→ Span (auth-service) [10ms]
  └→ Span (user-service) [60ms]
      └→ Span (database) [40ms]
```

## Key Components

| Component | Description |
|-----------|-------------|
| **Trace** | End-to-end request journey |
| **Span** | Single operation within a trace |
| **Context** | Metadata propagated between services |
| **Tags** | Key-value pairs for filtering |

## OpenTelemetry Setup (Python)

```python
from opentelemetry import trace
from opentelemetry.exporter.jaeger.thrift import JaegerExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.instrumentation.flask import FlaskInstrumentor

# Initialize
provider = TracerProvider()
processor = BatchSpanProcessor(JaegerExporter(
    agent_host_name="jaeger",
    agent_port=6831,
))
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

# Instrument Flask
app = Flask(__name__)
FlaskInstrumentor().instrument_app(app)

# Custom spans
@app.route('/api/users')
def get_users():
    tracer = trace.get_tracer(__name__)
    with tracer.start_as_current_span("get_users") as span:
        span.set_attribute("user.count", 100)
        return fetch_users()
```

## OpenTelemetry Setup (Node.js)

```javascript
const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node');
const { JaegerExporter } = require('@opentelemetry/exporter-jaeger');

const provider = new NodeTracerProvider();
provider.addSpanProcessor(new BatchSpanProcessor(
    new JaegerExporter({ endpoint: 'http://jaeger:14268/api/traces' })
));
provider.register();
```

## Context Propagation

```python
# Inject trace context into HTTP headers
from opentelemetry.propagate import inject

headers = {}
inject(headers)  # Adds traceparent header
response = requests.get('http://downstream/api', headers=headers)
```

## Sampling Strategies

```yaml
# Probabilistic - sample 1%
sampler:
  type: probabilistic
  param: 0.01

# Rate limiting - max 100/sec
sampler:
  type: ratelimiting
  param: 100
```

## Jaeger Queries

```
# Find slow requests
service=my-service duration > 1s

# Find errors
service=my-service error=true tags.http.status_code >= 500
```

## Correlated Logging

```python
def process_request():
    span = trace.get_current_span()
    trace_id = span.get_span_context().trace_id
    logger.info("Processing", extra={"trace_id": format(trace_id, '032x')})
```

## Best Practices

1. **Sample appropriately** (1-10% in production)
2. **Add meaningful tags** (user_id, request_id)
3. **Propagate context** across all boundaries
4. **Log exceptions** in spans
5. **Use consistent naming** for operations
6. **Monitor tracing overhead** (<1% CPU impact)
7. **Correlate with logs** using trace IDs
