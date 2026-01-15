---
name: ltk:ralph-loop
description: Start iterative self-referential development loop - runs until completion promise or max iterations
argument-hint: "PROMPT [--max-iterations N] [--completion-promise TEXT]"
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Ralph Loop Command

Implementation of the Ralph Wiggum technique for iterative, self-referential AI development loops.

## What is Ralph Loop?

Ralph Loop is a development methodology based on continuous AI agent loops. A simple loop that repeatedly feeds an AI agent a prompt, allowing it to iteratively improve its work until completion.

## How It Works

1. Start with `/ralph-loop "Your task" --completion-promise "DONE" --max-iterations 50`
2. Work on the task iteratively
3. Each iteration builds on previous work (visible in files and git history)
4. Loop continues until:
   - Completion promise is output: `<promise>DONE</promise>`
   - Max iterations reached
   - Manually cancelled with `/cancel-ralph`

## Usage Examples

```bash
# Build a feature with TDD
/ralph-loop "Build a REST API for todos. Requirements: CRUD operations, input validation, tests. Output <promise>COMPLETE</promise> when done." --completion-promise "COMPLETE" --max-iterations 50

# Fix bugs iteratively
/ralph-loop "Fix the auth bug. Run tests after each change." --max-iterations 20

# Refactor with safety net
/ralph-loop "Refactor the cache layer. Tests must pass." --completion-promise "REFACTORED" --max-iterations 30
```

## State Management

The loop state is stored in `.claude/ralph-loop.local.md`:

```yaml
---
active: true
iteration: 1
max_iterations: 50
completion_promise: "DONE"
started_at: "2024-01-15T10:00:00Z"
---

Your prompt text here...
```

## Completion Rules

**CRITICAL**: Only output the completion promise when it is genuinely TRUE:

- ✓ All requirements are met
- ✓ Tests are passing
- ✓ The task is actually complete
- ✗ Do NOT lie to exit the loop
- ✗ Do NOT output false promises

## When to Use Ralph

**Good for:**

- Well-defined tasks with clear success criteria
- Tasks requiring iteration and refinement
- Greenfield projects
- Tasks with automatic verification (tests, linters)

**Not good for:**

- Tasks requiring human judgment
- One-shot operations
- Unclear success criteria

## Monitoring

```bash
# View current iteration
grep '^iteration:' .claude/ralph-loop.local.md

# View full state
head -10 .claude/ralph-loop.local.md
```

## Cancellation

Use `/cancel-ralph` to stop the loop at any time.
