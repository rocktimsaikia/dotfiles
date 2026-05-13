---
name: codingal-monthly-highlights
description: Generate monthly engineering highlights report
---

Use GitHub CLI (gh) to generate a monthly engineering highlights report for the previous month (based on today's date).

Query merged PRs for these users:
- rocktimsaikia
- sekar-codingal
- vineetp
- vivekp
- rashid-codingal
- yashvardhankumar-codingal

Analyze all PRs and create a high-level summary document following this structure:

```
[Month] [Year] Engineering Highlights 🚀

Team Velocity: [Total] PRs merged.

Key Achievements:

[Dynamic Section Header with appropriate emoji]
— [High-level summary of related features]
— [Grouped improvements]

[Another Dynamic Section Header with appropriate emoji]
— [High-level summary of related features]
— [Grouped improvements]

[Continue with relevant sections...]
```

Requirements:
- Analyze PR titles and group them into logical thematic categories
- Create dynamic section headers based on the actual work done (e.g., "Infrastructure & Performance ⚡", "Teacher Dashboard Overhaul 👩‍🏫", "AI/ML Integration 🤖", etc.)
- Write high-level summaries that combine similar PRs (don't list individual PR titles)
- Focus on user-facing impact and technical achievements
- Add appropriate emojis to section headers (use sparingly, only a few key sections)
- Use sentence case for all content
- Calculate the previous month automatically based on today's date
- Save the output to a file named `[month-lowercase]-[year]-highlights.txt` (e.g., `october-2025-highlights.txt`)
- Keep the tone professional and concise
- Only include sections that have meaningful content (omit empty/minor categories)
- Organize sections by importance/impact, not alphabetically
