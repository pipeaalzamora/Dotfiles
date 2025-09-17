# Configuración mejorada de Zsh para Latinoamérica
# ================================================


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
export EDITOR='nano'
export VISUAL='nano'


# Personaliza el color de los directorios para 'ls'
# Configuración base con vivid y directorios naranjas
export LS_COLORS="di=01;38;5;208:$(vivid generate molokai | cut -d: -f2-)"
# Aliases personalizados
# ======================

# Navegación
alias cd='z'
alias ls='lsd'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -lh'

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

# Sistema
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
alias top='htop'
alias cls='clear'
alias c='clear'

# Archivos y directorios
alias mkdir='mkdir -pv'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias grep='grep --color=auto'
alias tree='tree -C'

# Red
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'

# Desarrollo
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'

# Alias para yt-dlp
alias yt='yt-dlp'

# Funciones útiles
# ================

# Crear directorio y entrar
crearc() {
    mkdir -p "$1" && cd "$1"
}

# Buscar archivos
ff() {
    find . -name "*$1*" -type f 2>/dev/null
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

# Extraer archivos (mejorado)
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
    mkdir -p "$1"/{src,docs,tests}
    cd "$1"
    touch README.md .gitignore
    echo "# $1" > README.md
    echo "Proyecto '$1' creado exitosamente"
}


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
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Mensaje de bienvenida
echo "¡Hola hoy sera un gran dia $(whoami)! 👋"
echo "Fecha: $(date '+%A, %d de %B de %Y - %H:%M')"


#NVM path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm 


# bun completions
[ -s "/home/pipeaalzamora/.bun/_bun" ] && source "/home/pipeaalzamora/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# =======================================================
# Actualización automática del sistema (una vez al día)
# =======================================================
LAST_UPDATE_FILE="/home/pipeaalzamora/.cache/last_update"

# Si el archivo de la última actualización no existe o ha pasado un día, actualiza.
if [ ! -f "$LAST_UPDATE_FILE" ] || [ $(( $(date +%s) - $(stat -c %Y "$LAST_UPDATE_FILE") )) -gt 86400 ]; then
  echo "✨ Realizando una actualización del sistema. Esto puede tomar unos segundos..."
  /home/pipeaalzamora/scripts/update-system
  touch "$LAST_UPDATE_FILE"
fi

#fx json terminal
source <(fx --comp zsh)