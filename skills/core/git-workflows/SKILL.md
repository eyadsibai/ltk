---
name: Git Workflows
description: This skill should be used when the user asks to "create a commit", "write commit message", "create a pull request", "generate changelog", "manage branches", "git workflow", "merge strategy", "PR description", or mentions git operations and version control workflows.
version: 1.0.0
---

# Git Workflows

Comprehensive git workflow skill for commits, pull requests, branching, and changelog generation.

---

## Commit Message Format

### Conventional Commits

| Part | Purpose | Example |
|------|---------|---------|
| **Type** | Category of change | `feat`, `fix`, `docs` |
| **Scope** | Affected component | `(auth)`, `(api)` |
| **Subject** | Brief description | `add OAuth2 login` |
| **Body** | Details (optional) | Why + what changed |
| **Footer** | References | `Closes #123` |

### Commit Types

| Type | When to Use |
|------|-------------|
| **feat** | New feature |
| **fix** | Bug fix |
| **docs** | Documentation only |
| **style** | Formatting (no code change) |
| **refactor** | Code restructuring |
| **test** | Adding/updating tests |
| **chore** | Maintenance, deps |
| **perf** | Performance improvement |

### Commit Analysis Workflow

1. Run `git diff --staged` to see changes
2. Identify change type (feat, fix, etc.)
3. Determine scope (affected component)
4. Write concise subject (< 50 chars)
5. Add body if context needed

---

## Pull Request Structure

### PR Template Elements

| Section | Content |
|---------|---------|
| **Summary** | What this PR does (1-2 sentences) |
| **Changes** | Bullet list of specific changes |
| **Testing** | How changes were tested |
| **Screenshots** | If UI changes |
| **Checklist** | Tests pass, docs updated |

### PR Analysis Workflow

1. List commits: `git log main..HEAD --oneline`
2. Identify themes across commits
3. Note any breaking changes
4. Check test coverage
5. Review documentation needs

---

## Branch Strategies

### Git Flow

| Branch | Purpose |
|--------|---------|
| **main** | Production code |
| **develop** | Integration branch |
| **feature/** | New features |
| **release/** | Release preparation |
| **hotfix/** | Production fixes |

### GitHub Flow

| Branch | Purpose |
|--------|---------|
| **main** | Always deployable |
| **feature branches** | Short-lived work |

### Trunk-Based

| Branch | Purpose |
|--------|---------|
| **main** | All development |
| **Short branches** | < 1 day |
| **Feature flags** | Incomplete work |

### Branch Naming

| Pattern | Example |
|---------|---------|
| Feature | `feature/ABC-123-add-user-auth` |
| Bugfix | `bugfix/ABC-456-fix-login` |
| Hotfix | `hotfix/critical-security-patch` |
| Release | `release/v1.2.0` |

---

## Changelog Format

### Keep a Changelog Structure

| Section | Content |
|---------|---------|
| **Added** | New features |
| **Changed** | Changes in existing functionality |
| **Deprecated** | Soon-to-be removed features |
| **Removed** | Removed features |
| **Fixed** | Bug fixes |
| **Security** | Security fixes |

### Changelog Generation Workflow

1. Get commits since last release tag
2. Parse commit messages for type/scope
3. Group by category (Added, Fixed, etc.)
4. Format with links to issues/PRs

---

## Best Practices

### Commits

| Practice | Why |
|----------|-----|
| Atomic commits | One logical change per commit |
| Clear messages | Explain why, not just what |
| Reference issues | Link to related tickets |
| Sign commits | GPG verification |

### Pull Requests

| Practice | Why |
|----------|-----|
| Small PRs | < 400 lines ideal for review |
| Clear title | Summarize the change |
| Self-review first | Check diff before requesting |
| Respond promptly | Address feedback quickly |

### Branches

| Practice | Why |
|----------|-----|
| Short-lived | Merge within days |
| Up to date | Rebase regularly |
| Clean history | Squash before merge |
| Delete after merge | Keep repo clean |

---

## Merge Strategies

| Strategy | When to Use | Result |
|----------|-------------|--------|
| **Merge commit** | Preserve history | Merge commit node |
| **Squash** | Clean up messy history | Single commit |
| **Rebase** | Linear history | No merge commit |
| **Fast-forward** | Simple, linear | No merge commit |

**Key concept**: Squash for feature branches with messy commits. Rebase for clean linear history. Merge commit when branch history matters.

---

## Common Git Commands

### Pre-Commit

| Command | Purpose |
|---------|---------|
| `git status` | See staged/unstaged changes |
| `git diff --staged` | Review what will be committed |
| `git add -p` | Interactive staging |

### Commit

| Command | Purpose |
|---------|---------|
| `git commit -m "msg"` | Commit with message |
| `git commit --amend` | Fix last commit (before push) |

### Branch Management

| Command | Purpose |
|---------|---------|
| `git branch -d name` | Delete merged branch |
| `git fetch --prune` | Remove stale remotes |
| `git rebase main` | Update branch with main |

### PR Workflow

| Command | Purpose |
|---------|---------|
| `git push -u origin branch` | Push and set upstream |
| `gh pr create` | Create PR via CLI |
| `gh pr merge` | Merge PR via CLI |

## Resources

- Conventional Commits: <https://www.conventionalcommits.org/>
- Keep a Changelog: <https://keepachangelog.com/>
- Git Book: <https://git-scm.com/book>
