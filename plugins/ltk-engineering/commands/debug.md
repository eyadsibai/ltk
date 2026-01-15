---
name: ltk:debug
description: Systematic debugging for code bugs, runtime issues, and system problems
argument-hint: "[bug description, error message, or symptom]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Task
  - TodoWrite
  - AskUserQuestion
---

# Debug Command

Systematic approach to finding and fixing bugs through hypothesis-driven investigation.

## Problem Description

<bug_description> #$ARGUMENTS </bug_description>

**If empty, ask:** "What bug are you investigating? Describe the symptom, error message, or unexpected behavior."

## Investigation Framework

### Phase 1: Gather Evidence

```markdown
## Evidence Collection

### Error Information
- Error message: [Exact text]
- Stack trace: [If available]
- Error code: [If any]

### Environment
- Environment: [Development/Staging/Production]
- Recent changes: [What changed recently?]
- First occurrence: [When did this start?]

### Reproduction
- Steps to reproduce: [1, 2, 3...]
- Reproducibility: [Always/Sometimes/Rare]
- Affected users: [All/Some/One]
```

### Phase 2: System State Check

```bash
# Check running processes
ps aux | grep -E "node|python|java|go" | head -20

# Check open ports
lsof -i -P -n | grep LISTEN

# Check disk space
df -h

# Check memory
free -h 2>/dev/null || vm_stat

# Check application logs
tail -200 logs/app.log 2>/dev/null
```

### Phase 3: Form Hypotheses

Generate at least 3 possible causes, ranked by likelihood:

```markdown
## Hypotheses

| # | Hypothesis | Likelihood | Test Method |
|---|-----------|------------|-------------|
| 1 | [Most likely cause] | High | [How to test] |
| 2 | [Second possibility] | Medium | [How to test] |
| 3 | [Third possibility] | Low | [How to test] |
```

### Phase 4: Test Hypotheses

For each hypothesis, systematically test:

```markdown
## Hypothesis Testing

### H1: [Hypothesis]
**Test:** [What we did]
**Result:** [What we found]
**Conclusion:** [Confirmed/Refuted/Inconclusive]
```

### Phase 5: Root Cause Analysis (5 Whys)

```markdown
1. **Why** did [symptom] happen?
   → Because [immediate cause]

2. **Why** did [immediate cause] happen?
   → Because [deeper cause]

3. **Why** did [deeper cause] happen?
   → Because [even deeper]

4. **Why** did [even deeper] happen?
   → Because [root cause emerging]

5. **Why** did [root cause emerging] happen?
   → Because [ROOT CAUSE]
```

## Debugging Commands Reference

```bash
# Search for error patterns
grep -rn "ErrorMessage" --include="*.py"

# Find recent changes to file
git log --oneline -20 -- path/to/file.py

# Check who last modified a line
git blame path/to/file.py -L 42,50

# Find when bug was introduced
git bisect start
git bisect bad HEAD
git bisect good v1.0.0

# Debug Python
DEBUG=* python script.py
python -m pdb script.py

# Debug Node.js
DEBUG=* node app.js
node --inspect app.js

# Profile Python
python -m cProfile -o profile.out script.py

# Database connections
psql -c "SELECT * FROM pg_stat_activity;"
```

## Issue Categories

| Category | Symptoms | Common Causes |
|----------|----------|---------------|
| **Crash** | Process terminates | Unhandled exception, OOM |
| **Hang** | Process unresponsive | Deadlock, infinite loop |
| **Slow** | High latency | Resource contention, N+1 |
| **Error** | Error messages | Bad input, config issue |
| **Wrong Output** | Incorrect results | Logic bug, data issue |

## Common Bug Patterns

| Pattern | Symptoms | Investigation |
|---------|----------|---------------|
| Race condition | Intermittent, timing-dependent | Add logging with timestamps |
| Memory leak | Gradual slowdown, OOM | Profile memory over time |
| Off-by-one | Wrong counts, missing items | Check loop bounds |
| Null reference | Crashes on certain data | Trace data flow |
| State corruption | Wrong values, inconsistent | Add state assertions |
| Timeout | Hangs, slow responses | Check network, DB queries |

## Output Format

```markdown
# Bug Investigation: [Brief Description]

## Summary
**Status:** [Investigating/Root Cause Found/Fixed]
**Severity:** [Critical/High/Medium/Low]
**Impact:** [Who/what is affected]

## Evidence Collected
- [Key evidence 1]
- [Key evidence 2]

## Investigation Timeline
1. [First thing checked] → [Result]
2. [Second thing checked] → [Result]
3. [Third thing checked] → [FOUND IT]

## Root Cause
[Clear explanation of what caused the bug]

## Fix
**File:** `path/to/file.py:42`
**Change:** [Description of fix]

```python
# Before
[buggy code]

# After
[fixed code]
```

## Prevention

- [ ] Add test case for this scenario
- [ ] Add validation to prevent recurrence
- [ ] Update documentation
- [ ] Consider similar bugs elsewhere

```

## Debugging Checklist

Before giving up:

- [ ] Read the full error message and stack trace
- [ ] Check if the error is reproducible
- [ ] Search codebase for error message
- [ ] Check recent git commits
- [ ] Verify environment variables
- [ ] Check logs for related errors
- [ ] Try to minimize reproduction case
- [ ] Check for similar issues in issue tracker
- [ ] Ask: "What changed recently?"

## Tips

- **Start broad, narrow down** - Don't assume the cause
- **Check the obvious first** - Disk space, permissions, config
- **Reproduce consistently** - Random bugs are hard to fix
- **Document everything** - Future you will thank present you
- **Take breaks** - Fresh eyes find bugs faster
