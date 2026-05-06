---
name: debug-zoko-template-sentry-issue
description: Debug a Zoko template-related Sentry issue by refreshing the local Zoko template dump, inspecting the Sentry event details, cross-checking the failing payload against `api/static/zoko_templates.json`, identifying template/schema mismatches, and reporting the root cause with a recommended fix.
---

# Debug Zoko Template Sentry Issue

Use this skill when the user asks to investigate a Zoko or WhatsApp template failure reported in Sentry, especially when the problem may be caused by template drift between Codingal code and the live Zoko template definition.

## Input

The user should provide the Sentry issue or event URL as the task argument: $ARGUMENTS

## Goal

Determine whether the Sentry failure was caused by a mismatch between the payload sent by the code and the current Zoko template definition, then produce a concise findings report.

## Workflow

1. Refresh the local Zoko templates dump first.
   Run:
   `api/scripts/zoko-templates.sh`

2. Read the refreshed template data from:
   `api/static/zoko_templates.json`

3. Use Sentry MCP to fetch and analyze the Sentry issue or event provided by the user.
   Inspect:
   - the top-level error message
   - stack trace
   - recent occurrences if available
   - the outbound request payload
   - the template name, template ID, language, and any variables or components in the payload

4. Cross-reference the failing payload against `api/static/zoko_templates.json`.
   Check for mismatches in:
   - template name
   - template ID
   - language code
   - approval or active status
   - parameter count
   - parameter order
   - placeholder numbering such as `{{1}}`, `{{2}}`
   - header, body, footer, and button structure
   - component schema drift between the payload and the stored template definition

5. Determine the root cause.
   Common causes include:
   - template removed or disabled in Zoko
   - template renamed
   - stale template ID in code or config
   - parameter count mismatch
   - parameter order mismatch
   - payload shape drift for header/body/button components
   - wrong language code
   - encoding or content formatting issue

6. If the root cause points to application code, inspect the relevant backend path in `api/` and identify the exact callsite building the Zoko payload.
   Follow the repository backend rules before editing:
   `docs/claude/backend.md`

## Report

Return the findings using this structure:

### Summary
[short description of the Sentry error]

### Mismatches found
- [specific mismatch between payload/code and `api/static/zoko_templates.json`]

### Root cause
[single concrete root-cause statement]

### Recommended fix
- [code change, template update, or both]

## Rules

- Always refresh `api/static/zoko_templates.json` before comparing templates unless the user explicitly says not to.
- Do not stop at the exception message; inspect the actual payload and the live template definition.
- Prefer exact evidence over guesses. Quote concrete template fields, placeholder counts, and component differences.
- If no mismatch is found in the template dump, say that explicitly and continue tracing the code path that builds or transforms the payload.
- If the issue cannot be fully proven from local data and Sentry evidence, separate confirmed facts from likely causes.
