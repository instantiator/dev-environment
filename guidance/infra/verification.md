---
type: standard
title: Infrastructure verification
description: The tool to run before applying any infrastructure change. Read before deploying or reviewing any infra code.
tags: [infra, verification, tools]
---

# Verifying infrastructure code

Never apply infrastructure changes without running the matching verifier — infra mistakes are expensive and slow to undo.

| Code | Verify with | Then review |
|-|-|-|
| CloudFormation | `cfn-lint` | change set before execute |
| SAM | `sam validate --lint`, `sam build` | change set (`--no-execute-changeset`) |
| CDK | `cdk synth` + assertion tests | `cdk diff` |
| Terraform | `fmt -check`, `validate`, `tflint` | `terraform plan` output |
| Bicep/ARM | `az bicep build` | `az deployment group what-if` |
| Dockerfile | `hadolint` | image builds and runs |
| Compose | `docker compose config` | services come up healthy |
| CI yaml | `actionlint` (GH) / platform linter | dry-run or a draft-branch run |

- A clean lint is necessary, not sufficient: always read the plan/diff/change-set for destroys, replacements, and IAM changes before applying.
- Missing verifier tools: install via `dev-environment/scripts/check-prereqs.sh` hints.
