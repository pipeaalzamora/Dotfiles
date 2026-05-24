# Configuración de Zsh (interactiva)
# ===================================

# ============================================================
# Starship prompt
# ============================================================
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ============================================================
# Zoxide (reemplazo de cd)
# ============================================================
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ============================================================
# Rust/Cargo (si no se cargó en .zprofile)
# ============================================================
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ============================================================
# Oh My Zsh (solo carga una vez por sesión)
# ============================================================
export ZSH="$HOME/.oh-my-zsh"

# Necesario para que clipboard.zsh de OMZ use &| sin error
setopt MULTIOS

if [[ -z "$ZSH_LOADED" ]]; then
    export ZSH_LOADED=1

plugins=(
    git
    sudo
    history
    command-not-found
    docker
    docker-compose
    kubectl
    npm
    node
    golang
    rust
    python
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd/mm/yyyy"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

    source $ZSH/oh-my-zsh.sh
fi

# ============================================================
# Historial
# ============================================================
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ============================================================
# LS_COLORS con vivid (si está instalado)
# ============================================================
if command -v vivid &>/dev/null; then
    export LS_COLORS="$(vivid generate molokai)"
fi

# ============================================================
# Aliases — Navegación
# ============================================================
alias j='z'                  # zoxide: saltar a directorio frecuente
alias ls='lsd'
alias la='lsd -A'
alias l='lsd -CF'
alias lh='lsd -lh'
alias ll='lsd -lah'

# ============================================================
# Aliases — bat (compatible Ubuntu)
# ============================================================
alias cat="$BAT_CMD"
alias bat="$BAT_CMD"

# ============================================================
# Aliases — fd (compatible Ubuntu)
# ============================================================
alias fd="$FD_CMD"

# ============================================================
# Aliases — Git
# ============================================================
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias glog='git log --oneline --graph'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias lg='lazygit'

# ============================================================
# Aliases — Sistema
# ============================================================
alias df='df -h'
alias free='free -h'
alias cls='clear'
alias c='clear'
alias bp='btop'
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'
alias mkdir='mkdir -pv'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias rrf='rm -rf'
alias tree='tree -C'

# dust (fallback a du si no está)
if command -v dust &>/dev/null; then
    alias du='dust'
else
    alias du='du -h'
fi

# procs (fallback a ps si no está)
if command -v procs &>/dev/null; then
    alias ps='procs'
fi

# btop como htop
if command -v btop &>/dev/null; then
    alias htop='btop'
    alias top='btop'
fi

# ============================================================
# Aliases — Desarrollo
# ============================================================
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias vim='nvim'
alias vi='nvim'

# fx json terminal (solo si está instalado)
if command -v fx &>/dev/null; then
    alias json='fx'
fi

# ============================================================
# Aliases — Docker
# ============================================================
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dimg='docker images'

# ============================================================
# Aliases — Extras
# ============================================================
alias yt='yt-dlp'
alias nb='newsboat'
alias dots='cd ~/dotfiles'

# ============================================================
# Funciones útiles
# ============================================================

# Crear directorio y entrar
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Buscar archivos con fd
ff() {
    $FD_CMD "$1"
}

# Buscar en contenido de archivos con rg
fif() {
    rg "$1" --hidden --follow
}

# FZF — abrir archivo en nvim
fzf-file() {
    local file=$($FD_CMD --type f --hidden --follow --exclude .git | fzf --preview "$BAT_CMD --color=always {}")
    [ -n "$file" ] && nvim "$file"
}

# FZF — navegar directorios
fzf-cd() {
    local dir=$($FD_CMD --type d --hidden --follow --exclude .git | fzf)
    [ -n "$dir" ] && cd "$dir"
}

# FZF — cambiar rama git
fzf-git-branch() {
    local branch=$(git branch -a | grep -v HEAD | sed 's/^..//' | fzf)
    [ -n "$branch" ] && git checkout "$branch"
}

# Clima (por defecto Santiago)
weather() {
    local city="${1:-Santiago,CL}"
    curl -s "wttr.in/$city?lang=es&format=3"
}

# Cheatsheet
cheat() {
    curl -s "cheat.sh/$1"
}

# Información del sistema
sysinfo() {
    echo "=== Información del Sistema ==="
    echo "Usuario: $(whoami)"
    echo "Fecha: $(date)"
    echo "Uptime: $(uptime -p)"
    echo "Memoria: $(free -h | grep '^Mem' | awk '{print $3 "/" $2}')"
    echo "Disco: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')"
}

# Backup rápido de un archivo
backup() {
    if [ $# -eq 0 ]; then
        echo "Uso: backup <archivo>"
        return 1
    fi
    local timestamp=$(date +%Y%m%d_%H%M%S)
    cp "$1" "$1.backup.$timestamp"
    echo "Backup creado: $1.backup.$timestamp"
}

# Buscar procesos (usa grep real, no rg)
psg() {
    command ps aux | command grep -v grep | command grep "$1"
}

# Crear proyecto básico
newproject() {
    if [ $# -eq 0 ]; then
        echo "Uso: newproject <nombre>"
        return 1
    fi
    mkdir -p "$1"/{src,docs}
    cd "$1"
    touch .gitignore
    git init
    echo "Proyecto '$1' creado exitosamente"
}

# ============================================================
# Keybindings FZF
# ============================================================
bindkey -s '^f' 'fzf-file\n'
bindkey -s '^g' 'fzf-cd\n'
bindkey -s '^b' 'fzf-git-branch\n'

# ============================================================
# Yazi — file manager con cd al salir
# ============================================================
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# ============================================================
# NVM
# ============================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============================================================
# Bun
# ============================================================
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL" ] && export PATH="$BUN_INSTALL/bin:$PATH"

# ============================================================
# fx — completions (si está instalado)
# ============================================================
if command -v fx >/dev/null 2>&1; then
    source <(fx --comp zsh)
fi

# ============================================================
# Kiro (si está instalado)
# ============================================================
[[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1 && \
    . "$(kiro --locate-shell-integration-path zsh)"

# ============================================================
# Actualización — recordatorio diario
# ============================================================
alias upd="$HOME/dotfiles/scripts/update-all"

LAST_UPDATE_FILE="$HOME/.cache/last_update"
_needs_update=true
if [[ -f "$LAST_UPDATE_FILE" ]]; then
    _last=$(date -r "$LAST_UPDATE_FILE" +%s 2>/dev/null || echo 0)
    _now=$(date +%s)
    (( _now - _last < 86400 )) && _needs_update=false
fi
$_needs_update && echo "💡 Llevas más de un día sin actualizar. Ejecuta: upd"
unset _needs_update _last _now
# ============================================================
# Mensaje de bienvenida (sin bloquear con peticiones HTTP)
# ============================================================
echo "¡Hola $(whoami)! 👋 — $(date '+%A, %d de %B de %Y - %H:%M')"
