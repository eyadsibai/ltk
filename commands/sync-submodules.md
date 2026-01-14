---
name: sync-submodules
description: Sync and adapt skills, commands, agents, and hooks from all git submodules
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Edit
  - Task
  - TodoWrite
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
2. **Similar** - Same concept exists in ltk (ALWAYS compare for improvements)
3. **Duplicate** - Same concept exists from multiple submodules

**CRITICAL: Never simply skip similar components.** Always compare and identify potential improvements.

### Step 4: Intelligent Adaptation

**DO NOT simply copy files. DO NOT simply skip similar components.**

1. **For New Components:**
   - Adapt to ltk namespace and conventions
   - Update skill descriptions for CSO (Claude Search Optimization)
   - Ensure frontmatter follows ltk format
   - Place in appropriate category directory

2. **For Similar Components (MANDATORY COMPARISON):**
   - Read BOTH versions side-by-side
   - Identify unique features in each version
   - Create improvement checklist:
     - [ ] Better examples?
     - [ ] More comprehensive checklist?
     - [ ] Better workflow/process?
     - [ ] Additional edge cases handled?
     - [ ] Framework-specific expertise?
     - [ ] Better output format?
   - Merge ALL improvements into ltk version
   - Document what was learned from comparison

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

### Improved Components:
- agent: code-reviewer (added: security checklist from submodule-name)
- agent: test-analyzer (added: AAA pattern, framework expertise from submodule-name)
- command: smart-commit (added: emoji support, split analysis from submodule-name)

### Duplicates Resolved:
- skill: component-name (combined from: submodule1, submodule2)

### Comparison Notes:
- component-name: ltk version retained (reason: more comprehensive)
- component-name: submodule version had X, incorporated into ltk
```

**Note: There should be NO "Skipped" section. Every similar component must be compared and either improved or documented why ltk version is retained.**

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
