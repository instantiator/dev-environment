---
type: standard
title: Terraform
description: Writing and verifying Terraform. Read when editing .tf files.
tags: [infra, terraform]
---

# Terraform

- Pin provider and terraform versions (`required_version`, `required_providers`).
- Use remote state with locking (S3+DynamoDB / GCS / Azure Storage) — never commit state files.
- Structure: reusable modules with typed variables (`type`, `description`, validation) and outputs; environments as thin root modules composing them.
- No secrets in `.tf` or `.tfvars` committed to git; source them from the platform's secret store or environment.
- Name resources predictably; tag/label everything (project, environment).
- Prefer data sources over hardcoded IDs/ARNs.

## Verification (run before every apply)

- `terraform fmt -check`, `terraform validate`, and `tflint` — all clean (the 0-warnings rule applies).
- `terraform plan` — read it; treat any unexpected destroy/replace as a stop-and-ask.
- Apply only from a reviewed plan (`terraform apply plan.out` or CI-gated).
