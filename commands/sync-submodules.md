---
name: sync-submodules
description: Sync and adapt skills, commands, agents, and hooks from all git submodules
---

# Sync Submodules Command

This command updates ltk components by learning from all git submodules.

## Process

### Step 1: Update All Submodules

```bash
git submodule update --remote --merge
```

### Step 2: Discover Components in All Submodules

For each submodule directory, scan for:

- `skills/` or `**/SKILL.md` files
- `commands/` or `commands/*.md` files
- `agents/` or `agents/*.md` files
- `hooks/` or `hooks.json` files

### Step 3: Analyze and Categorize

For each discovered component, determine:

1. **New** - Doesn't exist in ltk yet
2. **Updated** - Exists but submodule version is different/better
3. **Duplicate** - Same concept exists from multiple submodules
4. **Inferior** - ltk version is already better

### Step 4: Intelligent Adaptation

**DO NOT simply copy files.** Instead:

1. **For New Components:**
   - Adapt to ltk namespace and conventions
   - Update skill descriptions for CSO (Claude Search Optimization)
   - Ensure frontmatter follows ltk format
   - Place in appropriate category directory

2. **For Updates:**
   - Compare both versions
   - Merge improvements while keeping ltk customizations
   - Preserve any ltk-specific enhancements

3. **For Duplicates (same concept from multiple sources):**
   - Analyze ALL versions of the component
   - Create a SUPERIOR version that combines the best from each
   - Document the sources in a comment

4. **For Hooks:**
   - Merge hook configurations intelligently
   - Avoid duplicate event handlers
   - Combine scripts where appropriate

### Step 5: Quality Checks

Before finalizing any component:

- Ensure no duplicate skill names
- Verify all file paths are correct
- Check frontmatter is valid YAML
- Confirm descriptions are CSO-optimized

### Step 6: Report Changes

Output a summary:

```
## Sync Complete

### New Components Added:
- skill: component-name (from: submodule-name)

### Updated Components:
- skill: component-name (merged improvements from: submodule-name)

### Duplicates Resolved:
- skill: component-name (combined from: submodule1, submodule2)

### Skipped (ltk version superior):
- skill: component-name
```

## Adaptation Guidelines

### Skill Descriptions (CSO)

Transform generic descriptions into specific trigger phrases:

```yaml
# Bad
description: Helps with testing

# Good
description: Use when writing tests, doing TDD, need test coverage, or asking about "pytest", "jest", "unit tests", "integration tests"
```

### Namespace Conventions

- Skills go in `skills/{category}/{name}/SKILL.md`
- Categories: core, python, javascript, design, devops, data
- Commands go in `commands/{name}.md`
- Agents go in `agents/{name}.md`

### Deduplication Rules

When the same concept exists in multiple submodules:

1. Compare completeness (more comprehensive wins)
2. Compare clarity (clearer instructions win)
3. Compare specificity (more actionable wins)
4. Merge unique insights from all versions
5. Credit all sources

## Invoke the Skill

After reading this command, invoke the `ltk:syncing-submodules` skill for detailed adaptation instructions.
