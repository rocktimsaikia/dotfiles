# dotfiles

Personal dotfiles and configuration files for a modern development environment.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Clone Repository](#clone-repository)
  - [System Requirements](#system-requirements)
  - [Shell Configuration](#shell-configuration)
  - [Neovim Setup](#neovim-setup)
  - [Node.js Ecosystem](#nodejs-ecosystem)
  - [Custom Scripts and Fonts](#custom-scripts-and-fonts)

## Prerequisites

Before proceeding with the installation, ensure your system has the following:
- Ubuntu/Debian-based Linux distribution
- Root access for system packages installation
- Basic understanding of shell commands

## Installation

### Clone Repository

First, clone the repository with its submodules:
```bash
git clone --recurse-submodules https://github.com/rocktimsaikia/dotfiles
```

### System Requirements

Install the essential system packages:
```bash
sudo apt install \
  zsh \
  neofetch \
  ripgrep \
  fuse \
  git \
  vim \
  curl \
  make \
  xclip
```

### Shell Configuration

1. Verify your current shell:
```bash
echo $SHELL
```

2. Check if zsh is available:
```bash
cat /etc/shells
```

3. Switch to zsh (requires system reboot):
```bash
chsh -s /bin/zsh
```

4. Set up zsh configuration:
```bash
ln -sf ~/dotfiles/.aliases ~/
ln -sf ~/dotfiles/.zshrc ~/
ln -sf ~/dotfiles/antigen.zsh ~/
ln -sf ~/dotfiles/.vimrc ~/
ln -sf ~/dotfiles/.zsh ~/
```

### Neovim Setup

1. Install Neovim via snap:
```bash
sudo snap install nvim --classic
```

2. Verify installation:
```bash
nvim --version
```

3. Open Neovim to install dependencies:
```bash
nvim
```

### Node.js Ecosystem

1. Install `n` (Node.js version manager):
```bash
curl -L https://bit.ly/n-install | bash
```

Note: Before running the installation script, remove any existing `n` configuration from your `.zshrc` file (remove the line starting with `export N_PREFIX`).

2. Install development tools globally:
```bash
npm install -g \
  pnpm \
  typescript \
  typescript-language-server \
  pyright \
  @johnnymorganz/stylua-bin \
  @biomejs/biome \
  @tailwindcss/language-server
```

### Custom Scripts and Fonts

1. Set up local bin scripts:
```bash
ln -sf ~/dotfiles/bin ~/bin
```

2. Install custom fonts:
```bash
ln -sf ~/dotfiles/.local/share/fonts ~/.local/share
fc-cache -f -v
```

## Post-Installation

After completing the installation:
1. Reboot your system to apply shell changes
2. Verify all configurations by opening a new terminal
3. Test Neovim by opening it and checking for any errors

## License

MIT License - see LICENSE file for details
