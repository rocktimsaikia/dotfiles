fpath+=("$(brew --prefix)/share/zsh/site-functions")

autoload -U promptinit
promptinit

prompt pure

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

source ~/.aliases

. "$HOME/.local/bin/env"

cd() {
  builtin cd "$@" || return
  if [ -f venv/bin/activate ]; then
    source venv/bin/activate
  fi
}
