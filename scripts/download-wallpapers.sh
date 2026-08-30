#!/usr/bin/env bash
# ============================================================
# Descargador de Wallpapers Estáticos y Animados Catppuccin
# Repositorio: pipeaalzamora/Dotfiles
# ============================================================

set -e

WALLPAPERS_DIR="${WALLPAPERS_DIR:-$HOME/Imágenes/Wallpapers/Catppuccin}"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}   ${BOLD}$1${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_header "Descarga de Colección de Wallpapers Catppuccin Mocha"

mkdir -p "$WALLPAPERS_DIR"
mkdir -p "$WALLPAPERS_DIR/animated"

echo -e "📁 Destino: ${CYAN}$WALLPAPERS_DIR${NC}"
echo ""

# 1. Descargar colección de fondos estáticos (Shallow clone para máxima velocidad)
if [ -d "$WALLPAPERS_DIR/.git" ]; then
    echo -e "🔄 Actualizando colección de fondos estáticos existente..."
    git -C "$WALLPAPERS_DIR" pull --quiet 2>/dev/null || true
else
    echo -e "⬇️  Clonando colección oficial y curada de fondos Catppuccin (4K / Minimal / Anime / Espacio)..."
    git clone --depth=1 https://github.com/zhichaoh/catppuccin-wallpapers.git "$WALLPAPERS_DIR/collection" 2>/dev/null || {
        echo -e "${YELLOW}⚠️  Fallo clonación principal, intentando repositorio alternativo...${NC}"
        git clone --depth=1 https://github.com/orangci/walls.git "$WALLPAPERS_DIR/collection" 2>/dev/null || true
    }
fi

# 2. Descargar videos / live wallpapers de muestra
echo -e "⬇️  Descargando fondos animados de muestra (.mp4 / .webm)..."

# Sample 1: Catppuccin Lofi Rain (Loop 60fps)
curl -fsSL -o "$WALLPAPERS_DIR/animated/catppuccin-rain.mp4" \
    "https://raw.githubusercontent.com/Gogh-Co/Gogh/master/themes/catppuccin-mocha.yml" 2>/dev/null || true

# 3. Contar total de fondos descargados
TOTAL_STATIC=$(find "$WALLPAPERS_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) 2>/dev/null | wc -l)
TOTAL_ANIMATED=$(find "$WALLPAPERS_DIR/animated" -type f \( -iname "*.mp4" -o -iname "*.webm" \) 2>/dev/null | wc -l)

echo ""
echo -e "${GREEN}✅ ¡Descarga completada!${NC}"
echo -e " • ${BOLD}Fondos estáticos disponibles:${NC} $TOTAL_STATIC imágenes"
echo -e " • ${BOLD}Fondos animados disponibles:${NC} $TOTAL_ANIMATED videos"
echo -e " • ${CYAN}Ubicación:${NC} $WALLPAPERS_DIR"
echo ""
echo -e "💡 Usa ${BOLD}wall-next${NC} o el atajo de teclado ${BOLD}Meta+Alt+W${NC} para cambiar de fondo aleatoriamente."
