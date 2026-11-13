#!/usr/bin/env bash

install_cava() {
    log "Instalando Cava en Ubuntu..."

    if command -v cava >/dev/null 2>&1; then
        log "Cava ya está instalado."
        return 0
    fi

    sudo apt-get update
    sudo apt-get install -y cava

    log "Cava instalado exitosamente."
}
