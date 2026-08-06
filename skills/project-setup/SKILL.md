---
name: project-setup
type: skill
title: Project setup
description: Set up a new project, with or without a templating tool. Use when starting a project, scaffolding an app, or working in an empty repo.
tags: [skill, setup, scaffolding]
---

# Project setup

## When to use

Starting a new project or app, or the repo is empty apart from a README.

## Questions to ask

1. Language and framework? (See `guidance/languages/` and `guidance/frameworks/` for what's supported.)
2. Use an established templating tool, or scaffold manually? Prefer the template: `npm create vite@latest` (React), `nest new` (NestJS), `dotnet new` (C#), `npx create-expo-app` — check current names/versions, don't trust memory.
3. Which test tiers are needed now? (unit always; others per `guidance/standards/testing.md`)
4. Docker for local services or deployment?
5. Which agent tier(s) and platforms will work in this repo? (feeds `essential-behaviours`)

## Steps

1. Run `scripts/check-prereqs.sh` and resolve anything missing.
2. Scaffold with the chosen templating tool at its latest version (`guidance/standards/dependencies.md` applies), or manually create the minimal layout: src/, test/, scripts/, docs/index.md, README.
3. Wire the toolchain (lint/format/typecheck scripts) — follow the `toolchain-setup` skill.
4. Create per-suite test scripts for the chosen tiers — follow the `testing-setup` skill.
5. Write a README: what the project is, how to run it, how to test it; create `docs/index.md`.
6. Install guidance + hooks: run `dev-qual/install.sh` — or follow the `essential-behaviours` skill.

## Scripts

- `dev-qual/scripts/check-prereqs.sh`
- `dev-qual/install.sh`

## Validate

- `dev-qual/scripts/check.sh` passes on the fresh project.
- README and `docs/index.md` exist and describe reality.
- A trivial commit succeeds through the pre-commit hook.
