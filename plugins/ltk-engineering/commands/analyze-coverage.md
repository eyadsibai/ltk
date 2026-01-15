---
name: ltk:analyze-coverage
description: Analyze test coverage and identify testing gaps
argument-hint: "[path]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# Test Coverage Analysis Command

Analyze test coverage to measure how well the codebase is tested and identify critical gaps.

## Execution Steps

1. **Detect test framework**:
   - Python: pytest, unittest
   - JavaScript: Jest, Mocha
   - Check for coverage tools (pytest-cov, coverage.py, nyc)

2. **Run coverage analysis**:
   - Execute tests with coverage enabled if possible
   - Or analyze existing coverage reports if available
   - Parse coverage data

3. **Calculate coverage metrics**:
   - Line coverage percentage
   - Branch coverage if available
   - Coverage by module/directory

4. **Identify coverage gaps**:
   - Files with 0% coverage
   - Functions with low coverage
   - Untested error handling paths
   - Missing edge case tests

5. **Prioritize gaps**:
   - Critical: Payment, auth, security code
   - Important: Core business logic
   - Lower: Utilities, configuration

6. **Generate test recommendations**: Suggest specific tests to add.

## Output Format

```
Test Coverage Analysis
======================

Test Framework: [pytest/jest/etc.]
Coverage Tool: [pytest-cov/coverage.py/etc.]

Coverage Summary
----------------
Total Coverage: X%
Target: 80%
Status: [PASS/BELOW TARGET]

Coverage by Component
---------------------
| Component      | Lines | Covered | Coverage |
|----------------|-------|---------|----------|
| src/api/       | XXX   | XXX     | XX%      |
| src/services/  | XXX   | XXX     | XX%      |
| src/utils/     | XXX   | XXX     | XX%      |

Critical Gaps (Priority: High)
------------------------------
1. [file.py] - XX% coverage
   - [function()]: Lines X-Y untested
   - [function()]: No error handling tests

2. [file.py] - XX% coverage
   - [description of gap]

Untested Files
--------------
- [file1.py]
- [file2.py]

Recommended Tests
-----------------
1. test_[name].py
   - test_[scenario]()
   - test_[scenario]()

2. test_[name].py
   - test_[scenario]()

Coverage Trend
--------------
[If historical data available]

Next Steps
----------
1. [Most impactful test to add]
2. [Second priority]
3. [Third priority]
```

## Tips

- Use the test-coverage skill for detailed patterns
- Focus on critical paths first (auth, payments, data validation)
- Quality over quantity - meaningful tests > high coverage numbers
