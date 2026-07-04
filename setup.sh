#!/usr/bin/env bash
# Symlink all dotfiles into place. Idempotent and non-destructive:
# existing symlinks are replaced, real files/dirs are left alone with a warning.
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    ln -sfn "$src" "$dst"; echo "linked  $dst"
  elif [ -e "$dst" ]; then
    echo "SKIP    $dst (exists, not a symlink — back up and remove first)"
  else
    mkdir -p "$(dirname "$dst")"; ln -s "$src" "$dst"; echo "linked  $dst"
  fi
}

# Submodules (antidote plugin manager, tmux TPM)
git -C "$DOT" submodule update --init --recursive >/dev/null 2>&1 || true

# Home-level dotfiles
link "$DOT/.aliases" "$HOME/.aliases"
link "$DOT/.vimrc"   "$HOME/.vimrc"
link "$DOT/zshenv"   "$HOME/.zshenv"
link "$DOT/bin"      "$HOME/bin"

# XDG config directories
for d in "$DOT"/.config/*/; do
  link "${d%/}" "$HOME/.config/$(basename "$d")"
done

# Claude Code (statusline + settings; settings.local.json stays machine-local)
link "$DOT/.claude/statusline.sh" "$HOME/.claude/statusline.sh"
link "$DOT/.claude/settings.json" "$HOME/.claude/settings.json"

# Global agent instructions (Claude Code via ~/.claude/CLAUDE.md, Codex/others via ~/AGENTS.md)
link "$DOT/.claude/CLAUDE.md" "$HOME/AGENTS.md"
link "$DOT/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Fonts (platform-specific)
case "$(uname)" in
  Darwin)
    mkdir -p "$HOME/Library/Fonts"
    cp "$DOT"/.local/share/fonts/* "$HOME/Library/Fonts/" 2>/dev/null || true
    echo "copied  fonts -> ~/Library/Fonts"
    ;;
  Linux)
    link "$DOT/.local/share/fonts" "$HOME/.local/share/fonts"
    command -v fc-cache >/dev/null 2>&1 && fc-cache -f >/dev/null 2>&1 || true
    ;;
esac

echo "Done. Run 'exec zsh' to reload the shell."
