---
name: ltk:refactor
description: Guided refactoring with safety checks
argument-hint: "<type> [target]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Edit
  - TodoWrite
---

# Refactor Command

Perform safe refactoring operations with comprehensive checks and verification.

## Arguments

- **type**: Type of refactoring
  - `rename`: Rename function, class, or variable
  - `extract`: Extract code into new function/class
  - `simplify`: Reduce complexity
  - `inline`: Inline function or variable
  - `move`: Move code to different module
- **target**: The code element to refactor (optional, will prompt if not provided)

## Execution Steps

1. **Pre-refactoring checks**:
   - Ensure tests exist for affected code
   - Run tests to establish baseline
   - Check for other code that might be affected

2. **Analyze target**:
   - Understand current structure
   - Find all references
   - Identify dependencies
   - Assess impact scope

3. **Plan refactoring**:
   - Document what will change
   - Identify all files affected
   - Plan change sequence
   - Prepare rollback strategy

4. **Execute refactoring**:
   - Make changes incrementally
   - Verify each step
   - Update tests if needed

5. **Post-refactoring verification**:
   - Run all tests
   - Check for lint errors
   - Verify type checking passes
   - Confirm functionality unchanged

6. **Report results**: Show what changed and verification status.

## Refactoring Types

### Rename

```
/mytoolkit:refactor rename old_name new_name
```

- Find all occurrences
- Update imports
- Update references
- Update documentation

### Extract

```
/mytoolkit:refactor extract function_name file:start-end
```

- Extract code block to new function
- Identify parameters and return values
- Replace original with function call

### Simplify

```
/mytoolkit:refactor simplify file_or_function
```

- Reduce cyclomatic complexity
- Flatten nested conditionals
- Remove dead code
- Simplify expressions

## Output Format

```
Refactoring: [type]
===================

Target: [what is being refactored]

Pre-Refactoring Analysis
------------------------
Tests exist: [Yes/No]
Test status: [PASS/FAIL]
References found: X
Files affected: X

Refactoring Plan
----------------
1. [Step 1]
2. [Step 2]
3. [Step 3]

Impact Assessment
-----------------
| File              | Changes          |
|-------------------|------------------|
| src/module.py     | Rename function  |
| tests/test_mod.py | Update tests     |

Executing Refactoring
---------------------
[✓] Step 1 complete
[✓] Step 2 complete
[✓] Step 3 complete

Post-Refactoring Verification
-----------------------------
[✓] All tests pass
[✓] No lint errors
[✓] Type checking passes
[✓] Functionality verified

Summary
-------
Files changed: X
Lines modified: X
Tests updated: X

Commit with: /mytoolkit:smart-commit
```

## Tips

- Use the refactoring skill for detailed patterns
- Always verify tests pass before and after
- Make small, incremental changes
- Commit after each successful refactoring
