---
type: standard
title: Quality principles
description: The named code quality frameworks and what they mean in practice, per paradigm. Read when planning a unit of work, or reviewing one.
tags: [standards, principles, review]
---

# Quality principles

Two checklists. The rest of `standards/` is the detail behind them.

## Before a unit of work

- **YAGNI** — does this need to exist at all? Speculative need is not need. No abstraction with one implementation, no config for a value that never changes.
- **KISS** — is there a boring solution? Standard library, then platform feature, then an already-installed dependency, before anything new ([dependencies](dependencies.md)).
- **Single responsibility** — does each piece do one thing? This applies to a function, a module, a script, or a class; it does not need objects to be true.

## After a unit of work

- **Correctness** — it does what was asked, and the tests prove it rather than just executing it.
- **Clarity** — the next reader follows it without decoding ([readability](readability.md)).
- **Completeness** — edge cases, error paths, tests, and docs, not just the happy path.
- **Consistency** — it looks like the code around it: same naming, same idioms, same structure.

## The review lens

Readability, Maintainability, Efficiency, Reliability, Security — used in
[quality-review](../../skills/quality-review/SKILL.md). Efficiency means "not
obviously wasteful", not "optimised"; measure before trading clarity for speed.

## SOLID, per paradigm

SOLID was written for class hierarchies. Take what applies to the code in front
of you and leave the rest — forcing it produces exactly the speculative
structure YAGNI forbids.

| Principle | Object-oriented (C#, NestJS) | Functional / procedural (TS, Python, shell) |
|-|-|-|
| Single responsibility | One reason to change per class | One purpose per function, module, or script |
| Open/closed | Extend via inheritance or composition | Largely inert — prefer editing the code over building extension points nobody asked for |
| Liskov substitution | Subtypes honour the base contract | Inert without subtyping; the equivalent is "every implementation of a callback keeps the same contract" |
| Interface segregation | Small, role-specific interfaces | Don't make a caller supply arguments it doesn't use |
| Dependency inversion | Depend on abstractions, inject them | Take collaborators as parameters; in shell, take paths and flags as arguments rather than hardcoding them |

Applying open/closed or Liskov to a Python script or a bash file is a sign the
principle is being followed for its own sake. Say so and move on.
