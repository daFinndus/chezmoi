#!/bin/bash

HARDWARE=$1

fetch_cpu() {
    echo "CPU!"
}

fetch_ram() {
    echo "RAM!"
}

fetch_gpu() {
    echo "GPU!"
}

case "$1" in
cpu)
    fetch_cpu
    ;;
ram)
    fetch_ram
    ;;
gpu)
    fetch_gpu
    ;;
esac
