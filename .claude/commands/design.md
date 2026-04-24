---
description: Ultrathink-driven architecture design — architect agent + built-in Plan agent cross-check
---

ultrathink

Produce a robust, cross-checked design doc for: $ARGUMENTS.

Workflow:
1. Invoke the `architect` subagent with the topic. Let it return its full design doc (10 sections).
2. Pass that design to the built-in `Plan` subagent with this instruction: "Independently assess this design. List (a) agreements, (b) disagreements with reasons, (c) missed constraints or options, (d) concrete rewrites you would make. Do not rewrite the doc — just critique."
3. Summarize the delta between the two outputs for the user: key agreements, the top 3 disagreements, and must-resolve open questions.
4. If the user approves, write the finalized design to `docs/designs/<kebab-case-slug>.md`. Create the folder if absent. Do **not** commit automatically — leave staged for user review.

Rules:
- Never begin implementation until the user explicitly approves the design.
- If the architect replied "No design needed", do not escalate to Plan — just forward that verdict and stop.
- Keep the consolidated user-facing delta under 300 words.
