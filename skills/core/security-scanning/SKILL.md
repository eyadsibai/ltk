---
name: Security Scanning
description: This skill should be used when the user asks to "scan for vulnerabilities", "check for security issues", "find secrets in code", "audit dependencies", "detect SQL injection", "find XSS vulnerabilities", "check for OWASP issues", "scan for hardcoded credentials", or mentions security analysis of code.
version: 1.0.0
---

# Security Scanning

Comprehensive security analysis skill for detecting vulnerabilities, secrets, and security anti-patterns in codebases.

## Core Capabilities

### Secrets Detection

Scan for accidentally committed secrets and credentials:

**Patterns to detect:**
- API keys (AWS, GCP, Azure, Stripe, etc.)
- Private keys (RSA, SSH, PGP)
- Passwords and tokens in code
- Database connection strings with credentials
- JWT secrets and signing keys
- OAuth client secrets

**Common file locations:**
- `.env` files committed to repo
- Configuration files (config.py, settings.json)
- Test fixtures with real credentials
- Documentation with example credentials
- CI/CD configuration files

**Search patterns:**
```
# API Keys
grep -rE "(api[_-]?key|apikey)\s*[:=]\s*['\"][a-zA-Z0-9]{20,}"

# AWS Keys
grep -rE "AKIA[0-9A-Z]{16}"

# Private Keys
grep -rE "-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----"

# Generic Secrets
grep -rE "(password|secret|token)\s*[:=]\s*['\"][^'\"]{8,}"
```

### OWASP Vulnerability Detection

Identify common web application vulnerabilities:

**SQL Injection:**
- String concatenation in SQL queries
- Unparameterized queries
- Dynamic table/column names from user input

**Cross-Site Scripting (XSS):**
- Unescaped user input in HTML output
- innerHTML assignments with user data
- Template rendering without auto-escaping

**Command Injection:**
- Shell command construction with user input
- subprocess/os.system calls with variables
- eval() with external data

**Path Traversal:**
- File operations with user-controlled paths
- Missing path sanitization
- Symlink following vulnerabilities

**Insecure Deserialization:**
- pickle.loads with untrusted data
- yaml.load without safe_load
- JSON parsing of user input into code execution

### Dependency Auditing

Check for known vulnerabilities in dependencies:

**Python:**
```bash
# Using pip-audit
pip-audit -r requirements.txt

# Using safety
safety check -r requirements.txt

# Check outdated packages
pip list --outdated
```

**JavaScript/Node:**
```bash
npm audit
yarn audit
```

**General approach:**
1. Parse dependency files (requirements.txt, package.json, go.mod)
2. Check versions against known CVE databases
3. Report severity and remediation guidance

### Security Anti-Patterns

Detect insecure coding patterns:

**Weak Cryptography:**
- MD5/SHA1 for password hashing
- ECB mode encryption
- Hardcoded encryption keys
- Weak random number generation

**Authentication Issues:**
- Hardcoded credentials
- Missing authentication checks
- Weak password policies
- Session fixation vulnerabilities

**Authorization Flaws:**
- Missing access control checks
- IDOR (Insecure Direct Object References)
- Privilege escalation paths

**Data Exposure:**
- Sensitive data in logs
- Unencrypted sensitive storage
- Debug information in production

## Scanning Workflow

### Full Security Scan

To perform a comprehensive security scan:

1. **Secrets scan**: Search for hardcoded credentials
2. **Dependency audit**: Check for known CVEs
3. **Code analysis**: Identify vulnerability patterns
4. **Configuration review**: Check security settings

### Quick Security Check

For rapid assessment of recent changes:

1. Identify modified files from git diff
2. Scan only changed files for secrets
3. Check new dependencies added
4. Review security-sensitive code paths

## Output Format

Present findings with severity levels:

**Critical**: Immediate exploitation risk
- Hardcoded production credentials
- Known exploitable CVEs
- Authentication bypass

**High**: Significant security risk
- SQL injection vulnerabilities
- XSS in user-facing pages
- Weak cryptographic usage

**Medium**: Potential security concern
- Missing input validation
- Outdated dependencies (no known CVE)
- Insecure defaults

**Low**: Best practice violations
- Verbose error messages
- Missing security headers
- Suboptimal configurations

## Language-Specific Patterns

### Python

```python
# SQL Injection - BAD
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")

# SQL Injection - GOOD
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))

# Command Injection - BAD
os.system(f"ls {user_input}")

# Command Injection - GOOD
subprocess.run(["ls", user_input], shell=False)

# Insecure Deserialization - BAD
data = pickle.loads(user_data)

# Secure Alternative
data = json.loads(user_data)
```

### JavaScript

```javascript
// XSS - BAD
element.innerHTML = userInput;

// XSS - GOOD
element.textContent = userInput;

// SQL Injection - BAD
db.query(`SELECT * FROM users WHERE id = ${userId}`);

// SQL Injection - GOOD
db.query('SELECT * FROM users WHERE id = ?', [userId]);
```

## Integration with Other Tools

When security issues are found, coordinate with:

- **code-quality skill**: For fixing identified issues
- **git-workflows skill**: For secure commit practices
- **documentation skill**: For security documentation

## Remediation Guidance

For each finding, provide:

1. **Description**: What the vulnerability is
2. **Location**: File path and line number
3. **Risk**: Potential impact if exploited
4. **Fix**: Specific remediation steps
5. **Prevention**: How to avoid in future

## Additional Resources

### Reference Files

For detailed vulnerability patterns:
- Consult OWASP Top 10 documentation
- Check CWE (Common Weakness Enumeration) database
- Review language-specific security guides
