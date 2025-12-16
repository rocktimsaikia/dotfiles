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

# Bind Ctrl+L to clear the screen
bindkey "^L" clear-screen

# *** PATH Configuration ***
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

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
[ -s "/home/nightwarriorftw/.bun/_bun" ] && source "/home/nightwarriorftw/.bun/_bun"
