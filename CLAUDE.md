# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

`ltk` is a Claude Code plugin providing code analysis, workflow automation, and integrations. It's designed to be installed into other projects to extend Claude Code's capabilities.

## Plugin Architecture

This is a **Claude Code plugin** with four component types:

| Component | Location | Purpose | How It Works |
|-----------|----------|---------|--------------|
| **Skills** | `skills/*/SKILL.md` | Passive knowledge | Auto-loads based on description matching user queries |
| **Commands** | `commands/*.md` | Manual actions | User invokes with `/ltk:command-name` |
| **Agents** | `agents/*.md` | Proactive analyzers | Auto-triggers after code changes based on `whenToUse` |
| **Hooks** | `hooks/hooks.json` | System automation | Runs on events (SessionStart, PreToolUse, etc.) |

**Key insight**: Skills provide knowledge, agents do work. Skills are passive reference material; agents actively analyze and report.

## Component File Formats

### Skills (`skills/category/name/SKILL.md`)
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
    "matcher": "Write|Edit",  // for Pre/PostToolUse only
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

## Installation Scripts

```bash
./install.sh /path/to/project      # Copy plugin to project
./install.sh -l /path/to/project   # Symlink (for development)
./uninstall.sh /path/to/project    # Remove from project
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

## Directory Structure

```
skills/
├── core/           # Language-agnostic (security, quality, git, etc.)
├── python/         # Python-specific (fastapi, pytest, patterns)
├── javascript/     # JS/TS-specific (react)
└── design/         # Design-related (ui-ux, branding, accessibility)
```
