# dotfiles

Personal dotfiles and config files for modern dev environment.

## Platform guides

Install steps differ per OS. Follow guide for your platform:

- **[Linux (Ubuntu/Debian)](README-linux.md)**
- **[macOS](README-macos.md)**

## Prerequisites

- macOS or Ubuntu/Debian-based Linux distro
- Root access for system package install (Linux only)
- Basic shell command knowledge

## Clone Repository

Clone repo with submodules:
```bash
git clone --recurse-submodules https://github.com/rocktimsaikia/dotfiles
```

**Note**: `--recurse-submodules` flag important — clones Antidote plugin manager and TPM (tmux plugin manager).

## Setup

Run setup script to symlink everything (home dotfiles, `.config/*`, `bin`, Claude Code config, global agent instructions, fonts) into place:

```bash
cd ~/dotfiles && ./setup.sh
```

Idempotent and non-destructive — existing symlinks replaced, real files left alone with warning. Handles all manual `ln -sf` steps in platform guides; still need guide for package installs and plugin bootstrap (Antidote, TPM, lazy.nvim).

Then go to [Linux](README-linux.md) or [macOS](README-macos.md) guide to finish setup.

## Global agent instructions

Personal global memory for AI CLI agents lives at `.claude/CLAUDE.md`, shared across tools by symlink (set up by `./setup.sh`) — Claude Code reads via `~/.claude/CLAUDE.md`, Codex and others via `~/AGENTS.md`.

## License

MIT License - see LICENSE file for details