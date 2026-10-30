#!/bin/bash

HOSTNAME=$(hostname)

# This will fetch CPU load and temperature
# It will also fetch load per CPU core
fetch_cpu() {
  local delay=0.2

  # Read both total and per-core in one go
  local s1=$(grep '^cpu[0-9 ]' /proc/stat)
  sleep $delay
  local s2=$(grep '^cpu[0-9 ]' /proc/stat)

  # Total usage in percent
  local s1_total=$(echo "$s1" | awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8}')
  local s2_total=$(echo "$s2" | awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8}')

  local cpu_usage=$(awk -v a="$s1_total" -v b="$s2_total" 'BEGIN {
        split(a,x); split(b,y)
        idle=(y[4]-x[4]); total=0
        for(i=1;i<=7;i++) total+=(y[i]-x[i])
        if (total > 0) print int((1 - idle/total) * 100)
        else print 0
    }')

  # Per-core — filter numbered cpu lines
  local temp=0
  if [[ $HOSTNAME == "bartmoss" ]]; then
    temp=$(sensors 2>/dev/null | awk '/Tccd1/ {gsub(/[+°C]/,"",$2); print int($2); exit}')
  elif [[ $HOSTNAME == "kabuki" ]]; then
    temp=$(sensors 2>/dev/null | awk '/Package id 0/ {gsub(/[+°C]/,"",$4); print int($4); exit}')
  fi

  local nuclei=$(nproc)
  local cores="["
  for i in $(seq 0 $((nuclei - 1))); do
    local line1=$(awk -v c="cpu$i" '$1==c {print}' <<<"$s1")
    local line2=$(awk -v c="cpu$i" '$1==c {print}' <<<"$s2")

    local core_usage=$(awk -v a="$line1" -v b="$line2" 'BEGIN {
            split(a,x); split(b,y)
            idle=(y[5]-x[5]); total=0
            for(i=2;i<=8;i++) total+=(y[i]-x[i])
            if (total > 0) print int((1 - idle/total) * 100)
            else print 0
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
  local total used
  read -r total used < <(free -b | awk '/Mem:/ {print $2, $3}')
  local load=0
  ((total > 0)) && load=$(awk "BEGIN {printf \"%.0f\", ($used/$total)*100}")

  printf '{"total":%s, "used":%s, "load":%s}\n' "${total:-0}" "${used:-0}" "${load:-0}"
}

# This will fetch swap space
# If available
fetch_swap() {
  local total used
  read -r total used < <(free -b | awk '/Swap:/ {print $2, $3}')

  if [[ -n $total ]]; then
    local load=0
    ((total > 0)) && load=$(awk "BEGIN {printf \"%.0f\", ($used/$total)*100}")

    printf '{"total":%s, "used":%s, "load":%s}\n' "${total:-0}" "${used:-0}" "${load:-0}"
  fi
}

# This will display AMD GPU load and temperature
fetch_gpu() {
  if [[ $HOSTNAME == "bartmoss" ]]; then
    if [[ -f /sys/class/drm/card0/device/gpu_busy_percent ]]; then
      for hwmon in /sys/class/hwmon/hwmon*; do
        if [[ $(cat "$hwmon/name") == "amdgpu" ]]; then
          local temp=$(awk '{print int($1/1000)}' "$hwmon/temp1_input" 2>/dev/null)
        else
          continue
        fi
      done

      local load=$(cat /sys/class/drm/card1/device/gpu_busy_percent)
      printf '{"load":%s, "temp":%s}\n' "${load:-0}" "${temp:-0}"
    else
      printf '{"load":0, "temp":0}\n'
    fi
  elif [[ $HOSTNAME == "kabuki" ]]; then
    local load=$(sudo intel_gpu_top -J -s 100 -n 2 -o - | grep busy | head -n 1 | awk '{print int($2)}')

    printf '{"load":%s}\n' "${load:-0}"
  fi
}

# This will fetch used disk space on root and home
fetch_disk() {
  local rootTotal rootUsed rootLoad homeTotal homeUsed homeLoad
  read -r rootTotal rootUsed rootLoad < <(df -P -B 1 / | awk 'NR==2 {gsub(/%/,"",$5); print $2,$3,$5}')
  read -r homeTotal homeUsed homeLoad < <(df -P -B 1 /home | awk 'NR==2 {gsub(/%/,"",$5); print $2,$3,$5}')

  printf '{"rootTotal":%s, "rootUsed":%s, "rootLoad":%s, "homeTotal":%s, "homeUsed":%s, "homeLoad":%s}\n' "${rootTotal:-0}" "${rootUsed:-0}" "${rootLoad:-0}" "${homeTotal:-0}" "${homeUsed:-0}" "${homeLoad:-0}"
}

fetch_all() {
  local cpu ram swap gpu disk
  cpu=$(fetch_cpu)
  ram=$(fetch_ram)
  swap=$(fetch_swap)
  gpu=$(fetch_gpu)
  disk=$(fetch_disk)

  swap=${swap:-'{"total":0,"used":0}'}
  gpu=${gpu:-'{"load":0,"temp":0}'}

  jq -n \
    --argjson cpu "$cpu" \
    --argjson ram "$ram" \
    --argjson swap "$swap" \
    --argjson gpu "$gpu" \
    --argjson disk "$disk" \
    '{cpu: $cpu, ram: $ram, swap: $swap, gpu: $gpu, disk: $disk}'
}

case "$1" in
all) fetch_all ;;
cpu) fetch_cpu ;;
ram) fetch_ram ;;
swap) fetch_swap ;;
gpu) fetch_gpu ;;
disk) fetch_disk ;;
esac
