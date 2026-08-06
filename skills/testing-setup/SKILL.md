---
name: testing-setup
type: skill
title: Testing setup
description: Add test suites and per-suite launch scripts to a project. Use when a project lacks tests or needs a new test tier.
tags: [skill, testing]
---

# Testing setup

## When to use

The project has no tests, a tier is missing (e.g. integration), or tests exist but there's no easy way to launch them.

## Questions to ask

1. Which tiers are needed? unit / integration / e2e / browser / api / smoke (`guidance/standards/testing.md` describes them).
2. Which test framework? Match what the project or its ecosystem already uses (Jest/Vitest for TS, xUnit for C#).
3. What do the slower tiers need — Docker services, running app, auth? What's the test data strategy?

## Steps

1. Read `guidance/standards/testing.md`.
2. Add the framework and config per tier (separate configs so tiers run independently; e.g. jest configs per tier, or xUnit categories).
3. Create one launch script per tier: `scripts/run-<suite>-tests.sh` in the project, from the template in this skill's `scripts/` directory. Each script starts/stops any services it needs.
4. Create `scripts/run-all-tests.sh` that runs the tiers in order, fastest first.
5. Wire the unit tier into the project's default test command (npm `test` / `dotnet test`) so `check.sh` picks it up.
6. Add one real test per tier (not a placeholder) that exercises actual behaviour.

## Scripts

- `scripts/run-suite-template.sh` (in this skill) — copy per suite and fill in the marked sections.

## Validate

- Each `scripts/run-<suite>-tests.sh` runs and exits 0.
- `dev-qual/scripts/run-tests.sh all` discovers and runs every tier.
- A deliberately broken assertion makes the right suite fail.
