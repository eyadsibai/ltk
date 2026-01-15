---
name: webapp-testing
description: Use when testing "web application", "Playwright", "browser automation", "UI testing", "frontend testing", "E2E testing", "end-to-end tests", or asking about "test local webapp", "browser screenshots", "DOM inspection"
version: 1.0.0
---

<!-- Adapted from: awesome-claude-skills/webapp-testing -->

# Web Application Testing with Playwright

Test local web applications using Python Playwright scripts.

## Decision Tree

```
Is it static HTML?
├─ Yes → Read HTML file directly to identify selectors
│         ├─ Success → Write Playwright script using selectors
│         └─ Fails → Treat as dynamic (below)
│
└─ No (dynamic webapp) → Is the server already running?
    ├─ No → Start server, then test
    └─ Yes → Reconnaissance-then-action:
        1. Navigate and wait for networkidle
        2. Take screenshot or inspect DOM
        3. Identify selectors from rendered state
        4. Execute actions with discovered selectors
```

## Basic Playwright Script

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto('http://localhost:5173')
    page.wait_for_load_state('networkidle')  # CRITICAL: Wait for JS

    # Your automation logic here
    page.screenshot(path='screenshot.png')

    browser.close()
```

## Reconnaissance-Then-Action Pattern

### 1. Inspect Rendered DOM

```python
# Take screenshot for visual inspection
page.screenshot(path='/tmp/inspect.png', full_page=True)

# Get page content
content = page.content()

# Find all buttons
buttons = page.locator('button').all()
for btn in buttons:
    print(btn.inner_text())
```

### 2. Identify Selectors

```python
# Find elements by text
page.locator('text=Submit').click()

# Find by role
page.locator('role=button[name="Save"]').click()

# Find by CSS
page.locator('#submit-btn').click()
page.locator('.primary-action').click()
```

### 3. Execute Actions

```python
# Click
page.locator('button:has-text("Login")').click()

# Fill form
page.locator('input[name="email"]').fill('user@example.com')
page.locator('input[name="password"]').fill('password123')

# Wait and verify
page.wait_for_selector('.success-message')
assert page.locator('.success-message').is_visible()
```

## Common Pitfall

```python
# ❌ WRONG: Inspecting before page loads
page.goto('http://localhost:5173')
content = page.content()  # May be incomplete!

# ✅ CORRECT: Wait for network idle first
page.goto('http://localhost:5173')
page.wait_for_load_state('networkidle')
content = page.content()  # Now complete
```

## Capture Console Logs

```python
from playwright.sync_api import sync_playwright

def handle_console(msg):
    print(f"Console {msg.type}: {msg.text}")

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.on('console', handle_console)
    page.goto('http://localhost:5173')
    page.wait_for_load_state('networkidle')
    browser.close()
```

## Testing with Server Management

```python
import subprocess
import time
from playwright.sync_api import sync_playwright

# Start server
server = subprocess.Popen(['npm', 'run', 'dev'], cwd='./frontend')
time.sleep(5)  # Wait for server to start

try:
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto('http://localhost:5173')
        page.wait_for_load_state('networkidle')
        # ... tests ...
        browser.close()
finally:
    server.terminate()
```

## Best Practices

1. **Always use headless mode**: `browser = p.chromium.launch(headless=True)`
2. **Always wait for networkidle**: `page.wait_for_load_state('networkidle')`
3. **Always close browser**: Use `with` statement or explicit `browser.close()`
4. **Use descriptive selectors**: `text=`, `role=`, CSS selectors, or IDs
5. **Add appropriate waits**: `page.wait_for_selector()` or `page.wait_for_timeout()`

## Required Packages

```bash
pip install playwright
playwright install chromium
```
