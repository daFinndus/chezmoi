#!/bin/bash

# This script will fetch all files in ~/Pictures/Wallpaper
# Then it will generate a json from these files with their basename, path, and a command
# That command is basically my wallpaper script for changing wallpapers and the path

DIRECTORY="$HOME/Pictures/Wallpaper/"
SCRIPT="$XDG_DATA_HOME/../bin/set-wallpaper.sh"
FILE="$XDG_CONFIG_HOME/quickshell/assets/files/wallpapers.json"

JSON=$(find "$DIRECTORY" -type f | sort -u | jq -Rn --arg script "$SCRIPT" '[inputs | {name: (. | split("/") | last | split(".") | first), path: ., command: ($script + " " + .)}]')

echo "$JSON" >"$FILE"
