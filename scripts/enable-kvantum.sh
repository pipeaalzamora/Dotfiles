#!/bin/bash

# ============================================================
# Activador de Kvantum para KDE Plasma
# ============================================================
# Este script activa Kvantum como Application Style en KDE Plasma
# Permitiendo que todos los temas de Kvantum se apliquen al sistema

set -euo pipefail

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

if ! command -v kwriteconfig5 &> /dev/null; then
    log_error "kwriteconfig5 no está instalado"
    log_info "Instálalo con: sudo pacman -S extra-cmake-modules"
    exit 1
fi

if ! command -v kvantummanager &> /dev/null; then
    log_warning "kvantummanager no está instalado"
    log_info "Instálalo con: sudo pacman -S kvantum"
    exit 1
fi

# Verificar si es KDE Plasma
if [ -z "${PLASMA_VERSION:-}" ]; then
    log_warning "No parece estar ejecutando KDE Plasma"
    log_info "Los cambios se aplicarán a la configuración de KDE Plasma"
fi

# ============================================================
# Explicación
# ============================================================

cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║                    🎨 ACTIVACIÓN DE KVANTUM EN KDE 🎨                     ║
╚════════════════════════════════════════════════════════════════════════════╝

¿QUÉ HACE ESTE SCRIPT?

  1. Configura KDE Plasma para usar Kvantum como Application Style
  2. Habilita la integración completa de Kvantum con el sistema
  3. Permite que los temas instalados en ~/.config/Kvantum se apliquen

¿QUÉ NECESITAS DESPUÉS?

  Después de ejecutar este script debes:
  
  1. Abrir Kvantum Manager: kvantummanager
  2. Seleccionar el tema que desees (ej: Catppuccin-Mocha-Blue)
  3. Hacer clic en "Apply"
  
  Luego, los cambios se aplicarán a TODAS las aplicaciones Qt en tu sistema

════════════════════════════════════════════════════════════════════════════

EOF

read -p "¿Deseas continuar? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    log_info "Abortado"
    exit 0
fi

# ============================================================
# Activar Kvantum
# ============================================================

echo ""
log_info "Activando Kvantum en KDE Plasma..."

# Configurar el Application Style a Kvantum
log_info "Configurando Application Style..."
kwriteconfig5 --file ~/.config/kdeglobals --group General --key "widgetStyle" "kvantum"

if [ $? -eq 0 ]; then
    log_success "Application Style configurado"
else
    log_error "Fallo al configurar Application Style"
    exit 1
fi

# ============================================================
# Verificar instalación
# ============================================================

echo ""
log_info "Verificando instalación..."

# Verificar que Kvantum está instalado
if [ ! -d ~/.config/Kvantum ]; then
    log_warning "Directorio Kvantum no encontrado"
    log_info "Se creará automáticamente al instalar un tema"
    mkdir -p ~/.config/Kvantum
fi

# Contar temas instalados
THEME_COUNT=$(find ~/.config/Kvantum -maxdepth 1 -type d ! -name "Kvantum" 2>/dev/null | wc -l)

if [ "$THEME_COUNT" -gt 0 ]; then
    log_success "Se encontraron $THEME_COUNT tema(s) instalado(s)"
else
    log_warning "No hay temas Kvantum instalados"
    log_info "Instala un tema primero ejecutando:"
    echo "  bash ~/dotfiles/scripts/install-catppuccin-kvantum.sh"
fi

# ============================================================
# Información final
# ============================================================

echo ""
log_success "¡Kvantum activado en KDE Plasma!"

cat << 'EOF'

════════════════════════════════════════════════════════════════════════════

PRÓXIMOS PASOS:

  1. Abre Kvantum Manager:
     $ kvantummanager
  
  2. Selecciona el tema que desees:
     - Catppuccin-Mocha-Blue (recomendado)
     - O cualquier otro tema instalado
  
  3. Haz clic en "Apply"
  
  4. ¡Listo! Los cambios se aplicarán inmediatamente

════════════════════════════════════════════════════════════════════════════

ALTERNATIVA: Hacerlo manualmente en KDE

  System Settings → Appearance → Application Style
  
  1. Abre System Settings
  2. Ve a "Appearance"
  3. Selecciona "Application Style"
  4. En el menú desplegable, elige "Kvantum"
  5. Se abrirá Kvantum Manager automáticamente
  6. Selecciona el tema y aplica

════════════════════════════════════════════════════════════════════════════

TIPS:

  • Kvantum controla la apariencia de botones, ventanas, barras, etc.
  • Los cambios se aplican a TODAS las aplicaciones Qt
  • Puedes cambiar entre temas en cualquier momento
  • Algunos temas tienen opciones en Kvantum Manager

════════════════════════════════════════════════════════════════════════════

EOF

log_info "Para más información, consulta:"
echo "  ~/dotfiles/docs/CATPPUCCIN_KVANTUM_SETUP.md"

echo ""
