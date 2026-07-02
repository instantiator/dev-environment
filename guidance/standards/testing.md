---
type: standard
title: Testing standards
description: How test suites are organised, named, and launched. Read when writing tests or setting up testing.
tags: [standards, testing]
---

# Testing standards

- Separate test suites by tier: unit, integration, e2e, browser, api, smoke — each independently runnable.
- Provide one launch script per suite: `scripts/run-<suite>-tests.sh` (e.g. `scripts/run-unit-tests.sh`), plus `scripts/run-all-tests.sh` to run every tier in order. Scripts start/stop any services they need (e.g. docker compose).
- Unit tests need no external services and run fast; slower tiers declare their prerequisites in the script header.
- Test the *intent* of the code: when the tests pass, the code demonstrably does the right thing — not just "the lines were executed".
- Cover edge cases, not only the happy path.
- Write or update tests for all new and modified code; remove tests for removed code.
- `dev-environment/scripts/run-tests.sh <suite>` dispatches to these per-suite scripts automatically.
- When and how often to run which suite: [testing-loop](../process/testing-loop.md).
