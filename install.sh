#!/bin/bash
# ============================================================
# Dotfiles Installer para Arch Linux / EndeavourOS
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

pkg_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

# ============================================================
# Verificar Arch Linux / EndeavourOS
# ============================================================

if [[ ! -f /etc/os-release ]]; then
    print_error "No se puede detectar el sistema operativo"
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

print_header "Instalador de Dotfiles para Arch Linux / EndeavourOS"
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
print_info "Sincronizando repositorios y actualizando el sistema..."
sudo pacman -Syu --noconfirm

print_info "Instalando dependencias base (git, curl, wget, unzip, base-devel)..."
pkg_install git curl wget unzip base-devel ca-certificates

# Instalar AUR Helper (yay) si no existe
if ! command -v yay &>/dev/null; then
    print_info "Instalando AUR helper (yay)..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
fi

print_success "Sistema base actualizado y yay preparado"

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

    pkg_install zsh
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
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    print_info "Instalando plugin: zsh-syntax-highlighting"
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
   Muestra info contextual: rama git, lenguaje del proyecto, errores.
   Tema Catppuccin Mocha."; then
    INSTALL_STARSHIP=true
    pkg_install starship
    print_success "Starship instalado"
fi

# ============================================================
# PASO 4: Terminal Kitty
# ============================================================

INSTALL_KITTY=false
if ask_install "Kitty" \
    "Terminal emulador acelerado por GPU. Soporta transparencia,
   ligatures de fuentes, tabs, splits y es muy rápido.
   Excelente rendimiento en Wayland y KDE Plasma."; then
    INSTALL_KITTY=true
    pkg_install kitty
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

    if ! fc-list | grep -qi "MesloLGS"; then
        print_info "Descargando MesloLGS Nerd Font..."
        MESLO_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
        wget -q "$MESLO_URL" -O /tmp/Meslo.zip
        unzip -qo /tmp/Meslo.zip -d "$FONT_DIR/MesloNerd"
        rm /tmp/Meslo.zip
    fi

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

INSTALL_LSD=false
if ask_install "lsd (reemplazo de ls)" "Listado de archivos con iconos y colores."; then
    INSTALL_LSD=true
    pkg_install lsd
    print_success "lsd instalado"
fi

INSTALL_BAT=false
if ask_install "bat (reemplazo de cat)" "Muestra archivos con syntax highlighting e integración git."; then
    INSTALL_BAT=true
    pkg_install bat

    # Instalar tema Catppuccin Mocha para bat
    print_info "Instalando tema Catppuccin Mocha para bat..."
    BAT_THEME_DIR="$(bat --config-dir)/themes"
    mkdir -p "$BAT_THEME_DIR"
    curl -fsSL -o "$BAT_THEME_DIR/Catppuccin Mocha.tmTheme" \
        "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme" \
        && bat cache --build >/dev/null 2>&1 \
        && print_success "Tema Catppuccin Mocha instalado" \
        || print_warning "No se pudo instalar el tema Catppuccin de bat"

    print_success "bat instalado"
fi

INSTALL_FD=false
if ask_install "fd (reemplazo de find)" "Búsqueda de archivos ultra-rápida con sintaxis simple."; then
    INSTALL_FD=true
    pkg_install fd
    print_success "fd instalado"
fi

INSTALL_RG=false
if ask_install "ripgrep (reemplazo de grep)" "Búsqueda de texto en archivos extremadamente rápida."; then
    INSTALL_RG=true
    pkg_install ripgrep
    print_success "ripgrep instalado"
fi

INSTALL_FZF=false
if ask_install "fzf (fuzzy finder)" "Buscador interactivo fuzzy para archivos e historial."; then
    INSTALL_FZF=true
    pkg_install fzf
    print_success "fzf instalado"
fi

INSTALL_ZOXIDE=false
if ask_install "zoxide (reemplazo de cd)" "Aprende los directorios que más visitas (comando 'j')."; then
    INSTALL_ZOXIDE=true
    pkg_install zoxide
    print_success "zoxide instalado"
fi

INSTALL_LAZYGIT=false
if ask_install "lazygit (git visual en terminal)" "Interfaz TUI para operaciones complejas de Git."; then
    INSTALL_LAZYGIT=true
    pkg_install lazygit
    print_success "lazygit instalado"
fi

INSTALL_DELTA=false
if ask_install "delta (diffs mejorados de git)" "Diffs de Git con syntax highlighting y formato side-by-side."; then
    INSTALL_DELTA=true
    pkg_install git-delta
    print_success "delta instalado"
fi

INSTALL_BTOP=false
if ask_install "btop (monitor del sistema)" "Monitor de recursos del sistema moderno y visual."; then
    INSTALL_BTOP=true
    pkg_install btop
    print_success "btop instalado"
fi

INSTALL_YAZI=false
if ask_install "yazi (file manager en terminal)" "Explorador de archivos en terminal con previews visuales."; then
    INSTALL_YAZI=true
    pkg_install yazi
    print_success "yazi instalado"
fi

INSTALL_VIVID=false
if ask_install "vivid (colores para ls)" "Generador de esquemas de colores para LS_COLORS." "n"; then
    INSTALL_VIVID=true
    pkg_install vivid
    print_success "vivid instalado"
fi

INSTALL_DUST=false
if ask_install "dust (reemplazo de du)" "Uso de disco visual con barras de progreso." "n"; then
    INSTALL_DUST=true
    pkg_install du-dust
    print_success "dust instalado"
fi

INSTALL_PROCS=false
if ask_install "procs (reemplazo de ps)" "Muestra procesos con colores y formato estructurado." "n"; then
    INSTALL_PROCS=true
    pkg_install procs
    print_success "procs instalado"
fi

INSTALL_TLDR=false
if ask_install "tealdeer / tldr (cheatsheets de comandos)" "Muestra ejemplos prácticos y concisos de comandos."; then
    INSTALL_TLDR=true
    pkg_install tealdeer
    tldr --update 2>/dev/null || true
    print_success "tealdeer instalado"
fi

INSTALL_FX=false
if ask_install "fx (visor JSON interactivo)" "Visor interactivo de JSON en terminal." "n"; then
    INSTALL_FX=true
    pkg_install fx
    print_success "fx instalado"
fi

INSTALL_NEWSBOAT=false
if ask_install "newsboat (lector RSS en terminal)" "Lector de feeds RSS/Atom en la terminal." "n"; then
    INSTALL_NEWSBOAT=true
    pkg_install newsboat
    print_success "newsboat instalado"
fi

INSTALL_YTDLP=false
if ask_install "yt-dlp (descargador de videos)" "Descarga de videos de YouTube y plataformas soportadas."; then
    INSTALL_YTDLP=true
    pkg_install yt-dlp
    print_success "yt-dlp instalado"
fi

INSTALL_ZATHURA=false
if ask_install "zathura (visor de PDF minimalista)" "Visor de PDF ligero con navegación estilo Vim." "n"; then
    INSTALL_ZATHURA=true
    pkg_install zathura zathura-pdf-poppler
    print_success "zathura instalado"
fi

INSTALL_NVIM=false
if ask_install "Neovim" "Editor de texto avanzado extensible con Lua."; then
    INSTALL_NVIM=true
    pkg_install neovim
    print_success "Neovim instalado"
fi

# ============================================================
# PASO 7: Entorno de desarrollo
# ============================================================

print_header "Paso 7: Entorno de desarrollo"

INSTALL_NODE=false
if ask_install "NVM + Node.js (JavaScript/TypeScript)" "Gestor de versiones de Node.js."; then
    INSTALL_NODE=true
    if [ ! -d "$HOME/.nvm" ]; then
        print_info "Instalando NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi
    print_success "NVM instalado"
fi

INSTALL_BUN=false
if ask_install "Bun (runtime JS ultra-rápido)" "Runtime de JS alternativo y rápido." "n"; then
    INSTALL_BUN=true
    pkg_install bun
    print_success "Bun instalado"
fi

INSTALL_GO=false
if ask_install "Go (Golang)" "Lenguaje de programación Go." "n"; then
    INSTALL_GO=true
    pkg_install go
    print_success "Go instalado"
fi

INSTALL_RUST=false
if ask_install "Rust (Rustlang)" "Lenguaje de programación Rust y cargo." "n"; then
    INSTALL_RUST=true
    pkg_install rustup
    rustup default stable
    print_success "Rust instalado"
fi

INSTALL_PYTHON=false
if ask_install "Python herramientas (pipx, poetry)" "Herramientas de entorno Python." "n"; then
    INSTALL_PYTHON=true
    pkg_install python python-pip python-pipx python-poetry
    pipx ensurepath 2>/dev/null || true
    print_success "Herramientas Python instaladas"
fi

# ============================================================
# PASO 8: Utilidades extra
# ============================================================

print_header "Paso 8: Utilidades extra"
print_info "Instalando utilidades base (jq, tree, xclip, wl-clipboard, p7zip, unrar)..."
pkg_install jq tree xclip wl-clipboard p7zip unrar

INSTALL_FASTFETCH=false
if ask_install "fastfetch (info del sistema)" "Muestra información del sistema rápida y estilizada." "n"; then
    INSTALL_FASTFETCH=true
    pkg_install fastfetch
    print_success "fastfetch instalado"
fi

# ============================================================
# PASO 9: Crear backup y symlinks
# ============================================================

print_header "Paso 9: Instalando configuraciones (symlinks)"

ROOT_FILES=(.zshrc .zprofile .gitconfig .gitignore_global .ripgreprc .editorconfig)

CONFIG_ITEMS=(starship.toml)
$INSTALL_KITTY && CONFIG_ITEMS+=(kitty)
$INSTALL_LAZYGIT && CONFIG_ITEMS+=(lazygit)
$INSTALL_LSD && CONFIG_ITEMS+=(lsd)
$INSTALL_BTOP && CONFIG_ITEMS+=(btop)
$INSTALL_ZATHURA && CONFIG_ITEMS+=(zathura)
$INSTALL_YTDLP && CONFIG_ITEMS+=(yt-dlp)
$INSTALL_FD && CONFIG_ITEMS+=(fd)

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

if [ ! -f "$HOME/.zshrc.local" ] && [ -f "$DOTFILES_DIR/.zshrc.local.example" ]; then
    cp "$DOTFILES_DIR/.zshrc.local.example" "$HOME/.zshrc.local"
    print_info "Creado ~/.zshrc.local desde plantilla"
fi

# ============================================================
# PASO 10: Configurar newsboat (si se instaló)
# ============================================================

if $INSTALL_NEWSBOAT; then
    print_info "Configurando newsboat..."
    mkdir -p "$HOME/.newsboat"
    if [ ! -f "$HOME/.newsboat/urls" ]; then
        cat > "$HOME/.newsboat/urls" << 'EOF'
# Linux en Español
https://blog.desdelinux.net/feed/  "DesdeLinux"
https://soloconlinux.org.es/rss  "SoloConLinux"
https://www.muylinux.com/feed  "MuyLinux"

# Linux / Arch
https://archlinux.org/news/news.xml  "Arch Linux News"
https://www.phoronix.com/rss.php  "Phoronix"
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
        "Tu shell actual es $(basename $SHELL). ¿Quieres que Zsh sea tu shell por defecto?"; then
        chsh -s "$(which zsh)"
        print_success "Shell cambiada a Zsh"
    fi
fi

if $INSTALL_YTDLP; then
    mkdir -p "$HOME/Vídeos/youtube"
fi

print_header "¡Instalación completada!"
echo -e "${PURPLE}¡Disfruta tu nuevo entorno en Arch Linux / EndeavourOS! 🚀${NC}"