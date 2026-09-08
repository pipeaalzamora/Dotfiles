#!/usr/bin/env bash
# Selector de temas de Kitty/KDE. El tema inicial es Black & Orange.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KITTY_CONFIG_DIR="$HOME/.config/kitty"
KITTY_CURRENT_THEME="$KITTY_CONFIG_DIR/current-theme.conf"
CACHE_FILE="$HOME/.cache/current-theme"

THEMES=(
    "🔥 Catppuccin Black & Orange"
    "🟣 Catppuccin Mocha"
    "☀️ Catppuccin Latte (Modo Claro)"
    "🌃 Tokyo Night"
    "❄️ Nord (Artico)"
    "🦠 Dracula"
    "🪵 Gruvbox Dark"
)

if [ -n "${1:-}" ]; then
    CHOICE="$*"
elif command -v rofi &>/dev/null && [ -n "${WAYLAND_DISPLAY:-$DISPLAY}" ]; then
    CHOICE=$(printf '%s\n' "${THEMES[@]}" | rofi -dmenu -i -p "Seleccionar Tema Visual" -theme "$DOTFILES_DIR/.config/rofi/config.rasi" 2>/dev/null || true)
else
    echo "Temas disponibles:"
    select choice in "${THEMES[@]}"; do CHOICE="$choice"; break; done
fi

[ -z "${CHOICE:-}" ] && exit 0

case "$CHOICE" in
    *"Black & Orange"*|*orange*|*naranjo*)
        THEME_NAME="Catppuccin Black & Orange"
        KITTY_THEME="catppuccin-black-orange"
        ACCENT_COLOR="250,179,135"
        GTK_DARK=1
        ;;
    *"Catppuccin Mocha"*|mocha)
        THEME_NAME="Catppuccin Mocha"
        KITTY_THEME="catppuccin-mocha"
        ACCENT_COLOR="137,180,250"
        GTK_DARK=1
        ;;
    *"Catppuccin Latte"*|latte|light)
        THEME_NAME="Catppuccin Latte"
        KITTY_THEME="catppuccin-latte"
        ACCENT_COLOR="30,102,245"
        GTK_DARK=0
        ;;
    *)
        printf 'Tema no reconocido: %s\n' "$CHOICE" >&2
        printf 'Usa: theme-switch, theme-switch orange, theme-switch mocha o theme-switch latte\n' >&2
        exit 2
        ;;
esac

THEME_FILE="$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf"
if [ ! -f "$THEME_FILE" ]; then
    printf 'No existe el archivo de tema: %s\n' "$THEME_FILE" >&2
    exit 1
fi

printf '🎨 Aplicando tema: %s...\n' "$THEME_NAME"
mkdir -p "$KITTY_CONFIG_DIR" "$(dirname "$CACHE_FILE")"
cp "$THEME_FILE" "$KITTY_CURRENT_THEME"

# Actualiza sesiones de Kitty abiertas; una sesión nueva siempre lee current-theme.conf.
if command -v kitty &>/dev/null; then
    kitty @ set-colors --all "$THEME_FILE" 2>/dev/null || true
fi

# KDE conserva BreezeDark para estructura y recibe el acento del tema.
if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme BreezeDark 2>/dev/null || true
fi
if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file "$HOME/.config/kdeglobals" --group General --key AccentColor "$ACCENT_COLOR" 2>/dev/null || true
fi

if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
fi
if [ -f "$HOME/.config/gtk-4.0/settings.ini" ]; then
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || true
fi

printf '%s\n' "$THEME_NAME" > "$CACHE_FILE"
notify-send -a "Theme Switcher" -i preferences-desktop-theme "Tema Visual Cambiado" "Esquema activo: $THEME_NAME" 2>/dev/null || true
printf '✅ Kitty actualizado: %s\n' "$THEME_NAME"
