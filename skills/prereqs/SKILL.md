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

1. Run `dev-environment/scripts/check-prereqs.sh` — it detects the project type, checks each tool, and prints per-OS install commands for anything missing.
2. With the user's go-ahead, run the printed install commands for the detected OS.
3. Re-run `check-prereqs.sh` until everything required is green.
4. For project-specific tools the script doesn't know (check the project README), verify with `command -v` and install the same way.

## Scripts

- `dev-environment/scripts/check-prereqs.sh` (does 90% of the work)

## Validate

- `check-prereqs.sh` exits 0 (all required tools present).
- `dev-environment/scripts/check.sh` runs without SKIPs caused by missing tools.
