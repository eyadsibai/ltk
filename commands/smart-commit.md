---
name: smart-commit
description: Create an intelligent git commit with analysis of changes
argument-hint: "[message]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# Smart Commit Command

Create a well-crafted git commit by analyzing changes and generating a meaningful commit message.

## Execution Steps

1. **Check git status**: Run `git status` to see staged and unstaged changes.

2. **Analyze staged changes**: If changes are staged, analyze them:
   - Run `git diff --staged` to see what will be committed
   - Identify the type of change (feature, fix, refactor, etc.)
   - Determine scope (affected components)

3. **If no staged changes**: Prompt to stage changes or offer to stage all.

4. **Pre-commit checks** (optional but recommended):
   - Quick security scan for secrets
   - Basic lint check
   - Type hint validation on changed files

5. **Generate commit message**:
   - If message argument provided, use it as base
   - Otherwise, generate from analysis
   - Format: `type(scope): subject`
   - Add body with details if significant changes

6. **Create commit**: Execute the commit with the message.

7. **Post-commit**: Show commit summary and next steps.

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

## Output Format

```
Smart Commit
============

Changes Analysis
----------------
Files changed: X
Insertions: +X
Deletions: -X

Change Type: [feat/fix/refactor/etc.]
Scope: [component/module affected]

Pre-commit Checks
-----------------
[✓] No secrets detected
[✓] Lint check passed
[✓] Type hints valid

Generated Commit Message
------------------------
type(scope): subject line

Detailed description of what changed and why.

- Bullet point 1
- Bullet point 2

Proceed with commit? [Committing...]

Commit Result
-------------
[commit hash] type(scope): subject

Next Steps
----------
- Push with: git push
- Create PR with: /mytoolkit:create-pr
```

## Tips

- Use the git-workflows skill for commit best practices
- Keep commits atomic (one logical change per commit)
- Reference issue numbers in footer when applicable
- If pre-commit checks fail, address issues before committing
