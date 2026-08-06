---
type: standard
title: Common standards
description: Non-negotiable rules for all code in any language. Read before any coding task.
tags: [standards, all-languages]
---

# Common standards

- Less is more: aim for concise, readable code and simple interfaces.
- Use clear function and variable names.
- Keep compiler/build errors AND warnings at 0.
- Keep linter errors AND warnings at 0 (formatting issues count as linter warnings).
- If reaching 0 would be unnecessarily complicated or undesirable, ask the user how to proceed.
- Where not specified in these docs, follow the common conventions of the language in use.

## Comments

- Use documentation comments for all classes, interfaces, enums, enum values, methods, functions, variables, and consts (skip very simple values or functions).
- Comments state the *intent* of the thing, not how it works (implementation that no longer matches its comment is then easy to spot).
- Prefer multi-line documentation comments; inside a code block, a single-line comment (`#` / `//`) is fine when it fits on one line.
- Link to types and members mentioned in comments: `{@link TheType}` (TS/JS), `<see cref="MyClass.MyMethod"/>` (C#).
- No decorative break comments (`// ── Validate ──────`); use a plain single-line comment (`// Validate inputs`) if a file needs breaking up.

### Structuring a documentation comment

Clarity beats brevity: a comment that costs a few more lines but separates its
concepts is the better comment.

- Open with a single short sentence saying what the thing *is*. Leave a blank line before anything else.
- Give each further concept its own paragraph or list item, rather than running them together in one dense sentence.
- Number the steps of anything sequential (stages, phases, fallbacks) as a list.
- Never assume the reader can unpack a compressed term the code doesn't define: write "handles SIGINT in two stages", not "two-stage SIGINT".
- Prefix a side note with `NB.` — used for caveats and guarantees about parameters or callers, as opposed to the thing's own purpose.

```ts
/**
 * Plain readline loop (no TUI).
 *
 * Handles SIGINT in two stages:
 * 1. During a turn, stop watching (the agent continues server-side).
 * 2. At the idle prompt, clean up and exit.
 *
 * NB. `--company-id` without `--role-id` is rejected before this mode can
 * ever be reached, so `rootAgentId` is guaranteed to be a real agent here.
 */
```

## Working in small steps

- Group changes by purpose; make a small group of changes, test them, then move on (see [testing-loop](../process/testing-loop.md)).
- After every change, run `scripts/check.sh` from dev-qual and fix what it reports.
