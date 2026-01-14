#!/bin/bash
#
# Command Generator for ltk
# Creates new slash commands with proper structure
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
COMMANDS_DIR="$SCRIPT_DIR/commands"

show_help() {
    echo -e "${BLUE}Command Generator for ltk${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS] <command-name>"
    echo ""
    echo "Options:"
    echo "  -d, --description    Interactive mode - prompts for details"
    echo "  -l, --list           List existing commands"
    echo "  -h, --help           Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 lint-code                    # Creates commands/lint-code.md"
    echo "  $0 -d run-benchmarks            # Interactive mode"
    echo ""
    echo "Commands are invoked with: /ltk:<command-name>"
    echo ""
}

list_commands() {
    echo -e "${BLUE}Existing Commands${NC}"
    echo "================="
    echo ""

    for cmd in "$COMMANDS_DIR"/*.md; do
        if [ -f "$cmd" ]; then
            cmd_name=$(basename "$cmd" .md)
            desc=$(grep -m1 "^description:" "$cmd" 2>/dev/null | sed 's/description: //' | head -c 50)
            echo -e "  ${CYAN}/ltk:$cmd_name${NC}"
            if [ -n "$desc" ]; then
                echo "      $desc"
            fi
        fi
    done
    echo ""
}

# Default values
INTERACTIVE=false
COMMAND_NAME=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--list)
            list_commands
            exit 0
            ;;
        -d|--description)
            INTERACTIVE=true
            shift
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
        *)
            COMMAND_NAME="$1"
            shift
            ;;
    esac
done

# Validate command name
if [ -z "$COMMAND_NAME" ]; then
    echo -e "${RED}Error: Command name required${NC}"
    show_help
    exit 1
fi

# Convert to kebab-case
COMMAND_NAME=$(echo "$COMMAND_NAME" | tr '[:upper:]' '[:lower:]' | tr ' _' '-')

COMMAND_FILE="$COMMANDS_DIR/$COMMAND_NAME.md"

# Check if command already exists
if [ -f "$COMMAND_FILE" ]; then
    echo -e "${RED}Error: Command already exists at $COMMAND_FILE${NC}"
    exit 1
fi

# Get details if interactive
DESCRIPTION=""
WHAT_IT_DOES=""
if [ "$INTERACTIVE" = true ]; then
    echo ""
    echo -e "${CYAN}Command Configuration${NC}"
    echo "====================="
    echo ""
    read -p "Brief description (one line): " DESCRIPTION
    echo ""
    echo "What should this command do? (Enter empty line to finish)"
    echo "Example: Scan codebase for security issues, report findings"
    WHAT_IT_DOES=""
    while IFS= read -r line; do
        [ -z "$line" ] && break
        WHAT_IT_DOES="${WHAT_IT_DOES}${line}\n"
    done
fi

# Generate human-readable name
COMMAND_DISPLAY_NAME=$(echo "$COMMAND_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Build description
if [ -z "$DESCRIPTION" ]; then
    DESCRIPTION="Run $COMMAND_DISPLAY_NAME operation"
fi

# Build instructions
if [ -z "$WHAT_IT_DOES" ]; then
    WHAT_IT_DOES="[Describe what this command should do]"
fi

# Create commands directory if it doesn't exist
mkdir -p "$COMMANDS_DIR"

# Generate command file
cat > "$COMMAND_FILE" << EOF
---
name: $COMMAND_NAME
description: $DESCRIPTION
---

# $COMMAND_DISPLAY_NAME

$WHAT_IT_DOES

## Steps

1. [First step]
2. [Second step]
3. [Third step]

## Output

Provide clear output showing:
- What was analyzed/processed
- Any issues found
- Recommendations or next steps

## Example Usage

\`\`\`
User: /ltk:$COMMAND_NAME

Claude: [Performs the command]
        Results: ...
\`\`\`
EOF

echo ""
echo -e "${GREEN}Command created successfully!${NC}"
echo ""
echo -e "File: ${CYAN}$COMMAND_FILE${NC}"
echo -e "Invoke with: ${CYAN}/ltk:$COMMAND_NAME${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Edit $COMMAND_FILE"
echo "2. Add detailed instructions for Claude"
echo "3. Test with /ltk:$COMMAND_NAME"
echo ""
