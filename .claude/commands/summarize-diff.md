---
description: One-glance summary of current working-tree changes
---

Summarize the current changes across the working tree so the user can review scope in seconds.

Steps:
1. Run `git status --short` to list tracked + untracked changes.
2. Run `git diff --stat HEAD` to get file-level insert/delete counts (includes staged + unstaged).
3. For each changed file, produce a one-line summary of *what* changed and *why it matters* — infer intent from the diff, not just file names.
4. Flag any risky or sensitive areas: auth, secrets, DB schema/migrations, external network calls, dependency bumps, CI config.

Output format:
```
Totals: <N files>, +<insertions>/-<deletions>

Files:
- path/to/file — <one-line summary>
- ...

Risk flags (if any):
- <file>: <why it's risky>
```

Do not paste raw diff content. If there are no changes, say so and stop.

$ARGUMENTS (optional) — if provided, constrain the summary to this path or ref range.
