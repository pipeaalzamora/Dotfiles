#!/usr/bin/env bash
# ============================================================
# Configuración KDE Plasma 6: Black & Orange, Dolphin y Ark
# Repositorio: pipeaalzamora/Dotfiles
# ============================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config"
ACCENT_COLOR="250,179,135" # Catppuccin Peach / Orange

ask_yes_no() {
    local answer
    read -r -p "$1 [S/n]: " answer
    [[ -z "$answer" || "$answer" =~ ^[SsYy]$ ]]
}

printf '🎨 Aplicando apariencia KDE Black & Orange...\n'
mkdir -p "$CONFIG_DIR"

# KDE no tiene instalado un esquema Catppuccin; BreezeDark sirve de base estable.
if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme BreezeDark 2>/dev/null || true
fi

# Aplicar el acento Peach directamente en kdeglobals.
if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file "$CONFIG_DIR/kdeglobals" --group General --key ColorScheme BreezeDark
    kwriteconfig6 --file "$CONFIG_DIR/kdeglobals" --group General --key AccentColor "$ACCENT_COLOR"
    kwriteconfig6 --file "$CONFIG_DIR/kdeglobals" --group Icons --key Theme Papirus-Dark
fi

# Dolphin hereda BreezeDark + AccentColor; esto aplica preferencias de navegación/previews.
if [ -f "$DOTFILES_DIR/.config/dolphinrc" ]; then
    cp "$DOTFILES_DIR/.config/dolphinrc" "$CONFIG_DIR/dolphinrc"
    printf '✅ Preferencias de Dolphin aplicadas.\n'
fi

if ask_yes_no "¿Instalar Ark y soporte para ZIP, RAR, 7z y tar en Dolphin?"; then
    bash "$DOTFILES_DIR/scripts/install-archives.sh"
fi

# Recargar apps para que lean los nuevos valores.
kquitapp6 dolphin 2>/dev/null || true
systemctl --user restart plasma-plasmashell.service 2>/dev/null || true
printf '✅ KDE/Dolphin configurados con fondo oscuro y acento naranjo.\n'
