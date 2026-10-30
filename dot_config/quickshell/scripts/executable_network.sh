#!/bin/bash

log() {
  echo "[NETWORK] $1"
}

# Get all available networks
fetch_wireless_networks() {
  # Get active and known ssid
  declare -g active=$(nmcli --get-values 802-11-wireless.ssid connection show --active $(nmcli --fields NAME,TYPE connection show | awk '$2 == "wifi" {print $1}'))
  mapfile -t remember < <(get_known_networks)

  scan_networks | while read -r network; do
    if [[ -n $network ]]; then
      parse_network "$network"
    fi
  done | jq -s "."
}

# This will fetch networks from nmcli
scan_networks() {
  # Check if scan is in progress
  local networks="$(nmcli --wait 15 --get-values IN-USE,SSID,SIGNAL,SECURITY,BAND device wifi list)"

  # Print fetched networks
  if [[ -z "$networks" ]]; then
    scan_networks
  else
    # Grepping discards the top line
    echo "$networks"
  fi
}

parse_network() {
  local network="$1"

  # Grep ssid, security and strength out of the iwctl line
  local ssid strength security

  [[ -n $(echo "$network" | cut -d ':' -f 1) ]] && active=true || active=false
  ssid=$(echo "$network" | cut -d ':' -f 2)
  strength=$(echo "$network" | cut -d ':' -f 3)
  security=$(echo "$network" | cut -d ':' -f 4)
  band=$(echo "$network" | cut -d ':' -f 5)
  known=false

  for wifi in "${remember[@]}"; do
    if [[ "$ssid" == "$wifi" ]]; then
      known=true
      break
    fi
  done

  if [[ $ssid =~ ^[[:alnum:]] ]]; then
    jq -n \
      --arg ssid "$ssid" \
      --arg security "$security" \
      --arg strength "$strength" \
      --arg band "$band" \
      --argjson active "$active" \
      --argjson known "$known" \
      '{
        ssid: $ssid,
        security: $security,
        strength: $strength,
        band: $band,
        active: $active,
        known: $known
       }'
  fi
}

get_known_networks() {
  local uuid type ssid

  while IFS=: read -r uuid type; do
    [[ "$type" == "802-11-wireless" ]] || continue

    network=$(nmcli --get-values 802-11-wireless.ssid,connection.timestamp connection show uuid "$uuid")

    [[ $(echo "$network" | tail -n 1) == 0 ]] && continue
    [[ -n $(echo "$network" | head -n 1) ]] && printf '%s\n' "$(echo "$network" | head -n 1)"
  done < <(nmcli --get-values UUID,TYPE connection show)
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

  [[ $rx1 =~ ^[0-9]+$ && $tx1 =~ ^[0-9]+$ && $rx2 =~ ^[0-9]+$ && $tx2 =~ ^[0-9]+$ ]] ||
    {
      printf '{"rx":"0","tx":"0"}\n'
      return
    }

  printf '{"rx":"%s","tx":"%s"}\n' \
    "$(((rx2 - rx1) * 8))" \
    "$(((tx2 - tx1) * 8))"
}

get_interfaces() {
  local interfaces=$(nmcli --get-values TYPE,DEVICE,STATE device status)

  echo "$interfaces" | while read -r interface; do
    if [[ -n "$interface" ]]; then
      type=$(echo "$interface" | cut -d ":" -f 1)
      device=$(echo "$interface" | cut -d ":" -f 2)
      [[ $(echo "$interface" | cut -d ":" -f 3) == "connected"* ]] && active=true || active=false

      information=$(nmcli --get-values IP4.ADDRESS,IP4.GATEWAY,IP4.DNS device show $device)

      address=$(echo "$information" | head -n 1)
      gateway=$(echo "$information" | sed -n 2p)
      dns=$(echo "$information" | tail -n 1)

      jq -n \
        --arg type "$type" \
        --arg device "$device" \
        --argjson active "$active" \
        --arg address "$address" \
        --arg gateway "$gateway" \
        --arg dns "$dns" \
        '{
            type: $type,
            device: $device,
            active: $active,
            address: $address,
            gateway: $gateway,
            dns: $dns
        }'
    fi
  done | jq -s "."
}

case "$1" in
wifi) fetch_wireless_networks ;;
speed) fetch_network_speed "$2" ;;
interfaces) get_interfaces ;;
esac
