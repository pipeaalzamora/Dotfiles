#!/usr/bin/env bash
# ============================================================
# Selector Dinámico Multi-Tema para KDE Plasma 6 y Terminal
# Repositorio: pipeaalzamora/Dotfiles
# Atajo: Meta+Shift+T (o comando 'theme-switch')
#
# NOTA DE DISEÑO: kitty.conf siempre incluye el archivo fijo
# 'themes/catppuccin-mocha.conf' (ver .config/kitty/kitty.conf).
# Este script SOBRESCRIBE el contenido de ese archivo con la
# paleta del tema elegido en cada cambio, en vez de editar la
# directiva 'include' de kitty.conf. Esto evita tener que
# reiniciar Kitty y permite aplicar el cambio en caliente via
# 'kitty @ set-colors'. El nombre del archivo no representa el
# tema activo real; usa 'cat ~/.cache/current-theme' para saber
# cuál está aplicado.
# ============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_FILE="$HOME/.cache/current-theme"

# Opciones de Temas disponibles
THEMES=(
    "🟣 Catppuccin Mocha"
    "☀️ Catppuccin Latte (Modo Claro)"
    "🌃 Tokyo Night"
    "❄️ Nord (Ártico)"
    "🦠 Dracula"
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

# Cada tema define listas de candidatos (separados por espacio) para
# KDE_SCHEMES y KVANTUM_THEMES: se prueban en orden hasta que uno
# funcione, ya que el nombre exacto del esquema depende del paquete
# AUR instalado y puede variar entre versiones.
case "$CHOICE" in
    *"Catppuccin Mocha"*)
        THEME_NAME="Catppuccin Mocha"
        KITTY_THEME="catppuccin-mocha"
        KDE_SCHEMES=("CatppuccinMochaDark" "CatppuccinMocha" "BreezeDark")
        KVANTUM_THEMES=("Catppuccin-Mocha-Dark" "CatppuccinMochaDark")
        CURSOR_THEME="Catppuccin-Mocha-Dark"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *"Catppuccin Latte"*)
        THEME_NAME="Catppuccin Latte"
        KITTY_THEME="catppuccin-latte"
        KDE_SCHEMES=("CatppuccinLatteLight" "CatppuccinLatte" "BreezeLight")
        KVANTUM_THEMES=("Catppuccin-Latte-Light" "CatppuccinLatteLight")
        CURSOR_THEME="Catppuccin-Latte-Light"
        ICON_THEME="Papirus-Light"
        GTK_DARK="0"
        ;;
    *"Tokyo Night"*)
        THEME_NAME="Tokyo Night"
        KITTY_THEME="tokyo-night"
        # tokyonight-gtk-theme-git es un tema GTK; no siempre trae un
        # esquema de color nativo de Plasma con este ID exacto.
        KDE_SCHEMES=("TokyoNight" "TokyoNightDark" "BreezeDark")
        KVANTUM_THEMES=("TokyoNight" "Catppuccin-Mocha-Dark")
        CURSOR_THEME="Bibata-Modern-Ice"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *"Nord"*)
        THEME_NAME="Nord"
        KITTY_THEME="nord"
        KDE_SCHEMES=("Nordic" "NordicDarker" "BreezeDark")
        KVANTUM_THEMES=("Nordic" "NordicDarker")
        CURSOR_THEME="Bibata-Modern-Classic"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *"Dracula"*)
        THEME_NAME="Dracula"
        KITTY_THEME="dracula"
        KDE_SCHEMES=("Dracula" "DraculaPlasma" "BreezeDark")
        KVANTUM_THEMES=("Dracula" "DraculaPlasma")
        CURSOR_THEME="Bibata-Modern-Dark"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *"Gruvbox Dark"*)
        THEME_NAME="Gruvbox Dark"
        KITTY_THEME="gruvbox-dark"
        KDE_SCHEMES=("Gruvbox" "GruvboxDark" "BreezeDark")
        KVANTUM_THEMES=("Gruvbox" "KvGruvbox")
        CURSOR_THEME="Capitaine-cursors"
        ICON_THEME="Papirus-Dark"
        GTK_DARK="1"
        ;;
    *)
        exit 0
        ;;
esac

echo "🎨 Aplicando tema: $THEME_NAME..."

# 1. Aplicar paleta en Terminal Kitty (sobrescribe el archivo fijo
#    que kitty.conf incluye siempre: themes/catppuccin-mocha.conf)
if [ -f "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" ]; then
    mkdir -p "$HOME/.config/kitty/themes"
    cp "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" "$HOME/.config/kitty/themes/catppuccin-mocha.conf" 2>/dev/null || true
    kitty @ set-colors --all "$DOTFILES_DIR/.config/kitty/themes/$KITTY_THEME.conf" 2>/dev/null || true
fi

# 2. Aplicar esquema de colores en KDE Plasma 6 (probando candidatos en orden)
if command -v plasma-apply-colorscheme &>/dev/null; then
    for scheme in "${KDE_SCHEMES[@]}"; do
        if plasma-apply-colorscheme "$scheme" 2>/dev/null; then
            break
        fi
    done
fi

# 3. Aplicar motor Kvantum (probando candidatos en orden)
if command -v kvantummanager &>/dev/null; then
    for kv_theme in "${KVANTUM_THEMES[@]}"; do
        if kvantummanager --set "$kv_theme" 2>/dev/null; then
            break
        fi
    done
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

# 7. Persistir el tema activo para referencia de otros scripts (barras de estado, etc.)
mkdir -p "$(dirname "$CACHE_FILE")"
echo "$THEME_NAME" > "$CACHE_FILE"

# 8. Notificación en pantalla
notify-send -a "Theme Switcher" -i preferences-desktop-theme "Tema Visual Cambiado" "Esquema activo: $THEME_NAME" 2>/dev/null || true

echo "✅ ¡Tema $THEME_NAME aplicado con éxito!"
