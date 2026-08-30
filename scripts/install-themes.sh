#!/usr/bin/env bash
# ============================================================
# Script de Personalización Visual para Arch Linux + KDE Plasma
# Temas Catppuccin Mocha, Kvantum, Klassy, Iconos, Cursores, SDDM y GRUB
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

print_header "Personalización Visual — Arch Linux + KDE Plasma"
echo -e "Sistema detectado: ${GREEN}$PRETTY_NAME${NC}"
echo ""
echo "Este script instala motores de temas, decoraciones, iconos, cursores y fondos."
echo "En cada paso se detalla exactamente qué función cumple cada componente visual."
echo ""
echo -e "${YELLOW}─────────────────────────────────────────────────────${NC}"

# ============================================================
# MOTORES VISUALES Y DECORACIONES (KVANTUM + KLASSY)
# ============================================================

print_header "1. Motores Gráficos y Decoración de Ventanas"

INSTALL_KVANTUM=false
if ask_install "Kvantum Engine + Tema Catppuccin Mocha" \
    "¿Qué hace?: Motor de renderizado basado en SVG para aplicaciones Qt.\n   Añade transparencias, desenfoque (blur) y estilo Catppuccin consistente a Dolphin, Kate y ajustes."; then
    INSTALL_KVANTUM=true
    aur_install kvantum kvantum-theme-catppuccin-git
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
if ask_install "Rofi-Wayland (Lanzador Rápido)" \
    "¿Qué hace?: Lanzador de aplicaciones modal ultra-rápido compatible con Wayland.\n   Alternativa ligera y minimalista para abrir apps y comandos rápidamente." "n"; then
    INSTALL_ROFI=true
    pkg_install rofi-wayland
    print_success "Rofi-Wayland instalado"
fi

INSTALL_SPICETIFY=false
if ask_install "Spicetify CLI (Spotify con Catppuccin Mocha)" \
    "¿Qué hace?: Modificador de la interfaz del cliente oficial de Spotify para inyectar\n   la paleta de colores Catppuccin Mocha y extensiones de reproducción." "n"; then
    INSTALL_SPICETIFY=true
    aur_install spicetify-cli
    print_success "Spicetify instalado desde AUR"
fi

# ============================================================
# ICONOS
# ============================================================

print_header "2. Paquetes de Iconos"

INSTALL_PAPIRUS=false
if ask_install "Papirus Icon Theme (Dark)" \
    "¿Qué hace?: Iconos planos y modernos con soporte para miles de aplicaciones.\n   La versión Dark ofrece contraste ideal con fondos oscuros como Catppuccin."; then
    INSTALL_PAPIRUS=true
    pkg_install papirus-icon-theme
    print_success "Papirus instalado"
fi

INSTALL_TELA=false
if ask_install "Tela Circle Icon Theme (Dark)" \
    "¿Qué hace?: Iconos circulares con estilo Material Design y paletas oscuras.\n   Alternativa estética para quienes prefieren iconos redondeados." "n"; then
    INSTALL_TELA=true
    aur_install tela-circle-icon-theme-dark
    print_success "Tela Circle instalado desde AUR"
fi

INSTALL_CATPPUCCIN_ICONS=false
if ask_install "Catppuccin Icons" \
    "¿Qué hace?: Iconos oficiales de la comunidad Catppuccin adaptados a la paleta Mocha." "n"; then
    INSTALL_CATPPUCCIN_ICONS=true
    aur_install catppuccin-icons-git
    print_success "Catppuccin Icons instalado desde AUR"
fi

# ============================================================
# CURSORES
# ============================================================

print_header "3. Temas de Cursores"

INSTALL_CATPPUCCIN_CURSORS=false
if ask_install "Catppuccin Cursors (Mocha Dark)" \
    "¿Qué hace?: Tema de puntero del ratón con diseño limpio y los acentos de color de Catppuccin."; then
    INSTALL_CATPPUCCIN_CURSORS=true
    aur_install catppuccin-cursors-mocha || aur_install catppuccin-cursors-git
    print_success "Catppuccin Cursors instalado"
fi

INSTALL_BIBATA=false
if ask_install "Bibata Modern Dark Cursors" \
    "¿Qué hace?: Cursores redondeados de alta visibilidad con borde nítido y acentos modernos." "n"; then
    INSTALL_BIBATA=true
    aur_install bibata-cursor-theme
    print_success "Bibata Cursors instalado desde AUR"
fi

# ============================================================
# TEMAS DE VENTANAS Y GTK
# ============================================================

print_header "4. Temas de Plasma y Aplicaciones GTK"

INSTALL_CATPPUCCIN_KWIN=false
if ask_install "Catppuccin Plasma Look & Feel (Mocha)" \
    "¿Qué hace?: Aplica el esquema de colores global, pantalla de bloqueo y tema de widgets de Plasma."; then
    INSTALL_CATPPUCCIN_KWIN=true
    aur_install catppuccin-kde-theme-mocha-git
    print_success "Catppuccin KDE Theme instalado"
fi

INSTALL_WHITESUR=false
if ask_install "WhiteSur GTK Theme (Dark)" \
    "¿Qué hace?: Tema oscuro para aplicaciones GTK (GIMP, Inkscape, etc.) asegurando coherencia visual." "n"; then
    INSTALL_WHITESUR=true
    aur_install whitesur-gtk-theme-dark
    print_success "WhiteSur Dark instalado desde AUR"
fi

# ============================================================
# SDDM (Pantalla de Login)
# ============================================================

print_header "5. SDDM — Pantalla de Inicio de Sesión"

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

print_header "6. GRUB — Gestor de Arranque"

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

print_header "7. Fondos de Escritorio Catppuccin"

INSTALL_CATPPUCCIN_WALLPAPERS=false
if ask_install "Catppuccin Wallpapers (4K)" \
    "¿Qué hace?: Colección de fondos de pantalla en alta resolución optimizados para la paleta Mocha."; then
    INSTALL_CATPPUCCIN_WALLPAPERS=true
    aur_install catppuccin-wallpapers-git
    print_info "Fondos disponibles en /usr/share/backgrounds/catppuccin/"
    print_success "Fondos Catppuccin instalados"
fi

# ============================================================
# APLICACIÓN AUTOMÁTICA EN PLASMA
# ============================================================

print_header "8. Aplicar Personalización a KDE Plasma"

APPLY_CATPPUCCIN_PLASMA=false
if ask_install "Aplicar Tema Global Ahora Mismo" \
    "¿Qué hace?: Aplica de forma inmediata la paleta Catppuccin Mocha, cursores y motor Kvantum en Plasma."; then
    APPLY_CATPPUCCIN_PLASMA=true
    
    if command -v plasma-apply-lookandfeel &>/dev/null; then
        plasma-apply-lookandfeel -a Catppuccin-Mocha-Dark 2>/dev/null || true
    fi
    if command -v kvantummanager &>/dev/null; then
        kvantummanager --set Catppuccin-Mocha-Dark 2>/dev/null || true
    fi
    if command -v plasma-apply-cursortheme &>/dev/null; then
        plasma-apply-cursortheme Catppuccin-Mocha-Dark 2>/dev/null || true
    fi
    print_success "Temas aplicados a la sesión actual"
fi

# ============================================================
# Resumen Final
# ============================================================

print_header "Instalación Visual Completada"
echo -e "${GREEN}Componentes configurados:${NC}"
$INSTALL_KVANTUM && echo "  ✅ Kvantum Engine + Tema Catppuccin"
$INSTALL_KLASSY && echo "  ✅ Klassy Window Decoration"
$INSTALL_ROFI && echo "  ✅ Rofi-Wayland"
$INSTALL_SPICETIFY && echo "  ✅ Spicetify CLI"
$INSTALL_PAPIRUS && echo "  ✅ Papirus Icon Theme"
$INSTALL_TELA && echo "  ✅ Tela Circle Icons"
$INSTALL_CATPPUCCIN_ICONS && echo "  ✅ Catppuccin Icons"
$INSTALL_CATPPUCCIN_CURSORS && echo "  ✅ Catppuccin Cursors"
$INSTALL_BIBATA && echo "  ✅ Bibata Cursors"
$INSTALL_CATPPUCCIN_KWIN && echo "  ✅ Catppuccin Look & Feel"
$INSTALL_WHITESUR && echo "  ✅ WhiteSur GTK"
$INSTALL_CATPPUCCIN_SDDM && echo "  ✅ SDDM Catppuccin"
$INSTALL_CATPPUCCIN_GRUB && echo "  ✅ GRUB Catppuccin"
$INSTALL_CATPPUCCIN_WALLPAPERS && echo "  ✅ Wallpapers Catppuccin"

echo ""
echo -e "${PURPLE}¡Disfruta tu entorno visual de KDE Plasma! 🎨🚀${NC}"
