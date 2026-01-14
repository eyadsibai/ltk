---
name: aws-architecture
description: Use when "designing AWS architecture", "serverless AWS", "cloud infrastructure", "Lambda", "DynamoDB", or asking about "AWS cost optimization", "CloudFormation", "CDK", "API Gateway", "ECS", "EKS"
version: 1.0.0
---

<!-- Adapted from: claude-skills/engineering-team/aws-solution-architect -->

# AWS Solution Architecture Guide

Serverless, scalable, and cost-effective AWS cloud infrastructure.

## When to Use

- Designing AWS architecture for new applications
- Optimizing AWS costs
- Building serverless applications
- Creating infrastructure as code
- Multi-region deployments

## Architecture Patterns

### 1. Serverless Web Application

**Best for**: SaaS platforms, mobile backends, low-traffic sites

```
Frontend: S3 + CloudFront
API: API Gateway + Lambda
Database: DynamoDB or Aurora Serverless
Auth: Cognito
CI/CD: Amplify or CodePipeline
```

**Cost**: $50-500/month

### 2. Event-Driven Microservices

**Best for**: Complex workflows, async processing

```
Events: EventBridge
Processing: Lambda or ECS Fargate
Queue: SQS (with DLQ)
State: Step Functions
Storage: DynamoDB, S3
```

**Cost**: $100-1000/month

### 3. Modern Three-Tier

**Best for**: Traditional web apps, e-commerce

```
Load Balancer: ALB
Compute: ECS Fargate or EC2 Auto Scaling
Database: RDS Aurora
Cache: ElastiCache Redis
CDN: CloudFront
```

**Cost**: $300-2000/month

## Service Selection Guide

### Compute

| Service | Use Case |
|---------|----------|
| Lambda | Event-driven, short tasks (<15 min) |
| Fargate | Containerized apps, long-running |
| EC2 | Custom configs, GPU/FPGA |
| App Runner | Simple container deployment |

### Database

| Service | Use Case |
|---------|----------|
| DynamoDB | Key-value, serverless, <10ms latency |
| Aurora Serverless | Relational, variable workloads |
| RDS | Traditional databases |
| DocumentDB | MongoDB-compatible |
| Neptune | Graph database |

### Storage

| Service | Use Case |
|---------|----------|
| S3 Standard | Frequent access |
| S3 IA | Backups, archives |
| S3 Glacier | Long-term archives |
| EFS | Shared file system |
| EBS | Block storage for EC2 |

## Infrastructure as Code

### CDK Example

```typescript
import * as cdk from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';

export class ApiStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string) {
    super(scope, id);

    const handler = new lambda.Function(this, 'Handler', {
      runtime: lambda.Runtime.NODEJS_18_X,
      code: lambda.Code.fromAsset('lambda'),
      handler: 'index.handler',
    });

    new apigateway.LambdaRestApi(this, 'Api', {
      handler,
    });
  }
}
```

### CloudFormation Snippet

```yaml
Resources:
  MyFunction:
    Type: AWS::Lambda::Function
    Properties:
      Runtime: nodejs18.x
      Handler: index.handler
      Code:
        S3Bucket: !Ref CodeBucket
        S3Key: function.zip
      MemorySize: 256
      Timeout: 30
```

## Cost Optimization

### Quick Wins

- Enable S3 Intelligent-Tiering
- Use Savings Plans for predictable workloads
- Set CloudWatch log retention (7-30 days)
- Use VPC endpoints instead of NAT Gateway
- Right-size Lambda memory

### Cost Breakdown Tips

- Enable Cost Explorer
- Set up billing alerts
- Tag all resources for tracking
- Review NAT Gateway traffic
- Check data transfer costs

## Security Best Practices

| Practice | Implementation |
|----------|---------------|
| Least Privilege | IAM roles with minimal permissions |
| Encryption | KMS for at-rest, TLS for transit |
| Network Isolation | Private subnets, security groups |
| Secrets | Secrets Manager, not hardcoded |
| API Protection | WAF, rate limiting, API keys |
| Audit Logging | CloudTrail, VPC Flow Logs |

## Startup Stages

### MVP ($20-100/month)

- Amplify full-stack
- Lambda + API Gateway + DynamoDB
- Cognito for auth
- S3 + CloudFront for frontend

### Growth Stage ($500-2000/month)

- Add ElastiCache
- Aurora Serverless for complex queries
- CloudWatch dashboards and alarms
- CI/CD pipeline
- Multi-AZ deployment

### Scale-Up ($3000-10000/month)

- Multi-region deployment
- DynamoDB Global Tables
- WAF and Shield
- Advanced monitoring (X-Ray)
- Reserved capacity

## Common Pitfalls

- **Over-engineering early** - Don't build for 10M users with 100
- **Public S3 buckets** - Block public access
- **Overly permissive IAM** - Avoid `*` permissions
- **No caching** - Add CloudFront early
- **NAT Gateway costs** - Use VPC endpoints
