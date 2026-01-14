---
name: review-architecture
description: Analyze project structure, dependencies, and architectural patterns
argument-hint: "[path]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# Architecture Review Command

Analyze project structure, dependency relationships, and architectural patterns to understand and evaluate the codebase architecture.

## Execution Steps

1. **Map project structure**:
   - List top-level directories
   - Identify key files (entry points, configs)
   - Determine project type (web app, library, CLI, etc.)

2. **Identify architecture pattern**:
   - Layered (MVC, Clean Architecture)
   - Feature-based organization
   - Domain-driven design
   - Monolith vs microservices indicators

3. **Analyze dependencies**:
   - Map internal module dependencies
   - Detect circular imports
   - Calculate coupling metrics
   - Review external dependencies

4. **Recognize design patterns**:
   - Factory, Singleton, Repository patterns
   - Dependency injection usage
   - Event/Observer patterns
   - Strategy patterns

5. **Evaluate SOLID principles**:
   - Single Responsibility adherence
   - Interface segregation
   - Dependency inversion

6. **Generate architecture report**: Present findings with visualizations.

## Output Format

```
Architecture Review
===================

Project Overview
----------------
Type: [Web Application / Library / CLI / etc.]
Pattern: [Layered / Feature-based / etc.]
Primary Language: [language]

Directory Structure
-------------------
[Tree view of key directories with annotations]

Entry Points
------------
- [file]: [description]

Layer Analysis
--------------
| Layer        | Directories    | Responsibilities      |
|--------------|----------------|-----------------------|
| Presentation | api/, views/   | HTTP handling, UI     |
| Business     | services/      | Business logic        |
| Data         | repositories/  | Data access           |

Dependency Analysis
-------------------
Circular Dependencies: [count]
[List any circular dependency chains]

High Coupling Modules:
[List modules with high coupling]

Design Patterns Found
---------------------
- [Pattern]: [Location and usage]

SOLID Evaluation
----------------
| Principle              | Score | Notes                |
|------------------------|-------|----------------------|
| Single Responsibility  | X/10  | [observations]       |
| Open/Closed            | X/10  | [observations]       |
| Liskov Substitution    | X/10  | [observations]       |
| Interface Segregation  | X/10  | [observations]       |
| Dependency Inversion   | X/10  | [observations]       |

Recommendations
---------------
[Prioritized architectural improvements]
```

## Tips

- Use the architecture-review skill for detailed patterns
- Focus on circular dependencies as highest priority
- Consider creating architecture diagrams with Mermaid
