---
name: sympy
description: Use when "SymPy", "symbolic math", "symbolic computation", "algebraic solver", or asking about "solve equations", "derivatives symbolically", "integrals symbolically", "differential equations", "matrix algebra", "LaTeX output", "lambdify"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/sympy -->

# SymPy Symbolic Mathematics

Python library for symbolic mathematics - exact computation with mathematical symbols.

## When to Use

- Solving equations symbolically (algebraic, differential, systems)
- Calculus operations (derivatives, integrals, limits, series)
- Simplifying algebraic expressions
- Symbolic matrix operations and linear algebra
- Generating LaTeX or executable code from expressions
- Need exact results (e.g., `sqrt(2)` not `1.414...`)

## Quick Start

```python
from sympy import symbols, solve, diff, integrate, simplify
from sympy import sin, cos, exp, sqrt, pi, oo

# Define symbols
x, y, z = symbols('x y z')

# Solve equations
solutions = solve(x**2 - 5*x + 6, x)  # [2, 3]

# Derivatives
derivative = diff(sin(x**2), x)  # 2*x*cos(x**2)

# Integrals
integral = integrate(x**2, (x, 0, 1))  # 1/3
```

## Core Operations

### Solving Equations

```python
from sympy import solveset, linsolve, nonlinsolve, dsolve, Eq, Function

# Algebraic equations
solveset(x**2 - 4, x)  # {-2, 2}

# Systems of linear equations
linsolve([x + y - 2, x - y], x, y)  # {(1, 1)}

# Nonlinear systems
nonlinsolve([x**2 + y - 2, x + y**2 - 3], x, y)

# Differential equations
f = Function('f')
dsolve(f(x).diff(x) - f(x), f(x))  # f(x) = C1*exp(x)
```

### Calculus

```python
from sympy import diff, integrate, limit, series

# Derivatives
diff(x**3, x)        # 3*x**2
diff(x**4, x, 3)     # 24*x (third derivative)

# Integrals
integrate(exp(-x), (x, 0, oo))  # 1 (improper)

# Limits
limit(sin(x)/x, x, 0)  # 1

# Series expansion
series(exp(x), x, 0, 6)  # 1 + x + x**2/2 + ...
```

### Simplification

```python
from sympy import simplify, expand, factor, cancel, trigsimp

simplify(sin(x)**2 + cos(x)**2)  # 1
expand((x + 1)**3)               # x**3 + 3*x**2 + 3*x + 1
factor(x**2 - 1)                 # (x - 1)*(x + 1)
trigsimp(sin(x)*cos(y) + cos(x)*sin(y))  # sin(x + y)
```

### Matrices

```python
from sympy import Matrix, eye, zeros

M = Matrix([[1, 2], [3, 4]])
M_inv = M**-1           # Inverse
M.det()                 # Determinant
M.eigenvals()           # Eigenvalues
M.eigenvects()          # Eigenvectors
P, D = M.diagonalize()  # M = P*D*P^-1
```

## Symbol Assumptions

```python
# Constrain symbols for better simplification
x = symbols('x', positive=True, real=True)
n = symbols('n', integer=True)

# With positive assumption
sqrt(x**2)  # Returns x (not Abs(x))
```

## Numerical Evaluation

```python
from sympy import lambdify, N
import numpy as np

# Single value
result = sqrt(8) + pi
result.evalf()      # 5.96371554103586
result.evalf(50)    # 50 digits precision

# Convert to NumPy function (fast)
expr = x**2 + 2*x + 1
f = lambdify(x, expr, 'numpy')
x_vals = np.linspace(0, 10, 100)
y_vals = f(x_vals)  # Fast vectorized evaluation
```

## Code Generation

```python
from sympy import latex, pprint
from sympy.utilities.codegen import codegen

# LaTeX output
latex_str = latex(integrate(x**2, x))  # \frac{x^{3}}{3}

# Pretty print
pprint(integrate(x**2, x))

# Generate C code
[(c_name, c_code), (h_name, h_header)] = codegen(
    ('my_func', x**2 + 1), 'C'
)
```

## Best Practices

1. **Define symbols first**: Always use `symbols()` before expressions
2. **Use assumptions**: Add `positive=True`, `real=True`, `integer=True`
3. **Use exact arithmetic**: `Rational(1, 2)` not `0.5`
4. **Use lambdify for loops**: Convert to NumPy for repeated evaluation
5. **Choose appropriate solver**: `solveset` for algebraic, `dsolve` for ODEs

## vs Alternatives

| Tool | Best For |
|------|----------|
| **SymPy** | Symbolic math, exact results, algebraic manipulation |
| NumPy | Numerical computation, arrays |
| SciPy | Numerical optimization, integration |

## Resources

- Docs: <https://docs.sympy.org/>
- Tutorial: <https://docs.sympy.org/latest/tutorials/intro-tutorial/>
