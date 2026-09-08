#!/usr/bin/env bash
#
# theme-switcher.sh — Cambia tema de Plasma, esquema de colores, iconos, cursores, fondo y Kvantum
#
# Uso:
#   theme-switcher.sh [--theme <tema>] [--icon <icono>] [--cursor <cursor>] [--wallpaper <archivo>] [--kvantum <tema>] [--help]
#
# Si no se indica ningún tema, se listan los temas disponibles y se elige uno.

set -euo pipefail

# ============================================================
# Ayuda
# ============================================================
show_help() {
    cat <<EOF
Uso: $(basename "$0") [OPCIONES]

Opciones:
  --theme <tema>       Tema de Plasma (look-and-feel). Ej: KlassyDark, KvFlat, KvArcDark
  --icon <icono>       Tema de iconos. Ej: Tela-circle-dark, Papirus-Dark, breeze-dark
  --cursor <cursor>    Tema de cursores. Ej: catppuccin-mocha-dark-cursors, breeze_cursors
  --wallpaper <archivo>  Ruta al fondo de pantalla
  --kvantum <tema>     Tema Kvantum. Ej: KvFlat, KvArcDark
  --help               Muestra esta ayuda y sale

Ejemplos:
  $(basename "$0") --theme KvFlat --icon Papirus-Dark --cursor catppuccin-mocha-dark-cursors
  $(basename "$0") --kvantum KvArcDark
  $(basename "$0") --wallpaper ~/Imagenes/fondo.jpg
EOF
    exit 0
}

# ============================================================
# Parseo de argumentos
# ============================================================
THEME=""
ICON=""
CURSOR=""
WALLPAPER=""
KVANTUM=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --theme) THEME="$2"; shift 2 ;;
        --icon)  ICON="$2"; shift 2 ;;
        --cursor) CURSOR="$2"; shift 2 ;;
        --wallpaper) WALLPAPER="$2"; shift 2 ;;
        --kvantum) KVANTUM="$2"; shift 2 ;;
        --help) show_help ;;
        *) echo "Opcion desconocida: $1" >&2; exit 1 ;;
    esac
done

# ============================================================
# Utilidades
# ============================================================
log() { echo "[theme-switcher] $*"; }
warn() { echo "[theme-switcher] ADVERTENCIA: $*" >&2; }
die() { echo "[theme-switcher] ERROR: $*" >&2; exit 1; }

# Verifica si un tema de Plasma está disponible
plasma_theme_exists() {
    local t="$1"
    lookandfeeltool -l 2>/dev/null | grep -qxF "$t"
}

# Verifica si un tema de iconos está disponible
icon_theme_exists() {
    local t="$1"
    # Busca en las rutas estándar de iconos
    [[ -d "/usr/share/icons/$t" || -d "$HOME/.icons/$t" || -d "/usr/share/pixmaps/$t" ]]
}

# Verifica si un tema de cursores está disponible
cursor_theme_exists() {
    local t="$1"
    [[ -d "/usr/share/icons/$t" || -d "$HOME/.icons/$t" ]]
}

# Verifica si un tema Kvantum está disponible
kvantum_theme_exists() {
    local t="$1"
    [[ -f "$HOME/.config/Kvantum/$t/$t.kvconfig" || -f "/usr/share/Kvantum/$t/$t.kvconfig" ]]
}

# ============================================================
# Temas de Plasma disponibles
# ============================================================
list_plasma_themes() {
    log "Temas de Plasma disponibles:"
    lookandfeeltool -l 2>/dev/null || warn "No se pudo listar temas de Plasma"
}

# ============================================================
# Aplicar tema de Plasma
# ============================================================
apply_plasma_theme() {
    local theme="$1"

    if [[ -z "$theme" ]]; then
        log "No se especificó···tema de Plasma. Saltando..."
        return 0
    fi

    if ! plasma_theme_exists "$theme"; then
        warn "El tema de Plasma '$theme' no está disponible."
        list_plasma_themes
        die "Usa uno de los temas listados arriba."
    fi

    log "Aplicando tema de Plasma: $theme"
    lookandfeeltool -a "$theme"
}

# ============================================================
# Aplicar tema de iconos
# ============================================================
apply_icon_theme() {
    local icon="$1"

    if [[ -z "$icon" ]]; then
        log "No se especificó···tema de iconos. Saltando..."
        return 0
    fi

    if ! icon_theme_exists "$icon"; then
        warn "El tema de iconos '$icon' no está disponible en /usr/share/icons, ~/.icons o /usr/share/pixmaps"
        die "Instala el tema o elige uno disponible."
    fi

    log "Aplicando tema de iconos: $icon"
    plasmashell --replace &>/dev/null || true
    kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme "$icon"
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
}

# ============================================================
# Aplicar tema de cursores
# ============================================================
apply_cursor_theme() {
    local cursor="$1"

    if [[ -z "$cursor" ]]; then
        log "No se especificó···tema de cursores. Saltando..."
        return 0
    fi

    if ! cursor_theme_exists "$cursor"; then
        warn "El tema de cursores '$cursor' no está disponible en /usr/share/icons o ~/.icons"
        die "Instala el tema o elige uno disponible."
    fi

    log "Aplicando tema de cursores: $cursor"
    kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key cursorTheme "$cursor"
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
}

# ============================================================
# Aplicar tema Kvantum
# ============================================================
apply_kvantum_theme() {
    local kvantum="$1"

    if [[ -z "$kvantum" ]]; then
        log "No se especificó···tema Kvantum. Saltando..."
        return 0
    fi

    if ! kvantum_theme_exists "$kvantum"; then
        warn "El tema Kvantum '$kvantum' no está disponible."
        log "Temas Kvantum disponibles en ~/.config/Kvantum:"
        [[ -d "$HOME/.config/Kvantum" ]] && ls -1 "$HOME/.config/Kvantum" 2>/dev/null || warn "No hay temas Kvantum en ~/.config/Kvantum"
        die "Instala el tema o elige uno disponible."
    fi

    log "Aplicando tema Kvantum: $kvantum"
    kvantummanager --set "$kvantum" 2>/dev/null || \
        kwriteconfig5 --file ~/.config/Kvantum/kvantum.kvconfig --group General --key theme "$kvantum"
}

# ============================================================
# Cambiar fondo de pantalla
# ============================================================
apply_wallpaper() {
    local wp="$1"

    if [[ -z "$wp" ]]; then
        log "No se especificó···fondo de pantalla. Saltando..."
        return 0
    fi

    if [[ ! -f "$wp" ]]; then
        die "El archivo de fondo de pantalla '$wp' no existe."
    fi

    log "Aplicando fondo de pantalla: $wp"
    # Plasma 5
    qdbus org.kde.plasmashell /PlasmaShell org.kde.plasmashell.evaluateScript \
        "var allDesktops = desktops(); print(main); for (i=0;i<allDesktops.length;i++) { d=allDesktops[i]; d.wallpaperPlugin='org.kde.image'; d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General']; d.writeConfig('Image', 'file://$wp'); }" 2>/dev/null || \
    warn "No se pudo cambiar el fondo con qdbus. Intenta manualmente desde Preferencias del Sistema."
}

# ============================================================
# Recargar Plasma
# ============================================================
reload_plasma() {
    log "Recargando Plasma..."
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
    kquitapp5 plasmashell 2>/dev/null || kquitapp plasmashell 2>/dev/null || true
    sleep 1
    kstart5 plasmashell 2>/dev/null || kstart plasmashell 2>/dev/null || plasmashell &>/dev/null &
}

# ============================================================
# Ejecutar cambios
# ============================================================
if [[ -n "$THEME" || -n "$ICON" || -n "$CURSOR" || -n "$WALLPAPER" || -n "$KVANTUM" ]]; then
    apply_plasma_theme "$THEME"
    apply_icon_theme "$ICON"
    apply_cursor_theme "$CURSOR"
    apply_kvantum_theme "$KVANTUM"
    apply_wallpaper "$WALLPAPER"
    reload_plasma
    log "✅ Tema aplicado correctamente."
else
    log "No se especificaron opciones. Mostrando temas disponibles..."
    list_plasma_themes
    log "Usa --help para ver cómo cambiar el tema."
fi
