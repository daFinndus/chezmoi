#!/usr/bin/env bash

log() {
  echo "[WALLPAPER] $1"
}

change() {
  log "Executing script at $(date)"
  WALLPAPER_PATH="$1"

  if [ ! -f "$WALLPAPER_PATH" ]; then
    log "File does not exist: $WALLPAPER_PATH" >&2
    return 1
  fi

  log "Applying wallpaper: $WALLPAPER_PATH"
  log "Updating wallpaper..."
  awww img $WALLPAPER_PATH --resize crop --transition-type grow --transition-duration 0.5 --transition-fps 60

  echo "[PYWAL] Applying pywal colorscheme..."
  wal -i "$WALLPAPER_PATH"

  echo "[DUNST] Restarting dunst, killing and disowning..."
  pkill dunst
  dunst &
  disown
}

change "$1"
