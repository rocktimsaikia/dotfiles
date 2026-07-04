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

Once cloned, head to the [Linux](README-linux.md) or [macOS](README-macos.md) guide to finish setup.

## Global agent instructions

Personal global memory for AI CLI agents lives at `.claude/AGENTS.md` and is shared across tools by symlink — Claude Code reads it via `~/.claude/CLAUDE.md`, Codex and others via `~/AGENTS.md`:

```bash
ln -sf ~/dotfiles/.claude/AGENTS.md ~/AGENTS.md
ln -sf ~/AGENTS.md ~/.claude/CLAUDE.md
```

**Note**: If `~/.claude/CLAUDE.md` already exists as a real file, back it up first — `ln -sf` overwrites it.

## License

MIT License - see LICENSE file for details
