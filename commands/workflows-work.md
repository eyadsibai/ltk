---
name: workflows-work
description: Execute work plans efficiently while maintaining quality and finishing features
argument-hint: "[plan file, specification, or todo file path]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
  - TodoWrite
  - AskUserQuestion
---

# Work Plan Execution Command

Execute a work plan efficiently while maintaining quality and finishing features.

## Input Document

<input_document> #$ARGUMENTS </input_document>

## Execution Workflow

### Phase 1: Quick Start

#### 1. Read Plan and Clarify

- Read the work document completely
- Review any references or links provided
- If anything is unclear, ask clarifying questions NOW
- Get user approval to proceed
- **Do not skip this** - better to ask now than build the wrong thing

#### 2. Setup Environment

Choose your work style:

**Option A: Work on current branch**

```bash
git checkout main && git pull origin main
git checkout -b feature-branch-name
```

**Option B: Parallel work with worktree**

```bash
# Create isolated worktree for parallel development
git worktree add ../feature-worktree -b feature-branch-name
cd ../feature-worktree
```

**Use worktree if:**

- Working on multiple features simultaneously
- Want to keep main clean while experimenting
- Plan to switch between branches frequently

#### 3. Create Todo List

- Use TodoWrite to break plan into actionable tasks
- Include dependencies between tasks
- Prioritize based on what needs to be done first
- Include testing and quality check tasks

### Phase 2: Execute

#### 1. Task Execution Loop

```
while (tasks remain):
  - Mark task as in_progress in TodoWrite
  - Read any referenced files from the plan
  - Look for similar patterns in codebase
  - Implement following existing conventions
  - Write tests for new functionality
  - Run tests after changes
  - Mark task as completed
```

#### 2. Follow Existing Patterns

- The plan should reference similar code - read those files first
- Match naming conventions exactly
- Reuse existing components where possible
- Follow project coding standards (see CLAUDE.md)
- When in doubt, grep for similar implementations

#### 3. Test Continuously

- Run relevant tests after each significant change
- Don't wait until the end to test
- Fix failures immediately
- Add new tests for new functionality

#### 4. Track Progress

- Keep TodoWrite updated as you complete tasks
- Note any blockers or unexpected discoveries
- Create new tasks if scope expands
- Keep user informed of major milestones

### Phase 3: Quality Check

#### 1. Run Core Quality Checks

Always run before submitting:

```bash
# Run test suite (adjust for your project)
npm test        # JavaScript/TypeScript
pytest          # Python
go test ./...   # Go
bundle exec rspec  # Ruby

# Run linting
npm run lint    # or eslint, prettier
ruff check .    # Python
```

#### 2. Consider Reviewer Agents (For Complex Changes)

Use for large, risky, or complex changes:

- **code-simplicity-reviewer**: Check for unnecessary complexity
- **security-analyzer**: Scan for security vulnerabilities
- **architecture-analyzer**: Verify architectural fit

Run reviewers in parallel with Task tool when needed.

#### 3. Final Validation Checklist

- [ ] All TodoWrite tasks marked completed
- [ ] All tests pass
- [ ] Linting passes
- [ ] Code follows existing patterns
- [ ] No console errors or warnings
- [ ] Documentation updated if needed

### Phase 4: Ship It

#### 1. Create Commit

```bash
git add .
git status  # Review what's being committed
git diff --staged  # Check the changes

# Commit with conventional format
git commit -m "feat(scope): description of what and why"
```

#### 2. Create Pull Request

```bash
git push -u origin feature-branch-name

gh pr create --title "feat: [Description]" --body "$(cat <<'EOF'
## Summary
- What was built
- Why it was needed
- Key decisions made

## Testing
- Tests added/modified
- Manual testing performed

## Screenshots (if UI changes)
[Add before/after if applicable]
EOF
)"
```

#### 3. Notify User

- Summarize what was completed
- Link to PR
- Note any follow-up work needed

## Key Principles

### Start Fast, Execute Faster

- Get clarification once at the start, then execute
- Don't wait for perfect understanding - ask and move
- Goal is to **finish the feature**

### The Plan is Your Guide

- Work documents should reference similar code
- Load those references and follow them
- Don't reinvent - match what exists

### Test As You Go

- Run tests after each change, not at the end
- Fix failures immediately
- Continuous testing prevents big surprises

### Quality is Built In

- Follow existing patterns
- Write tests for new code
- Run linting before pushing

### Ship Complete Features

- Mark all tasks completed before moving on
- Don't leave features 80% done
- A finished feature that ships beats a perfect feature that doesn't

## Quality Checklist

Before creating PR, verify:

- [ ] All clarifying questions asked and answered
- [ ] All TodoWrite tasks marked completed
- [ ] Tests pass
- [ ] Linting passes
- [ ] Code follows existing patterns
- [ ] Commit messages follow conventional format
- [ ] PR description includes summary and testing notes

## When to Use Reviewer Agents

**Don't use by default.** Use only when:

- Large refactor affecting many files (10+)
- Security-sensitive changes
- Performance-critical code paths
- Complex algorithms or business logic
- User explicitly requests thorough review

For most features: tests + linting + following patterns is sufficient.

## Common Pitfalls to Avoid

- **Analysis paralysis** - Don't overthink, read the plan and execute
- **Skipping clarifying questions** - Ask now, not after building wrong thing
- **Ignoring plan references** - The plan has links for a reason
- **Testing at the end** - Test continuously or suffer later
- **Forgetting TodoWrite** - Track progress or lose track
- **80% done syndrome** - Finish the feature, don't move on early
