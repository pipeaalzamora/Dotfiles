#!/bin/bash

# ============================================================
# Activador de Kvantum para KDE Plasma
# ============================================================

set -euo pipefail

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}▶${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# ============================================================
# Verificaciones previas
# ============================================================

log_info "Verificando requisitos..."

# Detectar versión de KDE
if command -v kwriteconfig6 &> /dev/null; then
    KWRITE_CMD="kwriteconfig6"
elif command -v kwriteconfig5 &> /dev/null; then
    KWRITE_CMD="kwriteconfig5"
else
    log_error "No se encontró kwriteconfig5 ni kwriteconfig6"
    exit 1
fi

if ! command -v kvantummanager &> /dev/null; then
    log_error "kvantummanager no está instalado"
    log_info "Instala con: sudo pacman -S kvantum"
    exit 1
fi

# ============================================================
# Activar Kvantum
# ============================================================

log_info "Activando Kvantum en KDE Plasma..."

$KWRITE_CMD --file "$HOME/.config/kdeglobals" --group General --key "widgetStyle" "kvantum"

if [ $? -eq 0 ]; then
    log_success "Kvantum activado"
else
    log_error "Fallo al activar Kvantum"
    exit 1
fi

# ============================================================
# Verificación
# ============================================================

if [ ! -d ~/.config/Kvantum ]; then
    mkdir -p ~/.config/Kvantum
fi

THEME_COUNT=$(find ~/.config/Kvantum -maxdepth 1 -type d ! -name "Kvantum" 2>/dev/null | wc -l)

if [ "$THEME_COUNT" -gt 0 ]; then
    log_success "$THEME_COUNT tema(s) encontrado(s)"
else
    log_warning "No hay temas instalados"
fi

# ============================================================
# Información final
# ============================================================

echo ""
log_success "¡Kvantum activado!"
echo ""
log_info "Próximos pasos:"
echo "  1. Abre Kvantum Manager: kvantummanager"
echo "  2. Selecciona el tema que desees"
echo "  3. Haz clic en 'Apply'"
echo ""
