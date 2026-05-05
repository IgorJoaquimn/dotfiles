#!/bin/bash
# Fetch a random wallpaper from Wallhaven and update hyprpaper
TARGET="$HOME/Pictures/wallpaper.jpg"
API_URL="https://wallhaven.cc/api/v1/search?sorting=random&purity=100&categories=111"
# Fetch the JSON response and use jq to extract the path
IMG_URL=$(curl -s "$API_URL" | jq -r '.data[0].path')
wget "$IMG_URL" -O "$TARGET"

# Update hyprpaper configuration
hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$TARGET"
hyprctl hyprpaper wallpaper ",$TARGET"
