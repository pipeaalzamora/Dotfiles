#!/bin/bash
# ============================================================
# Dotfiles Installer para Ubuntu 24.04+ / 26.04
# Instalación interactiva — elige qué instalar
# ============================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# ============================================================
# Funciones auxiliares
# ============================================================

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${BOLD}$1${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

ask_yes_no() {
    local prompt="$1"
    local default="${2:-s}"
    local response

    if [[ "$default" == "s" ]]; then
        prompt="$prompt [S/n]: "
    else
        prompt="$prompt [s/N]: "
    fi

    echo -ne "${PURPLE}❓ ${prompt}${NC}"
    read -r response
    response=${response:-$default}

    [[ "$response" =~ ^[sS]$ ]]
}

ask_install() {
    local name="$1"
    local description="$2"
    local default="${3:-s}"

    echo ""
    echo -e "${BOLD}📦 $name${NC}"
    echo -e "   ${description}"
    ask_yes_no "¿Instalar $name?" "$default"
}

install_if_missing() {
    local cmd="$1"
    local pkg="${2:-$1}"
    if ! command -v "$cmd" &>/dev/null; then
        sudo apt install -y "$pkg"
    fi
}

# ============================================================
# Verificar que estamos en Ubuntu
# ============================================================

if [[ ! -f /etc/os-release ]]; then
    print_error "No se puede detectar el sistema operativo"
    exit 1
fi

source /etc/os-release
if [[ "$ID" != "ubuntu" && "$ID_LIKE" != *"ubuntu"* && "$ID_LIKE" != *"debian"* ]]; then
    print_error "Este script está diseñado para Ubuntu/Debian. Detectado: $ID"
    exit 1
fi

# ============================================================
# Inicio
# ============================================================

print_header "Instalador de Dotfiles para Ubuntu"
echo -e "Sistema detectado: ${GREEN}$PRETTY_NAME${NC}"
echo -e "Directorio dotfiles: ${CYAN}$DOTFILES_DIR${NC}"
echo ""
echo "Este script te permitirá elegir qué componentes instalar."
echo "Cada uno incluye una explicación de para qué sirve."
echo ""
echo -e "${YELLOW}─────────────────────────────────────────────────────${NC}"

# ============================================================
# PASO 1: Actualizar sistema
# ============================================================

print_header "Paso 1: Actualizar sistema"
print_info "Actualizando lista de paquetes..."
sudo apt update
sudo apt upgrade -y

# Instalar dependencias base siempre necesarias
print_info "Instalando dependencias base (git, curl, wget, unzip, build-essential)..."
sudo apt install -y git curl wget unzip build-essential software-properties-common \
    apt-transport-https ca-certificates gnupg lsb-release

print_success "Sistema actualizado"

# ============================================================
# PASO 2: Shell (Zsh + Oh My Zsh)
# ============================================================

print_header "Paso 2: Shell"

INSTALL_ZSH=false
if ask_install "Zsh + Oh My Zsh" \
    "Shell avanzada con autocompletado inteligente, corrección de errores,
   historial compartido entre terminales y cientos de plugins.
   Reemplaza bash como tu shell principal."; then
    INSTALL_ZSH=true

    install_if_missing zsh zsh
    print_success "Zsh instalado"

    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Instalando Oh My Zsh..."
        RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    print_success "Oh My Zsh instalado"

    # Plugins
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    print_info "Instalando plugin: zsh-autosuggestions"
    echo -e "   Sugiere comandos mientras escribes basándose en tu historial"
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    print_info "Instalando plugin: zsh-syntax-highlighting"
    echo -e "   Colorea comandos en tiempo real (verde=válido, rojo=error)"
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting \
            "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    print_success "Plugins de Zsh instalados"
fi

# ============================================================
# PASO 3: Starship Prompt
# ============================================================

INSTALL_STARSHIP=false
if ask_install "Starship" \
    "Prompt minimalista y ultra-rápido (escrito en Rust).
   Muestra info contextual: rama git, lenguaje del proyecto, errores,
   tiempo de ejecución del último comando. Tema Catppuccin Mocha."; then
    INSTALL_STARSHIP=true

    if ! command -v starship &>/dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
    print_success "Starship instalado"
fi

# ============================================================
# PASO 4: Terminal Kitty
# ============================================================

INSTALL_KITTY=false
if ask_install "Kitty" \
    "Terminal emulador acelerado por GPU. Soporta transparencia,
   ligatures de fuentes, tabs, splits y es muy rápido.
   Funciona en X11 y Wayland (GNOME). Tema Catppuccin Mocha."; then
    INSTALL_KITTY=true

    if ! command -v kitty &>/dev/null; then
        # Instalar desde el binario oficial (versión más reciente)
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
        # Crear symlink
        mkdir -p "$HOME/.local/bin"
        ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
        ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
        # Desktop entry
        mkdir -p "$HOME/.local/share/applications"
        cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" \
            "$HOME/.local/share/applications/"
        sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
            "$HOME/.local/share/applications/kitty.desktop"
        sed -i "s|Exec=kitty|Exec=$HOME/.local/bin/kitty|g" \
            "$HOME/.local/share/applications/kitty.desktop"
    fi
    print_success "Kitty instalado"
fi

# ============================================================
# PASO 5: Fuentes Nerd
# ============================================================

INSTALL_FONTS=false
if ask_install "Nerd Fonts (MesloLGS + JetBrains Mono)" \
    "Fuentes monoespaciadas con iconos integrados (necesarias para
   que lsd, starship y kitty muestren iconos correctamente)."; then
    INSTALL_FONTS=true

    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"

    # MesloLGS Nerd Font
    if ! fc-list | grep -qi "MesloLGS"; then
        print_info "Descargando MesloLGS Nerd Font..."
        MESLO_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
        wget -q "$MESLO_URL" -O /tmp/Meslo.zip
        unzip -qo /tmp/Meslo.zip -d "$FONT_DIR/MesloNerd"
        rm /tmp/Meslo.zip
    fi

    # JetBrains Mono Nerd Font
    if ! fc-list | grep -qi "JetBrainsMono Nerd"; then
        print_info "Descargando JetBrains Mono Nerd Font..."
        JB_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        wget -q "$JB_URL" -O /tmp/JetBrainsMono.zip
        unzip -qo /tmp/JetBrainsMono.zip -d "$FONT_DIR/JetBrainsMonoNerd"
        rm /tmp/JetBrainsMono.zip
    fi

    fc-cache -fv >/dev/null 2>&1
    print_success "Fuentes Nerd instaladas"
fi

# ============================================================
# PASO 6: Herramientas CLI modernas
# ============================================================

print_header "Paso 6: Herramientas CLI modernas"
echo "Estas herramientas reemplazan comandos clásicos por versiones"
echo "más rápidas, con colores e iconos."
echo ""

# --- lsd ---
INSTALL_LSD=false
if ask_install "lsd (reemplazo de ls)" \
    "Listado de archivos con iconos, colores y formato tipo árbol.
   Hace que 'ls' sea mucho más visual y legible."; then
    INSTALL_LSD=true
    if ! command -v lsd &>/dev/null; then
        sudo apt install -y lsd 2>/dev/null || {
            LSD_URL=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest \
                | grep "browser_download_url.*lsd_.*amd64.deb" | head -1 | cut -d'"' -f4)
            wget -q "$LSD_URL" -O /tmp/lsd.deb
            sudo dpkg -i /tmp/lsd.deb
            rm /tmp/lsd.deb
        }
    fi
    print_success "lsd instalado"
fi

# --- bat ---
INSTALL_BAT=false
if ask_install "bat (reemplazo de cat)" \
    "Muestra archivos con syntax highlighting, números de línea
   e integración con git (marca líneas modificadas).
   En Ubuntu se llama 'batcat' pero el alias lo mapea a 'cat'."; then
    INSTALL_BAT=true
    install_if_missing batcat bat
    print_success "bat instalado"
fi

# --- fd ---
INSTALL_FD=false
if ask_install "fd (reemplazo de find)" \
    "Búsqueda de archivos ultra-rápida con sintaxis simple.
   Ejemplo: 'fd config' en vez de 'find . -name \"*config*\"'.
   En Ubuntu se llama 'fdfind' pero el alias lo mapea a 'fd'."; then
    INSTALL_FD=true
    install_if_missing fdfind fd-find
    print_success "fd instalado"
fi

# --- ripgrep ---
INSTALL_RG=false
if ask_install "ripgrep (reemplazo de grep)" \
    "Búsqueda de texto en archivos extremadamente rápida.
   Respeta .gitignore, busca recursivamente por defecto.
   Ejemplo: 'rg TODO' busca en todo el proyecto."; then
    INSTALL_RG=true
    install_if_missing rg ripgrep
    print_success "ripgrep instalado"
fi

# --- fzf ---
INSTALL_FZF=false
if ask_install "fzf (fuzzy finder)" \
    "Buscador interactivo fuzzy. Permite buscar archivos, historial
   de comandos (Ctrl+R mejorado), ramas git, y más.
   Se integra con bat y fd para previews."; then
    INSTALL_FZF=true
    install_if_missing fzf fzf
    print_success "fzf instalado"
fi

# --- zoxide ---
INSTALL_ZOXIDE=false
if ask_install "zoxide (reemplazo de cd)" \
    "Aprende los directorios que más visitas y te permite saltar
   a ellos con 'j proyecto' en vez de escribir la ruta completa.
   Ejemplo: 'j dot' → salta a ~/dotfiles."; then
    INSTALL_ZOXIDE=true
    if ! command -v zoxide &>/dev/null; then
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi
    print_success "zoxide instalado"
fi

# --- lazygit ---
INSTALL_LAZYGIT=false
if ask_install "lazygit (git visual en terminal)" \
    "Interfaz gráfica de git dentro de la terminal. Permite hacer
   commits, push, pull, resolver conflictos, ver diffs, stash,
   cherry-pick, todo con atajos de teclado. Alias: 'lg'."; then
    INSTALL_LAZYGIT=true
    if ! command -v lazygit &>/dev/null; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
            | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo /tmp/lazygit.tar.gz \
            "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
        sudo install /tmp/lazygit /usr/local/bin
        rm /tmp/lazygit /tmp/lazygit.tar.gz
    fi
    print_success "lazygit instalado"
fi

# --- delta ---
INSTALL_DELTA=false
if ask_install "delta (diffs mejorados de git)" \
    "Muestra los diffs de git con syntax highlighting, números de
   línea y vista side-by-side. Se configura automáticamente en
   .gitconfig para que 'git diff' y 'git log' se vean mejor."; then
    INSTALL_DELTA=true
    if ! command -v delta &>/dev/null; then
        DELTA_URL=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest \
            | grep "browser_download_url.*delta_.*amd64.deb" | head -1 | cut -d'"' -f4)
        wget -q "$DELTA_URL" -O /tmp/delta.deb
        sudo dpkg -i /tmp/delta.deb
        rm /tmp/delta.deb
    fi
    print_success "delta instalado"
fi

# --- btop ---
INSTALL_BTOP=false
if ask_install "btop (monitor del sistema)" \
    "Monitor de recursos del sistema (CPU, RAM, disco, red, procesos)
   con interfaz visual moderna. Reemplazo de htop/top.
   Alias: 'bp' o 'top'."; then
    INSTALL_BTOP=true
    install_if_missing btop btop
    print_success "btop instalado"
fi

# --- yazi ---
INSTALL_YAZI=false
if ask_install "yazi (file manager en terminal)" \
    "Explorador de archivos en terminal ultra-rápido (escrito en Rust).
   Soporta previews de imágenes, videos, PDFs. Navegación con vim keys.
   Al salir, te deja en el directorio donde estabas (función 'y')."; then
    INSTALL_YAZI=true
    if ! command -v yazi &>/dev/null; then
        # Instalar desde cargo o binario
        if command -v cargo &>/dev/null; then
            cargo install --locked yazi-fm yazi-cli
        else
            YAZI_URL=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest \
                | grep "browser_download_url.*yazi-x86_64-unknown-linux-gnu.zip" | head -1 | cut -d'"' -f4)
            wget -q "$YAZI_URL" -O /tmp/yazi.zip
            unzip -qo /tmp/yazi.zip -d /tmp/yazi
            sudo install /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
            rm -rf /tmp/yazi /tmp/yazi.zip
        fi
    fi
    print_success "yazi instalado"
fi

# --- vivid ---
INSTALL_VIVID=false
if ask_install "vivid (colores para ls)" \
    "Genera esquemas de colores para LS_COLORS con temas.
   Hace que los archivos en terminal tengan colores consistentes
   según su tipo (ejecutable, directorio, symlink, etc.)." "n"; then
    INSTALL_VIVID=true
    if ! command -v vivid &>/dev/null; then
        VIVID_URL=$(curl -s https://api.github.com/repos/sharkdp/vivid/releases/latest \
            | grep "browser_download_url.*vivid_.*amd64.deb" | head -1 | cut -d'"' -f4)
        wget -q "$VIVID_URL" -O /tmp/vivid.deb
        sudo dpkg -i /tmp/vivid.deb
        rm /tmp/vivid.deb
    fi
    print_success "vivid instalado"
fi

# --- dust ---
INSTALL_DUST=false
if ask_install "dust (reemplazo de du)" \
    "Muestra el uso de disco de forma visual con barras de progreso.
   Ejemplo: 'dust' en un directorio muestra qué subcarpetas pesan más." "n"; then
    INSTALL_DUST=true
    if ! command -v dust &>/dev/null; then
        DUST_URL=$(curl -s https://api.github.com/repos/bootandy/dust/releases/latest \
            | grep "browser_download_url.*dust_.*amd64.deb" | head -1 | cut -d'"' -f4)
        if [ -n "$DUST_URL" ]; then
            wget -q "$DUST_URL" -O /tmp/dust.deb
            sudo dpkg -i /tmp/dust.deb
            rm /tmp/dust.deb
        else
            cargo install du-dust 2>/dev/null || print_warning "No se pudo instalar dust"
        fi
    fi
    print_success "dust instalado"
fi

# --- procs ---
INSTALL_PROCS=false
if ask_install "procs (reemplazo de ps)" \
    "Muestra procesos con colores, filtros y formato legible.
   Ejemplo: 'procs firefox' muestra solo procesos de Firefox." "n"; then
    INSTALL_PROCS=true
    if ! command -v procs &>/dev/null; then
        PROCS_URL=$(curl -s https://api.github.com/repos/dalance/procs/releases/latest \
            | grep "browser_download_url.*procs-.*-linux.zip" | head -1 | cut -d'"' -f4)
        if [ -n "$PROCS_URL" ]; then
            wget -q "$PROCS_URL" -O /tmp/procs.zip
            unzip -qo /tmp/procs.zip -d /tmp/procs
            sudo install /tmp/procs/procs /usr/local/bin/ 2>/dev/null || \
                sudo find /tmp/procs -name "procs" -exec install {} /usr/local/bin/ \;
            rm -rf /tmp/procs /tmp/procs.zip
        fi
    fi
    print_success "procs instalado"
fi

# --- tealdeer ---
INSTALL_TLDR=false
if ask_install "tealdeer / tldr (cheatsheets de comandos)" \
    "Muestra ejemplos prácticos de cómo usar un comando.
   Ejemplo: 'tldr tar' muestra los usos más comunes de tar
   sin tener que leer el man page completo."; then
    INSTALL_TLDR=true
    if ! command -v tldr &>/dev/null; then
        sudo apt install -y tealdeer 2>/dev/null || {
            if command -v cargo &>/dev/null; then
                cargo install tealdeer
            else
                print_warning "Instalando tldr via npm como fallback..."
                npm install -g tldr 2>/dev/null || print_warning "No se pudo instalar tldr"
            fi
        }
    fi
    # Actualizar base de datos
    command -v tldr &>/dev/null && tldr --update 2>/dev/null || true
    print_success "tealdeer instalado"
fi

# --- fx ---
INSTALL_FX=false
if ask_install "fx (visor JSON interactivo)" \
    "Visor interactivo de JSON en terminal. Permite navegar,
   filtrar y transformar archivos JSON con atajos de teclado.
   Útil para trabajar con APIs y archivos de configuración." "n"; then
    INSTALL_FX=true
    if ! command -v fx &>/dev/null; then
        FX_URL=$(curl -s https://api.github.com/repos/antonmedv/fx/releases/latest \
            | grep "browser_download_url.*fx_linux_amd64" | head -1 | cut -d'"' -f4)
        if [ -n "$FX_URL" ]; then
            wget -q "$FX_URL" -O /tmp/fx
            chmod +x /tmp/fx
            sudo install /tmp/fx /usr/local/bin/
            rm /tmp/fx
        fi
    fi
    print_success "fx instalado"
fi

# --- newsboat ---
INSTALL_NEWSBOAT=false
if ask_install "newsboat (lector RSS en terminal)" \
    "Lector de feeds RSS/Atom en la terminal. Lee noticias de
   tecnología, Linux, desarrollo sin abrir el navegador.
   Incluye feeds preconfigurados en español e inglés." "n"; then
    INSTALL_NEWSBOAT=true
    install_if_missing newsboat newsboat
    print_success "newsboat instalado"
fi

# --- yt-dlp ---
INSTALL_YTDLP=false
if ask_install "yt-dlp (descargador de videos)" \
    "Descarga videos de YouTube y +1000 sitios más.
   Configurado para descargar en 1080p con mejor audio.
   Alias: 'yt'."; then
    INSTALL_YTDLP=true
    if ! command -v yt-dlp &>/dev/null; then
        sudo apt install -y yt-dlp 2>/dev/null || \
            pip3 install --user yt-dlp 2>/dev/null || \
            pipx install yt-dlp 2>/dev/null
    fi
    print_success "yt-dlp instalado"
fi

# --- zathura ---
INSTALL_ZATHURA=false
if ask_install "zathura (visor de PDF minimalista)" \
    "Visor de PDF ligero con atajos tipo vim (j/k para scroll,
   gg/G para inicio/fin). Tema oscuro Catppuccin Mocha.
   Ideal si no quieres abrir Evince/Okular para PDFs simples." "n"; then
    INSTALL_ZATHURA=true
    sudo apt install -y zathura zathura-pdf-poppler
    print_success "zathura instalado"
fi

# --- Neovim ---
INSTALL_NVIM=false
if ask_install "Neovim" \
    "Editor de texto avanzado basado en Vim. Extensible con Lua,
   soporta LSP, autocompletado, tree-sitter, y miles de plugins.
   Se configura como editor por defecto (alias: vim, vi)."; then
    INSTALL_NVIM=true
    if ! command -v nvim &>/dev/null; then
        # Instalar versión estable más reciente
        sudo add-apt-repository -y ppa:neovim-ppa/stable 2>/dev/null || true
        sudo apt update
        sudo apt install -y neovim
    fi
    print_success "Neovim instalado"
fi

# ============================================================
# PASO 7: Entorno de desarrollo (opcional)
# ============================================================

print_header "Paso 7: Entorno de desarrollo"
echo "Lenguajes y herramientas de programación."
echo ""

# --- NVM + Node.js ---
INSTALL_NODE=false
if ask_install "NVM + Node.js (JavaScript/TypeScript)" \
    "Gestor de versiones de Node.js. Permite tener múltiples
   versiones instaladas y cambiar entre ellas fácilmente.
   Instala la versión LTS más reciente."; then
    INSTALL_NODE=true
    if [ ! -d "$HOME/.nvm" ]; then
        print_info "Instalando NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm use --lts
    fi
    print_success "NVM + Node.js instalado"
fi

# --- Bun ---
INSTALL_BUN=false
if ask_install "Bun (runtime JS ultra-rápido)" \
    "Runtime de JavaScript alternativo a Node.js, mucho más rápido.
   Incluye bundler, test runner y gestor de paquetes integrado.
   Compatible con la mayoría de paquetes npm." "n"; then
    INSTALL_BUN=true
    if ! command -v bun &>/dev/null; then
        curl -fsSL https://bun.sh/install | bash
    fi
    print_success "Bun instalado"
fi

# --- Go ---
INSTALL_GO=false
if ask_install "Go (Golang)" \
    "Lenguaje de programación de Google. Rápido, compilado,
   ideal para backends, CLIs y herramientas de sistema.
   Muchas herramientas de este setup están escritas en Go." "n"; then
    INSTALL_GO=true
    if ! command -v go &>/dev/null; then
        GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -1)
        wget -q "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf /tmp/go.tar.gz
        rm /tmp/go.tar.gz
        export PATH=$PATH:/usr/local/go/bin
    fi
    print_success "Go instalado"
fi

# --- Rust ---
INSTALL_RUST=false
if ask_install "Rust (Rustlang)" \
    "Lenguaje de programación de sistemas, seguro y rápido.
   Muchas herramientas modernas de CLI están escritas en Rust
   (bat, fd, ripgrep, lsd, starship, zoxide, yazi, etc.)." "n"; then
    INSTALL_RUST=true
    if ! command -v rustc &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    print_success "Rust instalado"
fi

# --- Python tools ---
INSTALL_PYTHON=false
if ask_install "Python herramientas (pipx, poetry, black, flake8)" \
    "Herramientas de desarrollo Python: pipx (instalar CLIs aislados),
   poetry (gestor de proyectos), black (formateador), flake8 (linter)." "n"; then
    INSTALL_PYTHON=true
    sudo apt install -y python3 python3-pip python3-venv pipx
    pipx ensurepath
    pipx install poetry 2>/dev/null || true
    pipx install black 2>/dev/null || true
    pipx install flake8 2>/dev/null || true
    print_success "Herramientas Python instaladas"
fi

# ============================================================
# PASO 8: Utilidades extra
# ============================================================

print_header "Paso 8: Utilidades extra"

# jq, tree, xclip
print_info "Instalando utilidades base (jq, tree, xclip, wl-clipboard)..."
sudo apt install -y jq tree xclip wl-clipboard p7zip-full unrar 2>/dev/null || true
print_success "Utilidades base instaladas"

# fastfetch
INSTALL_FASTFETCH=false
if ask_install "fastfetch (info del sistema)" \
    "Muestra información del sistema de forma bonita al abrir terminal
   (distro, kernel, DE, RAM, CPU, GPU, etc.). Similar a neofetch
   pero mucho más rápido." "n"; then
    INSTALL_FASTFETCH=true
    if ! command -v fastfetch &>/dev/null; then
        sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch 2>/dev/null || true
        sudo apt update
        sudo apt install -y fastfetch 2>/dev/null || {
            FF_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
                | grep "browser_download_url.*linux-amd64.deb" | head -1 | cut -d'"' -f4)
            wget -q "$FF_URL" -O /tmp/fastfetch.deb
            sudo dpkg -i /tmp/fastfetch.deb
            rm /tmp/fastfetch.deb
        }
    fi
    print_success "fastfetch instalado"
fi

# ============================================================
# PASO 9: Crear backup y symlinks
# ============================================================

print_header "Paso 9: Instalando configuraciones (symlinks)"

# Archivos raíz a enlazar
ROOT_FILES=(.zshrc .zprofile .gitconfig .gitignore_global .ripgreprc .editorconfig)

# Configs a enlazar
CONFIG_ITEMS=(starship.toml)
$INSTALL_KITTY && CONFIG_ITEMS+=(kitty)
$INSTALL_LAZYGIT && CONFIG_ITEMS+=(lazygit)
$INSTALL_LSD && CONFIG_ITEMS+=(lsd)
$INSTALL_BTOP && CONFIG_ITEMS+=(btop)
$INSTALL_ZATHURA && CONFIG_ITEMS+=(zathura)
$INSTALL_YTDLP && CONFIG_ITEMS+=(yt-dlp)
$INSTALL_FD && CONFIG_ITEMS+=(fd)

# Backup
NEEDS_BACKUP=false
for f in "${ROOT_FILES[@]}"; do
    [ -e "$HOME/$f" ] && NEEDS_BACKUP=true && break
done

if $NEEDS_BACKUP; then
    print_info "Creando backup en $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR/.config"
    for f in "${ROOT_FILES[@]}"; do
        [ -e "$HOME/$f" ] && cp -r "$HOME/$f" "$BACKUP_DIR/$f"
    done
    for item in "${CONFIG_ITEMS[@]}"; do
        [ -e "$HOME/.config/$item" ] && cp -r "$HOME/.config/$item" "$BACKUP_DIR/.config/$item"
    done
    print_success "Backup creado"
fi

# Crear symlinks
print_info "Creando symlinks..."
for f in "${ROOT_FILES[@]}"; do
    if [ -e "$DOTFILES_DIR/$f" ]; then
        ln -sf "$DOTFILES_DIR/$f" "$HOME/$f"
        echo "  → ~/$f"
    fi
done

mkdir -p "$HOME/.config"
for item in "${CONFIG_ITEMS[@]}"; do
    src="$DOTFILES_DIR/.config/$item"
    dst="$HOME/.config/$item"
    if [ -e "$src" ]; then
        rm -rf "$dst"
        ln -sf "$src" "$dst"
        echo "  → ~/.config/$item"
    fi
done

print_success "Configuraciones enlazadas"

# ============================================================
# PASO 10: Configurar newsboat (si se instaló)
# ============================================================

if $INSTALL_NEWSBOAT; then
    print_info "Configurando newsboat con feeds preconfigurados..."
    mkdir -p "$HOME/.newsboat"
    if [ ! -f "$HOME/.newsboat/urls" ]; then
        cat > "$HOME/.newsboat/urls" << 'EOF'
# Linux en Español
https://blog.desdelinux.net/feed/  "DesdeLinux"
https://soloconlinux.org.es/rss  "SoloConLinux"
https://www.muylinux.com/feed  "MuyLinux"
https://ubunlog.com/feed  "Ubunlog"
https://www.linuxadictos.com/feed  "Linux Adictos"
https://proyectotictac.com/feed  "Proyecto TicTac"

# Linux / FOSS en Inglés
https://www.phoronix.com/rss.php  "Phoronix"
https://feed.itsfoss.com  "It's FOSS News"
https://feeds.feedburner.com/d0od  "OMG!Linux"
https://www.tecmint.com/feed/  "Tecmint"
https://lwn.net/headlines/rss  "LWN.net"

# Ubuntu
https://ubuntu.com/blog/feed  "Ubuntu Blog"
EOF
        print_success "Feeds de newsboat configurados"
    fi
fi

# ============================================================
# PASO 11: Cambiar shell a Zsh
# ============================================================

if $INSTALL_ZSH; then
    echo ""
    if ask_install "Cambiar shell por defecto a Zsh" \
        "Tu shell actual es $(basename $SHELL). ¿Quieres que Zsh sea
   tu shell por defecto? (requiere cerrar sesión para tomar efecto)"; then
        chsh -s "$(which zsh)"
        print_success "Shell cambiada a Zsh (cierra sesión para que tome efecto)"
    fi
fi

# ============================================================
# PASO 12: Configurar yt-dlp directorio de descargas
# ============================================================

if $INSTALL_YTDLP; then
    # Actualizar ruta de descarga en config de yt-dlp
    YT_CONFIG="$DOTFILES_DIR/.config/yt-dlp/config"
    if [ -f "$YT_CONFIG" ]; then
        VIDEOS_DIR="$HOME/Vídeos/youtube"
        mkdir -p "$VIDEOS_DIR"
        sed -i "s|-o /home/pipeaalzamora/Vídeos/youtube/|-o $HOME/Vídeos/youtube/|g" "$YT_CONFIG"
    fi
fi

# ============================================================
# Resumen final
# ============================================================

print_header "¡Instalación completada!"

echo -e "${GREEN}Componentes instalados:${NC}"
echo ""
$INSTALL_ZSH && echo "  ✅ Zsh + Oh My Zsh + plugins"
$INSTALL_STARSHIP && echo "  ✅ Starship prompt"
$INSTALL_KITTY && echo "  ✅ Kitty terminal"
$INSTALL_FONTS && echo "  ✅ Nerd Fonts"
$INSTALL_LSD && echo "  ✅ lsd (ls mejorado)"
$INSTALL_BAT && echo "  ✅ bat (cat mejorado)"
$INSTALL_FD && echo "  ✅ fd (find mejorado)"
$INSTALL_RG && echo "  ✅ ripgrep (grep mejorado)"
$INSTALL_FZF && echo "  ✅ fzf (fuzzy finder)"
$INSTALL_ZOXIDE && echo "  ✅ zoxide (cd inteligente)"
$INSTALL_LAZYGIT && echo "  ✅ lazygit (git visual)"
$INSTALL_DELTA && echo "  ✅ delta (diffs mejorados)"
$INSTALL_BTOP && echo "  ✅ btop (monitor sistema)"
$INSTALL_YAZI && echo "  ✅ yazi (file manager)"
$INSTALL_VIVID && echo "  ✅ vivid (colores ls)"
$INSTALL_DUST && echo "  ✅ dust (uso de disco)"
$INSTALL_PROCS && echo "  ✅ procs (procesos)"
$INSTALL_TLDR && echo "  ✅ tealdeer (cheatsheets)"
$INSTALL_FX && echo "  ✅ fx (JSON viewer)"
$INSTALL_NEWSBOAT && echo "  ✅ newsboat (RSS)"
$INSTALL_YTDLP && echo "  ✅ yt-dlp (videos)"
$INSTALL_ZATHURA && echo "  ✅ zathura (PDF viewer)"
$INSTALL_NVIM && echo "  ✅ Neovim"
$INSTALL_NODE && echo "  ✅ NVM + Node.js"
$INSTALL_BUN && echo "  ✅ Bun"
$INSTALL_GO && echo "  ✅ Go"
$INSTALL_RUST && echo "  ✅ Rust"
$INSTALL_PYTHON && echo "  ✅ Python tools"
$INSTALL_FASTFETCH && echo "  ✅ fastfetch"
echo ""
echo -e "${YELLOW}Próximos pasos:${NC}"
echo "  1. Cierra sesión y vuelve a entrar (para que Zsh tome efecto)"
echo "  2. Abre Kitty como tu terminal"
echo "  3. Edita ~/.gitconfig con tu nombre y email"
echo ""
echo -e "${CYAN}Comandos útiles:${NC}"
echo "  lg        → lazygit"
echo "  j <dir>   → saltar a directorio (zoxide)"
echo "  Ctrl+F    → buscar archivo con fzf"
echo "  Ctrl+R    → historial de comandos con fzf"
echo "  y         → yazi (file manager)"
echo "  bp        → btop (monitor)"
echo ""
echo -e "${PURPLE}¡Disfruta tu nueva terminal! 🚀${NC}"
