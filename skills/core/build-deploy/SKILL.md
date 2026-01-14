---
name: Build & Deploy
description: This skill should be used when the user asks to "build the project", "run the build", "deploy to production", "validate build", "CI/CD pipeline", "deployment configuration", "pre-flight checks", "release process", or mentions build and deployment operations.
version: 1.0.0
---

# Build & Deploy

Comprehensive build and deployment skill for validation, CI/CD patterns, and deployment strategies.

## Core Capabilities

### Build Validation

Validate builds before deployment:

**Pre-build checks:**
- Dependencies installed correctly
- Environment variables set
- Required services available
- Configuration files valid

**Build process:**
```bash
# Python project
pip install -r requirements.txt
python -m pytest
python -m mypy src/
python -m build

# Node.js project
npm ci
npm run lint
npm run test
npm run build
```

**Post-build validation:**
- Build artifacts exist
- Artifact sizes reasonable
- Version numbers correct
- No development dependencies in production

### CI/CD Patterns

Common continuous integration/deployment patterns:

**GitHub Actions:**
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - run: pip install -r requirements.txt
      - run: pytest --cov=src

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t app:${{ github.sha }} .

  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploy to production"
```

**Pipeline stages:**
1. **Lint**: Code style and quality
2. **Test**: Unit and integration tests
3. **Build**: Create artifacts
4. **Security**: Scan for vulnerabilities
5. **Deploy**: Push to environment

### Deployment Strategies

Choose appropriate deployment approach:

**Rolling Deployment:**
- Gradual replacement of instances
- Zero downtime
- Easy rollback
- Best for: Stateless services

**Blue-Green Deployment:**
- Two identical environments
- Instant switch between versions
- Simple rollback
- Best for: Critical services

**Canary Deployment:**
- Small percentage gets new version
- Gradual traffic increase
- Risk mitigation
- Best for: High-traffic services

**Feature Flags:**
- Deploy code, enable separately
- Gradual rollout to users
- Quick disable if issues
- Best for: New features

### Pre-flight Checks

Validation before deployment:

**Checklist:**
```
[ ] All tests pass
[ ] Security scan clean
[ ] Build artifacts valid
[ ] Configuration correct
[ ] Database migrations ready
[ ] Dependencies compatible
[ ] Rollback plan documented
[ ] Monitoring configured
[ ] Team notified
```

**Automated checks:**
```bash
# Environment validation
./scripts/check-env.sh

# Database connectivity
./scripts/check-db.sh

# External service health
./scripts/check-services.sh

# Configuration validation
./scripts/validate-config.sh
```

## Build Workflows

### Local Build

For development and testing:

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements-dev.txt

# Run tests
pytest

# Build package
python -m build
```

### Production Build

For deployment:

```bash
# Install production dependencies only
pip install -r requirements.txt

# Run production build
python -m build --wheel

# Verify artifact
ls dist/
```

### Container Build

For containerized deployments:

```dockerfile
# Multi-stage Dockerfile
FROM python:3.11-slim as builder

WORKDIR /app
COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /wheels /wheels
RUN pip install --no-cache /wheels/*
COPY src/ ./src/
CMD ["python", "-m", "src.main"]
```

## Deployment Workflows

### GCP Cloud Run

```bash
# Build and push image
gcloud builds submit --tag gcr.io/PROJECT/APP

# Deploy to Cloud Run
gcloud run deploy APP \
  --image gcr.io/PROJECT/APP \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

### GCP Compute Engine

```bash
# Create instance template
gcloud compute instance-templates create APP-template \
  --machine-type=e2-medium \
  --image-family=debian-11 \
  --metadata-from-file=startup-script=startup.sh

# Update managed instance group
gcloud compute instance-groups managed rolling-action start-update APP-group \
  --version=template=APP-template
```

### GCP Cloud Functions

```bash
# Deploy function
gcloud functions deploy FUNCTION_NAME \
  --runtime python311 \
  --trigger-http \
  --entry-point main \
  --source ./src
```

## Environment Management

### Environment Variables

**Required variables:**
```bash
# Application
APP_ENV=production
APP_DEBUG=false
APP_SECRET_KEY=<secret>

# Database
DATABASE_URL=postgresql://...
REDIS_URL=redis://...

# External Services
API_KEY=<key>
```

**Validation:**
```python
required_vars = [
    'DATABASE_URL',
    'APP_SECRET_KEY',
    'API_KEY',
]

missing = [v for v in required_vars if not os.getenv(v)]
if missing:
    raise ValueError(f"Missing env vars: {missing}")
```

### Configuration Management

**Environment-specific configs:**
```
config/
├── base.py       # Shared settings
├── development.py
├── staging.py
└── production.py
```

**Loading pattern:**
```python
import os
env = os.getenv('APP_ENV', 'development')
config = importlib.import_module(f'config.{env}')
```

## Rollback Procedures

### Quick Rollback

```bash
# GCP Cloud Run
gcloud run services update-traffic APP \
  --to-revisions=PREVIOUS_REVISION=100

# Docker/Kubernetes
kubectl rollout undo deployment/APP

# Database (if migration failed)
python manage.py migrate APP PREVIOUS_MIGRATION
```

### Rollback Checklist

```
[ ] Identify the issue
[ ] Notify stakeholders
[ ] Execute rollback command
[ ] Verify service health
[ ] Investigate root cause
[ ] Document incident
```

## Monitoring Integration

### Health Checks

```python
@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "version": APP_VERSION,
        "timestamp": datetime.utcnow().isoformat()
    }

@app.get("/ready")
def readiness_check():
    # Check dependencies
    db_ok = check_database()
    cache_ok = check_redis()
    return {
        "ready": db_ok and cache_ok,
        "checks": {
            "database": db_ok,
            "cache": cache_ok
        }
    }
```

### Deployment Metrics

Track after deployment:
- Response times
- Error rates
- Resource utilization
- Business metrics

## Integration

Coordinate with other skills:
- **security-scanning skill**: Pre-deploy security checks
- **test-coverage skill**: Ensure adequate coverage
- **git-workflows skill**: Tag releases, update changelog
