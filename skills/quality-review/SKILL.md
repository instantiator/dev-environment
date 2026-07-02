---
name: quality-review
type: skill
title: Quality review
description: Review and repair code quality after changes. Use after completing coding work, when asked to review code, or when check.sh fails.
tags: [skill, review, quality]
---

# Quality review

## When to use

After a coding task, on request ("review this"), or when the quality gate reports failures.

## Questions to ask

1. Scope: just the changed code, or adjacent code too? (Default: changed code plus anything it touches.)
2. Fix problems directly, or report them for the user to decide?

## Steps

1. Run `dev-environment/scripts/check.sh` — fix every FAIL it reports first (mechanical problems before judgment ones).
2. Read `guidance/standards/pitfalls.md`, then review the diff for each pitfall (swallowed errors, stale comments, unconditioned TODOs, dead code, `any` casts).
3. Look for improvements in modified *and adjacent* code:
   - simplify long functions (`guidance/standards/readability.md`);
   - DRY up duplicate or *similar* code — near-duplicates count;
   - check each comment states intent and still matches the code;
   - confirm the code matches the stated intent of the task.
4. Enforce the documented standards for the languages/frameworks involved (route via `guidance/index.md`).
5. Check test coverage of the changed behaviour, including edge cases; add missing tests.
6. Re-run `check.sh` after fixes.

## Scripts

- `dev-environment/scripts/check.sh`
- `npx aislop scan` (included in check.sh where available)

## Validate

- `check.sh` passes.
- Every finding was either fixed or reported to the user with a recommendation — none silently dropped.
