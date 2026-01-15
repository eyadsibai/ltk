---
name: ltk:cancel-ralph
description: Cancel an active Ralph Loop
allowed-tools:
  - Bash
  - Read
---

# Cancel Ralph

Cancel an active Ralph loop.

## Process

1. Check if `.claude/ralph-loop.local.md` exists:

   ```bash
   test -f .claude/ralph-loop.local.md && echo "EXISTS" || echo "NOT_FOUND"
   ```

2. **If NOT_FOUND**: Report "No active Ralph loop found."

3. **If EXISTS**:
   - Read `.claude/ralph-loop.local.md` to get the current iteration
   - Remove the file: `rm .claude/ralph-loop.local.md`
   - Report: "Cancelled Ralph loop (was at iteration N)"
