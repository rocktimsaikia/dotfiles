---
name: debug-sentry-issue
description: Debug a Sentry issue by inspecting the event details, cross-checking against the relevant code path, config, and data, then producing a concise findings report.
---

Debug the following Sentry issue: $ARGUMENTS

Goal: determine the root cause of the Sentry failure by inspecting the event details, cross-checking against the relevant code path, config, and data, then produce a concise findings report.

## Workflow

1. Use Sentry MCP to fetch and analyze the Sentry issue or event from the URL above. Inspect:
   - the top-level error message and exception type
   - full stack trace, including in-app frames vs library frames
   - recent occurrences, frequency, first/last seen, and affected releases
   - tags, breadcrumbs, and event context (user, request, server, environment)
   - any request payload, response, or arguments captured in the event
   - related issues or events grouped under the same fingerprint

2. Identify the failing callsite. Open the file and function from the in-app stack frame that raised the error and read enough surrounding code to understand:
   - what inputs the function expects
   - what external systems it calls (DB, cache, third-party APIs, queues)
   - what assumptions or invariants are implicit in the code path

3. Cross-reference the failing event against the relevant code, config, and data. Depending on the error type, check for mismatches in:
   - input shape, type, or null-safety vs. what the code expects
   - schema drift between the payload and the model, serializer, or external API contract
   - config or env var values across environments
   - DB state (missing rows, stale data, migration not applied)
   - cache staleness or wrong cache key
   - third-party API response format changes
   - permission, auth, or scope mismatches
   - timing / race conditions across concurrent code paths

4. Determine the root cause. Common causes include:
   - recent code change introducing a regression (check `git log` / `git blame` on the failing line)
   - missing or null field in the payload that the code dereferences
   - type mismatch or unexpected shape from upstream
   - external API contract drift
   - missing migration or DB state inconsistent with the code
   - race condition or ordering bug between async tasks
   - config mismatch between staging and production
   - stale cache returning outdated data
   - input validation gap allowing invalid data through

5. If the root cause points to application code, inspect the relevant path in `api/` or `web/` and identify the exact callsite to change. Follow the repository rules before editing:
   - backend: `docs/claude/backend.md`
   - frontend: `docs/claude/frontend.md`

## Report

Return the findings using this structure:

### Summary
[short description of the Sentry error]

### Evidence
- [concrete fact from the event: stack frame, payload field, tag value, etc.]

### Root cause
[single concrete root-cause statement]

### Recommended fix
- [code change, config update, data fix, or combination]

## Rules

- Do not stop at the exception message; inspect the actual payload, stack trace, and the code path that raised it.
- Prefer exact evidence over guesses. Quote concrete values from the event (field names, types, frame locations) rather than paraphrasing.
- If the issue cannot be fully proven from the Sentry event and local code, separate confirmed facts from likely causes and call out what would prove or disprove each hypothesis.
- If the failing code path touches a domain with its own debug command (e.g. Zoko templates), suggest the user run that more specific command instead.
- Do not propose a fix until the root cause is concretely identified.
