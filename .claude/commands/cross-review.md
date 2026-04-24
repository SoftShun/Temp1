---
description: Parallel multi-model, multi-perspective review (code + a11y + security + QA), consolidated into one report
---

ultrathink

Review target: $ARGUMENTS (git ref range, a path, or empty for staged diff).

## Workflow
1. Launch **four subagents in parallel** (single message, four Agent tool calls). Each holds its own context so the main session stays clean:
   - `code-reviewer` (model: opus) — overall correctness, design cohesion, readability, test coverage.
   - `ux-a11y-reviewer` (model: haiku) — WCAG 2.2 AA, UX, keyboard/focus/contrast.
   - `frontend-security-reviewer` (model: sonnet) — OWASP, XSS/CSP/auth/secrets.
   - `qa-tester` (model: sonnet) — acceptance-criteria mapping, edge cases, regression risks, manual QA script.
2. Wait for all four to return.
3. Consolidate into one report with these sections, citing `file:line` per finding:
   - **Blockers** — anything any reviewer marked blocking.
   - **Agrees** — items raised by two or more reviewers.
   - **Disagrees** — explicit contradictions between reviewers.
   - **Gaps** — raised by only one reviewer but in scope.
   - **QA plan** — the `qa-tester` manual script and automated test suggestions, unedited.
4. Do NOT paste raw reviewer output — distill.

## Fifth perspective (external)
A correctness re-check via the user's local Codex CLI is expected for large changes. If the user has not run it, note that at the end of the report and suggest the command.

## Cost awareness
Running four subagents multiplies token usage. Trigger `/cross-review` on PR-level changes, not every micro-edit.
