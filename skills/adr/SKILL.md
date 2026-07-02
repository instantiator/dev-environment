---
name: adr
type: skill
title: ADR
description: Think through and record an architectural decision. Use when making architecture, infrastructure, or significant design choices.
tags: [skill, architecture, adr]
---

# ADR (architectural decision record)

## When to use

Any decision that shapes the system: component/service selection, data storage, auth approach, framework choice, significant refactors, problem-solving approaches with lasting consequences.

## Questions to ask

1. What is the decision context — the problem, and the constraints (cost, team, existing stack)?
2. Which options are on the table? (Research current reality — `guidance/infra/choosing-components.md` for cloud choices.)
3. What matters most here: simplicity, cost, performance, operability?

## Steps

1. Think architecturally before writing: prefer the simplest architecture that meets the need; not wasteful, no speculative components (they can be added when actually needed).
2. Compare 2–3 realistic options with honest trade-offs; recommend one and discuss with the user before committing.
3. Scaffold the record: `skills/adr/scripts/adr-new.sh "Title"` creates `docs/ADRs/NNNN-title.md` with the standard sections.
4. Fill it in: Context, Decision, Options considered, Consequences (including what becomes harder), Status.
5. Add the ADR to `docs/index.md`; if it supersedes an earlier ADR, mark that one Superseded with a link.

## Scripts

- `skills/adr/scripts/adr-new.sh` — numbering and template scaffold.

## Validate

- The ADR exists, is indexed in `docs/index.md`, and states the decision and its consequences clearly enough that a newcomer understands *why* without asking.
