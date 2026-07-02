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

## Working in small steps

- Group changes by purpose; make a small group of changes, test them, then move on (see [testing-loop](../process/testing-loop.md)).
- After every change, run `scripts/check.sh` from dev-environment and fix what it reports.
