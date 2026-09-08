#!/usr/bin/env bash
# ==============================================================================
# Pipe's Dotfiles - Unified System & Package Updater
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/utils.sh
source "${SCRIPT_DIR}/lib/utils.sh"

log_step "Actualizando el sistema y dependencias"

# 1. Gestores de paquetes del sistema
if has_cmd pacman; then
    log_info "Actualizando paquetes vía pacman..."
    sudo pacman -Syu --noconfirm || log_warn "Fallo al actualizar paquetes con pacman"
    if has_cmd yay; then
        log_info "Actualizando paquetes AUR vía yay..."
        yay -Sua --noconfirm || log_warn "Fallo al actualizar con yay"
    fi
elif has_cmd apt-get; then
    log_info "Actualizando paquetes vía apt..."
    sudo apt-get update && sudo apt-get upgrade -y || log_warn "Fallo al actualizar con apt"
elif has_cmd dnf; then
    log_info "Actualizando paquetes vía dnf..."
    sudo dnf upgrade -y || log_warn "Fallo al actualizar con dnf"
fi

# 2. Flatpak si está disponible
if has_cmd flatpak; then
    log_info "Actualizando aplicaciones Flatpak..."
    flatpak update -y || log_warn "Fallo al actualizar flatpak"
fi

# 3. Zsh / Oh My Zsh
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    log_info "Actualizando Oh My Zsh..."
    env ZSH="${HOME}/.oh-my-zsh" sh "${HOME}/.oh-my-zsh/tools/upgrade.sh" || log_warn "Fallo al actualizar Oh My Zsh"
fi

# 4. Actualizar repositorio de dotfiles si está en git
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
if [[ -d "${DOTFILES_DIR}/.git" ]]; then
    log_info "Sincronizando cambios de Git en Dotfiles..."
    git -C "${DOTFILES_DIR}" pull --ff-only || log_warn "No se pudo hacer pull rápido en ${DOTFILES_DIR}"
fi

log_info "Actualización completada."
