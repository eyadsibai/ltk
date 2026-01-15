---
name: ltk:brainstorm
description: Structured brainstorming before creative or implementation work
argument-hint: "[topic or problem to brainstorm]"
---

# Brainstorm Command

Use before any creative work to explore intent, requirements, and design.

## When to Use

- Before implementing a new feature
- When requirements are unclear
- Before making architectural decisions
- When exploring multiple approaches

## Process

### 1. Understand Intent

Ask clarifying questions:

- What problem are we solving?
- Who is the user/audience?
- What does success look like?
- What constraints exist?

### 2. Explore Options

Generate multiple approaches:

- List at least 3 different ways to solve the problem
- Consider trade-offs of each
- Identify unknowns and risks

### 3. Gather Context

Research before deciding:

- Check existing patterns in codebase
- Look for similar solutions
- Identify dependencies

### 4. Propose Direction

Present recommendation:

- Preferred approach with reasoning
- Key decision points
- Next steps to validate

## Output Format

```markdown
## Brainstorm: [Topic]

### Understanding
- Problem: [description]
- User: [who benefits]
- Success: [what good looks like]

### Options Considered
1. **[Option A]** - [pros/cons]
2. **[Option B]** - [pros/cons]
3. **[Option C]** - [pros/cons]

### Recommendation
[Preferred approach and why]

### Next Steps
- [ ] [Action 1]
- [ ] [Action 2]
```

## Usage

```
/brainstorm How should we implement user notifications?
/brainstorm Best approach for caching API responses
/brainstorm Database schema for multi-tenant support
```
