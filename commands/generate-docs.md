---
name: generate-docs
description: Generate documentation for the codebase
argument-hint: "[type] [path]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Edit
  - TodoWrite
---

# Generate Documentation Command

Generate comprehensive documentation including docstrings, API docs, and markdown guides.

## Arguments

- **type**: Type of documentation to generate
  - `docstrings`: Add/update Python docstrings
  - `api`: Generate API documentation
  - `readme`: Update README
  - `all`: Generate all documentation
- **path**: Specific path to document (optional)

## Execution Steps

1. **Determine scope**:
   - If path provided, focus on that path
   - If type specified, generate that type only
   - Default: Analyze and suggest what needs documentation

2. **For docstrings**:
   - Find functions/classes without docstrings
   - Analyze function signatures and behavior
   - Generate Google-style docstrings
   - Include Args, Returns, Raises, Examples

3. **For API documentation**:
   - Identify API endpoints
   - Document request/response schemas
   - Generate OpenAPI spec if applicable
   - Create API reference markdown

4. **For README**:
   - Analyze project structure
   - Update installation instructions
   - Refresh usage examples
   - Update configuration reference

5. **For diagrams**:
   - Generate architecture diagrams (Mermaid)
   - Create sequence diagrams for key flows
   - Document data models with ER diagrams

6. **Write documentation**: Create or update doc files.

## Output Format

```
Documentation Generation
========================

Scope: [path/type]

Analysis
--------
Functions without docstrings: X
Classes without docstrings: X
API endpoints undocumented: X
README sections outdated: X

Generated Documentation
-----------------------

Docstrings Added: X
Files: [list of files updated]

API Documentation:
- docs/api/endpoints.md
- docs/api/schemas.md
- openapi.yaml

README Updates:
- Installation section refreshed
- Usage examples updated
- Configuration table added

Diagrams Created:
- docs/architecture.md (Mermaid diagram)
- docs/sequence-auth.md (Auth flow)

Summary
-------
Documentation coverage: X% -> Y%
Files updated: X
New files created: X

Next Steps
----------
- Review generated docstrings for accuracy
- Verify API documentation completeness
- Consider adding more examples
```

## Docstring Format (Google Style)

```python
def function_name(param1: type, param2: type) -> ReturnType:
    """Short description of function.

    Longer description if needed, explaining the purpose
    and behavior of the function.

    Args:
        param1: Description of param1.
        param2: Description of param2.

    Returns:
        Description of return value.

    Raises:
        ErrorType: When this error occurs.

    Example:
        >>> result = function_name(value1, value2)
        >>> print(result)
        expected_output
    """
```

## Tips

- Use the documentation skill for detailed patterns
- Review generated docstrings for accuracy
- Keep docstrings concise but complete
- Include examples for complex functions
