# Global agent instructions

Personal global memory shared across AI CLI agents:

- `dcy` anywhere in a prompt means "don't code yet": answer, discuss, plan, or recommend, but write no code and make no file edits until explicitly told to go ahead. Reading, grepping, and investigating are fine. Scan the whole prompt for the word - it can appear mid-sentence.
- Never use em dash (—) in any output. Use the normal hyphen (-) instead.
- Never add AI agent attribution to commits or PRs: no `Co-Authored-By` for Claude/Codex/etc., no `Claude-Session:` or other session-link trailers, no "Generated with" footers. Commit messages and PR bodies contain only the change description.
- Never auto-commit. Always ask for explicit permission before making any git commit.
- Write commit messages as Conventional Commits: `type(scope): description`. Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`. Scope optional. Description lowercase, imperative mood, no trailing period. Breaking change: append `!` after type/scope (e.g. `feat!:`) or add a `BREAKING CHANGE:` footer.
- When offering multiple-choice options to the user (including every `AskUserQuestion` call), always mark one as the recommended default and say why. Concretely: append `(Recommended)` to that option's `label` and give the reason in its `description`. Putting the preferred option first is NOT enough - it must be labeled. Only skip when there is genuinely no basis to prefer one.
- New git worktree: symlink `node_modules` into it from original repo so worktree run same as original, no reinstall.
- Multiple Linear MCPs may exist. For any Linear task whose issue ID prefix is `ROC-`, always use the `linear-rocktim` MCP.
- Always use the `agent-browser` skill to open any internet links (do not use other browser automation tools for this).

## UI / styling

- Change container background (tints, status colors, dark mode)? Restyle every child on it - text, icons, chips, borders - keep readable contrast (aim WCAG AA, ~4.5:1 text). Never leave default-styled elements clashing on non-default surface.

@RTK.md
