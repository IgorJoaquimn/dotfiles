#!/bin/bash
# Install script for daily Wallhaven wallpaper service
echo "Installing dependencies..."
sudo pacman -S --noconfirm jq wget

# Setup binary directory
mkdir -p "$HOME/.local/bin"
cp ".local/bin/wallpaper_fetcher.sh" "$HOME/.local/bin/"
cp ".local/bin/reload_wallpaper.sh" "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/wallpaper_fetcher.sh"
chmod +x "$HOME/.local/bin/reload_wallpaper.sh"

# Setup systemd services
mkdir -p "$HOME/.config/systemd/user"
cp "systemd/user/wallpaper.service" "$HOME/.config/systemd/user/"
cp "systemd/user/wallpaper.timer" "$HOME/.config/systemd/user/"

echo "Reloading systemd and enabling wallpaper timer..."
systemctl --user daemon-reload
systemctl --user enable --now wallpaper.timer

echo "Wallpaper service installed successfully!"
echo "It will run daily and every time you start Hyprland."
