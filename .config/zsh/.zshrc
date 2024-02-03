eval "$(starship init zsh)"

source "$XDG_CONFIG_HOME/aliasrc"

# Loading package manager
source "$XDG_CONFIG_HOME/zsh/antigen.zsh"

# bindkey -v
bindkey -e
bindkey '\t' menu-complete
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle MichaelAquilina/zsh-you-should-use
antigen bundle hlissner/zsh-autopair

# Position of the message shown by YSU
export YSU_MESSAGE_POSITION="after"

# Set the strategy to use for autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Apply the antigen configuration
antigen apply

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

# pnpm
export PNPM_HOME="$HOME/.config/local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# bun completions
[ -s "/home/nightwarriorftw/.bun/_bun" ] && source "/home/nightwarriorftw/.bun/_bun"
