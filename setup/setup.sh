#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting system setup...${NC}"

# Add apt repositories
echo -e "${YELLOW}Setting up apt repositories...${NC}"

# Install prerequisites
sudo apt-get install -y wget gpg apt-transport-https

# Setup Nala repository
echo -e "${YELLOW}Setting up Nala repository...${NC}"
echo "deb [arch=$(dpkg --print-architecture)] https://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list > /dev/null
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null

# Setup VS Code repository
echo -e "${YELLOW}Setting up VS Code repository...${NC}"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm /tmp/packages.microsoft.gpg

# Setup GitHub CLI repository
echo -e "${YELLOW}Setting up GitHub CLI repository...${NC}"
sudo mkdir -p -m 755 /etc/apt/keyrings
out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && sudo install -D -o root -g root -m 644 "$out" /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && rm "$out" \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Update package lists
sudo apt update

# Install Nala first
echo -e "${YELLOW}Installing Nala package manager...${NC}"
sudo apt-get install -y nala

# Configure Nala mirrors
echo -e "${YELLOW}Configuring Nala mirrors...${NC}"
sudo nala fetch --auto --fetches 3

# Install remaining packages using Nala
echo -e "${YELLOW}Installing packages from packages.list...${NC}"
mapfile -t pkgs < <(grep -v '^//' "$SCRIPT_DIR/packages.list" | grep -v -e '^$' -e '^nala$')
sudo nala install -y "${pkgs[@]}"

# Install Zsh if not already installed
echo -e "${YELLOW}Installing Zsh...${NC}"
if ! command -v zsh &> /dev/null; then
    sudo apt-get install -y zsh
fi

# Install Oh My Zsh
echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

# Install zoxide
echo -e "${YELLOW}Installing zoxide...${NC}"
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    
    # Ensure .local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.bashrc"
        export PATH="$PATH:$HOME/.local/bin"
    fi
fi

# Install nvm (Node Version Manager)
echo -e "${YELLOW}Installing nvm...${NC}"
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
fi

# Load nvm regardless of whether it was just installed or already existed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install and set up Node.js only if nvm is available
if command -v nvm &>/dev/null; then
    # Install latest LTS version of Node.js
    nvm install --lts
    nvm use --lts
    # Set the LTS version as default
    nvm alias default 'lts/*'
else
    echo -e "${YELLOW}Warning: nvm installation may require a new shell session${NC}"
fi

# Install Zsh plugins
echo -e "${YELLOW}Installing Zsh plugins...${NC}"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGINS_DIR/zsh-syntax-highlighting"
fi

# zsh-you-should-use
if [ ! -d "$PLUGINS_DIR/zsh-you-should-use" ]; then
    git clone https://github.com/MichaelAquilina/zsh-you-should-use "$PLUGINS_DIR/zsh-you-should-use"
fi

# Set up dotfiles
echo -e "${YELLOW}Setting up dotfiles...${NC}"
# Set up Oh My Zsh custom directory and aliases
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
mkdir -p "$ZSH_CUSTOM"
ln -sf "$DOTFILES_DIR/my-aliases.zsh" "$ZSH_CUSTOM/aliases.zsh"

# Set up dotfiles in home directory
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.nanorc" "$HOME/.nanorc" 2>/dev/null || true
ln -sf "$DOTFILES_DIR/.profile" "$HOME/.profile" 2>/dev/null || true
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" 2>/dev/null || true

# Set Zsh as default shell if not already set
if [[ "$SHELL" != *"zsh"* ]]; then
    echo -e "${YELLOW}Setting Zsh as default shell...${NC}"
    chsh -s $(which zsh)
fi

echo -e "${GREEN}Setup completed successfully!${NC}"
