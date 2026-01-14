---
name: validate-build
description: Run and validate the build process
argument-hint: "[env]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# Validate Build Command

Run the build process and validate that all build steps complete successfully.

## Execution Steps

1. **Detect project type**:
   - Python: Look for setup.py, pyproject.toml, requirements.txt
   - Node.js: Look for package.json
   - Other: Look for Makefile, build scripts

2. **Pre-build validation**:
   - Check dependencies are installed
   - Verify required environment variables
   - Validate configuration files

3. **Run linting**:
   - Python: flake8, black --check
   - JavaScript: eslint
   - Report any lint errors

4. **Run type checking**:
   - Python: mypy
   - TypeScript: tsc --noEmit
   - Report type errors

5. **Run tests**:
   - Execute test suite
   - Report test results and coverage

6. **Run build**:
   - Python: python -m build
   - Node.js: npm run build
   - Report build output

7. **Post-build validation**:
   - Check build artifacts exist
   - Verify artifact sizes are reasonable
   - Check for development dependencies in production build

8. **Generate build report**: Summarize all validation results.

## Output Format

```
Build Validation
================

Project: [name]
Type: [Python/Node.js/etc.]
Environment: [dev/staging/prod]

Pre-Build Checks
----------------
[✓] Dependencies installed
[✓] Environment variables set
[✓] Configuration valid

Lint Check
----------
Status: [PASS/FAIL]
[Details if failed]

Type Check
----------
Status: [PASS/FAIL]
[Details if failed]

Tests
-----
Status: [PASS/FAIL]
Tests Run: X
Passed: X
Failed: X
Coverage: X%

Build
-----
Status: [PASS/FAIL]
Duration: Xs
Output: [build directory]

Artifacts
---------
| Artifact          | Size    | Status |
|-------------------|---------|--------|
| [artifact name]   | X KB    | ✓      |

Post-Build Validation
---------------------
[✓] Artifacts exist
[✓] Sizes reasonable
[✓] No dev dependencies

Overall Status: [PASS/FAIL]

Next Steps
----------
[If passed: deployment options]
[If failed: issues to fix]
```

## Tips

- Use the build-deploy skill for detailed patterns
- Fix lint and type errors before proceeding
- Ensure tests pass before considering build valid
- Check artifact sizes for unexpected bloat
