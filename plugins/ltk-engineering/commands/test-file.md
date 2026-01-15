---
name: ltk:test-file
description: Generate comprehensive unit tests for a specific file with edge cases and error scenarios
argument-hint: "[path to file to test]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - Task
---

# Generate Tests for File

Create comprehensive unit tests for a specific file following project conventions.

## Target File

<target_file> #$ARGUMENTS </target_file>

**If empty, ask:** "Which file would you like me to generate tests for? Provide the file path."

## Process

### Step 1: Analyze the File

Read and understand:

- Functions/methods and their signatures
- Input types and expected outputs
- Side effects and dependencies
- Error conditions and edge cases

### Step 2: Identify Test Cases

For each function, identify:

| Category | Test Cases |
|----------|------------|
| Happy path | Normal inputs, expected outputs |
| Edge cases | Empty inputs, boundaries, nulls |
| Error cases | Invalid inputs, exceptions |
| Integration | Dependencies, side effects |

### Step 3: Determine Testing Framework

```python
# Python
# Check for existing test patterns
pytest  # Most common
unittest  # Standard library
```

```typescript
// TypeScript/JavaScript
// Check for existing test patterns
jest  // Most common
vitest  // Vite projects
mocha  # Older projects
```

### Step 4: Generate Tests

Follow existing test patterns in the project:

```bash
# Find existing tests to match style
find . -name "*_test.py" -o -name "*.test.ts" | head -5
```

## Test Structure Template

### Python (pytest)

```python
import pytest
from module import function_to_test

class TestFunctionName:
    """Tests for function_name."""

    def test_happy_path(self):
        """Test normal operation."""
        result = function_to_test(valid_input)
        assert result == expected_output

    def test_empty_input(self):
        """Test with empty input."""
        result = function_to_test([])
        assert result == []

    def test_invalid_input_raises(self):
        """Test that invalid input raises ValueError."""
        with pytest.raises(ValueError, match="expected message"):
            function_to_test(invalid_input)

    @pytest.mark.parametrize("input,expected", [
        (1, 1),
        (2, 4),
        (3, 9),
    ])
    def test_multiple_cases(self, input, expected):
        """Test multiple input/output combinations."""
        assert function_to_test(input) == expected
```

### TypeScript (Jest)

```typescript
import { functionToTest } from "./module";

describe("functionToTest", () => {
  describe("happy path", () => {
    it("should return expected result for valid input", () => {
      expect(functionToTest(validInput)).toBe(expectedOutput);
    });
  });

  describe("edge cases", () => {
    it("should handle empty input", () => {
      expect(functionToTest([])).toEqual([]);
    });

    it("should handle null", () => {
      expect(functionToTest(null)).toBeNull();
    });
  });

  describe("error cases", () => {
    it("should throw for invalid input", () => {
      expect(() => functionToTest(invalidInput)).toThrow("expected message");
    });
  });
});
```

## Test Coverage Goals

| Coverage Type | Target | Priority |
|--------------|--------|----------|
| Line coverage | >80% | High |
| Branch coverage | >70% | High |
| Function coverage | 100% | Medium |
| Edge cases | All identified | High |
| Error paths | All error types | High |

## Test Quality Checklist

- [ ] **Descriptive names** - Test names explain what is tested
- [ ] **Single assertion focus** - Each test verifies one thing
- [ ] **Independent tests** - Tests don't depend on each other
- [ ] **No test logic** - Avoid conditionals in tests
- [ ] **Clear arrange/act/assert** - Structure is obvious
- [ ] **Meaningful assertions** - Not just `assert True`
- [ ] **Error messages helpful** - Failures are easy to debug

## Output

After generating tests:

```markdown
## Test Generation Summary

**File tested:** `path/to/file.py`
**Test file created:** `tests/test_file.py`

### Tests Generated
| Function | Tests | Coverage |
|----------|-------|----------|
| function_a | 5 | Happy path, edge cases, errors |
| function_b | 3 | Happy path, edge cases |

### Run Tests
```bash
pytest tests/test_file.py -v
```

### Coverage Report

```bash
pytest tests/test_file.py --cov=module --cov-report=term-missing
```

```

## Best Practices

### DO

- Test behavior, not implementation
- Use descriptive test names
- Keep tests simple and readable
- Test edge cases thoroughly
- Mock external dependencies

### DON'T

- Test private methods directly
- Write tests that are flaky
- Over-mock (test nothing real)
- Write overly complex test setup
- Skip error case testing
