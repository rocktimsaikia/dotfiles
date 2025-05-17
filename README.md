### 0. Clone
```sh
git clone --recurse-submodules https://github.com/rocktimsaikia/dotfiles
```

### 1. Requirements and essentials packages

```sh
sudo apt install \
  zsh \
  neofetch \
  ripgrep \
  fuse \
  git \
  vim \
  curl \
  make
```

### 2. Aliases and shell config

```sh
# Check current shell
echo $SHELL

# Check in zsh is available or not
cat /etc/shells

# Change it to zsh and reboot
chsh -s /bin/zsh

# Setup my zsh config and plugins
ln -sf ~/dotfiles/.aliases ~/
ln -sf ~/dotfiles/.zshrc ~/
ln -sf ~/dotfiles/antigen.zsh ~/
ln -sf ~/dotfiles/.vimrc ~/
ln -sf ~/dotfiles/.zsh ~/
```

### 3. Setup Neovim

```sh
# Install the latest version only.
sudo snap install nvim --classic

# Check if installation is successful.
nvim --version

# Just open nvim to install all required dependencies
nvim
```

### 4. Setup Node ecosystem.

> Before running this `n` install script, remove the existing `n` config from the `.zshrc` otherwise the installation script will fail.

```sh
# This will install n, latest LTS node and npm version.
curl -L https://bit.ly/n-install | bash

# We will only install `pnpm` LSP servers and formatters for nvim globally via npm
npm install -g \
  pnpm \
  typescript \
  typescript-language-server \
  pyright \
  @johnnymorganz/stylua-bin \
  @biomejs/biome \
  @tailwindcss/language-server
```


### 2. Custom scripts and fonts

```sh
# Setup local bin scripts
ln -sf ~/dot/bin ~/bin

# Install the custom fonts
ln -sf ~/dot/.local/share/fonts ~/.local/share
fc-cache -f -v
```
