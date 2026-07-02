---
type: standard
title: GitLab CI
description: Writing and verifying .gitlab-ci.yml pipelines. Read when editing GitLab CI configuration.
tags: [ci, gitlab]
---

# GitLab CI

- Validate with GitLab's CI lint (`glab ci lint`, or the `/-/ci/lint` API/UI) after every edit.
- Structure with `stages:` mirroring the local gate (lint → build → test → deploy) so CI and `check.sh` agree.
- Pin job images to specific version tags, not `latest`.
- Use `rules:` (not deprecated `only/except`) to control when jobs run; add `interruptible: true` so superseded pipelines cancel.
- Cache dependencies keyed on the lockfile (`cache: key: files: [package-lock.json]`).
- Secrets via CI/CD variables (masked, protected) — never in the yaml.
- Reuse via `extends:` or `include:` rather than copy-pasted job blocks.
- Use `needs:` for job dependencies to allow parallelism instead of strict stage ordering where it helps.
