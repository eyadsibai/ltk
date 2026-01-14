#!/bin/bash
#
# Agent Generator for ltk
# Creates new autonomous agents with proper structure
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/agents"

# Valid agent colors
VALID_COLORS="red green yellow blue magenta cyan white"

show_help() {
    echo -e "${BLUE}Agent Generator for ltk${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS] <agent-name>"
    echo ""
    echo "Options:"
    echo "  -t, --tools <list>   Comma-separated tools (Read,Grep,Glob,Edit,Write,Bash)"
    echo "  -c, --color <color>  Status line color ($VALID_COLORS)"
    echo "  -p, --proactive      Make agent proactive (triggers after Write/Edit)"
    echo "  -d, --description    Interactive mode - prompts for all details"
    echo "  -l, --list           List existing agents"
    echo "  -h, --help           Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 performance-analyzer                     # Basic agent"
    echo "  $0 -p -c cyan api-validator                 # Proactive with color"
    echo "  $0 -t Read,Grep,Bash -d dependency-checker  # With tools, interactive"
    echo ""
    echo "Agents trigger automatically based on their 'whenToUse' description."
    echo ""
}

list_agents() {
    echo -e "${BLUE}Existing Agents${NC}"
    echo "==============="
    echo ""

    for agent in "$AGENTS_DIR"/*.md; do
        if [ -f "$agent" ]; then
            agent_name=$(basename "$agent" .md)
            desc=$(grep -m1 "^description:" "$agent" 2>/dev/null | sed 's/description: //' | head -c 60)
            color=$(grep -m1 "^color:" "$agent" 2>/dev/null | sed 's/color: //')
            echo -e "  ${CYAN}$agent_name${NC}"
            if [ -n "$desc" ]; then
                echo "      $desc"
            fi
            if [ -n "$color" ]; then
                echo "      Color: $color"
            fi
            echo ""
        fi
    done
}

# Default values
INTERACTIVE=false
AGENT_NAME=""
TOOLS="Read,Grep,Glob"
COLOR=""
PROACTIVE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--list)
            list_agents
            exit 0
            ;;
        -d|--description)
            INTERACTIVE=true
            shift
            ;;
        -t|--tools)
            TOOLS="$2"
            shift 2
            ;;
        -c|--color)
            COLOR="$2"
            shift 2
            ;;
        -p|--proactive)
            PROACTIVE=true
            shift
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
        *)
            AGENT_NAME="$1"
            shift
            ;;
    esac
done

# Validate agent name
if [ -z "$AGENT_NAME" ]; then
    echo -e "${RED}Error: Agent name required${NC}"
    show_help
    exit 1
fi

# Convert to kebab-case
AGENT_NAME=$(echo "$AGENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' _' '-')

AGENT_FILE="$AGENTS_DIR/$AGENT_NAME.md"

# Check if agent already exists
if [ -f "$AGENT_FILE" ]; then
    echo -e "${RED}Error: Agent already exists at $AGENT_FILE${NC}"
    exit 1
fi

# Validate color if provided
if [ -n "$COLOR" ]; then
    if ! echo "$VALID_COLORS" | grep -qw "$COLOR"; then
        echo -e "${RED}Error: Invalid color '$COLOR'${NC}"
        echo "Valid colors: $VALID_COLORS"
        exit 1
    fi
fi

# Get details if interactive
DESCRIPTION=""
WHEN_TO_USE=""
if [ "$INTERACTIVE" = true ]; then
    echo ""
    echo -e "${CYAN}Agent Configuration${NC}"
    echo "==================="
    echo ""
    read -p "What does this agent do? (brief): " DESCRIPTION
    echo ""
    echo "When should this agent trigger? (be specific)"
    echo "Example: After the user writes Python code that interacts with databases"
    read -p "When to use: " WHEN_TO_USE
    echo ""

    if [ -z "$COLOR" ]; then
        echo "Choose a color for the status line:"
        echo "  1) cyan    - Information/neutral"
        echo "  2) green   - Success/positive"
        echo "  3) yellow  - Warning/attention"
        echo "  4) blue    - Processing"
        echo "  5) magenta - Special"
        echo "  6) none    - No color"
        read -p "Color [1-6]: " color_choice
        case $color_choice in
            1) COLOR="cyan" ;;
            2) COLOR="green" ;;
            3) COLOR="yellow" ;;
            4) COLOR="blue" ;;
            5) COLOR="magenta" ;;
            *) COLOR="" ;;
        esac
    fi

    echo ""
    echo "Which tools should this agent have access to?"
    echo "  Available: Read, Grep, Glob, Edit, Write, Bash, WebFetch, WebSearch"
    echo "  Current: $TOOLS"
    read -p "Tools (comma-separated, or press Enter to keep default): " tools_input
    if [ -n "$tools_input" ]; then
        TOOLS="$tools_input"
    fi

    echo ""
    read -p "Should this agent be proactive (trigger after code changes)? [y/N]: " proactive_input
    if [ "$proactive_input" = "y" ] || [ "$proactive_input" = "Y" ]; then
        PROACTIVE=true
    fi
fi

# Generate human-readable name
AGENT_DISPLAY_NAME=$(echo "$AGENT_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Build description
if [ -z "$DESCRIPTION" ]; then
    DESCRIPTION="Analyzes code and provides $AGENT_DISPLAY_NAME insights"
fi

# Build whenToUse
if [ -z "$WHEN_TO_USE" ]; then
    if [ "$PROACTIVE" = true ]; then
        WHEN_TO_USE="After the user writes or edits code that may benefit from $AGENT_DISPLAY_NAME analysis"
    else
        WHEN_TO_USE="When the user asks about $AGENT_DISPLAY_NAME or requests analysis"
    fi
fi

# Convert tools to YAML array format
TOOLS_YAML=$(echo "$TOOLS" | tr ',' '\n' | sed 's/^/  - /' | sed 's/^ *- */  - /')

# Create agents directory if it doesn't exist
mkdir -p "$AGENTS_DIR"

# Generate agent file
cat > "$AGENT_FILE" << EOF
---
description: $DESCRIPTION
tools:
$(echo "$TOOLS" | tr ',' '\n' | sed 's/^/  - /')
whenToUse: |
  $WHEN_TO_USE

  Examples of when to trigger:
  - [Specific scenario 1]
  - [Specific scenario 2]
EOF

# Add color if specified
if [ -n "$COLOR" ]; then
    echo "color: $COLOR" >> "$AGENT_FILE"
fi

# Close frontmatter and add body
cat >> "$AGENT_FILE" << EOF
---

# $AGENT_DISPLAY_NAME

You are a specialized agent for $AGENT_DISPLAY_NAME.

## Your Role

$DESCRIPTION

## When You Activate

$WHEN_TO_USE

## Analysis Process

1. **Scan**: Review the relevant code/files
2. **Analyze**: Look for patterns, issues, or opportunities
3. **Report**: Provide clear, actionable feedback

## Output Format

Provide findings in this format:

### Findings

- **[Category]**: Description of finding
  - Location: \`file.py:line\`
  - Suggestion: How to address it

### Summary

Brief summary of overall analysis.

## Guidelines

- Be concise but thorough
- Prioritize important issues
- Provide actionable suggestions
- Don't be overly verbose for minor issues
EOF

echo ""
echo -e "${GREEN}Agent created successfully!${NC}"
echo ""
echo -e "File: ${CYAN}$AGENT_FILE${NC}"
echo -e "Triggers: ${CYAN}$WHEN_TO_USE${NC}"
if [ -n "$COLOR" ]; then
    echo -e "Color: ${CYAN}$COLOR${NC}"
fi
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Edit $AGENT_FILE"
echo "2. Refine the whenToUse triggers"
echo "3. Add specific analysis instructions"
echo "4. Test by writing code that matches the trigger"
echo ""
