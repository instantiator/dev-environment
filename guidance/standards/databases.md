---
type: standard
title: Database standards
description: Transactions, migrations, and safe queries. Read when writing code that reads from or writes to a database.
tags: [standards, database, sql, transactions]
---

# Databases

## Transactions

- Changes that must succeed or fail **together** belong in one transaction. If a partial application would leave the data wrong, it is one transaction — not several calls in sequence.
- Name the unit of work the transaction represents, in the function's documentation comment: "creates the order and reserves its stock, atomically".
- Never leave a partial write behind on an error path. If the operation fails, the transaction rolls back — do not "clean up" with compensating writes when a rollback would do.
- Do not hold a transaction open across a network call, user interaction, or long computation. Gather what you need first, then open the transaction, then commit.
- Handle the failure the database can always produce: deadlocks and serialisation failures. Either retry the whole transaction or let it propagate — never swallow it ([pitfalls](pitfalls.md)).
- Read-modify-write across two statements is a race. Use a single statement, a constraint, or an explicit lock.

## Queries

- **Parameterised queries only.** Never build SQL by string concatenation or interpolation, including for identifiers and `IN` lists — use the driver's parameter binding or the query builder's.
- Let the database enforce what it can: not-null, unique, foreign keys, check constraints. A constraint is worth more than the application code that tries to remember the same rule.
- Watch for N+1 queries when loading related rows; fetch in one query or batch.

## Migrations

- Every schema change is a versioned migration in the repository, applied by a tool — never a hand-run statement against an environment.
- Migrations are forward-only by default. Where a rollback is genuinely needed, write it and test it.
- Review the generated migration before applying it. An unexpected drop or rename: stop and ask ([infra/verification](../infra/verification.md)).
- Deploying a schema change alongside code: make the schema change backwards-compatible first, deploy the code, then remove what is now unused. Three steps, not one.

## Testing

- Test the rollback path, not only the commit path: force a failure mid-transaction and assert that nothing was written.
- Test against the same engine the project runs in production — an in-memory substitute will not reproduce its constraint or locking behaviour.
