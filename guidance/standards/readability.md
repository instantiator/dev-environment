---
type: standard
title: Readability and structure
description: How to structure code so developers can find and understand it. Read when creating files, modules, or refactoring.
tags: [standards, structure, readability]
---

# Readability and structure

- Keep functions and methods short — one purpose each. If a function needs a paragraph to describe, split it.
- Break supporting functions out into their own files or modules; keep the calling code readable as a narrative.
- Group functions by purpose; group classes/interfaces/types by purpose (one concept per file where the language convention allows).
- Group directories and files logically by intent, so code is discoverable by someone who has never seen it.
- Make the entry point obvious: a newcomer should find "where execution starts" from the README or the directory layout in under a minute.
- Prefer boring, conventional solutions over clever ones (clever is what someone has to decode at 3am).
- Delete dead code rather than commenting it out (git remembers it).
