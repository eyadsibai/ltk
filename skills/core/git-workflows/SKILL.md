---
name: Git Workflows
description: This skill should be used when the user asks to "create a commit", "write commit message", "create a pull request", "generate changelog", "manage branches", "git workflow", "merge strategy", "PR description", or mentions git operations and version control workflows.
version: 1.0.0
---

# Git Workflows

Comprehensive git workflow skill for commits, pull requests, branching, and changelog generation.

## Core Capabilities

### Smart Commit Messages

Generate meaningful commit messages from changes:

**Commit Message Format:**

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting (no code change)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

**Analysis workflow:**

1. Run `git diff --staged` to see changes
2. Identify the type of change
3. Determine scope (affected component)
4. Write concise subject (< 50 chars)
5. Add body with details if needed

**Good commit examples:**

```
feat(auth): add OAuth2 login support

Implement OAuth2 authentication flow with Google and GitHub providers.
Includes token refresh and session management.

Closes #123

---

fix(api): handle null response from payment gateway

Add null check before accessing response.data to prevent
TypeError when gateway returns empty response.

Fixes #456
```

### Pull Request Creation

Generate comprehensive PR descriptions:

**PR Template:**

```markdown
## Summary

Brief description of what this PR does.

## Changes

- Change 1
- Change 2
- Change 3

## Testing

How the changes were tested.

## Screenshots (if applicable)

## Checklist

- [ ] Tests pass
- [ ] Documentation updated
- [ ] No breaking changes
```

**PR workflow:**

1. Analyze commits in branch
2. Summarize overall change purpose
3. List specific changes made
4. Note testing performed
5. Add relevant labels/reviewers

### Branch Management

Organize and manage branches effectively:

**Branch naming:**

```
feature/ABC-123-add-user-auth
bugfix/ABC-456-fix-login-error
hotfix/critical-security-patch
release/v1.2.0
```

**Branch strategies:**

**Git Flow:**

- main: Production code
- develop: Integration branch
- feature/*: New features
- release/*: Release preparation
- hotfix/*: Production fixes

**GitHub Flow:**

- main: Always deployable
- feature branches: Short-lived

**Trunk-Based:**

- main: All development
- Short feature branches (< 1 day)
- Feature flags for WIP

### Changelog Generation

Create changelogs from commit history:

**Changelog format:**

```markdown
# Changelog

## [1.2.0] - 2024-01-15

### Added
- OAuth2 authentication (#123)
- User profile page (#124)

### Fixed
- Payment gateway null response (#456)
- Session timeout issue (#457)

### Changed
- Updated API rate limits
- Improved error messages

### Deprecated
- Legacy auth endpoint (use /v2/auth)

### Removed
- Unused analytics module

### Security
- Fixed XSS vulnerability in comments
```

**Generation workflow:**

1. Get commits since last release tag
2. Parse commit messages for type/scope
3. Group by category (Added, Fixed, etc.)
4. Format with links to issues/PRs

## Workflow Commands

### Pre-Commit Workflow

Before committing:

```bash
# Check what will be committed
git status
git diff --staged

# Verify tests pass
pytest

# Run linting
black --check .
flake8 .
```

### Commit Workflow

```bash
# Stage changes
git add -p  # Interactive staging

# Create commit with message
git commit -m "type(scope): subject"

# Or open editor for longer message
git commit
```

### PR Workflow

```bash
# Ensure branch is up to date
git fetch origin
git rebase origin/main

# Push branch
git push -u origin feature/branch-name

# Create PR (using gh CLI)
gh pr create --title "Title" --body "Description"
```

## Analysis Patterns

### Analyzing Changes for Commit

To determine appropriate commit message:

1. **Identify modified files**: What areas changed?
2. **Categorize change type**: Feature, fix, refactor?
3. **Assess scope**: Which component affected?
4. **Summarize impact**: What does this enable/fix?

### Analyzing Branch for PR

To generate PR description:

1. **List commits**: `git log main..HEAD --oneline`
2. **Identify themes**: Group related changes
3. **Note breaking changes**: Any API changes?
4. **Check test coverage**: New tests added?
5. **Review documentation**: Updates needed?

## Best Practices

### Commit Guidelines

- **Atomic commits**: One logical change per commit
- **Clear messages**: Explain why, not just what
- **Reference issues**: Link to related tickets
- **Sign commits**: Use GPG signing for verification

### PR Guidelines

- **Small PRs**: Easier to review (< 400 lines ideal)
- **Clear title**: Summarize the change
- **Description**: Explain context and decisions
- **Self-review**: Check diff before requesting review
- **Respond promptly**: Address feedback quickly

### Branch Guidelines

- **Short-lived**: Merge within days, not weeks
- **Up to date**: Rebase regularly against main
- **Clean history**: Squash or rebase before merge
- **Delete after merge**: Keep repo clean

## Git Configuration

**Recommended global config:**

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
git config --global pull.rebase true
git config --global fetch.prune true
git config --global init.defaultBranch main
```

**Commit template:**

```bash
# .gitmessage
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>

git config --global commit.template ~/.gitmessage
```

## Integration

Coordinate with other skills:

- **security-scanning skill**: Check for secrets before commit
- **code-quality skill**: Ensure quality before commit
- **documentation skill**: Update docs with changes
