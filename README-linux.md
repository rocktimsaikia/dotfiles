# dotfiles — Linux (Ubuntu/Debian)

Install guide for Ubuntu/Debian Linux. For macOS see [README-macos.md](README-macos.md).

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
  - [Claude Code Statusline](#claude-code-statusline)
- [Post-Installation](#post-installation)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Need:
- Ubuntu/Debian Linux distro
- Root access for system package install
- Basic shell command knowledge

## Installation

### Clone Repository

Clone repo with submodules:
```bash
git clone --recurse-submodules https://github.com/rocktimsaikia/dotfiles
```

**Note**: `--recurse-submodules` flag important — clones Antidote plugin manager and TPM (tmux plugin manager).

### Quick setup

Run setup script, makes all symlinks at once (home dotfiles, `.config/*`, `bin`, Claude Code config, global agent instructions, fonts):

```bash
cd ~/dotfiles && ./setup.sh
```

Replaces individual `ln -sf` steps below (kept as reference). Still need package installs and plugin bootstrap steps after.

### System Packages

Install essential packages:

```bash
sudo apt install \
  zsh \
  fastfetch \
  ripgrep \
  fzf \
  fuse \
  git \
  vim \
  curl \
  make \
  xclip \
  tmux
```

### Shell Setup

1. Check current shell:
```bash
echo $SHELL
```

2. Check zsh available:
```bash
cat /etc/shells
```

3. Switch to zsh (needs reboot):
```bash
chsh -s /bin/zsh
```

4. Set up other shell configs:
```bash
# Symlink aliases and vim configuration
ln -sf ~/dotfiles/.aliases ~/
ln -sf ~/dotfiles/.vimrc ~/
```

### ZSH Configuration

Repo use clean, organized ZSH config structure per [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).

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

- **Clean home directory**: Only `~/.zshenv` in home
- **XDG compliant**: All ZSH configs in `~/.config/zsh/`
- **Platform detection**: Auto-loads OS-specific configs
- **Antidote plugin manager**: Fast, modern plugin management
- **Pure prompt**: Minimal prompt with git integration

#### Installation

1. Make config dir:
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

Clones all plugins (Pure prompt, autosuggestions, etc.) and generates plugin loader script. **Without this, Pure prompt and other plugins won't work.**

4. Reload shell:
```bash
exec zsh
```

#### Plugin Management

Plugins managed with [Antidote](https://github.com/mattmc3/antidote), modern ZSH plugin manager. Declared in `.config/zsh/.zsh_plugins.txt`.

**Current plugins:**
- `sindresorhus/pure` - Minimal prompt theme
- `zsh-users/zsh-autosuggestions` - Fish-like autosuggestions
- `zsh-users/zsh-completions` - Extra completion definitions
- `zdharma-continuum/fast-syntax-highlighting` - Fast syntax highlighting (deferred)

**Adding new plugins:**

1. Edit `.config/zsh/.zsh_plugins.txt`, add plugin in `user/repo` format:
```bash
echo "user/plugin-name" >> ~/.config/zsh/.zsh_plugins.txt
```

2. Reload shell:
```bash
exec zsh
```

Antidote auto-clones and loads new plugin.

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

2. Verify install:
```bash
nvim --version
```

3. Symlink nvim config:
```bash
mkdir -p ~/.config
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
```

4. Open Neovim — lazy.nvim bootstraps itself, starts installing plugins:
```bash
nvim
```

Wait till lazy.nvim UI reports all plugins installed (build steps like `:TSUpdate` and `make install_jsregexp` run automatically). If incomplete, run `:Lazy sync` and `:TSUpdate` in nvim, then restart.

### Tmux Setup

Tmux config at `.config/tmux/tmux.conf`, uses [TPM](https://github.com/tmux-plugins/tpm) for plugin management. TPM included as git submodule under `.config/tmux/plugins/tpm` — must clone with `--recurse-submodules` (see [Clone Repository](#clone-repository)).

1. Symlink tmux config dir:
```bash
ln -sf ~/dotfiles/.config/tmux ~/.config/tmux
```

2. Start tmux, install plugins:
```bash
tmux
```

In tmux, press `prefix + I` (default prefix `Ctrl-b`, so `Ctrl-b` then `Shift-i`) to fetch and install declared plugins.

### Node.js Ecosystem

1. Install `nvm` (Node Version Manager):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
```

Drops `~/.nvm` dir. Shared `.zshrc` already sources it, so new shell picks it up.

2. Install latest LTS Node:
```bash
nvm install --lts
nvm use --lts
```

3. Install dev tools globally:
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

[Extension Manager](https://github.com/mjakeman/extension-manager) is GUI for browsing, installing, configuring GNOME Shell extensions without browser.

1. Install Extension Manager and browser connector via apt:
```bash
sudo apt install gnome-shell-extension-manager gnome-browser-connector
```

`gnome-browser-connector` package lets you install extensions direct from [extensions.gnome.org](https://extensions.gnome.org) (also need GNOME Shell integration browser add-on).

2. Launch:
```bash
extension-manager
```

Use **Browse** tab to install extensions, **Installed** tab to toggle and configure.

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

### Claude Code Statusline

Custom [Claude Code](https://claude.com/claude-code) statusline at `.claude/statusline.sh`, activated by `statusLine` block in `.claude/settings.json`. Both files tracked in repo, activated by symlink.

1. Install `jq` (parses statusline JSON — without it script falls back to slower bash parsing, drops some fields):
```bash
sudo apt install jq
```

2. Symlink config into `~/.claude/`:
```bash
mkdir -p ~/.claude
ln -sf ~/dotfiles/.claude/statusline.sh ~/.claude/statusline.sh
ln -sf ~/dotfiles/.claude/settings.json ~/.claude/settings.json
```

**Note**: If `~/.claude/settings.json` already exists as real file (not symlink), back it up first (`mv ~/.claude/settings.json ~/.claude/settings.json.bak`) — else `-f` overwrites it and you lose machine-specific settings. Per-machine overrides belong in `~/.claude/settings.local.json`, which is gitignored.

3. Restart Claude Code — new statusline picked up next launch.

4. Symlink global agent instructions (shared by Claude Code via `~/.claude/CLAUDE.md` and Codex/others via `~/AGENTS.md`):
```bash
ln -sf ~/dotfiles/.claude/CLAUDE.md ~/AGENTS.md
ln -sf ~/AGENTS.md ~/.claude/CLAUDE.md
```

## Post-Installation

After install:
1. Reboot to apply shell changes
2. Verify configs by opening new terminal
3. Test Neovim — open it, check for errors

## Troubleshooting

### Pure prompt not showing

If prompt looks like default zsh prompt not Pure:

**Cause**: Antidote plugins not installed. `.zsh_plugins.zsh` file empty or missing.

**Solution**: Run plugin install command:
```bash
cd ~/.config/zsh
source antidote/antidote.zsh
antidote bundle < .zsh_plugins.txt > .zsh_plugins.zsh
exec zsh
```

**Verify**: Check plugins installed — `ls ~/.cache/antidote/` should show plugin directories.

## License

MIT License - see LICENSE file for details