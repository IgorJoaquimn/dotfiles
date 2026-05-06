#!/bin/bash
# Fetch a random wallpaper from Wallhaven and update wallpaper
TARGET="$HOME/Pictures/wallpaper.jpg"
mkdir -p "$HOME/Pictures"
API_URL="https://wallhaven.cc/api/v1/search?sorting=random&purity=100&categories=111&q=id:23416"

# Fetch the JSON response and use jq to extract the path
IMG_URL=$(curl -s "$API_URL" | jq -r '.data[0].path')

if [ -n "$IMG_URL" ] && [ "$IMG_URL" != "null" ]; then
    wget -q "$IMG_URL" -O "$TARGET"
    
    # Update wallpaper using swaybg
    killall swaybg 2>/dev/null
    swaybg -m fill -i "$TARGET" &
else
    echo "Failed to fetch wallpaper URL"
    exit 1
fi
