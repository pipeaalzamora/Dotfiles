#!/usr/bin/env bash
# ==============================================================================
# Pipe's Dotfiles - Shared Utilities Library
# ==============================================================================

set -euo pipefail

# Sanitizar locale automáticamente si el actual no existe en el sistema
if [[ -n "${LC_ALL:-}" ]] && ! locale -a 2>/dev/null | tr -d '._-' | grep -qi "$(echo "${LC_ALL}" | tr -d '._-')"; then
    export LC_ALL="C.UTF-8"
fi

# Colores y formato
readonly COLOR_RESET="\033[0m"
readonly COLOR_BOLD="\033[1m"
readonly COLOR_RED="\033[0;31m"
readonly COLOR_GREEN="\033[0;32m"
readonly COLOR_YELLOW="\033[0;33m"
readonly COLOR_BLUE="\033[0;34m"
readonly COLOR_CYAN="\033[0;36m"

# Mensajes estructurados
log_info() {
    printf "${COLOR_GREEN}[✓]${COLOR_RESET} %s\n" "$*"
}

log_warn() {
    printf "${COLOR_YELLOW}[!]${COLOR_RESET} %s\n" "$*"
}

log_error() {
    printf "${COLOR_RED}[✗]${COLOR_RESET} %s\n" "$*" >&2
}

log_fatal() {
    log_error "$*"
    exit 1
}

log_step() {
    printf "\n${COLOR_BOLD}${COLOR_CYAN}==> %s${COLOR_RESET}\n" "$*"
}

# Verificadores y validaciones
has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

require_cmd() {
    if ! has_cmd "$1"; then
        log_fatal "El comando requerido '$1' no está disponible en el sistema."
    fi
}

ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_info "Directorio creado: $dir"
    fi
}

# Enlace simbólico seguro con respaldo
link_file() {
    local src="$1"
    local dest="$2"
    local backup_dir="${HOME}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

    if [[ -e "$dest" || -L "$dest" ]]; then
        if [[ "$(readlink -f "$dest" 2>/dev/null)" == "$(readlink -f "$src" 2>/dev/null)" ]]; then
            log_info "Enlace ya configurado: $dest -> $src"
            return 0
        fi
        ensure_dir "$backup_dir"
        mv "$dest" "$backup_dir/"
        log_warn "Archivo existente respaldado en $backup_dir: $(basename "$dest")"
    fi

    ensure_dir "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    log_info "Enlazado: $src -> $dest"
}

# Pregunta interactiva (Sí/No)
confirm_prompt() {
    local prompt="$1"
    local default="${2:-N}"

    if [[ "$default" == "Y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -r -p "$prompt" response
    response="${response:-$default}"

    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}
