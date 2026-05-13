---
name: pypi-release
description: Bump a Python package version, push to the default branch, and publish a GitHub Release that triggers the PyPI publish workflow.
---

# PyPI Release

Use this skill when the user asks to release, publish, or cut a new version of a Python package whose PyPI publish flow is driven by a GitHub Release.

## Preconditions

1. A workflow listening on `release: types: [published]` exists under `.github/workflows/` (typically `release.yml`) and is wired to PyPI via Trusted Publishing or a token.
2. The working tree is clean and up to date with the remote default branch.
3. The user has rights to push to the default branch and to create releases on the repo.

## Workflow

1. Resolve the default branch with `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`, switch to it, `git pull`, and verify a clean tree with `git status --short`.
2. Read the current version from `pyproject.toml` under `[project] version = "..."`.
3. Find every mirror of that version string. Always check `<package>/__init__.py` for `__version__ = "..."`; also grep for the literal version (`grep -r "<current-version>" --include='*.py' --include='*.toml' --include='*.cfg'`) to catch other locations.
4. If pre-existing mirrors are already out of sync, stop and ask the user which value is canonical before continuing.
5. Determine the new version. Accept an explicit version or a bump type (`patch`/`minor`/`major`) from the user. If neither is given, propose a patch bump and ask for confirmation.
6. Update every location identified in step 3 to the new version. Keep them byte-for-byte identical.
7. Commit with `chore: bump version to <new>` using `git commit -n -m "..."` and push to the default branch with `git push`. No AI attribution in the commit message.
8. Detect tag-prefix style from `git tag --sort=-v:refname | head -1`. Preserve the existing convention (`v0.1.3` vs `0.1.3`); never mix.
9. If a tag for the chosen version already exists, stop and ask whether to choose a higher version.
10. Generate concise release notes — a single line summarising the merged PR(s) since the previous tag, e.g. `Fix URL escaping (#10, closes #7)`. Use `gh pr list --state merged --search "merged:>$(git log -1 --format=%aI <previous-tag>)"` to enumerate.
11. Create the release with `gh release create <tag> --target <default-branch> --title "<tag>" --notes "<notes>"`. Publishing the release is what fires the workflow — a bare tag push does not.
12. Confirm the publish workflow started: `gh run list --workflow=<release-workflow-filename> --limit 1`. Report the run URL to the user.

## Rules

1. Never bump versions or push to the default branch without explicit user instruction.
2. Do not include AI attribution in commit messages, tag names, or release notes.
3. Do not delete or move existing tags. If the chosen version conflicts, ask the user instead.
4. Do not run `gh release create` against a draft or pre-release flag unless the user asks.
5. If the project uses dynamic versioning (`tool.hatch.version`, `setuptools_scm`, etc.) instead of a static `[project] version`, stop and ask — the workflow differs.

## Example

User: "Release 0.1.3"

1. `pyproject.toml`: `version = "0.1.2"` → `"0.1.3"`
2. `github_dlr/__init__.py`: `__version__ = "0.1.2"` → `"0.1.3"`
3. Commit: `chore: bump version to 0.1.3`
4. Push to `main`.
5. Tag style detected as bare (`0.1.2`), so new tag is `0.1.3`.
6. Release notes: `Fix URL escaping (#10, closes #7)`
7. `gh release create 0.1.3 --target main --title "0.1.3" --notes "Fix URL escaping (#10, closes #7)"`
8. Verify workflow run started and report the URL.
