---
name: ltk:fix-issue
description: Analyze and fix a GitHub issue with proper implementation and testing
argument-hint: "<issue-number>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# Fix Issue Command

Analyze a GitHub issue and implement a proper fix with testing and verification.

## Execution Steps

### 1. Fetch Issue Details

```bash
gh issue view <issue-number>
```

Parse the issue to understand:

- Problem description
- Expected behavior
- Actual behavior
- Steps to reproduce
- Any error messages or logs

### 2. Analyze the Problem

- Search codebase for related files
- Understand the affected component
- Identify root cause
- Check for related issues or PRs

### 3. Plan the Fix

Create a todo list with:

- Files to modify
- Changes needed
- Tests to add/update
- Documentation updates

### 4. Implement the Fix

- Make minimal, focused changes
- Follow existing code patterns
- Add appropriate comments
- Handle edge cases

### 5. Verify the Fix

Run tests to ensure:

```bash
# Run related tests
npm test  # or pytest, go test, etc.

# Check linting
npm run lint

# Type checking
npm run typecheck
```

### 6. Create Commit

Format: `fix(scope): description (fixes #<issue>)`

Include in commit body:

- What was the problem
- How it was fixed
- Any relevant notes

## Output Format

```
Fix Issue #<number>
===================

Issue: <title>
Status: <open/closed>
Labels: <labels>

Problem Analysis
----------------
<summary of the issue>

Root Cause
----------
<explanation of why this happened>

Implementation Plan
-------------------
1. [file]: <change description>
2. [file]: <change description>

Changes Made
------------
Modified:
  - src/component.ts: Fixed null check in processData()
  - tests/component.test.ts: Added test for edge case

Verification
------------
[✓] Tests pass
[✓] Lint clean
[✓] Type check pass

Commit
------
fix(component): handle null input in processData (fixes #<issue>)

Next Steps
----------
- Push changes: git push
- Issue will auto-close when PR merges
- Consider adding regression test
```

## Tips

- Reference the issue number in commits
- Keep fixes focused and atomic
- Add tests that would have caught the bug
- Update documentation if behavior changes
- Consider similar issues that might exist elsewhere
