#!/usr/bin/env bash
# ============================================================
# Cambiador de Fondo de Pantalla (Estático o Video) — KDE Plasma 6
# Repositorio: pipeaalzamora/Dotfiles
# Atajo: Meta+Alt+W (o comando 'wall-next')
# ============================================================

set -e

WALLPAPERS_DIR="${WALLPAPERS_DIR:-$HOME/Imágenes/Wallpapers/Catppuccin}"

# Si la carpeta no existe o está vacía, descargar automáticamente
if [ ! -d "$WALLPAPERS_DIR" ] || [ -z "$(find "$WALLPAPERS_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.webp" -o -iname "*.mp4" \) 2>/dev/null)" ]; then
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    if [ -f "$DOTFILES_DIR/scripts/download-wallpapers.sh" ]; then
        bash "$DOTFILES_DIR/scripts/download-wallpapers.sh"
    fi
fi

# Obtener lista de todos los fondos (imágenes y videos)
mapfile -t WALLS < <(find "$WALLPAPERS_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.mp4" -o -iname "*.webm" \) 2>/dev/null)

if [ ${#WALLS[@]} -eq 0 ]; then
    notify-send "Fondo de Pantalla" "No se encontraron fondos en $WALLPAPERS_DIR" 2>/dev/null || true
    exit 1
fi

# Seleccionar un fondo aleatorio
SELECTED_WALL="${WALLS[RANDOM % ${#WALLS[@]}]}"
FILENAME=$(basename "$SELECTED_WALL")
EXTENSION="${FILENAME##*.}"

echo "🎨 Aplicando fondo: $FILENAME"

case "${EXTENSION,,}" in
    mp4|webm|mkv)
        # Fondo de Video
        if command -v mpvpaper &>/dev/null; then
            # Matar instancias previas de mpvpaper
            killall mpvpaper 2>/dev/null || true
            # Obtener nombre del monitor activo o usar '*'
            MONITOR=$(wlr-randr 2>/dev/null | grep -o "^[A-Za-z0-9-]*" | head -n 1 || echo "*")
            mpvpaper -vs -o "no-audio --loop" "$MONITOR" "$SELECTED_WALL" &
            notify-send -a "Wallpaper" "Fondo Animado Activo" "Reproduciendo: $FILENAME" 2>/dev/null || true
        else
            notify-send -a "Wallpaper" "Video detectado" "Instala mpvpaper (sudo pacman -S mpvpaper) para reproducir fondos animados." 2>/dev/null || true
        fi
        ;;
    png|jpg|jpeg|webp)
        # Si había un video corriendo con mpvpaper, detenerlo
        killall mpvpaper 2>/dev/null || true

        # 1. Método nativo de KDE Plasma 6
        if command -v plasma-apply-wallpaperimage &>/dev/null; then
            plasma-apply-wallpaperimage "$SELECTED_WALL" >/dev/null 2>&1 || true
        fi

        # 2. Script de evaluación D-Bus en Plasma como respaldo confiable
        if command -v qdbus &>/dev/null; then
            qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
                var allDesktops = desktops();
                for (i=0;i<allDesktops.length;i++) {
                    d = allDesktops[i];
                    d.wallpaperPlugin = 'org.kde.image';
                    d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
                    d.writeConfig('Image', 'file://${SELECTED_WALL}');
                }
            " >/dev/null 2>&1 || true
        fi

        notify-send -a "Wallpaper" -i "$SELECTED_WALL" "Fondo de Pantalla" "Cambiado a: $FILENAME" 2>/dev/null || true
        ;;
esac
