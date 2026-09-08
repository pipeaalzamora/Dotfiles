#!/usr/bin/env bash
#
# install-programs.sh — Instala programas esenciales para el sistema
#
# Uso:
#   install-programs.sh [--all] [--system] [--dev] [--multimedia] [--image-viewer] [--editor]
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

log() { echo -e "${BLUE}[install-programs]${NC} $*"; }
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
# Programas del sistema
# -------------------------------------------------------------
install_system() {
    header "Instalando programas del sistema..."

    case "$DISTRO" in
        arch)
            if command -v yay >/dev/null 2>&1; then
                yay -S --noconfirm \
                    btop \
                    dust \
                    eza \
                    fd \
                    fzf \
                    git \
                    htop \
                    jq \
                    lsd \
                    neovim \
                    ripgrep \
                    tldr \
                    tree \
                    zoxide \
                    zsh \
                    zsh-completions
            elif command -v paru >/dev/null 2>&1; then
                paru -S --noconfirm \
                    btop \
                    dust \
                    eza \
                    fd \
                    fzf \
                    git \
                    htop \
                    jq \
                    lsd \
                    neovim \
                    ripgrep \
                    tldr \
                    tree \
                    zoxide \
                    zsh \
                    zsh-completions
            else
                sudo pacman -S --noconfirm \
                    btop \
                    dust \
                    eza \
                    fd \
                    fzf \
                    git \
                    htop \
                    jq \
                    lsd \
                    neovim \
                    ripgrep \
                    tldr \
                    tree \
                    zoxide \
                    zsh \
                    zsh-completions
            fi
            ;;
        debian)
            sudo apt update
            sudo apt install -y \
                btop \
                dust \
                fd-find \
                fzf \
                git \
                htop \
                jq \
                lsd \
                neovim \
                ripgrep \
                tree \
                zoxide \
                zsh
            ;;
        fedora)
            sudo dnf install -y \
                btop \
                dust \
                fd-find \
                fzf \
                git \
                htop \
                jq \
                lsd \
                neovim \
                ripgrep \
                tree \
                zoxide \
                zsh
            ;;
        opensuse)
            sudo zypper install -y \
                btop \
                dust \
                fd \
                fzf \
                git \
                htop \
                jq \
                lsd \
                neovim \
                ripgrep \
                tree \
                zoxide \
                zsh
            ;;
        *)
            warn "DistribuciÃ³n no reconocida. Instala programas manualmente."
            return 1
            ;;
    esac

    info "â¡¡â¡¡â¡¡ Programas del sistema instalados!"
}

# -------------------------------------------------------------
# Herramientas de desarrollo
# -------------------------------------------------------------
install_dev() {
    header "Instalando herramientas de desarrollo..."

    case "$DISTRO" in
        arch)
            if command -v yay >/dev/null 2>&1; then
                yay -S --noconfirm \
                    docker \
                    docker-compose \
                    go \
                    nodejs \
                    npm \
                    python \
                    python-pip \
                    rust
            elif command -v paru >/dev/null 2>&1; then
                paru -S --noconfirm \
                    docker \
                    docker-compose \
                    go \
                    nodejs \
                    npm \
                    python \
                    python-pip \
                    rust
            else
                sudo pacman -S --noconfirm \
                    docker \
                    docker-compose \
                    go \
                    nodejs \
                    npm \
                    python \
                    python-pip \
                    rust
            fi
            ;;
        debian)
            sudo apt update
            sudo apt install -y \
                docker.io \
                docker-compose \
                golang-go \
                nodejs \
                npm \
                python3 \
                python3-pip \
                rustc
            ;;
        fedora)
            sudo dnf install -y \
                docker \
                docker-compose \
                golang \
                nodejs \
                npm \
                python3 \
                python3-pip \
                rust
            ;;
        opensuse)
            sudo zypper install -y \
                docker \
                docker-compose \
                go \
                nodejs \
                npm \
                python3 \
                python3-pip \
                rust
            ;;
        *)
            warn "DistribuciÃ³n no reconocida. Instala herramientas de desarrollo manualmente."
            return 1
            ;;
    esac

    info "â¡¡â¡¡â¡¡ Herramientas de desarrollo instaladas!"
}

# -------------------------------------------------------------
# Multimedia
# -------------------------------------------------------------
install_multimedia() {
    header "Instalando herramientas multimedia..."

    case "$DISTRO" in
        arch)
            if command -v yay >/dev/null 2>&1; then
                yay -S --noconfirm \
                    ffmpeg \
                    mpv \
                    vlc \
                    yt-dlp
            elif command -v paru >/dev/null 2>&1; then
                paru -S --noconfirm \
                    ffmpeg \
                    mpv \
                    vlc \
                    yt-dlp
            else
                sudo pacman -S --noconfirm \
                    ffmpeg \
                    mpv \
                    vlc \
                    yt-dlp
            fi
            ;;
        debian)
            sudo apt update
            sudo apt install -y \
                ffmpeg \
                mpv \
                vlc \
                yt-dlp
            ;;
        fedora)
            sudo dnf install -y \
                ffmpeg \
                mpv \
                vlc \
                yt-dlp
            ;;
        opensuse)
            sudo zypper install -y \
                ffmpeg \
                mpv \
                vlc \
                yt-dlp
            ;;
        *)
            warn "DistribuciÃ³n no reconocida. Instala herramientas multimedia manualmente."
            return 1
            ;;
    esac

    info "â¡¡â¡¡â¡¡ Herramientas multimedia instaladas!"
}

# -------------------------------------------------------------
# Visor de imágenes (feh)
# -------------------------------------------------------------
install_image_viewer() {
    header "Instalando visor de imágenes (feh)..."

    case "$DISTRO" in
        arch)
            if command -v yay >/dev/null 2>&1; then
                yay -S --noconfirm feh
            elif command -v paru >/dev/null 2>&1; then
                paru -S --noconfirm feh
            else
                sudo pacman -S --noconfirm feh
            fi
            ;;
        debian)
            sudo apt update
            sudo apt install -y feh
            ;;
        fedora)
            sudo dnf install -y feh
            ;;
        opensuse)
            sudo zypper install -y feh
            ;;
        *)
            warn "DistribuciÃ³n no reconocida. Instala feh manualmente."
            return 1
            ;;
    esac

    info "â¡¡â¡¡â¡¡ Feh instalado!"
    info "Uso: feh ~/ImÃ¡genes/foto.jpg"
    info "Slideshow: feh --slideshow-delay 5 --fullscreen ~/ImÃ¡genes/"
}

# -------------------------------------------------------------
# Editor de texto (Kate - KDE)
# -------------------------------------------------------------
install_editor() {
    header "Instalando editor de texto (Kate - KDE)..."

    case "$DISTRO" in
        arch)
            if command -v yay >/dev/null 2>&1; then
                yay -S --noconfirm kate
            elif command -v paru >/dev/null 2>&1; then
                paru -S --noconfirm kate
            else
                sudo pacman -S --noconfirm kate
            fi
            ;;
        debian)
            sudo apt update
            sudo apt install -y kate
            ;;
        fedora)
            sudo dnf install -y kate
            ;;
        opensuse)
            sudo zypper install -y kate
            ;;
        *)
            warn "DistribuciÃ³n no reconocida. Instala Kate manualmente."
            return 1
            ;;
    esac

    info "â¡¡â¡¡â¡¡ Kate instalado!"
    info "Uso: kate archivo.txt"
}

# -------------------------------------------------------------
# Instalar todo
# -------------------------------------------------------------
install_all() {
    install_system
    install_dev
    install_multimedia
    install_image_viewer
    install_editor

    header "â¡¡â¡¡â¡¡ â Todos los programas instalados"
}

# ============================================================
# MenÃº interactivo
# ============================================================
show_menu() {
    cat <<EOF

${CYAN}=====================================${NC}
${CYAN}      Instalador de Programas        ${NC}
${CYAN}=====================================${NC}

Selecciona quÃ© instalar:

  1) Programas del sistema (btop, fd, fzf, git, neovim, etc.)
  2) Herramientas de desarrollo (Docker, Node, Python, Rust, etc.)
  3) Multimedia (ffmpeg, mpv, vlc, yt-dlp)
  4) Visor de imÃ¡genes (feh)
  5) Editor de texto (Kate - KDE)
  6) â Instalar todo
  0) Salir

EOF
}

interactive_mode() {
    while true; do
        show_menu
        read -rp "OpciÃ³n [0-6]: " choice

        case "$choice" in
            1)
                install_system
                ;;
            2)
                install_dev
                ;;
            3)
                install_multimedia
                ;;
            4)
                install_image_viewer
                ;;
            5)
                install_editor
                ;;
            6)
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
INSTALL_SYSTEM=false
INSTALL_DEV=false
INSTALL_MULTIMEDIA=false
INSTALL_IMAGE_VIEWER=false
INSTALL_EDITOR=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)
            INSTALL_ALL=true
            shift
            ;;
        --system)
            INSTALL_SYSTEM=true
            shift
            ;;
        --dev)
            INSTALL_DEV=true
            shift
            ;;
        --multimedia)
            INSTALL_MULTIMEDIA=true
            shift
            ;;
        --image-viewer)
            INSTALL_IMAGE_VIEWER=true
            shift
            ;;
        --editor)
            INSTALL_EDITOR=true
            shift
            ;;
        --help)
            cat <<EOF
Uso: $(basename "$0") [OPCIONES]

Opciones:
  --all            Instalar todo (sistema, dev, multimedia, visor, editor)
  --system         Instalar programas del sistema
  --dev            Instalar herramientas de desarrollo
  --multimedia     Instalar herramientas multimedia
  --image-viewer   Instalar visor de imÃ¡genes (feh)
  --editor         Instalar editor de texto (Kate)
  --help           Muestra esta ayuda

Sin opciones: muestra un menÃº interactivo.

Ejemplos:
  $(basename "$0") --all
  $(basename "$0") --image-viewer --editor
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
elif [[ "$INSTALL_SYSTEM" == true ]]; then
    install_system
elif [[ "$INSTALL_DEV" == true ]]; then
    install_dev
elif [[ "$INSTALL_MULTIMEDIA" == true ]]; then
    install_multimedia
elif [[ "$INSTALL_IMAGE_VIEWER" == true ]]; then
    install_image_viewer
elif [[ "$INSTALL_EDITOR" == true ]]; then
    install_editor
else
    interactive_mode
fi
