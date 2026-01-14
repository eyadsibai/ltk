---
name: workflows-plan
description: Transform feature descriptions into well-structured project plans with flexible detail levels
argument-hint: "[feature description, bug report, or improvement idea]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Edit
  - Task
  - TodoWrite
  - WebSearch
  - WebFetch
  - AskUserQuestion
---

# Create a Plan for a Feature or Bug Fix

Transform feature descriptions, bug reports, or improvement ideas into well-structured markdown plans that follow project conventions and best practices.

## Feature Description

<feature_description> #$ARGUMENTS </feature_description>

**If the feature description above is empty, ask the user:** "What would you like to plan? Please describe the feature, bug fix, or improvement you have in mind."

Do not proceed until you have a clear feature description from the user.

## Main Tasks

### 1. Repository Research & Context Gathering

Run these research tasks in parallel:

- **Codebase Analysis**: Search for similar implementations, patterns, and conventions
- **Best Practices Research**: Look up current best practices for the technology
- **Documentation Review**: Check existing docs, README, CLAUDE.md for guidelines

**Reference Collection:**

- [ ] Document findings with specific file paths (e.g., `app/services/example_service.rb:42`)
- [ ] Include URLs to external documentation
- [ ] Note team conventions from CLAUDE.md

### 2. Issue Planning & Structure

**Title & Categorization:**

- [ ] Draft clear, searchable title using conventional format (`feat:`, `fix:`, `docs:`)
- [ ] Determine issue type: enhancement, bug, refactor

**Stakeholder Analysis:**

- [ ] Identify who will be affected (end users, developers, operations)
- [ ] Consider implementation complexity

### 3. Choose Detail Level

Select how comprehensive the plan should be:

#### MINIMAL (Quick Issue)

**Best for:** Simple bugs, small improvements, clear features

**Structure:**

```markdown
[Brief problem/feature description]

## Acceptance Criteria
- [ ] Core requirement 1
- [ ] Core requirement 2

## Context
[Any critical information]

## References
- Related: #[issue_number]
```

#### STANDARD (Most Features)

**Best for:** Most features, complex bugs, team collaboration

**Includes MINIMAL plus:**

- Detailed background and motivation
- Technical considerations
- Success metrics
- Dependencies and risks

**Structure:**

```markdown
## Overview
[Comprehensive description]

## Problem Statement / Motivation
[Why this matters]

## Proposed Solution
[High-level approach]

## Technical Considerations
- Architecture impacts
- Performance implications
- Security considerations

## Acceptance Criteria
- [ ] Detailed requirement 1
- [ ] Testing requirements

## Success Metrics
[How we measure success]

## Dependencies & Risks
[What could block this]

## References
- Similar: [file_path:line_number]
- Docs: [url]
```

#### COMPREHENSIVE (Major Features)

**Best for:** Major features, architectural changes, complex integrations

**Includes STANDARD plus:**

- Implementation phases
- Alternative approaches
- Resource requirements
- Risk mitigation strategies

**Structure:**

```markdown
## Overview
[Executive summary]

## Problem Statement
[Detailed analysis]

## Proposed Solution
[Comprehensive design]

## Technical Approach

### Architecture
[Detailed technical design]

### Implementation Phases

#### Phase 1: [Foundation]
- Tasks and deliverables
- Success criteria

#### Phase 2: [Core Implementation]
- Tasks and deliverables

#### Phase 3: [Polish & Optimization]
- Tasks and deliverables

## Alternative Approaches Considered
[Other solutions and why rejected]

## Acceptance Criteria

### Functional Requirements
- [ ] Detailed functional criteria

### Non-Functional Requirements
- [ ] Performance targets
- [ ] Security requirements

### Quality Gates
- [ ] Test coverage requirements
- [ ] Code review approval

## Risk Analysis & Mitigation
[Comprehensive risk assessment]

## References
- Architecture: [file_path:line_number]
- Similar features: [file_path:line_number]
- External docs: [url]
```

### 4. Create Plan File

**Content Formatting:**

- [ ] Use clear headings with proper hierarchy
- [ ] Include code examples with syntax highlighting
- [ ] Use task lists for trackable items
- [ ] Add collapsible sections for lengthy content using `<details>` tags
- [ ] Apply emoji for visual scanning (optional)

**Cross-Referencing:**

- [ ] Link to related issues/PRs
- [ ] Reference specific code locations
- [ ] Add links to external resources

### 5. Output Format

Write the plan to `plans/<issue_title>.md`

### 6. Post-Generation Options

After writing the plan, use **AskUserQuestion** to present options:

**Question:** "Plan ready. What would you like to do next?"

**Options:**

1. **Review plan** - Open for review and editing
2. **Start work** - Begin implementing with `/workflows-work`
3. **Create GitHub Issue** - Create issue from this plan
4. **Simplify** - Reduce detail level
5. **Enhance** - Add more detail or research

**If Create GitHub Issue selected:**

```bash
gh issue create --title "feat: [Plan Title]" --body-file plans/<issue_title>.md
```

## Key Principles

- **Research First**: Understand before planning
- **Right-Size Detail**: Match detail to complexity
- **Actionable Items**: Every task should be completable
- **Clear References**: Link to code and docs

NEVER CODE during planning. Just research and write the plan.
