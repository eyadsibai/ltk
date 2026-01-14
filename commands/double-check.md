---
name: double-check
description: Force re-evaluation of completed work to ensure it is truly production-ready
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Task
---

# Double-Check: Quality Assurance Verification

Force a thorough re-evaluation of completed work before considering it done.

## Purpose

This command exists because:

1. First implementations often miss edge cases
2. "It works" is not the same as "it's production-ready"
3. Fresh review catches issues fatigue missed
4. Prevents shipping bugs that seem obvious in hindsight

## Verification Checklist

### Code Quality

- [ ] **No hardcoded values** - Config, secrets, and magic numbers externalized?
- [ ] **Error handling complete** - All error paths handled gracefully?
- [ ] **Logging adequate** - Can you debug issues in production?
- [ ] **No debug code left** - Console.logs, print statements, TODO comments removed?
- [ ] **Code documented** - Complex logic explained?

### Testing

- [ ] **Tests pass** - All existing tests still green?
- [ ] **New tests added** - New functionality covered?
- [ ] **Edge cases tested** - Empty inputs, null values, boundaries?
- [ ] **Error cases tested** - What happens when things fail?

### Security

- [ ] **No secrets exposed** - API keys, passwords not in code?
- [ ] **Input validated** - User input sanitized?
- [ ] **Auth checked** - Permissions verified where needed?
- [ ] **SQL injection safe** - Parameterized queries used?

### Performance

- [ ] **No N+1 queries** - Database calls optimized?
- [ ] **No blocking calls** - Async used where appropriate?
- [ ] **Reasonable memory** - No unbounded growth?
- [ ] **Caching considered** - Repeated work avoided?

### Compatibility

- [ ] **Backwards compatible** - Existing clients still work?
- [ ] **Migration path** - Data migrates cleanly?
- [ ] **Rollback possible** - Can we undo this change?

## Execution

### Step 1: Run All Tests

```bash
# Run the test suite
npm test
# or
pytest
# or
go test ./...
```

### Step 2: Run Linting

```bash
# Check for style issues
npm run lint
# or
ruff check .
# or
golangci-lint run
```

### Step 3: Check for Common Issues

```bash
# Look for debug code
grep -rn "console.log\|print(\|debugger" --include="*.{js,ts,py}"

# Look for TODOs
grep -rn "TODO\|FIXME\|HACK\|XXX" --include="*.{js,ts,py}"

# Look for hardcoded secrets
grep -rn "password\s*=\s*['\"]" --include="*.{js,ts,py}"
grep -rn "api_key\s*=\s*['\"]" --include="*.{js,ts,py}"
```

### Step 4: Review Changes

```bash
# See what changed
git diff --stat HEAD~5

# Review the actual changes
git diff HEAD~5
```

### Step 5: Manual Testing

If applicable:

1. Test the happy path end-to-end
2. Test with invalid input
3. Test with edge cases
4. Test error scenarios

## Output Format

```markdown
# Double-Check Report

## Summary
**Status:** [Ready to Ship / Needs Work]
**Confidence:** [High / Medium / Low]

## Automated Checks
| Check | Status | Notes |
|-------|--------|-------|
| Tests | PASS | 42 tests, 100% pass |
| Lint | PASS | No warnings |
| Security scan | PASS | No issues |

## Manual Review
| Area | Status | Notes |
|------|--------|-------|
| Code quality | OK | Clean and readable |
| Error handling | NEEDS WORK | Missing retry logic |
| Performance | OK | Query optimized |

## Issues Found
1. **[Issue]** - [Location] - [Fix needed]
2. **[Issue]** - [Location] - [Fix needed]

## Recommendation
[Ship it / Fix issues first / Needs more review]
```

## When to Use

Use double-check:

- Before creating a PR
- Before deploying to production
- After a long coding session
- When working on critical features
- When you have that "did I miss something?" feeling

## Remember

The goal is not to find fault, but to ensure quality. A clean double-check report gives confidence to ship. Issues found now are cheaper than issues found in production.
