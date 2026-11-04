#!/bin/bash
# Define the save location
DIR="$HOME/Pictures/Screenshots"
FILE="screenshot_$(date +%Y%m%d_%H%M%S).png"

# Ensure the directory exists
mkdir -p "$DIR"

# Use slurp to select a region and grim to capture it
# Then pipe it to wl-copy and save to file
slurp | grim -g - - | tee "$DIR/$FILE" | wl-copy

# Optional: Send a notification
notify-send "Screenshot Captured" "Saved to $DIR/$FILE and copied to clipboard"