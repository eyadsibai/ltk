#!/bin/bash
#
# Skill Generator for ltk
# Quickly scaffold new skills with proper structure
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
SKILLS_DIR="$SCRIPT_DIR/skills"

show_help() {
    echo -e "${BLUE}Skill Generator for ltk${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS] <skill-name>"
    echo ""
    echo "Options:"
    echo "  -c, --category <cat>   Category folder (core, python, javascript, go, rust, or custom)"
    echo "  -t, --template <type>  Template type: minimal, standard, full (default: standard)"
    echo "  -d, --description      Interactive mode - prompts for description"
    echo "  -l, --list             List existing skills"
    echo "  -h, --help             Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 django                           # Creates skills/python/django/"
    echo "  $0 -c javascript react-hooks        # Creates skills/javascript/react-hooks/"
    echo "  $0 -c core caching                  # Creates skills/core/caching/"
    echo "  $0 -t full -d kubernetes            # Full template with interactive prompts"
    echo ""
    echo "Categories:"
    echo "  core        - Language-agnostic skills"
    echo "  python      - Python-specific skills"
    echo "  javascript  - JavaScript/TypeScript skills"
    echo "  go          - Go-specific skills"
    echo "  rust        - Rust-specific skills"
    echo "  <custom>    - Any custom category (creates if doesn't exist)"
    echo ""
}

list_skills() {
    echo -e "${BLUE}Existing Skills${NC}"
    echo "==============="
    echo ""

    for category in "$SKILLS_DIR"/*/; do
        if [ -d "$category" ]; then
            cat_name=$(basename "$category")
            echo -e "${CYAN}$cat_name/${NC}"

            for skill in "$category"*/; do
                if [ -d "$skill" ] && [ -f "$skill/SKILL.md" ]; then
                    skill_name=$(basename "$skill")
                    # Extract description from SKILL.md
                    desc=$(grep -m1 "^description:" "$skill/SKILL.md" 2>/dev/null | cut -d'"' -f2 | head -c 60)
                    echo "  - $skill_name"
                fi
            done
            echo ""
        fi
    done
}

# Default values
CATEGORY=""
TEMPLATE="standard"
INTERACTIVE=false
SKILL_NAME=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--list)
            list_skills
            exit 0
            ;;
        -c|--category)
            CATEGORY="$2"
            shift 2
            ;;
        -t|--template)
            TEMPLATE="$2"
            shift 2
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
            SKILL_NAME="$1"
            shift
            ;;
    esac
done

# Validate skill name
if [ -z "$SKILL_NAME" ]; then
    echo -e "${RED}Error: Skill name required${NC}"
    show_help
    exit 1
fi

# Convert to kebab-case
SKILL_NAME=$(echo "$SKILL_NAME" | tr '[:upper:]' '[:lower:]' | tr ' _' '-')

# Auto-detect category if not specified
if [ -z "$CATEGORY" ]; then
    echo -e "${YELLOW}No category specified. Select one:${NC}"
    echo "  1) core        - Language-agnostic"
    echo "  2) python      - Python-specific"
    echo "  3) javascript  - JavaScript/TypeScript"
    echo "  4) go          - Go-specific"
    echo "  5) rust        - Rust-specific"
    echo "  6) custom      - Enter custom category"
    echo ""
    read -p "Choice [1-6]: " choice

    case $choice in
        1) CATEGORY="core" ;;
        2) CATEGORY="python" ;;
        3) CATEGORY="javascript" ;;
        4) CATEGORY="go" ;;
        5) CATEGORY="rust" ;;
        6)
            read -p "Enter custom category name: " CATEGORY
            CATEGORY=$(echo "$CATEGORY" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
fi

SKILL_DIR="$SKILLS_DIR/$CATEGORY/$SKILL_NAME"

# Check if skill already exists
if [ -d "$SKILL_DIR" ]; then
    echo -e "${RED}Error: Skill already exists at $SKILL_DIR${NC}"
    exit 1
fi

# Get description if interactive
DESCRIPTION=""
TRIGGERS=""
if [ "$INTERACTIVE" = true ]; then
    echo ""
    echo -e "${CYAN}Skill Configuration${NC}"
    echo "==================="
    echo ""
    read -p "Brief description (what does this skill do?): " DESCRIPTION
    echo ""
    echo "Enter trigger phrases (comma-separated)."
    echo "Example: Django models, Django ORM, Django migrations"
    read -p "Triggers: " TRIGGERS
fi

# Create skill directory
mkdir -p "$SKILL_DIR"

# Generate human-readable name
SKILL_DISPLAY_NAME=$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Build description
if [ -z "$DESCRIPTION" ]; then
    DESCRIPTION="Guidance for $SKILL_DISPLAY_NAME development and best practices."
fi

# Build trigger list
if [ -z "$TRIGGERS" ]; then
    TRIGGERS="\"$SKILL_DISPLAY_NAME\", \"$SKILL_NAME patterns\", \"$SKILL_NAME best practices\""
else
    # Convert comma-separated to quoted list
    TRIGGERS=$(echo "$TRIGGERS" | sed 's/,/", "/g' | sed 's/^/"/' | sed 's/$/"/')
fi

# Generate SKILL.md based on template
case $TEMPLATE in
    minimal)
        cat > "$SKILL_DIR/SKILL.md" << EOF
---
name: $SKILL_DISPLAY_NAME
description: This skill should be used when the user asks about $TRIGGERS, or mentions $SKILL_DISPLAY_NAME development.
version: 1.0.0
---

# $SKILL_DISPLAY_NAME

$DESCRIPTION

## Overview

[Add overview content here]

## Key Concepts

[Add key concepts here]

## Best Practices

[Add best practices here]
EOF
        ;;

    full)
        mkdir -p "$SKILL_DIR/references"
        mkdir -p "$SKILL_DIR/examples"

        cat > "$SKILL_DIR/SKILL.md" << EOF
---
name: $SKILL_DISPLAY_NAME
description: This skill should be used when the user asks about $TRIGGERS, or mentions $SKILL_DISPLAY_NAME development.
version: 1.0.0
---

# $SKILL_DISPLAY_NAME

$DESCRIPTION

## Overview

[Provide a high-level overview of $SKILL_DISPLAY_NAME]

## Core Concepts

### Concept 1

[Explain key concept]

### Concept 2

[Explain key concept]

## Common Patterns

### Pattern 1

\`\`\`python
# Example code
\`\`\`

### Pattern 2

\`\`\`python
# Example code
\`\`\`

## Best Practices

1. **Practice 1**: Description
2. **Practice 2**: Description
3. **Practice 3**: Description

## Common Pitfalls

- **Pitfall 1**: How to avoid
- **Pitfall 2**: How to avoid

## Project Structure

\`\`\`
project/
├── src/
└── tests/
\`\`\`

## Additional Resources

### References
- See \`references/\` for detailed documentation

### Examples
- See \`examples/\` for working code samples
EOF

        # Create placeholder reference
        cat > "$SKILL_DIR/references/detailed-guide.md" << EOF
# $SKILL_DISPLAY_NAME Detailed Guide

[Add detailed reference documentation here]
EOF

        # Create placeholder example
        cat > "$SKILL_DIR/examples/example.py" << EOF
# $SKILL_DISPLAY_NAME Example

# TODO: Add working example code
EOF
        ;;

    *)  # standard
        cat > "$SKILL_DIR/SKILL.md" << EOF
---
name: $SKILL_DISPLAY_NAME
description: This skill should be used when the user asks about $TRIGGERS, or mentions $SKILL_DISPLAY_NAME development.
version: 1.0.0
---

# $SKILL_DISPLAY_NAME

$DESCRIPTION

## Overview

[Provide overview of $SKILL_DISPLAY_NAME]

## Core Concepts

### Concept 1

[Explain concept]

\`\`\`python
# Example code
\`\`\`

### Concept 2

[Explain concept]

## Common Patterns

### Pattern 1

\`\`\`python
# Example implementation
\`\`\`

## Best Practices

1. **Practice 1**: Description
2. **Practice 2**: Description

## Common Pitfalls

- **Pitfall 1**: How to avoid

## Project Structure

\`\`\`
project/
├── src/
└── tests/
\`\`\`
EOF
        ;;
esac

echo ""
echo -e "${GREEN}Skill created successfully!${NC}"
echo ""
echo -e "Location: ${CYAN}$SKILL_DIR${NC}"
echo ""
echo "Files created:"
find "$SKILL_DIR" -type f | while read file; do
    echo "  - ${file#$SKILL_DIR/}"
done
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Edit $SKILL_DIR/SKILL.md"
echo "2. Add your content and examples"
echo "3. Test by asking Claude about '$SKILL_DISPLAY_NAME'"
echo ""
