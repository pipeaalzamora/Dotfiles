#!/usr/bin/env bash
# ============================================================
# Instalador Principal de Dotfiles
# Configura enlaces simbólicos, permisos y servicios
# ============================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}   ${BOLD}$1${NC}"
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

ask_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    local answer
    
    while true; do
        read -r -p "$(echo -e "${YELLOW}?${NC} $prompt [S/n]: ")" answer
        answer="${answer:-$default}"
        case "$answer" in
            [SsYy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Por favor responde sí (s) o no (n)." ;;
        esac
    done
}

link_file() {
    local source="$1"
    local target="$2"
    
    if [ ! -e "$source" ]; then
        print_warning "Origen no existe: $source"
        return 1
    fi
    
    mkdir -p "$(dirname "$target")"
    
    if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$source")" ]; then
        print_info "Ya enlazado: $target"
        return 0
    fi
    
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        print_info "Backup: $(basename "$target")"
    fi
    
    ln -s "$source" "$target"
    print_success "Enlazado: $target"
}

# ============================================================
# INICIO
# ============================================================

print_header "🚀 Dotfiles - Instalador Principal"

echo -e "${BOLD}Bienvenido a la instalación de Dotfiles${NC}"
echo ""
print_info "Este script hará lo siguiente:"
echo "  1. ✅ Crear enlaces simbólicos para archivos de configuración"
echo "  2. ✅ Configurar permisos de scripts"
echo "  3. ✅ Instalar servicios systemd"
echo "  4. ✅ Instalar lanzadores .desktop"
echo ""

if ! ask_yes_no "¿Deseas continuar?"; then
    print_info "Cancelado."
    exit 0
fi

# ============================================================
# FASE 1: CREAR ENLACES SIMBÓLICOS
# ============================================================

print_header "FASE 1: Creando Enlaces Simbólicos"

# Archivos raíz
ROOT_FILES=(.zshrc .zprofile .gitconfig .gitignore_global .editorconfig .tool-versions .bashrc)

print_info "Archivos de configuración raíz:"
for file in "${ROOT_FILES[@]}"; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        link_file "$DOTFILES_DIR/$file" "$HOME/$file"
    fi
done

echo ""
print_info "Configuraciones en ~/.config:"

# Archivos .config
mkdir -p "$HOME/.config"

CONFIG_ITEMS=(starship.toml fontconfig environment.d)

# Detecta qué herramientas están instaladas
command -v kitty &>/dev/null && CONFIG_ITEMS+=(kitty)
command -v nvim &>/dev/null && CONFIG_ITEMS+=(nvim)
command -v lazygit &>/dev/null && CONFIG_ITEMS+=(lazygit)
command -v btop &>/dev/null && CONFIG_ITEMS+=(btop)
command -v lsd &>/dev/null && CONFIG_ITEMS+=(lsd)
command -v bat &>/dev/null && CONFIG_ITEMS+=(bat)
command -v yazi &>/dev/null && CONFIG_ITEMS+=(yazi)
command -v zathura &>/dev/null && CONFIG_ITEMS+=(zathura)
command -v zellij &>/dev/null && CONFIG_ITEMS+=(zellij)

# KDE y GTK
if pgrep -x plasmashell > /dev/null 2>&1 || [ -d "/usr/share/plasma" ]; then
    CONFIG_ITEMS+=(kdeglobals kglobalshortcutsrc kwinrc Kvantum gtk-3.0 gtk-4.0 rofi)
fi

command -v easyeffects &>/dev/null && CONFIG_ITEMS+=(easyeffects)

for item in "${CONFIG_ITEMS[@]}"; do
    if [ -e "$DOTFILES_DIR/.config/$item" ]; then
        link_file "$DOTFILES_DIR/.config/$item" "$HOME/.config/$item"
    fi
done

# ============================================================
# FASE 2: CONFIGURAR PERMISOS Y SERVICIOS
# ============================================================

echo ""
print_header "FASE 2: Configurando Servicios y Permisos"

# Permisos de scripts
print_info "Configurando permisos de scripts..."
chmod +x "$DOTFILES_DIR/scripts/"*.sh 2>/dev/null || true
chmod +x "$DOTFILES_DIR/scripts/update-all" 2>/dev/null || true
chmod +x "$DOTFILES_DIR/scripts/check-dependencies" 2>/dev/null || true
chmod +x "$DOTFILES_DIR/bin/dotfiles" 2>/dev/null || true
print_success "Permisos configurados"

# Systemd services
if [ -d "$DOTFILES_DIR/.config/systemd/user" ]; then
    print_info "Instalando servicios systemd..."
    mkdir -p "$HOME/.config/systemd/user"
    cp "$DOTFILES_DIR/.config/systemd/user/"*.{timer,service} "$HOME/.config/systemd/user/" 2>/dev/null || true
    systemctl --user daemon-reload 2>/dev/null || true
    print_success "Servicios systemd instalados"
fi

# Lanzadores .desktop
if [ -d "$DOTFILES_DIR/.local/share/applications" ]; then
    print_info "Instalando lanzadores .desktop..."
    APPS_DIR="$HOME/.local/share/applications"
    mkdir -p "$APPS_DIR"
    cp "$DOTFILES_DIR/.local/share/applications/"*.desktop "$APPS_DIR/" 2>/dev/null || true
    print_success "Lanzadores instalados"
fi

# Git hooks
if [ -d "$DOTFILES_DIR/.githooks" ]; then
    print_info "Activando Git hooks..."
    cd "$DOTFILES_DIR"
    git config core.hooksPath .githooks 2>/dev/null || true
    chmod +x "$DOTFILES_DIR/.githooks/"* 2>/dev/null || true
    print_success "Git hooks activados"
fi

# .zshrc.local
if [ ! -f "$HOME/.zshrc.local" ] && [ -f "$DOTFILES_DIR/.zshrc.local.example" ]; then
    print_info "Creando ~/.zshrc.local personalizado..."
    cp "$DOTFILES_DIR/.zshrc.local.example" "$HOME/.zshrc.local"
    print_success "Creado: ~/.zshrc.local"
fi

# ============================================================
# FASE 3: OPCIONALES
# ============================================================

echo ""
print_header "FASE 3: Configuración Adicional (Opcional)"

if ask_yes_no "¿Deseas configurar KDE Plasma 6 con Catppuccin?"; then
    if [ -f "$DOTFILES_DIR/scripts/setup-kde.sh" ]; then
        bash "$DOTFILES_DIR/scripts/setup-kde.sh"
    fi
fi

if ask_yes_no "¿Deseas instalar programas recomendados?"; then
    if [ -f "$DOTFILES_DIR/scripts/install-programs.sh" ]; then
        bash "$DOTFILES_DIR/scripts/install-programs.sh"
    fi
fi

if ask_yes_no "¿Deseas instalar y configurar Git globalmente?"; then
    if [ -f "$DOTFILES_DIR/bin/dotfiles" ]; then
        "$DOTFILES_DIR/bin/dotfiles" git
    fi
fi

# ============================================================
# RESUMEN FINAL
# ============================================================

echo ""
print_header "✅ INSTALACIÓN COMPLETADA"

echo -e "${BOLD}Lo que se configuró:${NC}"
echo "  ✅ Enlaces simbólicos para archivos de configuración"
echo "  ✅ Permisos de ejecución en scripts"
echo "  ✅ Servicios systemd"
echo "  ✅ Lanzadores .desktop"
echo "  ✅ Git hooks"
echo ""

if [ -d "$BACKUP_DIR" ] && [ -n "$(ls -A "$BACKUP_DIR")" ]; then
    echo -e "${BOLD}Backups guardados en:${NC}"
    echo "  $BACKUP_DIR"
    echo ""
fi

echo -e "${BOLD}Próximos pasos:${NC}"
echo ""
echo "  1️⃣  Recarga tu shell:"
echo "     ${CYAN}exec zsh${NC}"
echo ""
echo "  2️⃣  Verifica que todo funciona:"
echo "     ${CYAN}dotfiles doctor${NC}"
echo ""
echo "  3️⃣  Explora los comandos disponibles:"
echo "     ${CYAN}dotfiles help${NC}"
echo ""
echo "  4️⃣  Lee la documentación completa:"
echo "     ${CYAN}cat $DOTFILES_DIR/DOTFILES_CLI.md${NC}"
echo ""

print_success "¡Tu entorno está configurado! 🚀"
echo ""
