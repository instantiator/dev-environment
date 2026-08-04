---
type: process
title: Outstanding work
description: Recording deferred work so it survives the session, and reviewing it when conditions are met. Read when work finishes with follow-ups, or at the end of a task.
tags: [process, deferred, tracking]
---

# Outstanding work

Anything you leave undone must be written down where the next person — or the
next model — will find it. A note in a summary the user scrolls past is lost.

## Where it lives

`docs/outstanding-issues.md`, listed in `docs/index.md`. One table:

| Item | Why deferred | Condition to act | Where |
|-|-|-|-|
| Wire `hadolint` into the gate | No Dockerfile in this repo yet | A `Dockerfile` exists at the repo root | `scripts/check.sh` |

Tell the user about every item you add, in your final summary of the work.

## Writing the condition

"Return to this later" is not a condition — nobody can tell whether it is time.
A condition must be checkable without judgement:

- a version or release (`aislop ships a Python ruleset`),
- a date (`after 2026-09-01`),
- a file or directory existing (`the project adds a migrations/ directory`),
- a state you can test (`the integration suite runs in CI`),
- a decision the user has taken (`the user picks a hosting platform`).

If you cannot state one, ask the user for it before writing the entry. An item
without a condition is a `TODO` that never fires — see
[pitfalls](../standards/pitfalls.md).

## Memory is a mirror, not the record

Where the agent platform has a memory (Claude Code does; many do not), also
store the item there with the *same* measurable condition, so it surfaces
without anyone opening the file. The file still governs: memory is per-user and
per-platform, and it does not survive into a colleague's checkout or a PR
review.

## Reviewing conditions

Run this after the last unit of work in a task ([testing-loop](testing-loop.md)):

1. Read `docs/outstanding-issues.md` and any platform memories of deferred work.
2. Evaluate each condition against the state of the repo as it now is.
3. Condition met **and** the task is trivial: do it, and tell the user you did.
4. Condition met **and** the task is not trivial: collect these into a table and
   ask the user which to include in the current work.
5. Condition not met: leave it. Do not re-litigate it in the summary.
6. Delete completed items — the table records what is outstanding, not history.
