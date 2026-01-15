---
name: Code Quality
description: This skill should be used when the user asks to "check code quality", "analyze code metrics", "find dead code", "check style compliance", "measure complexity", "find unused imports", "check type hints", "run linting", "PEP8 compliance", or mentions code quality analysis.
version: 1.0.0
---

# Code Quality Analysis

Comprehensive code quality analysis skill covering style, complexity, dead code detection, and type checking.

## Core Capabilities

### Style Compliance

Check adherence to language-specific style guides:

**Python (PEP8/Black):**

- Line length (88 chars for Black, 79 for PEP8)
- Indentation (4 spaces)
- Import ordering (standard, third-party, local)
- Naming conventions (snake_case for functions/variables, PascalCase for classes)
- Whitespace usage

**Style check commands:**

```bash
# Black formatting check
black --check --diff .

# Flake8 linting
flake8 --max-line-length=88 .

# isort import sorting
isort --check-only --diff .
```

### Complexity Metrics

Measure and report code complexity:

**Cyclomatic Complexity:**

- Number of independent paths through code
- Target: < 10 per function
- Warning: 10-20
- Critical: > 20

**Cognitive Complexity:**

- Mental effort to understand code
- Accounts for nesting depth and control flow

**Function Length:**

- Target: < 50 lines
- Warning: 50-100 lines
- Critical: > 100 lines

**Nesting Depth:**

- Target: < 4 levels
- Warning: 4-6 levels
- Critical: > 6 levels

**Complexity analysis:**

```bash
# Using radon for Python
radon cc . -a -s  # Cyclomatic complexity
radon mi .        # Maintainability index
radon hal .       # Halstead metrics
```

### Dead Code Detection

Identify unused code elements:

**Unused Imports:**

```bash
# Python - using autoflake
autoflake --check --remove-all-unused-imports .

# Using flake8 with F401
flake8 --select=F401 .
```

**Unused Variables:**

- Local variables assigned but never read
- Function parameters ignored
- Class attributes never accessed

**Unused Functions/Classes:**

- Defined but never called
- Private methods not used internally
- Dead code branches (always false conditions)

**Unreachable Code:**

- Code after return/raise/break/continue
- Branches with impossible conditions
- Deprecated code still in codebase

### Type Hint Analysis

Validate type annotations:

**Missing Type Hints:**

```bash
# Using mypy
mypy --strict .

# Check specific strictness levels
mypy --disallow-untyped-defs .
mypy --disallow-incomplete-defs .
```

**Type Errors:**

- Incompatible types in assignments
- Wrong argument types
- Missing return types
- Generic type issues

**Type Coverage:**

- Percentage of code with type annotations
- Target: > 80% coverage

## Quality Metrics Dashboard

When analyzing a codebase, report:

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Style Compliance | X% | > 95% | Pass/Fail |
| Avg Cyclomatic Complexity | X | < 10 | Pass/Fail |
| Max Function Length | X lines | < 50 | Pass/Fail |
| Dead Code | X items | 0 | Pass/Fail |
| Type Coverage | X% | > 80% | Pass/Fail |

## Analysis Workflow

### Full Quality Analysis

To perform comprehensive quality check:

1. **Style check**: Run linters and formatters
2. **Complexity analysis**: Calculate metrics
3. **Dead code scan**: Find unused elements
4. **Type check**: Validate annotations
5. **Report generation**: Summarize findings

### Quick Quality Check

For rapid assessment of changes:

1. Get changed files from git diff
2. Run focused linting on changed files
3. Check complexity of modified functions
4. Validate types in touched code

## Language-Specific Guidance

### Python

**Recommended tooling:**

- Black (formatting)
- isort (import sorting)
- flake8 (linting)
- mypy (type checking)
- radon (complexity)
- vulture (dead code)

**Configuration (pyproject.toml):**

```toml
[tool.black]
line-length = 88
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.11"
strict = true
```

### JavaScript/TypeScript

**Recommended tooling:**

- ESLint (linting)
- Prettier (formatting)
- TypeScript compiler (type checking)

**Configuration (.eslintrc.json):**

```json
{
  "extends": ["eslint:recommended"],
  "rules": {
    "complexity": ["warn", 10],
    "max-depth": ["warn", 4],
    "max-lines-per-function": ["warn", 50]
  }
}
```

## Common Quality Issues

### High Priority Fixes

1. **Unused imports**: Remove immediately
2. **Type errors**: Fix type mismatches
3. **High complexity**: Refactor into smaller functions
4. **Long functions**: Extract logical blocks

### Medium Priority

1. **Style violations**: Apply formatter
2. **Missing type hints**: Add annotations
3. **Moderate complexity**: Consider refactoring
4. **Unused variables**: Remove or use

### Low Priority

1. **Minor style preferences**: Team decision
2. **Optional type hints**: Add gradually
3. **Documentation gaps**: Address incrementally

## Output Format

Present findings organized by severity:

**Errors** (must fix):

- Type errors
- Syntax issues
- Critical complexity

**Warnings** (should fix):

- Unused code
- High complexity
- Missing types in public APIs

**Info** (consider):

- Style suggestions
- Optimization opportunities
- Best practice recommendations

## Integration

Coordinate with other skills:

- **refactoring skill**: For complexity reduction
- **documentation skill**: For missing docstrings
- **security-scanning skill**: For security-related quality issues
