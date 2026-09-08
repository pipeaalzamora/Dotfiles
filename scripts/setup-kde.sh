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

same_file() {
    [ -e "$1" ] && [ -e "$2" ] && [ "$(readlink -f "$1")" = "$(readlink -f "$2")" ]
}

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

# Dolphin hereda Kvantum. Si dolphinrc ya es el symlink hacia Dotfiles, no copiar sobre sí mismo.
DOLPHIN_SOURCE="$DOTFILES_DIR/.config/dolphinrc"
DOLPHIN_TARGET="$CONFIG_DIR/dolphinrc"
if [ -f "$DOLPHIN_SOURCE" ]; then
    if same_file "$DOLPHIN_SOURCE" "$DOLPHIN_TARGET"; then
        printf '✅ Dolphin ya usa la configuración enlazada del repositorio.\n'
    else
        cp "$DOLPHIN_SOURCE" "$DOLPHIN_TARGET"
        printf '✅ Preferencias de Dolphin aplicadas.\n'
    fi
fi

# Recargar Dolphin y Plasma para leer tema, acento y preferencias nuevos.
kquitapp6 dolphin 2>/dev/null || true
systemctl --user restart plasma-plasmashell.service 2>/dev/null || true
printf '✅ Dolphin usa Kvantum %s con fondo Mocha oscuro y acento naranjo Peach.\n' "$KVANTUM_THEME"
printf '✅ Ark ya se instala desde install.sh: clic derecho en Dolphin → Extraer / Comprimir.\n'
