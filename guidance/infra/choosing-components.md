---
type: standard
title: Choosing cloud components
description: Selecting the right cloud service across AWS, GCP, and Azure. Read when making an infrastructure or architecture decision.
tags: [infra, aws, gcp, azure, architecture]
---

# Choosing cloud components

Heuristics first:

- Prefer managed/serverless over self-managed (less to operate); prefer the boring, established service over the new one.
- Match the workload: request/response → functions or containers; always-on/stateful → containers or VMs; static assets → object storage + CDN.
- Record the decision as an ADR (see the `adr` skill) — component choices are exactly what ADRs are for.
- Verify service capabilities and pricing against current provider docs — training data goes stale fast.

Rough equivalence table:

| Need | AWS | GCP | Azure |
|-|-|-|-|
| Functions | Lambda | Cloud Functions / Cloud Run functions | Azure Functions |
| Containers (serverless) | Fargate / App Runner | Cloud Run | Container Apps |
| Kubernetes | EKS | GKE | AKS |
| Object storage | S3 | Cloud Storage | Blob Storage |
| Relational DB | RDS / Aurora | Cloud SQL / AlloyDB | Azure SQL / Database for PostgreSQL |
| NoSQL | DynamoDB | Firestore / Bigtable | Cosmos DB |
| Queue | SQS | Pub/Sub | Storage Queues / Service Bus |
| Events | EventBridge / SNS | Pub/Sub / Eventarc | Event Grid |
| Secrets | Secrets Manager / SSM | Secret Manager | Key Vault |
| CDN | CloudFront | Cloud CDN | Front Door / CDN |
| Auth | Cognito | Identity Platform | Entra ID (B2C) |
