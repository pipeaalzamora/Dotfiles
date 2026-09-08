#!/usr/bin/env bash
# ============================================================
# Configure Git - Script Interactivo
# Configura Git globalmente para el usuario
# ============================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    clear
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}   ${BOLD}Configurador Interactivo de Git${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_info() {
    echo -e "${CYAN}ℹ   $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠   $1${NC}"
}

print_error() {
    echo -e "${RED}❌  $1${NC}"
}

# ============================================================
# INICIO
# ============================================================

print_header

echo -e "${BOLD}Vamos a configurar Git globalmente en tu sistema.${NC}"
echo ""
print_info "Esta configuración se aplicará a TODOS tus repositorios."
echo ""

# ============================================================
# OBTENER VALORES ACTUALES
# ============================================================

CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
CURRENT_EDITOR=$(git config --global core.editor 2>/dev/null || echo "nvim")

echo -e "${BOLD}Valores actuales:${NC}"
echo "  Nombre: ${CYAN}${CURRENT_NAME:-[no configurado]}${NC}"
echo "  Email:  ${CYAN}${CURRENT_EMAIL:-[no configurado]}${NC}"
echo "  Editor: ${CYAN}${CURRENT_EDITOR}${NC}"
echo ""

# ============================================================
# USUARIO
# ============================================================

read -p "$(echo -e ${YELLOW}?${NC} Ingresa tu nombre (Enter para mantener actual): " USER_NAME
USER_NAME="${USER_NAME:-$CURRENT_NAME}"

if [ -z "$USER_NAME" ]; then
    print_error "El nombre no puede estar vacío"
    exit 1
fi

# ============================================================
# EMAIL
# ============================================================

read -p "$(echo -e ${YELLOW}?${NC} Ingresa tu email (Enter para mantener actual): " USER_EMAIL
USER_EMAIL="${USER_EMAIL:-$CURRENT_EMAIL}"

if [ -z "$USER_EMAIL" ]; then
    print_error "El email no puede estar vacío"
    exit 1
fi

# ============================================================
# EDITOR
# ============================================================

read -p "$(echo -e ${YELLOW}?${NC} Ingresa editor por defecto [nvim/vim/nano/code] (Enter para $CURRENT_EDITOR): " USER_EDITOR
USER_EDITOR="${USER_EDITOR:-$CURRENT_EDITOR}"

# ============================================================
# CONFIGURAR
# ============================================================

echo ""
echo -e "${BOLD}Configurando...${NC}"
echo ""

git config --global user.name "$USER_NAME"
print_success "Usuario: $USER_NAME"

git config --global user.email "$USER_EMAIL"
print_success "Email: $USER_EMAIL"

git config --global core.editor "$USER_EDITOR"
print_success "Editor: $USER_EDITOR"

# ============================================================
# CONFIGURAR EDITOR EN .gitconfig SI USA NVIM
# ============================================================

if [ "$USER_EDITOR" = "nvim" ]; then
    git config --global core.pager "delta"
    print_success "Pager: delta (visual diffs)"
fi

# ============================================================
# CONFIGURAR CREDENTIAL HELPER
# ============================================================

echo ""
echo -e "${BOLD}¿Guardar contraseñas de GitHub?${NC}"
read -p "$(echo -e ${YELLOW}?${NC} Usar credential.helper cache? [s/n] (default: s): " SAVE_CREDS
SAVE_CREDS="${SAVE_CREDS:-s}"

if [[ "$SAVE_CREDS" =~ ^[Ss]$ ]]; then
    git config --global credential.helper cache
    git config --global credential.helper "cache --timeout=3600"
    print_success "Credenciales guardarán por 1 hora"
fi

# ============================================================
# VERIFICACIÓN FINAL
# ============================================================

echo ""
echo -e "${BOLD}Configuración Final:${NC}"
echo ""

echo "  $(git config --global user.name) <$(git config --global user.email)>"
echo "  Editor: $(git config --global core.editor)"
echo "  Pager: $(git config --global core.pager)"

echo ""
git config --global --list | grep -E "^(user\.|core\.editor|core\.pager|credential\.)" | sed 's/^/  /'

echo ""
print_success "✨ Git configurado correctamente"
echo ""
echo -e "${BOLD}Próximos pasos:${NC}"
echo "  1. git st              → Ver estado del repositorio"
echo "  2. git st             → Ver cambios"
echo "  3. git add .          → Agregar cambios"
echo "  4. git ci -m 'msg'   → Hacer commit"
echo "  5. git push           → Hacer push a GitHub"
echo ""
