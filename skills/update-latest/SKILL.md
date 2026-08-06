---
name: update-latest
type: skill
title: Update to latest
description: Bring a project's installed guidance, skills, scripts, and hooks up to date without losing customisations. Use when the dev-qual submodule has moved on, or setup looks stale.
tags: [skill, maintenance, upgrade]
---

# Update to latest

## When to use

The `dev-qual` submodule has been updated, setup was installed a while
ago, or something in `.claude/` or the git hooks looks out of date.

## Questions to ask

1. Update the submodule itself first, or only re-align the project with the checkout it already has?
2. Has the user deliberately customised any of the installed files? (The report will show which; ask before touching those.)

## Steps

1. Update the checkout, unless the user asked to stay on the current one:
   `git submodule update --remote dev-qual`
2. Run `dev-qual/scripts/check-install.sh`. It compares the project against the checkout and reports PASS / FAIL / SKIP per item: the `AGENTS.md` block and its skills routing, `CLAUDE.md`, `.claude/skills/`, `.claude/settings.json`, and the git hooks.
3. For each FAIL, look at what actually differs before changing anything:
   - `git -C dev-qual log --oneline <old>..HEAD -- <path>` for what changed upstream,
   - `diff` the project's copy against the checkout's for what the user changed.
4. Tell the user what each difference is, and which side you propose to keep. Anything that looks like a deliberate local customisation gets kept unless they say otherwise.
5. Apply the mechanical updates by re-running the installer: `./dev-qual/install.sh` (idempotent — it replaces its own marked block and never clobbers unmarked content).
6. Merge by hand anything the installer does not own: an edited `CLAUDE.md`, hooks installed with `--copy`, custom entries in `.claude/settings.json`. Take the upstream version and re-apply the user's edits on top; never drop an edit silently.
7. Re-run `check-install.sh` until everything is PASS or the remaining FAILs are customisations the user chose to keep.
8. Run `dev-qual/scripts/check.sh` — an updated gate may report things the old one did not.

## Bootstrapping a project that does not have this skill

Nothing needs installing first — the installer carries the skill in with it:

```bash
git submodule update --remote dev-qual && ./dev-qual/install.sh
```

## Scripts

- `dev-qual/scripts/check-install.sh` — the drift report.
- `dev-qual/install.sh` — re-runnable installer for the mechanical parts.

## Validate

- `check-install.sh` reports no unexplained differences.
- Every customisation the user chose to keep is still present in the file.
- `check.sh` passes, and a test commit still triggers the pre-commit hook.
