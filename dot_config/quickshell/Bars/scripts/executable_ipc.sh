#!/bin/bash

FIFO="${XDG_RUNTIME_DIR}/qs-ipc"

[[ -p "$FIFO" ]] || mkfifo "$FIFO"

while true; do
    read -r cmd <"$FIFO"
    echo "$cmd"
done
