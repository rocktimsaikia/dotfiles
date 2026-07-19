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
- Use pnpm as the package manager. If pnpm is not on PATH, run it via `corepack pnpm`. If the repo uses npm/yarn, migrate: delete the old lockfile, generate `pnpm-lock.yaml` with `pnpm install`, and update CI to `pnpm/action-setup`. Gotcha: a `.npmrc` with `package-lock=false` silently stops pnpm from writing `pnpm-lock.yaml` - delete that line (usually the whole file) first.

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

### 3. Polish the README

Target structure (based on rocktimsaikia/meta-fetcher):

1. `# package-name`
2. Badges, each on its own line: CI badge using the workflow-path format (`actions/workflows/<file>.yml/badge.svg`, not the legacy `workflows/<name>/badge.svg`), then `![npm](https://badgen.net/npm/v/<name>)`.
3. One-line description in plain text - no blockquote, no emoji. Verb-first and short ("Scrape all links and images from a web page"), never "A simple ...". Keep package.json `description` and the GitHub repo description identical to it.
4. `## Installation` - note the minimum node version and typings ("Requires Node.js 20 or later. Ships with TypeScript types." - only claim types when a `.d.ts` actually ships), then the `npm install` block.
5. `## Usage` - flat `import x from '<name>'` + `await` example (verify default-import interop if the package is CJS), then `Output:` followed by a code block with the real, verified output.
6. `## Options` - when the package takes an options object: a "Pass an options object as the second argument:" line with a one-line code example (`await pkg(url, { theOption: value })`), then a table (`Option | Required | Default | Description`). Otherwise an `## API` section. Watch verb precision in descriptions ("include", not "fetch", when nothing extra is downloaded).
7. `## Related` - `[**other-pkg**](repo-url): Description.` Sync each description with that repo's official GitHub description (`gh repo view <repo> --json description`).
8. `## License` - `MIT <first-year>-<current-year> &copy; [Author](https://site)`.

No Contribute section. When removing sections, also delete their now-orphaned reference-style link definitions.

### 4. Modernize toolchain

- Check `pnpm-lock.yaml` vs the pnpm version pinned in CI (`pnpm/action-setup`). A lockfile regenerated locally with a newer pnpm silently breaks `pnpm install --frozen-lockfile` in CI ("lockfile absent/not compatible"). Keep the CI pnpm version in sync with the lockfile format.
- Update CI matrix: drop EOL node versions, add current LTS versions.
- Drop dependencies the platform now covers (e.g. `node-fetch` -> native `fetch` on node >= 18). Add an `engines` field when raising the floor. This is a breaking change - mark the commit `!`.

### 5. Release automation

- Add `.github/workflows/release.yml` triggered on `release: types: [published]`, publishing with npm **trusted publishing** (OIDC): `permissions: id-token: write`, no token secrets, `npm install -g npm@latest` before `npm publish --provenance --access public` (trusted publishing needs npm >= 11.5.1).
- Remind the user of the one-time npm-side setup: package Settings > Trusted Publisher > GitHub Actions with repo + workflow filename. Never recommend 2FA-bypass automation tokens.

### 6. Release

- Decide the semver bump from commits since the last tag: any `!`/BREAKING = major, `feat` = minor, else patch.
- Bump `package.json` version, commit, push.
- User creates the GitHub release (tag `vX.Y.Z`). Offer a formatted release body via the `release-body` skill (commits since last tag grouped by type with short hashes, plus a Full Changelog compare link).
- After publish, verify: release workflow conclusion via `gh run list --workflow release.yml`, and `npm view <name> version` matches.

## Report

At the end summarize: commits made (hash + message), CI status, published version if released, and any manual steps still pending for the user.
