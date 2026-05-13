---
name: codingal-weekly-update
description: Generate weekly engineering update from recent PRs and commits
---

Generate my weekly engineering update by following these steps:

1. Fetch recent merged PRs from the last 7 days for GitHub user "rocktimsaikia" using: `gh pr list --author rocktimsaikia --state merged --limit 20`
2. Fetch recent commits from the last 7 days for git user "rocktimsaikia" using: `git log --author="rocktimsaikia" --since="1 week ago"`
3. Fetch open PRs for user "rocktimsaikia" using: `gh pr list --author rocktimsaikia --state open`

Format the output as follows:

```
## Weekly Engineering Update

**Released:** ✅
— [List all merged PRs from the last week with format: CE-XXXX: Title]
— [Include any notable commits or refactoring work]

**In Progress/Upcoming:** 🔨
— [List all open PRs with format: CE-XXXX: Title]
— [Add brief context about what's being worked on]
```

Rules:
- Use em dash (—) at the beginning of each line item
- Keep the CE-XXXX format with colon after the issue number
- Include brief descriptions where helpful
- Group all released items together (no separate sections)
- Group all in-progress/upcoming items together
- Use the author's git username to filter commits and PRs
