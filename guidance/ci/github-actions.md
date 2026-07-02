---
type: standard
title: GitHub Actions
description: Writing and verifying GitHub Actions workflows. Read when editing files under .github/workflows/.
tags: [ci, github-actions]
---

# GitHub Actions

- Verify every workflow with `actionlint` after editing — yaml typos otherwise only surface on push.
- Use current action and runner versions: check the action's repo for the latest major (`actions/checkout@v4`-era tags go stale) — your training data is often outdated here.
- Pin third-party actions to a full commit SHA (supply-chain safety); first-party `actions/*` may use major tags.
- Set least-privilege `permissions:` at workflow level (`contents: read` default; widen per job only as needed).
- CI runs the same gate as local: format check, lint, typecheck, build, tests — mirror `check.sh` stages so CI and local can't disagree.
- Cache dependencies (`actions/setup-node` with `cache: npm`, etc.) to keep runs fast.
- Secrets come from repository/environment secrets — never echo them; mask anything derived.
- Use `concurrency` to cancel superseded runs on PR branches.
