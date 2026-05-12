#!/bin/bash

RED="\033[38;2;220;50;50m"
GREEN="\033[38;2;50;200;50m"
CYAN="\033[38;2;0;180;180m"
YELLOW="\033[38;2;220;180;0m"
BLUE="\033[38;2;50;120;220m"
RESET="\033[0m"

# Check if wireguard is active
is_wireguard_active() {
  ip link show kabuki &>/dev/null & ip link show kabuki | grep -q "UP"
}

# Check if openvpn is active
is_openvpn_active() {
  pgrep -x openvpn &>/dev/null
}

# If active, check which VPN is used
get_openvpn_vpn() {
  local cmdline
  cmdline=$(ps -eo args | grep openvpn | grep -v grep)

  if echo "$cmdline" | grep -q "academy"; then
    echo "HTB Academy"
  elif echo "$cmdline" | grep -q "labs"; then
    echo "HTB Labs"
  else
    echo "OpenVPN"
  fi
}

# This will be used by waybar
status() {
  local active_vpns=()
  if is_wireguard_active; then
    active_vpns+=("Wireguard")
  fi

  if is_openvpn_active; then
    active_vpns+=("$(get_openvpn_vpn)")
  fi

  if [[ "${#active_vpns[@]}" -gt 0 ]]; then
    local tooltip
    tooltip=$(printf "%s\n" "${active_vpns[@]}")

    echo "{\"text\": \"VPN on\", \"tooltip\": \"$tooltip\", \"class\": \"active\"}"
  else
    echo "{\"text\": \"VPN off\", \"tooltip\": \"No VPN active\", \"class\": \"inactive\"}"
  fi
}

status