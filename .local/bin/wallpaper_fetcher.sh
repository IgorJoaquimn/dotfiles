#!/bin/bash
# Fetch a random wallpaper from Wallhaven and update wallpaper
TARGET="$HOME/Pictures/wallpaper.jpg"
mkdir -p "$HOME/Pictures"
API_URL="https://wallhaven.cc/api/v1/search?sorting=random&purity=100&categories=111&q=id:23416"

# Fetch the JSON response
RESPONSE=$(curl -s "$API_URL")

# Get number of images returned (max 24 per page usually)
COUNT=$(echo "$RESPONSE" | jq '.data | length')

if [ -n "$COUNT" ] && [ "$COUNT" -gt 0 ]; then
    # Pick a random index
    RANDOM_INDEX=$(( RANDOM % COUNT ))
    IMG_URL=$(echo "$RESPONSE" | jq -r ".data[$RANDOM_INDEX].path")
else
    echo "No images found in API response"
    exit 1
fi

if [ -n "$IMG_URL" ] && [ "$IMG_URL" != "null" ]; then
    wget -q "$IMG_URL" -O "$TARGET"
    
    # Update SDDM background
    cp "$TARGET" "/usr/share/sddm/themes/pixel-coffee/background.jpg"
    
    # Update wallpaper using swaybg
    killall swaybg 2>/dev/null
    swaybg -m fill -i "$TARGET" &
else
    echo "Failed to fetch wallpaper URL"
    exit 1
fi
