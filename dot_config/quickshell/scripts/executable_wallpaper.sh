#!/bin/bash

DIRECTORY="/home/finn/Pictures/Wallpaper/"
SCRIPT="/home/finn/.config/scripts/wallpaper.sh"
THUMBS="/home/finn/.config/quickshell/assets/thumbs"
FILE="/home/finn/.config/quickshell/assets/files/wallpapers.json"

mkdir -p "$THUMBS"

find "$DIRECTORY" -type f | sort -u | while read -r path; do
    filename=$(basename "$path")
    thumb="$THUMBS/${filename%.*}.jpg"

    # Only generate if thumbnail doesn't exist yet
    if [[ ! -f "$thumb" ]]; then
        # For GIFs grab first frame, for others just resize
        ffmpeg -i "$path" -vframes 1 -vf "scale=1080:-1" "$thumb" -y 2>/dev/null
    fi
done

JSON=$(find "$DIRECTORY" -type f | sort -u | jq -Rn --arg script "$SCRIPT" --arg thumbs "$THUMBS" '[inputs | {name: (. | split("/") | last | split(".") | first), path: ., thumb: ($thumbs + "/" + (. | split("/") | last | split(".") | first) + ".jpg"), command: ($script + " " + .)}]')

echo "$JSON" >"$FILE"
