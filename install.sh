#!/bin/bash
#
# ltk Installation Script
# Installs ltk plugins into a project directory
# Supports selective plugin installation
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
TARGET_DIR=""
INSTALL_MODE="copy"  # copy or link
CREATE_CONFIG=true
SKIP_MCP=false

# Plugin selection (defaults to all)
INSTALL_CORE=false
INSTALL_ENGINEERING=false
INSTALL_DATA=false
INSTALL_DEVOPS=false
INSTALL_DESIGN=false
INSTALL_PRODUCT=false
INSTALL_GITHUB=false
INSTALL_ALL=false
INSTALL_PRESET=""

# Available plugins (exported for use by other scripts)
export AVAILABLE_PLUGINS=("ltk-core" "ltk-engineering" "ltk-data" "ltk-devops" "ltk-design" "ltk-product" "ltk-github")

# Help message
show_help() {
    echo -e "${BLUE}ltk Installation Script${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS] <target-directory>"
    echo ""
    echo -e "${CYAN}Plugin Selection:${NC}"
    echo "  --all                Install all plugins"
    echo "  --core               Install ltk-core (context engineering, foundations)"
    echo "  --engineering        Install ltk-engineering (code quality, testing)"
    echo "  --data               Install ltk-data (databases, ML, analytics)"
    echo "  --devops             Install ltk-devops (infrastructure, security)"
    echo "  --design             Install ltk-design (UI/UX, accessibility)"
    echo "  --product            Install ltk-product (product management)"
    echo "  --github             Install ltk-github (git workflows, PRs)"
    echo ""
    echo -e "${CYAN}Presets:${NC}"
    echo "  --preset=minimal     Core only"
    echo "  --preset=developer   Core + Engineering + GitHub"
    echo "  --preset=fullstack   Core + Engineering + Data + GitHub"
    echo "  --preset=devops      Core + DevOps + GitHub"
    echo "  --preset=design      Core + Design"
    echo "  --preset=product     Core + Product"
    echo ""
    echo -e "${CYAN}Other Options:${NC}"
    echo "  -h, --help           Show this help message"
    echo "  -l, --link           Create symlink instead of copying (for development)"
    echo "  -n, --no-config      Skip creating config template"
    echo "  -m, --no-mcp         Skip MCP server configuration"
    echo "  --list               List available plugins and presets"
    echo ""
    echo -e "${CYAN}Examples:${NC}"
    echo "  $0 --all /path/to/project              Install all plugins"
    echo "  $0 --core --engineering .              Install core + engineering"
    echo "  $0 --preset=developer ~/myproject      Use developer preset"
    echo "  $0 -l --all ~/dev/myapp                Symlink for development"
    echo ""
}

# List plugins
list_plugins() {
    echo -e "${BLUE}Available Plugins:${NC}"
    echo ""
    echo -e "  ${GREEN}ltk-core${NC}        Context engineering, memory, agents, foundations"
    echo -e "  ${GREEN}ltk-engineering${NC} Software development, testing, architecture"
    echo -e "  ${GREEN}ltk-data${NC}        Data processing, databases, ML, analytics"
    echo -e "  ${GREEN}ltk-devops${NC}      Infrastructure, Kubernetes, security"
    echo -e "  ${GREEN}ltk-design${NC}      UI/UX, accessibility, design systems"
    echo -e "  ${GREEN}ltk-product${NC}     Product management, marketing, business"
    echo -e "  ${GREEN}ltk-github${NC}      GitHub workflows, PRs, commits"
    echo ""
    echo -e "${BLUE}Presets:${NC}"
    echo ""
    echo -e "  ${CYAN}minimal${NC}    ltk-core"
    echo -e "  ${CYAN}developer${NC}  ltk-core + ltk-engineering + ltk-github"
    echo -e "  ${CYAN}fullstack${NC}  ltk-core + ltk-engineering + ltk-data + ltk-github"
    echo -e "  ${CYAN}devops${NC}     ltk-core + ltk-devops + ltk-github"
    echo -e "  ${CYAN}design${NC}     ltk-core + ltk-design"
    echo -e "  ${CYAN}product${NC}    ltk-core + ltk-product"
    echo -e "  ${CYAN}all${NC}        All plugins"
    echo ""
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --list)
            list_plugins
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
        --all)
            INSTALL_ALL=true
            shift
            ;;
        --core)
            INSTALL_CORE=true
            shift
            ;;
        --engineering)
            INSTALL_ENGINEERING=true
            shift
            ;;
        --data)
            INSTALL_DATA=true
            shift
            ;;
        --devops)
            INSTALL_DEVOPS=true
            shift
            ;;
        --design)
            INSTALL_DESIGN=true
            shift
            ;;
        --product)
            INSTALL_PRODUCT=true
            shift
            ;;
        --github)
            INSTALL_GITHUB=true
            shift
            ;;
        --preset=*)
            INSTALL_PRESET="${1#*=}"
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

# Apply preset if specified
if [ -n "$INSTALL_PRESET" ]; then
    case $INSTALL_PRESET in
        minimal)
            INSTALL_CORE=true
            ;;
        developer)
            INSTALL_CORE=true
            INSTALL_ENGINEERING=true
            INSTALL_GITHUB=true
            ;;
        fullstack)
            INSTALL_CORE=true
            INSTALL_ENGINEERING=true
            INSTALL_DATA=true
            INSTALL_GITHUB=true
            ;;
        devops)
            INSTALL_CORE=true
            INSTALL_DEVOPS=true
            INSTALL_GITHUB=true
            ;;
        design)
            INSTALL_CORE=true
            INSTALL_DESIGN=true
            ;;
        product)
            INSTALL_CORE=true
            INSTALL_PRODUCT=true
            ;;
        all)
            INSTALL_ALL=true
            ;;
        *)
            echo -e "${RED}Error: Unknown preset '$INSTALL_PRESET'${NC}"
            echo "Available presets: minimal, developer, fullstack, devops, design, product, all"
            exit 1
            ;;
    esac
fi

# If --all is set, enable all plugins
if [ "$INSTALL_ALL" = true ]; then
    INSTALL_CORE=true
    INSTALL_ENGINEERING=true
    INSTALL_DATA=true
    INSTALL_DEVOPS=true
    INSTALL_DESIGN=true
    INSTALL_PRODUCT=true
    INSTALL_GITHUB=true
fi

# Check if any plugin was selected
if [ "$INSTALL_CORE" = false ] && [ "$INSTALL_ENGINEERING" = false ] && \
   [ "$INSTALL_DATA" = false ] && [ "$INSTALL_DEVOPS" = false ] && \
   [ "$INSTALL_DESIGN" = false ] && [ "$INSTALL_PRODUCT" = false ] && \
   [ "$INSTALL_GITHUB" = false ]; then
    echo -e "${YELLOW}No plugins selected. Defaulting to --preset=developer${NC}"
    INSTALL_CORE=true
    INSTALL_ENGINEERING=true
    INSTALL_GITHUB=true
fi

# Always ensure core is installed (it's a dependency for others)
if [ "$INSTALL_CORE" = false ]; then
    echo -e "${YELLOW}Note: ltk-core is required and will be installed${NC}"
    INSTALL_CORE=true
fi

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

# Build list of plugins to install
SELECTED_PLUGINS=()
[ "$INSTALL_CORE" = true ] && SELECTED_PLUGINS+=("ltk-core")
[ "$INSTALL_ENGINEERING" = true ] && SELECTED_PLUGINS+=("ltk-engineering")
[ "$INSTALL_DATA" = true ] && SELECTED_PLUGINS+=("ltk-data")
[ "$INSTALL_DEVOPS" = true ] && SELECTED_PLUGINS+=("ltk-devops")
[ "$INSTALL_DESIGN" = true ] && SELECTED_PLUGINS+=("ltk-design")
[ "$INSTALL_PRODUCT" = true ] && SELECTED_PLUGINS+=("ltk-product")
[ "$INSTALL_GITHUB" = true ] && SELECTED_PLUGINS+=("ltk-github")

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  ltk Installation${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Source:      ${SCRIPT_DIR}"
echo -e "Target:      ${TARGET_DIR}"
echo -e "Mode:        ${INSTALL_MODE}"
echo -e "Plugins:     ${SELECTED_PLUGINS[*]}"
echo ""

# Check if .claude-plugin already exists
if [ -d "$PLUGIN_TARGET" ]; then
    echo -e "${YELLOW}Warning: .claude-plugin directory already exists${NC}"
    read -rp "Overwrite existing installation? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo -e "${RED}Installation cancelled${NC}"
        exit 1
    fi
    rm -rf "$PLUGIN_TARGET"
fi

# Install the plugins
echo -e "${GREEN}Installing plugins...${NC}"

if [ "$INSTALL_MODE" = "link" ]; then
    # For symlink mode, link the entire plugins directory
    mkdir -p "$PLUGIN_TARGET"

    for plugin in "${SELECTED_PLUGINS[@]}"; do
        ln -s "$SCRIPT_DIR/plugins/$plugin" "$PLUGIN_TARGET/$plugin"
        echo -e "  ${GREEN}✓${NC} Linked $plugin"
    done

    # Link marketplace.json
    ln -s "$SCRIPT_DIR/plugins/marketplace.json" "$PLUGIN_TARGET/marketplace.json"

    # Create combined plugin.json
    create_combined_plugin_json
else
    # Copy plugin files
    mkdir -p "$PLUGIN_TARGET"
    mkdir -p "$PLUGIN_TARGET/skills"
    mkdir -p "$PLUGIN_TARGET/agents"
    mkdir -p "$PLUGIN_TARGET/commands"
    mkdir -p "$PLUGIN_TARGET/hooks"

    # Copy marketplace.json
    cp "$SCRIPT_DIR/plugins/marketplace.json" "$PLUGIN_TARGET/"

    # Copy each selected plugin's contents
    for plugin in "${SELECTED_PLUGINS[@]}"; do
        PLUGIN_SRC="$SCRIPT_DIR/plugins/$plugin"

        if [ -d "$PLUGIN_SRC/skills" ]; then
            cp -r "$PLUGIN_SRC/skills/"* "$PLUGIN_TARGET/skills/" 2>/dev/null || true
        fi

        if [ -d "$PLUGIN_SRC/agents" ]; then
            cp -r "$PLUGIN_SRC/agents/"* "$PLUGIN_TARGET/agents/" 2>/dev/null || true
        fi

        if [ -d "$PLUGIN_SRC/commands" ]; then
            cp -r "$PLUGIN_SRC/commands/"* "$PLUGIN_TARGET/commands/" 2>/dev/null || true
        fi

        if [ -d "$PLUGIN_SRC/hooks" ] && [ -f "$PLUGIN_SRC/hooks/hooks.json" ]; then
            # Merge hooks (simplified - just copy for now)
            if [ -f "$PLUGIN_SRC/hooks/hooks.json" ]; then
                cp "$PLUGIN_SRC/hooks/"* "$PLUGIN_TARGET/hooks/" 2>/dev/null || true
            fi
        fi

        echo -e "  ${GREEN}✓${NC} Installed $plugin"
    done

    # Create combined plugin.json
    cat > "$PLUGIN_TARGET/plugin.json" << EOF
{
  "name": "ltk",
  "version": "1.0.0",
  "description": "LTK Plugin Collection - ${SELECTED_PLUGINS[*]}",
  "author": "LTK",
  "components": {
    "skills": "skills/",
    "agents": "agents/",
    "commands": "commands/",
    "hooks": "hooks/"
  },
  "installed_plugins": [$(printf '"%s",' "${SELECTED_PLUGINS[@]}" | sed 's/,$//')]
}
EOF

    # Copy MCP config if not skipped
    if [ "$SKIP_MCP" = false ] && [ -f "$SCRIPT_DIR/.mcp.json" ]; then
        cp "$SCRIPT_DIR/.mcp.json" "$PLUGIN_TARGET/"
    fi

    echo -e "  ${GREEN}✓${NC} Created combined plugin.json"
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

# Count installed components
SKILL_COUNT=$(find "$PLUGIN_TARGET/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
AGENT_COUNT=$(find "$PLUGIN_TARGET/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
COMMAND_COUNT=$(find "$PLUGIN_TARGET/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

# Create .gitignore entry suggestion
echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Installation Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "  Plugins:   ${#SELECTED_PLUGINS[@]}"
echo -e "  Skills:    $SKILL_COUNT"
echo -e "  Agents:    $AGENT_COUNT"
echo -e "  Commands:  $COMMAND_COUNT"
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
