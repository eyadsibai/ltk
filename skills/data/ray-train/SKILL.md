---
name: ray-train
description: Use when "Ray Train", "distributed training orchestration", "multi-node training", or asking about "Ray cluster", "elastic training", "hyperparameter tuning", "Ray Tune", "fault-tolerant training", "scale training"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/08-distributed-training/ray-train -->

# Ray Train - Distributed Training Orchestration

Scale ML training from laptop to 1000s of nodes with fault tolerance and elastic scaling.

## When to Use

- Multi-node distributed training
- Hyperparameter tuning at scale (Ray Tune)
- Need fault tolerance (auto-restart failed workers)
- Elastic scaling (add/remove nodes during training)
- Framework-agnostic (PyTorch, TensorFlow, HuggingFace)

## Quick Start

```bash
pip install -U "ray[train]"
```

```python
import ray
from ray import train
from ray.train import ScalingConfig
from ray.train.torch import TorchTrainer
import torch

def train_func(config):
    model = torch.nn.Linear(10, 1)
    optimizer = torch.optim.SGD(model.parameters(), lr=0.01)

    # Prepare for distributed
    model = train.torch.prepare_model(model)

    for epoch in range(10):
        output = model(torch.randn(32, 10))
        loss = output.sum()
        loss.backward()
        optimizer.step()
        optimizer.zero_grad()

        # Report metrics
        train.report({"loss": loss.item(), "epoch": epoch})

# Run distributed training
trainer = TorchTrainer(
    train_func,
    scaling_config=ScalingConfig(num_workers=4, use_gpu=True)
)

result = trainer.fit()
print(f"Final loss: {result.metrics['loss']}")
```

## Scale Existing PyTorch Code

**Original:**

```python
model = MyModel().cuda()
optimizer = torch.optim.Adam(model.parameters())

for batch in dataloader:
    loss = model(batch)
    loss.backward()
    optimizer.step()
```

**With Ray Train:**

```python
from ray.train.torch import TorchTrainer
from ray import train

def train_func(config):
    model = MyModel()
    optimizer = torch.optim.Adam(model.parameters())

    # Prepare for distributed
    model = train.torch.prepare_model(model)
    dataloader = train.torch.prepare_data_loader(dataloader)

    for batch in dataloader:
        loss = model(batch)
        loss.backward()
        optimizer.step()
        train.report({"loss": loss.item()})

trainer = TorchTrainer(
    train_func,
    scaling_config=ScalingConfig(num_workers=8, use_gpu=True)
)
trainer.fit()
```

## HuggingFace Integration

```python
from ray.train.huggingface import TransformersTrainer
from transformers import AutoModelForCausalLM, TrainingArguments, Trainer

def train_func(config):
    model = AutoModelForCausalLM.from_pretrained("gpt2")

    training_args = TrainingArguments(
        output_dir="./output",
        num_train_epochs=3,
        per_device_train_batch_size=8,
    )

    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=train_dataset,
    )
    trainer.train()

trainer = TransformersTrainer(
    train_func,
    scaling_config=ScalingConfig(num_workers=16, use_gpu=True)
)
result = trainer.fit()
```

## Hyperparameter Tuning (Ray Tune)

```python
from ray import tune
from ray.tune.schedulers import ASHAScheduler

def train_func(config):
    lr = config["lr"]
    batch_size = config["batch_size"]

    model = MyModel()
    optimizer = torch.optim.Adam(model.parameters(), lr=lr)
    model = train.torch.prepare_model(model)

    for epoch in range(10):
        loss = train_epoch(model, optimizer, batch_size)
        train.report({"loss": loss})

# Search space
param_space = {
    "lr": tune.loguniform(1e-5, 1e-2),
    "batch_size": tune.choice([16, 32, 64, 128])
}

tuner = tune.Tuner(
    TorchTrainer(
        train_func,
        scaling_config=ScalingConfig(num_workers=4, use_gpu=True)
    ),
    param_space=param_space,
    tune_config=tune.TuneConfig(
        num_samples=20,
        scheduler=ASHAScheduler(metric="loss", mode="min")
    )
)

results = tuner.fit()
best = results.get_best_result(metric="loss", mode="min")
print(f"Best: {best.config}")
```

## Checkpointing and Fault Tolerance

```python
from ray.train import Checkpoint

def train_func(config):
    model = MyModel()
    optimizer = torch.optim.Adam(model.parameters())

    # Resume from checkpoint
    checkpoint = train.get_checkpoint()
    if checkpoint:
        with checkpoint.as_directory() as ckpt_dir:
            state = torch.load(f"{ckpt_dir}/model.pt")
            model.load_state_dict(state["model"])
            start_epoch = state["epoch"]
    else:
        start_epoch = 0

    model = train.torch.prepare_model(model)

    for epoch in range(start_epoch, 100):
        loss = train_epoch(model, optimizer)

        # Save checkpoint
        if epoch % 10 == 0:
            torch.save({
                "model": model.state_dict(),
                "epoch": epoch
            }, "model.pt")
            train.report({"loss": loss}, checkpoint=Checkpoint.from_directory("."))
```

## Multi-Node Training

```bash
# On head node
ray start --head --port=6379

# On worker nodes
ray start --address=<head-ip>:6379
```

```python
ray.init(address="auto")

trainer = TorchTrainer(
    train_func,
    scaling_config=ScalingConfig(
        num_workers=32,  # 4 nodes × 8 GPUs
        use_gpu=True,
        resources_per_worker={"GPU": 1, "CPU": 4},
        placement_strategy="SPREAD"
    )
)
result = trainer.fit()
```

## Best Practices

1. **Use `train.torch.prepare_model()`** for automatic distributed setup
2. **Use `train.report()`** for metric logging
3. **Enable checkpointing** for fault tolerance
4. **Use Ray Tune** for hyperparameter optimization
5. **Scale workers** based on available GPUs

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Ray Train** | Multi-node, hyperparameter tuning, fault tolerance |
| Accelerate | Single-node, simpler setup |
| PyTorch Lightning | High-level abstractions, callbacks |
| DeepSpeed | Maximum performance, complex setup |

## Resources

- Docs: <https://docs.ray.io/en/latest/train/train.html>
- GitHub: <https://github.com/ray-project/ray>
- Examples: <https://docs.ray.io/en/latest/train/examples.html>
