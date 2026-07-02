---
type: standard
title: Dependency management
description: How to choose, add, and update dependencies safely. Read before adding or updating any dependency or framework.
tags: [standards, dependencies, security]
---

# Dependency management

## Choosing a dependency

- Prefer the standard library, then platform features, then an already-installed dependency, before adding a new one. Never add a dependency for what a few lines can do.
- Vet candidates on npm/NuGet/GitHub: license, last update, download count, open vulnerabilities (`npm audit` or equivalent).
- Prefer permissive licenses, recent updates, high adoption, and simplicity of implementation.
- List candidates to the user with those details, make a recommendation, and ask how to proceed.

## Versions

- Use the latest version of a new dependency, provided it has no known vulnerabilities. Check what is actually available — your training data may be outdated (GitHub Actions versions often fall foul of this).
- Use the latest LTS of Node, .NET, and other platform runtimes — again, verify against current reality, not memory.

## Updating

Do not update an existing dependency unless one of these holds:

- a vulnerability report (Dependabot, `npm audit`, `dotnet list package --vulnerable`),
- the user asks,
- a specific feature is required from a later version,
- another dependency must update for those reasons and depends on it.

- Resolve version conflicts to the simplest working set and record the rationale in the commit or PR.
- After any update, `scripts/check.sh` must pass and the lockfile must be committed.
