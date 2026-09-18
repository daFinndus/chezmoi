#!/bin/bash

log() {
  echo "[AUDIO] $1"
}

# Output all devices playing audio
get_sink_inputs() {
  pactl list sink-inputs
}

# Read all lines, grep sink input
split_sink_inputs() {
  local input=""

  while IFS= read -r line; do
    if [[ $line =~ ^Sink\ Input\ #[0-9]+$ ]]; then
      if [[ -n $input ]]; then
        printf '%s\n' "$input"
      fi

      input="$line"
    else
      input+="$line"
    fi
  done

  if [[ -n $input ]]; then
    printf '%s\n' "$input"
  fi
}

# Search for sink input name
# Get application name, id and volume
parse_sink_input() {
  local input="$1"

  local id="$(printf '%s\n' "$input" | grep -oP '^Sink Input #\K[0-9]+')"
  local name="$(printf '%s\n' "$input" | grep -oP 'application.name = "\K[^"]+')"
  local volume="$(printf '%s\n' "$input" | grep -oP 'Volume:.*?/\s*\K[0-9]+(?=%)')"

  jq -n \
    --argjson id "$id" \
    --arg name "$name" \
    --argjson volume "$volume" \
    '{
        id: $id,
        name: $name,
        volume: $volume
    }'
}

fetch_applications() {
  get_sink_inputs | split_sink_inputs | while IFS= read -r input; do
    parse_sink_input "$input"
  done | jq -s
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
applications) fetch_applications ;;
esac
