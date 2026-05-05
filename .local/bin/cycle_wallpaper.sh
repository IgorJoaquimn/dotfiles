#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers/photo"
STATE_FILE="$HOME/.cache/current_wallpaper_index"

# Get list of images
images=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort))
num_images=${#images[@]}

if [ "$num_images" -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Get current index
if [ -f "$STATE_FILE" ]; then
    index=$(cat "$STATE_FILE")
else
    index=0
fi

# Increment index
next_index=$(( (index + 1) % num_images ))
echo "$next_index" > "$STATE_FILE"

NEXT_WALLPAPER="${images[$next_index]}"

# Update hyprpaper
hyprctl hyprpaper preload "$NEXT_WALLPAPER"
hyprctl hyprpaper wallpaper ",$NEXT_WALLPAPER"

# Unload previous wallpaper to save memory (optional but recommended)
if [ -n "${images[$index]}" ] && [ "${images[$index]}" != "$NEXT_WALLPAPER" ]; then
    # Wait a bit to ensure the transition is smooth if any, then unload
    (sleep 1 && hyprctl hyprpaper unload "${images[$index]}") &
fi
