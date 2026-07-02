# dev-environment

Guidance, skills, and scripts that help coding agents (Claude Code, OpenCode, or any other) deliver consistently high-quality code — designed so that even small-context models can complete features and fixes to a high standard.

## What's here

| Path | What it is |
|-|-|
| `agents-files/` | Entry-point instructions to copy/merge into your project (`local/` for small-context agents, `remote/` for capable ones, plus a Claude Code variant) |
| `guidance/` | Condensed standards and process docs, one topic per file, routed by `guidance/index.md` |
| `skills/` | Step-by-step playbooks for multi-step tasks (project setup, CI, reviews, deploys, ADRs, ...), routed by `skills/index.md` |
| `scripts/` | The automation: `check.sh` (quality gate), `run-tests.sh`, `check-prereqs.sh`, `setup-hooks.sh`, git hooks |
| `adapters/` | Wiring for specific agent platforms (Claude Code skills + hooks, OpenCode) |

## Install into a project

```bash
git submodule add https://github.com/instantiator/dev-environment
./dev-environment/install.sh
```

The installer is interactive: it asks which agent tier(s) and platforms you use, merges entry files into your repo (never clobbering existing AGENTS.md/CLAUDE.md), and offers to install the git hooks that run the quality gate on commit and push. Re-run it any time.

Prefer manual setup? Copy a file from `agents-files/` to your repo root, then run `./dev-environment/scripts/setup-hooks.sh`.

## The quality gate

`scripts/check.sh` detects your project type and runs format check → lint → typecheck → build → unit tests → `aislop scan`, printing PASS/FAIL with a fix-hint per failure. The git hooks run it automatically (`--fast` on commit, full on push) — so quality doesn't depend on anyone, human or model, remembering.

## Third party tools

Some of these rules refer to and lean on third party tools. With gratitude:

| Tool | Description | License |
|-|-|-|
| [aislop](https://github.com/scanaislop/aislop) | Catch the slop AI coding agents leave in your code: narrative comments, swallowed exceptions, as-any casts, dead code, oversized functions. 50+ rules across 8 languages. | [MIT](https://github.com/scanaislop/aislop?tab=MIT-1-ov-file) |
| [ponytail](https://github.com/DietrichGebert/ponytail) | Makes your AI agent think like the laziest senior dev in the room. The best code is the code you never wrote. | [MIT](https://github.com/DietrichGebert/ponytail?tab=MIT-1-ov-file) |
