#!/bin/bash

# ============================================================
# Instalador de Catppuccin Kvantum Theme
# ============================================================
# Descarga e instala los temas de Catppuccin para Kvantum
# Soporta: Latte, Frappé, Macchiato, Mocha
# Con accents: Rosewater, Flamingo, Pink, Mauve, Red, Maroon, Peach, Yellow, Green, Teal, Sky, Sapphire, Blue, Lavender

set -euo pipefail

GITHUB_REPO="https://github.com/catppuccin/kvantum.git"
TEMP_DIR="/tmp/catppuccin-kvantum-install"
THEMES_DIR="$HOME/.config/Kvantum"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================
# Funciones
# ============================================================

log_info() {
    echo -e "${BLUE}▶${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# ============================================================
# Verificaciones previas
# ============================================================

log_info "Verificando requisitos..."

if ! command -v git &> /dev/null; then
    log_error "git no está instalado"
    exit 1
fi

if ! command -v kvantummanager &> /dev/null; then
    log_warning "kvantummanager no está instalado"
    log_info "Instálalo con: sudo pacman -S kvantum"
fi

if [ ! -d "$THEMES_DIR" ]; then
    log_info "Creando directorio de temas..."
    mkdir -p "$THEMES_DIR"
fi

# ============================================================
# Descargar repositorio
# ============================================================

log_info "Descargando Catppuccin Kvantum desde GitHub..."

if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

git clone --depth 1 "$GITHUB_REPO" "$TEMP_DIR" 2>&1 | grep -v "Cloning\|Receiving\|Resolving" || true

if [ ! -d "$TEMP_DIR/themes" ]; then
    log_error "No se pudo descargar el repositorio"
    exit 1
fi

log_success "Repositorio descargado"

# ============================================================
# Listar temas disponibles
# ============================================================

log_info ""
log_info "Temas disponibles:"
echo ""

cd "$TEMP_DIR/themes"
FLAVORS=()
for dir in */; do
    FLAVOR="${dir%/}"
    FLAVORS+=("$FLAVOR")
    echo "  • $FLAVOR"
done

echo ""

# ============================================================
# Seleccionar sabor (flavor)
# ============================================================

log_info "¿Cuál sabor deseas instalar?"
echo ""

select FLAVOR in "${FLAVORS[@]}"; do
    if [[ -n "$FLAVOR" ]]; then
        log_success "Sabor seleccionado: $FLAVOR"
        break
    else
        log_error "Opción inválida"
    fi
done

# ============================================================
# Listar acentos del sabor seleccionado
# ============================================================

echo ""
log_info "Acentos disponibles para $FLAVOR:"
echo ""

cd "$TEMP_DIR/themes/$FLAVOR"
ACCENTS=()
for dir in */; do
    ACCENT="${dir%/}"
    ACCENTS+=("$ACCENT")
    echo "  • $ACCENT"
done

echo ""
log_info "¿Cuál acento deseas instalar?"
echo ""

select ACCENT in "${ACCENTS[@]}"; do
    if [[ -n "$ACCENT" ]]; then
        log_success "Acento seleccionado: $ACCENT"
        break
    else
        log_error "Opción inválida"
    fi
done

# ============================================================
# Instalar tema
# ============================================================

THEME_SOURCE="$TEMP_DIR/themes/$FLAVOR/$ACCENT"
THEME_NAME="Catppuccin-${FLAVOR^}-${ACCENT^}"
THEME_DEST="$THEMES_DIR/$THEME_NAME"

echo ""
log_info "Instalando tema: $THEME_NAME"

# Remover si existe
if [ -d "$THEME_DEST" ]; then
    log_warning "El tema ya existe, reemplazando..."
    rm -rf "$THEME_DEST"
fi

# Copiar tema
cp -r "$THEME_SOURCE" "$THEME_DEST"

if [ -d "$THEME_DEST" ]; then
    log_success "Tema instalado en: $THEME_DEST"
else
    log_error "Falló la instalación"
    exit 1
fi

# ============================================================
# Información final
# ============================================================

echo ""
log_success "¡Instalación completada!"
echo ""
log_info "Próximos pasos:"
echo "  1. Abre Kvantum Manager"
echo "  2. Selecciona '$THEME_NAME' de la lista"
echo "  3. Haz clic en 'Apply'"
echo ""
log_info "Para aplicar el tema globalmente en KDE Plasma:"
echo "  • Ve a: System Settings → Appearance → Application Style → Kvantum"
echo "  • Selecciona el tema instalado"
echo ""

# ============================================================
# Limpiar
# ============================================================

log_info "Limpiando archivos temporales..."
rm -rf "$TEMP_DIR"
log_success "Hecho"

echo ""
log_info "Para instalar todos los temas de una vez, ejecuta:"
echo "  bash $0 --install-all"
