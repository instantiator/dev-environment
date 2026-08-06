---
name: prereqs
type: skill
title: Prerequisites
description: Check and install the tools a project needs. Use on a fresh machine, at onboarding, or when a required tool is missing.
tags: [skill, prerequisites, onboarding]
---

# Prerequisites

## When to use

A command fails because a tool is missing, or setting up a new machine/contributor for the project.

## Questions to ask

1. Which OS and package manager? (mac/brew, linux/apt, windows/winget — usually detectable, confirm if ambiguous.)
2. OK to install missing tools now, or just report them?

## Steps

1. Run `dev-qual/scripts/check-prereqs.sh` — it detects every stack present, checks each tool, and prints the install command for anything missing.
2. Show the user what is missing and what installing it would run. With their go-ahead, either run the printed commands or re-run with `--install`, which runs them and re-checks.
3. Re-run `check-prereqs.sh` until everything required is green.
4. For project-specific tools the script doesn't know (check the project README), verify with `command -v` and install the same way.

## Linters per language

Every language in the repo needs its linter installed, or the quality gate SKIPs
it and problems ship. The script checks these:

| Stack | Tools |
|-|-|
| Node / TypeScript | node, npm (ESLint and Prettier come from the project's own dependencies) |
| C# | the .NET SDK (analyzers and `dotnet format` ship with it) |
| Python | ruff (required), mypy, pytest, pip-audit |
| Shell | shellcheck |
| Markdown | markdownlint |
| Docker | hadolint |
| CI workflows | actionlint |

## Scripts

- `dev-qual/scripts/check-prereqs.sh` (does 90% of the work); add `--install` to install what's missing.

## Validate

- `check-prereqs.sh` exits 0 (all required tools present).
- `dev-qual/scripts/check.sh` runs without SKIPs caused by missing tools.
