# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal dotfiles for a Linux/macOS developer environment. There is no build system, no test suite, and no application code — changes here are config edits and shell scripts that take effect on the user's machine via symlinks.

## Layout that matters

The repo is checked out at `~/dotfiles`. Files are activated by symlinking from `~/dotfiles/...` into `$HOME` or `$XDG_CONFIG_HOME` — editing a file here changes live config on the next shell reload (`exec zsh`) or app restart. There is no apply/install step beyond the initial symlinking documented in `README.md`.

Key locations:
- `.aliases` — sourced from `.config/zsh/.zshrc`. The canonical place to add aliases.
- `.config/zsh/` — XDG-based zsh setup. Bootstrap is `zshenv` (symlinked to `~/.zshenv`), which sets `ZDOTDIR=$HOME/.config/zsh`. From there `.zshrc` loads Antidote plugins, sources `~/.aliases`, then sources `zshrc.linux` or `zshrc.macos` based on `uname`. Platform-specific PATH/tooling (pyenv, bun, n, go) lives in those OS files — not in `.zshrc`.
- `.config/zsh/.zsh_plugins.txt` — Antidote plugin list. After editing, regenerate `.zsh_plugins.zsh` (see "Zsh plugins" below). The generated `.zsh_plugins.zsh` is gitignored.
- `bin/` — custom user scripts, symlinked to `~/bin` and added to PATH by `.zshrc`. Many are referenced as aliases in `.aliases` (e.g. `dm` → `drop-migrations`, `qc` → `qcommit`, `tb` → `tmux-branch`, `grb` → `git-recent-branches`).
- `cron/ecosystem.config.js` — pm2 config that runs `cron/update-claude.js` every 15 minutes to `npm i -g @anthropic-ai/claude-code`. Standalone; not auto-started by anything in this repo.
- `.config/nvim/`, `.config/tmux/`, `.config/ghostty/`, `.config/fish/`, `.config/fontconfig/` — app configs activated by symlink.
- Submodules: `.config/zsh/antidote` (plugin manager) and `.config/tmux/plugins/tpm`. Clone with `--recurse-submodules` or run `git submodule update --init` after cloning.

## Common tasks

**Reload shell after editing `.aliases`, `.zshrc`, or `zshrc.linux`/`zshrc.macos`:**
```bash
exec zsh
```

**Add a new alias:** edit `.aliases` (it's already sourced by `.zshrc`). Don't add aliases to `.zshrc` directly.

**Add a new bin script:** drop the script into `bin/`, `chmod +x`, and it's available on PATH (because `~/bin` is symlinked from `bin/` and prepended in `.zshrc`). If you want a short alias for it, add to `.aliases`.

**Zsh plugins:** edit `.config/zsh/.zsh_plugins.txt`, then regenerate the loader:
```bash
cd ~/.config/zsh
source antidote/antidote.zsh
antidote bundle < .zsh_plugins.txt > .zsh_plugins.zsh
exec zsh
```

**Platform-specific config:** put Linux-only env/PATH in `zshrc.linux`, macOS-only in `zshrc.macos`. Cross-platform stuff goes in `.zshrc`.

## Conventions in this repo

- Aliases follow short two-to-four-letter mnemonics: `g*` for git, `cg*` for the user's `~/codingal/main` workspace, `cc*` for Claude Code variants, `e*` for editing config files (`eA`=aliases, `eZ`=zshrc, `eV`=nvim init, `eG`=ghostty).
- Scripts in `bin/` are mostly bash with a `#!/bin/bash` or `#!/usr/bin/env bash` shebang. Keep them self-contained — no shared helpers/library.
- The `.gitignore` already excludes generated artifacts (`.zsh_plugins.zsh`, `.zcompdump*`, `.config/tmux/plugins`, nvim's `lazy-lock.json` and `plugin/`). Don't commit them back in.
