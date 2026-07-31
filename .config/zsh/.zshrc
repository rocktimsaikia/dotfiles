# Main zsh configuration
# This file is loaded from $ZDOTDIR/.zshrc (typically ~/.config/zsh/.zshrc)

# *** Antidote Plugin Manager ***
# Source antidote
source "$ZDOTDIR/antidote/antidote.zsh"

# Initialize plugins (including Pure prompt theme)
antidote load

# History configuration
HISTSIZE=10000         # Number of commands to keep in memory
SAVEHIST=10000         # Number of commands to save in the history file

# Default editor
export EDITOR=nvim

# Language settings
export LANG='en_US.UTF-8'

# Load aliases
source "$HOME/.aliases"

# Keep AI agent skill links in sync with ~/agent-skills (separate repo).
if [[ -x "$HOME/agent-skills/setup.sh" ]]; then
    "$HOME/agent-skills/setup.sh" >/dev/null 2>&1 || true
fi

# *** Keybindings ***
# Use emacs keybindings
bindkey -e

# Bind the Tab key to 'menu-complete'
# which cycles through possible completions when pressed
# instead of getting all autocompletions at once
bindkey '\t' menu-complete

# Vim like keybindings for forward and backward word
# Bind Ctrl+L and Ctrl+H to forward and backward word
bindkey "^L" forward-word
bindkey "^H" backward-word

# Bind Ctrl+D to delete word forward
bindkey "^D" kill-word

# Ctrl+U kills only to the left of the cursor (zsh default nukes the whole line)
bindkey "^U" backward-kill-line

# Bind Ctrl+L to clear the screen
bindkey "^L" clear-screen

# *** PATH Configuration ***
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
# `exec zsh` inherits PATH, and nvm skips its auto-use when PATH already holds a
# version bin - so node stayed stale after `nodeup`. Drop inherited nvm entries
# and let nvm re-add whatever `default` points at.
path=("${(@)path:#$NVM_DIR/versions/node/*/bin}")
unset NVM_BIN NVM_INC
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Nudge to run `nodeup` when node/global packages haven't been refreshed in 30 days.
# ponytail: mtime check only, no network on shell start.
if [[ -o interactive ]]; then
    _nodeup_stamp="$HOME/.cache/nodeup-last-run"
    if [[ ! -f $_nodeup_stamp ]] || [[ -n $(find "$_nodeup_stamp" -mtime +30 2>/dev/null) ]]; then
        print -P "%F{yellow}node + global packages stale%f - run %F{cyan}nodeup%f"
    fi
    unset _nodeup_stamp
fi

# Detect OS and load platform-specific configuration
case "$(uname -s)" in
    Linux*)
        source "$ZDOTDIR/zshrc.linux"
        ;;
    Darwin*)
        source "$ZDOTDIR/zshrc.macos"
        ;;
esac

# bun completions
[ -s "/home/rocktim/.bun/_bun" ] && source "/home/rocktim/.bun/_bun"
