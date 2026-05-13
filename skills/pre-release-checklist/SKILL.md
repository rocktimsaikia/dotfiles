---
name: pre-release-checklist
description: Create or update a concise `pre-release-checklist.md` for the current branch PR by reviewing the PR diff, identifying impacted user-facing and admin-facing manual test surfaces, and grouping the checklist into `P0`, `P1`, and `Nice-to-Have`.
---

# Pre-Release Checklist

Use this skill when the user asks for a pre-release checklist, QA checklist, manual test plan, or release signoff checklist for the current branch PR.

## Goal

Produce a concise Markdown checklist in `pre-release-checklist.md` at the repo root for the PR tied to the current branch.

## Workflow

1. Identify the PR for the current branch.
   Use `git branch --show-current` and `gh pr view --json ...`.
   If there is no PR for the current branch, say so and stop.

2. Review the PR at the right level.
   Focus on:
   - PR title and body
   - changed files
   - templates, pages, routes, and navigation changes
   - backend endpoints or validation that change user-visible behavior

3. Map code changes to manual test surfaces.
   Prefer concrete entry points such as:
   - pages or routes
   - sidebar/navigation entries
   - forms and CRUD flows
   - permission-gated access
   - downstream smoke checks where changed data appears elsewhere

4. Write or update `pre-release-checklist.md`.
   Use these sections:
   - `## P0`
   - `## P1`
   - `## Nice-to-Have`

## Checklist Rules

- Keep it concise and execution-focused.
- Write checklist items as actionable manual validations.
- Lead with critical path behavior and regression risk.
- Include both happy-path and key failure/validation cases when relevant.
- Include permission/access checks when the PR introduces or changes gated features.
- Include downstream smoke checks only when the PR changes data that surfaces elsewhere.
- Avoid implementation trivia, internal refactors, and low-signal items.

## Output Rules

- Write to `pre-release-checklist.md` in the repository root.
- Use Markdown checkboxes: `- [ ]`.
- Prefer one-line checklist items.
- Use exact route/page names when they materially help QA.
- If a checklist file already exists, update it instead of creating a second file.
