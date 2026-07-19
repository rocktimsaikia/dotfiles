---
name: gh-release
description: Create a GitHub release - auto-determine the semver bump from the unreleased commits, sync the manifest version, tag and title with a `v` prefix, and generate the body via the release-body skill. Use when the user says "create a release", "cut a release", "gh release", or "tag and release".
---

# GitHub Release

Create a GitHub release for the current repo with an auto-determined version.

## Workflow

1. Preflight: working tree clean, on the default branch, local in sync with origin (`git status -sb`). Abort and report if not.
2. Find the last tag (`git describe --tags --abbrev=0`) and list unreleased commits (`git log <last-tag>..HEAD --pretty='%h %s'`). No new commits = nothing to release, stop.
3. Determine the bump from those commits: any `!` or `BREAKING CHANGE` footer = major, else any `feat` = minor, else patch. Sanity-check against the diff itself (`git diff <last-tag>..HEAD --stat`) - e.g. a raised `engines` floor or removed export is breaking even if no commit says `!`.
4. Confirm the computed version with `AskUserQuestion` before touching anything - present the bump (e.g. "v2.0.1, patch - docs-only changes") as the recommended option, with the alternative bump levels as other options.
5. Sync the manifest version (`package.json`, `pyproject.toml`, etc.):
   - Already equals the confirmed version: nothing to do.
   - Stale: confirm via `AskUserQuestion` (recommended option: "Bump and push"), then bump it, commit as `chore(release): X.Y.Z`, push, and wait for CI green (`gh run list`) before releasing.
   - Manifest ahead of computed version (maintainer bumped manually): trust the manifest, but surface this in the version confirmation of step 4.
6. Generate the release body with the `release-body` skill.
7. Confirm the release itself with `AskUserQuestion` (recommended option: "Create release") - it is outward-facing and often triggers a publish workflow; mention any publish-side precondition (e.g. npm trusted publisher). Then create it - tag AND title both use the `v` prefix regardless of older tags' style:

   ```sh
   gh release create v<X.Y.Z> --title "v<X.Y.Z>" --notes "<body>"
   ```
8. If a release/publish workflow exists (`.github/workflows/release.yml`), watch it to completion (`gh run list --workflow release.yml`) and verify the published artifact (e.g. `npm view <name> version`). Report the release URL and workflow conclusion.

## Rules

- Every state-changing operation (version-bump commit, push, `gh release create`) goes through `AskUserQuestion` first - never rely on earlier blanket permission. Read-only checks (status, logs, `npm view`) need no confirmation.
- Tag/title format: `vX.Y.Z`, even if previous tags lack the prefix. The compare link in the body must still use the old tag's real name on the left side (e.g. `1.0.1...v2.0.0`).
- Never force-move an existing tag. If the computed tag exists, stop and report.
- No draft/prerelease flags unless asked.
