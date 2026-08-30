#!/usr/bin/env bash
# ============================================================
# Script de Personalización Visual Multi-Tema para Arch Linux
# Fuentes Nerd Fonts, Kvantum, Klassy, Iconos, Cursores, SDDM y GRUB
# ============================================================

set -e

# Colores y estilos
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}   ${BOLD}$1${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_info() {
    echo -e "${CYAN}ℹ️   $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️   $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
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

ask_install() {
    local name="$1"
    local desc="$2"
    local default="${3:-y}"

    echo ""
    echo -e "${BOLD}${PURPLE}▶ ${name}${NC}"
    echo -e "${DIM}${desc}${NC}"
    ask_yes_no "¿Deseas instalar/aplicar esta personalización?" "$default"
}

pkg_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

aur_install() {
    if ! command -v yay &>/dev/null; then
        print_error "yay no está instalado. Instalando yay primero..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
    fi
    yay -S --needed --noconfirm "$@"
}

# ============================================================
# Verificar Arch Linux / EndeavourOS
# ============================================================

if [[ ! -f /etc/os-release ]]; then
    print_error "No se pudo detectar la distribución Linux."
    exit 1
fi

source /etc/os-release
if [[ "$ID" != "arch" && "$ID_LIKE" != *"arch"* && "$ID" != "endeavouros" ]]; then
    print_error "Este script está diseñado para Arch Linux / EndeavourOS. Detectado: $ID"
    exit 1
fi

# ============================================================
# Inicio
# ============================================================

print_header "Personalización Visual Multi-Tema — Arch Linux + KDE Plasma"
echo -e "Sistema detectado: ${GREEN}$PRETTY_NAME${NC}"
echo ""
echo "Este script instala la suite completa de fuentes Nerd Fonts, motores de temas,"
echo "esquemas visuales (Catppuccin, Tokyo Night, Nord, Dracula, Gruvbox), iconos y cursores."
echo ""
echo -e "${YELLOW}─────────────────────────────────────────────────────${NC}"

# ============================================================
# FUENTES NERD FONTS
# ============================================================

print_header "1. Suite Completa de Fuentes y Emojis"

INSTALL_FONTS=false
if ask_install "Fuentes de Programación Nerd Fonts + Inter + Emojis" \
    "¿Qué hace?: Instala JetBrainsMono Nerd Font, FiraCode Nerd Font, Cascadia Code,\n   fuente Inter para la interfaz gráfica y Noto Color Emoji para soporte completo de glifos."; then
    INSTALL_FONTS=true
    pkg_install ttf-jetbrains-mono-nerd ttf-fira-code-nerd ttf-cascadia-code-nerd inter-font noto-fonts-emoji
    fc-cache -fv 2>/dev/null || true
    print_success "Fuentes instaladas y caché actualizado"
fi

# ============================================================
# MOTORES VISUALES Y DECORACIONES (KVANTUM + KLASSY)
# ============================================================

print_header "2. Motores Gráficos y Decoración de Ventanas"

INSTALL_KVANTUM=false
if ask_install "Kvantum Engine + Temas SVG (Transparencias y Blur)" \
    "¿Qué hace?: Motor de renderizado basado en SVG para aplicaciones Qt.\n   Añade transparencias, desenfoque (blur) y estilo moderno consistente a Dolphin, Kate y ajustes."; then
    INSTALL_KVANTUM=true
    pkg_install kvantum
    aur_install kvantum-theme-catppuccin-git || true
    print_success "Kvantum y temas instalados"
fi

INSTALL_KLASSY=false
if ask_install "Klassy (Decoración de Ventanas Avanzada)" \
    "¿Qué hace?: Gestor de bordes para KWin que permite redondear las 4 esquinas de las ventanas,\n   personalizar botones (estilo macOS/Breeze) y sombras finas con efecto blur."; then
    INSTALL_KLASSY=true
    aur_install klassy
    print_success "Klassy instalado desde AUR"
fi

INSTALL_ROFI=false
if ask_install "Rofi-Wayland + Selector Dinámico de Temas" \
    "¿Qué hace?: Lanzador modal ultra-rápido compatible con Wayland.\n   Permite abrir aplicaciones y cambiar de tema con Meta+Shift+T."; then
    INSTALL_ROFI=true
    pkg_install rofi-wayland
    print_success "Rofi-Wayland instalado"
fi

INSTALL_SPICETIFY=false
if ask_install "Spicetify CLI (Spotify con Temas)" \
    "¿Qué hace?: Modificador de la interfaz del cliente oficial de Spotify para inyectar\n   la paleta de colores activa y extensiones de reproducción." "n"; then
    INSTALL_SPICETIFY=true
    aur_install spicetify-cli
    print_success "Spicetify instalado desde AUR"
fi

# ============================================================
# ICONOS
# ============================================================

print_header "3. Paquetes de Iconos"

INSTALL_PAPIRUS=false
if ask_install "Papirus Icon Theme (Dark y Light)" \
    "¿Qué hace?: Iconos planos y modernos con soporte para miles de aplicaciones.\n   Incluye variantes Dark y Light para adaptarse al modo día/noche."; then
    INSTALL_PAPIRUS=true
    pkg_install papirus-icon-theme
    print_success "Papirus instalado"
fi

INSTALL_TELA=false
if ask_install "Tela Circle Icon Theme (Dark)" \
    "¿Qué hace?: Iconos circulares con estilo Material Design y acentos Tokyo Night / Nord." "n"; then
    INSTALL_TELA=true
    aur_install tela-circle-icon-theme-dark || aur_install tela-circle-icon-theme-git
    print_success "Tela Circle instalado desde AUR"
fi

INSTALL_NORDZY_ICONS=false
if ask_install "Nordzy Icon Theme" \
    "¿Qué hace?: Set de iconos diseñado específicamente para la paleta Nord." "n"; then
    INSTALL_NORDZY_ICONS=true
    aur_install nordzy-icon-theme || true
    print_success "Nordzy Icons instalado desde AUR"
fi

# ============================================================
# CURSORES
# ============================================================

print_header "4. Temas de Cursores"

INSTALL_CATPPUCCIN_CURSORS=false
if ask_install "Catppuccin Cursors (Mocha & Latte)" \
    "¿Qué hace?: Puntero del ratón en variantes oscura (Mocha) y clara (Latte)."; then
    INSTALL_CATPPUCCIN_CURSORS=true
    aur_install catppuccin-cursors-mocha || aur_install catppuccin-cursors-git || true
    print_success "Catppuccin Cursors instalado"
fi

INSTALL_BIBATA=false
if ask_install "Bibata Modern Cursors (Dark, Ice & Classic)" \
    "¿Qué hace?: Cursores redondeados de alta visibilidad para temas Tokyo Night, Nord y Dracula."; then
    INSTALL_BIBATA=true
    aur_install bibata-cursor-theme
    print_success "Bibata Cursors instalado desde AUR"
fi

INSTALL_CAPITAINE=false
if ask_install "Capitaine Cursors" \
    "¿Qué hace?: Cursores inspirados en macOS ideales para el tema Gruvbox." "n"; then
    INSTALL_CAPITAINE=true
    aur_install capitaine-cursors
    print_success "Capitaine Cursors instalado desde AUR"
fi

# ============================================================
# TEMAS DE VENTANAS Y GTK
# ============================================================

print_header "5. Paquetes Multi-Tema (Catppuccin, Nordic, Tokyo Night, Dracula)"

INSTALL_MULTI_THEMES=false
if ask_install "Instalar paquetes de temas adicionales (Nord, Dracula, Tokyo Night)" \
    "¿Qué hace?: Descarga los esquemas globales y temas GTK para poder alternar entre ellos sin reiniciar."; then
    INSTALL_MULTI_THEMES=true
    aur_install catppuccin-kde-theme-mocha-git nordic-theme-git full-dracula-theme-git tokyonight-gtk-theme-git 2>/dev/null || true
    print_success "Paquetes multi-tema instalados"
fi

# ============================================================
# SDDM (Pantalla de Login)
# ============================================================

print_header "6. SDDM — Pantalla de Inicio de Sesión"

INSTALL_CATPPUCCIN_SDDM=false
if ask_install "Catppuccin SDDM Theme" \
    "¿Qué hace?: Personaliza la pantalla de login con fondo Catppuccin Mocha, reloj elegante y avatar circular."; then
    INSTALL_CATPPUCCIN_SDDM=true
    aur_install sddm-catppuccin-theme-git
    print_info "Configurando SDDM..."
    sudo mkdir -p /etc/sddm.conf.d
    cat > /tmp/sddm-theme.conf << 'EOF'
[Theme]
Current=catppuccin-mocha-sddm
EOF
    sudo mv /tmp/sddm-theme.conf /etc/sddm.conf.d/theme.conf
    print_success "Catppuccin SDDM instalado y configurado"
fi

# ============================================================
# GRUB (Bootloader)
# ============================================================

print_header "7. GRUB — Gestor de Arranque"

INSTALL_CATPPUCCIN_GRUB=false
if ask_install "Catppuccin GRUB Theme" \
    "¿Qué hace?: Tema gráfico para el menú de inicio de GRUB con fuentes e iconos de sistemas operativos." "n"; then
    INSTALL_CATPPUCCIN_GRUB=true
    aur_install catppuccin-grub-theme-git
    print_info "Para activarlo: añade GRUB_THEME=\"/boot/grub/themes/catppuccin-mocha/theme.txt\" a /etc/default/grub"
    print_info "Luego ejecuta: sudo grub-mkconfig -o /boot/grub/grub.cfg"
    print_success "Catppuccin GRUB instalado"
fi

# ============================================================
# FONDOS DE ESCRITORIO
# ============================================================

print_header "8. Colección de Wallpapers Multi-Tema"

INSTALL_WALLPAPERS=false
if ask_install "Descargar Colección de Fondos (Estáticos y Videos)" \
    "¿Qué hace?: Clona fondos 4K categorizados por tema (Catppuccin, Tokyo Night, Nord, Gruvbox) en ~/Imágenes/Wallpapers."; then
    INSTALL_WALLPAPERS=true
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    if [ -f "$DOTFILES_DIR/scripts/download-wallpapers.sh" ]; then
        bash "$DOTFILES_DIR/scripts/download-wallpapers.sh"
    fi
fi

# ============================================================
# Resumen Final
# ============================================================

print_header "Instalación Visual Multi-Tema Completada"
echo -e "${GREEN}Componentes listos para usar:${NC}"
echo -e " • ${BOLD}Selector dinámico:${NC} Pulsa ${CYAN}Meta+Shift+T${NC} o escribe ${CYAN}theme-switch${NC} para cambiar de tema al instante."
echo -e " • ${BOLD}Cambiador de fondos:${NC} Pulsa ${CYAN}Meta+Alt+W${NC} o escribe ${CYAN}wall-next${NC} para rotar wallpapers."
echo ""
echo -e "${PURPLE}¡Disfruta tu nuevo entorno visual personalizable! 🎨🚀${NC}"
