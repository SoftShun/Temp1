---
description: Draft a Conventional Commits message for the current staged diff
---

Run `git diff --staged --stat` and `git diff --staged` to inspect the staged changes. Then produce a commit message draft using the Conventional Commits format (`feat` / `fix` / `chore` / `docs` / `refactor` / `test` / `perf` / `build` / `ci`).

Rules:
- Subject line ≤ 72 chars, imperative mood, focused on the *why* rather than the *what*.
- Include a scope in parentheses only when it is obvious from the diff (e.g. `feat(auth): …`).
- Body: 2–5 bullets for non-obvious changes, blank line between subject and body.
- Do **not** run `git commit`. Only present the draft in a fenced block so the user can copy or ask for revisions.
- If the staged diff is empty, say so and stop.

$ARGUMENTS (optional) — a short hint the user wants reflected in the subject.
