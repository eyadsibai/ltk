---
name: syncing-submodules
description: Use when running /ltk:sync-submodules, updating submodules, or needing to "sync", "merge", "adapt", "learn from" other Claude Code plugins or repos
version: 1.0.0
---

# Syncing Submodules Skill

This skill guides you through intelligently syncing ltk components from multiple git submodules.

## Core Philosophy

**ltk should be the BEST version** - not a copy of any single source, but a superior synthesis of all sources. When multiple submodules have the same concept, create something better than any individual version.

## Complete Sync Workflow

### Phase 1: Discovery

```bash
# Update all submodules first
git submodule update --remote --merge

# List all submodules
git submodule foreach 'echo $name'
```

Scan each submodule for components:

| Pattern | Component Type |
|---------|---------------|
| `**/SKILL.md` | Skill |
| `skills/**/*.md` | Skill |
| `commands/*.md` | Command |
| `agents/*.md` | Agent |
| `hooks.json` or `hooks/*.json` | Hooks |
| `hooks/*.sh` | Hook scripts |

### Phase 2: Inventory Current ltk State

Before making changes, catalog what exists:

```bash
# List current skills
find skills -name "SKILL.md" | sort

# List current commands
ls commands/*.md

# List current agents
ls agents/*.md

# Current hooks
cat hooks/hooks.json
```

### Phase 3: Component Analysis

For each discovered component, create an analysis:

```
Component: {name}
Type: {skill|command|agent|hook}
Sources: {list of submodules containing this}
ltk Status: {new|exists|similar}
Action: {add|merge|skip|replace}
Rationale: {why this action}
```

### Phase 4: Intelligent Adaptation

#### For Skills

**DO NOT COPY VERBATIM.** Instead:

1. Read the source skill completely
2. Understand its PURPOSE and KEY INSIGHTS
3. Check if ltk has a similar skill (by function, not name)
4. If new: Create adapted version with:
   - CSO-optimized description
   - ltk namespace conventions
   - Improved clarity where possible
5. If exists: Compare and merge improvements

**CSO Description Formula:**

```yaml
description: Use when {primary trigger}, {secondary trigger}, or asking about "{keyword1}", "{keyword2}", "{keyword3}"
```

**Skill Placement:**

```
skills/
├── core/           # Language-agnostic workflows, patterns, meta-skills
├── python/         # Python-specific
├── javascript/     # JS/TS-specific
├── devops/         # CI/CD, Docker, K8s, cloud
├── data/           # Databases, data processing
└── design/         # UI/UX, accessibility
```

#### For Commands

Commands should:

- Have clear, action-oriented names
- Include proper frontmatter with `name`, `description`
- Reference skills they depend on
- Start with a markdown heading

#### For Agents

Agents should:

- Have specific `whenToUse` triggers
- List required tools
- Use valid colors: red, green, yellow, blue, magenta, cyan, white
- Start with a markdown heading

#### For Hooks

Merge hooks.json intelligently:

- Combine event handlers
- Avoid duplicate matchers for same event
- Prefer scripts over inline prompts for complex logic

### Phase 5: Deduplication Strategy

When the same concept exists in multiple places:

1. **Identify the canonical version** - which is most complete?
2. **Extract unique insights** from each version
3. **Create synthesized version** that includes:
   - Most comprehensive coverage
   - Clearest instructions
   - Best examples
   - All unique edge cases
4. **Add source attribution** as a comment:

   ```markdown
   <!-- Synthesized from: superpowers, other-plugin -->
   ```

### Phase 6: Quality Validation

Before committing, verify:

- [ ] No duplicate skill names across all categories
- [ ] All frontmatter is valid YAML
- [ ] All descriptions are CSO-optimized
- [ ] All files start with proper heading (MD041)
- [ ] No orphaned references to removed components
- [ ] Hooks.json is valid JSON

### Phase 7: Commit Strategy

Make atomic commits:

```bash
# One commit per logical change
git add skills/core/new-skill/
git commit -m "Add new-skill adapted from submodule-name"

# Or batch related changes
git add skills/core/
git commit -m "Sync core skills from submodules: added X, updated Y, merged Z"
```

## Handling Specific Scenarios

### Scenario: Same Skill, Different Names

Example: "verification" vs "validation" vs "checking-work"

1. Determine if they're truly the same concept
2. Pick the clearest name
3. Merge all content into one
4. Ensure description covers all trigger phrases from all versions

### Scenario: Conflicting Advice

Example: One says "always do X", another says "never do X"

1. Understand the CONTEXT for each piece of advice
2. Create nuanced guidance: "Do X when {context1}, avoid X when {context2}"
3. Add examples for both cases

### Scenario: Outdated Content

If a submodule has older/worse content than ltk:

1. Skip the sync for that component
2. Note in report: "Skipped: ltk version superior"
3. Optionally: contribute ltk improvements back upstream

## Output Format

After sync, provide this report:

```markdown
## Submodule Sync Report

**Submodules Processed:** {list}
**Timestamp:** {date}

### Components Added
| Type | Name | Source | Category |
|------|------|--------|----------|
| skill | name | submodule | core |

### Components Updated
| Type | Name | Changes | Source |
|------|------|---------|--------|
| skill | name | merged X improvements | submodule |

### Duplicates Resolved
| Name | Sources | Resolution |
|------|---------|------------|
| name | sub1, sub2 | synthesized best of both |

### Skipped
| Type | Name | Reason |
|------|------|--------|
| skill | name | ltk version superior |

### Action Items
- [ ] Review merged skill: X
- [ ] Test new command: Y
```

## Remember

- **Quality over quantity** - Don't add mediocre content
- **Synthesis over copying** - Create something better
- **ltk conventions always win** - Adapt sources to match ltk, not vice versa
- **CSO is critical** - Bad descriptions mean skills never get used
