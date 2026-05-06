---
name: analyze-pr
description: Analyze the current branch's existing open pull request when the user wants a concise high-level summary of what the PR does, the problem it solves, and the remaining issues, blockers, or gaps that must be resolved before it is production-ready.
---

# Analyze PR

Use this skill when the user wants a review-oriented analysis of the current branch's PR, especially for an existing open PR they did not author.

## Goal

Inspect the PR tied to the current branch and provide:

1. A concise, high-level summary of what the PR changes and the problem it is solving.
2. A concrete list of outstanding issues, blockers, risks, or missing pieces that should be resolved before production rollout.

## Workflow

1. Identify the current branch PR.
   Use `git branch --show-current` and `gh pr view --json title,body,baseRefName,headRefName,author,files,commits,url`.
   If there is no open PR for the current branch, say so and stop.

2. Build context from the PR itself.
   Review:
   - PR title and body
   - changed files and their scope
   - notable commit messages when they clarify intent

3. Read the code, not just the PR metadata.
   Focus on behavior changes, integration points, validation, permissions, migrations, feature flags, tests, and rollout risk.

4. Produce two outputs only:
   - `Summary`: 2-4 sentences, high level, no changelog dump
   - `Outstanding Issues`: a flat list of concrete blockers, risks, or gaps

5. Persist the analysis in the repo root.
   Write the exact analysis output to `pr-analyze-output.md` in the repository root.
   Overwrite the file if it already exists.

## Review Rules

- Prioritize production readiness over style nits.
- Call out missing tests, unsafe assumptions, partial implementations, unclear rollout steps, and backward-compatibility risks.
- Distinguish between confirmed issues and reasonable concerns.
- If no meaningful blockers are found, state that explicitly and mention residual testing or validation gaps.
- Keep the response concise and decision-useful.

## Output Format

Use this structure:

### Summary
[short high-level summary]

### Outstanding Issues
- [issue or `None identified`]

Also save the same content to `pr-analyze-output.md` in the repo root.

## Notes

- Default to a code review mindset: findings first, summary second only if the user asks for a deeper review.
- Do not make code changes unless the user explicitly asks for them.
