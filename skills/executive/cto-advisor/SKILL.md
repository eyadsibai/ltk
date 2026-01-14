---
name: cto-advisor
description: Use when "CTO decisions", "technical strategy", "engineering organization", "technology roadmap", or asking about "tech debt", "platform architecture", "engineering hiring", "build vs buy"
version: 1.0.0
---

<!-- Adapted from: claude-skills/c-level-advisor/cto-advisor -->

# CTO Advisory Guide

Technical strategy and engineering leadership frameworks.

## When to Use

- Making technology strategy decisions
- Scaling engineering organizations
- Evaluating build vs buy decisions
- Managing technical debt
- Planning technology roadmaps

## Technical Strategy Framework

### Build vs Buy Decision

| Factor | Build | Buy |
|--------|-------|-----|
| Core competency | ✓ | |
| Competitive advantage | ✓ | |
| Commodity function | | ✓ |
| Time to market critical | | ✓ |
| Long-term cost | Evaluate | Evaluate |

### Decision Matrix

```
Is it core to our business?
├── Yes → Consider building
│   └── Do we have the expertise?
│       ├── Yes → Build
│       └── No → Build + hire or Buy
└── No → Buy or integrate
```

## Engineering Organization

### Team Scaling

| Company Stage | Eng Size | Structure |
|---------------|----------|-----------|
| Startup | 5-15 | Single team |
| Growth | 15-50 | Functional teams |
| Scale | 50-150 | Squads/pods |
| Enterprise | 150+ | Business units |

### Team Topologies

| Type | Best For |
|------|----------|
| Stream-aligned | Product delivery |
| Platform | Internal tools/infra |
| Enabling | Capability building |
| Complicated-subsystem | Deep expertise |

### Ratios

| Ratio | Benchmark |
|-------|-----------|
| Eng:PM | 8-10:1 |
| Eng:Designer | 8-12:1 |
| Senior:Junior | 1:2 to 1:3 |
| IC:Manager | 6-8:1 |

## Technical Debt Management

### Debt Categories

| Type | Impact | Approach |
|------|--------|----------|
| Code debt | Velocity | Continuous refactor |
| Architecture debt | Scalability | Planned migration |
| Test debt | Quality | Sprint allocation |
| Documentation debt | Onboarding | Doc sprints |

### Prioritization Framework

```
Debt Score = Impact × Frequency × Fix Effort

High Score → Address immediately
Medium Score → Plan for next quarter
Low Score → Track but deprioritize
```

### Budget Allocation

| Category | % of Sprint |
|----------|-------------|
| New features | 60-70% |
| Tech debt | 15-25% |
| Bugs/maintenance | 10-15% |

## Technology Roadmap

### Roadmap Structure

```
Quarter 1: Foundation
- Infrastructure improvements
- Key debt reduction

Quarter 2: Platform
- Scalability work
- Developer experience

Quarter 3: Innovation
- New capabilities
- Experimentation

Quarter 4: Optimization
- Performance
- Cost efficiency
```

### Evaluation Criteria

| Factor | Questions |
|--------|-----------|
| Business Value | Does it enable revenue/growth? |
| Technical Value | Does it improve architecture? |
| Risk Reduction | Does it reduce vulnerabilities? |
| Developer Experience | Does it improve productivity? |

## Architecture Decisions

### ADR Template

```markdown
# ADR-001: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded]

## Context
What is the issue we're facing?

## Decision
What is the change we're proposing?

## Consequences
What are the positive and negative outcomes?
```

### Review Checklist

- [ ] Scalability considerations
- [ ] Security implications
- [ ] Operational complexity
- [ ] Cost impact
- [ ] Team capability
- [ ] Migration path

## Engineering Metrics

### DORA Metrics

| Metric | Elite | High | Medium |
|--------|-------|------|--------|
| Deployment Frequency | Multiple/day | Weekly | Monthly |
| Lead Time | <1 hour | <1 week | <1 month |
| Change Failure Rate | <5% | <10% | <15% |
| Recovery Time | <1 hour | <1 day | <1 week |

### Other Key Metrics

| Metric | Purpose |
|--------|---------|
| Velocity | Team capacity |
| Cycle Time | Development speed |
| Code Coverage | Test health |
| Incident Rate | System reliability |

## Hiring & Retention

### Interview Process

1. Resume screen → Technical phone → Take-home/pair → Onsite → Offer

### Leveling Framework

| Level | Scope | Independence |
|-------|-------|--------------|
| Junior | Tasks | Guided |
| Mid | Features | Moderate |
| Senior | Systems | High |
| Staff | Organization | Strategic |
| Principal | Company | Visionary |

### Retention Strategies

- Clear career paths
- Technical challenges
- Learning opportunities
- Competitive compensation
- Strong engineering culture

## Vendor Management

### Vendor Evaluation Criteria

| Factor | Weight |
|--------|--------|
| Technical fit | 30% |
| Cost/value | 25% |
| Support/reliability | 20% |
| Integration ease | 15% |
| Vendor stability | 10% |

### Risk Mitigation

- Avoid single vendor lock-in
- Maintain abstraction layers
- Plan exit strategies
- Regular vendor reviews
