# Claude Code instructions

Follow `dev-qual/agents-files/remote/AGENTS.md` — those rules are mandatory. If this project has its own AGENTS.md merged from it, that copy governs.

## Claude Code specifics

- Skills from `dev-qual/skills/` may be installed at `.claude/skills/` — prefer invoking them over improvising the same workflow.
- If hooks are configured (via `dev-qual/adapters/claude-code/`), `check.sh --fast` runs automatically after edits — read its output in the transcript and fix failures; don't re-run it redundantly.
- Otherwise run `dev-qual/scripts/check.sh` yourself after every change.
- Git hooks installed by `dev-qual/scripts/setup-hooks.sh` are the final gate: a failing pre-commit means fix the reported problems, never `--no-verify`.
- Mirror deferred work into memory with the same measurable condition it has in `docs/outstanding-issues.md` — the file is still the record, memory is only a reminder.
