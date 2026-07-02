---
name: essential-behaviours
type: skill
title: Essential behaviours
description: Install the enforcement that makes key behaviours automatic. Use at project onboarding, or when asked to make sure something always happens.
tags: [skill, hooks, enforcement]
---

# Essential behaviours

## When to use

Onboarding a project into this guidance system, or the user says "make sure X always happens" (tests after changes, formatting, slop scans).

## Why this skill exists

Behaviours that live in an agent's memory get forgotten — especially by small-context models. Anything essential must be enforced by machinery: git hooks catch every commit regardless of which model, editor, or human made it.

## Questions to ask

1. Which behaviours matter here? (Default: quality gate on commit and push.)
2. Which agent platforms are in use — Claude Code, OpenCode, others? (Determines which adapters to install.)
3. Does the project already have git hooks to preserve? (If yes, use `--copy` mode.)

## Steps

1. Install the git hooks: `dev-environment/scripts/setup-hooks.sh` (add `--copy` if the project has its own hooks). This gives pre-commit → `check.sh --fast` and pre-push → full `check.sh`.
2. For Claude Code: run `dev-environment/adapters/claude-code/install.sh` — installs skills into `.claude/skills/` and offers the automatic post-edit check hook.
3. For OpenCode and other AGENTS.md-reading agents: run `dev-environment/adapters/opencode/install.sh` — injects the skills routing block into the project's AGENTS.md.
4. Make sure an entry file from `agents-files/` is merged into the repo root (the installer does this; check it happened).

## Scripts

- `dev-environment/scripts/setup-hooks.sh`
- `dev-environment/adapters/claude-code/install.sh`, `dev-environment/adapters/opencode/install.sh`

## Validate

- A deliberately bad commit (e.g. a lint error) is blocked by pre-commit with actionable output; revert the test change after.
- The platform adapters' files exist where expected (`.claude/skills/`, AGENTS.md routing block).
