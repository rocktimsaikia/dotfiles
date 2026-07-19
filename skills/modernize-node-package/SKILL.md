---
name: modernize-node-package
description: Audit and modernize an outdated Node.js npm package - fix stale package.json metadata, broken tests, EOL node/toolchain, dead links, missing npm release automation - committing each logical change separately with CI verified green after every push.
---

# Modernize Node Package

Use this skill when the user asks to update, refresh, revive, or modernize an old/outdated Node.js package repository.

## Goal

Bring a stale npm package back to healthy state: accurate metadata, passing hermetic tests, current node/toolchain, minimal dependencies, and automated npm releases. Small conventional commits, CI verified green after each push.

## Rules

- Never auto-commit. Propose each commit message, wait for explicit approval.
- Conventional Commits (`type(scope): description`, `!` for breaking).
- One logical change per commit (chore/test/fix/docs/ci separated).
- After every push, watch CI to completion (background poll on `gh run list`). Never assume green.
- Prefer deleting dependencies over adding them. Native platform features first.
- Verify every fix locally (build + tests) before proposing the commit.
- Use pnpm as the package manager. If pnpm is not on PATH, run it via `corepack pnpm`. If the repo uses npm/yarn, migrate: delete the old lockfile, generate `pnpm-lock.yaml` with `pnpm install`, and update CI to `pnpm/action-setup`.

## Workflow

Work through the phases in order. Skip any phase that does not apply, but check them all.

### 1. Audit metadata

- Compare `package.json` against the published registry: `npm view <name> name version`. Repos migrated from templates often carry template junk in `name`, `version`, `description`, `repository`, `keywords`. Restore real values; sync `version` to the published one.
- Grep the whole repo for the author's stale URLs/domains (check memory for the user's current domain). Test suspicious domains with `curl`/`nslookup` - dead personal domains are common in old repos.
- Bump copyright year in `LICENSE` and README license line.
- Fix typos in descriptions ("scrapper" -> "scraper" class of errors). Update the GitHub repo description too (`gh repo edit --description`) if it has the same rot.

### 2. Fix the test suite

- Tests that fetch live websites are broken-by-default: sites change, domains die. Replace with a local `node:http` server serving an inline fixture. No mocking libraries unless already installed.
- Verify the README's documented output against what the code actually returns - run the real thing. Stale examples often reveal real bugs worth fixing while there.

### 3. Modernize toolchain

- Check `pnpm-lock.yaml` vs the pnpm version pinned in CI (`pnpm/action-setup`). A lockfile regenerated locally with a newer pnpm silently breaks `pnpm install --frozen-lockfile` in CI ("lockfile absent/not compatible"). Keep the CI pnpm version in sync with the lockfile format.
- Update CI matrix: drop EOL node versions, add current LTS versions.
- Drop dependencies the platform now covers (e.g. `node-fetch` -> native `fetch` on node >= 18). Add an `engines` field when raising the floor. This is a breaking change - mark the commit `!`.

### 4. Release automation

- Add `.github/workflows/release.yml` triggered on `release: types: [published]`, publishing with npm **trusted publishing** (OIDC): `permissions: id-token: write`, no token secrets, `npm install -g npm@latest` before `npm publish --provenance --access public` (trusted publishing needs npm >= 11.5.1).
- Remind the user of the one-time npm-side setup: package Settings > Trusted Publisher > GitHub Actions with repo + workflow filename. Never recommend 2FA-bypass automation tokens.

### 5. Release

- Decide the semver bump from commits since the last tag: any `!`/BREAKING = major, `feat` = minor, else patch.
- Bump `package.json` version, commit, push.
- User creates the GitHub release (tag `vX.Y.Z`). Offer a formatted release body: commits since last tag grouped under Breaking / Performance / Fixes / Internal / Docs with short hashes, plus a `compare` Full Changelog link.
- After publish, verify: release workflow conclusion via `gh run list --workflow release.yml`, and `npm view <name> version` matches.

## Report

At the end summarize: commits made (hash + message), CI status, published version if released, and any manual steps still pending for the user.
