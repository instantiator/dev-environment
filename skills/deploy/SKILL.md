---
name: deploy
type: skill
title: Deploy
description: Run or deploy the application, locally or remotely. Use when asked to deploy, release, or run the app.
tags: [skill, deploy, operations]
---

# Deploy

## When to use

Deploying to an environment, cutting a release, or running the app locally for real use.

## Questions to ask

1. Local or remote? Which environment (dev/staging/prod)?
2. First-time setup or repeat deploy? (First time: prerequisites, env files, secrets provisioning.)
3. For remote: what is the deploy mechanism — CI pipeline, IaC (SAM/CDK/Terraform), a platform CLI, or scripts in the repo?

## Steps

1. Discover the project's own mechanism first: deploy/start scripts in `scripts/` or `package.json`, compose files, IaC directories, CI deploy jobs. Use what exists; don't invent a parallel path.
2. Run `dev-environment/scripts/check.sh` — never deploy a failing build.
3. Local: `docker compose up -d --wait` or the project's start script; confirm required env files exist (`.env` from `.env.example`).
4. Remote via IaC: follow `guidance/infra/verification.md` — lint, then review the plan/diff/change-set before applying. Unexpected destroys or IAM changes: stop and ask.
5. Remote via CI: push/tag per the pipeline's convention; watch the run to completion.
6. Never handle secrets in plaintext; they live in the platform's secret store.

## Scripts

- The project's own deploy/start scripts (preferred).
- `dev-environment/scripts/check.sh` as the pre-deploy gate.

## Validate

- Health endpoint or smoke test passes post-deploy (`scripts/run-smoke-tests.sh` if the project has one).
- Logs show a clean start — no errors or warnings during boot.
