---
name: polars
description: Use when "Polars", "fast dataframe", "lazy evaluation", "Arrow backend", or asking about "pandas alternative", "parallel dataframe", "large CSV processing", "ETL pipeline", "expression API"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/polars -->

# Polars Fast DataFrame Library

Lightning-fast DataFrame library with lazy evaluation and parallel execution.

## When to Use

- Pandas is too slow for your dataset
- Working with 1-100GB datasets that fit in RAM
- Need lazy evaluation for query optimization
- Building ETL pipelines
- Want parallel execution without extra config

## Quick Start

```bash
pip install polars
```

### Basic Usage

```python
import polars as pl

# Create DataFrame
df = pl.DataFrame({
    "name": ["Alice", "Bob", "Charlie"],
    "age": [25, 30, 35],
    "city": ["NY", "LA", "SF"]
})

# Select columns
df.select("name", "age")

# Filter rows
df.filter(pl.col("age") > 25)

# Add computed columns
df.with_columns(
    age_plus_10=pl.col("age") + 10
)
```

## Lazy vs Eager Evaluation

### Eager (Immediate)

```python
df = pl.read_csv("file.csv")  # Reads immediately
result = df.filter(pl.col("age") > 25)  # Executes immediately
```

### Lazy (Optimized)

```python
lf = pl.scan_csv("file.csv")  # Doesn't read yet
result = lf.filter(pl.col("age") > 25).select("name", "age")
df = result.collect()  # Now executes optimized query
```

**Use lazy for:**

- Large datasets
- Complex query pipelines
- When only some columns/rows needed
- Performance-critical work

## Common Operations

### GroupBy Aggregation

```python
df.group_by("city").agg(
    pl.col("age").mean().alias("avg_age"),
    pl.col("name").count().alias("count")
)
```

### Joins

```python
df1.join(df2, on="id", how="left")
```

### Window Functions

```python
df.with_columns(
    pl.col("value").rolling_mean(window_size=3).alias("rolling_avg")
)
```

### Read/Write

```python
# CSV
df = pl.read_csv("data.csv")
df.write_csv("output.csv")

# Parquet (faster)
df = pl.read_parquet("data.parquet")
df.write_parquet("output.parquet")

# Lazy scanning
lf = pl.scan_csv("large_file.csv")
lf = pl.scan_parquet("large_file.parquet")
```

## Pandas Migration

```python
# Pandas to Polars
pl_df = pl.from_pandas(pandas_df)

# Polars to Pandas
pandas_df = pl_df.to_pandas()
```

### Common Equivalents

| Pandas | Polars |
|--------|--------|
| `df['col']` | `df.select('col')` |
| `df[df['col'] > 5]` | `df.filter(pl.col('col') > 5)` |
| `df['new'] = df['col'] * 2` | `df.with_columns((pl.col('col') * 2).alias('new'))` |
| `df.groupby('col').mean()` | `df.group_by('col').agg(pl.all().mean())` |

## Performance Tips

1. **Use lazy mode** for large datasets
2. **Use Parquet** instead of CSV
3. **Select columns early** (projection pushdown)
4. **Filter early** (predicate pushdown)
5. **Avoid Python UDFs** when possible

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Polars** | 1-100GB in RAM, speed critical |
| Pandas | Small data, ecosystem compatibility |
| Dask | Larger than RAM, distributed |
| Spark | Cluster computing, very large scale |

## Resources

- Docs: <https://pola.rs/>
- GitHub: <https://github.com/pola-rs/polars>
- User Guide: <https://docs.pola.rs/user-guide/>
