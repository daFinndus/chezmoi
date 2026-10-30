#!/bin/bash

OVPN_DIR="$HOME/Nextcloud/VPNs"

fetch_vpn() {
    local -a connections=()
    declare -A seen

    add_connection() {
        local key=$1
        local json=$2

        [[ -z ${seen[$key]} ]] || return

        seen[$key]=1
        connections+=("$json")
    }

    # OpenVPN — known configs from VPN directory (always shown, active or not)
    while read -r cfg; do
        local network
        network=$(basename "$cfg" .ovpn)

        local process
        process=$(ps -eo args | awk '/openvpn/ && !/awk/ {print $NF}' | grep -F "$cfg")

        local active="false"
        local address=""

        # Check if the process is running
        if [[ -n $process ]]; then
            active="true"
            local logfile="/tmp/${network}.ovpn.log"

            # Check if there's a logfile
            if [[ -f $logfile ]]; then
                address=$(grep "net_addr_v4_add" "$logfile" | awk '{print $4}' | tail -n1)
            fi
        fi

        add_connection "openvpn:$network" "{\"provider\": \"openvpn\", \"network\": \"$network\", \"address\": \"${address:-}\", \"active\": $active, \"config\": \"$cfg\"}"
    done < <(find "$OVPN_DIR" -name "*.ovpn" -type f | sort)

    # OpenVPN — running but not in known directory
    while read -r cfg; do
        local network
        network=$(basename "$cfg" .ovpn)

        # Skip if already added from known directory
        [[ -n ${seen["openvpn:$network"]} ]] && continue
        [[ $cfg == "$OVPN_DIR"* ]] && continue

        local address=""
        local logfile="/tmp/${network}.ovpn.log"
        if [[ -f $logfile ]]; then
            address=$(grep "net_addr_v4_add" "$logfile" | awk '{print $4}' | tail -n1)
        fi

        add_connection "openvpn:$network" "{\"provider\": \"openvpn\", \"title\": \"$network\", \"network\": \"$network\", \"address\": \"${address:-}\", \"active\": true, \"config\": \"$cfg\"}"
    done < <(ps -eo args | awk '/openvpn/ && !/awk/ {print $NF}' | sort -u)

    # Tailscale
    local tailscale_state
    tailscale_state=$(ip link show type tun 2>/dev/null | awk '/^[0-9]+:/ && /UP/ {gsub(/:/,"",$2); print $2}' | grep '^tailscale')

    local tailscale_active="false"
    [[ -n $tailscale_state ]] && tailscale_active="true"

    add_connection "tailscale" "{\"provider\": \"tailscale\", \"network\": \"tailscale\", \"address\": \"\", \"active\": $tailscale_active, \"config\": \"\"}"

    # EduVPN
    local eduvpn_state
    eduvpn_state=$(ip link show eduvpn 2>/dev/null | awk '/^[0-9]+:/ && /UNKNOWN/ {gsub(/:/,"",$2); print $2}')

    local eduvpn_active="false"
    [[ -n $eduvpn_state ]] && eduvpn_active="true"

    add_connection "eduvpn" "{\"provider\": \"eduvpn\", \"network\": \"eduvpn\", \"address\": \"\", \"active\": $eduvpn_active, \"config\": \"\"}"

    local arr
    arr=$(printf '%s,' "${connections[@]}")

    printf '[%s]\n' "${arr%,}"
}

connect_vpn() {
    local provider="$1"
    local config="$2"

    case "$provider" in
    openvpn)
        bash /home/finn/.local/bin/vpn-manager.sh openvpn "$config"
        ;;
    tailscale)
        bash /home/finn/.local/bin/vpn-manager.sh tailscale
        ;;
    eduvpn)
        sudo networkctl up eduvpn
        ;;
    esac
}

disconnect_vpn() {
    local provider="$1"
    local config="$2"

    case "$provider" in
    openvpn)
        local network
        network=$(basename "$config" .ovpn)
        local pid=$(ps -eo pid,args | awk '/openvpn/ && !/awk/ && /'"$network"'/ {print $1}' | head -n1)
        [[ -n $pid ]] && sudo kill "$pid"
        ;;
    tailscale)
        sudo tailscale down
        ;;
    eduvpn)
        sudo networkctl down eduvpn
        ;;
    esac
}

case "$1" in
fetch_vpn) fetch_vpn ;;
connect_vpn) connect_vpn "$2" "$3" ;;
disconnect_vpn) disconnect_vpn "$2" "$3" ;;
esac
