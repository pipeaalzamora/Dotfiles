#!/bin/bash

install_cava() {
    log "Installing Cava..."

    if command -v cava >/dev/null 2>&1; then
        log "Cava is already installed"
        return 0
    fi

    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y cava
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y cava
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed --noconfirm cava
    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper --non-interactive install cava
    elif command -v brew >/dev/null 2>&1; then
        brew install cava
    else
        log_error "No supported package manager found for Cava"
        return 1
    fi

    log "Cava installed successfully"
}
