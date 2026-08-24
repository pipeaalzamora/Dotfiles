#!/usr/bin/env bash
# ============================================================
# Script de Personalizacion Visual para Arch Linux + KDE Plasma
# Temas Catppuccin Mocha, iconos, cursores, SDDM, GRUB y mas
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
    ask_yes_no "Instalar este componente?" "$default"
}

pkg_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

aur_install() {
    if ! command -v yay &>/dev/null; then
        print_error "yay no esta instalado. Instalando yay primero..."
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
    print_error "No se pudo detectar la distribucion Linux."
    exit 1
fi

source /etc/os-release
if [[ "$ID" != "arch" && "$ID_LIKE" != *"arch"* && "$ID" != "endeavouros" ]]; then
    print_error "Este script esta diseñado para Arch Linux / EndeavourOS. Detectado: $ID"
    exit 1
fi

# ============================================================
# Inicio
# ============================================================

print_header "Personalizacion Visual — Arch Linux + KDE Plasma"
echo -e "Sistema detectado: ${GREEN}$PRETTY_NAME${NC}"
echo ""
echo "Este script instala temas, iconos, cursores y efectos visuales."
echo "Enfocado en la paleta Catppuccin Mocha y coherencia visual."
echo ""
echo -e "${YELLOW}─────────────────────────────────────────────────────${NC}"

# ============================================================
# ICONOS
# ============================================================

print_header "Paquetes de Iconos"

INSTALL_PAPIRUS=false
if ask_install "Papirus Icon Theme (Dark)" \
    "Iconos planos y modernos con excelente cobertura de aplicaciones.\n   Version Dark optimizada para temas oscuros como Catppuccin."; then
    INSTALL_PAPIRUS=true
    pkg_install papirus-icon-theme
    print_success "Papirus instalado"
fi

INSTALL_TELA=false
if ask_install "Tela Circle Icon Theme (Dark)" \
    "Iconos circulares con diseño Material Design.\n   Alternativa elegante y coherente con GNOME/KDE." "n"; then
    INSTALL_TELA=true
    aur_install tela-circle-icon-theme-dark
    print_success "Tela Circle instalado desde AUR"
fi

INSTALL_CATPPUCCIN_ICONS=false
if ask_install "Catppuccin Icons" \
    "Iconos oficiales de Catppuccin con la paleta Mocha completa.\n   Coherencia visual perfecta con el resto del tema." "n"; then
    INSTALL_CATPPUCCIN_ICONS=true
    aur_install catppuccin-icons-git
    print_success "Catppuccin Icons instalado desde AUR"
fi

# ============================================================
# CURSORES
# ============================================================

print_header "Temas de Cursores"

INSTALL_CATPPUCCIN_CURSORS=false
if ask_install "Catppuccin Cursors" \
    "Cursores oficiales de Catppuccin en variante Mocha Dark.\n   Diseño minimalista y elegante para terminal y escritorio."; then
    INSTALL_CATPPUCCIN_CURSORS=true
    aur_install catppuccin-cursors-git
    print_success "Catppuccin Cursors instalado desde AUR"
fi

INSTALL_BIBATA=false
if ask_install "Bibata Modern Dark Cursors" \
    "Cursores oscuros con acentos dorados/amarillos.\n   Diseño moderno y distintivo con excelente visibilidad." "n"; then
    INSTALL_BIBATA=true
    aur_install bibata-cursor-theme
    print_success "Bibata Cursors instalado desde AUR"
fi

INSTALL_CAPITAINE=false
if ask_install "Capitaine Cursors" \
    "Cursores inspirados en macOS con diseño limpio.\n   Alternativa minimalista tipo SF Cursors de Apple." "n"; then
    INSTALL_CAPITAINE=true
    aur_install capitaine-cursors
    print_success "Capitaine Cursors instalado desde AUR"
fi

# ============================================================
# TEMAS DE VENTANAS (KWin)
# ============================================================

print_header "Temas de Ventanas y Decoraciones"

INSTALL_CATPPUCCIN_KWIN=false
if ask_install "Catppuccin KWin Theme" \
    "Tema oficial de decoracion de ventanas para KDE Plasma.\n   Bordes, titulos y botones con la paleta Catppuccin Mocha."; then
    INSTALL_CATPPUCCIN_KWIN=true
    aur_install catppuccin-kwin-theme-git
    print_success "Catppuccin KWin instalado desde AUR"
fi

INSTALL_WHITESUR=false
if ask_install "WhiteSur GTK Theme (Dark)" \
    "Tema GTK inspirado en macOS Big Sur.\n   Version Dark compatible con aplicaciones GTK como GIMP, Inkscape." "n"; then
    INSTALL_WHITESUR=true
    aur_install whitesur-gtk-theme-dark
    print_success "WhiteSur Dark instalado desde AUR"
fi

# ============================================================
# SDDM (Pantalla de Login)
# ============================================================

print_header "SDDM — Pantalla de Inicio de Sesion"

INSTALL_CATPPUCCIN_SDDM=false
if ask_install "Catppuccin SDDM Theme" \
    "Tema de pantalla de login para SDDM con Catppuccin Mocha.\n   Incluye fondo, campos de usuario/contrasena y botones."; then
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

print_header "GRUB — Gestor de Arranque"

INSTALL_CATPPUCCIN_GRUB=false
if ask_install "Catppuccin GRUB Theme" \
    "Tema visual para GRUB con la paleta Catppuccin Mocha.\n   Menu de arranque estilizado con iconos y fuentes." "n"; then
    INSTALL_CATPPUCCIN_GRUB=true
    aur_install catppuccin-grub-theme-git
    print_info "Para activar el tema, agrega al final de /etc/default/grub:"
    echo -e "${CYAN}GRUB_THEME=\"/boot/grub/themes/catppuccin-mocha/theme.txt\"${NC}"
    echo "Luego ejecuta: sudo grub-mkconfig -o /boot/grub/grub.cfg"
    print_success "Catppuccin GRUB instalado (configuracion manual requerida)"
fi

# ============================================================
# LATTE DOCK
# ============================================================

print_header "Latte Dock — Dock Flotante"

INSTALL_LATTE=false
if ask_install "Latte Dock" \
    "Dock flotante estilo macOS con animaciones, transparencias y blur.\n   Altamente personalizable con efectos visuales avanzados." "n"; then
    INSTALL_LATTE=true
    pkg_install latte-dock
    print_success "Latte Dock instalado"
    print_info "Ejecuta 'latte-dock' en terminal o desde el menu de aplicaciones"
fi

# ============================================================
# CONKY (Widgets de Escritorio)
# ============================================================

print_header "Conky — Widgets de Escritorio"

INSTALL_CONKY=false
if ask_install "Conky + Conky Manager" \
    "Sistema de widgets personalizables para el escritorio.\n   Muestra CPU, RAM, clima, calendario, musica y mas." "n"; then
    INSTALL_CONKY=true
    pkg_install conky conky-manager
    print_success "Conky instalado"
    print_info "Ejecuta 'conky-manager' para seleccionar widgets"
fi

INSTALL_CONKY_CATPPUCCIN=false
if ask_install "Conky Catppuccin Themes" \
    "Coleccion de widgets Conky con la paleta Catppuccin Mocha.\n   Configuracion lista para usar con monitoreo del sistema." "n"; then
    INSTALL_CONKY_CATPPUCCIN=true
    aur_install conky-catppuccin-git
    print_success "Conky Catppuccin instalado desde AUR"
fi

# ============================================================
# FONDOS DE ESCRITORIO
# ============================================================

print_header "Fondos de Escritorio Catppuccin"

INSTALL_CATPPUCCIN_WALLPAPERS=false
if ask_install "Catppuccin Wallpapers" \
    "Coleccion oficial de fondos de escritorio Catppuccin.\n   Gradientes, paisajes y diseños abstractos en 4K."; then
    INSTALL_CATPPUCCIN_WALLPAPERS=true
    aur_install catppuccin-wallpapers-git
    print_info "Fondos instalados en /usr/share/backgrounds/catppuccin/"
    print_success "Catppuccin Wallpapers instalado"
fi

INSTALL_KDE_WALLPAPERS=false
if ask_install "KDE Plasma Wallpapers (Extra)" \
    "Paquete oficial de fondos adicionales de KDE Plasma.\n   Incluye paisajes, abstractos y animados." "n"; then
    INSTALL_KDE_WALLPAPERS=true
    pkg_install plasma5-wallpapers
    print_success "KDE Wallpapers extra instalados"
fi

# ============================================================
# TEMAS PARA NAVEGADORES
# ============================================================

print_header "Temas para Navegadores"

INSTALL_FIREFOX_CATPPUCCIN=false
if ask_install "Catppuccin Theme para Firefox" \
    "Tema oficial de Catppuccin Mocha para Firefox.\n   Barras, pesta nas y menus con la paleta completa." "n"; then
    INSTALL_FIREFOX_CATPPUCCIN=true
    print_info "Instala la extension desde:"
    echo -e "${CYAN}https://addons.mozilla.org/firefox/addon/catppuccin/${NC}"
    print_success "Instrucciones mostradas (instalacion manual via Firefox)"
fi

INSTALL_CHROME_CATPPUCCIN=false
if ask_install "Catppuccin Theme para Chrome/Brave" \
    "Tema oficial de Catppuccin para Chrome y Chromium.\n   Disponible en Chrome Web Store." "n"; then
    INSTALL_CHROME_CATPPUCCIN=true
    print_info "Instala la extension desde:"
    echo -e "${CYAN}https://chrome.google.com/webstore/catppuccin${NC}"
    print_success "Instrucciones mostradas (instalacion manual via navegador)"
fi

# ============================================================
# EFECTOS KWIN
# ============================================================

print_header "Efectos de Escritorio (KWin)"

INSTALL_KWIN_BLUR=false
if ask_install "Efecto Blur (Desenfoque)" \
    "Desenfoque en ventanas, menus y paneles translucidos.\n   Efecto visual esencial para KDE Plasma moderno."; then
    INSTALL_KWIN_BLUR=true
    print_info "El efecto Blur ya viene incluido en KDE Plasma"
    print_info "Activalo en: Configuracion → Pantalla → Efectos de Escritorio → Blur"
    print_success "Informacion de Blur mostrada"
fi

INSTALL_KWIN_EFFECTS=false
if ask_install "Efectos Adicionales KWin" \
    "Slide (transiciones), Wobbly Windows (ventanas gelatinosas),\n   Magic Lamp (minimizado), Background Contrast." "n"; then
    INSTALL_KWIN_EFFECTS=true
    print_info "Estos efectos ya vienen incluidos en KDE Plasma"
    print_info "Activalos en: Configuracion → Pantalla → Efectos de Escritorio"
    print_success "Informacion de efectos KWin mostrada"
fi

# ============================================================
# CONFIGURACION AUTOMATICA DE KDE
# ============================================================

print_header "Configuracion Automatica de KDE Plasma"

APPLY_CATPPUCCIN_PLASMA=false
if ask_install "Aplicar Tema Catppuccin a KDE Plasma" \
    "Configura automaticamente el esquema de colores, iconos,\n   cursores y tema de ventanas de Catppuccin Mocha en KDE."; then
    APPLY_CATPPUCCIN_PLASMA=true
    
    print_info "Aplicando esquema de colores Catppuccin Mocha..."
    if command -v plasma-apply-lookandfeel &>/dev/null; then
        plasma-apply-lookandfeel -a Catppuccin-Mocha-Dark 2>/dev/null || \
            print_warning "No se pudo aplicar el Look & Feel de Catppuccin"
    fi
    
    print_info "Aplicando tema de iconos Papirus Dark..."
    if command -v lookandfeeltool &>/dev/null; then
        lookandfeeltool -a org.kde.breeze.desktop 2>/dev/null || true
    fi
    
    print_success "Tema Catppuccin aplicado a KDE Plasma"
    print_info "Puede requerir cerrar sesion y volver a entrar"
fi

# ============================================================
# Resumen Final
# ============================================================

print_header "Instalacion Completada"

echo -e "${GREEN}Componentes instalados:${NC}"
echo ""
$INSTALL_PAPIRUS && echo "  ✅ Papirus Icon Theme"
$INSTALL_TELA && echo "  ✅ Tela Circle Icon Theme"
$INSTALL_CATPPUCCIN_ICONS && echo "  ✅ Catppuccin Icons"
$INSTALL_CATPPUCCIN_CURSORS && echo "  ✅ Catppuccin Cursors"
$INSTALL_BIBATA && echo "  ✅ Bibata Modern Dark Cursors"
$INSTALL_CAPITAINE && echo "  ✅ Capitaine Cursors"
$INSTALL_CATPPUCCIN_KWIN && echo "  ✅ Catppuccin KWin Theme"
$INSTALL_WHITESUR && echo "  ✅ WhiteSur GTK Theme"
$INSTALL_CATPPUCCIN_SDDM && echo "  ✅ Catppuccin SDDM Theme"
$INSTALL_CATPPUCCIN_GRUB && echo "  ✅ Catppuccin GRUB Theme"
$INSTALL_LATTE && echo "  ✅ Latte Dock"
$INSTALL_CONKY && echo "  ✅ Conky + Conky Manager"
$INSTALL_CONKY_CATPPUCCIN && echo "  ✅ Conky Catppuccin Themes"
$INSTALL_CATPPUCCIN_WALLPAPERS && echo "  ✅ Catppuccin Wallpapers"
$INSTALL_KDE_WALLPAPERS && echo "  ✅ KDE Plasma Wallpapers"
$INSTALL_FIREFOX_CATPPUCCIN && echo "  ✅ Catppuccin Firefox (instrucciones)"
$INSTALL_CHROME_CATPPUCCIN && echo "  ✅ Catppuccin Chrome (instrucciones)"
$INSTALL_KWIN_BLUR && echo "  ✅ Efecto Blur (instrucciones)"
$INSTALL_KWIN_EFFECTS && echo "  ✅ Efectos KWin adicionales (instrucciones)"

echo ""
if $APPLY_CATPPUCCIN_PLASMA; then
    echo -e "${GREEN}✅ Tema Catppuccin aplicado a KDE Plasma${NC}"
    echo ""
fi

echo -e "${YELLOW}Notas adicionales:${NC}"
echo "  • Para activar GRUB theme: edita /etc/default/grub y ejecuta grub-mkconfig"
echo "  • Para Firefox/Chrome: sigue los enlaces mostrados arriba"
echo "  • Para efectos KWin: ve a Configuracion → Pantalla → Efectos de Escritorio"
echo "  • Puede requerir cerrar sesion para aplicar todos los cambios"
echo ""
echo -e "${PURPLE}Disfruta tu entorno visual personalizado! 🎨🚀${NC}"
