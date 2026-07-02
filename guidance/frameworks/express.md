---
type: standard
title: Express standards
description: Structure, error handling, and validation for Node + Express apps. Read when working in an Express application.
tags: [express, node, backend, framework]
---

# Node + Express

- Structure by feature: `routes/`, thin route handlers, logic in plain service modules that can be tested without HTTP.
- Centralise error handling in one error middleware (4-arg signature) registered last; async handlers must forward errors (`next(err)` or an async wrapper) — unhandled promise rejections are the classic Express bug.
- Validate inputs at the boundary (e.g. `zod` or `express-validator`) before any logic runs.
- Never trust `req.body`/`req.query` types — parse and narrow them.
- Set security headers (`helmet`), and configure CORS explicitly rather than `*` in production.
- Read config from env once at startup into a typed config module; fail fast on missing values.
- Expose a health endpoint (`/healthz`) for deploy checks.
- Test route handlers via `supertest`; test services as plain units.
