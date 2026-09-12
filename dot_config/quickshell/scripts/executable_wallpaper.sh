#!/bin/bash

DIRECTORY="/home/finn/Pictures/Wallpaper/"
SCRIPT="/home/finn/.config/scripts/wallpaper.sh"
FILE="/home/finn/.config/quickshell/assets/files/wallpapers.json"

JSON=$(find "$DIRECTORY" -type f | sort -u | jq -Rn --arg script "$SCRIPT" '[inputs | {name: (. | split("/") | last | split(".") | first), path: ., command: ($script + " " + .)}]')

echo "$JSON" >"$FILE"
