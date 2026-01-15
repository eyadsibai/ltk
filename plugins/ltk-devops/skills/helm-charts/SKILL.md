---
name: helm-charts
description: Use when creating Helm charts, packaging Kubernetes applications, managing multi-environment deployments, or asking about "Helm", "Helm chart", "values.yaml", "chart templating", "Helm dependencies"
version: 1.0.0
---

# Helm Chart Development

Create, organize, and manage Helm charts for Kubernetes applications.

## Chart Structure

```
my-app/
├── Chart.yaml           # Chart metadata
├── values.yaml          # Default values
├── charts/              # Dependencies
├── templates/
│   ├── NOTES.txt        # Post-install notes
│   ├── _helpers.tpl     # Template helpers
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── .helmignore
```

## Chart.yaml

```yaml
apiVersion: v2
name: my-app
description: A Helm chart for My Application
version: 1.0.0
appVersion: "2.1.0"

dependencies:
  - name: postgresql
    version: "12.0.0"
    repository: "https://charts.bitnami.com/bitnami"
    condition: postgresql.enabled
```

## values.yaml Structure

```yaml
image:
  repository: myapp
  tag: "1.0.0"
  pullPolicy: IfNotPresent

replicaCount: 3

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  hosts:
    - host: app.example.com
      paths:
        - path: /
          pathType: Prefix

resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"

autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
```

## Template Helpers (_helpers.tpl)

```yaml
{{- define "my-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "my-app.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "my-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
```

## Deployment Template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "my-app.fullname" . }}
  labels:
    {{- include "my-app.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "my-app.selectorLabels" . | nindent 6 }}
  template:
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        resources:
          {{- toYaml .Values.resources | nindent 12 }}
```

## Multi-Environment Configuration

```
my-app/
├── values.yaml          # Defaults
├── values-dev.yaml      # Development
├── values-staging.yaml  # Staging
└── values-prod.yaml     # Production
```

Install with environment:

```bash
helm install my-app ./my-app -f values-prod.yaml -n production
```

## Common Patterns

### Conditional Resources

```yaml
{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
...
{{- end }}
```

### Iterating Lists

```yaml
env:
{{- range .Values.env }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}
```

## Validation Commands

```bash
helm lint my-app/
helm template my-app ./my-app --dry-run
helm install my-app ./my-app --dry-run --debug
```

## Best Practices

1. Use semantic versioning
2. Document all values with comments
3. Use template helpers for repeated logic
4. Pin dependency versions explicitly
5. Include NOTES.txt with usage instructions
6. Add labels consistently
7. Test in all environments
