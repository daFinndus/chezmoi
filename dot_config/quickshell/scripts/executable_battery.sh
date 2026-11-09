#!/bin/bash

data=$(sudo tlp-stat -b)

fetch_information() {
  manufacturer=$(fetch_metadata "manufacturer")
  model=$(fetch_metadata "model")

  cycle_count=$(fetch_metadata "cycle_count")
  status=$(fetch_metadata "status")

  start_thresh=$(fetch_metadata "start_threshold" | tr -d '[%]')
  end_thresh=$(fetch_metadata "end_threshold" | tr -d '[%]')

  charge=$(fetch_metadata "Charge" | tr -d '[%]')
  capacity=$(fetch_metadata "Capacity" | tr -d '[%]')

  jq -n \
    --arg manufacturer "$manufacturer" \
    --arg model "$model" \
    --argjson cycle_count "$cycle_count" \
    --arg status "$status" \
    --argjson start_thresh "$start_thresh" \
    --argjson end_thresh "$end_thresh" \
    --argjson charge "$charge" \
    --argjson capacity "$capacity" \
    '[{
	  manufacturer: $manufacturer,
	  model: $model,
	  cycle_count: $cycle_count,
	  status: $status,
	  start_thresh: $start_thresh,
	  end_thresh: $end_thresh,
	  charge: $charge,
	  capacity: $capacity
    }]'
}

fetch_metadata() {
  metadata="$1"

  printf $(echo "$data" | grep "$1" | awk '{print $3}')
}

case "$1" in
all) fetch_information ;;
esac
