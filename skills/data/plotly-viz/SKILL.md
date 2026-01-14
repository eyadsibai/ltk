---
name: plotly-viz
description: Use when "Plotly", "interactive plots", "dashboard charts", "hover info", or asking about "interactive visualization", "zoom pan", "web charts", "Plotly Express", "3D plots"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/plotly -->

# Plotly Interactive Visualization

Interactive, publication-quality visualizations with 40+ chart types.

## When to Use

- Need hover info, zoom, pan interactions
- Building dashboards
- Exploratory data analysis
- Web-embeddable charts
- 3D visualizations

## Quick Start

```bash
pip install plotly
```

### Plotly Express (High-Level API)

```python
import plotly.express as px
import pandas as pd

df = pd.DataFrame({
    'x': [1, 2, 3, 4],
    'y': [10, 11, 12, 13],
    'category': ['A', 'B', 'A', 'B']
})

fig = px.scatter(df, x='x', y='y', color='category', title='My Plot')
fig.show()
```

## Common Chart Types

### Scatter Plot

```python
fig = px.scatter(df, x='x', y='y', color='category', size='value',
                 hover_data=['name'], title='Scatter Plot')
```

### Line Plot

```python
fig = px.line(df, x='date', y='value', color='series', title='Line Plot')
```

### Bar Chart

```python
fig = px.bar(df, x='category', y='value', color='group', barmode='group')
```

### Histogram

```python
fig = px.histogram(df, x='value', nbins=30, color='category')
```

### Box Plot

```python
fig = px.box(df, x='category', y='value', color='group')
```

### Heatmap

```python
fig = px.imshow(matrix, labels=dict(x='X', y='Y', color='Value'))
```

### 3D Scatter

```python
fig = px.scatter_3d(df, x='x', y='y', z='z', color='category')
```

## Customization

### Layout

```python
fig.update_layout(
    title='My Title',
    xaxis_title='X Axis',
    yaxis_title='Y Axis',
    template='plotly_white',  # or plotly_dark, ggplot2, seaborn
    width=800,
    height=600
)
```

### Traces

```python
fig.update_traces(
    marker=dict(size=12, line=dict(width=2, color='black')),
    selector=dict(mode='markers')
)
```

### Axes

```python
fig.update_xaxes(range=[0, 10], title_font_size=14)
fig.update_yaxes(type='log')  # Log scale
```

## Subplots

```python
from plotly.subplots import make_subplots
import plotly.graph_objects as go

fig = make_subplots(rows=2, cols=2, subplot_titles=('A', 'B', 'C', 'D'))

fig.add_trace(go.Scatter(x=[1, 2], y=[3, 4]), row=1, col=1)
fig.add_trace(go.Bar(x=['a', 'b'], y=[1, 2]), row=1, col=2)
```

## Graph Objects (Low-Level API)

```python
import plotly.graph_objects as go

fig = go.Figure()

fig.add_trace(go.Scatter(
    x=[1, 2, 3],
    y=[4, 5, 6],
    mode='lines+markers',
    name='Series 1'
))

fig.add_trace(go.Bar(
    x=['A', 'B', 'C'],
    y=[1, 2, 3],
    name='Series 2'
))

fig.show()
```

## Saving Figures

```python
# Interactive HTML
fig.write_html('figure.html')

# Static images (requires kaleido)
fig.write_image('figure.png', scale=2)
fig.write_image('figure.pdf')
fig.write_image('figure.svg')
```

## Templates

```python
# Built-in templates
fig = px.scatter(df, x='x', y='y', template='plotly_dark')

# Available: plotly_white, plotly_dark, ggplot2, seaborn, simple_white
```

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Plotly** | Interactive, dashboards, web |
| Matplotlib | Static, publication, fine control |
| Seaborn | Statistical, quick exploration |

## Resources

- Docs: <https://plotly.com/python/>
- Express Reference: <https://plotly.com/python/plotly-express/>
- Gallery: <https://plotly.com/python/basic-charts/>
