#!/bin/bash
#
# ltk Installation Script
# Installs the ltk plugin into a project directory
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
TARGET_DIR=""
INSTALL_MODE="copy"  # copy or link
CREATE_CONFIG=true
SKIP_MCP=false

# Help message
show_help() {
    echo "ltk Installation Script"
    echo ""
    echo "Usage: $0 [OPTIONS] <target-directory>"
    echo ""
    echo "Options:"
    echo "  -h, --help           Show this help message"
    echo "  -l, --link           Create symlink instead of copying (for development)"
    echo "  -n, --no-config      Skip creating config template"
    echo "  -m, --no-mcp         Skip MCP server configuration"
    echo "  --minimal            Install only essential components"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/project          Install to project directory"
    echo "  $0 .                          Install to current directory"
    echo "  $0 -l ~/projects/myapp        Symlink for development"
    echo ""
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--link)
            INSTALL_MODE="link"
            shift
            ;;
        -n|--no-config)
            CREATE_CONFIG=false
            shift
            ;;
        -m|--no-mcp)
            SKIP_MCP=true
            shift
            ;;
        --minimal)
            MINIMAL_INSTALL=true
            shift
            ;;
        -*)
            echo -e "${RED}Error: Unknown option $1${NC}"
            show_help
            exit 1
            ;;
        *)
            TARGET_DIR="$1"
            shift
            ;;
    esac
done

# Check if target directory was provided
if [ -z "$TARGET_DIR" ]; then
    echo -e "${RED}Error: No target directory specified${NC}"
    show_help
    exit 1
fi

# Resolve target directory to absolute path
if [ "$TARGET_DIR" = "." ]; then
    TARGET_DIR="$(pwd)"
else
    TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
        echo -e "${YELLOW}Creating target directory: $TARGET_DIR${NC}"
        mkdir -p "$TARGET_DIR"
        TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
    }
fi

PLUGIN_TARGET="$TARGET_DIR/.claude-plugin"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  ltk Installation${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Source:      ${SCRIPT_DIR}"
echo -e "Target:      ${TARGET_DIR}"
echo -e "Mode:        ${INSTALL_MODE}"
echo ""

# Check if .claude-plugin already exists
if [ -d "$PLUGIN_TARGET" ]; then
    echo -e "${YELLOW}Warning: .claude-plugin directory already exists${NC}"
    read -p "Overwrite existing installation? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo -e "${RED}Installation cancelled${NC}"
        exit 1
    fi
    rm -rf "$PLUGIN_TARGET"
fi

# Install the plugin
echo -e "${GREEN}Installing plugin...${NC}"

if [ "$INSTALL_MODE" = "link" ]; then
    # Create symlink for development
    ln -s "$SCRIPT_DIR" "$PLUGIN_TARGET"
    echo -e "  ${GREEN}✓${NC} Created symlink to source"
else
    # Copy plugin files
    mkdir -p "$PLUGIN_TARGET"

    # Copy core files
    cp -r "$SCRIPT_DIR/.claude-plugin" "$PLUGIN_TARGET/../" 2>/dev/null || true
    cp -r "$SCRIPT_DIR/commands" "$PLUGIN_TARGET/../.claude-plugin/" 2>/dev/null || {
        mkdir -p "$PLUGIN_TARGET/commands"
        cp "$SCRIPT_DIR/commands/"*.md "$PLUGIN_TARGET/commands/"
    }

    # Restructure - plugin needs specific layout
    rm -rf "$PLUGIN_TARGET"
    mkdir -p "$PLUGIN_TARGET"

    # Copy plugin.json
    cp "$SCRIPT_DIR/.claude-plugin/plugin.json" "$PLUGIN_TARGET/"

    # Copy components to plugin directory
    cp -r "$SCRIPT_DIR/commands" "$PLUGIN_TARGET/"
    cp -r "$SCRIPT_DIR/agents" "$PLUGIN_TARGET/"
    cp -r "$SCRIPT_DIR/skills" "$PLUGIN_TARGET/"
    cp -r "$SCRIPT_DIR/hooks" "$PLUGIN_TARGET/"

    # Copy MCP config if not skipped
    if [ "$SKIP_MCP" = false ] && [ -f "$SCRIPT_DIR/.mcp.json" ]; then
        cp "$SCRIPT_DIR/.mcp.json" "$PLUGIN_TARGET/"
    fi

    # Copy README
    cp "$SCRIPT_DIR/README.md" "$PLUGIN_TARGET/"

    echo -e "  ${GREEN}✓${NC} Copied plugin files"
fi

# Create .claude directory for config
if [ "$CREATE_CONFIG" = true ]; then
    echo -e "${GREEN}Creating configuration template...${NC}"

    mkdir -p "$TARGET_DIR/.claude"

    # Create config template
    cat > "$TARGET_DIR/.claude/ltk.local.md" << 'EOF'
---
# ltk Configuration
# Customize the plugin behavior for this project

# Enable/disable proactive agents (security, quality review after edits)
proactive_agents: true

# Code quality threshold (percentage) - warn if below this
quality_threshold: 80

# Security scanning settings
security:
  # Patterns to ignore during security scans
  ignore_patterns:
    - "test_*.py"
    - "*_test.py"
    - "fixtures/"
    - "mocks/"

  # Enable/disable specific checks
  check_secrets: true
  check_dependencies: true
  check_owasp: true

# Documentation settings
documentation:
  # Docstring style: google, numpy, or sphinx
  style: google

  # Auto-generate docstrings for new functions
  auto_generate: true

# Git workflow settings
git:
  # Commit message format: conventional, simple
  commit_format: conventional

  # Run checks before commit
  pre_commit_checks: true

# Build & Deploy settings (optional)
# gcp_project: my-project-id
# deploy_target: cloud-run

---

## Project Notes

Add any project-specific notes, conventions, or instructions here.
This content will be available to Claude when using the toolkit.

### Project Structure

[Describe your project structure here]

### Coding Standards

[Document any project-specific coding standards]

### Common Tasks

[List frequently performed tasks for reference]
EOF

    echo -e "  ${GREEN}✓${NC} Created .claude/ltk.local.md"
fi

# Create .gitignore entry suggestion
echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Next Steps${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "1. Add to .gitignore (recommended for personal configs):"
echo "   echo '.claude/*.local.md' >> .gitignore"
echo ""
echo "2. Customize your configuration:"
echo "   Edit: $TARGET_DIR/.claude/ltk.local.md"
echo ""
echo "3. Start Claude Code in your project:"
echo "   cd $TARGET_DIR && claude"
echo ""
echo "4. Try a command:"
echo "   /ltk:scan-security"
echo "   /ltk:check-quality"
echo ""

# Environment variables reminder
if [ "$SKIP_MCP" = false ]; then
    echo -e "${YELLOW}For MCP integrations, set these environment variables:${NC}"
    echo "   export GITHUB_TOKEN=your_github_token"
    echo "   export DATABASE_URL=postgresql://..."
    echo ""
fi

echo -e "${GREEN}Happy coding!${NC}"
