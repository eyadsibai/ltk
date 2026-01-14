# ltk

> Your personal development toolkit for Claude Code - extensible, per-project, and smart.

```
┌─────────────────────────────────────────────────────────────────┐
│  ltk                                                            │
│  ───                                                            │
│  16 Skills · 12 Commands · 6 Agents · 4 Hooks · 3 MCP Servers  │
└─────────────────────────────────────────────────────────────────┘
```

## What is this?

A **Claude Code plugin** that gives you:

- **Skills** - Domain knowledge that loads automatically when relevant
- **Commands** - Actions you invoke with `/ltk:command-name`
- **Agents** - Autonomous helpers that trigger after you write code
- **Hooks** - Automation that runs on events (session start, before/after edits)

---

## Understanding the Components

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        HOW COMPONENTS DIFFER                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SKILLS         = Knowledge that loads automatically                        │
│  COMMANDS       = Actions you trigger manually                              │
│  AGENTS         = Autonomous helpers that run after you code                │
│  HOOKS          = Automation that runs on system events                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Skills - Passive Knowledge

**What:** Domain expertise that Claude learns from when relevant
**When:** Loads automatically based on what you're asking about
**Trigger:** Your questions/context match the skill description
**You do:** Nothing - just ask questions naturally

```
You: "How do I test my FastAPI endpoints?"
     ↓
Claude: [fastapi + pytest skills auto-load into my knowledge]
        "Here's how to test FastAPI endpoints..."
```

**Think of it as:** A reference book that opens to the right page automatically


### Commands - Manual Actions

**What:** Specific tasks you explicitly request
**When:** Only when you type the command
**Trigger:** You type `/ltk:command-name`
**You do:** Invoke it manually when you want that action

```
You: /ltk:scan-security
     ↓
Claude: [Runs security scan on codebase]
        "Found 2 vulnerabilities..."
```

**Think of it as:** Buttons you press to do specific things


### Agents - Proactive Helpers

**What:** Specialized assistants that watch what you're doing
**When:** After you write or edit code (automatically)
**Trigger:** Tool events (Write, Edit) + matching context
**You do:** Nothing - they activate on their own

```
You: *writes Python code with SQL query*
     ↓
Claude: [security-analyzer agent activates]
        "Note: This SQL query might be vulnerable to injection.
         Consider using parameterized queries."
```

**Think of it as:** A team of experts looking over your shoulder


### Hooks - System Automation

**What:** Scripts/prompts that run on specific system events
**When:** Triggered by system events (session start, before/after edits)
**Trigger:** Events like SessionStart, PreToolUse, PostToolUse
**You do:** Nothing - happens automatically in the background

```
[Session starts]
     ↓
Hook: [Loads git status, project structure, TODOs]
     ↓
Claude: [Has project context ready]
```

**Think of it as:** Automatic setup and cleanup routines


### Side-by-Side Comparison

| Aspect | Skills | Commands | Agents | Hooks |
|--------|--------|----------|--------|-------|
| **Activation** | Automatic (context) | Manual (`/ltk:...`) | Automatic (after code) | Automatic (events) |
| **Purpose** | Provide knowledge | Execute actions | Analyze & advise | Automate workflows |
| **User action** | Just ask questions | Type command | Write code | Nothing |
| **Output** | Better answers | Task results | Suggestions/warnings | Background setup |

### Visual Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         YOUR CODING SESSION                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  SESSION START                                                          │
│       │                                                                 │
│       ▼                                                                 │
│  ┌─────────┐                                                            │
│  │  HOOKS  │ ──→ Load git status, project structure, TODOs             │
│  └─────────┘                                                            │
│       │                                                                 │
│       ▼                                                                 │
│  YOU ASK: "How do I add authentication to FastAPI?"                     │
│       │                                                                 │
│       ▼                                                                 │
│  ┌─────────┐                                                            │
│  │ SKILLS  │ ──→ fastapi + security-scanning skills load               │
│  └─────────┘                                                            │
│       │                                                                 │
│       ▼                                                                 │
│  CLAUDE ANSWERS with specialized knowledge                              │
│       │                                                                 │
│       ▼                                                                 │
│  YOU WRITE CODE                                                         │
│       │                                                                 │
│       ▼                                                                 │
│  ┌─────────┐                                                            │
│  │ AGENTS  │ ──→ security-analyzer checks your code                    │
│  └─────────┘     quality-reviewer suggests improvements                │
│       │                                                                 │
│       ▼                                                                 │
│  YOU TYPE: /ltk:scan-security                                           │
│       │                                                                 │
│       ▼                                                                 │
│  ┌──────────┐                                                           │
│  │ COMMANDS │ ──→ Full security scan runs                              │
│  └──────────┘                                                           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Quick Summary

| Component | One-liner |
|-----------|-----------|
| **Skills** | "Claude knows this stuff" |
| **Commands** | "Do this specific thing now" |
| **Agents** | "Watch my code and give feedback" |
| **Hooks** | "Run this automatically when X happens" |

### Skills vs Agents - Common Confusion

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  SKILLS = Reference Material (Passive)                                      │
│  ────────────────────────────────────────                                   │
│  • A book Claude reads to learn something                                   │
│  • Contains: Documentation, patterns, best practices                        │
│  • Does: NOTHING - just sits there until needed                             │
│  • Output: Better, more informed responses                                  │
│                                                                             │
│  Example: "fastapi" skill contains FastAPI patterns                         │
│           → Claude reads it → gives better FastAPI advice                   │
├─────────────────────────────────────────────────────────────────────────────┤
│  AGENTS = Active Workers (Proactive)                                        │
│  ───────────────────────────────────                                        │
│  • A specialist that actively analyzes your code                            │
│  • Contains: Instructions for a task + tools to use                         │
│  • Does: ACTIVELY scans, reviews, reports findings                          │
│  • Output: Specific warnings, suggestions, reports                          │
│                                                                             │
│  Example: "security-analyzer" agent scans your code                         │
│           → Reports "Found SQL injection on line 45"                        │
└─────────────────────────────────────────────────────────────────────────────┘
```

**When to create which?**

| Create a... | When you want... |
|-------------|------------------|
| **Skill** | Claude to *know* something (patterns, APIs, docs) |
| **Agent** | Something to actively *analyze* your code |

### How Conflicts Are Avoided

Claude Code is designed to be **ADDITIVE**, not exclusive - multiple components work together:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  SKILLS    │ Multiple load together - knowledge combines                    │
│            │ You ask about "FastAPI testing" → fastapi + pytest both load   │
├────────────┼────────────────────────────────────────────────────────────────┤
│  AGENTS    │ Multiple can trigger - Claude picks relevant ones              │
│            │ Write SQL code → security-analyzer AND quality-reviewer run    │
├────────────┼────────────────────────────────────────────────────────────────┤
│  COMMANDS  │ Namespaced with plugin name - no collision possible            │
│            │ /ltk:scan-security vs /other:scan - different commands         │
├────────────┼────────────────────────────────────────────────────────────────┤
│  HOOKS     │ All matching hooks execute sequentially                        │
│            │ SessionStart → all session hooks run in order                  │
└─────────────────────────────────────────────────────────────────────────────┘
```

| Component | Conflict? | Behavior |
|-----------|-----------|----------|
| Skills | No | Multiple load together, knowledge combines |
| Agents | No | Multiple can run, Claude picks relevant ones |
| Commands | No | Namespaced with plugin name (`/ltk:...`) |
| Hooks | No | All matching hooks execute |

**Best Practice - Be Specific:**

```yaml
# ❌ Too broad (skill) - loads too often
description: This skill is for Python

# ✅ Specific - loads only when relevant
description: This skill should be used when asking about "FastAPI", "FastAPI routes"

# ❌ Too broad (agent) - triggers too often
whenToUse: After writing code

# ✅ Specific - triggers appropriately
whenToUse: After writing Python code containing SQL queries or database operations
```

---

## Quick Start

### 1. Install to your project

```bash
./install.sh /path/to/your/project
```

### 2. Start Claude Code

```bash
cd /path/to/your/project
claude
```

### 3. Use it!

```
You: "How do I test my FastAPI endpoints?"
     → fastapi + pytest skills auto-load
     → You get specialized guidance

You: "/ltk:scan-security"
     → Runs security analysis on your code

You: *write some Python code*
     → security-analyzer agent checks for issues
     → quality-reviewer agent suggests improvements
```

---

## How Skills Work

Skills **load automatically** based on your questions. No manual invocation needed.

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│   You: "How do I add authentication to my FastAPI app?"         │
│                                                                  │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  Claude matches against ALL skill descriptions:          │   │
│   │                                                          │   │
│   │  ✓ fastapi           "FastAPI" matched                  │   │
│   │  ✓ python-patterns   "Python" context                   │   │
│   │  ✓ security-scanning "authentication" = security        │   │
│   │  ✗ react             not relevant                       │   │
│   │  ✗ branding          not relevant                       │   │
│   └─────────────────────────────────────────────────────────┘   │
│                              ↓                                   │
│   Only matched skills load their full content                    │
│   Others stay as tiny metadata (~100 words each)                │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### Token Efficiency

| What | When Loaded | Size |
|------|-------------|------|
| Skill metadata (name + description) | Always | ~100 words each |
| Skill body (SKILL.md content) | Only when matched | ~1,500 words each |
| References/examples | Only when Claude reads them | Varies |

**With 50 skills:** Only ~5,000 tokens always loaded. Relevant skills add more only when needed.

---

## What's Included

### Skills (16)

```
skills/
├── core/                        # Language-agnostic (8)
│   ├── security-scanning/       # Vulnerability detection
│   ├── code-quality/            # Style, complexity, dead code
│   ├── architecture-review/     # Structure, dependencies
│   ├── test-coverage/           # Coverage analysis
│   ├── git-workflows/           # Commits, PRs, branches
│   ├── build-deploy/            # CI/CD, deployment
│   ├── documentation/           # Docs, docstrings, API specs
│   └── refactoring/             # Safe code restructuring
│
├── python/                      # Python-specific (4)
│   ├── python-patterns/         # Modern Python, type hints
│   ├── fastapi/                 # FastAPI development
│   ├── pytest/                  # Testing with pytest
│   └── fastapi-testing/         # Combined FastAPI + testing
│
├── javascript/                  # JavaScript (1)
│   └── react/                   # React patterns
│
└── design/                      # Design (3)
    ├── ui-ux/                   # Interface design
    ├── branding/                # Brand identity
    └── accessibility/           # a11y, WCAG
```

### Commands (12)

| Command | What it does |
|---------|--------------|
| `/ltk:scan-security` | Find vulnerabilities, secrets, CVEs |
| `/ltk:check-quality` | Analyze style, complexity, dead code |
| `/ltk:review-architecture` | Map structure, find circular deps |
| `/ltk:analyze-coverage` | Find untested code paths |
| `/ltk:smart-commit` | Create commit with smart message |
| `/ltk:create-pr` | Generate PR with description |
| `/ltk:validate-build` | Run and validate build process |
| `/ltk:deploy` | Deploy with pre-flight checks |
| `/ltk:generate-docs` | Create docstrings, API docs |
| `/ltk:update-readme` | Refresh README content |
| `/ltk:refactor` | Guided safe refactoring |
| `/ltk:migrate` | Code migration assistance |

### Agents (6)

Agents run **automatically** after you write code:

| Agent | Triggers When | Does What |
|-------|---------------|-----------|
| `security-analyzer` | After Write/Edit | Checks for vulnerabilities |
| `quality-reviewer` | After Write/Edit | Reviews code quality |
| `architecture-analyzer` | Structure questions | Analyzes patterns |
| `test-analyzer` | After features | Suggests tests to write |
| `refactor-assistant` | Complex code | Suggests improvements |
| `docs-generator` | New code | Generates documentation |

### Hooks (4)

| Event | What Happens |
|-------|--------------|
| Session Start | Loads git status, project structure, TODOs |
| Pre-Write/Edit | Quick validation before changes |
| Post-Write/Edit | Suggestions after changes |
| Notification | Alerts for long tasks |

---

## Adding Your Own Skills

### Quick Way (Generator)

```bash
# Interactive - prompts for details
./create-skill.sh -d django

# Specify category
./create-skill.sh -c python sqlalchemy

# Full template with examples folder
./create-skill.sh -t full -c javascript vue

# List all skills
./create-skill.sh --list
```

### Manual Way

Create `skills/<category>/<name>/SKILL.md`:

```markdown
---
name: My Skill
description: This skill should be used when the user asks about "keyword1", "keyword2", or mentions my-skill topics.
version: 1.0.0
---

# My Skill

Your content here. This loads only when the description matches.
```

### Composite Skills

When two topics often combine, create a specialized skill:

```
skills/python/fastapi-testing/    # FastAPI + pytest combined
skills/javascript/react-testing/  # React + Jest combined
```

These provide specialized patterns for the combination.

---

## Configuration

Create `.claude/ltk.local.md` in your project:

```yaml
---
# Enable/disable proactive agents
proactive_agents: true

# Code quality threshold
quality_threshold: 80

# GCP project for deployments
gcp_project: my-project-id

# Security settings
security:
  ignore_patterns:
    - "test_*.py"
    - "fixtures/"
  check_secrets: true

# Documentation style
docstring_style: google
---

## Project Notes

Add project-specific context here. Claude reads this!
```

---

## Customization

### Enable/Disable Components

```bash
# Disable an agent
mv agents/security-analyzer.md agents/security-analyzer.md.disabled

# Disable a skill
mv skills/python/django skills/python/django.disabled

# Re-enable
mv agents/security-analyzer.md.disabled agents/security-analyzer.md
```

### Modify Behavior

| To Change | Edit |
|-----------|------|
| Skill knowledge | `skills/**/SKILL.md` |
| Command behavior | `commands/*.md` |
| Agent triggers | `agents/*.md` (whenToUse field) |
| Hook automation | `hooks/hooks.json` |

---

## Installation Options

### Install to Project (Recommended)

```bash
# Copies plugin into project's .claude-plugin/
./install.sh /path/to/project

# Creates:
# - .claude-plugin/           (the plugin)
# - .claude/ltk.local.md  (your config)
```

### Symlink (For Development)

```bash
# Links to source - changes sync automatically
./install.sh -l /path/to/project
```

### Load Without Installing

```bash
# Temporary - doesn't modify project
claude --plugin-dir /path/to/ltk
```

### Uninstall

```bash
./uninstall.sh /path/to/project
```

---

## Scripts Reference

| Script | Purpose |
|--------|---------|
| `install.sh` | Install plugin to a project |
| `install.sh -l` | Install as symlink (dev mode) |
| `uninstall.sh` | Remove from a project |
| `create-skill.sh` | Generate new skill |
| `create-command.sh` | Generate new command |
| `create-agent.sh` | Generate new agent |
| `add-hook.sh` | Add hook to hooks.json |

### Generator Examples

```bash
# Skills (passive knowledge)
./create-skill.sh -c python django           # Add Django skill
./create-skill.sh --list                      # List all skills

# Commands (manual actions)
./create-command.sh lint-code                 # Add /ltk:lint-code command
./create-command.sh -d run-benchmarks         # Interactive mode
./create-command.sh --list                    # List all commands

# Agents (proactive analyzers)
./create-agent.sh performance-analyzer        # Add performance agent
./create-agent.sh -p -c cyan api-validator    # Proactive with color
./create-agent.sh --list                      # List all agents

# Hooks (system automation)
./add-hook.sh -e SessionStart                 # Add session start hook
./add-hook.sh -e PreToolUse -m 'Write|Edit'   # Add pre-write hook
./add-hook.sh --list                          # List all hooks
```

---

## MCP Integrations

Optional external service connections:

| Server | Purpose | Requires |
|--------|---------|----------|
| GitHub | Extended GitHub operations | `GITHUB_TOKEN` |
| PostgreSQL | Database queries | `DATABASE_URL` |
| SQLite | Local database | `SQLITE_DB_PATH` |

Set environment variables to enable.

---

## File Structure

```
ltk/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── skills/                  # Domain knowledge (auto-loads)
│   ├── core/
│   ├── python/
│   ├── javascript/
│   └── design/
├── commands/                # /ltk:* commands
├── agents/                  # Autonomous helpers
├── hooks/
│   └── hooks.json          # Event automation
├── .mcp.json               # External integrations
├── install.sh              # Installation script
├── uninstall.sh            # Removal script
├── create-skill.sh         # Skill generator
├── create-command.sh       # Command generator
├── create-agent.sh         # Agent generator
├── add-hook.sh             # Hook helper
└── README.md               # This file
```

---

## Examples

### Ask a Question (Skills Auto-Load)

```
You: "What's the best way to structure a FastAPI project?"

Claude: [fastapi + architecture-review skills load]
        Here's a recommended structure...
```

### Run a Command

```
You: /ltk:scan-security

Claude: [Scans codebase]
        Found 2 issues:
        - HIGH: Hardcoded API key in config.py:23
        - MEDIUM: SQL query without parameterization in db.py:45
```

### Write Code (Agents Auto-Trigger)

```
You: *writes a new Python function*

Claude: [security-analyzer runs]
        Note: This function accepts user input - consider adding validation.

        [quality-reviewer runs]
        Suggestion: Add type hints to improve readability.
```

---

## Tips

1. **Skills are automatic** - Just ask questions naturally
2. **Commands are manual** - Use `/ltk:` prefix
3. **Agents are proactive** - They run after you code
4. **Add skills freely** - Token cost is minimal for unused skills
5. **Customize per-project** - Edit `.claude/ltk.local.md`

---

## License

MIT
