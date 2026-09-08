#!/usr/bin/env bash
# ============================================================
# Selector Dinamico Multi-Tema para KDE Plasma 6 y Terminal
# Repositorio: pipeaalzamora/Dotfiles
# Atajo: Meta+Shift+T (o comando 'theme-switch')
# ============================================================

set -e

# Sanitizar locale si el configurado genera advertencias en el sistema
if [[ -n "${LC_ALL:-}" ]] && ! locale -a 2>/dev/null | tr -d '._-' | grep -qi "$(echo "${LC_ALL}" | tr -d '._-')"; then
    export LC_ALL="C.UTF-8"
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_FILE="$HOME/.cache/current-theme"

# Opciones de Temas disponibles
THEMES=(
    "🔥 Catppuccin Black & Orange"
    "🟣 Catppuccin Mocha"
    "☀️ Catppuccin Latte (Modo Claro)"
    "🌃 Tokyo Night"
    "❄️ Nord (Artico)"
    "🦠 Dracula"
    "🪵 Gruvbox Dark"
)

# Si se paso un argumento por linea de comandos, usarlo directamente
if [ -n "${1:-}" ]; then
    CHOICE="$1"
elif command -v rofi &>/dev/null && [ -n "${WAYLAND_DISPLAY:-$DISPLAY}" ]; then
    CHOICE=$(printf '%s\n' "${THEMES[@]}" | rofi -dmenu -i -p "Seleccionar Tema Visual" -theme "$DOTFILES_DIR/.config/rofi/config.rasi" 2>/dev/null || true)
else
    echo "Temas disponibles:"
    select choice in "${THEMES[@]}"; do
        CHOICE="$choice"
        break
    done
fi

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    *"Black & Orange"*|*"black-orange"*|*"orange"*|*"naranjo"*)
        THEME_NAME="Catppuccin Black & Orange"
        KITTY_THEME="catppuccin-black-orange"
        KDE_SCHEMES=("CatppuccinMochaDark" "BreezeDark")
        KVANTUM_THEMES=("Catppuccin-Mocha-Dark" "CatppuccinMochaDark")
        CURSOR_THEME="Catppuccin-Mocha-Dark"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ACCENT_COLOR="250,179,135" # Catppuccin Peach / Orange
        ;;
    *"Catppuccin Mocha"*)
        THEME_NAME="Catppuccin Mocha"
        KITTY_THEME="catppuccin-mocha"
        KDE_SCHEMES=("CatppuccinMochaDark" "CatppuccinMocha" "BreezeDark")
        KVANTUM_THEMES=("Catppuccin-Mocha-Dark" "CatppuccinMochaDark")
        CURSOR_THEME="Catppuccin-Mocha-Dark"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ACCENT_COLOR="137,180,250" # Blue
        ;;
    *"Catppuccin Latte"*)
        THEME_NAME="Catppuccin Latte"
        KITTY_THEME="catppuccin-latte"
        KDE_SCHEMES=("CatppuccinLatteLight" "CatppuccinLatte" "BreezeLight")
        KVANTUM_THEMES=("Catppuccin-Latte-Light" "CatppuccinLatteLight")
        CURSOR_THEME="Catppuccin-Latte-Light"
        ICON_THEME="Papirus-Light"
        GTK_DARK="0"
        ACCENT_COLOR="30,102,245"
        ;;
    *"Tokyo Night"*)
        THEME_NAME="Tokyo Night"
        KITTY_THEME="tokyo-night"
        KDE_SCHEMES=("TokyoNight" "TokyoNightDark" "BreezeDark")
        KVANTUM_THEMES=("TokyoNight" "Catppuccin-Mocha-Dark")
        CURSOR_THEME="Bibata-Modern-Ice"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ACCENT_COLOR="122,162,247"
        ;;
    *"Nord"*)
        THEME_NAME="Nord"
        KITTY_THEME="nord"
        KDE_SCHEMES=("Nordic" "NordicDarker" "BreezeDark")
        KVANTUM_THEMES=("Nordic" "NordicDarker")
        CURSOR_THEME="Bibata-Modern-Classic"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ACCENT_COLOR="136,192,208"
        ;;
    *"Dracula"*)
        THEME_NAME="Dracula"
        KITTY_THEME="dracula"
        KDE_SCHEMES=("Dracula" "DraculaPlasma" "BreezeDark")
        KVANTUM_THEMES=("Dracula" "DraculaPlasma")
        CURSOR_THEME="Bibata-Modern-Dark"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ACCENT_COLOR="189,147,249"
        ;;
    *"Gruvbox Dark"*)
        THEME_NAME="Gruvbox Dark"
        KITTY_THEME="gruvbox-dark"
        KDE_SCHEMES=("Gruvbox" "GruvboxDark" "BreezeDark")
        KVANTUM_THEMES=("Gruvbox" "KvGruvbox")
        CURSOR_THEME="Capitaine-cursors"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ACCENT_COLOR="254,128,25"
        ;;
    *)
        THEME_NAME="Catppuccin Black & Orange"
        KITTY_THEME="catppuccin-black-orange"
        KDE_SCHEMES=("CatppuccinMochaDark" "BreezeDark")
        KVANTUM_THEMES=("Catppuccin-Mocha-Dark" "BreezeDark")
        CURSOR_THEME="Catppuccin-Mocha-Dark"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ACCENT_COLOR="250,179,135"
        ;;
esac

echo "🎨 Aplicando tema: $THEME_NAME..."

# 1. Aplicar paleta en Terminal Kitty (actualiza current-theme.conf)
if [ -f "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" ]; then
    mkdir -p "$HOME/.config/kitty"
    cp "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" "$HOME/.config/kitty/current-theme.conf" 2>/dev/null || true
    kitty @ set-colors --all "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" 2>/dev/null || true
fi

# 2. Aplicar esquema de colores en KDE Plasma 6
if command -v plasma-apply-colorscheme &>/dev/null; then
    for scheme in "${KDE_SCHEMES[@]}"; do
        if plasma-apply-colorscheme "$scheme" 2>/dev/null; then
            break
        fi
    done
fi

# 3. Aplicar color de acento si esta soportado en KDE
if [ -n "${ACCENT_COLOR:-}" ] && [ -f "$HOME/.config/kdeglobals" ]; then
    kwriteconfig6 --file "$HOME/.config/kdeglobals" --group "General" --key "AccentColor" "$ACCENT_COLOR" 2>/dev/null || true
fi

# 4. Aplicar motor Kvantum
if command -v kvantummanager &>/dev/null; then
    for kv_theme in "${KVANTUM_THEMES[@]}"; do
        if kvantummanager --set "$kv_theme" 2>/dev/null; then
            break
        fi
    done
fi

# 5. Aplicar cursores e iconos
if command -v plasma-apply-cursortheme &>/dev/null; then
    plasma-apply-cursortheme "$CURSOR_THEME" 2>/dev/null || true
fi

# 6. Modo GTK
if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
fi
if [ -f "$HOME/.config/gtk-4.0/settings.ini" ]; then
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || true
fi

# 7. Reiniciar plasmashell
systemctl --user restart plasma-plasmashell.service 2>/dev/null || true

# 8. Persistir tema activo
mkdir -p "$(dirname "$CACHE_FILE")"
echo "$THEME_NAME" > "$CACHE_FILE"

# 9. Notificacion
notify-send -a "Theme Switcher" -i preferences-desktop-theme "Tema Visual Cambiado" "Esquema activo: $THEME_NAME" 2>/dev/null || true

echo "✅ ¡Tema $THEME_NAME aplicado con exito!"
