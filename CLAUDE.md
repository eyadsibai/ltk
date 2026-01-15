# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

`ltk` is a Claude Code plugin collection providing code analysis, workflow automation, and integrations. It's organized into **7 domain-based plugins** that can be installed selectively into projects.

## Multi-Plugin Architecture

ltk is organized into domain-specific plugins for modular installation:

| Plugin | Purpose | Key Components |
|--------|---------|----------------|
| **ltk-core** | Context engineering, foundations | Memory systems, agent patterns, prompt engineering |
| **ltk-engineering** | Software development | Testing, architecture, code quality, refactoring |
| **ltk-data** | Data & databases | SQL, ML, analytics, data pipelines |
| **ltk-devops** | Infrastructure | Kubernetes, security, secrets, observability |
| **ltk-design** | UI/UX | Accessibility, design systems, branding |
| **ltk-product** | Product & business | Product management, marketing, strategy |
| **ltk-github** | Git workflows | PRs, commits, code review |

**Dependencies**: All plugins depend on `ltk-core` which provides foundational knowledge.

## Plugin Directory Structure

```
ltk/
├── plugins/
│   ├── marketplace.json        # Central registry of all plugins
│   ├── ltk-core/
│   │   ├── plugin.json
│   │   ├── skills/
│   │   ├── agents/
│   │   ├── commands/
│   │   └── hooks/
│   ├── ltk-engineering/
│   ├── ltk-data/
│   ├── ltk-devops/
│   ├── ltk-design/
│   ├── ltk-product/
│   └── ltk-github/
├── install.sh                  # Selective plugin installer
└── submodules/                 # Source material from git submodules
```

## Component Types

Each plugin contains four component types:

| Component | Location | Purpose | How It Works |
|-----------|----------|---------|--------------|
| **Skills** | `skills/*/SKILL.md` | Passive knowledge | Auto-loads based on description matching user queries |
| **Commands** | `commands/*.md` | Manual actions | User invokes with `/ltk:command-name` |
| **Agents** | `agents/*.md` | Proactive analyzers | Auto-triggers after code changes based on `whenToUse` |
| **Hooks** | `hooks/hooks.json` | System automation | Runs on events (SessionStart, PreToolUse, etc.) |

**Key insight**: Skills provide knowledge, agents do work. Skills are passive reference material; agents actively analyze and report.

## Installation

### Selective Installation

```bash
# Install specific plugins
./install.sh --core --engineering /path/to/project

# Use presets
./install.sh --preset=developer /path/to/project    # core + engineering + github
./install.sh --preset=fullstack /path/to/project    # core + engineering + data + github
./install.sh --preset=devops /path/to/project       # core + devops + github
./install.sh --preset=design /path/to/project       # core + design
./install.sh --preset=all /path/to/project          # all plugins

# Development mode (symlinks)
./install.sh -l --all /path/to/project

# List available plugins
./install.sh --list
```

### Available Presets

| Preset | Plugins Included |
|--------|------------------|
| `minimal` | ltk-core |
| `developer` | ltk-core + ltk-engineering + ltk-github |
| `fullstack` | ltk-core + ltk-engineering + ltk-data + ltk-github |
| `devops` | ltk-core + ltk-devops + ltk-github |
| `design` | ltk-core + ltk-design |
| `product` | ltk-core + ltk-product |
| `all` | All 7 plugins |

## Component File Formats

### Skills (`skills/name/SKILL.md`)

```yaml
---
name: Skill Name
description: This skill should be used when the user asks about "trigger phrase 1", "trigger phrase 2"...
version: 1.0.0
---
# Content that loads when description matches
```

### Commands (`commands/name.md`)

```yaml
---
name: command-name
description: What it does
allowed-tools:
  - Read
  - Grep
  - Bash
---
# Instructions Claude follows when user invokes /ltk:command-name
```

### Agents (`agents/name.md`)

```yaml
---
description: What this agent does
whenToUse: |
  When to trigger (with examples)
tools:
  - Read
  - Grep
color: cyan  # red, green, yellow, blue, magenta, cyan, white
---
# Agent instructions
```

### Hooks (`hooks/hooks.json`)

```json
{
  "hooks": [{
    "event": "SessionStart|PreToolUse|PostToolUse|Stop|Notification",
    "matcher": "Write|Edit",
    "type": "prompt|command",
    "prompt": "Instructions for Claude",
    "timeout": 10000
  }]
}
```

## Generator Scripts

```bash
./create-skill.sh -c python django      # New skill in skills/python/django/
./create-command.sh lint-code           # New command at commands/lint-code.md
./create-agent.sh -p security-checker   # New proactive agent
./add-hook.sh -e PreToolUse -m 'Write'  # Add hook to hooks.json

# List existing components
./create-skill.sh --list
./create-command.sh --list
./create-agent.sh --list
./add-hook.sh --list
```

## MCP Server Configuration

Defined in `.mcp.json`. Requires environment variables:

- `GITHUB_TOKEN` - For GitHub MCP server
- `DATABASE_URL` - For PostgreSQL MCP server
- `SQLITE_DB_PATH` - For SQLite MCP server (defaults to `./data.db`)

## Writing Effective Descriptions

**Skills** - Be specific about trigger phrases:

```yaml
# Good: Specific triggers
description: This skill should be used when asking about "FastAPI", "FastAPI routes", "FastAPI dependencies"

# Bad: Too broad
description: This skill is for Python development
```

**Agents** - Be specific about when to trigger:

```yaml
# Good: Specific context
whenToUse: After writing Python code that contains SQL queries or database operations

# Bad: Too broad
whenToUse: After writing code
```

## Valid Agent Colors

Only these colors are valid: `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`
