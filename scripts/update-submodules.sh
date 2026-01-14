#!/usr/bin/env bash
# Update all submodules and check for changes that need syncing
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LAST_SYNC_FILE="${PLUGIN_ROOT}/.last-submodule-sync"

cd "$PLUGIN_ROOT"

echo "=== Updating Git Submodules ==="
echo ""

# Store current submodule states
declare -A BEFORE_STATES
while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        commit=$(echo "$line" | awk '{print $1}' | tr -d '-+')
        path=$(echo "$line" | awk '{print $2}')
        BEFORE_STATES["$path"]="$commit"
    fi
done < <(git submodule status 2>/dev/null)

# Update submodules
git submodule update --remote --merge 2>/dev/null || {
    echo "Note: Some submodules may not have upstream changes"
}

# Check for changes
CHANGED_SUBMODULES=()
while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        commit=$(echo "$line" | awk '{print $1}' | tr -d '-+')
        path=$(echo "$line" | awk '{print $2}')
        if [[ "${BEFORE_STATES[$path]:-}" != "$commit" ]]; then
            CHANGED_SUBMODULES+=("$path")
        fi
    fi
done < <(git submodule status 2>/dev/null)

echo ""
echo "=== Submodule Status ==="
git submodule status

if [[ ${#CHANGED_SUBMODULES[@]} -gt 0 ]]; then
    echo ""
    echo "=== Changes Detected ==="
    echo "The following submodules were updated:"
    for sm in "${CHANGED_SUBMODULES[@]}"; do
        echo "  - $sm"
    done
    echo ""
    echo ">>> Run '/ltk:sync-submodules' in Claude Code to adapt changes <<<"
    echo ""

    # Record that sync is needed
    echo "needs_sync=true" > "$LAST_SYNC_FILE"
    echo "updated_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$LAST_SYNC_FILE"
    printf "submodules=%s\n" "$(IFS=,; echo "${CHANGED_SUBMODULES[*]}")" >> "$LAST_SYNC_FILE"
else
    echo ""
    echo "No submodule changes detected."

    # Record sync status
    echo "needs_sync=false" > "$LAST_SYNC_FILE"
    echo "checked_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$LAST_SYNC_FILE"
fi
