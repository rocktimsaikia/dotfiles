# dotfiles

Personal dotfiles and configuration files for a modern development environment.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Clone Repository](#clone-repository)
  - [System Requirements](#system-requirements)
  - [Shell Setup](#shell-setup)
  - [ZSH Configuration](#zsh-configuration)
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

**Note**: The `--recurse-submodules` flag is important as it clones the Antidote plugin manager and Pure prompt theme.

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
  xclip \
  tmux \
```

### Shell Setup

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

4. Set up other shell configurations:
```bash
# Symlink aliases and vim configuration
ln -sf ~/dotfiles/.aliases ~/
ln -sf ~/dotfiles/.vimrc ~/
```

### ZSH Configuration

This dotfiles repository uses a clean, organized structure for ZSH configuration following the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).

#### Directory Structure

```
dotfiles/
├── zshenv                    # Bootstrap file (symlinks to ~/.zshenv)
└── .config/zsh/
    ├── .zshrc               # Main ZSH configuration
    ├── zshrc.linux          # Linux-specific settings
    ├── zshrc.macos          # macOS-specific settings
    ├── .zsh_plugins.txt     # Antidote plugin declarations
    └── antidote/            # Antidote plugin manager (submodule)
```

#### Key Features

- **Clean home directory**: Only `~/.zshenv` in your home directory
- **XDG compliant**: All ZSH configs in `~/.config/zsh/`
- **Platform detection**: Automatically loads OS-specific configurations
- **Antidote plugin manager**: Fast, modern plugin management
- **Pure prompt**: Beautiful, minimal prompt with git integration

#### Installation

1. Create the config directory:
```bash
mkdir -p ~/.config
```

2. Set up symlinks:
```bash
# Bootstrap file that sets ZDOTDIR
ln -sf ~/dotfiles/zshenv ~/.zshenv

# Link entire zsh configuration directory
ln -sf ~/dotfiles/.config/zsh ~/.config/zsh
```

3. Reload your shell:
```bash
exec zsh
```

#### Plugin Management

Plugins are managed using [Antidote](https://github.com/mattmc3/antidote), a modern ZSH plugin manager. Plugins are declared in `.config/zsh/.zsh_plugins.txt`.

**Current plugins:**
- `sindresorhus/pure` - Beautiful, minimal prompt theme
- `zsh-users/zsh-autosuggestions` - Fish-like autosuggestions
- `zsh-users/zsh-completions` - Additional completion definitions
- `zdharma-continuum/fast-syntax-highlighting` - Fast syntax highlighting (deferred)

**Adding new plugins:**

1. Edit `.config/zsh/.zsh_plugins.txt` and add the plugin in `user/repo` format:
```bash
echo "user/plugin-name" >> ~/.config/zsh/.zsh_plugins.txt
```

2. Reload your shell:
```bash
exec zsh
```

Antidote will automatically clone and load the new plugin.

**Updating plugins:**
```bash
# Update Antidote itself
cd ~/dotfiles/.config/zsh/antidote && git pull

# Antidote automatically updates plugins on shell reload
exec zsh
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
