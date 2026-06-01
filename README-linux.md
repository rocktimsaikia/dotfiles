# dotfiles — Linux (Ubuntu/Debian)

Installation guide for Ubuntu/Debian-based Linux distributions. For macOS, see [README-macos.md](README-macos.md).

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Clone Repository](#clone-repository)
  - [System Packages](#system-packages)
  - [Shell Setup](#shell-setup)
  - [ZSH Configuration](#zsh-configuration)
  - [Neovim Setup](#neovim-setup)
  - [Tmux Setup](#tmux-setup)
  - [Node.js Ecosystem](#nodejs-ecosystem)
  - [GNOME Extension Manager](#gnome-extension-manager)
  - [Custom Scripts and Fonts](#custom-scripts-and-fonts)
- [Post-Installation](#post-installation)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before proceeding, ensure your system has the following:
- An Ubuntu/Debian-based Linux distribution
- Root access for system package installation
- Basic understanding of shell commands

## Installation

### Clone Repository

First, clone the repository with its submodules:
```bash
git clone --recurse-submodules https://github.com/rocktimsaikia/dotfiles
```

**Note**: The `--recurse-submodules` flag is important as it clones the Antidote plugin manager and TPM (tmux plugin manager).

### System Packages

Install the essential system packages:

```bash
sudo apt install \
  zsh \
  fastfetch \
  ripgrep \
  fuse \
  git \
  vim \
  curl \
  make \
  xclip \
  tmux
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

3. Install plugins (REQUIRED for first-time setup):
```bash
cd ~/.config/zsh
source antidote/antidote.zsh
antidote bundle < .zsh_plugins.txt > .zsh_plugins.zsh
```

This step clones all plugins (Pure prompt, autosuggestions, etc.) and generates the plugin loader script. **Without this step, Pure prompt and other plugins won't work.**

4. Reload your shell:
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

3. Symlink the nvim config:
```bash
mkdir -p ~/.config
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
```

4. Open Neovim — lazy.nvim will bootstrap itself and start installing plugins:
```bash
nvim
```

Wait until lazy.nvim's UI reports all plugins installed (build steps like `:TSUpdate` and `make install_jsregexp` run automatically). If anything looks incomplete, run `:Lazy sync` and `:TSUpdate` inside nvim, then restart.

### Tmux Setup

Tmux config lives at `.config/tmux/tmux.conf` and uses [TPM](https://github.com/tmux-plugins/tpm) for plugin management. TPM is included as a git submodule under `.config/tmux/plugins/tpm`, so make sure you cloned with `--recurse-submodules` (see [Clone Repository](#clone-repository)).

1. Symlink the tmux config directory:
```bash
ln -sf ~/dotfiles/.config/tmux ~/.config/tmux
```

2. Start tmux and install plugins:
```bash
tmux
```

Inside tmux, press `prefix + I` (default prefix is `Ctrl-b`, so `Ctrl-b` then `Shift-i`) to fetch and install the declared plugins.

### Node.js Ecosystem

1. Install `nvm` (Node Version Manager):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
```

This drops a `~/.nvm` directory. The shared `.zshrc` already sources it, so a new shell will pick it up.

2. Install the latest LTS Node:
```bash
nvm install --lts
nvm use --lts
```

3. Install development tools globally:
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

### GNOME Extension Manager

[Extension Manager](https://github.com/mjakeman/extension-manager) is a GUI for browsing, installing, and configuring GNOME Shell extensions without a browser.

1. Install Extension Manager and the browser connector via apt:
```bash
sudo apt install gnome-shell-extension-manager gnome-browser-connector
```

The `gnome-browser-connector` package lets you install extensions directly from [extensions.gnome.org](https://extensions.gnome.org) (you'll also need the GNOME Shell integration browser add-on).

2. Launch it:
```bash
extension-manager
```

Use the **Browse** tab to install extensions and the **Installed** tab to toggle and configure them.

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

## Troubleshooting

### Pure prompt not showing

If your prompt looks like the default zsh prompt instead of Pure:

**Cause**: Antidote plugins weren't installed. The `.zsh_plugins.zsh` file is empty or missing.

**Solution**: Run the plugin installation command:
```bash
cd ~/.config/zsh
source antidote/antidote.zsh
antidote bundle < .zsh_plugins.txt > .zsh_plugins.zsh
exec zsh
```

**Verify**: Check that plugins are installed — `ls ~/.cache/antidote/` should show plugin directories.

## License

MIT License - see LICENSE file for details
