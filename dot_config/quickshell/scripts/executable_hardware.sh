#!/bin/bash

HOSTNAME=$(hostname)

# This will fetch CPU load and temperature
# It will also fetch load per CPU core
fetch_cpu() {
    local delay=0.2

    # Read both total and per-core in one go
    local s1=$(grep "^cpu" /proc/stat)
    sleep $delay
    local s2=$(grep "^cpu" /proc/stat)

    # Total usage in percent
    local s1_total=$(echo "$s1" | awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8}')
    local s2_total=$(echo "$s2" | awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8}')

    local cpu_usage=$(awk -v a="$s1_total" -v b="$s2_total" 'BEGIN {
        split(a,x); split(b,y)
        idle=(y[4]-x[4]); total=0
        for(i=1;i<=7;i++) total+=(y[i]-x[i])
        print int((1 - idle/total) * 100)
    }')

    # Per-core — filter numbered cpu lines
    local s1_cores=$(echo "$s1" | grep "^cpu[0-9]")
    local s2_cores=$(echo "$s2" | grep "^cpu[0-9]")

    local temp=0
    if [[ "$HOSTNAME" == "bartmoss" ]]; then
        temp=$(sensors 2>/dev/null | awk '/Tctl/ {gsub(/[+°C]/,"",$2); print int($2); exit}')
    elif [[ "$HOSTNAME" == "kabuki" ]]; then
        temp=$(sensors 2>/dev/null | awk '/Package id 0/ {gsub(/[+°C]/,"",$4); print int($4); exit}')
    fi

    local nuclei=$(nproc)
    local cores="["
    for i in $(seq 0 $((nuclei - 1))); do
        local line1=$(echo "$s1_cores" | awk -v c="cpu$i" '$1==c {print}')
        local line2=$(echo "$s2_cores" | awk -v c="cpu$i" '$1==c {print}')

        local core_usage=$(awk -v a="$line1" -v b="$line2" 'BEGIN {
            split(a,x); split(b,y)
            idle=(y[5]-x[5]); total=0
            for(i=2;i<=8;i++) total+=(y[i]-x[i])
            print int((1 - idle/total) * 100)
        }')

        cores+="{\"core\":$i,\"usage\":${core_usage:-0}}"
        [[ $i -lt $((nuclei - 1)) ]] && cores+=","
    done
    cores+="]"

    # Get the CPU load
    local load=$(uptime | awk -F: '{print $NF}')

    printf '{"usage":%s, "temp":%s, "load":"%s", "cores":%s}\n' "${cpu_usage:-0}" "${temp:-0}" "${load:-0}" "${cores:-0}"
}

# This will fetch used RAM
fetch_ram() {
    local stats=$(free --mega | awk '/Mem:/ {print $2, $3}')
    local total=$(echo $stats | cut -d ' ' -f1)
    local used=$(echo $stats | cut -d ' ' -f2)
    local load=$(awk "BEGIN {printf \"%.0f\", ($used/$total)*100}")

    printf '{"total":%s, "used":%s, "load":%s}\n' "${total:-0}" "${used:-0}" "${load:-0}"
}

# This will fetch swap space
# If available
fetch_swap() {
    local stats=$(free --mega | awk '/Swap:/ {print $2, $3}')

    if [[ -z "$stats" ]]; then
        local total=$(echo $stats | cut -d ' ' -f1)
        local used=$(echo $stats | cut -d ' ' -f2)
        local load=$(awk "BEGIN {printf \"%.0f\", ($used/$total)*100}")

        printf '{"total":%s, "used":%s, "load":%s}\n' "${total:-0}" "${used:-0}" "${load:-0}"
    fi
}

# This will display AMD GPU load and temperature
fetch_gpu() {
    if [[ "$HOSTNAME" == "bartmoss" ]]; then
        if [[ -f /sys/class/drm/card0/device/gpu_busy_percent ]]; then
            for hwmon in /sys/class/hwmon/hwmon*; do
                if [[ $(cat "$hwmon/name") == "amdgpu" ]]; then
                    local temp=$(cat "$hwmon/temp1_input" 2>/dev/null | head -1 | awk '{print int($1/1000)}')
                else
                    continue
                fi
            done

            local load=$(cat /sys/class/drm/card1/device/gpu_busy_percent)
            printf '{"load":%s, "temp":%s}\n' "${load:-0}" "${temp:-0}"
        else
            printf '{"load":0, "temp":0}\n'
        fi
    elif [[ "$HOSTNAME" == "kabuki" ]]; then
        local load=$(sudo intel_gpu_top -J -s 100 -n 2 -o - | grep busy | head -n 1 | awk '{print int($2)}')

        printf '{"load":%s}\n' "${load:-0}"
    fi
}

# This will fetch used disk space on root and home
fetch_disk() {
    local rootStats=$(df / -B MB)
    local rootTotal=$(echo "$rootStats" | awk 'NR==2 {printf $2}' | tr -d "MB")
    local rootUsed=$(echo "$rootStats" | awk 'NR==2 {printf $3}' | tr -d "MB")
    local rootLoad=$(echo "$rootStats" | awk 'NR==2 {printf $5}' | tr -d "%")

    local homeStats=$(df /home -B MB)
    local homeTotal=$(echo "$homeStats" | awk 'NR==2 {printf $2}' | tr -d "MB")
    local homeUsed=$(echo "$homeStats" | awk 'NR==2 {printf $3}' | tr -d "MB")
    local homeLoad=$(echo "$homeStats" | awk 'NR==2 {printf $5}' | tr -d "%")

    printf '{"rootTotal":%s, "rootUsed":%s, "rootLoad":%s, "homeTotal":%s, "homeUsed":%s, "homeLoad":%s}\n' "${rootTotal:-0}" "${rootUsed:-0}" "${rootLoad:-0}" "${homeTotal:-0}" "${homeUsed:-0}" "${homeLoad:-0}"
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
swap) fetch_swap ;;
gpu) fetch_gpu ;;
disk) fetch_disk ;;
net) fetch_net "$2" ;;
esac
