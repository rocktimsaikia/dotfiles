---
name: node-readme
description: Restructure a Node.js package readme to Rocktim's standard style - badges, verb-first description, Installation/Usage/Options/Related/License layout with real verified output. Use when the user asks to "fix the readme", "restructure the readme", or apply the standard readme style to a repo.
---

# Node README

Rewrite the repo's readme to this exact structure. Verify claims against the actual code before writing them (run the real thing for output blocks, check `package.json` for the node floor and types).

## Structure

1. `# package-name`
2. Badges, each on its own line: CI badge using the workflow-path format (`actions/workflows/<file>.yml/badge.svg`, not the legacy `workflows/<name>/badge.svg`), then `![npm](https://badgen.net/npm/v/<name>)`.
3. One-line description in plain text - no blockquote, no emoji. Verb-first and short ("Scrape all links and images from a web page"), never "A simple ...". Keep package.json `description` and the GitHub repo description (`gh repo edit --description`) identical to it.
4. `## Installation` - note the minimum node version and typings ("Requires Node.js 20 or later. Ships with TypeScript types." - only claim types when a `.d.ts` actually ships), then the `npm install` block.
5. `## Usage` - flat `import x from '<name>'` + `await` example (verify default-import interop if the package is CJS), then `Output:` followed by a code block with the real, verified output.
6. `## Options` - when the package takes an options object: a "Pass an options object as the second argument:" line with a one-line code example (`await pkg(url, { theOption: value })`), then a table (`Option | Required | Default | Description`). Otherwise an `## API` section. Watch verb precision in descriptions ("include", not "fetch", when nothing extra is downloaded).
7. `## Related` - `[**other-pkg**](repo-url): Description.` Sync each description with that repo's official GitHub description (`gh repo view <repo> --json description`).
8. `## License` - `MIT <first-year>-<current-year> &copy; [Author](https://site)`.

## Rules

- No Contribute section. When removing sections, delete their now-orphaned reference-style link definitions too.
- Fix stale author links while there (current domain: https://rocktim.dev, email hey@rocktim.dev).
- Never invent output - run the package's example against a real or fixture page and paste what it actually printed.
- Commit as `docs(readme): ...` (Conventional Commits); ask before committing unless the user already granted commit permission.
