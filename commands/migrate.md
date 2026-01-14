---
name: migrate
description: Code migration assistance for version upgrades and pattern changes
argument-hint: "<migration-type> [options]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Edit
  - TodoWrite
---

# Migrate Command

Assist with code migrations between versions, patterns, or technologies.

## Arguments

- **migration-type**: Type of migration
  - `python2to3`: Python 2 to Python 3
  - `sync-to-async`: Synchronous to asynchronous code
  - `orm`: Database ORM migrations
  - `api`: API version upgrades
  - `framework`: Framework migrations
  - `custom`: Custom migration with prompts

## Execution Steps

1. **Analyze current state**:
   - Identify code patterns to migrate
   - Count occurrences
   - Assess migration complexity
   - Identify dependencies affected

2. **Plan migration**:
   - Create migration roadmap
   - Identify phases
   - Plan compatibility layers if needed
   - Estimate effort

3. **Execute migration**:
   - Migrate in phases
   - Maintain backwards compatibility where needed
   - Update tests along the way

4. **Verification**:
   - Run full test suite
   - Check for deprecated usage
   - Verify functionality
   - Performance validation

5. **Cleanup**:
   - Remove compatibility layers
   - Delete deprecated code
   - Update documentation

## Migration Types

### Python 2 to 3

```
/ltk:migrate python2to3
```

- Print statements to functions
- Division behavior
- Unicode handling
- Iterator changes
- Library updates

### Sync to Async

```
/mytoolkit:migrate sync-to-async [module]
```

- Convert functions to async def
- Update calls to use await
- Replace requests with aiohttp
- Update database calls

### ORM Migrations

```
/mytoolkit:migrate orm
```

- Generate migration files
- Analyze schema changes
- Apply migrations safely
- Handle data migrations

### API Version Upgrade

```
/mytoolkit:migrate api v1 v2
```

- Identify API changes
- Update endpoint calls
- Handle response changes
- Update error handling

## Output Format

```
Migration: [type]
=================

Analysis
--------
Files to migrate: X
Patterns to change: X
Estimated changes: X

Migration Plan
--------------
Phase 1: [description]
  - [file1]: [changes]
  - [file2]: [changes]

Phase 2: [description]
  - [file3]: [changes]

Compatibility Notes
-------------------
- [Note about backwards compatibility]
- [Breaking change warning]

Executing Migration
-------------------

Phase 1: [In Progress]
[✓] file1.py migrated
[✓] file2.py migrated

Phase 2: [In Progress]
[✓] file3.py migrated

Verification
------------
[✓] Tests pass
[✓] No deprecated warnings
[✓] Functionality verified

Migration Summary
-----------------
Files migrated: X
Patterns updated: X
Tests updated: X

Remaining Tasks
---------------
- [ ] Update documentation
- [ ] Remove compatibility layers
- [ ] Update deployment configs

Next Steps
----------
1. Review migrated code
2. Run integration tests
3. Deploy to staging for validation
```

## Tips

- Use the refactoring skill for safe code changes
- Migrate in small, testable phases
- Maintain compatibility layers during transition
- Update documentation alongside code changes
