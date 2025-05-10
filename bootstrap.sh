#!/bin/bash

DOTFILES_REPO="acedanger/dotfiles"
DOTFILES_BRANCH="main"
DOTFILES_DIR="$HOME/dev/dotfiles"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up your system...${NC}"

# Install git if not present
if ! command -v git &>/dev/null; then
    echo -e "${YELLOW}Installing git...${NC}"
    sudo apt update && sudo apt install -y git
fi

# Create dev directory if it doesn't exist
mkdir -p "$HOME/dev"

# Clone or update repository
if [ -d "$DOTFILES_DIR" ]; then
    echo -e "${YELLOW}Updating existing dotfiles repository...${NC}"
    cd "$DOTFILES_DIR"
    git pull origin $DOTFILES_BRANCH
else
    echo -e "${YELLOW}Cloning dotfiles repository...${NC}"
    git clone "https://github.com/$DOTFILES_REPO.git" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

# Make scripts executable
chmod +x "$DOTFILES_DIR/setup/setup.sh"

# Run setup script
"$DOTFILES_DIR/setup/setup.sh"

echo -e "${GREEN}Bootstrap completed! Please restart your terminal for changes to take effect.${NC}"
