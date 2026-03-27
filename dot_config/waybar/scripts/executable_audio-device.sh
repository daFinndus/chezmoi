DEVICES=($(pactl list sinks | grep -i "node.name" | grep -v "HDMI" | awk '{print $3}' | tr -d '"'))
CURRENT=$(pactl get-default-sink)

log() {
  echo "[AUDIO] $1"
}

if [[ "${#DEVICES[@]}" -gt 2 ]]; then
  log "Aborting script, too many devices registered."
fi

for device in "${DEVICES[@]}"; do
  if [[ "$device" == "$CURRENT" ]]; then
    log "Skipping "$device", it's currently default..."
    continue
  else
    log "Setting $device as default sink!"
    pactl set-default-sink $device
  fi
done
