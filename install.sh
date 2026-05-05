#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting dotfiles installation...${NC}"

# Define the dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# List of apps/folders to link
apps=("hypr" "kitty" "waybar" "rofi" "btop" "nvim")

# Create .config if it doesn't exist
mkdir -p "$CONFIG_DIR"

for app in "${apps[@]}"; do
    if [ -d "$DOTFILES_DIR/$app" ]; then
        echo -e "${BLUE}Linking $app...${NC}"
        
        # Back up existing config if it's not a symlink
        if [ -e "$CONFIG_DIR/$app" ] && [ ! -L "$CONFIG_DIR/$app" ]; then
            echo "Backing up existing $app config to $CONFIG_DIR/${app}_backup"
            mv "$CONFIG_DIR/$app" "$CONFIG_DIR/${app}_backup"
        fi
        
        # Remove existing symlink if it exists
        if [ -L "$CONFIG_DIR/$app" ]; then
            rm "$CONFIG_DIR/$app"
        fi
        
        # Create the symlink
        ln -s "$DOTFILES_DIR/$app" "$CONFIG_DIR/$app"
        echo -e "${GREEN}Successfully linked $app${NC}"
    else
        echo "Warning: $app directory not found in $DOTFILES_DIR"
    fi
done

echo -e "${GREEN}Installation complete!${NC}"
echo "Note: Make sure you have the following packages installed:"
echo "hyprland, kitty, waybar, rofi-wayland, btop, neovim"
