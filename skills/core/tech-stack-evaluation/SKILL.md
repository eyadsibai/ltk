---
name: tech-stack-evaluation
description: Use when "evaluating technology", "choosing frameworks", "stack comparison", "technology decisions", or asking about "React vs Vue", "PostgreSQL vs MySQL", "AWS vs GCP", "build vs buy"
version: 1.0.0
---

<!-- Adapted from: claude-skills/engineering-team/tech-stack-evaluator -->

# Tech Stack Evaluation Guide

Framework for making technology decisions.

## When to Use

- Choosing between frameworks/libraries
- Evaluating cloud providers
- Making build vs buy decisions
- Planning technology migrations
- Standardizing tech stack

## Evaluation Framework

### Decision Matrix

| Factor | Weight | Option A | Option B | Option C |
|--------|--------|----------|----------|----------|
| Team Experience | 20% | Score | Score | Score |
| Community/Support | 15% | Score | Score | Score |
| Performance | 15% | Score | Score | Score |
| Scalability | 15% | Score | Score | Score |
| Cost (TCO) | 15% | Score | Score | Score |
| Integration | 10% | Score | Score | Score |
| Security | 10% | Score | Score | Score |

### Scoring Guide

| Score | Meaning |
|-------|---------|
| 5 | Excellent, best in class |
| 4 | Good, above average |
| 3 | Adequate, meets needs |
| 2 | Below average, concerns |
| 1 | Poor, significant issues |

## Common Comparisons

### Frontend Frameworks

| Factor | React | Vue | Angular |
|--------|-------|-----|---------|
| Learning Curve | Medium | Low | High |
| Ecosystem | Large | Medium | Large |
| Performance | Good | Good | Good |
| Enterprise | Yes | Growing | Yes |
| Job Market | Largest | Growing | Strong |

### Backend Languages

| Factor | Node.js | Python | Go | Java |
|--------|---------|--------|-----|------|
| Performance | Good | Medium | Excellent | Good |
| Ecosystem | Large | Large | Growing | Large |
| Learning | Easy | Easy | Medium | Hard |
| Concurrency | Event-loop | Async | Native | Threads |

### Databases

| Factor | PostgreSQL | MySQL | MongoDB | DynamoDB |
|--------|------------|-------|---------|----------|
| Type | Relational | Relational | Document | Key-Value |
| Scalability | Vertical | Vertical | Horizontal | Horizontal |
| Schema | Strict | Strict | Flexible | Flexible |
| Cost | Free | Free | Free/Paid | Usage |

### Cloud Providers

| Factor | AWS | GCP | Azure |
|--------|-----|-----|-------|
| Market Share | Largest | Growing | Second |
| Services | Most complete | Strong ML/Data | Enterprise |
| Pricing | Complex | Simpler | Complex |
| Free Tier | 12 months | Always free | 12 months |

## Evaluation Process

### Step 1: Define Requirements

```markdown
## Requirements
- Scale: [Expected users/requests]
- Performance: [Latency requirements]
- Budget: [Monthly/yearly budget]
- Team: [Current skills and size]
- Timeline: [Implementation deadline]
```

### Step 2: Identify Options

Research 3-5 viable options:

- Current market leaders
- Rising alternatives
- Team-familiar options

### Step 3: Proof of Concept

Build minimal POC for top 2-3 options:

- Core functionality
- Integration test
- Performance benchmark

### Step 4: Total Cost Analysis

| Cost Type | Option A | Option B |
|-----------|----------|----------|
| Licensing | $ | $ |
| Infrastructure | $ | $ |
| Development | $ | $ |
| Training | $ | $ |
| Maintenance | $ | $ |
| **Total (3 yr)** | $ | $ |

### Step 5: Risk Assessment

| Risk | Option A | Option B |
|------|----------|----------|
| Vendor lock-in | Low/Med/High | |
| Technology obsolescence | | |
| Skill availability | | |
| Security concerns | | |

## Build vs Buy

### Build When

- Core competitive advantage
- Unique requirements
- Long-term cost savings
- Team has expertise

### Buy When

- Commodity functionality
- Time to market critical
- Ongoing maintenance burden
- Industry standard exists

### Decision Tree

```
Is it core to your business?
├── Yes → Does expertise exist?
│   ├── Yes → Build
│   └── No → Buy (for now)
└── No → Buy or use open source
```

## Migration Planning

### Migration Phases

1. **Assessment** - Current state analysis
2. **Planning** - Target architecture
3. **Preparation** - Team training, tooling
4. **Migration** - Incremental rollout
5. **Validation** - Testing, monitoring
6. **Cutover** - Final switch
7. **Optimization** - Post-migration tuning

### Risk Mitigation

- Run parallel systems
- Feature flags for rollback
- Comprehensive testing
- Staged rollout
- Clear rollback plan

## Documentation Template

```markdown
# Technology Decision: [Name]

## Context
Why are we making this decision?

## Options Considered
1. [Option A] - Pros/Cons
2. [Option B] - Pros/Cons
3. [Option C] - Pros/Cons

## Decision
We chose [Option] because...

## Consequences
- Positive: [List]
- Negative: [List]

## Implementation Plan
- Phase 1: [Action]
- Phase 2: [Action]
```
