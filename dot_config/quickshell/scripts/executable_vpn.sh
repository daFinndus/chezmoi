#!/bin/bash

# This script will fetch all running VPNs
fetch_vpn() {
  local -a connections=()
  declare -A seen

  add_connection() {
    local key=$1
    local json=$2

    # If it's in the seen array, skip it
    [[ -z ${seen[$key]} ]] || return

    # Otherwise add it to connections and seen
    seen[$key]=1
    connections+=("$json")
  }

  # OpenVPN — process-centric
  while read -r cfg; do
    local network
    network=$(basename "$cfg" .ovpn)

    # Necessary so the log file has the right permissions
    sleep 1

    local address=$(cat /tmp/"$network".ovpn.log | grep net_addr_v4_add | awk '{print $4}')

    add_connection "openvpn:$network" "{\"provider\": \"openvpn\", \"title\": \"OpenVPN\", \"network\": \"$network\", \"address\": \"$address\"}"
  done < <(ps -eo args | awk '/openvpn/ && !/awk/ {print $NF}' | sort -u)

  # Tailscale
  while read -r iface; do
    add_connection "tailscale:$iface" '{"provider": "tailscale", "title": "Tailscale", "network": "up"}'
  done < <(ip link show type tun 2>/dev/null | awk '/^[0-9]+:/ && /UP/ {gsub(/:/,"",$2); print $2}' | grep '^tailscale')

  if [[ ${#connections[@]} -gt 0 ]]; then
    local arr
    arr=$(printf '%s,' "${connections[@]}")

    printf '{"active": true, "connections": [%s]}\n' "${arr%,}"
  else
    printf '{"active": false, "connections": []}\n'
  fi
}

fetch_vpn
