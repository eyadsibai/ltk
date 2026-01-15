---
name: secrets-management
description: Use when implementing secrets management, using Vault, AWS Secrets Manager, handling credentials in CI/CD, or asking about "secrets", "Vault", "credentials", "secret rotation", "API keys", "external secrets operator"
version: 1.0.0
---

# Secrets Management

Secure secrets management for CI/CD pipelines using Vault, AWS Secrets Manager, and other tools.

## Secret Management Tools

| Tool | Best For |
|------|----------|
| HashiCorp Vault | Centralized, dynamic secrets |
| AWS Secrets Manager | AWS-native, auto-rotation |
| Azure Key Vault | Azure-native, HSM-backed |
| Google Secret Manager | GCP-native, IAM integration |

## HashiCorp Vault

### Setup

```bash
vault secrets enable -path=secret kv-v2
vault kv put secret/database/config username=admin password=secret
```

### GitHub Actions Integration

```yaml
- name: Import Secrets from Vault
  uses: hashicorp/vault-action@v2
  with:
    url: https://vault.example.com:8200
    token: ${{ secrets.VAULT_TOKEN }}
    secrets: |
      secret/data/database username | DB_USERNAME ;
      secret/data/database password | DB_PASSWORD
```

### GitLab CI Integration

```yaml
deploy:
  script:
    - export VAULT_ADDR=https://vault.example.com:8200
    - DB_PASSWORD=$(vault kv get -field=password secret/database/config)
```

## AWS Secrets Manager

### Store Secret

```bash
aws secretsmanager create-secret \
  --name production/database/password \
  --secret-string "super-secret-password"
```

### Retrieve in CI/CD

```yaml
- name: Get secret from AWS
  run: |
    SECRET=$(aws secretsmanager get-secret-value \
      --secret-id production/database/password \
      --query SecretString --output text)
    echo "::add-mask::$SECRET"
    echo "DB_PASSWORD=$SECRET" >> $GITHUB_ENV
```

### Terraform Integration

```hcl
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "production/database/password"
}

resource "aws_db_instance" "main" {
  password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
}
```

## External Secrets Operator (Kubernetes)

```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "https://vault.example.com:8200"
      path: "secret"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "production"
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: database-credentials
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-backend
  data:
  - secretKey: password
    remoteRef:
      key: database/config
      property: password
```

## Secret Rotation

```python
def rotate_secret(secret_id):
    # Generate new password
    new_password = generate_strong_password()

    # Update database password
    update_database_password(new_password)

    # Update secret store
    client.put_secret_value(
        SecretId=secret_id,
        SecretString=json.dumps({'password': new_password})
    )
```

## Secret Scanning (Pre-commit)

```bash
#!/bin/bash
# .git/hooks/pre-commit
docker run --rm -v "$(pwd):/repo" \
  trufflesecurity/trufflehog:latest \
  filesystem --directory=/repo

if [ $? -ne 0 ]; then
  echo "Secret detected! Commit blocked."
  exit 1
fi
```

## Best Practices

1. **Never commit secrets** to Git
2. **Use different secrets** per environment
3. **Rotate secrets regularly**
4. **Implement least-privilege access**
5. **Enable audit logging**
6. **Use secret scanning** (GitGuardian, TruffleHog)
7. **Mask secrets in logs**
8. **Use short-lived tokens** when possible
