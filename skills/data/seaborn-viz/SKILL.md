---
name: seaborn-viz
description: Use when "seaborn", "statistical plots", "distribution plots", or asking about "box plot", "violin plot", "pair plot", "heatmap correlation", "categorical plots", "facet grid"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/seaborn -->

# Seaborn Statistical Visualization

Statistical visualization with pandas integration and attractive defaults.

## When to Use

- Quick exploration of distributions and relationships
- Statistical visualizations (box, violin, pair plots)
- Categorical comparisons
- Correlation heatmaps
- Publication-ready plots with minimal code

## Quick Start

```python
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

# Load example dataset
df = sns.load_dataset('tips')

# Create visualization
sns.scatterplot(data=df, x='total_bill', y='tip', hue='day')
plt.show()
```

## Common Plot Types

### Distribution Plots

```python
# Histogram with KDE
sns.histplot(data=df, x='value', kde=True)

# KDE only
sns.kdeplot(data=df, x='value', hue='category')

# ECDF
sns.ecdfplot(data=df, x='value')
```

### Categorical Plots

```python
# Box plot
sns.boxplot(data=df, x='category', y='value', hue='group')

# Violin plot
sns.violinplot(data=df, x='category', y='value')

# Strip/swarm plot
sns.stripplot(data=df, x='category', y='value', jitter=True)
sns.swarmplot(data=df, x='category', y='value')

# Bar plot (with CI)
sns.barplot(data=df, x='category', y='value', errorbar='sd')
```

### Relational Plots

```python
# Scatter plot
sns.scatterplot(data=df, x='x', y='y', hue='category', size='value')

# Line plot
sns.lineplot(data=df, x='time', y='value', hue='group')
```

### Matrix Plots

```python
# Correlation heatmap
corr = df.corr()
sns.heatmap(corr, annot=True, cmap='coolwarm', center=0)

# Cluster map
sns.clustermap(data, cmap='viridis', standard_scale=1)
```

### Pair Plot

```python
# All pairwise relationships
sns.pairplot(df, hue='species', diag_kind='kde')
```

## Figure-Level vs Axes-Level

### Figure-Level (Creates Own Figure)

```python
# Automatic faceting support
g = sns.relplot(data=df, x='x', y='y', col='category', hue='group')
g = sns.catplot(data=df, x='cat', y='val', kind='box', col='group')
g = sns.displot(data=df, x='value', col='category', kde=True)
```

### Axes-Level (Plots to Existing Axes)

```python
fig, axes = plt.subplots(1, 2, figsize=(12, 5))
sns.boxplot(data=df, x='cat', y='val', ax=axes[0])
sns.histplot(data=df, x='val', ax=axes[1])
```

## Customization

### Themes

```python
sns.set_theme(style='whitegrid')  # darkgrid, white, dark, ticks
sns.set_context('paper')  # paper, notebook, talk, poster
```

### Color Palettes

```python
sns.set_palette('husl')  # deep, muted, bright, pastel, dark, colorblind
sns.color_palette('viridis', n_colors=5)
```

### Figure Aesthetics

```python
sns.set_theme(
    style='whitegrid',
    palette='deep',
    font_scale=1.2,
    rc={'figure.figsize': (10, 6)}
)
```

## FacetGrid

```python
# Create grid
g = sns.FacetGrid(df, col='category', row='group', hue='type')
g.map(sns.scatterplot, 'x', 'y')
g.add_legend()
```

## Best Practices

1. **Use figure-level functions** for faceting
2. **Use axes-level functions** for subplots
3. **Set theme once** at start of script
4. **Use hue** for categorical encoding
5. **Always label axes** for publication

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Seaborn** | Statistical plots, quick exploration |
| Matplotlib | Fine control, custom plots |
| Plotly | Interactive, dashboards |

## Resources

- Docs: <https://seaborn.pydata.org/>
- Tutorial: <https://seaborn.pydata.org/tutorial.html>
- Gallery: <https://seaborn.pydata.org/examples/>
