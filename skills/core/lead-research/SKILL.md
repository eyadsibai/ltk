---
name: lead-research
description: Use when "finding leads", "sales prospecting", "target companies", "business development", or asking about "ideal customer profile", "lead qualification", "outreach strategies"
version: 1.0.0
---

<!-- Adapted from: awesome-claude-skills/lead-research-assistant -->

# Lead Research Assistant

Identify and qualify potential leads by analyzing your product and finding target companies.

## When to Use

- Finding potential customers for your product
- Building company lists for partnerships
- Identifying target accounts for sales
- Researching companies matching your ICP
- Preparing for business development

## Workflow

1. **Understand** - Analyze your product/service
2. **Define** - Create ideal customer profile
3. **Research** - Find matching companies
4. **Score** - Prioritize leads by fit
5. **Strategize** - Provide contact approaches

## Ideal Customer Profile (ICP)

Define your target by:

| Attribute | Examples |
|-----------|----------|
| Industry | SaaS, Fintech, Healthcare |
| Company Size | 50-200 employees |
| Location | Bay Area, US, Global |
| Technology | Uses AWS, Python, etc. |
| Growth Stage | Series A, Profitable |
| Pain Points | Problems your product solves |

## Lead Scoring Criteria

Score 1-10 based on:

| Factor | Weight |
|--------|--------|
| ICP Alignment | High |
| Signals of Need | High |
| Budget Availability | Medium |
| Timing Indicators | Medium |
| Competitive Landscape | Low |

**Signals of Need**:

- Job postings for relevant roles
- Tech stack indicators
- Recent news or announcements
- Growth/funding indicators

## Output Format

```markdown
# Lead Research Results

## Summary
- Total leads found: [X]
- High priority (8-10): [X]
- Medium priority (5-7): [X]

---

## Lead 1: [Company Name]

**Website**: [URL]
**Priority Score**: [X/10]
**Industry**: [Industry]
**Size**: [Employee count]

**Why They're a Good Fit**:
[2-3 specific reasons]

**Target Decision Maker**: [Role/Title]
**LinkedIn**: [URL if available]

**Value Proposition for Them**:
[Specific benefit for this company]

**Outreach Strategy**:
[Personalized approach]

**Conversation Starters**:
- [Specific point 1]
- [Specific point 2]
```

## Finding Lead Signals

Look for:

- Job postings revealing tech stack/needs
- GitHub repos showing tool usage
- Recent funding announcements
- Company blog posts about challenges
- Conference speaking or sponsorships
- Technology partnership announcements

## Outreach Strategies

### Cold Email

- Reference specific company context
- Lead with value, not features
- Include relevant social proof

### LinkedIn

- Connect with personalized note
- Engage with their content first
- Reference mutual connections

### Warm Introduction

- Identify mutual contacts
- Ask for specific introduction
- Prepare context for introducer

## Best Practices

- Be specific about your product's value
- Run from your codebase for automatic context
- Provide detailed ICP constraints
- Request follow-up on promising leads
- Generate CRM-ready CSV exports
