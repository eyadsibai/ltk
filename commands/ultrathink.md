---
name: ultrathink
description: Launch coordinated multi-agent analysis for complex tasks using Architect, Research, Coder, and Tester specialists
argument-hint: "[complex task or problem to solve]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Task
  - TodoWrite
  - WebSearch
  - WebFetch
  - AskUserQuestion
---

# Ultrathink: Multi-Agent Coordination

Orchestrate four specialist sub-agents to analyze, design, implement, and validate complex coding tasks.

## Task Description

<task_description> #$ARGUMENTS </task_description>

**If the task description is empty, ask:** "What complex task would you like me to analyze? Describe the problem, feature, or challenge."

## Process

### Phase 1: Architect Agent

Spawn the Architect agent to design the high-level approach:

```markdown
Architect Agent Task:
- Analyze the problem space and constraints
- Identify system components affected
- Design the solution architecture
- Consider scalability, security, maintainability
- Output: Architecture diagram (text), key decisions, component list
```

### Phase 2: Research Agent

Spawn the Research agent to gather knowledge:

```markdown
Research Agent Task:
- Search for existing patterns in codebase
- Research external best practices
- Find similar implementations for reference
- Identify potential pitfalls from documentation
- Output: Research findings, reference implementations, gotchas
```

### Phase 3: Coder Agent

Spawn the Coder agent to plan implementation:

```markdown
Coder Agent Task:
- Translate architecture into concrete code changes
- List files to create/modify with specific changes
- Identify dependencies and order of implementation
- Consider edge cases and error handling
- Output: Implementation plan with file paths and code snippets
```

### Phase 4: Tester Agent

Spawn the Tester agent to plan validation:

```markdown
Tester Agent Task:
- Design test strategy (unit, integration, e2e)
- Identify critical test cases
- Plan for edge cases and failure scenarios
- Define acceptance criteria
- Output: Test plan with specific test cases
```

## Execution Strategy

Run agents in parallel where possible:

```
Phase 1: Architect (foundational - run first)
    |
    v
Phase 2: Research + Coder (can run in parallel after architecture)
    |
    v
Phase 3: Tester (needs architecture + implementation plan)
    |
    v
Synthesis: Combine all outputs into cohesive plan
```

## Output Format

```markdown
# Ultrathink Analysis: [Task Name]

## 1. Architecture Overview
[Architect agent output - diagrams, components, decisions]

## 2. Research Findings
[Research agent output - patterns, references, gotchas]

## 3. Implementation Plan
[Coder agent output - files, changes, order]

| # | File | Action | Description |
|---|------|--------|-------------|
| 1 | path/file.ts | Create | New service for X |
| 2 | path/other.ts | Modify | Add Y integration |

## 4. Test Strategy
[Tester agent output - test cases, coverage goals]

| Test Type | Count | Coverage |
|-----------|-------|----------|
| Unit | 15 | Core logic |
| Integration | 5 | API boundaries |
| E2E | 2 | Critical paths |

## 5. Risk Assessment
- [Risk 1]: [Mitigation]
- [Risk 2]: [Mitigation]

## 6. Next Actions
- [ ] [First actionable step]
- [ ] [Second step]
- [ ] [Third step]

## 7. Open Questions
- [Question needing human input]
```

## When to Use Ultrathink

Use for complex tasks requiring multiple perspectives:

- Major feature implementations
- Architectural refactors
- Performance optimization initiatives
- Security hardening projects
- Cross-cutting concerns (logging, monitoring)

For simple tasks, use regular implementation flow instead.

## Iteration

If gaps remain after initial analysis:

1. Identify which agent's output needs refinement
2. Re-spawn that specific agent with clarifying context
3. Update the synthesis with new findings
4. Repeat until confident in the plan
