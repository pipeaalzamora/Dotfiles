#!/bin/bash
# ============================================================
# Dotfiles Installer para Arch Linux / EndeavourOS
# Instalación interactiva detallada con descripción de paquetes
# ============================================================

set -e

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

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
    ask_yes_no "¿Deseas instalar este componente?" "$default"
}

pkg_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

# ============================================================
# Verificación de Distribución
# ============================================================

if [[ ! -f /etc/os-release ]]; then
    print_error "No se pudo detectar la distribución Linux."
    exit 1
fi

source /etc/os-release
if [[ "$ID" != "arch" && "$ID_LIKE" != *"arch"* && "$ID" != "endeavouros" ]]; then
    print_error "Este instalador está optimizado para Arch Linux / EndeavourOS. Detectado: $ID"
    exit 1
fi

# ============================================================
# Inicio
# ============================================================

print_header "Instalador de Dotfiles — Arch Linux / EndeavourOS"
echo -e "Sistema detectado:   ${GREEN}$PRETTY_NAME${NC}"
echo -e "Ruta de Dotfiles:    ${CYAN}$DOTFILES_DIR${NC}"
echo ""
echo "Cada programa incluye una breve descripción de su función y utilidad."
echo "Puedes elegir qué instalar respondiendo 's' o 'n' a cada paso."
echo ""
echo -e "${YELLOW}─────────────────────────────────────────────────────${NC}"

# ============================================================
# PASO 1: Actualizar sistema y dependencias base
# ============================================================

print_header "Paso 1: Actualizar sistema y preparar dependencias base"
print_info "Sincronizando repositorios y actualizando el sistema..."
sudo pacman -Syu --noconfirm

print_info "Instalando utilidades del sistema (git, curl, wget, unzip, base-devel)..."
pkg_install git curl wget unzip base-devel ca-certificates

if ! command -v yay &>/dev/null; then
    print_info "Instalando AUR Helper (yay)..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
fi

# Detección y configuración de Snapshots Btrfs
if [ "$(findmnt -n -o FSTYPE / 2>/dev/null)" = "btrfs" ]; then
    if ask_install "Snapshots Automáticos del Sistema (Btrfs + Snapper + GRUB)" \
        "Crea puntos de restauración instantáneos antes de cada actualización con pacman/yay\ny añade entradas automáticas en el menú de GRUB para arrancar si algo falla."; then
        if [ -f "$DOTFILES_DIR/scripts/setup-btrfs-snapshots.sh" ]; then
            bash "$DOTFILES_DIR/scripts/setup-btrfs-snapshots.sh"
        fi
    fi
fi

print_success "Sistema base listo y repositorios sincronizados"

# ============================================================
# PASO 2: Shell (Zsh + Oh My Zsh)
# ============================================================

print_header "Paso 2: Shell y Experiencia de Terminal"

INSTALL_ZSH=false
if ask_install "Zsh + Oh My Zsh + Plugins" \
    "Shell moderna que reemplaza a Bash. Incluye:\n   • zsh-autosuggestions: Autocompleta comandos según tu historial en tiempo real.\n   • zsh-syntax-highlighting: Resalta comandos válidos en verde y errores en rojo."; then
    INSTALL_ZSH=true
    pkg_install zsh

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Instalando Oh My Zsh..."
        RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    print_info "Descargando plugin: zsh-autosuggestions..."
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    print_info "Descargando plugin: zsh-syntax-highlighting..."
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting \
            "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    print_success "Zsh y plugins configurados"
fi

# ============================================================
# PASO 3: Starship Prompt
# ============================================================

print_header "Paso 3: Prompt de Terminal"

INSTALL_STARSHIP=false
if ask_install "Starship Prompt" \
    "Prompt ultrarrápido y personalizable escrito en Rust.\n   Muestra el directorio actual, rama de git, versión de Node/Go/Python\n   y estado de batería con la paleta Catppuccin Mocha."; then
    INSTALL_STARSHIP=true
    pkg_install starship
    print_success "Starship instalado"
fi

# ============================================================
# PASO 4: Kitty Terminal Emulator
# ============================================================

print_header "Paso 4: Emulador de Terminal"

INSTALL_KITTY=false
if ask_install "Kitty Terminal" \
    "Emulador de terminal acelerado por GPU (OpenGL).\n   Soporta transparencias, división de ventanas, pestañas, renderizado\n   de imágenes de alta velocidad y excelente rendimiento en Wayland."; then
    INSTALL_KITTY=true
    pkg_install kitty
    print_success "Kitty instalado"
fi

# ============================================================
# PASO 5: Tipografías Nerd Fonts
# ============================================================

print_header "Paso 5: Tipografías con Iconos"

INSTALL_FONTS=false
if ask_install "Nerd Fonts (MesloLGS + JetBrains Mono)" \
    "Fuentes tipográficas con glifos e iconos incrustados.\n   Indispensables para ver correctamente iconos en Starship, lsd, lazygit y yazi."; then
    INSTALL_FONTS=true

    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"

    if ! fc-list | grep -qi "MesloLGS"; then
        print_info "Descargando MesloLGS Nerd Font..."
        MESLO_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
        wget -q "$MESLO_URL" -O /tmp/Meslo.zip
        unzip -qo /tmp/Meslo.zip -d "$FONT_DIR/Meslo"
        rm /tmp/Meslo.zip
    fi

    if ! fc-list | grep -qi "JetBrainsMono Nerd"; then
        print_info "Descargando JetBrains Mono Nerd Font..."
        JB_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        wget -q "$JB_URL" -O /tmp/JetBrainsMono.zip
        unzip -qo /tmp/JetBrainsMono.zip -d "$FONT_DIR/JetBrainsMono"
        rm /tmp/JetBrainsMono.zip
    fi

    fc-cache -f "$FONT_DIR" 2>/dev/null || true
    print_success "Nerd Fonts instaladas en ~/.local/share/fonts"
fi

# ============================================================
# PASO 6: Herramientas CLI modernas
# ============================================================

print_header "Paso 6: Utilidades CLI de Alto Rendimiento"

INSTALL_LSD=false
if ask_install "lsd (Reemplazo moderno de 'ls')" \
    "Muestra directorios y archivos organizados con colores vibrantes,\n   iconos tipográficos y vista en árbol opcional."; then
    INSTALL_LSD=true
    pkg_install lsd
    print_success "lsd instalado"
fi

INSTALL_BAT=false
if ask_install "bat (Reemplazo inteligente de 'cat')" \
    "Visualizador de archivos con resaltado de sintaxis para +100 lenguajes,\n   números de línea e indicadores de cambios Git en el margen lateral."; then
    INSTALL_BAT=true
    pkg_install bat

    print_info "Instalando tema Catppuccin Mocha para bat..."
    BAT_THEME_DIR="$(bat --config-dir)/themes"
    mkdir -p "$BAT_THEME_DIR"
    curl -fsSL -o "$BAT_THEME_DIR/Catppuccin Mocha.tmTheme" \
        "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme" \
        && bat cache --build >/dev/null 2>&1 \
        && print_success "Tema Catppuccin Mocha configurado en bat" \
        || print_warning "No se pudo compilar el tema de bat"

    print_success "bat instalado"
fi

INSTALL_FD=false
if ask_install "fd (Buscador rápido de archivos)" \
    "Alternativa simple e intuitiva al comando 'find'.\n   Busca archivos respetando .gitignore de forma predeterminada y con mayor velocidad."; then
    INSTALL_FD=true
    pkg_install fd
    print_success "fd instalado"
fi

INSTALL_RG=false
if ask_install "ripgrep (Búsqueda ultra rápida en código)" \
    "Herramienta para buscar cadenas de texto y expresiones regulares\n   en proyectos completos en milisegundos ignorando archivos pesados."; then
    INSTALL_RG=true
    pkg_install ripgrep
    print_success "ripgrep instalado"
fi

INSTALL_FZF=false
if ask_install "fzf (Fuzzy Finder interactivo)" \
    "Buscador interactivo difuso para la terminal.\n   Permite buscar archivos al vuelo y consultar el historial de comandos con Ctrl+R."; then
    INSTALL_FZF=true
    pkg_install fzf
    print_success "fzf instalado"
fi

INSTALL_ZOXIDE=false
if ask_install "zoxide (Navegación inteligente entre carpetas)" \
    "Aprende las rutas que visitas con frecuencia en la terminal.\n   Permite saltar a cualquier carpeta usando solo parte de su nombre con 'j <directorio>'."; then
    INSTALL_ZOXIDE=true
    pkg_install zoxide
    print_success "zoxide instalado"
fi

INSTALL_ZELLIJ=false
if ask_install "Zellij (Multiplexor de terminal)" \
    "Alternativa moderna a tmux con paneles divididos, pestañas,\n   modo flotante, soporte total para ratón y tema Catppuccin Mocha."; then
    INSTALL_ZELLIJ=true
    pkg_install zellij
    print_success "Zellij instalado"
fi

INSTALL_LAZYGIT=false
if ask_install "lazygit (Interfaz visual TUI para Git)" \
    "Interfaz gráfica en terminal que permite hacer commits parciales,\n   gestionar ramas, resolver conflictos y hacer rebase fácilmente mediante el alias 'lg'."; then
    INSTALL_LAZYGIT=true
    pkg_install lazygit
    print_success "lazygit instalado"
fi

INSTALL_DELTA=false
if ask_install "git-delta (Visor de diferencias en Git)" \
    "Mejora 'git diff' y 'git log' con vista lado a lado (side-by-side),\n   resaltado de sintaxis y tema visual Catppuccin."; then
    INSTALL_DELTA=true
    pkg_install git-delta
    print_success "git-delta instalado"
fi

INSTALL_BTOP=false
if ask_install "btop (Monitor de recursos y procesos)" \
    "Monitor del sistema en terminal con gráficos de CPU, RAM, discos,\n   tráfico de red, uso de GPU y administración de procesos (comando 'bp')."; then
    INSTALL_BTOP=true
    pkg_install btop
    print_success "btop instalado"
fi

INSTALL_YAZI=false
if ask_install "yazi (Explorador de archivos en terminal)" \
    "Administrador de archivos de consola ultrarrápido (Rust) con navegación\n   tipo Vim, vista previa de imágenes y PDFs (función 'y')."; then
    INSTALL_YAZI=true
    pkg_install yazi
    print_success "yazi instalado"
fi

INSTALL_VIVID=false
if ask_install "vivid (Generador de colores LS_COLORS)" \
    "Genera una paleta de colores coherente y armónica para distinguir\n   tipos de archivos (binarios, archivos comprimidos, scripts) en la shell." "n"; then
    INSTALL_VIVID=true
    pkg_install vivid
    print_success "vivid instalado"
fi

INSTALL_DUST=false
if ask_install "dust (Visualizador de espacio en disco)" \
    "Alternativa a 'du' que representa visualmente qué carpetas y archivos\n   ocupan más espacio en tu disco mediante barras proporcionales." "n"; then
    INSTALL_DUST=true
    pkg_install du-dust
    print_success "dust instalado"
fi

INSTALL_PROCS=false
if ask_install "procs (Visualizador moderno de procesos)" \
    "Reemplazo de 'ps' con salida formateada en tablas limpias,\n   colores según el estado del proceso y búsqueda por nombre integrada." "n"; then
    INSTALL_PROCS=true
    pkg_install procs
    print_success "procs instalado"
fi

INSTALL_TLDR=false
if ask_install "tealdeer / tldr (Cheatsheets y ejemplos de comandos)" \
    "Muestra resúmenes prácticos con los ejemplos de uso más comunes\n   de cualquier comando en Linux sin necesidad de leer manuales extensos."; then
    INSTALL_TLDR=true
    pkg_install tealdeer
    tldr --update 2>/dev/null || true
    print_success "tealdeer instalado"
fi

INSTALL_FX=false
if ask_install "fx (Explorador interactivo de JSON)" \
    "Herramienta interactiva para inspeccionar, colapsar y transformar\n   archivos JSON en la terminal, ideal para desarrollo y APIs." "n"; then
    INSTALL_FX=true
    pkg_install fx
    print_success "fx instalado"
fi

INSTALL_NEWSBOAT=false
if ask_install "newsboat (Lector de RSS/Atom en terminal)" \
    "Cliente ligero para leer noticias, blogs y fuentes técnicas (Arch, Phoronix)\n   directamente en la consola sin distracciones." "n"; then
    INSTALL_NEWSBOAT=true
    pkg_install newsboat
    print_success "newsboat instalado"
fi

INSTALL_YTDLP=false
if ask_install "yt-dlp (Descargador de audio y video)" \
    "Descarga videos y música en máxima calidad desde YouTube y cientos de plataformas.\n   Configurado para guardar automáticamente en ~/Vídeos/youtube."; then
    INSTALL_YTDLP=true
    pkg_install yt-dlp
    print_success "yt-dlp instalado"
fi

INSTALL_ZATHURA=false
if ask_install "zathura (Visor PDF minimalista)" \
    "Visor de documentos PDF ultraligero y rápido con control mediante teclas\n   de Vim (j/k) y tema oscuro Catppuccin Mocha." "n"; then
    INSTALL_ZATHURA=true
    pkg_install zathura zathura-pdf-poppler
    print_success "zathura instalado"
fi

INSTALL_NVIM=false
if ask_install "Neovim (Editor de código modal)" \
    "Editor extensible con soporte para LSP, autocompletado y sintaxis avanzada.\n   Configurado como editor por defecto del sistema."; then
    INSTALL_NVIM=true
    pkg_install neovim
    print_success "Neovim instalado"
fi

# ============================================================
# PASO 7: Entornos de Desarrollo
# ============================================================

print_header "Paso 7: Lenguajes y Gestores de Entorno"

INSTALL_NODE=false
if ask_install "NVM + Node.js (JavaScript / TypeScript)" \
    "Node Version Manager para instalar y cambiar fácilmente entre versiones de Node.js."; then
    INSTALL_NODE=true
    if [ ! -d "$HOME/.nvm" ]; then
        print_info "Instalando NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi
    print_success "NVM instalado"
fi

INSTALL_BUN=false
if ask_install "Bun (Runtime de JS/TS ultrarrápido)" \
    "Alternativa a Node con bundler, ejecutor de pruebas y gestor de paquetes de alto rendimiento." "n"; then
    INSTALL_BUN=true
    pkg_install bun
    print_success "Bun instalado"
fi

INSTALL_GO=false
if ask_install "Go (Compilador y herramientas oficiales)" \
    "Lenguaje de Google enfocado en concurrencia, microservicios y backend de alto rendimiento." "n"; then
    INSTALL_GO=true
    pkg_install go
    print_success "Go instalado"
fi

INSTALL_RUST=false
if ask_install "Rust + Rustup (Toolchain de Rust)" \
    "Compilador rustc, gestor de dependencias cargo y soporte para el ecosistema Rust." "n"; then
    INSTALL_RUST=true
    pkg_install rustup
    rustup default stable
    print_success "Rust instalado"
fi

INSTALL_PYTHON=false
if ask_install "Python + Herramientas (pipx, poetry)" \
    "Entorno Python con pipx para CLIs aislados y poetry para gestión moderna de proyectos."; then
    INSTALL_PYTHON=true
    pkg_install python python-pip python-pipx python-poetry
    pipx ensurepath 2>/dev/null || true
    print_success "Entorno Python listo"
fi

# ============================================================
# PASO 8: Utilidades Extra y Estilo Visual
# ============================================================

print_header "Paso 8: Utilidades del Sistema y Personalización"
print_info "Instalando paquetes básicos (jq, tree, xclip, wl-clipboard, p7zip, unrar)..."
pkg_install jq tree xclip wl-clipboard p7zip unrar

INSTALL_FASTFETCH=false
if ask_install "fastfetch (Información rápida del sistema)" \
    "Muestra un resumen elegante de hardware, kernel, escritorio y memoria al abrir la consola." "n"; then
    INSTALL_FASTFETCH=true
    pkg_install fastfetch
    print_success "fastfetch instalado"
fi

INSTALL_EASYEFFECTS=false
if ask_install "EasyEffects + Presets Catppuccin (PipeWire Audio)" \
    "¿Qué hace?: Ecualización avanzada para mejorar sonido de auriculares y filtros de IA (RNNoise)\n   para suprimir el ruido de fondo de tu micrófono en llamadas y Discord."; then
    INSTALL_EASYEFFECTS=true
    pkg_install easyeffects lsp-plugins-lv2
    print_success "EasyEffects instalado"
fi

INSTALL_KDE_CUSTOM=false
if pgrep -x "plasmashell" > /dev/null || [ -d "/usr/share/plasma" ]; then
    if ask_install "Personalización Completa de KDE Plasma 6 (Catppuccin Mocha + Kvantum + Klassy)" \
        "¿Qué hace esta personalización?:\n   • Kvantum: Renderizado con transparencias y desenfoque (blur) real en apps Qt.\n   • Klassy: Decoraciones de ventana con esquinas redondeadas y botones modernos.\n   • Catppuccin Mocha: Tema global para paneles, ventanas, widgets y cursores.\n   • Atajos globales y reglas optimizadas de KWin."; then
        INSTALL_KDE_CUSTOM=true
        if [ -f "$DOTFILES_DIR/scripts/setup-kde.sh" ]; then
            bash "$DOTFILES_DIR/scripts/setup-kde.sh"
        fi
    fi
fi

# ============================================================
# PASO 9: Crear Backup y Enlazar Archivos (Symlinks)
# ============================================================

print_header "Paso 9: Creación de Enlaces Simbólicos (Symlinks)"

ROOT_FILES=(.zshrc .zprofile .gitconfig .gitignore_global .ripgreprc .editorconfig .tool-versions)

CONFIG_ITEMS=(starship.toml fontconfig)
$INSTALL_KITTY && CONFIG_ITEMS+=(kitty)
$INSTALL_NVIM && CONFIG_ITEMS+=(nvim)
$INSTALL_LAZYGIT && CONFIG_ITEMS+=(lazygit)
$INSTALL_BTOP && CONFIG_ITEMS+=(btop)
$INSTALL_LSD && CONFIG_ITEMS+=(lsd)
$INSTALL_BAT && CONFIG_ITEMS+=(bat)
$INSTALL_YAZI && CONFIG_ITEMS+=(yazi)
$INSTALL_FASTFETCH && CONFIG_ITEMS+=(fastfetch)
$INSTALL_EASYEFFECTS && CONFIG_ITEMS+=(easyeffects)
$INSTALL_ZATHURA && CONFIG_ITEMS+=(zathura)
$INSTALL_YTDLP && CONFIG_ITEMS+=(yt-dlp)
$INSTALL_FD && CONFIG_ITEMS+=(fd)
$INSTALL_ZELLIJ && CONFIG_ITEMS+=(zellij)

# Si se seleccionó personalización de KDE o interfaz gráfica
if $INSTALL_KDE_CUSTOM; then
    CONFIG_ITEMS+=(environment.d Kvantum kdeglobals kglobalshortcutsrc kwinrc gtk-3.0 gtk-4.0 rofi easyeffects)
fi

NEEDS_BACKUP=false
for f in "${ROOT_FILES[@]}"; do
    [ -e "$HOME/$f" ] && NEEDS_BACKUP=true && break
done

if $NEEDS_BACKUP; then
    print_info "Respaldando configuraciones previas en $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    for f in "${ROOT_FILES[@]}"; do
        if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
            cp -r "$HOME/$f" "$BACKUP_DIR/"
        fi
    done
    print_success "Copia de respaldo completada"
fi

print_info "Enlazando archivos raíz a tu home..."
for f in "${ROOT_FILES[@]}"; do
    if [ -e "$DOTFILES_DIR/$f" ]; then
        ln -sf "$DOTFILES_DIR/$f" "$HOME/$f"
        echo "   $f → ~/$f"
    fi
done

mkdir -p "$HOME/.config"
print_info "Enlazando configuraciones en ~/.config/..."
for item in "${CONFIG_ITEMS[@]}"; do
    if [ -e "$DOTFILES_DIR/.config/$item" ]; then
        ln -sf "$DOTFILES_DIR/.config/$item" "$HOME/.config/$item"
        echo "   .config/$item → ~/.config/$item"
    fi
done

# Activar Git hooks locales del repositorio
git config core.hooksPath "$DOTFILES_DIR/.githooks" 2>/dev/null || true

print_success "Todos los enlaces simbólicos han sido creados"

if [ ! -f "$HOME/.zshrc.local" ] && [ -f "$DOTFILES_DIR/.zshrc.local.example" ]; then
    cp "$DOTFILES_DIR/.zshrc.local.example" "$HOME/.zshrc.local"
    print_info "Se ha creado ~/.zshrc.local a partir de la plantilla de ejemplo"
fi

# ============================================================
# PASO 10: Configuración Final
# ============================================================

if $INSTALL_NEWSBOAT; then
    mkdir -p "$HOME/.newsboat"
    if [ ! -f "$HOME/.newsboat/urls" ]; then
        cat > "$HOME/.newsboat/urls" << 'EOF'
https://blog.desdelinux.net/feed/  "DesdeLinux"
https://archlinux.org/news/news.xml  "Arch Linux News"
https://www.phoronix.com/rss.php  "Phoronix"
EOF
    fi
fi

if $INSTALL_ZSH; then
    echo ""
    if ask_install "Establecer Zsh como Shell por Defecto" \
        "Cambia tu shell de usuario a Zsh (requiere reiniciar sesión para surtir efecto completo)."; then
        chsh -s "$(which zsh)"
        print_success "Shell predeterminada cambiada a Zsh"
    fi
fi

if $INSTALL_YTDLP; then
    mkdir -p "$HOME/Vídeos/youtube"
fi

print_header "¡Instalación y Configuración Completada!"
echo -e "${PURPLE}¡Disfruta tu entorno de trabajo en Arch Linux / EndeavourOS! 🚀${NC}"
