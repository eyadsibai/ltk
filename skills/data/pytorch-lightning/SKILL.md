---
name: pytorch-lightning
description: Use when "PyTorch Lightning", "Lightning", "Trainer class", "distributed training", or asking about "DDP training", "FSDP", "DeepSpeed", "training loop", "callbacks", "automatic mixed precision", "multi-GPU training"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/pytorch-lightning -->

# PyTorch Lightning Training Framework

High-level PyTorch framework with minimal boilerplate - scales from laptop to cluster.

## When to Use

- Clean, organized PyTorch training code
- Automatic distributed training (DDP, FSDP, DeepSpeed)
- Built-in logging, checkpointing, callbacks
- Mixed precision training
- Multi-GPU or multi-node scaling

## Quick Start

```python
import lightning as L
import torch
from torch import nn

class LitModel(L.LightningModule):
    def __init__(self, hidden_size=128):
        super().__init__()
        self.model = nn.Sequential(
            nn.Linear(28 * 28, hidden_size),
            nn.ReLU(),
            nn.Linear(hidden_size, 10)
        )

    def training_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self.model(x)
        loss = nn.functional.cross_entropy(y_hat, y)
        self.log('train_loss', loss)
        return loss

    def configure_optimizers(self):
        return torch.optim.Adam(self.parameters(), lr=1e-3)

# Train
trainer = L.Trainer(max_epochs=10, accelerator='gpu')
trainer.fit(LitModel(), train_loader)
```

## LightningModule Structure

```python
class LitModel(L.LightningModule):
    def __init__(self):
        super().__init__()
        self.model = MyModel()

    def training_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self.model(x)
        loss = nn.functional.cross_entropy(y_hat, y)
        self.log('train_loss', loss)
        return loss

    def validation_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self.model(x)
        val_loss = nn.functional.cross_entropy(y_hat, y)
        acc = (y_hat.argmax(dim=1) == y).float().mean()
        self.log('val_loss', val_loss)
        self.log('val_acc', acc)

    def test_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self.model(x)
        self.log('test_loss', nn.functional.cross_entropy(y_hat, y))

    def configure_optimizers(self):
        optimizer = torch.optim.Adam(self.parameters(), lr=1e-3)
        scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=100)
        return {'optimizer': optimizer, 'lr_scheduler': scheduler}
```

## Trainer Configuration

```python
trainer = L.Trainer(
    max_epochs=10,
    accelerator='gpu',
    devices=2,
    strategy='ddp',           # 'ddp', 'fsdp', 'deepspeed'
    precision='bf16-mixed',   # 'fp16', 'bf16', 'bf16-mixed'
    accumulate_grad_batches=4,
    gradient_clip_val=1.0,
    callbacks=[...],
    logger=...,
)

# Train
trainer.fit(model, train_loader, val_loader)

# Test
trainer.test(model, test_loader)
```

## Callbacks

```python
from lightning.pytorch.callbacks import (
    ModelCheckpoint, EarlyStopping, LearningRateMonitor
)

checkpoint = ModelCheckpoint(
    monitor='val_loss',
    mode='min',
    save_top_k=3,
    filename='model-{epoch:02d}-{val_loss:.2f}'
)

early_stop = EarlyStopping(
    monitor='val_loss',
    patience=5,
    mode='min'
)

lr_monitor = LearningRateMonitor(logging_interval='epoch')

trainer = L.Trainer(
    callbacks=[checkpoint, early_stop, lr_monitor]
)
```

## Distributed Training

```python
# Single GPU
trainer = L.Trainer(accelerator='gpu', devices=1)

# Multi-GPU with DDP
trainer = L.Trainer(accelerator='gpu', devices=4, strategy='ddp')

# FSDP (for large models)
trainer = L.Trainer(accelerator='gpu', devices=4, strategy='fsdp')

# DeepSpeed
trainer = L.Trainer(accelerator='gpu', devices=4, strategy='deepspeed')

# Multi-node
trainer = L.Trainer(
    accelerator='gpu',
    devices=8,
    num_nodes=2,
    strategy='ddp'
)
```

## Logging

```python
from lightning.pytorch.loggers import TensorBoardLogger, WandbLogger

# TensorBoard
logger = TensorBoardLogger('logs/', name='my_model')

# Weights & Biases
logger = WandbLogger(project='my-project', name='run-1')

trainer = L.Trainer(logger=logger)

# In LightningModule
self.log('train_loss', loss)
self.log_dict({'acc': acc, 'f1': f1})
```

## Best Practices

1. **Use LightningModule** to organize code cleanly
2. **Log metrics** with `self.log()` for automatic aggregation
3. **Use callbacks** for checkpointing, early stopping
4. **Start with DDP** for multi-GPU, FSDP for large models
5. **Use bf16-mixed** precision on A100/H100

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Lightning** | Clean code, automatic distributed, production |
| Accelerate | Minimal changes to existing PyTorch |
| Raw PyTorch | Maximum control, learning |

## Resources

- Docs: <https://lightning.ai/docs/pytorch/stable/>
- Examples: <https://github.com/Lightning-AI/pytorch-lightning/tree/master/examples>
