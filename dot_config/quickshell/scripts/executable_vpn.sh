#!/bin/bash

fetch_vpn() {
    local -a connections=()
    declare -A seen

    add_connection() {
        local key=$1
        local json=$2
        [[ -z "${seen[$key]}" ]] || return
        seen[$key]=1
        connections+=("$json")
    }

    # WireGuard — interface-centric
    while read -r iface; do
        add_connection "wg:$iface" \
            "{\"type\":\"WireGuard: $profile\"}"
    done < <(ip link show type wireguard 2>/dev/null |
        awk '/^[0-9]+:/ && /UP/ {gsub(/:/,"",$2); print $2}')

    # OpenVPN — process-centric
    while read -r cfg; do
        local profile
        profile=$(basename "$cfg" .ovpn)
        add_connection "ovpn:$profile" \
            "{\"type\":\"OpenVPN: $profile\"}"
    done < <(ps -eo args | awk '/openvpn/ && !/awk/ {print $NF}' | sort -u)

    # Tailscale
    while read -r iface; do
        add_connection "ts:$iface" \
            "{\"type\":\"Tailscale: up\"}"
    done < <(ip link show type tun 2>/dev/null |
        awk '/^[0-9]+:/ && /UP/ {gsub(/:/,"",$2); print $2}' |
        grep '^tailscale')

    if [[ ${#connections[@]} -gt 0 ]]; then
        local arr
        arr=$(printf '%s,' "${connections[@]}")
        printf '{"active":true,"connections":[%s]}\n' "${arr%,}"
    else
        printf '{"active":false,"connections":[]}\n'
    fi
}

fetch_vpn
