---
name: ltk:lfg
description: Full autonomous engineering workflow - plan, work, review, test, and ship
argument-hint: "[feature description]"
---

# LFG - Full Autonomous Engineering Workflow

Run through the complete engineering workflow autonomously.

## Workflow Steps

Execute these steps in order:

1. **Plan** - Create implementation plan for the feature
   - Use `/workflows-plan $ARGUMENTS`
   - Break down into clear, actionable steps
   - Identify files to modify

2. **Research** - Deepen the plan with research
   - Search for best practices
   - Check existing patterns in codebase
   - Validate approach

3. **Work** - Execute the plan
   - Use `/workflows-work`
   - Implement changes systematically
   - Test as you go

4. **Review** - Comprehensive code review
   - Run tests
   - Check for regressions
   - Validate against requirements

5. **Resolve** - Fix any issues found
   - Address review comments
   - Fix failing tests
   - Clean up code

6. **Test Browser** (if applicable)
   - Run browser tests on affected pages
   - Verify UI changes work correctly

7. **Complete** - Ship the feature
   - Create commit with clear message
   - Ready for PR

## Usage

```
/lfg Implement user authentication with JWT
/lfg Add dark mode toggle to settings
/lfg Fix pagination bug on products page
```

## Process Notes

- Each step builds on the previous
- Stop and ask if anything is unclear
- Verify each step before moving to next
- Use todo list to track progress through steps

## Output

At completion, provide:

1. Summary of changes made
2. Files modified
3. Tests run and results
4. Any remaining follow-up items
