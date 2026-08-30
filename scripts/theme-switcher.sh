#!/usr/bin/env bash
# ============================================================
# Selector Dinámico Multi-Tema para KDE Plasma 6 y Terminal
# Repositorio: pipeaalzamora/Dotfiles
# Atajo: Meta+Shift+T (o comando 'theme-switch')
# ============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Opciones de Temas disponibles
THEMES=(
    "🟣 Catppuccin Mocha"
    "☀️ Catppuccin Latte (Modo Claro)"
    "🌃 Tokyo Night"
    "❄️ Nord (Ártico)"
    "🧛 Dracula"
    "🪵 Gruvbox Dark"
)

# Si se pasa como argumento o a través de Rofi
if [ -n "$1" ]; then
    CHOICE="$1"
else
    if command -v rofi &>/dev/null; then
        CHOICE=$(printf '%s\n' "${THEMES[@]}" | rofi -dmenu -i -p "🎨 Seleccionar Tema Visual" -theme "$HOME/.config/rofi/config.rasi")
    else
        echo "Selecciona un tema:"
        select opt in "${THEMES[@]}"; do
            CHOICE="$opt"
            break
        done
    fi
fi

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    *"Catppuccin Mocha"*)
        THEME_NAME="Catppuccin Mocha"
        KITTY_THEME="catppuccin-mocha"
        KDE_SCHEME="CatppuccinMochaDark"
        KVANTUM_THEME="Catppuccin-Mocha-Dark"
        CURSOR_THEME="Catppuccin-Mocha-Dark"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *"Catppuccin Latte"*)
        THEME_NAME="Catppuccin Latte"
        KITTY_THEME="catppuccin-latte"
        KDE_SCHEME="CatppuccinLatteLight"
        KVANTUM_THEME="Catppuccin-Latte-Light"
        CURSOR_THEME="Catppuccin-Latte-Light"
        ICON_THEME="Papirus-Light"
        GTK_DARK="0"
        ;;
    *"Tokyo Night"*)
        THEME_NAME="Tokyo Night"
        KITTY_THEME="tokyo-night"
        KDE_SCHEME="TokyoNightDark"
        KVANTUM_THEME="TokyoNight"
        CURSOR_THEME="Bibata-Modern-Ice"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *"Nord"*)
        THEME_NAME="Nord"
        KITTY_THEME="nord"
        KDE_SCHEME="Nordic"
        KVANTUM_THEME="Nordic"
        CURSOR_THEME="Bibata-Modern-Classic"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *"Dracula"*)
        THEME_NAME="Dracula"
        KITTY_THEME="dracula"
        KDE_SCHEME="Dracula"
        KVANTUM_THEME="Dracula"
        CURSOR_THEME="Bibata-Modern-Dark"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *"Gruvbox Dark"*)
        THEME_NAME="Gruvbox Dark"
        KITTY_THEME="gruvbox-dark"
        KDE_SCHEME="GruvboxDark"
        KVANTUM_THEME="Gruvbox"
        CURSOR_THEME="Capitaine-cursors"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *)
        exit 0
        ;;
esac

echo "🎨 Aplicando tema: $THEME_NAME..."

# 1. Aplicar paleta en Terminal Kitty
if [ -f "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" ]; then
    mkdir -p "$HOME/.config/kitty/themes"
    cp "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" "$HOME/.config/kitty/themes/catppuccin-mocha.conf" 2>/dev/null || true
    kitty @ set-colors --all "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" 2>/dev/null || true
fi

# 2. Aplicar esquema de colores en KDE Plasma 6
if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme "$KDE_SCHEME" 2>/dev/null || \
    plasma-apply-colorscheme "BreezeDark" 2>/dev/null || true
fi

# 3. Aplicar motor Kvantum
if command -v kvantummanager &>/dev/null; then
    kvantummanager --set "$KVANTUM_THEME" 2>/dev/null || \
    kvantummanager --set "Catppuccin-Mocha-Dark" 2>/dev/null || true
fi

# 4. Aplicar cursores e iconos
if command -v plasma-apply-cursortheme &>/dev/null; then
    plasma-apply-cursortheme "$CURSOR_THEME" 2>/dev/null || true
fi

if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file "$HOME/.config/kdeglobals" --group Icons --key Theme "$ICON_THEME" 2>/dev/null || true
fi

# 5. Aplicar modo claro/oscuro en GTK
if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
fi
if [ -f "$HOME/.config/gtk-4.0/settings.ini" ]; then
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || true
fi

# 6. Recargar KWin y Plasmashell
if command -v qdbus &>/dev/null; then
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
fi

systemctl --user restart plasma-plasmashell.service 2>/dev/null || true

# 7. Notificación en pantalla
notify-send -a "Theme Switcher" -i preferences-desktop-theme "Tema Visual Cambiado" "Esquema activo: $THEME_NAME" 2>/dev/null || true

echo "✅ ¡Tema $THEME_NAME aplicado con éxito!"
