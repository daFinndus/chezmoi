#!/bin/bash

LOGDIR="/tmp"

log() {
  echo "[VPN-MANAGER] $1"
}

print_usage() {
  echo "Usage: $0 <tailscale|openvpn> <openvpn-config>"
  exit 1
}

connect_openvpn() {
  local config="$1"

  if [[ ! -f $config ]]; then
    log "Config file not found."
    exit 1
  fi

  local process=$(sudo pgrep -fax "[o]penvpn.*$config")

  if [[ -n $process ]]; then
    log "Process already exists, aborting."
    log "Process: $(echo $process | head -n1)"
    exit 1
  else
    log "Process doesn't exist yet, going on..."
  fi

  local log="$LOGDIR/$(basename "$config").log"

  if [[ -f $log ]]; then
    rm "$log"
  fi

  sudo openvpn --log "$log" --config "$config" 1>/dev/null &

  # Give openvpn a moment to create the log file before chowning
  sleep 1

  if [[ -f $log ]]; then
    sudo chown "$(whoami)":"$(whoami)" "$log"
  fi
}

connect_tailscale() {
  which tailscale 2>/dev/null

  if [[ $? -gt 0 ]]; then
    log "Tailscale command doesn't exist!"
  else
    sudo tailscale up
  fi
}

case "$1" in
tailscale) connect_tailscale ;;
openvpn) connect_openvpn "$2" ;;
*) print_usage ;;
esac
