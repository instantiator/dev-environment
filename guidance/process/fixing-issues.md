---
type: process
title: Fixing issues
description: Hypothesis-driven approach to bugs. Read when the user reports an issue or asks for a fix.
tags: [process, debugging]
---

# Fixing issues

- Review what you know and develop hypotheses about possible causes.
- For each hypothesis you cannot rule out: establish how to test it, and plan the fix if it proves true.
- Present hypotheses in order of likelihood, and explain the tests. Where possible, run the tests yourself to establish which hypothesis is correct.
- Never patch a symptom before you have a confirmed cause.
- If there are multiple fix approaches, present them and recommend the one that is least hacky, simplest, and introduces the least technical debt and fewest special cases.
- After fixing: add a test that fails without the fix, then follow [after-coding](after-coding.md).
