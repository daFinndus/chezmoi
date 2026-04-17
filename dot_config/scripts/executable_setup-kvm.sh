#!/bin/bash

# This script is used to setup KVM and Virt-Manager on Arch Linux.

set -euo pipefail

RED="\033[38;2;220;50;50m"
YELLOW="\033[38;2;220;180;0m"
GREEN="\033[38;2;50;200;50m"
BLUE="\033[38;2;50;120;220m"
CYAN="\033[38;2;0;180;180m"
RESET="\033[0m"

DEPS=()

log_step() { echo -e "\n${BLUE}[*]${RESET} $1"; }
log_success() { echo -e "${GREEN}[+]${RESET} $1"; }
log_warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
log_error() { echo -e "${RED}[-]${RESET} $1"; }

check_root() {
  # Check if user is root
  if [[ "$EUID" -ne 0 ]]; then
    log_error "This script must be run as root."
    exit 1
  fi

  # Check who executed sudo
  if [[ -z "$SUDO_USER" ]]; then
    log_error "Please run with sudo, not as root directly. (Need \$SUDO_USER to drop privileges.)"
    exit 1
  fi
}

check_reflector() {
  REFLECTOR=$(command -v reflector)

  log_step "Checking if reflector is installed for mirror updating."

  if [[ -n "$REFLECTOR" ]]; then
    log_success "Reflector is installed! Proceeding...\n"
  else
    log_warn "Reflector is not installed. Installing...\n"

    sudo pacman -S reflector
  fi

  log_step "Updating mirrorlist now..."

  sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

  log_success "Successfully updated mirrorlist to use fastest mirrors!"
}

check_kvm_module() {
  LOADED=$(lsmod | grep kvm)

  if [[ -z "$LOADED" ]]; then
    log_success "KVM Kernel Module is loaded, nice!"
  else
    log_warn "KVM kernel module isn't loaded, loading now..."

    VENDOR=$(lscpu | grep "Vendor ID" | awk '{print $3}')

    log_step "Checking up on your CPU type."

    if [[ "$VENDOR" == *"Intel"* ]]; then
      log_success "Your CPU is by Intel."
    else
      log_success "Your CPU is by AMD."
    fi

    # sudo modprobe kvm
  fi
}

main() {
  check_kvm_module
}

main
