# dotfiles-chezmoi

My personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

> **Note:** Previously managed dotfiles at [kaitoimai/dotfiles](https://github.com/kaitoimai/dotfiles)

## Directory Structure

```
.
├── .chezmoi.toml.tmpl          # chezmoi configuration (template)
├── .chezmoiignore              # Files to ignore
├── .gitignore
├── .pre-commit-config.yaml     # prek configuration (pre-commit hook)
├── .secretlintrc.json          # secretlint configuration (secret detection)
├── package.json
├── package-lock.json
│
├── dot_Brewfile                # Homebrew dependencies → ~/.Brewfile
├── dot_tmux.conf               # Tmux config file → ~/.tmux.conf
│
├── dot_config/
│   ├── chezmoi/
│   │   └── scripts/            # chezmoi scripts
│   ├── ghostty/                # Ghostty (terminal) config
│   │   └── config
│   ├── nvim/                   # Neovim configuration
│   │   ├── init.lua            # Entry point
│   │   ├── lazy-lock.json      # Plugin lockfile
│   │   └── lua/                # Lua config files
│   ├── private_fish/           # Fish shell config (private)
│   │   └── config.fish.tmpl
│   ├── yazi/                   # Yazi (file manager) config
│   │   └── yazi.toml
│   └── zellij/                 # Zellij (terminal multiplexer) config
│       └── config.kdl
│
└── dot_hammerspoon/            # Hammerspoon config → ~/.hammerspoon/
    └── init.lua
```

## Setup

### Prerequisites

- macOS
- [Homebrew](https://brew.sh/) installed

### Initial Setup

**Install chezmoi and apply dotfiles**

```bash
# Install chezmoi (if not already installed)
brew install chezmoi

# Initialize dotfiles repository
chezmoi init https://github.com/kaitoimai/dotfiles-chezmoi.git

# Review changes
chezmoi diff

# Apply changes
chezmoi apply
```

**Install Node.js dependencies (for secretlint)**

```bash
cd ~/.local/share/chezmoi
npm install
```

**Setup prek (pre-commit hooks)**

```bash
# Install prek
brew install prek

# Enable pre-commit hooks
cd ~/.local/share/chezmoi
prek install
```

**Setup tmux plugin manager (tpm)**

```bash
# Clone tpm repository
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux and install plugins
# Press Prefix + I to install all plugins
```

## Updating Configuration Files

When you need to update configuration files managed by chezmoi (e.g., `config.fish`, `nvim/init.lua`):

**Edit source files in chezmoi directory**

```bash
# Navigate to chezmoi source directory
cd ~/.local/share/chezmoi

# Edit the source file
# Example: vim dot_config/private_fish/config.fish.tmpl

# Preview changes before applying
chezmoi diff

# Apply changes to home directory
chezmoi apply
```

**Apply specific files only**

```bash
# Apply specific file
chezmoi apply ~/.config/fish/config.fish

# Apply specific directory
chezmoi apply ~/.config/nvim

# Apply multiple files
chezmoi apply ~/.config/fish/config.fish ~/.gitconfig
```

**Preview changes before applying (dry-run)**

```bash
# Preview changes for specific file
chezmoi diff ~/.config/fish/config.fish

# Dry-run (show what would be applied without actually applying)
chezmoi apply --dry-run ~/.config/fish/config.fish

# Verbose mode to see detailed changes
chezmoi apply --verbose --dry-run
```
