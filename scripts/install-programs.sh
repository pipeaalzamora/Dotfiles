#!/usr/bin/env bash
# ==============================================================================
# Pipe's Dotfiles — Instalador de Programas para Ubuntu
# Perfil: Fullstack Developer + AI Engineer + DevOps
# ==============================================================================

set -euo pipefail

# Colores para salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log() { echo -e "${BLUE}[install-programs]${NC} $*"; }
info() { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[⚠]${NC} $*" >&2; }
error() { echo -e "${RED}[✗]${NC} $*" >&2; }
header() { echo -e "\n${CYAN}════════════════════════════════════════════════════════════${NC}"; echo -e "${BOLD}${CYAN}$*${NC}"; echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}\n"; }

is_installed() {
    command -v "$1" >/dev/null 2>&1
}

is_deb_installed() {
    dpkg -s "$1" &>/dev/null 2>&1
}

# ==============================================================================
# Verificación de Ubuntu
# ==============================================================================
verify_ubuntu() {
    if [[ ! -f /etc/os-release ]]; then
        error "No se pudo detectar /etc/os-release. Este script está diseñado exclusivamente para Ubuntu."
        exit 1
    fi

    # shellcheck source=/dev/null
    source /etc/os-release

    if [[ "${ID:-}" != "ubuntu" && ! "${ID_LIKE:-}" =~ ubuntu ]]; then
        warn "Advertencia: Tu distribución reporta '${NAME:-Desconocida}', no Ubuntu."
        warn "El instalador continuará usando el gestor APT de Ubuntu/Debian."
    else
        info "Sistema verificado: ${PRETTY_NAME:-Ubuntu}"
    fi
}

# ==============================================================================
# Instalación de paquetes APT
# ==============================================================================
install_apt_packages() {
    local category="$1"
    shift
    local packages=("$@")

    log "Verificando paquetes para: ${BOLD}$category${NC}..."
    local to_install=()
    for pkg in "${packages[@]}"; do
        if is_deb_installed "$pkg"; then
            info "  $pkg ya está instalado, omitiendo..."
        else
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        log "Instalando ${#to_install[@]} paquetes de $category vía APT..."
        if ! sudo apt install -y "${to_install[@]}"; then
            warn "Instalación en lote falló; intentando individualmente..."
            for pkg in "${to_install[@]}"; do
                if ! is_deb_installed "$pkg"; then
                    sudo apt install -y "$pkg" 2>/dev/null || warn "No se pudo instalar $pkg (paquete opcional u omitido)."
                fi
            done
        fi
        info "Paquetes de $category procesados."
    else
        info "Todos los paquetes de $category ya están presentes."
    fi
}

# ==============================================================================
# Instaladores especializados (Fullstack / AI / DevOps)
# ==============================================================================

# Starship Prompt
install_starship() {
    if is_installed starship; then
        info "Starship prompt ya está instalado."
        return 0
    fi
    log "Instalando Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y || warn "Fallo al instalar Starship"
}

# Lazygit (Git TUI)
install_lazygit() {
    if is_installed lazygit; then
        info "lazygit ya está instalado."
        return 0
    fi
    log "Instalando lazygit desde GitHub releases..."
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64) arch="x86_64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) arch="" ;;
    esac

    if [[ -n "$arch" ]]; then
        local version
        version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" 2>/dev/null | grep -Po '"tag_name": "v\K[^"]*' || true)
        if [[ -n "$version" ]]; then
            curl -sLo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_${arch}.tar.gz" 2>/dev/null || true
            if [[ -f /tmp/lazygit.tar.gz ]]; then
                tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit 2>/dev/null || true
                if [[ -f /tmp/lazygit ]]; then
                    sudo install /tmp/lazygit /usr/local/bin/ 2>/dev/null || {
                        mkdir -p "$HOME/.local/bin"
                        cp /tmp/lazygit "$HOME/.local/bin/"
                    }
                    rm -f /tmp/lazygit /tmp/lazygit.tar.gz
                    info "lazygit instalado correctamente."
                fi
            fi
        fi
    fi
}

# Lazydocker (Docker TUI)
install_lazydocker() {
    if is_installed lazydocker; then
        info "lazydocker ya está instalado."
        return 0
    fi
    log "Instalando lazydocker desde GitHub releases..."
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash 2>/dev/null || warn "No se pudo instalar lazydocker"
}

# k9s (Kubernetes TUI)
install_k9s() {
    if is_installed k9s; then
        info "k9s ya está instalado."
        return 0
    fi
    log "Instalando k9s (Kubernetes TUI)..."
    if is_installed snap; then
        sudo snap install k9s --devmode 2>/dev/null || true
    fi
    if ! is_installed k9s; then
        local k9s_arch
        k9s_arch=$(uname -m)
        case "$k9s_arch" in
            x86_64) k9s_arch="amd64" ;;
            aarch64|arm64) k9s_arch="arm64" ;;
            *) k9s_arch="" ;;
        esac
        if [[ -n "$k9s_arch" ]]; then
            local k9s_ver
            k9s_ver=$(curl -s "https://api.github.com/repos/derailed/k9s/releases/latest" 2>/dev/null | grep -Po '"tag_name": "v\K[^"]*' || true)
            if [[ -n "$k9s_ver" ]]; then
                curl -sLo /tmp/k9s.tar.gz "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_${k9s_arch}.tar.gz" 2>/dev/null || true
                if [[ -f /tmp/k9s.tar.gz ]]; then
                    tar -xf /tmp/k9s.tar.gz -C /tmp k9s 2>/dev/null || true
                    if [[ -f /tmp/k9s ]]; then
                        sudo install /tmp/k9s /usr/local/bin/ 2>/dev/null || {
                            mkdir -p "$HOME/.local/bin"
                            cp /tmp/k9s "$HOME/.local/bin/"
                        }
                        rm -f /tmp/k9s /tmp/k9s.tar.gz
                        info "k9s instalado correctamente."
                    fi
                fi
            fi
        fi
    fi
}

# uv (Astral - Python package & project manager para IA y desarrollo)
install_uv() {
    if is_installed uv; then
        info "uv ya está instalado."
        return 0
    fi
    log "Instalando uv (gestor ultra-rápido de Python para IA y backend)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null || warn "Fallo al instalar uv"
}

# Ollama (Ejecución local de LLMs)
install_ollama() {
    if is_installed ollama; then
        info "ollama ya está instalado."
        return 0
    fi
    log "Instalando Ollama (ejecución local de modelos de IA)..."
    curl -fsSL https://ollama.com/install.sh | sh 2>/dev/null || warn "Fallo al instalar Ollama"
}

# Bun (Runtime JS/TS de alto rendimiento)
install_bun() {
    if is_installed bun; then
        info "bun ya está instalado."
        return 0
    fi
    log "Instalando Bun (Runtime JavaScript / TypeScript)..."
    curl -fsSL https://bun.sh/install | bash 2>/dev/null || warn "Fallo al instalar Bun"
}

# PNPM
install_pnpm() {
    if is_installed pnpm; then
        info "pnpm ya está instalado."
        return 0
    fi
    if is_installed npm; then
        log "Instalando pnpm globalmente..."
        sudo npm install -g pnpm 2>/dev/null || npm install -g pnpm 2>/dev/null || true
    fi
}

# Lunacy (Snap)
install_lunacy() {
    if is_installed lunacy; then
        info "lunacy ya está instalado."
        return 0
    fi
    if is_installed snap; then
        log "Instalando Lunacy vía Snap..."
        sudo snap install lunacy 2>/dev/null || warn "No se pudo instalar Lunacy vía Snap (opcional)."
    fi
}

# Configurar grupo Docker
configure_docker_permissions() {
    if is_installed docker && getent group docker >/dev/null 2>&1; then
        if ! groups "$USER" 2>/dev/null | grep -qw docker; then
            log "Configurando permisos de Docker para $USER..."
            sudo usermod -aG docker "$USER" 2>/dev/null || true
            info "Usuario $USER agregado al grupo docker (requiere cerrar y volver a abrir sesión)."
        fi
    fi
}

# Enlaces de compatibilidad para Ubuntu
setup_ubuntu_symlinks() {
    mkdir -p "$HOME/.local/bin"
    if is_installed batcat && ! is_installed bat; then
        ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
        info "Enlace creado: ~/.local/bin/bat -> $(command -v batcat)"
    fi
    if is_installed fdfind && ! is_installed fd; then
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
        info "Enlace creado: ~/.local/bin/fd -> $(command -v fdfind)"
    fi
}

# ==============================================================================
# Función principal
# ==============================================================================
main() {
    header "🚀 Pipe's Dotfiles — Instalador de Programas (Ubuntu)"

    verify_ubuntu

    echo -e "${CYAN}Este script configurará las herramientas completas para:${NC}"
    echo -e "  • ${BOLD}Base CLI & Terminal:${NC} Zsh, Neovim, Starship, Kitty, Fzf, Zoxide, Bat, Fd, Lsd, Lazygit..."
    echo -e "  • ${BOLD}Fullstack Developer:${NC} Node.js, PNPM, Bun, Go, Rust, PostgreSQL client, Redis, SQLite, HTTPie..."
    echo -e "  • ${BOLD}AI Engineer:${NC} Python3, Pipx, uv (Astral), Ollama (Local LLMs)..."
    echo -e "  • ${BOLD}DevOps & Cloud:${NC} Docker, Docker Compose v2, Lazydocker, Kubectl, k9s, Helm, Kubectx/Kubens..."
    echo -e "  • ${BOLD}Multimedia & Extras:${NC} FFmpeg, VLC, yt-dlp, EasyEffects, Cava, Feh, Kate, Lunacy..."
    echo ""

    read -rp "$(echo -e "${YELLOW}?${NC} ¿Deseas iniciar la instalación en Ubuntu? [S/n]: ")" answer
    answer="${answer:-s}"
    if [[ ! "$answer" =~ ^[Ss]$ ]]; then
        info "Instalación cancelada."
        exit 0
    fi

    # Actualizar repositorios APT
    log "Actualizando lista de paquetes APT..."
    sudo apt update

    # Determinar docker compose
    local docker_compose_pkg="docker-compose"
    if apt-cache show docker-compose-v2 &>/dev/null 2>&1; then
        docker_compose_pkg="docker-compose-v2"
    fi

    # Determinar tldr / tealdeer
    local tldr_pkg="tldr"
    if apt-cache show tealdeer &>/dev/null 2>&1; then
        tldr_pkg="tealdeer"
    fi

    # 1. Base CLI & Sistema
    install_apt_packages "Base CLI y Terminal" \
        btop bat fd-find fzf git htop jq lsd neovim ripgrep "$tldr_pkg" tree zoxide \
        zsh zsh-autosuggestions zsh-syntax-highlighting curl wget git-delta fastfetch \
        wl-clipboard build-essential kitty zathura easyeffects cava

    # 2. Fullstack Development
    install_apt_packages "Fullstack Stack" \
        nodejs npm golang-go rustc cargo postgresql-client redis-tools sqlite3 \
        httpie lsof iproute2

    # 3. DevOps & Cloud
    install_apt_packages "DevOps Suite" \
        docker.io "$docker_compose_pkg" kubectx

    # 4. AI Engineering & Python
    install_apt_packages "AI Engineering & Python" \
        python3 python3-pip python3-venv pipx

    # 5. Multimedia & Herramientas
    install_apt_packages "Multimedia y GUI" \
        ffmpeg vlc yt-dlp feh kate

    # Instaladores especializados y TUIs
    header "Instalando Herramientas Especializadas y TUIs"
    setup_ubuntu_symlinks
    install_starship
    install_lazygit
    install_lazydocker
    install_k9s
    install_uv
    install_ollama
    install_bun
    install_pnpm
    install_lunacy
    configure_docker_permissions

    header "✅ INSTALACIÓN COMPLETADA EXITOSAMENTE EN UBUNTU"
    echo -e "${GREEN}¡Tu entorno Fullstack + AI Engineer + DevOps está listo!${NC}"
    echo ""
    echo "Próximos pasos:"
    echo "  1. Recarga tu terminal: exec zsh"
    echo "  2. Verifica dependencias: dotfiles doctor"
    echo "  3. Abre Lazygit con 'lg', Lazydocker con 'ld' o k9s con 'k9s'"
    echo "  4. Gestiona modelos locales de IA con 'ollama run <modelo>'"
    echo ""
}

main "$@"
