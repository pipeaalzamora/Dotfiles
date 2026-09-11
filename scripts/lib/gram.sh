#!/bin/bash

install_gram() {
    log "Installing Gram..."
    local src_dir="${HOME}/.local/src/gram"
    mkdir -p "${HOME}/.local/src"

    if command -v gram >/dev/null 2>&1; then
        log "Gram is already installed"
        return 0
    fi

    if [[ ! -d "$src_dir/.git" ]]; then
        git clone https://codeberg.org/GramEditor/gram.git "$src_dir"
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
        log_error "No supported Gram installer was found"
        return 1
    fi
}
