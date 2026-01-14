---
name: create-pr
description: Create a pull request with auto-generated description
argument-hint: "[title]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# Create Pull Request Command

Create a comprehensive pull request with auto-generated description based on branch changes.

## Execution Steps

1. **Check branch status**:
   - Get current branch name
   - Identify base branch (main/master/develop)
   - Check if branch is pushed to remote

2. **Analyze branch changes**:
   - List all commits: `git log main..HEAD --oneline`
   - Get full diff: `git diff main...HEAD`
   - Identify files changed, insertions, deletions

3. **Generate PR title**:
   - If title argument provided, use it
   - Otherwise, derive from branch name or commits
   - Format: Clear, concise summary

4. **Generate PR description**:
   - Summary of changes
   - List of specific changes made
   - Testing performed
   - Any breaking changes
   - Related issues

5. **Push branch if needed**: Push to remote with upstream tracking.

6. **Create PR**: Use `gh pr create` with generated content.

7. **Report result**: Show PR URL and next steps.

## PR Description Template

```markdown
## Summary

Brief description of what this PR accomplishes.

## Changes

- Change 1: Description
- Change 2: Description
- Change 3: Description

## Testing

- [ ] Unit tests pass
- [ ] Manual testing completed
- [ ] [Other testing notes]

## Breaking Changes

[None / List any breaking changes]

## Related Issues

Closes #XXX
```

## Output Format

```
Create Pull Request
===================

Branch Analysis
---------------
Current Branch: feature/xyz
Base Branch: main
Commits: X
Files Changed: X

Changes Summary
---------------
[Brief summary of all changes]

Generated PR
------------
Title: [generated or provided title]

Description:
[Full PR description]

Creating PR...

Result
------
PR #XXX created successfully!
URL: https://github.com/owner/repo/pull/XXX

Next Steps
----------
- Add reviewers
- Link related issues
- Monitor CI checks
```

## Tips

- Use the git-workflows skill for PR best practices
- Keep PRs focused and small when possible
- Ensure all tests pass before creating PR
- Add appropriate labels and reviewers
