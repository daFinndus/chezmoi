#!/bin/bash

HOSTNAME=$(hostname)

# This will fetch CPU load and temperature
fetch_cpu() {
    local delay=0.2

    # Two /proc/stat reads for accurate delta-based load
    local s1=$(awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8}' /proc/stat)

    sleep $delay

    local s2=$(awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8}' /proc/stat)

    local load=$(awk -v a="$s1" -v b="$s2" 'BEGIN {
        split(a,x); split(b,y)
        idle=(y[4]-x[4]); total=0
        for(i=1;i<=7;i++) total+=(y[i]-x[i])
        print int((1 - idle/total) * 100)
    }')

    local temp=0

    if [[ "$HOSTNAME" == "bartmoss" ]]; then
        local temp=$(sensors 2>/dev/null | grep "Tctl" | awk '{gsub(/[+°C]/,"",$2); print int($2); exit}')
    elif [[ "$HOSTNAME" == "kabuki" ]]; then
        local temp=$(sensors 2>/dev/null | grep "Package id 0" | awk '{gsub(/[+°C]/,"",$4); print int($4); exit}')
    fi

    printf '{"load":%s,"temp":%s}\n' "${load:-0}" "${temp:-0}"
}

# This will fetch used RAM
fetch_ram() {
    local stats=$(free | awk '/Mem:/ {print $2, $3}')
    local total=$(echo $stats | cut -d' ' -f1)
    local used=$(echo $stats | cut -d' ' -f2)
    local load=$(awk "BEGIN {printf \"%.0f\", ($used/$total)*100}")

    printf '{"load":%s}\n' "${load:-0}"
}

# This will display AMD GPU load and temperature
fetch_gpu() {
    if [[ "$HOSTNAME" == "bartmoss" ]]; then
        if [[ -f /sys/class/drm/card0/device/gpu_busy_percent ]]; then
            local load=$(cat /sys/class/drm/card1/device/gpu_busy_percent)
            local temp=$(cat /sys/class/hwmon/hwmon2/temp1_input 2>/dev/null | head -1 | awk '{print int($1/1000)}')
            printf '{"load":%s,"temp":%s}\n' "${load:-0}" "${temp:-0}"
        else
            printf '{"load":0,"temp":0}\n'
        fi
    elif [[ "$HOSTNAME" == "kabuki" ]]; then
        local load=$(sudo intel_gpu_top -J -s 100 -n 2 -o - | grep busy | head -n 1 | awk '{print int($2)}')

        printf '{"load":%s}\n' "${load:-0}"
    fi
}

# This will fetch used disk space on root and home
fetch_disk() {
    local root=$(df / | awk 'NR==2 {printf "%.0f", $3/$2*100}')
    local home=$(df /home | awk 'NR==2 {printf "%.0f", $3/$2*100}')

    printf '{"root":%s,"home":%s}\n' "${root:-0}" "${home:-0}"
}

fetch_net() {
    local iface=$1
    [[ -z "$iface" ]] && printf '{"rx":"0 B/s","tx":"0 B/s"}\n' && return

    local rx1 tx1 rx2 tx2
    rx1=$(awk -v i="${iface}:" '$1==i {print $2}' /proc/net/dev)
    tx1=$(awk -v i="${iface}:" '$1==i {print $10}' /proc/net/dev)

    sleep 1

    rx2=$(awk -v i="${iface}:" '$1==i {print $2}' /proc/net/dev)
    tx2=$(awk -v i="${iface}:" '$1==i {print $10}' /proc/net/dev)

    format_speed() {
        local b=$1
        if ((b >= 1048576)); then
            awk "BEGIN {printf \"%.1f MB/s\", $b/1048576}"
        elif ((b >= 1024)); then
            awk "BEGIN {printf \"%.0f KB/s\", $b/1024}"
        else
            echo "${b} B/s"
        fi
    }

    printf '{"rx":"%s","tx":"%s"}\n' \
        "$(format_speed $((rx2 - rx1)))" \
        "$(format_speed $((tx2 - tx1)))"
}

case "$1" in
cpu) fetch_cpu ;;
ram) fetch_ram ;;
gpu) fetch_gpu ;;
disk) fetch_disk ;;
net) fetch_net "$2" ;;
esac
