#!/bin/bash

log() {
  echo "[AUDIO] $1"
}

# This will toggle between my two sinks
# Old function, will be deprecated soon
toggle_device() {
  local devices=($(pactl list sinks | grep -i "node.name" | grep -v "HDMI" | awk '{print $3}' | tr -d '"'))
  local current=$(pactl get-default-sink)

  if [[ ${#devices[@]} -gt 2 ]]; then
    log "Aborting script, too many devices registered."
  fi

  for device in "${devices[@]}"; do
    if [[ $device == "$current" ]]; then
      log "Skipping "$device", it's currently default..."
      continue
    else
      log "Setting $device as default sink!"
      pactl set-default-sink $device
    fi
  done
}

case "$1" in
toggle) toggle_device ;;
esac
