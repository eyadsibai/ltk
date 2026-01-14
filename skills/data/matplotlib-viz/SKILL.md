---
name: matplotlib-viz
description: Use when "matplotlib", "pyplot", "plotting", "charts", "figures", or asking about "line plot", "scatter plot", "bar chart", "histogram", "subplots", "save figure", "publication plots"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/matplotlib -->

# Matplotlib Visualization

Python's foundational library for creating static, animated, and interactive plots.

## When to Use

- Creating any type of plot (line, scatter, bar, histogram, heatmap)
- Fine-grained control over every plot element
- Publication-quality figures
- Multi-panel figures with subplots
- Exporting to PNG, PDF, SVG

## Quick Start

```python
import matplotlib.pyplot as plt
import numpy as np

# Create figure and axes (recommended OO interface)
fig, ax = plt.subplots(figsize=(10, 6))

# Plot data
x = np.linspace(0, 2*np.pi, 100)
ax.plot(x, np.sin(x), label='sin(x)')
ax.plot(x, np.cos(x), label='cos(x)')

# Customize
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_title('Trigonometric Functions')
ax.legend()
ax.grid(True, alpha=0.3)

# Save and display
plt.savefig('plot.png', dpi=300, bbox_inches='tight')
plt.show()
```

## Common Plot Types

### Line Plot

```python
ax.plot(x, y, color='blue', linestyle='-', linewidth=2, marker='o')
```

### Scatter Plot

```python
ax.scatter(x, y, c=colors, s=sizes, alpha=0.7, cmap='viridis')
```

### Bar Chart

```python
ax.bar(categories, values, color='steelblue', edgecolor='black')
ax.barh(categories, values)  # Horizontal
```

### Histogram

```python
ax.hist(data, bins=30, edgecolor='black', alpha=0.7)
```

### Heatmap

```python
im = ax.imshow(data, cmap='viridis')
plt.colorbar(im)
```

## Multiple Subplots

```python
# Regular grid
fig, axes = plt.subplots(2, 2, figsize=(12, 10))
axes[0, 0].plot(x, y1)
axes[0, 1].scatter(x, y2)
axes[1, 0].bar(categories, values)
axes[1, 1].hist(data)

# Shared axes
fig, axes = plt.subplots(2, 1, sharex=True, figsize=(10, 8))
```

## Customization

### Colors and Styles

```python
# Named colors
ax.plot(x, y, color='steelblue')

# Hex colors
ax.plot(x, y, color='#1f77b4')

# Line styles
ax.plot(x, y, linestyle='--')  # dashed
ax.plot(x, y, linestyle=':')   # dotted

# Markers
ax.plot(x, y, marker='o', markersize=8)
```

### Axis and Labels

```python
ax.set_xlim(0, 10)
ax.set_ylim(-1, 1)
ax.set_xlabel('X Label', fontsize=12)
ax.set_ylabel('Y Label', fontsize=12)
ax.set_title('Title', fontsize=14, fontweight='bold')
ax.tick_params(axis='both', labelsize=10)
```

### Legend

```python
ax.legend(loc='upper right', frameon=True, fontsize=10)
ax.legend(loc='best')  # Auto-position
```

## Saving Figures

```python
# PNG (raster, good for web)
plt.savefig('figure.png', dpi=300, bbox_inches='tight')

# PDF (vector, good for publication)
plt.savefig('figure.pdf', bbox_inches='tight')

# SVG (vector, good for editing)
plt.savefig('figure.svg', bbox_inches='tight')

# Transparent background
plt.savefig('figure.png', transparent=True)
```

## Style Sheets

```python
# Use built-in styles
plt.style.use('seaborn-v0_8')
plt.style.use('ggplot')
plt.style.use('dark_background')

# List available styles
print(plt.style.available)
```

## Best Practices

1. **Use OO interface** (`fig, ax = plt.subplots()`) for better control
2. **Set figsize** appropriate for final use
3. **Use bbox_inches='tight'** when saving
4. **Label everything** (axes, title, legend)
5. **Use consistent colors** across related plots

## Resources

- Docs: <https://matplotlib.org/>
- Gallery: <https://matplotlib.org/stable/gallery/>
- Cheatsheets: <https://matplotlib.org/cheatsheets/>
