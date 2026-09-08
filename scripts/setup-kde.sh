#!/usr/bin/env bash
# ============================================================
# Configuración KDE Plasma 6: Catppuccin Mocha Yellow / Dolphin
# Repositorio: pipeaalzamora/Dotfiles
# ============================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config"
KVANTUM_THEME="catppuccin-mocha-yellow"
ACCENT_COLOR="250,179,135" # Catppuccin Peach / Orange

printf '🎨 Aplicando apariencia Catppuccin Mocha Yellow (negro y naranjo)...\n'
mkdir -p "$CONFIG_DIR" "$CONFIG_DIR/Kvantum"

# Plasma mantiene BreezeDark como esquema estructural, mientras Kvantum pinta Dolphin/Qt.
if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme BreezeDark 2>/dev/null || true
fi

# Selecciona el tema Kvantum que ya aparece instalado/activo en el sistema del usuario.
if command -v kvantummanager &>/dev/null; then
    kvantummanager --set "$KVANTUM_THEME" 2>/dev/null || true
fi

if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file "$CONFIG_DIR/kdeglobals" --group General --key ColorScheme BreezeDark
    kwriteconfig6 --file "$CONFIG_DIR/kdeglobals" --group General --key AccentColor "$ACCENT_COLOR"
    kwriteconfig6 --file "$CONFIG_DIR/kdeglobals" --group General --key widgetStyle kvantum
    kwriteconfig6 --file "$CONFIG_DIR/kdeglobals" --group Icons --key Theme Papirus-Dark
fi

# Dolphin hereda Kvantum. Estas preferencias solo definen navegación y previsualización.
if [ -f "$DOTFILES_DIR/.config/dolphinrc" ]; then
    cp "$DOTFILES_DIR/.config/dolphinrc" "$CONFIG_DIR/dolphinrc"
    printf '✅ Preferencias de Dolphin aplicadas.\n'
fi

# Recargar Dolphin y Plasma para leer tema, acento y preferencias nuevos.
kquitapp6 dolphin 2>/dev/null || true
systemctl --user restart plasma-plasmashell.service 2>/dev/null || true
printf '✅ Dolphin usa Kvantum %s con fondo Mocha oscuro y acento naranjo Peach.\n' "$KVANTUM_THEME"
printf '✅ Ark ya se instala desde install.sh: clic derecho en Dolphin → Extraer / Comprimir.\n'
