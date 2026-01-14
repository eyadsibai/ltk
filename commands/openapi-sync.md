---
name: openapi-sync
description: Update and synchronize OpenAPI specification with API implementation
argument-hint: "[openapi-file]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
---

# OpenAPI Sync Command

Update, synchronize, and validate the OpenAPI specification against the actual REST API implementation.

## Execution Steps

### 1. Discover API Implementation

Scan the codebase for API definitions:

```bash
# Find route definitions
grep -r "router\." --include="*.go" --include="*.py" --include="*.ts" .
grep -r "@app\." --include="*.py" .
grep -r "app\.(get|post|put|delete)" --include="*.ts" --include="*.js" .
```

### 2. Analyze Current OpenAPI Spec

Read the existing spec (default: `openapi.yml` or `openapi.yaml`):

- Document existing paths and operations
- Identify defined schemas and components
- Note authentication requirements

### 3. Compare Implementation vs Spec

For each discovered endpoint:

- Check if path exists in OpenAPI spec
- Verify HTTP methods match
- Compare request/response schemas
- Validate parameter definitions

### 4. Generate Updates

For missing or outdated entries:

- Add new paths for undocumented endpoints
- Update schemas to match DTOs/models
- Add missing error responses
- Include proper authentication requirements

### 5. Schema Synchronization

Map code types to OpenAPI:

| Language Type | OpenAPI Type |
|--------------|--------------|
| string | string |
| int/int64 | integer (format: int64) |
| float/double | number |
| bool | boolean |
| array/slice | array |
| struct/class | object |
| optional | nullable: true |

### 6. Validation

After updates, validate the spec:

```bash
# Using spectral
spectral lint openapi.yml

# Using swagger-cli
swagger-cli validate openapi.yml
```

## Output Format

```
OpenAPI Sync Report
===================

Spec File: openapi.yml
Version: 3.0.3

API Discovery
-------------
Endpoints found in code: X
Endpoints in spec: Y
Coverage: Z%

Changes Made
------------
Added:
  - POST /api/users (CreateUser operation)
  - GET /api/users/{id}/profile

Updated:
  - PUT /api/users/{id} (added email field to request)
  - Response schema for GET /api/orders

Schemas Added:
  - UserProfile
  - OrderResponse

Validation
----------
[✓] Valid OpenAPI 3.0 specification
[✓] All $ref references resolve
[✓] Required fields documented

Recommendations
---------------
- Add description for UserProfile schema
- Document rate limits on /api/auth endpoints
```

## Best Practices

- Use `$ref` for reusable schemas (DRY)
- Group endpoints with tags
- Include realistic examples
- Document all error responses
- Add operation IDs matching handler names
- Bump version number when making changes
