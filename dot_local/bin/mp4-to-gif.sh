#!/bin/bash
# Converts an .mp4 to a high-quality .gif using a two-pass palette,
# then cleans up everything except the final .gif.

set -euo pipefail

log() {
	echo -e "[CONVERT] $1"
}

input="$1"

if [[ -z "$input" ]]; then
	log "Gotta provide a mp4, dude."
	exit
fi

if [[ ! -f "$input" ]]; then
  log "File not found: $input"
  exit 1
fi

name="$(basename "${input%.*}")"
dir="$(dirname "$input")"

palette="$dir/${name}-palette.png"
output="$dir/${name}.gif"

scale=3000
fps=10

echo ""
log "Generating palette...\n"
ffmpeg -y -i "$input" -vf "fps=$fps,scale=${scale}:-1:flags=lanczos,palettegen=stats_mode=full" "$palette"

echo ""
log -e "Encoding gif..."
ffmpeg -y -i "$input" -i "$palette" -filter_complex \
  "fps=$fps,scale=${scale}:-1:flags=lanczos[x];[x][1:v]paletteuse" "$output"

echo ""
log "Cleaning up..."

rm -f "$palette" "$input"

echo ""
log "Done: $output"
