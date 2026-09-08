#!/bin/bash

# ============================================================
# Instalador completo de todos los temas Catppuccin Kvantum
# ============================================================
# Descarga e instala TODOS los sabores y acentos

set -euo pipefail

GITHUB_REPO="https://github.com/catppuccin/kvantum.git"
TEMP_DIR="/tmp/catppuccin-kvantum-install-all"
THEMES_DIR="$HOME/.config/Kvantum"

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}▶${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# ============================================================
# Verificaciones
# ============================================================

log_info "Verificando requisitos..."

if ! command -v git &> /dev/null; then
    echo "❌ git no está instalado"
    exit 1
fi

if [ ! -d "$THEMES_DIR" ]; then
    log_info "Creando directorio de temas..."
    mkdir -p "$THEMES_DIR"
fi

# ============================================================
# Descargar repositorio
# ============================================================

log_info "Descargando Catppuccin Kvantum..."

if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

git clone --depth 1 "$GITHUB_REPO" "$TEMP_DIR" 2>&1 | grep -v "Cloning\|Receiving\|Resolving" || true

# ============================================================
# Instalar todos los temas
# ============================================================

log_info "Instalando todos los temas..."
echo ""

TOTAL=0
INSTALLED=0

for flavor_dir in "$TEMP_DIR/themes"/*; do
    FLAVOR=$(basename "$flavor_dir")
    
    for accent_dir in "$flavor_dir"/*; do
        ACCENT=$(basename "$accent_dir")
        THEME_NAME="Catppuccin-${FLAVOR^}-${ACCENT^}"
        THEME_DEST="$THEMES_DIR/$THEME_NAME"
        
        TOTAL=$((TOTAL + 1))
        
        # Remover si existe
        [ -d "$THEME_DEST" ] && rm -rf "$THEME_DEST"
        
        # Copiar tema
        cp -r "$accent_dir" "$THEME_DEST"
        
        if [ -d "$THEME_DEST" ]; then
            echo "  ✓ $THEME_NAME"
            INSTALLED=$((INSTALLED + 1))
        else
            echo "  ✗ $THEME_NAME (falló)"
        fi
    done
done

echo ""
log_success "Instalación completada: $INSTALLED/$TOTAL temas instalados"

# ============================================================
# Información
# ============================================================

echo ""
log_info "Temas disponibles:"
ls -1 "$THEMES_DIR" | grep -i catppuccin | sort

echo ""
log_info "Para usar un tema:"
echo "  1. Abre Kvantum Manager (kvantummanager)"
echo "  2. Selecciona el tema que desees"
echo "  3. Haz clic en 'Apply'"
echo ""
log_info "En KDE Plasma:"
echo "  • System Settings → Appearance → Application Style → Kvantum"
echo ""

# ============================================================
# Limpiar
# ============================================================

log_info "Limpiando archivos temporales..."
rm -rf "$TEMP_DIR"
log_success "¡Listo!"
