---
name: requirements-engineering
description: Use when "requirements document", "acceptance criteria", "user stories", "EARS format", "specification", "feature spec", "product requirements"
version: 1.0.0
---

# Requirements Engineering

Structured approaches for capturing what to build before how to build it.

---

## Core Principle

**Specify WHAT, not HOW.** Requirements describe outcomes and behaviors, not implementation details.

---

## EARS Format

**Easy Approach to Requirements Syntax** - structured acceptance criteria.

| Pattern | Template | Use Case |
|---------|----------|----------|
| **Event-driven** | WHEN [event] THEN [system] SHALL [response] | User actions, triggers |
| **Conditional** | IF [condition] THEN [system] SHALL [response] | Business rules |
| **State-driven** | WHILE [state] [system] SHALL [response] | Ongoing behaviors |
| **Ubiquitous** | WHERE [feature] [system] SHALL [response] | Always-true rules |
| **Unconditional** | [system] SHALL [response] | Basic capabilities |

### Examples

| Type | Example |
|------|---------|
| Event | WHEN user clicks "Submit" THEN system SHALL validate all required fields |
| Conditional | IF user is not authenticated THEN system SHALL redirect to login |
| State | WHILE file is uploading system SHALL display progress indicator |
| Ubiquitous | WHERE data is displayed system SHALL use consistent date format |

---

## User Story Format

```
As a [role]
I want [capability]
So that [benefit]
```

### Good vs Bad

| Bad | Good |
|-----|------|
| As a user I want to login | As a returning customer I want to login with my email so that I can access my order history |
| As a user I want a button | As a content creator I want a publish button so that I can share my work publicly |

**Key concept**: The "so that" clause reveals the actual need - often the stated "want" isn't what's really needed.

---

## Requirements Document Structure

| Section | Content |
|---------|---------|
| **Problem Statement** | What problem are we solving? |
| **User Stories** | Who wants what and why? |
| **Acceptance Criteria** | How do we know it's done? (EARS) |
| **Non-Functional** | Performance, security, accessibility |
| **Out of Scope** | What we're NOT building |
| **Success Metrics** | How do we measure success? |

---

## Constitution (Governing Principles)

For complex projects, establish guiding principles before features:

| Element | Purpose |
|---------|---------|
| **Core Values** | What matters most (simplicity > cleverness) |
| **Technical Principles** | Architecture standards |
| **Decision Framework** | How to make trade-offs |
| **Quality Standards** | Testing, review requirements |

**Key concept**: Constitution prevents scope creep and ensures consistency across features.

---

## Clarification Techniques

Before implementation, resolve ambiguities:

| Technique | When to Use |
|-----------|-------------|
| **Ask "what if"** | Edge cases, error scenarios |
| **Present options** | Multiple valid approaches |
| **Challenge assumptions** | "Is this actually required?" |
| **Define boundaries** | What's in/out of scope |

### Questions to Ask

- What happens when [edge case]?
- What does success look like?
- What's the minimum viable version?
- What can we defer to later?

---

## Non-Functional Requirements

| Category | Questions to Answer |
|----------|---------------------|
| **Performance** | Response time? Throughput? Concurrent users? |
| **Security** | Authentication? Authorization? Data protection? |
| **Accessibility** | WCAG level? Screen reader support? |
| **Scalability** | Expected growth? Peak load? |
| **Reliability** | Uptime requirements? Recovery time? |

---

## Anti-Patterns

| Don't | Why |
|-------|-----|
| Specify implementation | "Use React" locks in decisions |
| Assume requirements | Validate with stakeholders |
| Skip edge cases | They become bugs later |
| Mix requirements with design | Conflates what with how |
| Write vague criteria | "System should be fast" is untestable |

---

## Testable vs Untestable

| Untestable | Testable |
|------------|----------|
| "Fast response" | "Response under 200ms" |
| "User-friendly" | "Task completable in <3 clicks" |
| "Secure" | "Passwords hashed with bcrypt" |
| "Scalable" | "Handles 10K concurrent users" |

**Key concept**: If you can't write a test for it, it's not a requirement - it's a wish.
