#!/usr/bin/env bash

# This will set a specified application as a default for typical mimes

APP="$1"

log() {
  echo "[MIMER] $1"
}

if [[ -z $APP ]]; then
  log "A default has to be specified."
  exit 1
elif [[ $APP =~ ^[A-Za-z0-9]+\.[A-Za-z0-9]+$ ]]; then
  log "It seems the application is valid!"
  echo ""
fi

MIMES=(
  application/pdf
  application/rtf
  application/zip
  application/x-7z-compressed
  application/x-tar
  application/json
  application/xml
  text/html
  text/plain
  text/xml
  image/jpeg
  image/png
  image/gif
  image/webp
  image/bmp
  image/svg+xml
  image/tiff
  image/avif
  video/mp4
  video/webm
  video/x-matroska
  video/x-msvideo
  video/quicktime
  video/mpeg
  audio/mpeg
  audio/ogg
  audio/wav
  audio/flac
  audio/mp4
  audio/webm)

for MIME in "${MIMES[@]}"; do
  xdg-mime default "$APP" "$MIME"
  log "$MIME is now associated to $APP"
done

echo ""
log "Set defaults to: $APP"
