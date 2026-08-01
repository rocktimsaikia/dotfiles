# CLAUDE.md

This file guide Claude Code (claude.ai/code) when work with code in this repo.

## Repository purpose

Personal dotfiles for Linux/macOS dev environment. No build system, no test suite, no app code — changes here config edits and shell scripts, take effect on user machine via symlinks.

## Layout that matters

Repo checked out at `~/dotfiles`. Files activated by symlinking from `~/dotfiles/...` into `$HOME` or `$XDG_CONFIG_HOME` — edit file here changes live config on next shell reload (`exec zsh`) or app restart. No apply/install step beyond initial symlinking in `README.md`.

Key locations:
- `.aliases` — sourced from `.config/zsh/.zshrc`. Canonical place for aliases.
- `.config/zsh/` — XDG-based zsh setup. Bootstrap is `zshenv` (symlinked to `~/.zshenv`), sets `ZDOTDIR=$HOME/.config/zsh`. From there `.zshrc` loads Antidote plugins, sources `~/.aliases`, then sources `zshrc.linux` or `zshrc.macos` based on `uname`. Platform-specific PATH/tooling (pyenv, bun, n, go) lives in those OS files — not `.zshrc`.
- `.config/zsh/.zsh_plugins.txt` — Antidote plugin list. After edit, regenerate `.zsh_plugins.zsh` (see "Zsh plugins" below). Generated `.zsh_plugins.zsh` gitignored.
- `bin/` — custom user scripts, symlinked to `~/bin` and added to PATH by `.zshrc`. Many referenced as aliases in `.aliases` (e.g. `dm` → `drop-migrations`, `qc` → `qcommit`, `tb` → `tmux-branch`, `grb` → `git-recent-branches`).
- `.config/nvim/`, `.config/tmux/`, `.config/ghostty/`, `.config/fontconfig/` — app configs activated by symlink.
- Submodules: `.config/zsh/antidote` (plugin manager) and `.config/tmux/plugins/tpm`. Clone with `--recurse-submodules` or run `git submodule update --init` after clone.

## First-time setup

Clone with submodules and init:
```bash
git clone --recurse-submodules https://github.com/rocktimsaikia/dotfiles ~/.dotfiles
cd ~/.dotfiles
./setup.sh  # or manually symlink files per README.md
exec zsh
```

## Common tasks

**Reload shell after editing `.aliases`, `.zshrc`, or `zshrc.linux`/`zshrc.macos`:**
```bash
exec zsh
```

**Add new alias:** edit `.aliases` (already sourced by `.zshrc`). Don't add aliases to `.zshrc` directly.

**Add new bin script:** drop script into `bin/`, `chmod +x`, available on PATH (`~/bin` symlinked from `bin/` and prepended in `.zshrc`). Want short alias? Add to `.aliases`.

**Zsh plugins:** edit `.config/zsh/.zsh_plugins.txt`, then regenerate loader:
```bash
cd ~/.config/zsh
source antidote/antidote.zsh
antidote bundle < .zsh_plugins.txt > .zsh_plugins.zsh
exec zsh
```

**Platform-specific config:** Linux-only env/PATH in `zshrc.linux`, macOS-only in `zshrc.macos`. Cross-platform in `.zshrc`.

**AI agent skills:** live in separate private repo `~/agent-skills` (github.com/rocktimsaikia/agent-skills), not in dotfiles. Add a skill there and run `~/agent-skills/setup.sh` to sync to all CLI agents (Codex, Claude, Copilot CLI).

## Conventions in this repo

- Aliases follow short two-to-four-letter mnemonics: `g*` for git, `cg*` for user `~/codingal/main` workspace, `cc*` for Claude Code variants, `e*` for editing config files (`eA`=aliases, `eZ`=zshrc, `eV`=nvim init, `eG`=ghostty).
- Scripts in `bin/` mostly bash with `#!/bin/bash` or `#!/usr/bin/env bash` shebang. Keep self-contained — no shared helpers/library.
- `.gitignore` already excludes generated artifacts (`.zsh_plugins.zsh`, `.zcompdump*`, `.config/tmux/plugins`, nvim `lazy-lock.json` and `plugin/`). Don't commit them back.

## Gotchas

- **Zsh plugins not loading after edit:** After editing `.zsh_plugins.txt`, you MUST regenerate `.zsh_plugins.zsh`. Saving file won't activate new plugins—run antidote bundle command in "Zsh plugins" above.
- **Symlink conflicts during setup:** If target file already exists (e.g., `~/.zshenv`), symlink won't be created. Back up or remove existing file first.
- **PATH order matters:** Custom `~/bin` prepended in `.zshrc`, so takes priority over system tools. Useful for shadowing system commands, but keep in mind when adding scripts.