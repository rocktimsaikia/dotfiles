---
name: gh-address-pr-comments
description: Review GitHub pull request comments and review threads, decide which comments actually require code changes, implement valid fixes on the current branch, push updates, and resolve addressed review threads. Use when the user asks to check Copilot comments, address PR review feedback, or resolve addressed comments on a GitHub PR.
---

# GitHub PR Comments

## Overview

Use this skill when the task is to inspect GitHub PR feedback, determine which comments matter, make the required code changes, and resolve only the threads that are actually addressed.

## Workflow

1. Identify the PR.
   Prefer the PR for the current branch. If the PR number is already known, use it directly.

2. Fetch review context.
   Use:
   - `gh pr view <pr> --json url,title,comments,reviews`
   - `gh api repos/<owner>/<repo>/pulls/<pr>/comments`

3. Separate signal from noise.
   For each comment, classify it as one of:
   - `valid and needs code changes`
   - `already addressed`
   - `not applicable / low value`

   Focus on behavioral regressions, incorrect tests, broken assumptions, and real edge cases. Do not churn code just to satisfy stylistic or weak bot suggestions.

4. Verify against the current branch state.
   Read the referenced files and compare the comment with the current code, not just the original diff. A review comment may already be stale after later commits.

5. Implement fixes for valid comments.
   Make the smallest coherent change that resolves the issue. Add or update tests when the comment points to behavior, parsing, validation, edge cases, or regressions.

6. Push the branch after fixes.
   If local commits are needed, commit only the intended changes and push the branch before resolving threads.

7. Resolve addressed threads.
   Fetch thread IDs with GraphQL:

   ```bash
   gh api graphql -f query='query {
     repository(owner: "OWNER", name: "REPO") {
       pullRequest(number: PR_NUMBER) {
         reviewThreads(first: 50) {
           nodes {
             id
             isResolved
             comments(first: 10) {
               nodes {
                 id
                 url
                 body
                 path
               }
             }
           }
         }
       }
     }
   }'
   ```

   Resolve only threads that are clearly handled:

   ```bash
   gh api graphql -f query='mutation {
     resolveReviewThread(input: {threadId: "THREAD_ID"}) {
       thread { isResolved }
     }
   }'
   ```

## Decision Rules

- Treat Copilot comments as review input, not truth.
- Prefer preserving behavior unless the user explicitly wants a semantic change.
- If a suggestion fixes one issue but introduces another regression, implement the corrected version and mention the tradeoff.
- Do not resolve threads that are still open questions or partially addressed.
- If local tests cannot be run because env/config is missing, say so explicitly in the final report.

## Final Response

Report:
- which comments were valid
- which changes were made
- which threads were resolved
- any comments intentionally left open and why
