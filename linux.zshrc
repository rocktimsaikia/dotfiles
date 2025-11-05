# Initialize the prompt
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure

HISTSIZE=10000         # Number of commands to keep in memory
SAVEHIST=10000         # Number of commands to save in the history file

export EDITOR=nvim

# Set the start directory here
# cd ~/main

# Load the aliases
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

export LANG='en_US.UTF-8'

# bins
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/neovim/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# new pyenv configurations
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Checks if the current dir contains any venv and activates on cd
function activatevenv() {
	if [[ -d "$PWD/venv" ]]; then
		source "$PWD/venv/bin/activate"
	fi
}

function cd() {
	builtin cd $1
	activatevenv
}

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Created by `pipx` on 2024-08-31 14:58:43
export PATH="$PATH:/home/$USERNAME/.local/bin"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
