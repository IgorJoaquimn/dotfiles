#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers/photo"
STATE_FILE="$HOME/.cache/current_wallpaper_index"

# Get list of images
IFS=$'\n' read -d '' -r -a images < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort && printf '\0')
num_images=${#images[@]}

if [ "$num_images" -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Get current index
if [ -f "$STATE_FILE" ]; then
    index=$(cat "$STATE_FILE")
else
    index=-1
fi

# Increment index
next_index=$(( (index + 1) % num_images ))
echo "$next_index" > "$STATE_FILE"

NEXT_WALLPAPER="${images[$next_index]}"

# Update SDDM background
cp "$NEXT_WALLPAPER" "/usr/share/sddm/themes/pixel-coffee/background.jpg"

# Use swaybg to set the wallpaper
# Kill existing swaybg processes
killall swaybg 2>/dev/null

# Start swaybg in the background
swaybg -m fill -i "$NEXT_WALLPAPER" &
