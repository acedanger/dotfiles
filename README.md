
# dotfiles

My personal dotfiles and system setup configuration for Linux machines.

## Quick Start

To set up a new machine, run:

```bash
curl -fsSL https://raw.githubusercontent.com/acedanger/dotfiles/main/bootstrap.sh | bash
```

## What's Included

### Package Managers
- [**Nala**](https://gitlab.com/volian/nala): A better front-end for `apt` with parallel downloads and improved interface
- [**VS Code**](https://code.visualstudio.com/): Microsoft's popular code editor
- [**GitHub CLI**](https://cli.github.com/): Official GitHub command-line tool

### Core Packages
- [`git`](https://git-scm.com/): Version control
- [`python3`](https://www.python.org/): Python runtime
- [`wget`](https://www.gnu.org/software/wget/) & [`curl`](https://curl.se/): Download utilities
- [`bat`](https://github.com/sharkdp/bat): A better `cat` with syntax highlighting
- [`cowsay`](https://github.com/piuccio/cowsay): For fun CLI messages
- [`lolcat`](https://github.com/busyloop/lolcat): Colorful terminal output
- [`fzf`](https://github.com/junegunn/fzf): Fuzzy finder
- [`zsh`](https://www.zsh.org/): Better shell
- [`nala`](https://gitlab.com/volian/nala): Better package manager for Debian/Ubuntu

### Shell Setup
- [**Oh My Zsh**](https://ohmyz.sh/): Framework for managing Zsh configuration
- [**Agnoster Theme**](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster): Beautiful terminal theme with Git integration

#### Zsh Plugins
1. [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions): Suggests commands as you type based on history
2. [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting): Syntax highlighting for the shell
3. [`zsh-you-should-use`](https://github.com/MichaelAquilina/zsh-you-should-use): Reminds you of existing aliases
4. [`git`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git): Git integration and aliases
5. [`docker`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker): Docker commands integration
6. [`docker-compose`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker-compose): Docker Compose integration
7. [`z`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/z): Quick directory jumping
8. [`ssh`](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh): SSH configuration and shortcuts

### Development Tools
- [**nvm**](https://github.com/nvm-sh/nvm): Node Version Manager for managing Node.js versions
- [**zoxide**](https://github.com/ajeetdsouza/zoxide): Smarter directory navigation (a modern replacement for `z`)
- [**VS Code**](https://code.visualstudio.com/): Code editor with essential extensions

## Features

### Automatic Setup
- Automatically installs and configures all necessary packages and tools
- Sets up Zsh as the default shell
- Configures Nala package manager with optimized mirrors
- Installs and configures Node.js LTS version via nvm
- Sets up VS Code with recommended extensions

### Dotfile Management
- Automatically symlinks all configuration files
- Manages Zsh configuration and plugins
- Sets up Git configuration
- Configures custom aliases and functions

### Custom Configurations
- Terminal greeting with fortune and cowsay
- Optimized Zsh history settings
- Improved command-line navigation with zoxide
- Automatic Node.js version switching using .nvmrc

## Installation Process

1. The script will first set up necessary package repositories:
   - Nala package manager
   - VS Code
   - GitHub CLI

2. Install core packages using Nala for better performance

3. Set up the shell environment:
   - Install Zsh and Oh My Zsh
   - Configure Zsh plugins and themes
   - Set up custom aliases and configurations

4. Install development tools:
   - Set up nvm and Node.js
   - Configure zoxide for better navigation
   - Install and configure Git

## Manual Steps

If you need to manually set up aliases:

```sh
# Create new symlink
ln -s ~/dev/dotfiles/my-aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh

# If the symlink already exists, use -f to force creation
ln -sf ~/dev/dotfiles/my-aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
```

## Post-Installation

After installation:
1. Start a new terminal session or run `zsh`
2. The shell will be configured with all plugins and settings
3. You can start using all installed tools and aliases

## Maintenance

To update your setup:
1. Pull the latest changes from the repository
2. Run the setup script again - it's designed to be idempotent
3. Start a new shell session to apply any changes
