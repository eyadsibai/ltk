---
name: code-review
description: Use when requesting code review, receiving code review feedback, before merging, or when handling reviewer suggestions - covers both giving and receiving review
version: 1.0.0
---

# Code Review

Both sides of the code review process: requesting and receiving feedback.

---

## When to Request Review

### Mandatory

| Situation | Why |
|-----------|-----|
| After completing major feature | Catch issues before they spread |
| Before merge to main | Gate quality |
| After each task in subagent workflow | Fix issues before compounding |

### Valuable

| Situation | Why |
|-----------|-----|
| When stuck | Fresh perspective |
| Before refactoring | Baseline check |
| After fixing complex bug | Verify fix doesn't introduce new issues |

---

## Requesting Review

### What to Provide

| Element | Purpose |
|---------|---------|
| What was implemented | Context for reviewer |
| Requirements/plan reference | What it should do |
| Base SHA | Starting point |
| Head SHA | Ending point |
| Brief summary | Quick orientation |

### Acting on Feedback

| Severity | Action |
|----------|--------|
| **Critical** | Fix immediately |
| **Important** | Fix before proceeding |
| **Minor** | Note for later |
| **Disagree** | Push back with reasoning |

---

## Receiving Review

### Core Principle

**Verify before implementing. Ask before assuming. Technical correctness over social comfort.**

### The Response Pattern

1. **Read** - Complete feedback without reacting
2. **Understand** - Restate requirement (or ask)
3. **Verify** - Check against codebase reality
4. **Evaluate** - Technically sound for THIS codebase?
5. **Respond** - Technical acknowledgment or reasoned pushback
6. **Implement** - One item at a time, test each

---

## Handling Unclear Feedback

| Situation | Action |
|-----------|--------|
| Some items unclear | STOP - ask before implementing any |
| Partially understood | Don't implement partial - items may be related |
| Scope unclear | Ask for clarification |

**Key concept**: Partial understanding leads to wrong implementation. Clarify everything first.

---

## When to Push Back

| Situation | Push Back |
|-----------|-----------|
| Suggestion breaks existing functionality | Yes |
| Reviewer lacks full context | Yes |
| Unused feature (YAGNI violation) | Yes |
| Technically incorrect for this stack | Yes |
| Legacy/compatibility reasons exist | Yes |
| Conflicts with architectural decisions | Yes |

### How to Push Back

| Do | Don't |
|----|-------|
| Use technical reasoning | Be defensive |
| Ask specific questions | Argue emotionally |
| Reference working tests/code | Ignore valid feedback |
| Show evidence | Just say "no" |

---

## Implementation Order

When fixing multiple items:

1. Clarify anything unclear FIRST
2. Then implement in order:
   - Blocking issues (breaks, security)
   - Simple fixes (typos, imports)
   - Complex fixes (refactoring, logic)
3. Test each fix individually
4. Verify no regressions

---

## Response Patterns

### Forbidden (Performative)

| Don't Say | Why |
|-----------|-----|
| "You're absolutely right!" | Performative, not technical |
| "Great point!" | Empty agreement |
| "Let me implement that now" | Before verification |

### Correct Responses

| Situation | Response |
|-----------|----------|
| Feedback is correct | "Fixed. [Brief description]" |
| Need clarification | "Need clarification on X before proceeding" |
| Disagree | "[Technical reasoning why current approach is better]" |
| Can't verify | "Can't verify without [X]. Should I investigate?" |

**Key concept**: Actions speak. Just fix it. The code shows you heard the feedback.

---

## Red Flags

| Never Do | Why |
|----------|-----|
| Skip review because "it's simple" | Simple changes cause bugs too |
| Ignore Critical issues | They're critical for a reason |
| Proceed with unfixed Important issues | They'll compound |
| Argue with valid technical feedback | Ego over quality |
| Implement without understanding | Wrong fixes waste time |

---

## Source-Specific Handling

| Source | Approach |
|--------|----------|
| **User** | Trusted - implement after understanding, skip to action |
| **External reviewer** | Evaluate technically before implementing |
| **Automated tool** | Verify relevance to your context |
