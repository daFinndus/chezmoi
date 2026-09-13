#!/usr/bin/env bash

APP="$1"

log() {
  echo "[MIMER] $1"
}

if [[ -z $APP ]]; then
  log "A default has to be specified."
  exit 1
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

log "Set defaults to: $APP"
