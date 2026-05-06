---
name: pr-create
description: Commit staged changes, push branch, and create a GitHub PR with a concise single-sentence description.
---

# PR Create

Use this skill when the user asks to create a pull request.

## Workflow

1. Run the `commit` skill first to commit only staged changes.
2. Push current branch to remote with `git push -u origin <branch-name>`.
3. Create PR with `gh pr create --assignee @me`.

## PR Description Rules

1. Keep description to a single clear sentence explaining what changed and why.
2. Focus on the problem solved and implemented fix.
3. Use backticks for technical terms (models, fields, identifiers).

## Do Not Include

1. AI credits or mentions.
2. Test plan/checklist sections.
3. Bullets or multiple paragraphs.
4. Section headers like `Summary` or `Changes`.

## Example

`Fixed a race condition in the \`PaymentPage\` model where validation for paid and expired states ran before \`expiry_date\` was cleared, causing legitimate paid payments to fail validation.`
