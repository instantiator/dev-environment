---
type: process
title: Testing loop
description: Short change-test cycles and which test suite to run when. Read when working through a multi-step coding task.
tags: [process, testing]
---

# Testing loop

Favour short testing cycles:

1. Make a small group of changes, grouped by purpose.
2. Write tests for them and run them.
3. Fix anything that fails, or move on to the next group.

## Which suites, when

- **After every change**: unit tests (fast, no external services) — `scripts/check.sh` includes them.
- **After completing a task**: every other suite expected to take less than 1 minute
  (`dev-environment/scripts/run-tests.sh all` discovers and runs the project's suites).
- **Slower suites** (integration/e2e/smoke needing services): ask the user before running them.
- Suite organisation and naming: [testing standards](../standards/testing.md).

Do not rely on remembering this: install the git hooks (`dev-environment/scripts/setup-hooks.sh`) so pre-commit runs the fast checks and pre-push runs the full gate.
