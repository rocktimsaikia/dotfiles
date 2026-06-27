---
name: pr-why-comments
description: Review the current branch's PR diff and add reviewer-friendly code comments in the source wherever the "why" behind a change isn't obvious from the code alone. Use when the user says "explain my PR for reviewers", "add why comments to the diff", "comment the non-obvious changes", "where is context missing", or invokes /pr-why-comments. Adds source-code comments (not GitHub comments) so reviewers don't have to guess intent.
---

# PR Why-Comments

Use this skill to walk the PR diff as the author and add comments *in the source code* explaining intent where the diff alone doesn't make the reasoning clear. The goal is to save reviewers from guessing why a change was made — the comments ship as part of the code.

## Goal

For the changes on the current branch, find the edits whose *motivation* is non-obvious and add a short code comment explaining the why, right above the line. Do not comment on changes that explain themselves.

## Workflow

1. Get the diff.
   `git diff <base>...HEAD` (base is usually `master`/`main`), or `gh pr diff` if a PR exists. Read the surrounding code in the file, not just the hunk — the diff alone is often not enough to judge whether the why is obvious.

2. Find the spots that lack explanation.
   Flag a change only when a reviewer would reasonably ask "why this?". Good candidates:
   - non-obvious values (magic numbers, timeouts, retry counts, ordering)
   - workarounds, guards, or special-casing for a specific bug/edge case
   - intentional deviations from the surrounding pattern
   - decisions driven by context outside the diff (an upstream API quirk, a migration, a perf finding)

   Skip anything where the code, the function name, or the change itself already makes the intent clear. Fewer, high-signal comments beat blanket annotation.

3. Add the comments in the source.
   Use Edit to insert a comment in the file's native comment syntax (`#`, `//`, `<!-- -->`, etc.), placed directly above the relevant line and matching the surrounding indentation and style. One or two sentences, lead with the reason.

## Rules

- Explain the *why*, never restate the *what*. `# increment counter` is noise; `# must update before the flush below or the batch ships short` is signal.
- Match the file's existing comment conventions — don't introduce a new style.
- Only touch lines that are part of this branch's changes. Don't annotate pre-existing code unless its meaning changed because of this PR.
- If a change's why is genuinely unclear to you from the code and history, leave it out and flag it in the final report — ask the author rather than inventing a rationale.
- Confirm the planned comments with the user before editing if there are more than a handful, unless they said to just add them.

## Final Response

Report: how many comments were added and where (file:line + the one-line reason), plus any changes whose intent you couldn't determine and left for the author to explain.
