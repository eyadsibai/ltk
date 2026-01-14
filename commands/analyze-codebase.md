---
name: analyze-codebase
description: Generate comprehensive codebase analysis and documentation
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Task
---

# Analyze Codebase

Generate a comprehensive analysis of the current codebase structure, patterns, and documentation.

## Process

### Step 1: Project Discovery

```bash
# Identify project type
ls -la
cat package.json 2>/dev/null || cat pyproject.toml 2>/dev/null || cat Cargo.toml 2>/dev/null || cat go.mod 2>/dev/null

# Get directory structure
tree -L 3 -I 'node_modules|venv|__pycache__|.git|dist|build' 2>/dev/null || find . -type d -maxdepth 3 | grep -v node_modules | grep -v .git
```

### Step 2: Identify Key Components

For each area, document:

| Area | What to Find |
|------|--------------|
| **Entry Points** | Main files, CLI commands |
| **API/Routes** | Endpoint definitions |
| **Models** | Data structures, schemas |
| **Services** | Business logic |
| **Config** | Environment, settings |
| **Tests** | Test organization |

### Step 3: Analyze Dependencies

```bash
# JavaScript/TypeScript
cat package.json | jq '.dependencies, .devDependencies'

# Python
cat requirements.txt 2>/dev/null || cat pyproject.toml 2>/dev/null

# Go
cat go.mod
```

### Step 4: Detect Patterns

Look for:

- Architecture style (MVC, Clean, Hexagonal)
- State management approach
- API design patterns (REST, GraphQL)
- Testing framework and strategy
- Deployment configuration

### Step 5: Generate Report

Create `codebase_analysis.md` with:

```markdown
# Codebase Analysis: [Project Name]

## Overview
- **Type**: [Web app, CLI, Library, etc.]
- **Language**: [Primary language]
- **Framework**: [Main framework]

## Project Structure
[Directory tree with explanations]

## Key Components

### Entry Points
- `src/main.ts` - Application bootstrap

### API Routes
[List of endpoints]

### Data Models
[Key models and relationships]

### Services
[Business logic modules]

## Dependencies
### Production
[Key dependencies and their purpose]

### Development
[Build tools, testing frameworks]

## Patterns & Conventions
- [Pattern 1]: [Where/how used]
- [Pattern 2]: [Where/how used]

## Configuration
- Environment variables required
- Configuration files

## Development Setup
```bash
# Commands to get started
```

## Architecture Notes

[Observations about architecture decisions]

## Recommendations

- [Suggested improvements]

```

## Output

After analysis, save the report to `codebase_analysis.md` in the project root.
