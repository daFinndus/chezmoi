#!/bin/bash

# ==============================================================================
# Metasploit Framework Setup Script for Arch Linux
# ==============================================================================

RED="\033[38;2;220;50;50m"
YELLOW="\033[38;2;220;180;0m"
GREEN="\033[38;2;50;200;50m"
BLUE="\033[38;2;50;120;220m"
CYAN="\033[38;2;0;180;180m"
RESET="\033[0m"

DEPS=(metasploit ruby postgresql)

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

is_installed() {
  pacman -Q "$1" &>/dev/null
}

install_deps() {
  log_step "Checking dependencies..."

  local to_install=()

  for dep in "${DEPS[@]}"; do
    if is_installed "$dep"; then
      log_success "$dep is already installed."
    else
      log_warn "$dep is not installed. Queuing for installation..."

      to_install+=("$dep")
    fi
  done

  if [[ "${#to_install[@]}" -gt 0 ]]; then
    log_step "Installing: ${to_install[*]}"
    pacman -S --noconfirm "${to_install[@]}" &>/dev/null || {
      log_error "Failed to install dependencies."
      exit 1
    }

    log_success "Dependencies installed."
  else
    log_success "All dependencies already satisfied."
  fi
}

setup_ruby() {
  log_step "Setting up Ruby gems..."

  if [[ -f ~/.rvm/scripts/rvm ]]; then
    source ~/.rvm/scripts/rvm
  fi

  if [[ -d /opt/metasploit ]]; then
    cd /opt/metasploit || exit 1
    sudo -u "$SUDO_USER" gem install bundler &>/dev/null
    sudo -u "$SUDO_USER" bundle install &>/dev/null || {
      log_warn "bundle install encountered issues, continuing..."
    }

    log_success "Ruby gems configured."
  else
    log_warn "/opt/metasploit not found, skipping bundle install."
  fi
}

setup_postgres() {
  log_step "Setting up PostgreSQL..."

  # Init cluster if not already done
  if [[ ! -f /var/lib/postgres/data/PG_VERSION ]]; then
    log_step "Initializing database cluster..."
    sudo -u postgres initdb -D /var/lib/postgres/data &>/dev/null || {
      log_error "Failed to initialize PostgreSQL cluster."
      exit 1
    }

    log_success "Database cluster initialized."
  else
    log_success "Database cluster already initialized."
  fi

  # Enable and start PostgreSQL
  if ! systemctl is-active --quiet postgresql; then
    log_step "Starting PostgreSQL service..."
    systemctl enable --now postgresql &>/dev/null || {
      log_error "Failed to start PostgreSQL."
      exit 1
    }

    log_success "PostgreSQL started."
  else
    log_success "PostgreSQL is already running."
  fi
}

init_msfdb() {
  log_step "Initializing Metasploit database..."

  if sudo -u "$SUDO_USER" msfdb status 2>/dev/null | grep -q "connected"; then
    log_success "Metasploit database already initialized and connected."
    return
  fi

  sudo -u "$SUDO_USER" msfdb init --connection-string=postgresql://postgres@localhost:5432/postgres &>/dev/null || {
    log_error "Failed to initialize msfdb."
    exit 1
  }

  log_success "Metasploit database initialized."
}

launch_msf() {
  log_step "Checking database status and launching msfconsole..."
  echo ""
  sudo -u "$SUDO_USER" msfconsole -x "db_status"
}

main() {
  echo -e "${RED}"
  cat <<'EOF'
  __  __ ____  _____   ____       _
 |  \/  / ___||  ___| / ___|  ___| |_ _   _ _ __
 | |\/| \___ \| |_    \___ \ / _ \ __| | | | '_ \
 | |  | |___) |  _|    ___) |  __/ |_| |_| | |_) |
 |_|  |_|____/|_|     |____/ \___|\__|\__,_| .__/
                                            |_|
EOF
  echo -e "${RESET}"
  echo -e "${CYAN}Arch Linux Metasploit Setup${RESET}"
  echo -e "${CYAN}============================${RESET}\n"

  check_root
  install_deps
  setup_ruby
  setup_postgres
  init_msfdb
  launch_msf
}

main
