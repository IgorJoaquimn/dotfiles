#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting dotfiles installation...${NC}"

# Define dependencies
dependencies=(
    "hyprland"
    "swaybg"
    "hypridle"
    "kitty"
    "waybar"
    "rofi-wayland"
    "btop"
    "neovim"
    "ttf-firacode-nerd"
    "ttf-fira-mono"
    "thunar"
    "yazi"
    "dunst"
    "zsh"
    "starship"
    "fzf"
    "zoxide"
    "hyprshot"
    "qimgv"
    "mpv"
    "zathura"
    "zathura-pdf-mupdf"
    "jq"
    "wget"
    "cmake"
    "cpio"
    "pkgconf"
    "meson"
    "ninja"
    "blueman"
    "pavucontrol"
    "nm-connection-editor"
    "network-manager-applet"
    "nwg-look"
    "papirus-icon-theme"
)

# Function to check and install dependencies
install_dependencies() {
    echo -e "${BLUE}Checking for dependencies...${NC}"
    
    if ! command -v yay &> /dev/null; then
        echo -e "${RED}Error: 'yay' is not installed. Please install an AUR helper first.${NC}"
        echo -e "${BLUE}Quick tip: sudo pacman -S --needed base-devel git && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si${NC}"
        return 1
    fi

    for pkg in "${dependencies[@]}"; do
        if pacman -Qi "$pkg" &> /dev/null; then
            echo -e "${GREEN}[OK] $pkg is already installed.${NC}"
        else
            echo -e "${BLUE}Installing $pkg...${NC}"
            yay -S --noconfirm "$pkg"
        fi
    done

    echo -e "${BLUE}Cleaning up unused packages...${NC}"
    yay -Yc --noconfirm
}

# Run dependency installation
install_dependencies || exit 1

# Define the dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# List of apps/folders to link
apps=("hypr" "kitty" "waybar" "rofi" "btop" "nvim" "dunst" "yazi" "bash")

# Create .config if it doesn't exist
mkdir -p "$CONFIG_DIR"

echo -e "${BLUE}Linking configuration files...${NC}"

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

# Setup local bin directory and scripts
echo -e "${BLUE}Setting up local scripts...${NC}"
mkdir -p "$HOME/.local/bin"
if [ -d "$DOTFILES_DIR/.local/bin" ]; then
    for script in "$DOTFILES_DIR/.local/bin"/*; do
        script_name=$(basename "$script")
        ln -sf "$script" "$HOME/.local/bin/$script_name"
        chmod +x "$HOME/.local/bin/$script_name"
    done
    echo -e "${GREEN}Local scripts linked and executable${NC}"
fi

# Setup systemd services for wallpaper
echo -e "${BLUE}Setting up wallpaper service...${NC}"
mkdir -p "$HOME/.config/systemd/user"
if [ -d "$DOTFILES_DIR/systemd/user" ]; then
    cp "$DOTFILES_DIR/systemd/user"/wallpaper.* "$HOME/.config/systemd/user/"
    systemctl --user daemon-reload
    systemctl --user enable --now wallpaper.timer
    echo -e "${GREEN}Wallpaper service enabled${NC}"
fi

# Install Yazi packages
if command -v ya &> /dev/null; then
    echo -e "${BLUE}Installing Yazi packages...${NC}"
    (cd "$DOTFILES_DIR/yazi" && ya pkg install)
    echo -e "${GREEN}Yazi packages installed${NC}"
fi

# Hyprland Plugin setup
echo -e "${BLUE}Setting up Hyprland plugins...${NC}"
if command -v hyprpm &> /dev/null; then
    if ! hyprpm list | grep -q "split-monitor-workspaces"; then
        echo -e "${BLUE}Adding split-monitor-workspaces plugin...${NC}"
        hyprpm update
        hyprpm add https://github.com/zjeffer/split-monitor-workspaces
        hyprpm enable split-monitor-workspaces
        hyprpm reload
        echo -e "${GREEN}Hyprland plugins configured${NC}"
    else
        echo -e "${GREEN}[OK] split-monitor-workspaces plugin is already installed.${NC}"
        hyprpm reload # Just reload to ensure it's active
    fi
fi

# SDDM Theme setup
echo -e "${BLUE}Setting up SDDM theme...${NC}"
if [ -d "/usr/share/sddm/themes" ]; then
    echo -e "${BLUE}Installing/Updating pixel-coffee theme from repo...${NC}"
    sudo mkdir -p /usr/share/sddm/themes/pixel-coffee
    sudo cp -r "$DOTFILES_DIR/sddm/themes/pixel-coffee/"* /usr/share/sddm/themes/pixel-coffee/
    
    # Allow user to update background without sudo (needed for the fetcher script)
    sudo chown -R $USER:$USER /usr/share/sddm/themes/pixel-coffee/
    
    # Enable theme in SDDM
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=pixel-coffee" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null
    echo -e "${GREEN}SDDM theme configured${NC}"
fi

# Ensure local configuration files exist to prevent errors
echo -e "${BLUE}Ensuring local configuration files exist...${NC}"
touch "$HOME/.config/hypr/local.conf"
touch "$HOME/.bashrc_local"
touch "$HOME/.zshrc_local"

# Link .zshrc and starship.toml to their expected locations
echo -e "${BLUE}Performing additional symlinks for Zsh and Starship...${NC}"
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# Change default shell to zsh if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${BLUE}Changing default shell to zsh...${NC}"
    chsh -s "$(which zsh)"
fi

# Source the bash editor config in .bashrc if not already present
BASHRC="$HOME/.bashrc"
if [ -f "$BASHRC" ]; then
    SOURCE_LINE="[ -f \$HOME/.config/bash/.bashrc_editor ] && source \$HOME/.config/bash/.bashrc_editor"
    if ! grep -q "bash/.bashrc_editor" "$BASHRC"; then
        echo -e "${BLUE}Adding source line to .bashrc...${NC}"
        echo "" >> "$BASHRC"
        echo "# Source dotfiles editor configuration" >> "$BASHRC"
        echo "$SOURCE_LINE" >> "$BASHRC"
        echo -e "${GREEN}Added to .bashrc${NC}"
    fi
fi

# Set dark theme preference
if command -v gsettings &> /dev/null; then
    echo -e "${BLUE}Applying Tokyo Night GTK and Icon theme...${NC}"
    gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-Dark"
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    echo -e "${GREEN}System theme set to Tokyo Night${NC}"
fi

echo -e "${GREEN}Installation complete! Please restart Hyprland to apply all changes.${NC}"
