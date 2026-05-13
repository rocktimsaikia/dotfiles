---
name: action-debug
description: Debug and fix a failing GitHub Actions run for the current branch by finding the latest failed run, inspecting failed logs, identifying the root cause, and implementing the fix locally.
---

# Action Debug

Use this skill when the user asks to debug GitHub Actions, fix a failing CI run, inspect the latest failed workflow for the current branch, or investigate an action failure.

## Goal

Identify the latest failed GitHub Actions run for the current branch, inspect the failing job logs, determine the root cause, and fix the issue in the codebase when possible.

## Workflow

1. Get the current branch.
   Use `git branch --show-current`.

2. Find the latest failed Actions run for that branch.
   Use `gh run list --branch <branch> --status failure --limit 1 --json databaseId,name,workflowName,createdAt,headBranch`.

3. If no failed run exists, report that CI is currently passing for the branch and stop.

4. Inspect the failed run logs.
   Use `gh run view <run-id> --log-failed`.
   If needed, inspect workflow or job metadata with `gh run view <run-id>`.

5. Identify the concrete failure.
   Focus on:
   - the first actionable error, not downstream noise
   - the file, test, command, or job that actually failed
   - whether the failure is deterministic or environment-specific

6. Fix the issue locally.
   Prefer the smallest defensible code or config change that addresses the root cause.
   If the logs point to tests, linters, or type checks, run the closest relevant local verification you can.

7. Report the outcome.
   Include:
   - the failing workflow or job
   - the root cause
   - the fix applied
   - any verification you ran
   - any remaining uncertainty if the failure could not be fully reproduced locally

## Rules

- Start from GitHub Actions logs before changing code.
- Do not guess at the cause when the logs are still ambiguous; inspect more context first.
- Prefer fixing the root cause over silencing symptoms.
- If the failure is unrelated to the current branch changes, say so explicitly.
- If the run failure is transient or external, call that out instead of forcing an unrelated code change.
