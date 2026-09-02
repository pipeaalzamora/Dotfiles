#!/usr/bin/env bash
# ============================================================
# Gestor de Perfiles Multi-Monitor con KScreen (KDE Plasma 6)
# Repositorio: pipeaalzamora/Dotfiles
# Atajo: Meta+P (o comando 'monitors')
# ============================================================

set -e

CACHE_FILE="$HOME/.cache/current-monitor-profile"

if ! command -v kscreen-doctor &>/dev/null; then
    echo "❌ kscreen-doctor no está disponible. Debería venir incluido con KDE Plasma (paquete 'kscreen')."
    exit 1
fi

if ! command -v jq &>/dev/null; then
    echo "❌ jq no está instalado. Instalo con: sudo pacman -S jq"
    exit 1
fi

OUTPUTS_JSON=$(kscreen-doctor -j)

# Detectar salida interna (panel de laptop) entre las conectadas
INTERNAL=$(echo "$OUTPUTS_JSON" | jq -r '.outputs[] | select(.connected==true) | select(.name | test("^(eDP|LVDS)")) | .name' | head -n1)

# Si no hay panel interno (escritorio de sobremesa), usar la primera pantalla conectada como referencia
if [ -z "$INTERNAL" ]; then
    INTERNAL=$(echo "$OUTPUTS_JSON" | jq -r '.outputs[] | select(.connected==true) | .name' | head -n1)
fi

mapfile -t EXTERNALS < <(echo "$OUTPUTS_JSON" | jq -r --arg internal "$INTERNAL" '.outputs[] | select(.connected==true) | select(.name != $internal) | .name')

if [ ${#EXTERNALS[@]} -eq 0 ]; then
    echo "ℹ️  Solo se detectó una pantalla conectada ($INTERNAL). No hay nada que gestionar."
    exit 0
fi

EXTERNAL="${EXTERNALS[0]}"

# Obtiene el ancho y alto del modo activo de una salida (en base a su currentModeId)
get_size() {
    local output_name="$1"
    echo "$OUTPUTS_JSON" | jq -r --arg name "$output_name" '
        (.outputs[] | select(.name == $name)) as $o |
        ($o.modes[] | select(.id == $o.currentModeId)) | "\(.size.width) \(.size.height)"
    ' 2>/dev/null
}

read -r INTERNAL_W INTERNAL_H <<< "$(get_size "$INTERNAL")"
INTERNAL_W="${INTERNAL_W:-1920}"

PROFILES=(
    "💻 Solo Pantalla Principal ($INTERNAL)"
    "🖥️  Solo Pantalla Externa ($EXTERNAL)"
    "➡️  Extender a la Derecha (Principal + Externa)"
    "⬅️  Extender a la Izquierda (Externa + Principal)"
    "🪞 Duplicar / Espejo (Mismo contenido en ambas)"
)

if [ -n "$1" ]; then
    CHOICE="$1"
else
    if command -v rofi &>/dev/null; then
        CHOICE=$(printf '%s\n' "${PROFILES[@]}" | rofi -dmenu -i -p "🖥️  Perfil de Pantallas" -theme "$HOME/.config/rofi/config.rasi")
    else
        echo "Selecciona un perfil de pantallas:"
        select opt in "${PROFILES[@]}"; do
            CHOICE="$opt"
            break
        done
    fi
fi

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    *"Solo Pantalla Principal"*)
        PROFILE_NAME="Solo Principal ($INTERNAL)"
        kscreen-doctor output."$INTERNAL".enable output."$EXTERNAL".disable
        ;;
    *"Solo Pantalla Externa"*)
        PROFILE_NAME="Solo Externa ($EXTERNAL)"
        kscreen-doctor output."$INTERNAL".disable output."$EXTERNAL".enable
        ;;
    *"Extender a la Derecha"*)
        PROFILE_NAME="Extendida a la Derecha"
        kscreen-doctor \
            output."$INTERNAL".enable \
            output."$EXTERNAL".enable \
            output."$INTERNAL".position.0,0 \
            output."$EXTERNAL".position."$INTERNAL_W",0
        ;;
    *"Extender a la Izquierda"*)
        PROFILE_NAME="Extendida a la Izquierda"
        read -r EXT_W EXT_H <<< "$(get_size "$EXTERNAL")"
        EXT_W="${EXT_W:-1920}"
        kscreen-doctor \
            output."$EXTERNAL".enable \
            output."$INTERNAL".enable \
            output."$EXTERNAL".position.0,0 \
            output."$INTERNAL".position."$EXT_W",0
        ;;
    *"Duplicar"*)
        PROFILE_NAME="Duplicada / Espejo"
        kscreen-doctor \
            output."$INTERNAL".enable \
            output."$EXTERNAL".enable \
            output."$INTERNAL".position.0,0 \
            output."$EXTERNAL".position.0,0
        ;;
    *)
        exit 0
        ;;
esac

mkdir -p "$(dirname "$CACHE_FILE")"
echo "$PROFILE_NAME" > "$CACHE_FILE"

notify-send -a "Monitores" -i preferences-desktop-display "Perfil de Pantallas Aplicado" "$PROFILE_NAME" 2>/dev/null || true
echo "✅ ¡Perfil '$PROFILE_NAME' aplicado!"
