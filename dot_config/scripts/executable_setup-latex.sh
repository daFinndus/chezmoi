#!/usr/bin/env bash

set -euo pipefail

log() {
  echo "[LATEX] $1"
}

error() {
  echo "[LATEX] ERROR: $1"
  exit 1
}

install_pkg() {
  log "Installing $1"
  sudo pacman -S --needed $1

  if [[ -n $(pacman -Qq "$1") ]]; then
    log "Successfully installed $1"
  else
    error "Failed installing $1"
  fi
}

check_ngerman() {
  log "Checking if german is installed.."

  if [[ -n $(kpsewhich ngerman.ldf) ]]; then
    log "Successfully installed ngerman."
  else
    error "Failed to install ngerman. Please intervene."
  fi
}

packages=(
  "texlive-basic"
  "texlive-bibtexextra"
  "texlive-bin"
  "texlive-binextra"
  "texlive-fontsextra"
  "texlive-fontsrecommended"
  "texlive-langgerman"
  "texlive-langspanish"
  "texlive-latex"
  "texlive-latexextra"
  "texlive-latexrecommended"
  "texlive-mathscience"
  "texlive-metapost"
  "texlive-pictures"
  "texlive-xetex"
)

main() {
  log "Welcome, this script is gonna install LaTeX for you!"
  log "This is used for LaTeX Workshop in VSCode and Arch Linux."

  for package in "${packages[@]}"; do
    install_pkg "$package"
  done

  check_ngerman

  log "Succesfully setup LaTeX!"
}

main
