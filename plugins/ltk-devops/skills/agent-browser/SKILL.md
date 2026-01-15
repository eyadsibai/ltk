---
name: agent-browser
description: Use when automating browser interactions via CLI, filling forms, taking screenshots, scraping pages, or asking about "agent-browser", "browser automation", "headless browser", "web scraping", "form filling", "Vercel browser"
version: 1.0.0
---

# agent-browser: CLI Browser Automation

Vercel's headless browser automation CLI designed for AI agents. Uses ref-based selection (@e1, @e2) from accessibility snapshots.

## Setup

```bash
# Check installation
command -v agent-browser >/dev/null 2>&1 && echo "Installed" || echo "NOT INSTALLED"

# Install if needed
npm install -g agent-browser
agent-browser install  # Downloads Chromium
```

## Core Workflow

The snapshot + ref pattern is optimal for LLMs:

1. **Navigate** to URL
2. **Snapshot** to get interactive elements with refs
3. **Interact** using refs (@e1, @e2, etc.)
4. **Re-snapshot** after navigation or DOM changes

```bash
agent-browser open https://example.com
agent-browser snapshot -i          # Get refs
agent-browser click @e1            # Use ref
agent-browser fill @e2 "text"
agent-browser snapshot -i          # Re-snapshot
```

## Key Commands

### Navigation

```bash
agent-browser open <url>       # Navigate to URL
agent-browser back             # Go back
agent-browser forward          # Go forward
agent-browser reload           # Reload page
agent-browser close            # Close browser
```

### Snapshots (Essential for AI)

```bash
agent-browser snapshot              # Full accessibility tree
agent-browser snapshot -i           # Interactive elements only (recommended)
agent-browser snapshot -i --json    # JSON output for parsing
agent-browser snapshot -c           # Compact (remove empty)
agent-browser snapshot -d 3         # Limit depth
```

### Interactions

```bash
agent-browser click @e1                    # Click element
agent-browser dblclick @e1                 # Double-click
agent-browser fill @e1 "text"              # Clear and fill input
agent-browser type @e1 "text"              # Type without clearing
agent-browser press Enter                  # Press key
agent-browser hover @e1                    # Hover element
agent-browser check @e1                    # Check checkbox
agent-browser uncheck @e1                  # Uncheck
agent-browser select @e1 "option"          # Select dropdown
agent-browser scroll down 500              # Scroll
agent-browser scrollintoview @e1           # Scroll element into view
```

### Get Information

```bash
agent-browser get text @e1          # Get element text
agent-browser get html @e1          # Get element HTML
agent-browser get value @e1         # Get input value
agent-browser get attr href @e1     # Get attribute
agent-browser get title             # Get page title
agent-browser get url               # Get current URL
```

### Screenshots & PDFs

```bash
agent-browser screenshot                      # Viewport screenshot
agent-browser screenshot --full               # Full page
agent-browser screenshot output.png           # Save to file
agent-browser pdf output.pdf                  # Save as PDF
```

### Wait

```bash
agent-browser wait @e1              # Wait for element
agent-browser wait 2000             # Wait milliseconds
agent-browser wait "text"           # Wait for text
```

## Examples

### Login Flow

```bash
agent-browser open https://app.example.com/login
agent-browser snapshot -i
# Output: textbox "Email" [ref=e1], textbox "Password" [ref=e2], button "Sign in" [ref=e3]
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3
agent-browser wait 2000
agent-browser snapshot -i  # Verify logged in
```

### Form Filling

```bash
agent-browser open https://forms.example.com
agent-browser snapshot -i
agent-browser fill @e1 "John Doe"
agent-browser fill @e2 "john@example.com"
agent-browser select @e3 "United States"
agent-browser check @e4  # Agree to terms
agent-browser click @e5  # Submit
agent-browser screenshot confirmation.png
```

### Debug Mode (Visible Browser)

```bash
agent-browser --headed open https://example.com
agent-browser --headed snapshot -i
agent-browser --headed click @e1
```

## Sessions (Parallel Browsers)

```bash
agent-browser --session browser1 open https://site1.com
agent-browser --session browser2 open https://site2.com
agent-browser session list
```

## JSON Output

```bash
agent-browser snapshot -i --json
```

Returns:

```json
{
  "success": true,
  "data": {
    "refs": {
      "e1": {"name": "Submit", "role": "button"},
      "e2": {"name": "Email", "role": "textbox"}
    }
  }
}
```

## When to Use vs Alternatives

**Use agent-browser when:**

- Prefer Bash-based workflows
- Need quick one-off automation
- Want simpler CLI commands

**Use Playwright MCP when:**

- Need deep MCP tool integration
- Building complex automation pipelines
- Want tool-based responses
