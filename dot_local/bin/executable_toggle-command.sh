#!/bin/bash

command="$1"
pid=$(pgrep -af "$command")

if [[ -z $(pgrep -af "$command") ]]; then
  echo "PID is: $pid"
  "$@" &
else
  echo "PID is: $pid"
  killall "$command"
fi
