#!/bin/bash

log() {
  echo "[AUDIO] $1"
}

# This will toggle between my two sinks
# Old function, will be deprecated soon
toggle_device() {
  # Get all output devices
  local -a devices
  mapfile -t devices < <(pactl list sinks | awk -F'"' '/node.name/ && $2 !~ /HDMI/ {print $2}')

  local current=$(pactl get-default-sink)

  if [[ ${#devices[@]} -gt 2 ]]; then
    log "Aborting script, too many devices registered."
    return 1
  fi

  for device in "${devices[@]}"; do
    if [[ $device == "$current" ]]; then
      log "Skipping $device, it's currently default..."
      continue
    else
      log "Setting $device as default sink!"
      pactl set-default-sink "$device"
      return
    fi
  done
}

case "$1" in
toggle) toggle_device ;;
esac
