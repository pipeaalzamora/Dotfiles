#!/bin/bash
# =============================================================================
# Starship - Prompt minimalista, rápido e infinitamente personalizable
# https://starship.rs/
# =============================================================================

install_starship() {
    log "Instalando Starship..."
    
    # Verificar si ya está instalado
    if command -v starship &> /dev/null; then
        log "Starship ya está instalado"
        return 0
    fi
    
    # Método 1: Usando el instalador oficial (recomendado)
    if command -v curl &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh
        if [ $? -eq 0 ]; then
            log "Starship instalado correctamente"
            return 0
        fi
    fi
    
    # Método 2: Usando Homebrew (macOS/Linux)
    if command -v brew &> /dev/null; then
        brew install starship
        if [ $? -eq 0 ]; then
            log "Starship instalado correctamente con Homebrew"
            return 0
        fi
    fi
    
    # Método 3: Usando Cargo (si Rust está disponible)
    if command -v cargo &> /dev/null; then
        cargo install starship
        if [ $? -eq 0 ]; then
            log "Starship instalado correctamente con Cargo"
            return 0
        fi
    fi
    
    log_error "No se pudo instalar Starship. Intenta manualmente: curl -sS https://starship.rs/install.sh | sh"
    return 1
}
