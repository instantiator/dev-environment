---
type: standard
title: AWS SAM and CloudFormation
description: Writing and verifying SAM/CloudFormation templates. Read when editing template.yaml or CloudFormation stacks.
tags: [infra, aws, sam, cloudformation]
---

# AWS SAM / CloudFormation

- Prefer SAM over raw CloudFormation for serverless apps (shorter templates, `sam local` testing).
- Parameterise per-environment values; never hardcode account IDs, ARNs, or secrets in templates (reference SSM/Secrets Manager).
- Give every function an explicit least-privilege policy; avoid `Action: "*"`.
- Set function timeouts, memory, and log retention explicitly — the defaults are rarely right.
- Use `Outputs` for anything another stack or script needs; import rather than copy values.
- Tag all resources (project, environment) for cost attribution.

## Verification (run before every deploy)

- `sam validate --lint` (or `cfn-lint template.yaml` for raw CloudFormation).
- `sam build` locally; `sam local invoke` for changed functions where practical.
- Review the change set (`sam deploy --no-execute-changeset`) before executing — especially for anything with `Replacement: True`.
