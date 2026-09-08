#!/usr/bin/env bash
# ==============================================================================
# Pipe's Dotfiles - Unified Theme & Wallpaper Manager
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
    cat <<EOF
Uso: $(basename "$0") <subcomando>

Subcomandos:
  orange       Aplica la paleta Negro Profundo con Naranjo (Catppuccin Peach)
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
    orange|black-orange|naranjo)
        echo "Aplicando paleta Negro con Naranjo (Catppuccin Black & Orange)"
        if [[ -f "${SCRIPT_DIR}/theme-switcher.sh" ]]; then
            "${SCRIPT_DIR}/theme-switcher.sh" "🔥 Catppuccin Black & Orange" "$@"
        fi
        ;;
    toggle)
        echo "Alternando tema claro / oscuro"
        if [[ -f "${SCRIPT_DIR}/theme-switcher.sh" ]]; then
            "${SCRIPT_DIR}/theme-switcher.sh" toggle "$@"
        fi
        ;;
    dark)
        echo "Aplicando modo oscuro"
        if [[ -f "${SCRIPT_DIR}/theme-switcher.sh" ]]; then
            "${SCRIPT_DIR}/theme-switcher.sh" dark "$@"
        fi
        ;;
    light)
        echo "Aplicando modo claro"
        if [[ -f "${SCRIPT_DIR}/theme-switcher.sh" ]]; then
            "${SCRIPT_DIR}/theme-switcher.sh" light "$@"
        fi
        ;;
    wallpaper)
        echo "Gestionando fondos de pantalla"
        if [[ -f "${SCRIPT_DIR}/change-wallpaper.sh" ]]; then
            "${SCRIPT_DIR}/change-wallpaper.sh" "$@"
        elif [[ -f "${SCRIPT_DIR}/download-wallpapers.sh" ]]; then
            "${SCRIPT_DIR}/download-wallpapers.sh" "$@"
        fi
        ;;
    install)
        echo "Instalando paquetes de temas e iconos"
        if [[ -f "${SCRIPT_DIR}/install-themes.sh" ]]; then
            "${SCRIPT_DIR}/install-themes.sh" "$@"
        fi
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Opcion no reconocida: '$cmd'"
        show_help
        exit 1
        ;;
esac
