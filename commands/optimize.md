---
name: optimize
description: Analyze and optimize code performance
argument-hint: "[file-or-directory]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
---

# Optimize Command

Analyze code for performance issues and apply optimizations.

## Execution Steps

### 1. Identify Target

If no argument provided:

- Check for performance-related issues in git log
- Look for TODO comments mentioning performance
- Focus on hot paths (frequently executed code)

### 2. Performance Analysis

Run profiling tools:

```bash
# Python
python -m cProfile -s cumtime script.py

# Node.js
node --prof app.js

# Go
go test -bench . -cpuprofile cpu.prof
```

### 3. Common Optimizations

#### Algorithm Complexity

- Replace O(n²) with O(n log n) where possible
- Use appropriate data structures (hash maps, sets)
- Avoid unnecessary iterations

#### Database Queries

- Identify N+1 query patterns
- Add missing indexes
- Use batch operations
- Implement pagination

#### Memory Usage

- Reduce object allocations in loops
- Use streaming for large data
- Implement object pooling
- Clear unused references

#### I/O Operations

- Batch file operations
- Use async/parallel processing
- Implement caching
- Compress large payloads

#### Caching

- Add memoization for pure functions
- Cache expensive computations
- Use appropriate cache invalidation

### 4. Apply Optimizations

Make targeted changes:

- One optimization per commit
- Include before/after metrics
- Preserve correctness

### 5. Verify Improvements

Benchmark before and after:

```bash
# Run benchmarks
make benchmark

# Compare results
hyperfine 'old-version' 'new-version'
```

## Output Format

```
Performance Optimization Report
===============================

Target: <file or directory>

Analysis
--------
Hot Spots Identified:
1. processData() - 45% of execution time
2. fetchRecords() - 30% of execution time
3. renderOutput() - 15% of execution time

Issues Found
------------
[HIGH] N+1 query in fetchRecords()
  - 100 queries instead of 1
  - Location: src/data.py:45

[MEDIUM] Unnecessary re-computation in processData()
  - Same calculation repeated in loop
  - Location: src/process.py:78

[LOW] String concatenation in loop
  - Could use StringBuilder/join
  - Location: src/output.py:23

Optimizations Applied
---------------------
1. [N+1 Query Fix]
   Before: 100 queries, 500ms
   After: 1 query, 15ms
   Improvement: 97% reduction

2. [Memoization]
   Before: 1000 calculations
   After: 10 calculations (cached)
   Improvement: 99% reduction

Overall Impact
--------------
Execution time: 2.5s → 0.3s (88% improvement)
Memory usage: 512MB → 128MB (75% reduction)
Database load: -97% query reduction

Next Steps
----------
- Add performance regression tests
- Set up continuous benchmarking
- Monitor production metrics
```

## Common Patterns

### N+1 Query Fix

```python
# Before
for user in users:
    orders = db.query(Order).filter_by(user_id=user.id).all()

# After
user_ids = [u.id for u in users]
orders = db.query(Order).filter(Order.user_id.in_(user_ids)).all()
orders_by_user = groupby(orders, key=lambda o: o.user_id)
```

### Memoization

```python
from functools import lru_cache

@lru_cache(maxsize=1000)
def expensive_computation(input):
    # ...
```

### Batch Processing

```python
# Before
for item in items:
    db.session.add(item)
    db.session.commit()

# After
db.session.add_all(items)
db.session.commit()
```
