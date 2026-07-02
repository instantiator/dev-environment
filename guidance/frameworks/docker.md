---
type: standard
title: Docker standards
description: Writing correct, small, secure Dockerfiles. Read when creating or editing a Dockerfile.
tags: [docker, containers, framework]
---

# Docker

- Use multi-stage builds: build stage with the SDK/toolchain, final stage with only the runtime and built artefacts.
- Run as a non-root user in the final stage (`USER node` / create an app user).
- Pin base images to a specific version tag (verify what is current — [dependencies](../standards/dependencies.md)); prefer slim/alpine variants where the app allows.
- Add a `.dockerignore` (node_modules, .git, dist, test output) — smaller context, no secret leakage.
- Order layers for cache efficiency: copy dependency manifests and install first, then copy source.
- One process per container; use `CMD` in exec form (`CMD ["node", "dist/main.js"]`).
- Define a `HEALTHCHECK` (or rely on compose/orchestrator healthchecks — [docker-compose](docker-compose.md)).
- Never bake secrets into images (no `ENV API_KEY=...`, no secrets in build args).

## Verification

- Lint every Dockerfile with `hadolint` and fix all findings.
- `docker build` must succeed cleanly; test the image runs before committing.
