---
name: codingal-monthly-prs
description: Generate PR statistics for the previous month
---

Use GitHub CLI (gh) to generate pull request statistics for the previous month (based on today's date) for the following GitHub users:
- rocktimsaikia
- sekar-codingal
- vineetp
- vivekp

Format the output exactly as follows:

1. First, show a summary with PR counts for each user in this format:
```
— rocktimsaikia: X PRs
— sekar-codingal: X PRs
— vineetp: X PRs
— vivekp: X PRs
```

2. Then add separate sections for each user with their username as the header:

```
rocktimsaikia:
— #PR_NUMBER - Title (Month Day)
— #PR_NUMBER - Title (Month Day)

sekar-codingal:
— #PR_NUMBER - Title (Month Day)
— #PR_NUMBER - Title (Month Day)

vineetp:
— #PR_NUMBER - Title (Month Day)
— #PR_NUMBER - Title (Month Day)

vivekp:
— #PR_NUMBER - Title (Month Day)
— #PR_NUMBER - Title (Month Day)
```

Requirements:
- Remove any "CE-XXXX:" prefixes from PR titles
- Remove any "RE:" prefixes from PR titles
- Use em dash (—) for bullet points
- Format dates as "Month Day" (e.g., "Oct 28")
- Group PRs chronologically with the most recent first
- Calculate the previous month automatically based on today's date
- Use merged date as the criteria for "merged:YYYY-MM-01..YYYY-MM-31"
