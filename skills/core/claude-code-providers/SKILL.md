---
name: claude-code-providers
description: Use when "Claude Code model provider", "alternative model", "GitHub Copilot provider", "LiteLLM", "copilot-api", "LLM gateway", "custom model endpoint"
version: 1.0.0
---

# Claude Code Alternative Model Providers

Configure Claude Code to use alternative model providers.

---

## GitHub Copilot as Provider

Use GitHub Copilot subscription as a model provider for Claude Code.

### Copilot Setup

```bash
# Install
npm install -g copilot-api @anthropic-ai/claude-code

# Start proxy and authenticate
copilot-api start --proxy-env
# Visit https://github.com/login/device and enter the code
```

### Available Models

- claude-3.5-sonnet, claude-3.7-sonnet, claude-sonnet-4.5, claude-opus-4
- gemini-2.0-flash-001, gemini-2.5-pro
- o3

### Copilot Configuration

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:4141",
    "ANTHROPIC_AUTH_TOKEN": "sk-dummy",
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-5-mini",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "1",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1"
  }
}
```

---

## LiteLLM Gateway

Use LiteLLM as a unified gateway to 100+ LLMs.

### LiteLLM Setup

```bash
npm install -g @anthropic-ai/claude-code
pip install -U 'litellm[proxy]'
```

### Config File (`litellm_config.yaml`)

```yaml
general_settings:
  master_key: sk-dummy
litellm_settings:
  drop_params: true
model_list:
- model_name: claude-opus-4.5
  litellm_params:
    model: github_copilot/claude-opus-4.5
    drop_params: true
    extra_headers:
      editor-version: "vscode/1.95.0"
      editor-plugin-version: "copilot-chat/0.26.7"
- model_name: "*"
  litellm_params:
    model: "github_copilot/*"
    extra_headers:
      editor-version: "vscode/1.95.0"
      editor-plugin-version: "copilot-chat/0.26.7"
```

### Start Proxy

```bash
litellm -c litellm_config.yaml
# Authenticate at https://github.com/login/device
```

### LiteLLM Configuration

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:4000",
    "ANTHROPIC_AUTH_TOKEN": "sk-dummy",
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-5-mini",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "1",
    "DISABLE_TELEMETRY": "1"
  }
}
```

---

## Environment Variables Alternative

```bash
export ANTHROPIC_BASE_URL="http://localhost:4141"  # or :4000 for LiteLLM
export ANTHROPIC_AUTH_TOKEN="sk-dummy"
export ANTHROPIC_MODEL="claude-sonnet-4.5"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="gpt-5-mini"
export DISABLE_NON_ESSENTIAL_MODEL_CALLS="1"

claude
```

---

## Decision Guide

| Provider | Best For |
|----------|----------|
| **GitHub Copilot** | Existing Copilot subscription, simpler setup |
| **LiteLLM** | Multiple provider access, advanced routing |
| **Direct Anthropic** | Production use, official support |
