# Configuración mejorada de Zsh para Latinoamérica
# ================================================

# Directorio de dotfiles (usado por scripts internos)
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# ============================================================
# Detección automática del OS
# ============================================================
_is_ubuntu=false
_is_arch=false
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"ubuntu"* || "$ID" == "zorin" ]] && _is_ubuntu=true
    [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]] && _is_arch=true
fi

# Resolver nombre real de bat (batcat en Ubuntu, bat en Arch/otros)
if command -v batcat &>/dev/null; then
    _bat_cmd="batcat"
elif command -v bat &>/dev/null; then
    _bat_cmd="bat"
else
    _bat_cmd="cat"
fi

# Resolver nombre real de fd (fdfind en Ubuntu, fd en Arch/otros)
if command -v fdfind &>/dev/null; then
    _fd_cmd="fdfind"
elif command -v fd &>/dev/null; then
    _fd_cmd="fd"
else
    _fd_cmd="find"
fi

# ============================================================
# Starship
# ============================================================
eval "$(starship init zsh)"

# ============================================================
# Zoxide
# ============================================================
eval "$(zoxide init zsh)"

# ============================================================
# Path personalizado
# ============================================================
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$HOME/scripts:$PATH"

# Go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ============================================================
# Oh My Zsh
# ============================================================
export ZSH="$HOME/.oh-my-zsh"

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

plugins=(
    git
    sudo
    history
    command-not-found
    extract
    z
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
# Editor
# ============================================================
export EDITOR='nvim'
export VISUAL='nvim'

# ============================================================
# LS_COLORS con vivid (fallback si no está instalado)
# ============================================================
if command -v vivid &>/dev/null; then
    export LS_COLORS="di=01;38;5;208:$(vivid generate molokai | cut -d: -f2-)"
fi

# ============================================================
# FZF config — usa fd/fdfind según el sistema
# ============================================================
export FZF_DEFAULT_COMMAND="$_fd_cmd --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8 --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8 --color=info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,spinner:#f5e0dc,header:#f38ba8'

# ============================================================
# Aliases — Navegación
# ============================================================
alias z='z'
alias cd='cd'
alias j='z'
alias ls='lsd'
alias la='lsd -A'
alias l='lsd -CF'
alias lh='lsd -lh'
alias ll='lsd -lah'

# ============================================================
# Aliases — bat (compatible Ubuntu/Arch)
# ============================================================
alias cat="$_bat_cmd"
alias bat="$_bat_cmd"

# ============================================================
# Aliases — fd (compatible Ubuntu/Arch)
# ============================================================
alias fd="$_fd_cmd"
alias find="$_fd_cmd"

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
alias gl='git log --oneline --graph'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias lg='lazygit'

# ============================================================
# Aliases — Sistema (con fallbacks para herramientas opcionales)
# ============================================================
alias df='df -h'
alias free='free -h'
alias cls='clear'
alias c='clear'
alias bp='btop'
alias top='btop'
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'
alias mkdir='mkdir -pv'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias rrf='rm -rf'
alias grep='rg'
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
else
    alias ps='ps aux'
fi

# htop (fallback)
if command -v btop &>/dev/null; then
    alias htop='btop'
fi

# ============================================================
# Aliases — Desarrollo
# ============================================================
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias vim='nvim'
alias vi='nvim'
alias tldr='tldr'

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
alias dotfiles='cd ~/dotfiles'
alias dots='cd ~/dotfiles'

# ============================================================
# Funciones útiles
# ============================================================

# Crear directorio y entrar
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Buscar archivos
ff() {
    $_fd_cmd "$1"
}

# Buscar en archivos
fif() {
    rg "$1" --hidden --follow
}

# FZF integrado — abre archivo en nvim
fzf-file() {
    local file=$($_fd_cmd --type f --hidden --follow --exclude .git | fzf --preview "$_bat_cmd --color=always {}")
    [ -n "$file" ] && nvim "$file"
}

# FZF — navegar directorios
fzf-cd() {
    local dir=$($_fd_cmd --type d --hidden --follow --exclude .git | fzf)
    [ -n "$dir" ] && cd "$dir"
}

# Git con FZF
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

# Extraer cualquier archivo comprimido
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "No sé cómo extraer '$1'" ;;
        esac
    else
        echo "El archivo '$1' no existe"
    fi
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

# Backup rápido
backup() {
    if [ $# -eq 0 ]; then
        echo "Uso: backup <archivo>"
        return 1
    fi
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backup creado: $1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Buscar procesos
psg() {
    ps aux | grep -v grep | grep "$1"
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
# Variables de entorno adicionales
# ============================================================
export PAGER='less'
export LESS='-R'
export BAT_THEME="Catppuccin-mocha"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Man pages con bat
export MANPAGER="sh -c 'col -bx | $_bat_cmd -l man -p'"
export MANROFFOPT="-c"

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
export PATH="$BUN_INSTALL/bin:$PATH"

# ============================================================
# fx — json terminal
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
# Recordatorio de actualización (una vez al día)
# ============================================================
LAST_UPDATE_FILE="$HOME/.cache/last_update"
if [ ! -f "$LAST_UPDATE_FILE" ] || [ $(( $(date +%s) - $(stat -c %Y "$LAST_UPDATE_FILE") )) -gt 86400 ]; then
    echo "💡 Llevas más de un día sin actualizar. Ejecuta: upd"
fi
alias upd="$DOTFILES_DIR/scripts/update-all"

# ============================================================
# Mensaje de bienvenida
# ============================================================
echo "¡Hola, hoy será un gran día $(whoami)! 👋"
echo "Fecha: $(date '+%A, %d de %B de %Y - %H:%M')"
echo "🌤️  Clima en Santiago:"
weather
echo ""
