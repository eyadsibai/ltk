---
name: ltk:check-quality
description: Analyze code quality metrics including style, complexity, and type hints
argument-hint: "[path]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# Code Quality Analysis Command

Perform comprehensive code quality analysis including style compliance, complexity metrics, dead code detection, and type hint validation.

## Execution Steps

1. **Determine scope**: If path provided, analyze that path. Otherwise, analyze the entire project.

2. **Detect project type**: Identify primary language (Python, JavaScript, etc.) from files present.

3. **Style compliance check**:
   - For Python: Check PEP8/Black compliance
   - Look for inconsistent indentation, line lengths, naming conventions
   - Check import ordering

4. **Complexity analysis**:
   - Identify functions with high cyclomatic complexity (> 10)
   - Find deeply nested code (> 4 levels)
   - Flag long functions (> 50 lines)

5. **Dead code detection**:
   - Find unused imports
   - Identify unused variables
   - Look for unreachable code after return/raise

6. **Type hint analysis** (Python):
   - Check for missing type annotations on public functions
   - Identify functions without return type hints

7. **Generate quality report**: Present metrics and issues found.

## Output Format

```
Code Quality Report
===================

Scope: [analyzed path]
Primary language: [language]

Quality Metrics
---------------
| Metric                  | Value  | Target | Status |
|-------------------------|--------|--------|--------|
| Style Compliance        | X%     | >95%   | ✓/✗    |
| Avg Cyclomatic Complex  | X      | <10    | ✓/✗    |
| Max Function Length     | X      | <50    | ✓/✗    |
| Unused Imports          | X      | 0      | ✓/✗    |
| Type Coverage           | X%     | >80%   | ✓/✗    |

Issues Found
------------

HIGH COMPLEXITY (X)
[List functions with complexity > 10]

LONG FUNCTIONS (X)
[List functions > 50 lines]

UNUSED CODE (X)
[List unused imports, variables]

MISSING TYPES (X)
[List functions missing type hints]

Recommendations
---------------
[Prioritized list of improvements]
```

## Tips

- Use the code-quality skill for detailed patterns
- Focus on high-impact issues first (complexity, unused code)
- Consider running formatters (black, prettier) to fix style issues automatically
