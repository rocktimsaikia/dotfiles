# dotfiles

Personal dotfiles and configuration files for a modern development environment.

## Platform guides

Installation steps differ between operating systems. Follow the guide for your platform:

- **[Linux (Ubuntu/Debian)](README-linux.md)**
- **[macOS](README-macos.md)**

## Prerequisites

- macOS or an Ubuntu/Debian-based Linux distribution
- Root access for system package installation (Linux only)
- Basic understanding of shell commands

## Clone Repository

First, clone the repository with its submodules:
```bash
git clone --recurse-submodules https://github.com/rocktimsaikia/dotfiles
```

**Note**: The `--recurse-submodules` flag is important as it clones the Antidote plugin manager and TPM (tmux plugin manager).

## Setup

Run the setup script to symlink everything (home dotfiles, `.config/*`, `bin`, Claude Code config, global agent instructions, and fonts) into place:

```bash
cd ~/dotfiles && ./setup.sh
```

It's idempotent and non-destructive — existing symlinks are replaced, real files are left alone with a warning. It handles all the manual `ln -sf` steps in the platform guides; you still need the guide for package installs and plugin bootstrap (Antidote, TPM, lazy.nvim).

Then head to the [Linux](README-linux.md) or [macOS](README-macos.md) guide to finish setup.

## Global agent instructions

Personal global memory for AI CLI agents lives at `.claude/AGENTS.md`, shared across tools by symlink (set up by `./setup.sh`) — Claude Code reads it via `~/.claude/CLAUDE.md`, Codex and others via `~/AGENTS.md`.

## License

MIT License - see LICENSE file for details
