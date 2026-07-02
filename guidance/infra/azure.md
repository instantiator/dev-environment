---
type: standard
title: Azure
description: Thin decision guide for Azure infrastructure. Read when targeting Azure.
tags: [infra, azure]
---

# Azure

- Component selection: use the equivalence table in [choosing-components](choosing-components.md); default compute choice on Azure is Container Apps or Azure Functions.
- Define infrastructure as code: Bicep is the native choice (cleaner than raw ARM JSON); Terraform if the team is multi-cloud ([terraform](terraform.md)).
- Organise with resource groups per app+environment; tag consistently for cost attribution.
- Use managed identities instead of connection strings/keys wherever a service supports them; secrets that must exist live in Key Vault.
- Grant RBAC at the narrowest scope that works (resource group, not subscription).
- Verify against current Azure docs — services and pricing change frequently, and your training data may be stale.
- Verification: `az bicep build` (compiles/validates), `az deployment group what-if` before deploying; more in [verification](verification.md).
