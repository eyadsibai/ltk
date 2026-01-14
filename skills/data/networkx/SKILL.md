---
name: networkx
description: Use when "NetworkX", "graph analysis", "network analysis", "graph algorithms", or asking about "shortest path", "centrality", "PageRank", "community detection", "social network", "knowledge graph", "graph visualization"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/networkx -->

# NetworkX Graph and Network Analysis

Python library for creating, analyzing, and visualizing complex networks and graphs.

## When to Use

- Creating and manipulating graph/network structures
- Computing graph algorithms (shortest paths, centrality, PageRank)
- Detecting communities in networks
- Analyzing social networks, citation networks, biological networks
- Visualizing network topologies
- Working with knowledge graphs

## Quick Start

```python
import networkx as nx
import matplotlib.pyplot as plt

# Create graph
G = nx.Graph()
G.add_edges_from([(1, 2), (1, 3), (2, 3), (3, 4)])

# Analyze
print(f"Nodes: {G.number_of_nodes()}")
print(f"Edges: {G.number_of_edges()}")
print(f"Density: {nx.density(G):.3f}")

# Visualize
nx.draw(G, with_labels=True)
plt.show()
```

## Graph Types

```python
# Undirected graph
G = nx.Graph()

# Directed graph
G = nx.DiGraph()

# Multi-edge graph
G = nx.MultiGraph()

# Directed multi-edge
G = nx.MultiDiGraph()
```

## Creating Graphs

```python
# Add nodes with attributes
G.add_node(1)
G.add_nodes_from([2, 3, 4])
G.add_node("A", type='protein', weight=1.5)

# Add edges with attributes
G.add_edge(1, 2)
G.add_edges_from([(1, 3), (2, 4)])
G.add_edge(1, 4, weight=0.8, relation='interacts')

# From pandas DataFrame
import pandas as pd
df = pd.DataFrame({
    'source': [1, 2, 3],
    'target': [2, 3, 4],
    'weight': [0.5, 1.0, 0.75]
})
G = nx.from_pandas_edgelist(df, 'source', 'target', edge_attr='weight')
```

## Graph Algorithms

### Shortest Paths

```python
# Single pair
path = nx.shortest_path(G, source=1, target=5)
length = nx.shortest_path_length(G, source=1, target=5)

# Weighted
path = nx.shortest_path(G, source=1, target=5, weight='weight')

# All pairs
all_paths = dict(nx.all_pairs_shortest_path(G))
```

### Centrality Measures

```python
# Degree centrality
degree_cent = nx.degree_centrality(G)

# Betweenness centrality
betweenness = nx.betweenness_centrality(G)

# Closeness centrality
closeness = nx.closeness_centrality(G)

# PageRank
pagerank = nx.pagerank(G)

# Eigenvector centrality
eigenvector = nx.eigenvector_centrality(G)
```

### Community Detection

```python
from networkx.algorithms import community

# Greedy modularity
communities = community.greedy_modularity_communities(G)

# Louvain method
communities = community.louvain_communities(G)

# Label propagation
communities = community.label_propagation_communities(G)
```

### Connectivity

```python
# Check connectivity
is_connected = nx.is_connected(G)

# Connected components
components = list(nx.connected_components(G))
largest = max(components, key=len)

# For directed graphs
is_strongly_connected = nx.is_strongly_connected(G)
scc = list(nx.strongly_connected_components(G))
```

### Clustering

```python
# Clustering coefficient
clustering = nx.clustering(G)
avg_clustering = nx.average_clustering(G)

# Triangles
triangles = nx.triangles(G)
```

## Graph Generators

```python
# Random graphs
G = nx.erdos_renyi_graph(n=100, p=0.1, seed=42)
G = nx.barabasi_albert_graph(n=100, m=3, seed=42)
G = nx.watts_strogatz_graph(n=100, k=6, p=0.1, seed=42)

# Classic graphs
G = nx.complete_graph(n=10)
G = nx.cycle_graph(n=20)
G = nx.grid_2d_graph(m=5, n=7)

# Known graphs
G = nx.karate_club_graph()
G = nx.petersen_graph()
```

## I/O Operations

```python
# Edge list
G = nx.read_edgelist('graph.txt')
nx.write_edgelist(G, 'graph.txt')

# GraphML (preserves attributes)
G = nx.read_graphml('graph.graphml')
nx.write_graphml(G, 'graph.graphml')

# JSON
data = nx.node_link_data(G)
G = nx.node_link_graph(data)

# Pandas
df = nx.to_pandas_edgelist(G)
G = nx.from_pandas_edgelist(df, 'source', 'target')

# NumPy/SciPy
A = nx.to_numpy_array(G)
G = nx.from_numpy_array(A)
```

## Visualization

```python
import matplotlib.pyplot as plt

# Basic plot
nx.draw(G, with_labels=True)

# With layout
pos = nx.spring_layout(G, seed=42)
nx.draw(G, pos=pos, with_labels=True, node_color='lightblue', node_size=500)

# Color by centrality
centrality = nx.betweenness_centrality(G)
node_colors = [centrality[n] for n in G.nodes()]
nx.draw(G, pos, node_color=node_colors, cmap=plt.cm.viridis)

# Layout options
pos = nx.spring_layout(G)      # Force-directed
pos = nx.circular_layout(G)    # Circular
pos = nx.kamada_kawai_layout(G)  # Kamada-Kawai
pos = nx.spectral_layout(G)    # Spectral

plt.savefig('network.png', dpi=300, bbox_inches='tight')
```

## Common Workflow

```python
import networkx as nx
import pandas as pd

# 1. Load data
G = nx.read_edgelist('network.txt')

# 2. Examine structure
print(f"Nodes: {G.number_of_nodes()}")
print(f"Edges: {G.number_of_edges()}")
print(f"Connected: {nx.is_connected(G)}")

# 3. Analyze
centrality = nx.betweenness_centrality(G)
communities = list(nx.community.greedy_modularity_communities(G))

# 4. Export results
results = pd.DataFrame({
    'node': list(centrality.keys()),
    'betweenness': list(centrality.values())
})
results.to_csv('centrality.csv', index=False)
```

## Best Practices

1. **Set random seeds** for reproducibility in layouts and random graphs
2. **Use appropriate graph type** (directed vs undirected, multi-edge)
3. **Consider memory** for large networks - use sparse representations
4. **Use approximate algorithms** for very large networks (k parameter)
5. **Leverage pandas integration** for data import/export

## Resources

- Docs: <https://networkx.org/documentation/latest/>
- Tutorial: <https://networkx.org/documentation/latest/tutorial.html>
- Gallery: <https://networkx.org/documentation/latest/auto_examples/>
