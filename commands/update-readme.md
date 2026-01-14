---
name: update-readme
description: Update README with current project state
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Edit
  - TodoWrite
---

# Update README Command

Analyze the project and update the README.md to reflect current state.

## Execution Steps

1. **Read current README**: Load existing README.md if present.

2. **Analyze project**:
   - Detect project type and language
   - Find entry points
   - Identify key features from code
   - Check for configuration options
   - Review dependencies

3. **Check for outdated sections**:
   - Installation instructions match current setup
   - Dependencies are current
   - Usage examples still work
   - Configuration options are accurate
   - API references are correct

4. **Update sections**:
   - Project description
   - Features list
   - Installation instructions
   - Quick start / Usage
   - Configuration
   - API reference (if applicable)
   - Contributing guidelines
   - License

5. **Write updated README**: Apply changes while preserving custom content.

## README Template

```markdown
# Project Name

Brief description of what the project does.

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

```bash
# Installation commands
pip install package-name
```

## Quick Start

```python
# Minimal usage example
from package import main
main.run()
```

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| CONFIG_1 | Description | value   |

## Usage

### Basic Usage

[Examples]

### Advanced Usage

[More examples]

## API Reference

[Link to full API docs or brief reference]

## Development

```bash
# Development setup
pip install -e ".[dev]"
pytest
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

[License type] - see [LICENSE](LICENSE)
```

## Output Format

```
README Update
=============

Current README Analysis
-----------------------
Sections found: X
Last updated: [date if detectable]

Outdated Sections
-----------------
- Installation: Dependencies changed
- Usage: New features not documented
- Configuration: Missing new options

Updates Made
------------
[✓] Updated installation instructions
[✓] Added new features to list
[✓] Updated configuration table
[✓] Refreshed usage examples
[✓] Updated dependency versions

README Preview
--------------
[Show key updated sections]

Changes saved to README.md
```

## Tips

- Use the documentation skill for detailed patterns
- Preserve any custom sections the user has added
- Keep examples minimal but functional
- Link to detailed docs for complex topics
