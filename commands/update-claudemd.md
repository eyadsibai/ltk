---
name: update-claudemd
description: Automatically update CLAUDE.md based on recent code changes
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
---

# Update CLAUDE.md

Automatically maintain CLAUDE.md to reflect the current state of the codebase.

## Purpose

CLAUDE.md is the AI's guide to the codebase. When code changes, the documentation should too.

## Process

### Step 1: Analyze Recent Changes

```bash
# Get recent commits
git log --oneline -20

# See what files changed recently
git diff --stat HEAD~10

# Get detailed changes
git diff HEAD~10 --name-status
```

### Step 2: Identify Documentation Impact

Look for changes that affect CLAUDE.md:

| Change Type | Documentation Update Needed |
|-------------|----------------------------|
| New files/directories | Update project structure |
| New dependencies | Update setup instructions |
| API changes | Update API documentation |
| Configuration changes | Update configuration section |
| New commands/scripts | Update available commands |
| Architecture changes | Update architecture overview |

### Step 3: Read Current CLAUDE.md

```bash
# Read the current file
cat CLAUDE.md
```

### Step 4: Update Relevant Sections

Common sections to update:

```markdown
## Project Structure
[Update if new directories or major files added]

## Setup
[Update if new dependencies or setup steps]

## Common Commands
[Update if new scripts or commands available]

## Architecture
[Update if architectural changes made]

## API Reference
[Update if API endpoints changed]

## Configuration
[Update if new config options added]
```

### Step 5: Validate Updates

Ensure updated CLAUDE.md:

- [ ] Reflects current project structure
- [ ] Has accurate setup instructions
- [ ] Lists available commands correctly
- [ ] Describes architecture accurately
- [ ] Is consistent in style and formatting

## What to Update

### Always Update

- New top-level directories
- Changed project dependencies
- New environment variables
- Changed build/run commands
- New important files

### Consider Updating

- Significant new patterns/conventions
- Major refactors
- New integrations
- Performance considerations

### Don't Update

- Minor code changes
- Bug fixes (unless they change usage)
- Internal implementation details
- Temporary/experimental code

## Update Guidelines

### Keep It Concise

CLAUDE.md is for orientation, not comprehensive documentation.

```markdown
# Good
## API
- POST /api/users - Create user
- GET /api/users/:id - Get user

# Bad (too detailed)
## API
### POST /api/users
Creates a new user in the system. The request body should contain...
[500 words of documentation]
```

### Be Accurate

Outdated documentation is worse than no documentation.

```markdown
# Good - Always verify
## Setup
npm install  # Verify this is correct
npm run dev  # Verify this still works

# Bad - Copy-paste without checking
## Setup
pip install -r requirements.txt  # File doesn't exist!
```

### Stay Consistent

Match the existing style:

- Same header levels
- Same formatting conventions
- Same level of detail

## Output

After updating, show:

```markdown
## CLAUDE.md Update Summary

### Sections Updated
- [Section name]: [What changed]

### Changes Made
```diff
- Old content
+ New content
```

### Verification

- [ ] Tested setup instructions work
- [ ] Verified commands are accurate
- [ ] Checked links still valid

```
