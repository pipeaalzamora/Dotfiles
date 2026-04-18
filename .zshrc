# Configuración mejorada de Zsh para Latinoamérica
# ================================================

# Directorio de dotfiles (usado por scripts internos)
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"


#starship
eval "$(starship init zsh)"

#zoxide
eval "$(zoxide init zsh)"


# Path personalizado
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$HOME/scripts:$PATH"
# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Tema (puedes cambiarlo por: agnoster, powerlevel10k/powerlevel10k, etc.)
#ZSH_THEME="robbyrussell"

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Plugins útiles (agrega más según necesites)
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

# Configuraciones de Oh My Zsh
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd/mm/yyyy"

# Actualización automática
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

source $ZSH/oh-my-zsh.sh

# Configuración del historial
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Editor preferido
export EDITOR='nvim'
export VISUAL='nvim'


# Personaliza el color de los directorios para 'ls'
# Configuración base con vivid y directorios naranjas
export LS_COLORS="di=01;38;5;208:$(vivid generate molokai | cut -d: -f2-)"
# Aliases personalizados
# ======================

# Navegación
alias z='z'           # zoxide explícito
alias cd='cd'         # cd clásico sin romper scripts
alias j='z'           # atajo rápido para zoxide
alias ls='lsd'
alias la='lsd -A'
alias l='lsd -CF'
alias lh='lsd -lh'
alias ll='lsd -lah'

# Git mejorado
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

# Sistema
alias df='df -h'
alias du='dust'
alias free='free -h'
alias ps='procs'
alias top='htop'
alias cls='clear'
alias c='clear'
alias bp='btop'

# Cheatsheets
alias tldr='tldr'

# Archivos y directorios
alias mkdir='mkdir -pv'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'              # interactivo — pide confirmación antes de borrar
alias rrf='rm -rf'            # borrado forzado explícito cuando realmente lo necesitas
alias grep='rg'
alias cat='bat'
alias find='fd'
alias tree='tree -C'

# Red
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'

# Desarrollo
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias json='fx'
alias vim='nvim'
alias vi='nvim'

# Docker (si lo usas)
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dimg='docker images'

# Alias para yt-dlp
alias yt='yt-dlp'

# Newsboat
alias nb='newsboat'

# Dotfiles
alias dotfiles='cd ~/dotfiles'
alias dots='cd ~/dotfiles'

# Funciones útiles
# ================

# Crear directorio y entrar
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Buscar archivos
ff() {
    fd "$1"
}

# Buscar en archivos
fif() {
    rg "$1" --hidden --follow
}

# FZF integrado
fzf-file() {
    local file=$(fd --type f --hidden --follow --exclude .git | fzf --preview 'bat --color=always {}')
    [ -n "$file" ] && nvim "$file"
}

# FZF para directorios
fzf-cd() {
    local dir=$(fd --type d --hidden --follow --exclude .git | fzf)
    [ -n "$dir" ] && cd "$dir"
}

# Git con FZF
fzf-git-branch() {
    local branch=$(git branch -a | grep -v HEAD | sed 's/^..//' | fzf)
    [ -n "$branch" ] && git checkout "$branch"
}

# Clima
weather() {
    local city="${1:-Villa+Alemana,CL}"
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

# Keybindings para FZF
bindkey -s '^f' 'fzf-file\n'
bindkey -s '^g' 'fzf-cd\n'
bindkey -s '^b' 'fzf-git-branch\n'


#yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


# Variables de entorno adicionales
export PAGER='less'
export LESS='-R'

# Configuración de colores
# En Arch, bat/fd/rg usan sus nombres reales (sin sufijos como en Ubuntu)

# Mensaje de bienvenida
echo "¡Hola hoy sera un gran dia $(whoami)! 👋"
echo "Fecha: $(date '+%A, %d de %B de %Y - %H:%M')"
# Mostrar clima de Villa Alemana al abrir terminal
if [[ -n "$ZSH_VERSION" ]]; then
    echo "🌤️ Clima en Villa Alemana:"
    weather
    echo ""
fi

#NVM path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# =======================================================
# Recordatorio de actualización (una vez al día)
# =======================================================
LAST_UPDATE_FILE="$HOME/.cache/last_update"

if [ ! -f "$LAST_UPDATE_FILE" ] || [ $(( $(date +%s) - $(stat -c %Y "$LAST_UPDATE_FILE") )) -gt 86400 ]; then
  echo "💡 Llevas más de un día sin actualizar. Ejecuta: upd"
fi

# Alias para actualizar manualmente cuando quieras
alias upd="$DOTFILES_DIR/scripts/update-all"

#fx json terminal
if command -v fx >/dev/null 2>&1; then
  source <(fx --comp zsh)
fi

[[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1 && \
  . "$(kiro --locate-shell-integration-path zsh)"
