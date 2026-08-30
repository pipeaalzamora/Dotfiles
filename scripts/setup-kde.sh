#!/usr/bin/env bash
# ============================================================
# Script de Automatización y Personalización para KDE Plasma 6
# Repositorio: pipeaalzamora/Dotfiles
# Paleta: Catppuccin Mocha | Motor: Kvantum + Klassy
# ============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config"

# Colores y formato
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
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}   ${BOLD}$1${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo ""
    echo -e "${PURPLE}────────────────────────────────────────────────────────────${NC}"
    echo -e "${BOLD}${CYAN}▶ $1${NC}"
    echo -e "${DIM}$2${NC}"
    echo -e "${PURPLE}────────────────────────────────────────────────────────────${NC}"
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

# ============================================================
# Inicio
# ============================================================
print_header "Personalización de KDE Plasma 6 — Catppuccin Mocha"
echo -e "Este script configurará tu entorno de escritorio KDE Plasma paso a paso."
echo -e "En cada paso se explicará ${BOLD}qué hace cada personalización${NC} antes de aplicarla."
echo ""

# ------------------------------------------------------------
# PASO 1: Motores Visuales y Temas de Sistema
# ------------------------------------------------------------
print_step "Paso 1: Motores Visuales y Decoraciones de Ventana" \
"¿Qué hace esta personalización?\n\
 • Kvantum Engine: Motor SVG para aplicaciones Qt que permite transparencias y efecto blur real.\n\
 • Klassy: Gestor avanzado de bordes de ventana con esquinas redondeadas ajustables y botones modernos.\n\
 • Tema Catppuccin Mocha: Paleta oscura oficial para ventanas, paneles y aplicaciones Qt/KDE.\n\
 • Iconos Papirus Dark: Set completo de iconos adaptado a temas oscuros."

if ask_yes_no "¿Deseas instalar Kvantum, Klassy, temas e iconos?"; then
    if command -v yay &>/dev/null; then
        print_info "Instalando paquetes desde repositorios oficiales y AUR..."
        yay -S --needed --noconfirm \
            kvantum \
            kvantum-theme-catppuccin-git \
            catppuccin-kde-theme-mocha-git \
            catppuccin-cursors-mocha \
            papirus-icon-theme \
            klassy
        print_success "Motores visuales y temas instalados."
    else
        print_error "AUR helper (yay) no detectado. Instala los paquetes manualmente."
    fi
fi

# ------------------------------------------------------------
# PASO 2: Herramientas Opcionales (Rofi y Spicetify)
# ------------------------------------------------------------
print_step "Paso 2: Lanzador Rofi-Wayland y Personalizador Spotify" \
"¿Qué hace esta personalización?\n\
 • Rofi-Wayland: Lanzador de aplicaciones ultra-rápido, ligero y altamente personalizable.\n\
 • Spicetify-CLI: Herramienta de línea de comandos para aplicar Catppuccin Mocha al cliente de Spotify."

if ask_yes_no "¿Deseas instalar Rofi-wayland y Spicetify-cli?" "y"; then
    if command -v yay &>/dev/null; then
        yay -S --needed --noconfirm rofi-wayland spicetify-cli
        print_success "Rofi-wayland y Spicetify instalados."
    fi
fi

# ------------------------------------------------------------
# PASO 3: Variables de Entorno del Sistema (systemd / Wayland)
# ------------------------------------------------------------
print_step "Paso 3: Integración de Kvantum en el Sistema" \
"¿Qué hace esta personalización?\n\
 • Configura ~/.config/environment.d/qt.conf con QT_STYLE_OVERRIDE=kvantum.\n\
 • Garantiza que todas las aplicaciones Qt (Dolphin, Kate, Ajustes) usen Kvantum bajo Wayland y systemd."

mkdir -p "$CONFIG_DIR/environment.d" "$CONFIG_DIR/Kvantum"
if [ -f "$DOTFILES_DIR/.config/environment.d/qt.conf" ]; then
    cp "$DOTFILES_DIR/.config/environment.d/qt.conf" "$CONFIG_DIR/environment.d/qt.conf"
    print_success "Variables de entorno Qt/Kvantum configuradas en ~/.config/environment.d/qt.conf"
fi

# ------------------------------------------------------------
# PASO 4: Enlace de Archivos de Configuración de KDE
# ------------------------------------------------------------
print_step "Paso 4: Persistencia de Ajustes de KDE Plasma" \
"¿Qué hace esta personalización?\n\
 • kdeglobals: Aplica la paleta Catppuccin Mocha, fuentes y tema de iconos Papirus-Dark.\n\
 • kglobalshortcutsrc: Configura atajos de teclado rápidos (Meta+Return para Kitty, Meta+Shift+S para captura, etc.).\n\
 • kwinrc: Habilita desenfoque (blur), bordes limpios y comportamiento fluido de ventanas.\n\
 • Kvantum/kvantum.kvconfig: Asigna el tema Catppuccin-Mocha-Dark dentro del motor Kvantum."

KDE_CONFIGS=("kdeglobals" "kglobalshortcutsrc" "kwinrc")

for config in "${KDE_CONFIGS[@]}"; do
    if [ -f "$DOTFILES_DIR/.config/$config" ]; then
        [ -f "$CONFIG_DIR/$config" ] && cp "$CONFIG_DIR/$config" "$CONFIG_DIR/$config.bak"
        cp "$DOTFILES_DIR/.config/$config" "$CONFIG_DIR/$config"
        print_success "Configuración aplicada: ~/.config/$config (respaldo guardado en .bak)"
    fi
done

if [ -f "$DOTFILES_DIR/.config/Kvantum/kvantum.kvconfig" ]; then
    cp "$DOTFILES_DIR/.config/Kvantum/kvantum.kvconfig" "$CONFIG_DIR/Kvantum/kvantum.kvconfig"
    print_success "Configuración de Kvantum aplicada: ~/.config/Kvantum/kvantum.kvconfig"
fi

# ------------------------------------------------------------
# PASO 5: Aplicación en Vivo de Temas con Herramientas Nativas
# ------------------------------------------------------------
print_step "Paso 5: Aplicar Esquema Global y Cursores Activos" \
"¿Qué hace esta personalización?\n\
 • Invoca plasma-apply-lookandfeel y plasma-apply-cursortheme para aplicar Catppuccin inmediatamente.\n\
 • Establece Catppuccin-Mocha-Dark como perfil activo en Kvantum."

if command -v kvantummanager &>/dev/null; then
    kvantummanager --set Catppuccin-Mocha-Dark 2>/dev/null || true
    print_info "Tema activo de Kvantum establecido en Catppuccin-Mocha-Dark"
fi

if command -v plasma-apply-lookandfeel &>/dev/null; then
    plasma-apply-lookandfeel -a Catppuccin-Mocha-Dark 2>/dev/null || true
    print_info "Tema global de Plasma aplicado"
fi

if command -v plasma-apply-cursortheme &>/dev/null; then
    plasma-apply-cursortheme Catppuccin-Mocha-Dark 2>/dev/null || \
    plasma-apply-cursortheme catppuccin-mocha-dark-cursors 2>/dev/null || true
    print_info "Tema de cursores Catppuccin aplicado"
fi

# ------------------------------------------------------------
# PASO 6: Recarga de Servicios de Plasma
# ------------------------------------------------------------
print_step "Paso 6: Recarga Segura del Entorno Gráfico" \
"¿Qué hace esta personalización?\n\
 • Reinicia el servicio systemd de Plasmashell para refrescar paneles y widgets sin cerrar tu sesión.\n\
 • Solicita a KWin reconfigurar sus reglas visuales."

if systemctl --user is-active --quiet plasma-plasmashell.service 2>/dev/null; then
    systemctl --user restart plasma-plasmashell.service 2>/dev/null || true
    print_success "Plasmashell reiniciado limpiamente vía systemd."
elif pgrep -x "plasmashell" > /dev/null; then
    kquitapp6 plasmashell 2>/dev/null || true
    kstart plasmashell >/dev/null 2>&1 &
    print_success "Plasmashell reiniciado."
fi

if command -v qdbus &>/dev/null; then
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
fi

print_header "¡KDE Plasma Personalizado con Éxito!"
echo -e "${GREEN}Resumen de mejoras aplicadas:${NC}"
echo -e " • ${BOLD}Kvantum & Qt:${NC} Transparencias y blur activo con Catppuccin Mocha."
echo -e " • ${BOLD}Klassy:${NC} Bordes de ventana con esquinas redondeadas y botones personalizables."
echo -e " • ${BOLD}Atajos:${NC} Meta+Return (Kitty), Meta+Shift+S (Spectacle), Meta+C (Cerrar)."
echo -e " • ${BOLD}Tip adicional:${NC} En la tienda de widgets de KDE busca ${CYAN}'Panel Colorizer'${NC} para personalizar la barra de tareas en islas flotantes."
echo ""