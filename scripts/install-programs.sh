#!/usr/bin/env bash
#
# install-programs.sh — Instala todos los programas esenciales para el sistema
#
# Este script instala automáticamente todos los programas de una sola vez.
# Resuelve conflictos de dependencias y salta programas ya instalados.

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
info() { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[⚠]${NC} $*" >&2; }
error() { echo -e "${RED}[✗]${NC} $*" >&2; }
header() { echo -e "\n${CYAN}════════════════════════════════════════${NC}"; echo -e "${CYAN}$*${NC}"; echo -e "${CYAN}════════════════════════════════════════${NC}\n"; }

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

# Comprobar si un programa está instalado
is_installed() {
    command -v "$1" >/dev/null 2>&1
}

DISTRO=$(detect_distro)
log "Distribución detectada: $DISTRO"

# ============================================================
# Instaladores por distribución
# ============================================================

install_arch() {
    header "Instalando programas en Arch Linux"

    # Determinar gestor de paquetes AUR disponible
    local aur_helper="pacman"
    if command -v yay >/dev/null 2>&1; then
        aur_helper="yay"
    elif command -v paru >/dev/null 2>&1; then
        aur_helper="paru"
    fi

    # Actualizar base de datos
    log "Actualizando base de datos de paquetes..."
    if [[ "$aur_helper" != "pacman" ]]; then
        "$aur_helper" -Sy --noconfirm
    else
        sudo pacman -Sy --noconfirm
    fi

    # Array de paquetes a instalar
    local packages=(
        # Sistema
        "btop"
        "eza"
        "fd"
        "fzf"
        "git"
        "htop"
        "jq"
        "lsd"
        "neovim"
        "ripgrep"
        "tldr"
        "tree"
        "zoxide"
        "zsh"
        "zsh-completions"
        # Desarrollo
        "docker"
        "docker-compose"
        "go"
        "nodejs"
        "npm"
        "python"
        "python-pip"
        "rust"
        # Multimedia
        "ffmpeg"
        "vlc"
        "yt-dlp"
        # Visor de imágenes
        "feh"
        # Editor
        "kate"
    )

    # Instalar paquetes, omitiendo los ya instalados
    local to_install=()
    for pkg in "${packages[@]}"; do
        if is_installed "$pkg"; then
            info "$pkg ya está instalado, omitiendo..."
        else
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
        info "Todos los paquetes ya están instalados."
    else
        log "Instalando ${#to_install[@]} paquetes..."
    fi

    # Resolver conflictos ANTES de intentar instalar
    
    # Conflicto 1: tealdeer vs tldr
    if pacman -Q tealdeer &>/dev/null 2>&1; then
        warn "Detectado conflicto: tealdeer está instalado. Removiendo para instalar tldr..."
        sudo pacman -R --noconfirm tealdeer 2>/dev/null || true
    fi

    # Conflicto 2: rustup vs rust
    if pacman -Q rustup &>/dev/null 2>&1; then
        warn "Detectado conflicto: rustup está instalado. Removiendo para instalar rust..."
        sudo pacman -R --noconfirm rustup 2>/dev/null || true
    fi

    # Filtrar paquetes que ya están instalados para evitar reinstalación
    local final_install=()
    for pkg in "${to_install[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null 2>&1; then
            final_install+=("$pkg")
        fi
    done

    if [[ ${#final_install[@]} -gt 0 ]]; then
        # Instalar con el gestor apropiado
        if [[ "$aur_helper" == "yay" ]]; then
            log "Usando yay para instalar ${#final_install[@]} paquetes..."
            yay -S --noconfirm "${final_install[@]}" || {
                error "Error durante la instalación con yay."
                return 1
            }
        elif [[ "$aur_helper" == "paru" ]]; then
            log "Usando paru para instalar ${#final_install[@]} paquetes..."
            paru -S --noconfirm "${final_install[@]}" || {
                error "Error durante la instalación con paru."
                return 1
            }
        else
            log "Usando pacman para instalar ${#final_install[@]} paquetes..."
            sudo pacman -S --noconfirm "${final_install[@]}" || {
                error "Error durante la instalación con pacman."
                return 1
            }
        fi
    fi

    # Intentar instalar Lunacy desde AUR (opcional, sin fallar si no funciona)
    if ! is_installed lunacy; then
        log "Intentando instalar Lunacy desde AUR (esto puede tomar tiempo)..."
        if [[ "$aur_helper" == "yay" ]]; then
            info "Instalando lunacy-bin con yay..."
            yay -S --noconfirm --nocleanmenu --nodiffmenu --answerclean=All --answerdiff=None lunacy-bin 2>&1 | grep -v "Evite ejecutar" || {
                warn "No se pudo instalar lunacy-bin automáticamente."
                echo ""
                echo "Para instalar lunacy manualmente, ejecuta:"
                echo "  ${GREEN}yay -S lunacy-bin${NC}"
                echo ""
                echo "O lee la documentación: $DOTFILES_DIR/LUNACY_INSTALL.md"
            }
        elif [[ "$aur_helper" == "paru" ]]; then
            info "Instalando lunacy-bin con paru..."
            paru -S --noconfirm --nocleanmenu --nodiffmenu lunacy-bin 2>&1 | grep -v "Evite ejecutar" || {
                warn "No se pudo instalar lunacy-bin automáticamente."
                echo ""
                echo "Para instalar lunacy manualmente, ejecuta:"
                echo "  ${GREEN}paru -S lunacy-bin${NC}"
                echo ""
                echo "O lee la documentación: $DOTFILES_DIR/LUNACY_INSTALL.md"
            }
        fi
    else
        info "lunacy ya está instalado, omitiendo..."
    fi

    info "Paquetes de Arch Linux instalados correctamente."
}

install_debian() {
    header "Instalando programas en Debian/Ubuntu"

    # Actualizar base de datos
    log "Actualizando base de datos de paquetes..."
    sudo apt update

    local packages=(
        # Sistema
        "btop"
        "fd-find"
        "fzf"
        "git"
        "htop"
        "jq"
        "lsd"
        "neovim"
        "ripgrep"
        "tldr"
        "tree"
        "zoxide"
        "zsh"
        # Desarrollo
        "docker.io"
        "docker-compose"
        "golang-go"
        "nodejs"
        "npm"
        "python3"
        "python3-pip"
        "rustc"
        # Multimedia
        "ffmpeg"
        "vlc"
        "yt-dlp"
        # Visor de imágenes
        "feh"
        # Editor
        "kate"
        # Diseño
        "lunacy"
    )

    local to_install=()
    for pkg in "${packages[@]}"; do
        if is_installed "${pkg%-*}"; then  # Remover sufijo para verificación
            info "$pkg ya está instalado, omitiendo..."
        else
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
        info "Todos los paquetes ya están instalados."
        return 0
    fi

    log "Instalando ${#to_install[@]} paquetes..."
    sudo apt install -y "${to_install[@]}" || {
        error "Error durante la instalación."
        return 1
    }

    info "Paquetes de Debian/Ubuntu instalados correctamente."
}

install_fedora() {
    header "Instalando programas en Fedora"

    log "Actualizando base de datos de paquetes..."
    sudo dnf check-update || true

    local packages=(
        # Sistema
        "btop"
        "fd-find"
        "fzf"
        "git"
        "htop"
        "jq"
        "lsd"
        "neovim"
        "ripgrep"
        "tldr"
        "tree"
        "zoxide"
        "zsh"
        # Desarrollo
        "docker"
        "docker-compose"
        "golang"
        "nodejs"
        "npm"
        "python3"
        "python3-pip"
        "rust"
        # Multimedia
        "ffmpeg"
        "vlc"
        "yt-dlp"
        # Visor de imágenes
        "feh"
        # Editor
        "kate"
        # Diseño
        "lunacy"
    )

    local to_install=()
    for pkg in "${packages[@]}"; do
        if is_installed "${pkg%-*}"; then
            info "$pkg ya está instalado, omitiendo..."
        else
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
        info "Todos los paquetes ya están instalados."
        return 0
    fi

    log "Instalando ${#to_install[@]} paquetes..."
    sudo dnf install -y "${to_install[@]}" || {
        error "Error durante la instalación."
        return 1
    }

    info "Paquetes de Fedora instalados correctamente."
}

install_opensuse() {
    header "Instalando programas en openSUSE"

    log "Actualizando base de datos de paquetes..."
    sudo zypper refresh || true

    local packages=(
        # Sistema
        "btop"
        "fd"
        "fzf"
        "git"
        "htop"
        "jq"
        "lsd"
        "neovim"
        "ripgrep"
        "tldr"
        "tree"
        "zoxide"
        "zsh"
        # Desarrollo
        "docker"
        "docker-compose"
        "go"
        "nodejs"
        "npm"
        "python3"
        "python3-pip"
        "rust"
        # Multimedia
        "ffmpeg"
        "vlc"
        "yt-dlp"
        # Visor de imágenes
        "feh"
        # Editor
        "kate"
        # Diseño
        "lunacy"
    )

    local to_install=()
    for pkg in "${packages[@]}"; do
        if is_installed "$pkg"; then
            info "$pkg ya está instalado, omitiendo..."
        else
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
        info "Todos los paquetes ya están instalados."
        return 0
    fi

    log "Instalando ${#to_install[@]} paquetes..."
    sudo zypper install -y "${to_install[@]}" || {
        error "Error durante la instalación."
        return 1
    }

    info "Paquetes de openSUSE instalados correctamente."
}

# ============================================================
# Función principal
# ============================================================
main() {
    header "🚀 Instalador de Programas Esenciales"

    echo -e "${CYAN}Este script instalará TODOS los programas automáticamente.${NC}"
    echo -e "${CYAN}Se omitirán los programas ya instalados.${NC}"
    echo ""
    echo "Categorías a instalar:"
    echo "  • Sistema: btop, fd, fzf, git, htop, jq, lsd, neovim, ripgrep, tldr, tree, zoxide, zsh"
    echo "  • Desarrollo: docker, docker-compose, go, nodejs, npm, python, rust"
    echo "  • Multimedia: ffmpeg, vlc, yt-dlp"
    echo "  • Herramientas: feh (visor), kate (editor)"
    echo "  • Opcional: lunacy (diseño - AUR, puede omitirse si falla)"
    echo ""

    read -rp "$(echo -e "${YELLOW}?${NC} ¿Continuar con la instalación? [S/n]: ")" answer
    answer="${answer:-s}"
    
    if [[ ! "$answer" =~ ^[Ss]$ ]]; then
        info "Instalación cancelada."
        exit 0
    fi

    case "$DISTRO" in
        arch)
            install_arch
            ;;
        debian)
            install_debian
            ;;
        fedora)
            install_fedora
            ;;
        opensuse)
            install_opensuse
            ;;
        *)
            error "Distribución no soportada: $DISTRO"
            exit 1
            ;;
    esac

    header "✅ INSTALACIÓN COMPLETADA"
    info "Todos los programas han sido instalados correctamente."
    echo ""
    echo "Próximos pasos:"
    echo "  1. Recarga tu shell: exec zsh"
    echo "  2. Verifica dependencias: dotfiles doctor"
    echo "  3. Explora los comandos: dotfiles help"
}

main
