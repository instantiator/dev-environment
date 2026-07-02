---
type: standard
title: Gitea Actions
description: CI on Gitea using Actions workflows. Read when editing workflows for a Gitea-hosted repository.
tags: [ci, gitea]
---

# Gitea Actions

- Gitea Actions is GitHub-Actions-compatible: workflows live in `.gitea/workflows/` (falls back to `.github/workflows/`), and [github-actions](github-actions.md) rules apply, including `actionlint` verification.
- Differences to check: actions resolve from gitea.com or a configured mirror by default — reference actions by full URL (`https://github.com/actions/checkout@v4`) when the runner can't resolve short names.
- Runners are self-hosted (`act_runner`): confirm the labels in `runs-on:` match labels your runners actually register.
- Not every GitHub feature exists (e.g. some contexts, OIDC, concurrency behaviours) — verify against the Gitea version's docs before relying on one.
- Keep workflows simple enough to test by pushing to a draft branch; there is no hosted dry-run.
