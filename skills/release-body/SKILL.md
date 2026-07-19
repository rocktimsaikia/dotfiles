---
name: release-body
description: Generate a GitHub release body from commits since the last tag, grouped by Conventional Commit type with short hashes and a Full Changelog compare link. Use when the user asks for a "release body", "release notes", or "changelog for the release".
---

# Release Body

Generate a formatted GitHub release body for the current repo.

## Workflow

1. Find the last tag: `git describe --tags --abbrev=0`. If no tags exist, use the first commit (`git rev-list --max-parents=0 HEAD`) as the base and label the release as the first one.
2. List commits since it: `git log <last-tag>..HEAD --pretty='%h %s'`.
3. Determine the new version:
   - If `package.json` (or `pyproject.toml`, etc.) already has an unreleased bumped version, use it.
   - Otherwise derive from semver: any `!`/`BREAKING CHANGE` = major, any `feat` = minor, else patch.
4. Group commits into sections in this exact order, omitting empty sections:
   - `## Breaking` - commits with `!` or a `BREAKING CHANGE` footer
   - `## Features` - `feat`
   - `## Fixes` - `fix`
   - `## Performance` - `perf`
   - `## Internal` - `refactor`, `chore`, `build`, `ci`, `test`
   - `## Docs` - `docs`
5. Skip pure release-bump commits (`chore(release): X.Y.Z`).
6. End with the compare link.

## Format Rules

- One bullet per commit: `- <Sentence-case summary> <short-hash>`. Hash bare at the end, no parentheses, no link markup (GitHub autolinks it).
- Rewrite the commit subject into a readable sentence fragment; don't paste the raw `type(scope):` prefix.
- Merge related commits into one bullet with multiple hashes only when they are the same logical change.
- Wrap identifiers, package names, and commands in backticks.
- Final line: `**Full Changelog**: https://github.com/<owner>/<repo>/compare/<last-tag>...<new-tag>` (derive owner/repo from `git remote get-url origin`). The left side uses the previous tag's real name as-is; the new tag is always `v`-prefixed (`vX.Y.Z`, per the `gh-release` skill), e.g. `1.0.1...v2.0.0`.
- No emoji, no AI credits, no empty sections.

## Example

```markdown
## Breaking
- Requires Node.js >= 20 (was >= 10) 51a6a13
- Native `fetch`/`URL` replace `node-fetch`, `is-absolute-url`, `is-url-superb` 51a6a13

## Fixes
- Correct repository/homepage URLs, author info and description typo fdbbf53

## Internal
- Migrate yarn to pnpm, CI node matrix now 20/22/24 44ec3e0
- Hermetic tests: `node:test` + local http fixture, jest dropped 8c636cf

## Docs
- Refresh example output, note node >=20 requirement d3d66e1

**Full Changelog**: https://github.com/rocktimsaikia/page-scrapper/compare/1.0.1...v2.0.0
```

## Output

Return the release body in a single markdown code block so it can be pasted directly into the GitHub release form. Do not create the release or tag unless explicitly asked.
