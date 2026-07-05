# Global agent instructions

Personal global memory shared across AI CLI agents:

- Never use em dash (—) in any output. Use the normal hyphen (-) instead.
- Never add AI agent as co-author on commits (no `Co-Authored-By` for Claude/Codex/etc.).
- When offering multiple-choice options to the user (including every `AskUserQuestion` call), always mark one as the recommended default and say why. Concretely: append `(Recommended)` to that option's `label` and give the reason in its `description`. Putting the preferred option first is NOT enough - it must be labeled. Only skip when there is genuinely no basis to prefer one.
- Multiple Linear MCPs may exist. For any Linear task whose issue ID prefix is `ROC-`, always use the `linear-rocktim` MCP.

## UI / styling

- Change container background (tints, status colors, dark mode)? Restyle every child on it - text, icons, chips, borders - keep readable contrast (aim WCAG AA, ~4.5:1 text). Never leave default-styled elements clashing on non-default surface.
