---
type: standard
title: GCP
description: Thin decision guide for Google Cloud infrastructure. Read when targeting GCP.
tags: [infra, gcp]
---

# GCP

- Component selection: use the equivalence table in [choosing-components](choosing-components.md); default compute choice on GCP is Cloud Run (serverless containers) unless there's a reason otherwise.
- Define infrastructure as code: Terraform is the norm on GCP ([terraform](terraform.md)); Deployment Manager is legacy — avoid for new work.
- Use per-service service accounts with least-privilege IAM roles; never the default compute service account for app workloads.
- Keep secrets in Secret Manager; config via env vars set at deploy.
- Enable only the APIs you need per project; one project per environment is the simple, safe default.
- Verify against current GCP docs — services and pricing change frequently, and your training data may be stale.
- Verification tooling: [verification](verification.md).
