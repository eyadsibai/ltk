---
name: changelog-generator
description: Use when creating "changelog", "release notes", "version updates", generating "CHANGELOG.md", or asking about "git history to changelog", "commit summary", "what changed since last release"
version: 1.0.0
---

<!-- Adapted from: awesome-claude-skills/changelog-generator -->

# Changelog Generator

Transform technical git commits into polished, user-friendly changelogs.

## When to Use

- Preparing release notes for a new version
- Creating weekly or monthly product update summaries
- Documenting changes for customers
- Writing changelog entries for app store submissions
- Generating update notifications
- Maintaining a public changelog/product updates page

## Process

### 1. Scan Git History

Analyze commits from a specific time period or between versions:

```bash
# Since last tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Between dates
git log --since="2024-01-01" --until="2024-01-31" --oneline

# Between versions
git log v1.0.0..v2.0.0 --oneline
```

### 2. Categorize Changes

Group commits into logical categories:

| Category | Emoji | Includes |
|----------|-------|----------|
| New Features | ✨ | New functionality, capabilities |
| Improvements | 🔧 | Enhancements, optimizations |
| Bug Fixes | 🐛 | Resolved issues, corrections |
| Breaking Changes | ⚠️ | API changes, migrations needed |
| Security | 🔒 | Security patches, vulnerability fixes |
| Documentation | 📚 | Docs updates (usually excluded) |
| Internal | 🔨 | Refactoring, tests (usually excluded) |

### 3. Translate Technical → User-Friendly

**Bad (developer-speak):**

```
fix: resolve null pointer in UserService#getById
refactor: extract common logic to BaseRepository
```

**Good (user-friendly):**

```
- Fixed an issue where user profiles wouldn't load
- Improved application performance and reliability
```

### 4. Format Output

```markdown
# Updates - Week of March 10, 2024

## ✨ New Features

- **Team Workspaces**: Create separate workspaces for different
  projects. Invite team members and keep everything organized.

## 🔧 Improvements

- **Faster Sync**: Files now sync 2x faster across devices
- **Better Search**: Search now includes file contents, not just titles

## 🐛 Fixes

- Fixed issue where large images wouldn't upload
- Resolved timezone confusion in scheduled posts
```

## Filter Rules

**Include:**

- Features (feat:, feature:)
- Fixes (fix:, bugfix:)
- Performance (perf:)
- Security (security:)

**Exclude:**

- Refactoring (refactor:)
- Tests (test:)
- CI/CD (ci:, build:)
- Chores (chore:)
- WIP commits

## Usage Examples

```
Create a changelog from commits since last release
```

```
Generate changelog for all commits from the past week
```

```
Create release notes for version 2.5.0 based on commits since v2.4.0
```

## Tips

- Run from your git repository root
- Specify date ranges for focused changelogs
- Review and adjust before publishing
- Keep customer perspective - "what does this mean for them?"
- Save output directly to CHANGELOG.md
