# Commit Changes Command

This command helps commit changes to the repository following the project's commit message conventions.

## Instructions

When committing changes:

1. **Run git status and git diff** to understand the current state and changes
2. **Check recent commit messages** with `git log --oneline -5` to follow the existing style
3. **Add all relevant files** to the staging area
4. **Create a commit message** following this format:
   - Use conventional commit format: `type: description`
   - Common types: `feat`, `fix`, `docs`, `chore`, `refactor`
   - Write clear, descriptive commit messages
   - **IMPORTANT**: Do NOT add Claude Code credits or co-author lines in the commit message
5. **Push changes to remote** with `git push`
6. **Verify the commit and push** were successful with `git status`

## Example Usage

```bash
# Check current status
git status
git diff
git log --oneline -5

# Stage changes
git add .

# Commit with clean message (no Claude credits)
git commit -m "feat: add new feature description"

# Push to remote
git push

# Verify
git status
```

## Important Notes

- **Never include Claude Code credits** like "Generated with Claude Code" or "Co-Authored-By: Claude"
- Keep commit messages concise and descriptive
- Follow the existing project's commit style patterns
- Always verify the commit was successful

