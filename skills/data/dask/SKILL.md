---
name: dask
description: Use when "Dask", "parallel computing", "distributed computing", "larger than memory", or asking about "parallel pandas", "parallel numpy", "out-of-core", "multi-file processing", "cluster computing", "lazy evaluation dataframe"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/dask -->

# Dask Parallel and Distributed Computing

Scale pandas/NumPy workflows beyond memory and across clusters.

## When to Use

- Datasets exceed available RAM
- Need to parallelize pandas or NumPy operations
- Processing multiple files efficiently (CSVs, Parquet)
- Building custom parallel workflows
- Distributing workloads across multiple cores/machines

## Quick Start

```python
import dask.dataframe as dd
import dask.array as da

# Parallel DataFrame (like pandas)
ddf = dd.read_csv('data/*.csv')
result = ddf.groupby('category').mean().compute()

# Parallel Array (like numpy)
x = da.random.random((10000, 10000), chunks=(1000, 1000))
result = x.mean().compute()
```

## Dask DataFrame

```python
import dask.dataframe as dd

# Read multiple files
ddf = dd.read_csv('data/2024-*.csv')
ddf = dd.read_parquet('data/*.parquet')

# Operations are lazy until compute()
filtered = ddf[ddf['value'] > 100]
grouped = filtered.groupby('category').agg({'amount': ['sum', 'mean']})
result = grouped.compute()  # Triggers execution

# Custom operations on partitions
def process_partition(df):
    df['new_col'] = df['a'] + df['b']
    return df

ddf = ddf.map_partitions(process_partition)
```

## Dask Array

```python
import dask.array as da
import numpy as np

# Create from scratch
x = da.random.random((100000, 100000), chunks=(10000, 10000))

# From NumPy array
arr = np.random.random((10000, 10000))
x = da.from_array(arr, chunks=(1000, 1000))

# From files
x = da.from_zarr('large_dataset.zarr')

# Operations
y = x + 100
z = y.mean(axis=0)
result = z.compute()

# Custom operations
def custom_func(block):
    return block ** 2

result = da.map_blocks(custom_func, x)
```

## Dask Bag (Unstructured Data)

```python
import dask.bag as db
import json

# Read and parse JSON/text files
bag = db.read_text('logs/*.json').map(json.loads)

# Functional operations
valid = bag.filter(lambda x: x['status'] == 'valid')
processed = valid.map(lambda x: {'id': x['id'], 'value': x['value']})

# Convert to DataFrame for analysis
ddf = processed.to_dataframe()
result = ddf.groupby('category').mean().compute()
```

## Schedulers

```python
import dask

# Threads (default) - good for NumPy/Pandas
result = computation.compute()  # Uses threads

# Processes - good for Python-heavy work
result = computation.compute(scheduler='processes')

# Synchronous - for debugging
dask.config.set(scheduler='synchronous')
result = computation.compute()  # Can use pdb

# Distributed - for monitoring and scaling
from dask.distributed import Client
client = Client()  # Local cluster
print(client.dashboard_link)  # Monitor at this URL
result = computation.compute()
```

## Distributed Computing

```python
from dask.distributed import Client

# Local cluster
client = Client()

# Remote cluster
client = Client('scheduler-address:8786')

# Submit tasks
futures = client.map(process_func, data_list)
results = client.gather(futures)

# Scatter large data (send once)
big_data = client.scatter(large_dataset)
futures = client.map(process, [big_data] * 10, params)

client.close()
```

## Best Practices

### Don't Load Data Locally First

```python
# Wrong - loads all data in memory
import pandas as pd
df = pd.read_csv('large.csv')
ddf = dd.from_pandas(df, npartitions=10)

# Correct - let Dask handle loading
import dask.dataframe as dd
ddf = dd.read_csv('large.csv')
```

### Avoid Repeated compute()

```python
# Wrong - separate computations
for item in items:
    result = dask_computation(item).compute()

# Correct - single compute for all
computations = [dask_computation(item) for item in items]
results = dask.compute(*computations)
```

### Choose Appropriate Chunk Sizes

- Target ~100 MB per chunk
- Too large: Memory overflow
- Too small: Scheduling overhead

```python
# Check task graph size
print(len(ddf.__dask_graph__()))  # Should be < 100k tasks
```

## Common Patterns

### ETL Pipeline

```python
ddf = dd.read_csv('raw_data/*.csv')
ddf = ddf[ddf['status'] == 'valid']
ddf['amount'] = ddf['amount'].astype('float64')
ddf = ddf.dropna(subset=['important_col'])
summary = ddf.groupby('category').agg({'amount': ['sum', 'mean']})
summary.to_parquet('output/summary.parquet')
```

### Large-Scale Array Computation

```python
import dask.array as da

x = da.from_zarr('large_dataset.zarr')
normalized = (x - x.mean()) / x.std()
da.to_zarr(normalized, 'normalized.zarr')
```

## Debugging

```python
# Use synchronous scheduler
dask.config.set(scheduler='synchronous')
result = computation.compute()  # Now you can use pdb

# Test on sample first
sample = ddf.head(1000)  # Small sample
# Test logic, then scale
```

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Dask** | Scale pandas/NumPy, larger-than-RAM, clusters |
| Polars | Fast in-memory DataFrames |
| Vaex | Out-of-core analytics on single machine |
| Spark | Enterprise big data, SQL-heavy workflows |

## Resources

- Docs: <https://docs.dask.org/>
- Best Practices: <https://docs.dask.org/en/stable/best-practices.html>
- Examples: <https://examples.dask.org/>
