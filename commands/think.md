---
name: think
description: Orchestrate multi-perspective analysis for complex problems
argument-hint: "[problem or question to analyze]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Task
  - WebSearch
  - TodoWrite
---

# Think

Orchestrate deep analysis of complex problems from multiple expert perspectives.

## Problem

**Input:** `#$ARGUMENTS`

**If empty, ask:** "What problem or question would you like me to think deeply about?"

## Process

### Step 1: Problem Decomposition

Break down the problem into components:

```markdown
## Problem Analysis

### Core Question
[What are we really trying to solve?]

### Constraints
- [Constraint 1]
- [Constraint 2]

### Success Criteria
- [What does success look like?]

### Scope
- In scope: [...]
- Out of scope: [...]
```

### Step 2: Multi-Perspective Analysis

Analyze from four specialist viewpoints:

#### 🏗️ Architect Perspective

- System design implications
- Scalability considerations
- Integration points
- Technical debt trade-offs
- Long-term maintainability

#### 🔬 Research Perspective

- Prior art and existing solutions
- Industry best practices
- Relevant documentation
- Academic or technical resources
- Competitor approaches

#### 💻 Implementation Perspective

- Concrete implementation approach
- Code structure and patterns
- Libraries and tools needed
- Edge cases and error handling
- Testing strategy

#### ✅ Quality Perspective

- Potential failure modes
- Security implications
- Performance concerns
- Accessibility requirements
- Testing coverage

### Step 3: Synthesis

Combine perspectives into a coherent recommendation:

```markdown
## Synthesis

### Key Insights
1. [Insight from architecture]
2. [Insight from research]
3. [Insight from implementation]
4. [Insight from quality]

### Trade-offs
| Option | Pros | Cons |
|--------|------|------|
| A | [...] | [...] |
| B | [...] | [...] |

### Recommendation
[Recommended approach with reasoning]

### Risks and Mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [Action] |
```

### Step 4: Action Plan

```markdown
## Action Plan

### Phase 1: [Foundation]
- [ ] Task 1
- [ ] Task 2

### Phase 2: [Core Implementation]
- [ ] Task 3
- [ ] Task 4

### Phase 3: [Polish]
- [ ] Task 5
- [ ] Task 6

### Dependencies
- [What needs to happen first]

### Open Questions
- [Questions that need answers before proceeding]
```

## Output Format

```markdown
# Deep Analysis: [Problem Title]

## Executive Summary
[2-3 sentence summary of problem and recommendation]

## Problem Understanding
[Detailed problem breakdown]

## Analysis

### Architecture View
[System design analysis]

### Research Findings
[What exists, what's been tried]

### Implementation Approach
[How to build it]

### Quality Considerations
[Risks, security, testing]

## Recommendation
[Clear recommendation with reasoning]

## Action Plan
[Prioritized next steps]

## Open Questions
[What still needs to be decided]
```

## When to Use

- Complex architectural decisions
- New feature design
- Technology selection
- Problem-solving when stuck
- Strategic planning

## Tips

- **Don't rush** - The goal is thorough analysis
- **Challenge assumptions** - Question the obvious
- **Consider alternatives** - There's rarely only one way
- **Document uncertainty** - It's okay to not know everything
- **Focus on trade-offs** - Every decision has costs
