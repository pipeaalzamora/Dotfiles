#!/usr/bin/env bash
# ============================================================
# Setup.sh - Instalador Completo Interactivo de Dotfiles
# Valida → Instala → Aplica Configuración (TODO EN UNO)
# ============================================================

set +e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="/tmp/dotfiles_setup_$(date +%Y%m%d_%H%M%S).log"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

print_header() {
    clear
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}   ${BOLD}$1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BOLD}▶ $1${NC}"
    echo -e "${DIM}─────────────────────────────────────────────────────────────${NC}"
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
    local yn_hint="[S/n]"
    [ "$default" = "n" ] && yn_hint="[s/N]"

    while true; do
        read -r -p "$(echo -e "${YELLOW}?${NC} $prompt $yn_hint: ")" answer
        answer="${answer:-$default}"
        case "$answer" in
            [SsYy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Por favor responde sí (s) o no (n)." ;;
        esac
    done
}

# ============================================================
# FASE 1: BIENVENIDA Y VALIDACIÓN
# ============================================================

print_header "🚀 Dotfiles Arch Linux - Setup Completo"

echo -e "${BOLD}Bienvenido al instalador de Dotfiles${NC}"
echo ""
print_info "Este script hará TODO:"
echo "  1. ✅ Verifica que todo está descargado correctamente"
echo "  2. ✅ Instala paquetes (tú decides cuáles)"
echo "  3. ✅ Aplica configuración automáticamente"
echo "  4. ✅ Configura Git, shell, terminal y todo"
echo ""
print_info "Tiempo estimado: 30-45 minutos"
print_info "Se crearán backups de tu configuración anterior"
echo ""

if ! ask_yes_no "¿Deseas continuar?"; then
    print_info "Cancelado."
    exit 0
fi

# ============================================================
# FASE 2: VALIDACIÓN DE DESCARGA
# ============================================================

print_header "FASE 1: Validando Descarga"

CRITICAL_FILES=(
    "install.sh"
    ".zshrc"
    ".zprofile"
    ".gitconfig"
    ".config/starship.toml"
    "scripts"
)

MISSING=0
for file in "${CRITICAL_FILES[@]}"; do
    if [ -e "$DOTFILES_DIR/$file" ]; then
        print_success "Encontrado: $file"
    else
        print_error "FALTA: $file"
        ((MISSING++))
    fi
done

echo ""

if [ $MISSING -gt 0 ]; then
    print_error "Faltan $MISSING archivos críticos. Descarga incompleta."
    exit 1
fi

print_success "✅ Todos los archivos están presentes"
echo ""

# Cuenta archivos totales
TOTAL_FILES=$(find "$DOTFILES_DIR" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$DOTFILES_DIR" | cut -f1)
print_info "Total: $TOTAL_FILES archivos, $TOTAL_SIZE"

read -p "Presiona Enter para continuar..."

# ============================================================
# FASE 3: INSTALACIÓN DE PAQUETES
# ============================================================

print_header "FASE 2: Instalación de Paquetes"

echo -e "${BOLD}Ejecutando instalador interactivo...${NC}"
echo ""
print_info "Responde a cada pregunta según lo que desees instalar"
print_info "Cada opción incluye una descripción clara"
echo ""

read -p "Presiona Enter para iniciar el instalador..."

# Ejecuta el instalador original
chmod +x "$DOTFILES_DIR/install.sh"
"$DOTFILES_DIR/install.sh" | tee -a "$LOG_FILE"

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    print_warning "El instalador se interrumpió. Puedes volver a ejecutar más tarde."
fi

# ============================================================
# FASE 4: APLICACIÓN DE CONFIGURACIÓN
# ============================================================

print_header "FASE 3: Aplicando Configuración"

print_section "Creando backups de configuración anterior"

# Crea backups si es necesario
ROOT_FILES=(.zshrc .zprofile .gitconfig .gitignore_global .ripgreprc .editorconfig .tool-versions .bashrc)

for f in "${ROOT_FILES[@]}"; do
    if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$HOME/$f" "$BACKUP_DIR/"
        print_info "Backup: $f"
    fi
done

if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR")" ]; then
    print_success "Backups guardados en: $BACKUP_DIR"
else
    print_info "No se requirieron backups (archivos nuevos)"
fi

echo ""
print_section "Creando enlaces simbólicos (symlinks)"

# Enlaza archivos raíz
for f in "${ROOT_FILES[@]}"; do
    if [ -f "$DOTFILES_DIR/$f" ]; then
        [ -L "$HOME/$f" ] && rm "$HOME/$f"
        ln -sf "$DOTFILES_DIR/$f" "$HOME/$f"
        print_success "Enlace: ~/$f"
    fi
done

# Enlaza .config
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
        [ -L "$HOME/.config/$item" ] && rm "$HOME/.config/$item"
        ln -sf "$DOTFILES_DIR/.config/$item" "$HOME/.config/$item"
        print_success "Enlace: ~/.config/$item"
    fi
done

echo ""
print_section "Configurando servicios y permisos"

# Permisos de scripts
chmod +x "$DOTFILES_DIR/scripts/"* "$DOTFILES_DIR/install.sh" 2>/dev/null || true
print_success "Permisos de scripts configurados"

# Systemd services
if [ -d "$DOTFILES_DIR/.config/systemd/user" ]; then
    mkdir -p "$HOME/.config/systemd/user"
    cp "$DOTFILES_DIR/.config/systemd/user/"*.{timer,service} "$HOME/.config/systemd/user/" 2>/dev/null || true
    systemctl --user daemon-reload 2>/dev/null || true
    print_success "Servicios systemd instalados"
fi

# Lanzadores .desktop
APPS_DIR="$HOME/.local/share/applications"
mkdir -p "$APPS_DIR"
if [ -d "$DOTFILES_DIR/.local/share/applications" ]; then
    cp "$DOTFILES_DIR/.local/share/applications/"*.desktop "$APPS_DIR/" 2>/dev/null || true
    print_success "Lanzadores .desktop instalados"
fi

# Git hooks
if cd "$DOTFILES_DIR" && [ -d .githooks ]; then
    git config core.hooksPath .githooks 2>/dev/null || true
    chmod +x .githooks/* 2>/dev/null || true
    print_success "Git hooks activados"
fi

# .zshrc.local
if [ ! -f "$HOME/.zshrc.local" ] && [ -f "$DOTFILES_DIR/.zshrc.local.example" ]; then
    cp "$DOTFILES_DIR/.zshrc.local.example" "$HOME/.zshrc.local"
    print_success "Creado: ~/.zshrc.local"
fi

# ============================================================
# FASE 5: RESUMEN Y PRÓXIMOS PASOS
# ============================================================

print_header "✅ CONFIGURACIÓN COMPLETADA"

echo -e "${BOLD}¿Qué se instaló y configuró?${NC}"
echo ""
echo "  ✅ Shell Zsh + Oh My Zsh + Plugins"
echo "  ✅ Starship Prompt (git integrado)"
echo "  ✅ Nerd Fonts con iconos"
echo "  ✅ Herramientas CLI modernas"
echo "  ✅ Git configurado globalmente"
echo "  ✅ Neovim personalizado"
echo "  ✅ KDE Plasma 6 personalizado"
echo "  ✅ Tema Catppuccin Mocha en todo"
echo ""

echo -e "${BOLD}Próximos pasos:${NC}"
echo ""
echo "  1️⃣  ${YELLOW}IMPORTANTE: Reinicia tu sesión${NC}"
echo "     Ejecuta: ${CYAN}exit${NC} o presiona Ctrl+D"
echo "     Vuelve a loguear normalmente"
echo ""
echo "  2️⃣  Verifica que todo funciona:"
echo "     ${CYAN}$DOTFILES_DIR/scripts/check-dependencies${NC}"
echo ""
echo "  3️⃣  Si usas KDE, personaliza más:"
echo "     ${CYAN}$DOTFILES_DIR/scripts/setup-kde.sh${NC}"
echo ""
echo "  4️⃣  Descarga wallpapers 4K (opcional):"
echo "     ${CYAN}$DOTFILES_DIR/scripts/download-wallpapers.sh${NC}"
echo ""
echo "  5️⃣  Lee los atajos de teclado:"
echo "     ${CYAN}cat $DOTFILES_DIR/README.md${NC}"
echo ""

if [ -f "$LOG_FILE" ]; then
    echo -e "${DIM}Log guardado en: $LOG_FILE${NC}"
fi

echo ""
print_success "¡Tu entorno está configurado! 🚀"
echo ""
read -p "Presiona Enter para terminar..."
