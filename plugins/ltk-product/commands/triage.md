---
name: ltk:triage
description: Process and prioritize findings from code reviews, security scans, or audits
argument-hint: "[path to findings file or paste findings]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - TodoWrite
---

# Triage

Process categorized findings and convert them into a prioritized, actionable task list.

## Input

**Findings:** `#$ARGUMENTS`

**If empty, ask:** "Please provide the findings to triage (paste directly or provide a file path)."

## Process

### Step 1: Parse Findings

Identify and categorize each finding:

| Category | Priority | Examples |
|----------|----------|----------|
| **Security** | Critical/High | Vulnerabilities, auth issues |
| **Performance** | Medium/High | Slow queries, memory leaks |
| **Code Quality** | Medium | Code smells, complexity |
| **Best Practices** | Low/Medium | Style, conventions |
| **Documentation** | Low | Missing docs, outdated |

### Step 2: Assess Severity

For each finding, determine:

```markdown
| Severity | Criteria | Response Time |
|----------|----------|---------------|
| Critical | Security breach, data loss risk | Immediate |
| High | Major functionality impact | < 24 hours |
| Medium | Moderate impact, workarounds exist | < 1 week |
| Low | Minor issues, cosmetic | Next sprint |
```

### Step 3: Create Action Items

For each finding, create a structured task:

```markdown
## [Severity] Finding Title

**Category**: [Security/Performance/Quality/etc.]
**Location**: `path/to/file.ts:42`
**Impact**: [Description of impact]

### Current State
[What's wrong]

### Required Action
1. [Step 1]
2. [Step 2]

### Verification
[How to verify fix]
```

### Step 4: Prioritize

Create prioritized task list using TodoWrite:

```
Critical Issues (Fix Now):
1. [Issue with file:line]

High Priority (This Sprint):
2. [Issue with file:line]
3. [Issue with file:line]

Medium Priority (Next Sprint):
4. [Issue with file:line]

Low Priority (Backlog):
5. [Issue with file:line]
```

## Output Format

```markdown
# Triage Report

## Summary
- **Total Findings**: X
- **Critical**: X
- **High**: X
- **Medium**: X
- **Low**: X

## Critical Issues (Immediate Action Required)

### [CRIT-001] Issue Title
- **File**: `path/to/file.ts:42`
- **Issue**: [Description]
- **Fix**: [Action required]

## High Priority

### [HIGH-001] Issue Title
...

## Medium Priority

### [MED-001] Issue Title
...

## Low Priority

### [LOW-001] Issue Title
...

## Recommendations

1. [Strategic recommendation]
2. [Process improvement]

## Next Steps

1. Address all critical issues immediately
2. Plan high-priority fixes for current sprint
3. Schedule medium-priority for next sprint
4. Add low-priority to backlog
```

## Integration

After triage, use TodoWrite to track progress on addressing findings.
