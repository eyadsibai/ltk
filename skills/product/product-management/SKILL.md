---
name: product-management
description: Use when "RICE prioritization", "feature prioritization", "PRD writing", "user stories", or asking about "product roadmap", "customer interviews", "sprint planning", "backlog grooming"
version: 1.0.0
---

<!-- Adapted from: claude-skills/product-team/product-manager-toolkit -->

# Product Management Toolkit

Feature prioritization, PRDs, and product discovery frameworks.

## When to Use

- Prioritizing feature backlog
- Writing product requirements
- Analyzing customer interviews
- Planning sprints and roadmaps
- Making data-driven product decisions

## RICE Prioritization

### Formula

```
Score = (Reach × Impact × Confidence) / Effort
```

| Factor | Scale |
|--------|-------|
| Reach | Users per quarter |
| Impact | Massive=3, High=2, Medium=1, Low=0.5, Minimal=0.25 |
| Confidence | High=100%, Medium=80%, Low=50% |
| Effort | Person-months |

### Example

| Feature | Reach | Impact | Confidence | Effort | Score |
|---------|-------|--------|------------|--------|-------|
| User Dashboard | 500 | 3 (massive) | 80% | 5 | 240 |
| Dark Mode | 300 | 1 (medium) | 100% | 2 | 150 |
| API Rate Limiting | 1000 | 2 (high) | 90% | 3 | 600 |

## Value vs Effort Matrix

```
           Low Effort    High Effort

High       QUICK WINS    BIG BETS
Value      [Prioritize]  [Strategic]

Low        FILL-INS      TIME SINKS
Value      [Maybe]       [Avoid]
```

## PRD Template

```markdown
# Feature: [Name]

## Problem Statement
What problem are we solving? For whom?

## Success Metrics
- Primary: [Metric and target]
- Secondary: [Supporting metrics]

## User Stories
As a [user], I want [capability] so that [benefit].

## Requirements
### Must Have (P0)
- [Requirement 1]

### Should Have (P1)
- [Requirement 2]

### Out of Scope
- [Explicit exclusion]

## Design
[Link to designs or wireframes]

## Technical Approach
[High-level technical approach]

## Timeline
- Phase 1: [Scope] - [Date]
- Phase 2: [Scope] - [Date]

## Open Questions
- [Question 1]
```

## Customer Interview Framework

### Structure (35 min)

1. **Context** (5 min)
   - Role and responsibilities
   - Current workflow
   - Tools used

2. **Problem Exploration** (15 min)
   - Pain points
   - Frequency and impact
   - Current workarounds

3. **Solution Validation** (10 min)
   - Reaction to concepts
   - Value perception
   - Willingness to pay

4. **Wrap-up** (5 min)
   - Other thoughts
   - Referrals

### Analysis Framework

Extract from each interview:

- **Pain points** with severity (high/medium/low)
- **Feature requests** with priority
- **Jobs to be done** patterns
- **Key quotes** for stakeholder communication

## Sprint Planning

### Capacity Planning

```
Sprint Capacity = Team Size × Days × Velocity Factor

Example:
5 engineers × 10 days × 0.7 = 35 story points
```

### Story Point Guidelines

| Points | Complexity | Example |
|--------|------------|---------|
| 1 | Trivial | Copy change |
| 2 | Simple | Add field to form |
| 3 | Medium | New API endpoint |
| 5 | Complex | New feature with UI |
| 8 | Very Complex | Integration with external service |
| 13 | Epic-level | Break down further |

## MoSCoW Method

- **Must Have**: Critical for launch
- **Should Have**: Important but not critical
- **Could Have**: Nice to have
- **Won't Have**: Out of scope (this release)

## Metrics Framework

### North Star Metric

- What's the #1 value to users?
- Is it measurable and actionable?
- Does it predict business success?

### Feature Success Metrics

- **Adoption**: % users using feature
- **Frequency**: Usage per user per week
- **Retention**: Continued usage over time
- **Satisfaction**: NPS/CSAT for feature

## Best Practices

### Writing PRDs

- Start with problem, not solution
- Include clear success metrics
- Explicitly state what's out of scope
- Use visuals (wireframes, flows)

### Prioritization

- Mix quick wins with strategic bets
- Account for dependencies
- Buffer for unexpected work (20%)
- Revisit quarterly

### Discovery

- Ask "why" 5 times
- Focus on past behavior, not intentions
- Look for emotional reactions
- Validate with data
