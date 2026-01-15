---
name: ltk:sync-submodules
description: Intelligently sync and deduplicate skills, commands, agents, and hooks from all git submodules
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

# Intelligent Submodule Sync Command

This command performs deep analysis of all submodules and intelligently syncs components while avoiding duplicates and maintaining quality.

## Execution Steps

### Step 1: Update Submodules

```bash
git submodule update --remote --merge
```

### Step 2: Create Current Inventory

Before syncing, create a complete inventory of existing ltk components:

```bash
# Current skills with descriptions
for skill in plugins/*/skills/*/SKILL.md plugins/*/skills/*/*/SKILL.md; do
  echo "=== $skill ==="
  head -10 "$skill" | grep -E "^(name|description):"
done

# Current agents
for agent in plugins/*/agents/*.md; do
  echo "=== $agent ==="
  head -15 "$agent" | grep -E "^(agent|description):"
done

# Current commands
for cmd in plugins/*/commands/*.md; do
  echo "=== $cmd ==="
  head -5 "$cmd" | grep -E "^(name|description):"
done
```

### Step 3: Discover Submodule Components

Scan each submodule and extract component metadata:

```bash
for submodule in submodules/*/; do
  echo "=== Scanning: $submodule ==="

  # Skills
  find "$submodule" -name "SKILL.md" 2>/dev/null

  # Agents
  find "$submodule" -path "*/agents/*.md" 2>/dev/null

  # Commands
  find "$submodule" -path "*/commands/*.md" 2>/dev/null

  # Hooks
  find "$submodule" -name "hooks.json" 2>/dev/null
done
```

### Step 4: Deep Analysis (CRITICAL)

For EACH discovered component, perform this analysis:

#### 4.1 Extract Metadata

Read the component and extract:

- Name
- Description/Purpose
- Keywords (from content)
- Capabilities (what it does)
- Domain (core/engineering/data/devops/design/product/github)

#### 4.2 Similarity Check

Compare against ALL existing ltk components:

**Similarity Calculation:**

- Name similarity: 15%
- Keyword overlap: 25%
- Purpose overlap: 30%
- Capability overlap: 30%

**Thresholds:**

| Score | Action |
|-------|--------|
| 90-100% | DUPLICATE - Keep better one |
| 70-89% | NEAR-DUPLICATE - Must merge |
| 50-69% | RELATED - Consider consolidation |
| 30-49% | TANGENTIAL - Keep separate |
| 0-29% | DISTINCT - Add if quality >= 60 |

#### 4.3 Quality Scoring

Score each component 0-100:

| Criterion | Weight |
|-----------|--------|
| Completeness | 20% |
| Clarity | 20% |
| Actionability | 15% |
| Examples | 15% |
| Edge Cases | 10% |
| Formatting | 10% |
| CSO Optimization | 10% |

**Quality Thresholds:**

- 80-100: Add as-is
- 60-79: Add with improvements
- 40-59: Only if fills gap
- 0-39: Reject

### Step 5: Decision Matrix

Create a decision for each component:

```markdown
| Component | Source | Similarity | Quality | Decision | Rationale |
|-----------|--------|------------|---------|----------|-----------|
| skill-x | sub1 | 15% (new) | 85 | ADD | High quality, fills gap |
| agent-y | sub2 | 92% to agent-z | 70 | SKIP | Duplicate, ltk version better |
| skill-a | sub3 | 78% to skill-b | 80 | MERGE | Combine unique features |
| cmd-c | sub4 | 25% (new) | 45 | SKIP | Low quality |
```

### Step 6: Execute Decisions

#### For ADD decisions

1. Adapt to ltk conventions (frontmatter, naming)
2. Optimize description for CSO
3. Place in correct plugin/directory
4. Add source attribution

#### For MERGE decisions

1. Read both components fully
2. Identify unique sections in each
3. Create merged version with best of both
4. Add merge notes as HTML comment
5. Replace existing with merged version

#### For SKIP decisions

- Document why skipped in report

### Step 7: Post-Sync Deduplication Audit

After all changes, verify no duplicates:

```bash
# Check skill names
find plugins -name "SKILL.md" -exec dirname {} \; | xargs -I {} basename {} | sort | uniq -c | sort -rn

# Check agent names
find plugins/*/agents -name "*.md" | xargs -I {} basename {} .md | sort | uniq -c | sort -rn

# Check command names
find plugins/*/commands -name "*.md" | xargs -I {} basename {} .md | sort | uniq -c | sort -rn
```

If duplicates found, resolve immediately.

### Step 8: Generate Report

Output comprehensive report:

```markdown
# Submodule Sync Report - [DATE]

## Summary
- Submodules scanned: N
- Components discovered: N
- Added: N
- Merged: N
- Skipped (duplicate): N
- Skipped (quality): N

## Similarity Analysis

| New Component | Most Similar Existing | Similarity | Decision |
|---------------|----------------------|------------|----------|
| ... | ... | ...% | ... |

## Quality Analysis

| Component | Source | Score | Issues | Decision |
|-----------|--------|-------|--------|----------|
| ... | ... | ... | ... | ... |

## Changes Made

### Added
| Type | Name | Plugin | Source |
|------|------|--------|--------|

### Merged
| Result | Sources | Strategy |
|--------|---------|----------|

### Skipped
| Component | Source | Reason |
|-----------|--------|--------|

## Post-Sync Verification
- [ ] No duplicate skills
- [ ] No duplicate agents
- [ ] No duplicate commands
- [ ] All frontmatter valid
- [ ] All CSO descriptions optimized

## Recommendations
- [ ] Consider consolidating: X and Y
- [ ] Review merged: Z
```

## Important Rules

1. **NEVER copy without analysis** - Every component must be analyzed
2. **NEVER add duplicates** - Always check similarity first
3. **ALWAYS score quality** - Don't add mediocre content
4. **PREFER merging** - Enhance existing over adding similar
5. **DOCUMENT everything** - Report all decisions with rationale
6. **VERIFY after sync** - Run deduplication audit

## Invoke Skill

For detailed guidance on merge strategies and conflict resolution, the `syncing-submodules` skill will be loaded automatically.
