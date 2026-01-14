---
name: debug-session
description: Systematic debugging session for runtime issues and system problems
argument-hint: "[error message or problem description]"
allowed-tools:
  - Read
  - Bash
  - Grep
  - Glob
  - Task
  - TodoWrite
---

# Debug Session

Systematic debugging for runtime issues, system problems, and hard-to-reproduce bugs.

## Problem

**Input:** `#$ARGUMENTS`

**If empty, ask:** "What issue are you experiencing? Provide error messages, symptoms, or unexpected behavior."

## Process

### Step 1: Gather System State

```bash
# Check running processes
ps aux | grep -E "node|python|java|go" | head -20

# Check open ports
lsof -i -P -n | grep LISTEN

# Check disk space
df -h

# Check memory
free -h 2>/dev/null || vm_stat

# Check recent logs
tail -100 /var/log/syslog 2>/dev/null || log show --last 5m
```

### Step 2: Application State

```bash
# Check application logs
tail -200 logs/app.log 2>/dev/null

# Check for crash dumps
ls -la /tmp/*.crash 2>/dev/null

# Environment variables (sanitized)
env | grep -E "^(NODE_|PYTHON_|DATABASE_|API_)" | sed 's/=.*/=***/'

# Check configuration
cat .env 2>/dev/null | grep -v "KEY\|SECRET\|PASSWORD"
```

### Step 3: Categorize the Issue

| Category | Symptoms | Common Causes |
|----------|----------|---------------|
| **Crash** | Process terminates | Unhandled exception, OOM |
| **Hang** | Process unresponsive | Deadlock, infinite loop |
| **Slow** | High latency | Resource contention, N+1 |
| **Error** | Error messages | Bad input, config issue |
| **Wrong Output** | Incorrect results | Logic bug, data issue |

### Step 4: Form Hypotheses

For each potential cause:

```markdown
## Hypothesis 1: [Description]
**Likelihood**: High/Medium/Low
**Test**: [How to verify]
**Evidence For**: [Supporting observations]
**Evidence Against**: [Contradicting observations]
```

### Step 5: Test Hypotheses

```bash
# Add debug logging
DEBUG=* node app.js

# Run with profiling
python -m cProfile -o profile.out script.py

# Check database connections
psql -c "SELECT * FROM pg_stat_activity;"

# Network debugging
curl -v http://localhost:3000/health
netstat -an | grep ESTABLISHED
```

### Step 6: Isolate the Issue

```bash
# Binary search through commits
git bisect start
git bisect bad HEAD
git bisect good v1.0.0

# Minimal reproduction
# 1. Strip down to essential code
# 2. Remove dependencies one by one
# 3. Simplify input data
```

## Common Debug Patterns

### Memory Issues

```bash
# Node.js heap snapshot
node --inspect app.js
# Then in Chrome DevTools: chrome://inspect

# Python memory profiling
pip install memory_profiler
python -m memory_profiler script.py
```

### Performance Issues

```bash
# CPU profiling
perf record -g ./program
perf report

# Database slow queries
EXPLAIN ANALYZE SELECT ...;
```

### Network Issues

```bash
# DNS resolution
nslookup hostname
dig hostname

# Connection issues
telnet hostname port
nc -zv hostname port

# SSL/TLS issues
openssl s_client -connect hostname:443
```

## Output Format

```markdown
# Debug Session Report

## Problem Summary
[Brief description of the issue]

## Environment
- OS: [version]
- Runtime: [version]
- Relevant services: [list]

## Investigation Timeline

### 1. Initial Observations
[What we saw first]

### 2. System State Check
[Results of system inspection]

### 3. Hypotheses Tested
| Hypothesis | Test | Result |
|------------|------|--------|
| [H1] | [test] | Confirmed/Refuted |

## Root Cause
[What caused the issue]

## Solution
[How to fix it]

## Prevention
[How to prevent recurrence]

## Commands Used
```bash
# Key commands for future reference
```

```

## Tips

- **Start broad, narrow down** - Don't assume the cause
- **Check the obvious first** - Disk space, permissions, config
- **Reproduce consistently** - Random bugs are hard to fix
- **Document everything** - Future you will thank present you
- **Take breaks** - Fresh eyes find bugs faster
