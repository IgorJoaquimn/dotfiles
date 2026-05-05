#!/bin/bash
# Install script for daily Wallhaven wallpaper service
echo "Installing dependencies..."
sudo pacman -S --noconfirm jq wget

# Setup binary directory
mkdir -p "$HOME/.local/bin"
cp wallpaper_fetcher.sh "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/wallpaper_fetcher.sh"

# Setup systemd services
mkdir -p "$HOME/.config/systemd/user"
cp wallpaper.service wallpaper.timer "$HOME/.config/systemd/user/"

echo "Reloading systemd and enabling wallpaper timer..."
systemctl --user daemon-reload
systemctl --user enable --now wallpaper.timer

echo "Wallpaper service installed successfully!"
