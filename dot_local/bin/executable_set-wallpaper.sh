#!/usr/bin/env bash

WALLPAPER_FILE="$HOME/.config/quickshell/assets/states/wallpaper"

change() {
  echo "[WALLPAPER] Executing script at $(date)"
  WALLPAPER_PATH="$1"

  if [ -z "$WALLPAPER_PATH" ]; then
    if [ -f "$WALLPAPER_FILE" ]; then
      WALLPAPER_PATH=$(cat "$WALLPAPER_FILE")
      echo "[WALLPAPER] Loading wallpaper from $WALLPAPER_FILE"
    else
      echo "[WALLPAPER] No wallpaper specified and no saved found" >&2
      return 1
    fi
  fi

  if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "[WALLPAPER] File does not exist: $WALLPAPER_PATH" >&2
    return 1
  fi

  echo "[WALLPAPER] Applying wallpaper: $WALLPAPER_PATH"
  echo "[WALLPAPER] Updating wallpaper..."
  awww img $WALLPAPER_PATH --transition-type grow --transition-duration 0.5 --transition-fps 60

  echo "[PYWAL] Applying pywal colorscheme..."
  wal -i "$WALLPAPER_PATH"

  local theme=$(cat $HOME/.config/quickshell/assets/states/theme)
  echo "[QUICKSHELL] Making sure theme is re-applied..."
  qs ipc call theme applyTheme $theme

  echo "$WALLPAPER_PATH" >"$WALLPAPER_FILE"
  echo "[WALLPAPER] Saved to $WALLPAPER_FILE"

  echo "[DUNST] Restarting dunst, killing and disowning..."
  pkill dunst
  dunst &
  disown
}

change "$1"
