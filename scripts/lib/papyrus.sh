#!/bin/bash

install_papyrus() {
    log "Installing Papyrus..."
    local src_dir="${HOME}/.local/src/papyrus"
    mkdir -p "${HOME}/.local/src"

    if command -v papyrus >/dev/null 2>&1; then
        log "Papyrus is already installed"
        return 0
    fi

    if [[ ! -d "$src_dir/.git" ]]; then
        git clone https://github.com/PSGtatitos/papyrus.git "$src_dir"
    else
        git -C "$src_dir" pull --ff-only
    fi

    if [[ -x "$src_dir/install.sh" ]]; then
        bash "$src_dir/install.sh"
    elif [[ -f "$src_dir/Makefile" ]]; then
        make -C "$src_dir"
        sudo make -C "$src_dir" install
    elif [[ -f "$src_dir/Cargo.toml" ]]; then
        cargo install --path "$src_dir"
    else
        log_error "No supported Papyrus installer was found"
        return 1
    fi
}
