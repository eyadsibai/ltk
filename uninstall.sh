#!/bin/bash
#
# ltk Uninstall Script
# Removes the ltk plugin from a project directory
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TARGET_DIR="${1:-.}"

# Resolve to absolute path
if [ "$TARGET_DIR" = "." ]; then
    TARGET_DIR="$(pwd)"
else
    TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
        echo -e "${RED}Error: Directory not found: $TARGET_DIR${NC}"
        exit 1
    }
fi

PLUGIN_DIR="$TARGET_DIR/.claude-plugin"
CONFIG_FILE="$TARGET_DIR/.claude/ltk.local.md"

echo "ltk Uninstall"
echo "======================="
echo ""
echo "Target: $TARGET_DIR"
echo ""

# Check what exists
FOUND_PLUGIN=false
FOUND_CONFIG=false

if [ -d "$PLUGIN_DIR" ] || [ -L "$PLUGIN_DIR" ]; then
    FOUND_PLUGIN=true
fi

if [ -f "$CONFIG_FILE" ]; then
    FOUND_CONFIG=true
fi

if [ "$FOUND_PLUGIN" = false ] && [ "$FOUND_CONFIG" = false ]; then
    echo -e "${YELLOW}No ltk installation found${NC}"
    exit 0
fi

# Show what will be removed
echo "The following will be removed:"
if [ "$FOUND_PLUGIN" = true ]; then
    echo "  - $PLUGIN_DIR"
fi
if [ "$FOUND_CONFIG" = true ]; then
    echo "  - $CONFIG_FILE"
fi
echo ""

read -p "Proceed with uninstall? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo -e "${YELLOW}Uninstall cancelled${NC}"
    exit 0
fi

# Remove components
if [ "$FOUND_PLUGIN" = true ]; then
    rm -rf "$PLUGIN_DIR"
    echo -e "${GREEN}✓${NC} Removed plugin directory"
fi

if [ "$FOUND_CONFIG" = true ]; then
    rm "$CONFIG_FILE"
    echo -e "${GREEN}✓${NC} Removed config file"

    # Remove .claude directory if empty
    if [ -d "$TARGET_DIR/.claude" ] && [ -z "$(ls -A "$TARGET_DIR/.claude")" ]; then
        rmdir "$TARGET_DIR/.claude"
        echo -e "${GREEN}✓${NC} Removed empty .claude directory"
    fi
fi

echo ""
echo -e "${GREEN}Uninstall complete!${NC}"
