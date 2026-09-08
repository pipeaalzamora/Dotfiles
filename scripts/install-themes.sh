#!/usr/bin/env bash
#
# install-themes.sh — Instala temas e iconos populares para KDE Plasma
#
# Uso:
#   install-themes.sh [--all] [--catppuccin] [--kvantum] [--icon-themes] [--cursor-themes]
#
# Si no se especifica ninguna opción, muestra un menú interactivo.

set -euo pipefail

# ============================================================
# Colores para salida
# ============================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log() { echo -e "${BLUE}[install-themes]${NC} $*"; }
info() { echo -e "${GREEN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
die() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }
header() { echo -e "\n${CYAN}==>${NC} $*"; }

# ============================================================
# Detectar distribución
# ============================================================
detect_distro() {
    if [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/fedora-release ]]; then
        echo "fedora"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/opensuse-release ]] || [[ -f /etc/SuSE-release ]]; then
        echo "opensuse"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)
log "DistribuciÃ³n detectada: $DISTRO"

# ============================================================
# Funciones de instalaciÃ³n
# ============================================================

# -------------------------------------------------------------
# Catppuccin Kvantum
# -------------------------------------------------------------
install_catppuccin_kvantum() {
    header "Instalando Catppuccin Kvantum..."

    if [[ "$DISTRO" == "arch" ]]; then
        if command -v yay >/dev/null 2>&1; then
            yay -S kvantum-theme-catppuccin-git --noconfirm
        elif command -v paru >/dev/null 2>&1; then
            paru -S kvantum-theme-catppuccin-git --noconfirm
        else
            warn "No se encontrÃ³ yay ni paru. Usando mÃ©todo manual..."
            install_catppuccin_kvantum_manual
        fi
    else
        install_catppuccin_kvantum_manual
    fi

    info "â¡¡â¡¡â¡¡ Catppuccin Kvantum instalado!"
    info "Para configurarlo:"
    info "  kvantummanager --set Catppuccin-Mocha-Mauve"
    info "O usa: theme-switch --kvantum Catppuccin-Mocha-Mauve"
}

install_catppuccin_kvantum_manual() {
    log "Clonando Catppuccin Kvantum desde GitHub..."
    local tmpdir
    tmpdir=$(mktemp -d)
    cd "$tmpdir"

    git clone --depth 1 https://github.com/catppuccin/Kvantum.git kvantum-catppuccin
    cd kvantum-catppuccin

    log "Copiando temas a ~/.config/Kvantum..."
    mkdir -p "$HOME/.config/Kvantum"
    cp -r themes/* "$HOME/.config/Kvantum/"

    cd /
    rm -rf "$tmpdir"

    info "â¡¡â¡¡â¡¡ Catppuccin Kvantum instalado manualmente!"
}

# -------------------------------------------------------------
# Kvantum (gestor de temas Qt)
# -------------------------------------------------------------
install_kvantum() {
    header "Instalando Kvantum..."

    case "$DISTRO" in
        arch)
            if command -v yay >/dev/null 2>&1; then
                yay -S kvantum kvantum-qt5 --noconfirm
            elif command -v paru >/dev/null 2>&1; then
                paru -S kvantum kvantum-qt5 --noconfirm
            else
                sudo pacman -S --noconfirm kvantum kvantum-qt5
            fi
            ;;
        debian)
            sudo apt update
            sudo apt install -y kvantum kvantum-qt5
            ;;
        fedora)
            sudo dnf install -y kvantum
            ;;
        opensuse)
            sudo zypper install -y kvantum
            ;;
        *)
            warn "DistribuciÃ³n no reconocida. Instala Kvantum manualmente."
            return 1
            ;;
    esac

    info "â¡¡â¡¡â¡¡ Kvantum instalado!"
}

# -------------------------------------------------------------
# Temas de iconos populares
# -------------------------------------------------------------
install_icon_themes() {
    header "Instalando temas de iconos..."

    case "$DISTRO" in
        arch)
            if command -v yay >/dev/null 2>&1; then
                yay -S papirus-icon-theme tela-circle-icon-theme-git --noconfirm
            elif command -v paru >/dev/null 2>&1; then
                paru -S papirus-icon-theme tela-circle-icon-theme-git --noconfirm
            else
                sudo pacman -S --noconfirm papirus-icon-theme
            fi
            ;;
        debian)
            sudo apt update
            sudo apt install -y papirus-icon-theme
            ;;
        fedora)
            sudo dnf install -y papirus-icon-theme
            ;;
        opensuse)
            sudo zypper install -y papirus-icon-theme
            ;;
        *)
            warn "DistribuciÃ³n no reconocida. Instala temas de iconos manualmente."
            return 1
            ;;
    esac

    info "â¡¡â¡¡â¡¡ Temas de iconos instalados!"
}

# -------------------------------------------------------------
# Temas de cursores populares
# -------------------------------------------------------------
install_cursor_themes() {
    header "Instalando temas de cursores..."

    case "$DISTRO" in
        arch)
            if command -v yay >/dev/null 2>&1; then
                yay -S bibata-cursor-theme catppuccin-cursors-git --noconfirm
            elif command -v paru >/dev/null 2>&1; then
                paru -S bibata-cursor-theme catppuccin-cursors-git --noconfirm
            else
                sudo pacman -S --noconfirm xcursor-bibata-cursor-theme
            fi
            ;;
        debian)
            sudo apt update
            sudo apt install -y xcursor-themes
            ;;
        fedora)
            sudo dnf install -y xcursor-themes
            ;;
        opensuse)
            sudo zypper install -y xcursor-themes
            ;;
        *)
            warn "DistribuciÃ³n no reconocida. Instala temas de cursores manualmente."
            return 1
            ;;
    esac

    info "â¡¡â¡¡â¡¡ Temas de cursores instalados!"
}

# -------------------------------------------------------------
# Instalar todo
# -------------------------------------------------------------
install_all() {
    install_kvantum
    install_catppuccin_kvantum
    install_icon_themes
    install_cursor_themes

    header "â¡¡â¡¡â¡¡ â Todos los temas instalados"
    cat <<EOF

â¡¡â¡¡â¡¡ â¸ CÃ³mo configurar:

1) Kvantum (temas de aplicaciones Qt):

   kvantummanager --set Catppuccin-Mocha-Mauve

2) Tema de Plasma:

   lookandfeeltool -a org.kde.breezedark.desktop

3) Iconos:

   kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme Papirus-Dark

4) Cursores:

   kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key cursorTheme Bibata-Modern-Ice

5) O usa theme-switcher:

   theme-switch --theme org.kde.breezedark.desktop --kvantum Catppuccin-Mocha-Mauve --icon Papirus-Dark --cursor Bibata-Modern-Ice

â¡¡â¡¡â¡¡ â¸ Reiniciar Plasma (si es necesario):

   kquitapp5 plasmashell && kstart5 plasmashell

Â¡Disfruta de tu nuevo tema!
EOF
}

# ============================================================
# MenÃº interactivo
# ============================================================
show_menu() {
    cat <<EOF

${CYAN}=====================================${NC}
${CYAN}      Instalador de Temas KDE        ${NC}
${CYAN}=====================================${NC}

Selecciona quÃ© instalar:

  1) Kvantum (gestor de temas Qt)
  2) Catppuccin Kvantum (tema pastel)
  3) Temas de iconos (Papirus, Tela, etc.)
  4) Temas de cursores
  5) â Instalar todo
  0) Salir

EOF
}

interactive_mode() {
    while true; do
        show_menu
        read -rp "OpciÃ³n [0-5]: " choice

        case "$choice" in
            1)
                install_kvantum
                ;;
            2)
                install_catppuccin_kvantum
                ;;
            3)
                install_icon_themes
                ;;
            4)
                install_cursor_themes
                ;;
            5)
                install_all
                break
                ;;
            0)
                info "Saliendo..."
                exit 0
                ;;
            *)
                warn "OpciÃ³n no vÃ¡lida. Intenta de nuevo."
                ;;
        esac

        echo
        read -rp "Â¿Continuar? [s/N]: " cont
        [[ "$cont" =~ ^[SsYy]$ ]] || break
    done
}

# ============================================================
# Parseo de argumentos
# ============================================================
INSTALL_ALL=false
INSTALL_CATPPUCCIN=false
INSTALL_KVANTUM=false
INSTALL_ICONS=false
INSTALL_CURSORS=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)
            INSTALL_ALL=true
            shift
            ;;
        --catppuccin)
            INSTALL_CATPPUCCIN=true
            shift
            ;;
        --kvantum)
            INSTALL_KVANTUM=true
            shift
            ;;
        --icon-themes)
            INSTALL_ICONS=true
            shift
            ;;
        --cursor-themes)
            INSTALL_CURSORS=true
            shift
            ;;
        --help)
            cat <<EOF
Uso: $(basename "$0") [OPCIONES]

Opciones:
  --all            Instalar todo (Kvantum, Catppuccin, iconos, cursores)
  --catppuccin     Instalar solo Catppuccin Kvantum
  --kvantum        Instalar solo Kvantum
  --icon-themes    Instalar temas de iconos
  --cursor-themes  Instalar temas de cursores
  --help           Muestra esta ayuda

Sin opciones: muestra un menÃº interactivo.

Ejemplos:
  $(basename "$0") --all
  $(basename "$0") --catppuccin
  $(basename "$0") --kvantum --icon-themes
EOF
            exit 0
            ;;
        *)
            die "OpciÃ³n desconocida: $1. Usa --help para ver ayuda."
            ;;
    esac
done

# ============================================================
# Ejecutar instalaciÃ³n
# ============================================================
if [[ "$INSTALL_ALL" == true ]]; then
    install_all
elif [[ "$INSTALL_CATPPUCCIN" == true ]]; then
    install_catppuccin_kvantum
elif [[ "$INSTALL_KVANTUM" == true ]]; then
    install_kvantum
elif [[ "$INSTALL_ICONS" == true ]]; then
    install_icon_themes
elif [[ "$INSTALL_CURSORS" == true ]]; then
    install_cursor_themes
else
    interactive_mode
fi
