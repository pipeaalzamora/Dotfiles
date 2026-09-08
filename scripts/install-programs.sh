#!/usr/bin/env bash
# ============================================================
# Script de Instalador de Programas Open Source para Arch Linux
# Enfocado en aplicaciones nativas de Linux
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
    ask_yes_no "Instalar este programa?" "$default"
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

print_header "Instalador de Programas Open Source — Arch Linux"
echo -e "Sistema detectado: ${GREEN}$PRETTY_NAME${NC}"
echo ""
echo "Este script instala aplicaciones nativas de Linux priorizando software open source."
echo "Cada programa incluye una descripcion de su utilidad."
echo ""
echo -e "${YELLOW}─────────────────────────────────────────────────────${NC}"

# ============================================================
# NAVEGADORES WEB
# ============================================================

print_header "Navegadores Web"

INSTALL_FIREFOX=false
if ask_install "Mozilla Firefox" \
    "Navegador web open source de Mozilla. Privacidad, extensiones y sincronizacion.\n   Establecido como predeterminado en la mayoria de distribuciones Linux."; then
    INSTALL_FIREFOX=true
    pkg_install firefox
    print_success "Firefox instalado"
fi

INSTALL_BRAVE=false
if ask_install "Brave Browser" \
    "Navegador basado en Chromium con bloqueo de anuncios y trackers integrado.\n   Compatible con extensiones de Chrome y enfocado en privacidad." "n"; then
    INSTALL_BRAVE=true
    aur_install brave-bin
    print_success "Brave instalado desde AUR"
fi

# ============================================================
# IDEs Y EDITORES DE CÓDIGO
# ============================================================

print_header "IDEs y Editores de Codigo"

INSTALL_KIRO=false
if ask_install "Kiro IDE" \
    "IDE moderno y ligero diseñado para desarrollo full-stack.\n   Soporte nativo para TypeScript, React, Node.js y herramientas de IA."; then
    INSTALL_KIRO=true
    aur_install kiro-bin
    print_success "Kiro IDE instalado desde AUR"
fi

INSTALL_VSCODE=false
if ask_install "Visual Studio Code" \
    "Editor de codigo de Microsoft ampliamente usado en la industria.\n   Ecosistema masivo de extensiones, debugging integrado y Git." "n"; then
    INSTALL_VSCODE=true
    aur_install visual-studio-code-bin
    print_success "VS Code instalado desde AUR"
fi

INSTALL_DATABASER=false
if ask_install "DBeaver Community" \
    "Cliente universal de bases de datos. Soporta PostgreSQL, MySQL,\n   MariaDB, Oracle, SQL Server, MongoDB y mas con interfaz grafica." "n"; then
    INSTALL_DATABASER=true
    aur_install dbeaver
    print_success "DBeaver instalado desde AUR"
fi

INSTALL_BEEKEEPER=false
if ask_install "Beekeeper Studio" \
    "Cliente SQL moderno y ligero para PostgreSQL, MySQL, SQLite y SQL Server.\n   Interfaz limpia, autocompletado y export/import de datos." "n"; then
    INSTALL_BEEKEEPER=true
    aur_install beekeeper-studio
    print_success "Beekeeper Studio instalado desde AUR"
fi

INSTALL_INSOMNIA=false
if ask_install "Insomnia" \
    "Cliente de API REST y GraphQL con soporte para autenticaciones,\n   variables de entorno, plugins y documentacion de endpoints." "n"; then
    INSTALL_INSOMNIA=true
    aur_install insomnia
    print_success "Insomnia instalado desde AUR"
fi

# ============================================================
# CONTENEDORES Y VIRTUALIZACION
# ============================================================

print_header "Contenedores y Virtualizacion"

INSTALL_DOCKER=false
if ask_install "Docker + Docker Compose" \
    "Plataforma estandar para crear, desplegar y gestionar contenedores.\n   Incluye Docker CLI, Docker Compose y soporte para Dockerfiles."; then
    INSTALL_DOCKER=true
    pkg_install docker docker-compose
    print_info "Habilitando servicio de Docker..."
    sudo systemctl enable docker
    sudo systemctl start docker
    print_success "Docker instalado y servicio habilitado"
    print_info "Para usar Docker sin sudo, ejecuta: sudo usermod -aG docker $USER"
fi

INSTALL_PODMAN=false
if ask_install "Podman + Podman Desktop" \
    "Alternativa a Docker sin daemon. Compatible con contenedores OCI.\n   Podman Desktop ofrece interfaz grafica similar a Docker Desktop." "n"; then
    INSTALL_PODMAN=true
    pkg_install podman podman-desktop
    print_success "Podman y Podman Desktop instalados"
fi

# ============================================================
# MULTIMEDIA
# ============================================================

print_header "Multimedia y Reproduccion"

INSTALL_MPV=false
if ask_install "MPV" \
    "Reproductor de video minimalista y de alto rendimiento.\n   Soporta codecs modernos, subtitulos, scripts Lua y configuracion avanzada."; then
    INSTALL_MPV=true
    pkg_install mpv
    print_success "MPV instalado"
fi

INSTALL_VLC=false
if ask_install "VLC Media Player" \
    "Reproductor multimedia universal que reproduce cualquier formato.\n   Incluye herramientas de conversion, streaming y captura de pantalla."; then
    INSTALL_VLC=true
    pkg_install vlc
    print_success "VLC instalado"
fi

INSTALL_AUDACIOUS=false
if ask_install "Audacious" \
    "Reproductor de audio ligero tipo Winamp. Soporta MP3, FLAC, OGG,\n   WAV, AAC, WMA, visualizaciones y temas personalizables." "n"; then
    INSTALL_AUDACIOUS=true
    pkg_install audacious audacious-plugins
    print_success "Audacious instalado"
fi

INSTALL_STRAWBERRY=false
if ask_install "Strawberry Music Player" \
    "Reproductor de musica orientado a coleccionistas.\n   Soporta tags avanzados, letras, caratulas, Last.fm y biblioteca organizada." "n"; then
    INSTALL_STRAWBERRY=true
    pkg_install strawberry
    print_success "Strawberry instalado"
fi

# ============================================================
# COMUNICACION
# ============================================================

print_header "Comunicacion y Mensajeria"

INSTALL_ELEMENT=false
if ask_install "Element Desktop" \
    "Cliente de mensajeria descentralizada basado en Matrix.\n   Cifrado de extremo a extremo, salas, videollamadas y puentes a otras redes." "n"; then
    INSTALL_ELEMENT=true
    pkg_install element-desktop
    print_success "Element Desktop instalado"
fi

INSTALL_TELEGRAM=false
if ask_install "Telegram Desktop" \
    "Cliente oficial de Telegram para Linux.\n   Mensajes, canales, grupos, bots, llamadas y sincronizacion multiplataforma."; then
    INSTALL_TELEGRAM=true
    pkg_install telegram-desktop
    print_success "Telegram Desktop instalado"
fi

INSTALL_SLACK=false
if ask_install "Slack Desktop" \
    "Cliente oficial de Slack para comunicacion en equipos de trabajo.\n   Canales, hilos, integraciones con GitHub, Jira y otras herramientas." "n"; then
    INSTALL_SLACK=true
    aur_install slack-desktop
    print_success "Slack instalado desde AUR"
fi

# ============================================================
# PRODUCTIVIDAD Y NOTAS
# ============================================================

print_header "Productividad y Gestion de Notas"

INSTALL_OBSIDIAN=false
if ask_install "Obsidian" \
    "Gestor de notas basado en Markdown con enlaces bidireccionales.\n   Ideal para documentacion tecnica, Zettelkasten y grafos de conocimiento." "n"; then
    INSTALL_OBSIDIAN=true
    aur_install obsidian
    print_success "Obsidian instalado desde AUR"
fi

INSTALL_JOPLIN=false
if ask_install "Joplin" \
    "Aplicacion de notas open source con cifrado de extremo a extremo.\n   Soporta Markdown, sincronizacion con Nextcloud, Dropbox y mas."; then
    INSTALL_JOPLIN=true
    pkg_install joplin
    print_success "Joplin instalado"
fi

INSTALL_LOGSEQ=false
if ask_install "Logseq" \
    "Plataforma de gestion de conocimiento con enfoque en enlaces.\n   Notas en Markdown/org-mode, grafos, PDF annotation y queries." "n"; then
    INSTALL_LOGSEQ=true
    aur_install logseq
    print_success "Logseq instalado desde AUR"
fi

# ============================================================
# UTILIDADES DEL SISTEMA
# ============================================================

print_header "Utilidades del Sistema"

INSTALL_TIMESHIFT=false
if ask_install "Timeshift" \
    "Herramienta de backup del sistema tipo 'Restaurar Sistema'.\n   Crea snapshots del sistema para restaurar ante fallos o errores."; then
    INSTALL_TIMESHIFT=true
    pkg_install timeshift
    print_success "Timeshift instalado"
fi

INSTALL_BALENAETCHER=false
if ask_install "BalenaEtcher" \
    "Herramienta para crear USBs booteables desde ISOs.\n   Interfaz simple, validacion de escritura y soporte para imagenes comprimidas." "n"; then
    INSTALL_BALENAETCHER=true
    aur_install balena-etcher
    print_success "BalenaEtcher instalado desde AUR"
fi

INSTALL_FLAMESHOT=false
if ask_install "Flameshot" \
    "Capturador de pantalla con editor integrado.\n   Anotaciones, flechas, texto, desenfoque y subida a imgur."; then
    INSTALL_FLAMESHOT=true
    pkg_install flameshot
    print_success "Flameshot instalado"
fi

# ============================================================
# GESTION DE MUSICA
# ============================================================

print_header "Gestion de Musica"

INSTALL_LOLLYPOP=false
if ask_install "Lollypop" \
    "Reproductor de musica moderno para GNOME.\n   Interfaz limpia, letras, radio, sincronizacion con Android y modo fiesta." "n"; then
    INSTALL_LOLLYPOP=true
    pkg_install lollypop
    print_success "Lollypop instalado"
fi

INSTALL_TAUON=false
if ask_install "Tauon Music Box" \
    "Reproductor de musica minimalista y altamente personalizable.\n   Soporta temas, letras, radio, podcasts y biblioteca inteligente." "n"; then
    INSTALL_TAUON=true
    aur_install tauon
    print_success "Tauon instalado desde AUR"
fi

# ============================================================
# Resumen Final
# ============================================================

print_header "Instalacion Completada"

echo -e "${GREEN}Programas instalados:${NC}"
echo ""
$INSTALL_FIREFOX && echo "  ✅ Firefox"
$INSTALL_BRAVE && echo "  ✅ Brave Browser"
$INSTALL_KIRO && echo "  ✅ Kiro IDE"
$INSTALL_VSCODE && echo "  ✅ Visual Studio Code"
$INSTALL_DATABASER && echo "  ✅ DBeaver"
$INSTALL_BEEKEEPER && echo "  ✅ Beekeeper Studio"
$INSTALL_INSOMNIA && echo "  ✅ Insomnia"
$INSTALL_DOCKER && echo "  ✅ Docker + Docker Compose"
$INSTALL_PODMAN && echo "  ✅ Podman + Podman Desktop"
$INSTALL_MPV && echo "  ✅ MPV"
$INSTALL_VLC && echo "  ✅ VLC"
$INSTALL_AUDACIOUS && echo "  ✅ Audacious"
$INSTALL_STRAWBERRY && echo "  ✅ Strawberry"
$INSTALL_ELEMENT && echo "  ✅ Element Desktop"
$INSTALL_TELEGRAM && echo "  ✅ Telegram Desktop"
$INSTALL_SLACK && echo "  ✅ Slack Desktop"
$INSTALL_OBSIDIAN && echo "  ✅ Obsidian"
$INSTALL_JOPLIN && echo "  ✅ Joplin"
$INSTALL_LOGSEQ && echo "  ✅ Logseq"
$INSTALL_TIMESHIFT && echo "  ✅ Timeshift"
$INSTALL_BALENAETCHER && echo "  ✅ BalenaEtcher"
$INSTALL_FLAMESHOT && echo "  ✅ Flameshot"
$INSTALL_LOLLYPOP && echo "  ✅ Lollypop"
$INSTALL_TAUON && echo "  ✅ Tauon"

echo ""
if $INSTALL_DOCKER; then
    echo -e "${YELLOW}Nota: Para usar Docker sin sudo, ejecuta:${NC}"
    echo "  sudo usermod -aG docker $USER"
    echo "  (requiere cerrar sesion y volver a entrar)"
    echo ""
fi

echo -e "${PURPLE}Disfruta tu nuevo entorno de software open source! 🚀${NC}"
