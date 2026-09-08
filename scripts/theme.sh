#!/usr/bin/env bash
# ==============================================================================
# Pipe's Dotfiles - Unified Theme & Wallpaper Manager
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/utils.sh
source "${SCRIPT_DIR}/lib/utils.sh"

show_help() {
    cat <<EOF
${COLOR_BOLD}Uso:${COLOR_RESET} $(basename "$0") <subcomando>

${COLOR_BOLD}Subcomandos:${COLOR_RESET}
  toggle       Alterna entre tema claro y tema oscuro
  dark         Aplica el tema oscuro a KDE, terminal y aplicaciones
  light        Aplica el tema claro a KDE, terminal y aplicaciones
  wallpaper    Cambia o descarga fondos de pantalla
  install      Instala temas, fuentes e iconos adicionales
EOF
}

cmd="${1:-help}"
shift || true

case "$cmd" in
    toggle)
        log_step "Alternando tema claro / oscuro"
        if [[ -f "${SCRIPT_DIR}/theme-switcher.sh" ]]; then
            "${SCRIPT_DIR}/theme-switcher.sh" toggle "$@"
        else
            log_warn "theme-switcher.sh no disponible directamente."
        fi
        ;;
    dark)
        log_step "Aplicando modo oscuro"
        if [[ -f "${SCRIPT_DIR}/theme-switcher.sh" ]]; then
            "${SCRIPT_DIR}/theme-switcher.sh" dark "$@"
        fi
        ;;
    light)
        log_step "Aplicando modo claro"
        if [[ -f "${SCRIPT_DIR}/theme-switcher.sh" ]]; then
            "${SCRIPT_DIR}/theme-switcher.sh" light "$@"
        fi
        ;;
    wallpaper)
        log_step "Gestionando fondos de pantalla"
        if [[ -f "${SCRIPT_DIR}/change-wallpaper.sh" ]]; then
            "${SCRIPT_DIR}/change-wallpaper.sh" "$@"
        elif [[ -f "${SCRIPT_DIR}/download-wallpapers.sh" ]]; then
            "${SCRIPT_DIR}/download-wallpapers.sh" "$@"
        fi
        ;;
    install)
        log_step "Instalando paquetes de temas e íconos"
        if [[ -f "${SCRIPT_DIR}/install-themes.sh" ]]; then
            "${SCRIPT_DIR}/install-themes.sh" "$@"
        fi
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_error "Opción no reconocida: '$cmd'"
        show_help
        exit 1
        ;;
esac
