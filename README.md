### 0. Aliases and shell config

```sh
# Soft link the alias config to root dir
ln -sf ~/dot/.aliases ~/
```

> Change the default shell to Zsh in case it's something else.

```sh
# Check current shell
echo $SHELL

# Check in zsh is available or not
cat /etc/shells

# If not installed, install it
sudo apt install zsh

# Change it to zsh and reboot
chsh -s /bin/zsh

# Setup my zsh config and plugins
ln -sf ~/dot/.zshrc ~/
ln -sf ~/dot/antigen.zsh ~/

# Install/setup starship (customizable prompt)
curl -sS https://starship.rs/install.sh | sh
ln -sf ~/dot/.config/starship.toml ~/.config/
```

### 1. Requirements and essentials packages

```sh
sudo apt install
neofetch \
exa \
bat \
ripgrep \
gh \
```

### 2. Custom scripts and fonts

```sh
# Setup local bin scripts
ln -sf ~/dot/bin ~/bin

# Install the custom fonts
ln -sf ~/dot/.local/share/fonts ~/.local/share
fc-cache -f -v
```

### 3. Install/setup Neovim

> Installation via `appimage` instead of building it from scratch.
installing the current LTS version `v0.10.0`, change this to
to the LTS version of the time of installation.

```sh
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.0/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
sudo ln -s /usr/local/bin/nvim /usr/bin/nvim

# Check if installation is successful.
nvim --version
```

> Setup
```sh
ln -sf ~/dot/.config/nvim ~/.config

# Install Packer (nvim package manager)
# Note: open nvim and run PackerInstall once after the installtion
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install Lua language server
sudo apt installl ninja
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh

# Check if installtion was successful.
lua-language-server
```

### 4. Setup Node ecosystem.

> Before running this `n` install script, remove the existing `n` config from the `.zshrc` otherwise the installation script will fail.

```sh
# This will install n, latest LTS node and npm version.
curl -L https://bit.ly/n-install | bash

# We will only install `pnpm` LSP servers and formatters for nvim globally via npm
npm install -g
pnpm \
typescript \
typescript-language-server \
pyright \
@johnnymorganz/stylua-bin \
@biomejs/biome \
@tailwindcss/language-server
```
