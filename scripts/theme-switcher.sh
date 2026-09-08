#!/usr/bin/env bash
set -e
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_FILE="$HOME/.cache/current-theme"
THEMES=("🔥 Catppuccin Black & Orange" "🟣 Catppuccin Mocha" "☀️ Catppuccin Latte (Modo Claro)" "🌃 Tokyo Night" "❄️ Nord (Artico)" "🦠 Dracula" "🪵 Gruvbox Dark")

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
        THEME_NAME="Catppuccin Black & Orange"; KITTY_THEME="catppuccin-black-orange"; GTK_DARK=1; ACCENT_COLOR="250,179,135" ;;
    *"Catppuccin Mocha"*)
        THEME_NAME="Catppuccin Mocha"; KITTY_THEME="catppuccin-mocha"; GTK_DARK=1; ACCENT_COLOR="137,180,250" ;;
    *"Catppuccin Latte"*)
        THEME_NAME="Catppuccin Latte"; KITTY_THEME="catppuccin-latte"; GTK_DARK=0; ACCENT_COLOR="30,102,245" ;;
    *)
        THEME_NAME="Catppuccin Black & Orange"; KITTY_THEME="catppuccin-black-orange"; GTK_DARK=1; ACCENT_COLOR="250,179,135" ;;
esac

echo "🎨 Aplicando tema: $THEME_NAME..."

# Kitty: usa el archivo que realmente existe en el repositorio.
if [ -f "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" ]; then
    mkdir -p "$HOME/.config/kitty"
    cp "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" "$HOME/.config/kitty/current-theme.conf"
    kitty @ set-colors --all "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" 2>/dev/null || true
fi

# KDE: usa colores disponibles; no intenta aplicar IDs inexistentes de Catppuccin.
if command -v plasma-apply-colorscheme &>/dev/null; then
    plasma-apply-colorscheme BreezeDark 2>/dev/null || true
fi

# KDE: persiste el acento sin depender de Kvantum.
if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file "$HOME/.config/kdeglobals" --group General --key AccentColor "$ACCENT_COLOR" 2>/dev/null || true
    kwriteconfig6 --file "$HOME/.config/kdeglobals" --group General --key ColorScheme BreezeDark 2>/dev/null || true
fi

if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
fi
if [ -f "$HOME/.config/gtk-4.0/settings.ini" ]; then
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || true
fi

systemctl --user restart plasma-plasmashell.service 2>/dev/null || true
mkdir -p "$(dirname "$CACHE_FILE")"
printf '%s\n' "$THEME_NAME" > "$CACHE_FILE"
notify-send -a "Theme Switcher" -i preferences-desktop-theme "Tema Visual Cambiado" "Esquema activo: $THEME_NAME" 2>/dev/null || true
echo "✅ ¡Tema $THEME_NAME aplicado con éxito!"
