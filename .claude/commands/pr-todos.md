Analyze all comments on the GitHub PR for the current branch and create a comprehensive todo list based on the feedback. Follow these steps:

1. Get the current branch name using `git branch --show-current`
2. Fetch the PR associated with this branch using `gh pr view --json number,title,comments`
3. Analyze all comments in the PR to identify:
   - Requested changes and fixes
   - Suggestions for improvements
   - Questions that need to be addressed
   - Code review feedback
4. Create a structured todo list using the TodoWrite tool with:
   - Each actionable item from the comments as a separate todo
   - Clear, concise task descriptions in imperative form (e.g., "Fix bug in payment flow")
   - Active form for in-progress status (e.g., "Fixing bug in payment flow")
   - Group related feedback into logical tasks
   - Mark all todos as "pending" initially

If there is no PR for the current branch, inform the user that they need to create a PR first.

Important:
- Focus on actionable feedback, not general discussion
- Combine similar or related comments into single todos when appropriate
- Skip comments that are just acknowledgments or approvals
- If a comment has already been addressed (marked as resolved), note it but still include it for tracking
