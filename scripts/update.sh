#!/usr/bin/env bash
# ==============================================================================
# Pipe's Dotfiles - Unified System & Package Updater
# ==============================================================================
set -euo pipefail

# Sanitizar locale si el configurado genera advertencias
if [[ -n "${LC_ALL:-}" ]] && ! locale -a 2>/dev/null | tr -d '._-' | grep -qi "$(echo "${LC_ALL}" | tr -d '._-')"; then
    export LC_ALL="C.UTF-8"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/utils.sh
source "${SCRIPT_DIR}/lib/utils.sh"

log_step "Actualizando sistema Ubuntu y dependencias"

# 1. APT (Paquetes del sistema Ubuntu)
if has_cmd apt-get; then
    log_info "Actualizando paquetes vía APT..."
    sudo apt-get update && sudo apt-get upgrade -y || log_warn "Fallo al actualizar con APT"
    sudo apt-get autoremove -y 2>/dev/null || true
    sudo apt-get autoclean 2>/dev/null || true
fi

# 2. Snap y Flatpak
if has_cmd snap; then
    log_info "Actualizando aplicaciones Snap..."
    sudo snap refresh || log_warn "Fallo al actualizar Snap"
fi

if has_cmd flatpak; then
    log_info "Actualizando aplicaciones Flatpak..."
    flatpak update -y || log_warn "Fallo al actualizar Flatpak"
fi

# 3. Gestores de paquetes de desarrollo (Fullstack / AI / DevOps)
if has_cmd npm; then
    log_info "Actualizando paquetes globales de npm..."
    npm update -g 2>/dev/null || true
fi

if has_cmd rustup; then
    log_info "Actualizando toolchain de Rust..."
    rustup update 2>/dev/null || true
fi

if has_cmd pipx; then
    log_info "Actualizando herramientas pipx..."
    pipx upgrade-all 2>/dev/null || true
fi

if has_cmd uv; then
    log_info "Actualizando uv..."
    uv self update 2>/dev/null || true
fi

# 4. Zsh / Oh My Zsh (usar zsh, no sh, para evitar error de scope 'local')
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    log_info "Actualizando Oh My Zsh..."
    if has_cmd zsh; then
        env ZSH="${HOME}/.oh-my-zsh" zsh "${HOME}/.oh-my-zsh/tools/upgrade.sh" || log_warn "Fallo al actualizar Oh My Zsh"
    fi
fi

# 5. Actualizar repositorio de dotfiles si está en git
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
if [[ -d "${DOTFILES_DIR}/.git" ]]; then
    log_info "Sincronizando cambios de Git en Dotfiles..."
    git -C "${DOTFILES_DIR}" pull --ff-only || log_warn "No se pudo hacer pull rápido en ${DOTFILES_DIR}"
fi

log_info "Actualización completada."
