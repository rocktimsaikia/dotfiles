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
4. Sync the manifest version (`package.json`, `pyproject.toml`, etc.):
   - Already equals the computed version: nothing to do.
   - Stale: bump it, commit as `chore(release): X.Y.Z`, push, and wait for CI green (`gh run list`) before releasing.
   - Manifest ahead of computed version (maintainer bumped manually): trust the manifest.
5. Generate the release body with the `release-body` skill.
6. Create the release - tag AND title both use the `v` prefix regardless of older tags' style:

   ```sh
   gh release create v<X.Y.Z> --title "v<X.Y.Z>" --notes "<body>"
   ```

   Confirm with the user before running this - publishing a release is outward-facing and often triggers a publish workflow.
7. If a release/publish workflow exists (`.github/workflows/release.yml`), watch it to completion (`gh run list --workflow release.yml`) and verify the published artifact (e.g. `npm view <name> version`). Report the release URL and workflow conclusion.

## Rules

- Tag/title format: `vX.Y.Z`, even if previous tags lack the prefix. The compare link in the body must still use the old tag's real name on the left side (e.g. `1.0.1...v2.0.0`).
- Never force-move an existing tag. If the computed tag exists, stop and report.
- No draft/prerelease flags unless asked.
