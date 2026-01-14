---
name: wandb
description: Use when "Weights and Biases", "W&B", "wandb", "experiment tracking", or asking about "log training", "hyperparameter sweeps", "real-time dashboard", "model registry", "ML collaboration", "training visualization"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/weights-and-biases -->

# Weights & Biases (W&B) Experiment Tracking

Real-time ML experiment tracking, hyperparameter sweeps, and collaboration.

## When to Use

- Track experiments with automatic logging
- Real-time training visualization dashboards
- Hyperparameter optimization (sweeps)
- Compare runs across configurations
- Team collaboration on ML projects

## Quick Start

```python
import wandb

# Initialize
run = wandb.init(
    project="my-project",
    config={
        "learning_rate": 0.001,
        "epochs": 10,
        "batch_size": 32
    }
)

# Training loop
for epoch in range(config.epochs):
    loss = train_epoch()

    # Log metrics
    wandb.log({
        "epoch": epoch,
        "loss": loss,
        "accuracy": accuracy
    })

wandb.finish()
```

## Configuration

```python
# Initialize with config
run = wandb.init(
    project="image-classification",
    name="resnet50-baseline",       # Run name
    tags=["baseline", "resnet"],    # Tags for filtering
    notes="First baseline run",     # Notes
    config={
        "model": "ResNet50",
        "lr": 0.001,
        "batch_size": 32
    }
)

# Access config
config = wandb.config
print(config.lr)
```

## Logging

```python
# Log metrics
wandb.log({"loss": 0.5, "accuracy": 0.9})

# Log with step
for step in range(1000):
    wandb.log({"loss": loss, "step": step})

# Log images
wandb.log({"examples": [wandb.Image(img) for img in images]})

# Log tables
table = wandb.Table(columns=["id", "prediction", "label"])
table.add_data(1, "cat", "cat")
wandb.log({"predictions": table})

# Log plots
wandb.log({"chart": wandb.plot.line(...)})
```

## PyTorch Integration

```python
import wandb
import torch

wandb.init(project="pytorch-demo")

# Watch model (log gradients, weights)
wandb.watch(model, log="all", log_freq=100)

# Training loop
for epoch in range(epochs):
    for batch in train_loader:
        loss = train_step(batch)
        wandb.log({"loss": loss})

# Save model
torch.save(model.state_dict(), "model.pth")
wandb.save("model.pth")

wandb.finish()
```

## Lightning Integration

```python
from lightning.pytorch.loggers import WandbLogger

logger = WandbLogger(project="lightning-project")

trainer = L.Trainer(logger=logger)
trainer.fit(model, train_loader)
```

## HuggingFace Integration

```python
from transformers import TrainingArguments

training_args = TrainingArguments(
    report_to="wandb",
    run_name="bert-finetuning"
)

# Trainer automatically logs to W&B
trainer = Trainer(args=training_args, ...)
trainer.train()
```

## Hyperparameter Sweeps

```python
# Define sweep config
sweep_config = {
    "method": "bayes",  # 'grid', 'random', 'bayes'
    "metric": {"name": "val_loss", "goal": "minimize"},
    "parameters": {
        "learning_rate": {"min": 1e-5, "max": 1e-2, "distribution": "log_uniform"},
        "batch_size": {"values": [16, 32, 64]},
        "epochs": {"value": 10}
    }
}

# Create sweep
sweep_id = wandb.sweep(sweep_config, project="sweep-demo")

# Define training function
def train():
    run = wandb.init()
    config = wandb.config

    model = train_model(
        lr=config.learning_rate,
        batch_size=config.batch_size
    )

    wandb.log({"val_loss": val_loss})

# Run sweep
wandb.agent(sweep_id, function=train, count=20)
```

## Artifacts (Model Registry)

```python
# Log artifact
artifact = wandb.Artifact("model", type="model")
artifact.add_file("model.pth")
wandb.log_artifact(artifact)

# Download artifact
artifact = run.use_artifact("my-project/model:latest")
artifact_dir = artifact.download()

# Link to model registry
run.link_artifact(artifact, "model-registry/my-model")
```

## Best Practices

1. **Use config** for all hyperparameters
2. **Add tags** for easy filtering
3. **Log frequently** for real-time monitoring
4. **Use sweeps** for hyperparameter search
5. **Save artifacts** for reproducibility

## vs Alternatives

| Tool | Best For |
|------|----------|
| **W&B** | Real-time viz, collaboration, sweeps |
| MLflow | Open source, self-hosted |
| TensorBoard | Free, local, TensorFlow native |

## Resources

- Docs: <https://docs.wandb.ai/>
- Examples: <https://github.com/wandb/examples>
