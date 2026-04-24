---
description: Manually snapshot current state into .claude/context/pack.md
---

Run `bash .claude/hooks/pre-compact.sh` to regenerate the context pack.

Then Read `.claude/context/pack.md` and return a **5-bullet summary** of:
- current branch + tree state
- latest PRD / design / ADR / task files
- open tasks (status != done)
- recent commits
- immediate next action the user should expect

The goal: any future turn (including after `/compact`) can bootstrap from this file instead of replaying history.
