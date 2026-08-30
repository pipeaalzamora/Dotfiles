#!/usr/bin/env bash
# ============================================================
# Automatización de Snapshots con Btrfs + Snapper + GRUB-Btrfs
# Repositorio: pipeaalzamora/Dotfiles
# ============================================================

set -e

# Colores
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

print_header "Configuración de Snapshots Btrfs + Snapper + GRUB"

echo -e "Este script configurará copias de seguridad instantáneas automáticas."
echo -e "${BOLD}¿Qué hace este sistema?:${NC}"
echo -e " • ${CYAN}snapper:${NC} Administrador de instantáneas del sistema de archivos Btrfs."
echo -e " • ${CYAN}snap-pac:${NC} Hook de pacman que crea un snapshot 'pre' y 'post' antes de cada actualización."
echo -e " • ${CYAN}grub-btrfs:${NC} Genera entradas automáticas en el menú de inicio de GRUB para arrancar en snapshots anteriores si el sistema falla."
echo -e " • ${CYAN}inotify-tools:${NC} Monitoriza el sistema para actualizar el menú de GRUB en tiempo real."
echo ""

# 1. Comprobar si la raíz del sistema usa Btrfs
ROOT_FS=$(findmnt -n -o FSTYPE / 2>/dev/null || echo "")

if [ "$ROOT_FS" != "btrfs" ]; then
    print_error "La partición raíz (/) no utiliza el sistema de archivos Btrfs (Detectado: '$ROOT_FS')."
    echo "Snapper y grub-btrfs requieren una instalación sobre particiones formateadas en Btrfs."
    exit 1
fi

print_success "Sistema de archivos Btrfs detectado en la raíz (/)"

if ! ask_yes_no "¿Deseas instalar y configurar Snapper + snap-pac + GRUB-Btrfs?"; then
    echo "Operación cancelada."
    exit 0
fi

# 2. Instalación de paquetes
print_info "Instalando paquetes (snapper, snap-pac, grub-btrfs, inotify-tools)..."
if command -v yay &>/dev/null; then
    yay -S --needed --noconfirm snapper snap-pac grub-btrfs inotify-tools
else
    sudo pacman -S --needed --noconfirm snapper snap-pac grub-btrfs inotify-tools
fi

# 3. Configuración de Snapper para / (root)
if [ ! -f /etc/snapper/configs/root ]; then
    print_info "Creando configuración de Snapper para la partición raíz..."
    # Si existe subvolumen /.snapshots montado, desmontar temporalmente para crear config
    if mountpoint -q /.snapshots 2>/dev/null; then
        sudo umount /.snapshots || true
        sudo rm -rf /.snapshots
    fi
    sudo snapper -c root create-config /
    sudo chmod 750 /.snapshots
fi

# Permitir al usuario actual usar snapper sin sudo
sudo snapper -c root set-config "ALLOW_USERS=$USER" "SYNC_ACL=yes"
sudo chown -R :"$USER" /.snapshots 2>/dev/null || true

# 4. Ajustar límites de retención de snapshots (para no saturar el disco)
print_info "Optimizando retención de snapshots (10 por hora, 7 diarios, 4 semanales)..."
sudo snapper -c root set-config \
    NUMBER_LIMIT=10 \
    NUMBER_LIMIT_IMPORTANT=5 \
    TIMELINE_LIMIT_HOURLY=10 \
    TIMELINE_LIMIT_DAILY=7 \
    TIMELINE_LIMIT_WEEKLY=4 \
    TIMELINE_LIMIT_MONTHLY=2 \
    TIMELINE_LIMIT_YEARLY=0

# 5. Habilitar Timers de Snapper
print_info "Habilitando temporizadores de limpieza y mantenimiento de Snapper..."
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# 6. Habilitar servicio de actualización automática de GRUB
print_info "Habilitando servicio daemon de grub-btrfs..."
sudo systemctl enable --now grub-btrfsd.service || sudo systemctl enable --now grub-btrfs.path || true

# 7. Actualizar GRUB inicialmente
print_info "Actualizando menú de arranque de GRUB con los snapshots actuales..."
if [ -f /boot/grub/grub.cfg ]; then
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

print_header "¡Snapshots de Btrfs Configurados Exitosamente!"
echo -e "${GREEN}Protección contra fallos activada:${NC}"
echo -e " • Cada vez que ejecutes ${CYAN}pacman -Syu${NC} o ${CYAN}yay${NC}, se creará automáticamente un punto de restauración."
echo -e " • Si una actualización rompe el sistema o los drivers, reinicia tu PC, entra al submenú ${BOLD}'Arch Linux snapshots'${NC} en GRUB y arranca en el estado anterior."
echo -e " • Puedes listar tus snapshots con el comando: ${BOLD}snapper list${NC}"
echo ""
