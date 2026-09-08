#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
case "${1:-help}" in
    orange|black-orange|naranjo) exec "$SCRIPT_DIR/theme-switcher.sh" "🔥 Catppuccin Black & Orange" ;;
    mocha) exec "$SCRIPT_DIR/theme-switcher.sh" "🟣 Catppuccin Mocha" ;;
    latte|light) exec "$SCRIPT_DIR/theme-switcher.sh" "☀️ Catppuccin Latte (Modo Claro)" ;;
    select|switch) exec "$SCRIPT_DIR/theme-switcher.sh" ;;
    *)
        echo "Uso: theme {orange|mocha|latte|select}"
        echo "Alias: theme orange / theme naranjo / theme-switch orange"
        ;;
esac
