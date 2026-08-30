#!/usr/bin/env bash
# ============================================================
# Gestor de Perfiles de KDE Plasma 6 con Konsave
# Repositorio: pipeaalzamora/Dotfiles
# ============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_NAME="catppuccin-plasma-profile"
BACKUP_FILE="$DOTFILES_DIR/kde-plasma-profile.knsv"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}   ${BOLD}$1${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

check_konsave() {
    if ! command -v konsave &>/dev/null; then
        echo -e "${YELLOW}⚠️  Konsave no está instalado. Instalando con yay...${NC}"
        yay -S --needed --noconfirm konsave || pipx install konsave
    fi
}

save_profile() {
    check_konsave
    print_header "Guardando Perfil Activo de KDE Plasma"
    echo -e "${CYAN}Capturando paneles, widgets, esquemas de color y reglas de KWin...${NC}"
    
    # Remover perfil previo si existe
    konsave -r "$PROFILE_NAME" 2>/dev/null || true
    
    # Guardar nuevo perfil y exportarlo
    konsave -s "$PROFILE_NAME"
    konsave -e "$PROFILE_NAME"
    
    # Mover archivo generado a la raíz del repositorio
    if [ -f "$HOME/$PROFILE_NAME.knsv" ]; then
        mv "$HOME/$PROFILE_NAME.knsv" "$BACKUP_FILE"
    fi
    
    echo ""
    echo -e "${GREEN}✅ Perfil exportado exitosamente a: ${BOLD}$BACKUP_FILE${NC}"
    echo -e "${CYAN}Ahora puedes hacer 'git add kde-plasma-profile.knsv && git commit' para guardar tu escritorio en GitHub.${NC}"
}

restore_profile() {
    check_konsave
    print_header "Restaurando Perfil de KDE Plasma"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        echo -e "${YELLOW}⚠️  No se encontró $BACKUP_FILE. Guarda un perfil primero con: $0 save${NC}"
        exit 1
    fi
    
    echo -e "${CYAN}Importando y aplicando perfil ${PROFILE_NAME}...${NC}"
    konsave -i "$BACKUP_FILE" --force
    konsave -a "$PROFILE_NAME"
    
    # Reiniciar plasmashell
    systemctl --user restart plasma-plasmashell.service 2>/dev/null || true
    
    echo ""
    echo -e "${GREEN}✅ ¡Escritorio restaurado idéntico a la copia de respaldo!${NC}"
}

case "$1" in
    save|export)
        save_profile
        ;;
    restore|import|apply)
        restore_profile
        ;;
    *)
        print_header "Gestor de Perfiles de KDE Plasma (Konsave)"
        echo -e "Uso:"
        echo -e "  ${BOLD}$0 save${NC}     -> Guarda el estado actual del escritorio (paneles, widgets, fondos) en el repo"
        echo -e "  ${BOLD}$0 restore${NC}  -> Restaura el escritorio completo desde el archivo del repo"
        echo ""
        ;;
esac
