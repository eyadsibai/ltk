#!/bin/bash
#
# Hook Helper for ltk
# Adds new hooks to hooks.json
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
HOOKS_FILE="$SCRIPT_DIR/hooks/hooks.json"
HOOKS_SCRIPTS_DIR="$SCRIPT_DIR/hooks/scripts"

# Valid events
VALID_EVENTS="SessionStart SessionEnd PreToolUse PostToolUse Stop Notification UserPromptSubmit PreCompact"

show_help() {
    echo -e "${BLUE}Hook Helper for ltk${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -e, --event <event>    Event type (required)"
    echo "  -t, --type <type>      Hook type: command or prompt (default: prompt)"
    echo "  -m, --matcher <regex>  Tool matcher for Pre/PostToolUse (e.g., 'Write|Edit')"
    echo "  -l, --list             List existing hooks"
    echo "  -h, --help             Show this help"
    echo ""
    echo "Events:"
    echo "  SessionStart      - When Claude Code session begins"
    echo "  SessionEnd        - When session ends"
    echo "  PreToolUse        - Before a tool runs (use --matcher)"
    echo "  PostToolUse       - After a tool runs (use --matcher)"
    echo "  Stop              - When Claude finishes a response"
    echo "  Notification      - For long-running task alerts"
    echo "  UserPromptSubmit  - When user submits a prompt"
    echo "  PreCompact        - Before context compaction"
    echo ""
    echo "Examples:"
    echo "  $0 -e SessionStart                    # Add session start hook"
    echo "  $0 -e PreToolUse -m 'Write|Edit'      # Add pre-write hook"
    echo "  $0 -e PostToolUse -m Bash -t command  # Add post-bash command hook"
    echo ""
}

list_hooks() {
    echo -e "${BLUE}Existing Hooks${NC}"
    echo "=============="
    echo ""

    if [ ! -f "$HOOKS_FILE" ]; then
        echo "No hooks configured yet."
        return
    fi

    # Parse hooks.json and display
    python3 -c "
import json
import sys

try:
    with open('$HOOKS_FILE', 'r') as f:
        data = json.load(f)

    hooks = data.get('hooks', [])
    if not hooks:
        print('No hooks configured.')
        sys.exit(0)

    for i, hook in enumerate(hooks, 1):
        event = hook.get('event', 'Unknown')
        htype = hook.get('type', 'Unknown')
        matcher = hook.get('matcher', '')
        timeout = hook.get('timeout', 'default')

        print(f'  {i}. {event}', end='')
        if matcher:
            print(f' (matcher: {matcher})', end='')
        print(f' [{htype}]')

        if htype == 'command':
            cmd = hook.get('command', '')[:50]
            print(f'      Command: {cmd}...')
        elif htype == 'prompt':
            prompt = hook.get('prompt', '')[:50]
            print(f'      Prompt: {prompt}...')
        print()
except Exception as e:
    print(f'Error reading hooks: {e}')
" 2>/dev/null || echo "Could not parse hooks.json"
    echo ""
}

# Default values
EVENT=""
HOOK_TYPE="prompt"
MATCHER=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--list)
            list_hooks
            exit 0
            ;;
        -e|--event)
            EVENT="$2"
            shift 2
            ;;
        -t|--type)
            HOOK_TYPE="$2"
            shift 2
            ;;
        -m|--matcher)
            MATCHER="$2"
            shift 2
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
        *)
            shift
            ;;
    esac
done

# Validate event
if [ -z "$EVENT" ]; then
    echo -e "${YELLOW}Select an event type:${NC}"
    echo ""
    echo "  1) SessionStart     - When session begins"
    echo "  2) SessionEnd       - When session ends"
    echo "  3) PreToolUse       - Before a tool runs"
    echo "  4) PostToolUse      - After a tool runs"
    echo "  5) Stop             - When Claude finishes responding"
    echo "  6) Notification     - For long-running task alerts"
    echo "  7) UserPromptSubmit - When user submits prompt"
    echo ""
    read -p "Choice [1-7]: " choice

    case $choice in
        1) EVENT="SessionStart" ;;
        2) EVENT="SessionEnd" ;;
        3) EVENT="PreToolUse" ;;
        4) EVENT="PostToolUse" ;;
        5) EVENT="Stop" ;;
        6) EVENT="Notification" ;;
        7) EVENT="UserPromptSubmit" ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
fi

# Validate event is valid
if ! echo "$VALID_EVENTS" | grep -qw "$EVENT"; then
    echo -e "${RED}Error: Invalid event '$EVENT'${NC}"
    echo "Valid events: $VALID_EVENTS"
    exit 1
fi

# Get matcher for PreToolUse/PostToolUse
if [[ "$EVENT" == "PreToolUse" || "$EVENT" == "PostToolUse" ]] && [ -z "$MATCHER" ]; then
    echo ""
    echo -e "${YELLOW}Which tools should trigger this hook?${NC}"
    echo "Enter regex pattern (e.g., 'Write|Edit' or 'Bash' or '.*' for all)"
    read -p "Matcher: " MATCHER
fi

# Get hook type if not specified
echo ""
echo -e "${YELLOW}Hook type:${NC}"
echo "  1) prompt  - Claude evaluates a prompt (flexible, AI-powered)"
echo "  2) command - Run a shell command (fast, deterministic)"
read -p "Choice [1-2] (default: prompt): " type_choice

case $type_choice in
    2) HOOK_TYPE="command" ;;
    *) HOOK_TYPE="prompt" ;;
esac

# Get hook content
echo ""
HOOK_CONTENT=""
if [ "$HOOK_TYPE" = "prompt" ]; then
    echo -e "${YELLOW}Enter the prompt for Claude to evaluate:${NC}"
    echo "(This tells Claude what to check/do when the hook triggers)"
    echo ""
    read -p "Prompt: " HOOK_CONTENT
else
    echo -e "${YELLOW}Enter the command to run:${NC}"
    echo "(Use \${CLAUDE_PLUGIN_ROOT} for plugin path)"
    echo ""
    read -p "Command: " HOOK_CONTENT
fi

# Get timeout
echo ""
read -p "Timeout in ms (default: 10000): " TIMEOUT
TIMEOUT=${TIMEOUT:-10000}

# Create hooks directory if needed
mkdir -p "$(dirname "$HOOKS_FILE")"
mkdir -p "$HOOKS_SCRIPTS_DIR"

# Initialize hooks.json if it doesn't exist
if [ ! -f "$HOOKS_FILE" ]; then
    echo '{"hooks": []}' > "$HOOKS_FILE"
fi

# Build the new hook JSON
NEW_HOOK=$(python3 -c "
import json

hook = {
    'event': '$EVENT',
    'type': '$HOOK_TYPE',
    'timeout': $TIMEOUT
}

if '$MATCHER':
    hook['matcher'] = '$MATCHER'

if '$HOOK_TYPE' == 'prompt':
    hook['prompt'] = '''$HOOK_CONTENT'''
else:
    hook['command'] = '''$HOOK_CONTENT'''

print(json.dumps(hook))
")

# Add to hooks.json
python3 -c "
import json

with open('$HOOKS_FILE', 'r') as f:
    data = json.load(f)

new_hook = $NEW_HOOK
data['hooks'].append(new_hook)

with open('$HOOKS_FILE', 'w') as f:
    json.dump(data, f, indent=2)

print('Hook added successfully!')
"

echo ""
echo -e "${GREEN}Hook added successfully!${NC}"
echo ""
echo -e "Event: ${CYAN}$EVENT${NC}"
if [ -n "$MATCHER" ]; then
    echo -e "Matcher: ${CYAN}$MATCHER${NC}"
fi
echo -e "Type: ${CYAN}$HOOK_TYPE${NC}"
echo ""
echo -e "${YELLOW}View all hooks:${NC} $0 --list"
echo -e "${YELLOW}Edit manually:${NC} $HOOKS_FILE"
echo ""
