---
name: mlflow
description: Use when "MLflow", "experiment tracking", "model registry", "MLOps", or asking about "track experiments", "log metrics", "model versioning", "model deployment", "hyperparameter logging", "artifact tracking"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/mlflow -->

# MLflow ML Lifecycle Platform

Track experiments, manage model registry, deploy models - framework-agnostic MLOps.

## When to Use

- Track ML experiments (parameters, metrics, artifacts)
- Version and stage models (Staging → Production)
- Compare model performance across runs
- Deploy models to production
- Reproduce experiments

## Quick Start

```python
import mlflow

# Start tracking
with mlflow.start_run():
    mlflow.log_param("learning_rate", 0.001)
    mlflow.log_param("epochs", 10)

    # Train model
    model = train_model()

    # Log metrics
    mlflow.log_metric("accuracy", 0.95)
    mlflow.log_metric("loss", 0.15)

    # Log model
    mlflow.sklearn.log_model(model, "model")

# View at http://localhost:5000
# mlflow ui
```

## Autologging

```python
import mlflow

# Enable automatic logging
mlflow.autolog()

# For specific frameworks
mlflow.sklearn.autolog()
mlflow.pytorch.autolog()
mlflow.keras.autolog()
mlflow.xgboost.autolog()

# Train - everything logged automatically
model = RandomForestClassifier(n_estimators=100)
model.fit(X_train, y_train)
```

## Logging

```python
with mlflow.start_run(run_name="experiment-1"):
    # Parameters
    mlflow.log_param("learning_rate", 0.001)
    mlflow.log_params({"batch_size": 32, "epochs": 50})

    # Metrics (with step for time series)
    for epoch in range(epochs):
        mlflow.log_metric("loss", loss, step=epoch)
        mlflow.log_metric("accuracy", acc, step=epoch)

    # Artifacts (files)
    mlflow.log_artifact("model.pkl")
    mlflow.log_artifacts("plots/")  # Directory

    # Tags
    mlflow.set_tag("dataset", "ImageNet")
    mlflow.set_tag("framework", "PyTorch")
```

## Log Models

```python
# Scikit-learn
mlflow.sklearn.log_model(model, "model")

# PyTorch
mlflow.pytorch.log_model(model, "model")

# Keras
mlflow.keras.log_model(model, "model")

# HuggingFace
mlflow.transformers.log_model(
    transformers_model={"model": model, "tokenizer": tokenizer},
    artifact_path="model"
)

# Any model (generic)
mlflow.pyfunc.log_model("model", python_model=my_model)
```

## Model Registry

```python
# Register model
with mlflow.start_run():
    mlflow.sklearn.log_model(
        model, "model",
        registered_model_name="my-classifier"
    )

# Or register existing run
mlflow.register_model("runs:/abc123/model", "my-classifier")
```

### Stage Transitions

```python
from mlflow.tracking import MlflowClient

client = MlflowClient()

# Promote to staging
client.transition_model_version_stage(
    name="my-classifier",
    version=3,
    stage="Staging"
)

# Promote to production
client.transition_model_version_stage(
    name="my-classifier",
    version=3,
    stage="Production",
    archive_existing_versions=True
)
```

### Load from Registry

```python
import mlflow.pyfunc

# Load production model
model = mlflow.pyfunc.load_model("models:/my-classifier/Production")

# Load specific version
model = mlflow.pyfunc.load_model("models:/my-classifier/3")

# Predict
predictions = model.predict(X_test)
```

## Search Runs

```python
from mlflow.tracking import MlflowClient

client = MlflowClient()

# Search runs
runs = client.search_runs(
    experiment_ids=["1"],
    filter_string="metrics.accuracy > 0.9",
    order_by=["metrics.accuracy DESC"],
    max_results=10
)

for run in runs:
    print(f"Run: {run.info.run_id}")
    print(f"Accuracy: {run.data.metrics['accuracy']}")
```

## Serving

```bash
# Serve model locally
mlflow models serve -m "models:/my-classifier/Production" -p 5001

# Test endpoint
curl http://127.0.0.1:5001/invocations \
  -H 'Content-Type: application/json' \
  -d '{"inputs": [[1.0, 2.0, 3.0, 4.0]]}'
```

## Best Practices

1. **Use experiments** to organize related runs
2. **Use autolog** for automatic tracking
3. **Log comprehensive metadata** (params, tags, artifacts)
4. **Use model registry** for production deployment
5. **Include log_likelihood=True** for model comparison

## vs Alternatives

| Tool | Best For |
|------|----------|
| **MLflow** | Open source, self-hosted, framework-agnostic |
| W&B | Real-time viz, team collaboration, cloud |
| Neptune | Team experiments, comparison dashboards |

## Resources

- Docs: <https://mlflow.org/docs/latest>
- Examples: <https://github.com/mlflow/mlflow/tree/master/examples>
