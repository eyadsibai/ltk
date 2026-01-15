---
name: ltk:log-work
description: Log the current work segment to a worklog file with progressive disclosure
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
---

# Log Work Command

Log the work segment since the last log entry to `WORKLOG/YYYYMMDD.md`.

## Purpose

Create a concise work log following the **progressive disclosure principle**:

- Summary in the log file
- References to detailed documents for those who need more

This allows humans and AI agents to quickly scan progress and only dig deeper when needed.

## Execution

### 1. Create Worklog Directory

```bash
mkdir -p WORKLOG
```

### 2. Create or Append to Today's Log

File: `WORKLOG/YYYYMMDD.md` (e.g., `WORKLOG/20260114.md`)

### 3. Log Entry Format

Each entry is a top-level section with timestamp:

```markdown
# HH:MM [Concise Topic]

## Summary
[1-3 sentences describing what was done]

## Files
- Created: [list of files created]
- Modified: [list of files modified]
- Read: [key files referenced]

## Results
[Brief outcome or status]

## References
- [Link to detailed document if applicable]
- [Link to PR or issue if applicable]
```

### 4. Example Entry

```markdown
# 14:30 Implemented user authentication

## Summary
Added JWT-based authentication to the API with refresh token support.
Followed existing patterns from the payments module.

## Files
- Created: `src/auth/jwt.ts`, `src/auth/middleware.ts`
- Modified: `src/routes/index.ts`, `src/config.ts`
- Read: `src/payments/auth.ts` (reference pattern)

## Results
All auth tests passing. Ready for code review.

## References
- PR: #142
- Design doc: `docs/auth-design.md`
```

## Progressive Disclosure Principle

The worklog is NOT meant to be exhaustive. It provides:

1. **Quick Scan** - Timestamp + topic in heading
2. **Summary** - What happened in 1-3 sentences
3. **File Changes** - What was created/modified
4. **Deep Dive** - References to detailed docs

Anyone needing details can follow the references.

## What to Include

| Include | Don't Include |
|---------|---------------|
| High-level summary | Full implementation details |
| Files created/modified | Every line changed |
| Key decisions made | All debugging steps |
| Links to detailed docs | Duplicate content |
| Blockers encountered | Resolved minor issues |

## When to Log

- After completing a logical unit of work
- Before switching to a different task
- At end of session
- After significant milestones

## Tips

- Keep entries concise (aim for <100 words)
- Use consistent formatting
- Include session_id if available
- Link to PRs, issues, and docs
- Timestamp helps track work rhythm
