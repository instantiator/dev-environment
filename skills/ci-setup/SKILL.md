---
name: ci-setup
type: skill
title: CI setup
description: Set up continuous integration for a repository. Use when asked to add CI, or when a repo has no workflow files.
tags: [skill, ci]
---

# CI setup

## When to use

The repo has no CI, or CI needs extending to cover the quality gate.

## Questions to ask

1. Which platform? GitHub Actions, GitLab CI, or Gitea Actions (usually determined by where the repo is hosted).
2. Which stages should CI run? (Default: mirror `check.sh` — format check, lint, typecheck, build, tests.)
3. Should CI deploy, or only verify? If deploy: to where, and on which branches/tags?
4. Any slow suites (integration/e2e) to run on a schedule or per-PR?

## Steps

1. Read the platform doc: `guidance/ci/github-actions.md`, `guidance/ci/gitlab-ci.md`, or `guidance/ci/gitea.md`.
2. Write the workflow mirroring the local gate, so CI and local can never disagree. Simplest robust form: install deps, then run the same npm/dotnet commands `check.sh` runs.
3. Pin versions: runners, action SHAs/tags, job images — check what is *currently* latest, not what you remember.
4. Set least-privilege permissions and masked secrets per the platform doc.
5. Verify the yaml with the platform's linter (`actionlint` / `glab ci lint`).
6. Push to a branch and confirm the first pipeline run is green.

## Scripts

- `actionlint` (install hint via `dev-environment/scripts/check-prereqs.sh`)

## Validate

- The workflow linter reports no problems.
- The first pipeline run on a branch is green, and a deliberate failure (e.g. a lint error on a scratch branch) makes it red.
