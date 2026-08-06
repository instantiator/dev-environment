---
name: deps-audit
type: skill
title: Dependency audit
description: Audit, update, and resolve conflicts in dependencies. Use for dependency updates, vulnerability alerts, or version conflicts.
tags: [skill, dependencies, security]
---

# Dependency audit

## When to use

Vulnerability alerts (Dependabot/audit), a requested update, or dependency conflicts blocking work.

## Questions to ask

1. Scope: security fixes only, or update everything eligible?
2. Appetite for breaking changes (major bumps), or minor/patch only?

## Steps

1. Read `guidance/standards/dependencies.md` — it defines when updating is justified at all.
2. Audit: `npm audit` / `dotnet list package --vulnerable` (and `--outdated` / `npm outdated` if scope includes updates).
3. Summarise findings for the user: package, current → available, severity, and whether the update rule justifies it. Ask how to proceed if anything is a major bump.
4. Update in small groups (security first), running `dev-qual/scripts/check.sh` after each group — not one giant bump.
5. Conflicts: resolve to the simplest working set — prefer moving the fewest packages, prefer versions the ecosystem has settled on, and record the rationale where the resolution is pinned (lockfile overrides/resolutions get a comment or commit message explaining why).
6. Commit the lockfile with the manifest.

## Scripts

- `npm audit`, `npm outdated` / `dotnet list package --vulnerable`, `--outdated`
- `dev-qual/scripts/check.sh` after each update group

## Validate

- `check.sh` passes; the audit tool reports no remaining issues in scope.
- Lockfile committed; any override/resolution has a documented rationale.
