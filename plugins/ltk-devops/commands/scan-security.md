---
name: ltk:scan-security
description: Run comprehensive security analysis on the codebase
argument-hint: "[path]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# Security Scanning Command

Perform comprehensive security analysis on the codebase to identify vulnerabilities, secrets, and security anti-patterns.

## Execution Steps

1. **Determine scope**: If a path argument is provided, scan only that path. Otherwise, scan the entire project.

2. **Secrets detection**: Search for hardcoded credentials, API keys, and tokens:
   - AWS keys (pattern: `AKIA[0-9A-Z]{16}`)
   - Private keys (pattern: `-----BEGIN.*PRIVATE KEY-----`)
   - Generic secrets (passwords, tokens, api_keys in assignments)
   - Environment files that shouldn't be committed

3. **Dependency audit**: Check for known vulnerabilities:
   - For Python: Check if `pip-audit` or `safety` can be run
   - For Node.js: Run `npm audit` if package.json exists
   - Report any CVEs found

4. **Code vulnerability patterns**: Search for:
   - SQL injection (string concatenation in queries)
   - Command injection (shell commands with variables)
   - XSS patterns (innerHTML, unescaped output)
   - Insecure deserialization (pickle.loads, yaml.load)
   - Path traversal (file operations with user input)

5. **Report findings**: Present results organized by severity:
   - **Critical**: Immediate exploitation risk
   - **High**: Significant security risk
   - **Medium**: Potential security concern
   - **Low**: Best practice violations

## Output Format

```
Security Scan Results
=====================

Scope: [scanned path]
Files scanned: [count]

CRITICAL (X findings)
---------------------
[List critical issues with file:line and description]

HIGH (X findings)
-----------------
[List high issues]

MEDIUM (X findings)
-------------------
[List medium issues]

LOW (X findings)
----------------
[List low issues]

Summary: X critical, X high, X medium, X low
Recommendation: [Overall recommendation]
```

## Tips

- Use the security-scanning skill for detailed patterns
- For large codebases, consider scanning changed files only
- Always verify findings before reporting (reduce false positives)
