---
type: standard
title: Docker Compose standards
description: Structuring compose files for local dev and testing. Read when creating or editing docker-compose files.
tags: [docker, compose, framework]
---

# Docker Compose

- Give every long-running service a `healthcheck`, and gate dependants with `depends_on: {service: {condition: service_healthy}}` — "started" is not "ready".
- Use profiles for optional groups (e.g. `--profile auth`) so the default `up` stays fast and minimal.
- Keep environment in `.env` files (git-ignored) with a committed `.env.example`; never commit real values.
- Name volumes for anything that must survive restarts; leave everything else ephemeral.
- Pin image versions, same rule as [docker](docker.md).
- Bind ports only where a human or test needs them; prefer the internal network between services.
- Test scripts that need services should start and stop them themselves (`docker compose up -d --wait` / `down`) — see [testing](../standards/testing.md).

## Verification

- `docker compose config` validates the file — run it after every edit.
