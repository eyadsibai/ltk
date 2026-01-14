---
name: Architecture Review
description: This skill should be used when the user asks to "review architecture", "analyze project structure", "check dependencies", "find circular imports", "analyze code patterns", "understand codebase structure", "map dependencies", "evaluate design patterns", or mentions architectural analysis.
version: 1.0.0
---

# Architecture Review

Comprehensive architecture analysis skill for understanding project structure, dependencies, and design patterns.

## Core Capabilities

### Project Structure Analysis

Understand and evaluate codebase organization:

**Directory Structure Patterns:**
- Flat structure (small projects)
- Feature-based organization
- Layer-based organization (MVC, Clean Architecture)
- Domain-driven design structure

**Key files to identify:**
- Entry points (main.py, index.js, cmd/)
- Configuration files
- Test directories
- Build/deploy configurations
- Documentation

**Structure assessment:**
```
project/
├── src/          # Source code
├── tests/        # Test files
├── docs/         # Documentation
├── scripts/      # Utility scripts
├── config/       # Configuration
└── README.md     # Project overview
```

### Dependency Analysis

Map and evaluate dependencies:

**Internal Dependencies:**
- Module import graphs
- Circular dependency detection
- Coupling analysis
- Cohesion measurement

**External Dependencies:**
- Third-party package analysis
- Version constraints
- Transitive dependencies
- License compatibility

**Dependency visualization:**
```bash
# Python - using pydeps
pydeps --cluster src/

# Python - using pipdeptree
pipdeptree --warn silence

# JavaScript
npm ls --all
```

### Circular Import Detection

Identify and resolve circular dependencies:

**Detection approach:**
1. Build import graph from source files
2. Perform cycle detection (DFS)
3. Report circular chains
4. Suggest resolution strategies

**Resolution strategies:**
- Extract shared code to new module
- Use dependency injection
- Lazy imports (import inside function)
- Interface segregation

### Design Pattern Recognition

Identify common patterns in code:

**Creational Patterns:**
- Factory (object creation abstraction)
- Singleton (single instance)
- Builder (step-by-step construction)
- Dependency Injection

**Structural Patterns:**
- Adapter (interface conversion)
- Decorator (dynamic behavior)
- Facade (simplified interface)
- Repository (data access abstraction)

**Behavioral Patterns:**
- Strategy (algorithm selection)
- Observer (event handling)
- Command (action encapsulation)
- State (state machine)

## Architecture Evaluation

### Layer Analysis

For layered architectures, verify:

**Presentation Layer:**
- Controllers/Views
- Input validation
- Response formatting

**Business Layer:**
- Domain logic
- Business rules
- Service orchestration

**Data Layer:**
- Repositories
- Data access
- External integrations

**Cross-cutting concerns:**
- Logging
- Authentication
- Error handling
- Caching

### Coupling & Cohesion

**Coupling (lower is better):**
- Afferent coupling (Ca): Who depends on this module
- Efferent coupling (Ce): What this module depends on
- Instability: Ce / (Ca + Ce)

**Cohesion (higher is better):**
- Single responsibility adherence
- Related functionality grouping
- Clear module boundaries

### SOLID Principles Check

Evaluate adherence to:

**S - Single Responsibility:**
- Each class has one reason to change
- Clear, focused modules

**O - Open/Closed:**
- Open for extension
- Closed for modification

**L - Liskov Substitution:**
- Subtypes substitutable for base types
- Proper inheritance hierarchies

**I - Interface Segregation:**
- Specific interfaces over general ones
- No forced implementation of unused methods

**D - Dependency Inversion:**
- Depend on abstractions
- High-level modules independent of low-level

## Analysis Workflow

### Full Architecture Review

1. **Map structure**: Understand directory layout
2. **Identify entry points**: Find main execution paths
3. **Build dependency graph**: Map internal/external deps
4. **Detect issues**: Circular deps, high coupling
5. **Recognize patterns**: Identify design patterns used
6. **Evaluate quality**: Check SOLID, coupling/cohesion
7. **Report findings**: Summarize with recommendations

### Quick Architecture Check

For rapid assessment:

1. Review key configuration files
2. Check import structure of main modules
3. Identify obvious architectural issues
4. Note areas needing deeper review

## Output Format

### Structure Report

```
Project: my-project
Type: Web Application (FastAPI)
Architecture: Layered (API/Service/Repository)

Directory Structure:
├── api/          [Presentation Layer]
├── services/     [Business Layer]
├── repositories/ [Data Layer]
├── models/       [Domain Models]
└── utils/        [Shared Utilities]

Entry Points:
- main.py (FastAPI application)
- cli.py (Command line interface)
```

### Dependency Report

```
Module Dependencies:
┌─────────────┬────────────┬────────────┐
│ Module      │ Imports    │ Imported By│
├─────────────┼────────────┼────────────┤
│ api.users   │ 5          │ 2          │
│ services.   │ 8          │ 4          │
│ repos.db    │ 3          │ 6          │
└─────────────┴────────────┴────────────┘

Circular Dependencies Found: 2
1. services.auth → services.user → services.auth
2. models.order → models.product → models.order
```

### Quality Assessment

| Aspect | Score | Notes |
|--------|-------|-------|
| Structure | 8/10 | Clear layer separation |
| Coupling | 6/10 | Some tight coupling in services |
| Cohesion | 7/10 | Good module focus |
| SOLID | 7/10 | DI could be improved |

## Common Architectural Issues

### High Priority

1. **Circular dependencies**: Break cycles immediately
2. **God classes**: Split into focused components
3. **Missing abstraction layers**: Add interfaces

### Medium Priority

1. **High coupling**: Introduce dependency injection
2. **Inconsistent patterns**: Standardize approaches
3. **Mixed responsibilities**: Refactor to single responsibility

### Low Priority

1. **Naming inconsistencies**: Standardize naming
2. **Missing documentation**: Add architecture docs
3. **Test organization**: Align with source structure

## Recommendations Template

For each finding, provide:

```
Issue: [Description]
Location: [Files/modules affected]
Impact: [Why this matters]
Recommendation: [How to fix]
Effort: [Low/Medium/High]
Priority: [High/Medium/Low]
```

## Integration

Coordinate with other skills:
- **refactoring skill**: For implementing architectural changes
- **documentation skill**: For architecture documentation
- **code-quality skill**: For detailed code analysis
