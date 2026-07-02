---
type: standard
title: Documentation standards
description: How project documentation is organised and written. Read when writing or updating docs, or adding a feature that needs documenting.
tags: [standards, documentation, markdown]
---

# Documentation standards

- Every high-level part of the system architecture gets a doc describing what it does and why it exists.
- Keep a `docs/index.md` that lists every doc with a one-line description — docs nobody can find don't exist.
- Document important flows (request handling, auth, deployment) step by step.
- Illustrate with mermaid diagrams in markdown where a diagram beats prose (sequence diagrams for flows, graphs for topology).
- Use GitHub-flavoured markdown: tables for enumerable facts, code fences with language tags, relative links between docs.
- Documentation describes *current* behaviour. When code changes, update the related docs in the same change; remove docs for removed code.
- Record architectural decisions as ADRs in `docs/ADRs/NNNN-title.md` with context, decision, and consequences (see the `adr` skill).
- Markdown style rules: [markdown](../languages/markdown.md).
