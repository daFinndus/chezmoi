#!/bin/bash

log() {
  echo "[NETWORK] $1"
}

# This will fetch networks from iwctl
scan_networks() {
  # Check if scan is in progress
  local scanning="$(iwctl station wlan0 show | grep Scanning | awk '{print $3}')"

  if [[ $scanning == "yes" ]]; then
    iwctl station wlan0 scan off
    sleep 5
  fi

  # Scan surrounding networks for 5 seconds
  iwctl station wlan0 scan on
  sleep 5
  iwctl device wlan0 set-property scanning off

  # Print fetched networks
  iwctl station wlan0 get-networks rssi-dbms | tail -n +5 | sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g'
}

parse_network() {
  local network="$1"

  local ssid="$(echo "$network" | awk '{print substr($0, 1, 29)}')"
  local security="$(echo "$network" | cut -c 30- | awk '{print $1}')"
  local strength="$(echo "$network" | cut -c 30- | awk '{print $2}')"

  jq -n \
    --arg ssid "${ssid#>}" \
    --arg security "$security" \
    --arg strength "$strength" \
    '{
        ssid: $ssid,
        security: $security,
        strength: $strength
    }'
}

# Get all available networks
fetch_wireless_networks() {
  scan_networks | while read -r network; do
    if [[ -n $network ]]; then
      parse_network "$network"
    fi
  done | jq -s "."
}

# Fetch network speed out of /proc/net/dev
fetch_network_speed() {
  local iface=$1

  [[ -z $iface ]] && printf '{"rx":"0","tx":"0"}\n' && return

  local rx1 tx1 rx2 tx2
  rx1=$(awk -v i="${iface}:" '$1==i {print $2}' /proc/net/dev)
  tx1=$(awk -v i="${iface}:" '$1==i {print $10}' /proc/net/dev)

  sleep 1

  rx2=$(awk -v i="${iface}:" '$1==i {print $2}' /proc/net/dev)
  tx2=$(awk -v i="${iface}:" '$1==i {print $10}' /proc/net/dev)

  printf '{"rx":"%s","tx":"%s"}\n' \
    "$(((rx2 - rx1) * 8))" \
    "$(((tx2 - tx1) * 8))"
}

# This will fetch bandwidth per process via nethogs
fetch_process_bandwidth() {
  local getcap=$(which nethogs | xargs -n1 getcap)

  if [[ -z $getcap ]]; then
    log "Cap not set for nethogs."
    notify-send "NETWORK" "Please set nethog caps by executing script manually."
    sudo setcap "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+pe" /usr/sbin/nethogs
  fi

  # Retrieve bandwidth in bits
  local nethogs=$(nethogs -t -d 1 -c 2 -v 2 | tail -n +7)

  echo "$nethogs" | while IFS= read -r line; do
    if [[ -n $line && $line != *"Refreshing"* && $line != *"Unknown connection"* ]]; then
      local pid=$(echo "$line" | awk -F '/' '{print $(NF-1)}')

      if [[ $pid -eq 0 ]]; then
        continue
      fi

      local process=$(cat /proc/$pid/comm)
      local sent=$(echo "$line" | awk '{print $(NF-1)}')
      local received=$(echo "$line" | awk '{print $NF}')

      if [[ -z $process || -z $sent || -z $received ]]; then
        continue
      fi

      jq -n \
        --argjson pid "$pid" \
        --arg process "$process" \
        --argjson sent "$sent" \
        --argjson received "$received" \
        '{
	    pid: $pid,
            process: $process,
            sent: $sent,
            received: $received,
         }'
    fi
  done | jq -s "."
}

case "$1" in
wifi) fetch_wireless_networks ;;
speed) fetch_network_speed "$2" ;;
processes) fetch_process_bandwidth ;;
esac
