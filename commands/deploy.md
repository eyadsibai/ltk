---
name: deploy
description: Deploy application with pre-flight checks
argument-hint: "<env> [--force]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# Deploy Command

Deploy the application to the specified environment with comprehensive pre-flight checks.

## Execution Steps

1. **Parse arguments**:
   - Environment: staging, production (required)
   - --force: Skip confirmations (optional)

2. **Pre-flight checks**:
   - All tests pass
   - Build is valid
   - No security vulnerabilities
   - Configuration is correct
   - Database migrations ready
   - Rollback plan exists

3. **Environment validation**:
   - Required environment variables set
   - Target environment accessible
   - Required services healthy

4. **Confirm deployment**:
   - Show what will be deployed
   - List changes since last deployment
   - Require explicit confirmation (unless --force)

5. **Execute deployment**:
   - For GCP Cloud Run: `gcloud run deploy`
   - For GCP Compute: Update instance group
   - For other: Execute deploy script

6. **Post-deployment validation**:
   - Health check endpoints respond
   - Key functionality working
   - Monitoring shows healthy metrics

7. **Report result**: Show deployment status and next steps.

## Pre-flight Checklist

```
Pre-flight Checks
-----------------
[ ] Tests pass
[ ] Build valid
[ ] Security scan clean
[ ] Configuration correct
[ ] Migrations ready
[ ] Rollback documented
[ ] Team notified
```

## Output Format

```
Deployment
==========

Target: [environment]
Application: [name]
Version: [version/commit]

Pre-flight Checks
-----------------
[✓] Tests passing (X/X)
[✓] Build valid
[✓] Security scan clean
[✓] Configuration verified
[✓] Database migrations ready
[✓] Rollback plan documented

Environment Check
-----------------
[✓] GCP project: [project-id]
[✓] Service account configured
[✓] Required secrets available

Changes Since Last Deploy
-------------------------
- [commit 1 summary]
- [commit 2 summary]
- [commit 3 summary]

Proceed with deployment to [env]? [Deploying...]

Deployment Progress
-------------------
[✓] Building container image
[✓] Pushing to registry
[✓] Deploying to Cloud Run
[✓] Routing traffic

Post-deployment Validation
--------------------------
[✓] Health check: OK
[✓] Response time: Xms
[✓] Error rate: 0%

Deployment Successful!
----------------------
URL: https://app.example.com
Version: [version]
Duration: Xs

Rollback Command
----------------
gcloud run services update-traffic [service] --to-revisions=[previous]=100
```

## Tips

- Use the build-deploy skill for detailed patterns
- Always validate build before deploying
- Have rollback plan ready before production deployments
- Monitor closely after deployment
