# ============================================================
# Dotfiles — Zsh completo
# ============================================================

export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Documentos/Dotfiles}"
export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship.toml}"

# Compatibilidad de nombres en Arch y otras distribuciones.
if command -v bat >/dev/null 2>&1; then
    BAT_CMD="bat"
elif command -v batcat >/dev/null 2>&1; then
    BAT_CMD="batcat"
else
    BAT_CMD="cat"
fi

if command -v fd >/dev/null 2>&1; then
    FD_CMD="fd"
elif command -v fdfind >/dev/null 2>&1; then
    FD_CMD="fdfind"
else
    FD_CMD="find"
fi

# ============================================================
# Oh My Zsh (solo carga una vez por sesión)
# ============================================================
export ZSH="$HOME/.oh-my-zsh"
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

    [ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"
fi

# ============================================================
# Historial
# ============================================================
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ============================================================
# Herramientas de shell
# ============================================================
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh) 2>/dev/null || true
fi

if command -v vivid >/dev/null 2>&1; then
    export LS_COLORS="$(vivid generate molokai)"
fi

# ============================================================
# Aliases — Navegación
# ============================================================
alias j='z'
command -v lsd >/dev/null 2>&1 && alias ls='lsd'
command -v lsd >/dev/null 2>&1 && alias la='lsd -A'
command -v lsd >/dev/null 2>&1 && alias l='lsd -CF'
command -v lsd >/dev/null 2>&1 && alias lh='lsd -lh'
command -v lsd >/dev/null 2>&1 && alias ll='lsd -lah'

# ============================================================
# Aliases — CLI, Git y sistema
# ============================================================
alias cat="$BAT_CMD"
alias bat="$BAT_CMD"
alias fd="$FD_CMD"
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

if command -v dust >/dev/null 2>&1; then
    alias du='dust'
else
    alias du='du -h'
fi
if command -v procs >/dev/null 2>&1; then
    alias ps='procs'
fi
if command -v btop >/dev/null 2>&1; then
    alias htop='btop'
    alias top='btop'
fi

# ============================================================
# Aliases — Desarrollo, Docker y extras
# ============================================================
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias vim='nvim'
alias vi='nvim'
command -v fx >/dev/null 2>&1 && alias json='fx'
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dimg='docker images'
alias yt='yt-dlp'
alias nb='newsboat'
alias dots='cd "$DOTFILES_DIR"'

# ============================================================
# Funciones útiles
# ============================================================
mkcd() { mkdir -p "$1" && cd "$1"; }
ff() { "$FD_CMD" "$1"; }
fif() { rg "$1" --hidden --follow; }

fzf-file() {
    local file
    file=$("$FD_CMD" --type f --hidden --follow --exclude .git | fzf --preview "$BAT_CMD --color=always {}")
    [ -n "$file" ] && nvim "$file"
}

fzf-cd() {
    local dir
    dir=$("$FD_CMD" --type d --hidden --follow --exclude .git | fzf)
    [ -n "$dir" ] && cd "$dir"
}

fzf-git-branch() {
    local branch
    branch=$(git branch -a | grep -v HEAD | sed 's/^..//' | fzf)
    [ -n "$branch" ] && git checkout "$branch"
}

weather() {
    local city="${1:-Santiago,CL}"
    curl -s "wttr.in/$city?lang=es&format=3"
}

cheat() { curl -s "cheat.sh/$1"; }

sysinfo() {
    echo "=== Información del Sistema ==="
    echo "Usuario: $(whoami)"
    echo "Fecha: $(date)"
    echo "Uptime: $(uptime -p)"
    echo "Memoria: $(free -h | grep '^Mem' | awk '{print $3 "/" $2}')"
    echo "Disco: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')"
}

backup() {
    if [ $# -eq 0 ]; then
        echo "Uso: backup <archivo>"
        return 1
    fi
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    cp "$1" "$1.backup.$timestamp"
    echo "Backup creado: $1.backup.$timestamp"
}

psg() { command ps aux | command grep -v grep | command grep "$1"; }

newproject() {
    if [ $# -eq 0 ]; then
        echo "Uso: newproject <nombre>"
        return 1
    fi
    mkdir -p "$1"/{src,docs}
    cd "$1" || return
    touch .gitignore
    git init
    echo "Proyecto '$1' creado exitosamente"
}

# ============================================================
# Keybindings FZF y Yazi
# ============================================================
bindkey -s '^f' 'fzf-file\n'
bindkey -s '^g' 'fzf-cd\n'
bindkey -s '^b' 'fzf-git-branch\n'

y() {
    local tmp cwd
    tmp="$(mktemp -t 'yazi-cwd.XXXXXX')"
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp" || true
    [ -n "${cwd:-}" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# ============================================================
# NVM, Bun, fx y Kiro
# ============================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL" ] && export PATH="$BUN_INSTALL/bin:$PATH"

if command -v fx >/dev/null 2>&1; then
    source <(fx --comp zsh)
fi

if [[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1; then
    . "$(kiro --locate-shell-integration-path zsh)"
fi

# ============================================================
# Starship
# ============================================================
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# ============================================================
# Actualización y KDE
# ============================================================
alias upd="$DOTFILES_DIR/scripts/update-all"

LAST_UPDATE_FILE="$HOME/.cache/last_update"
_needs_update=true
if [[ -f "$LAST_UPDATE_FILE" ]]; then
    _last=$(date -r "$LAST_UPDATE_FILE" +%s 2>/dev/null || echo 0)
    _now=$(date +%s)
    (( _now - _last < 86400 )) && _needs_update=false
fi
$_needs_update && echo "💡 Llevas más de un día sin actualizar. Ejecuta: upd"
unset _needs_update _last _now

alias krestart='systemctl --user restart plasma-plasmashell.service'
alias kwin-reload='command -v qdbus &>/dev/null && qdbus org.kde.KWin /KWin reconfigure'

dots-export-kde() {
    local target_dir="${DOTFILES_DIR}/.config"
    mkdir -p "$target_dir/Kvantum" "$target_dir/environment.d"
    [ -f "$HOME/.config/kdeglobals" ] && cp "$HOME/.config/kdeglobals" "$target_dir/"
    [ -f "$HOME/.config/kglobalshortcutsrc" ] && cp "$HOME/.config/kglobalshortcutsrc" "$target_dir/"
    [ -f "$HOME/.config/kwinrc" ] && cp "$HOME/.config/kwinrc" "$target_dir/"
    [ -f "$HOME/.config/Kvantum/kvantum.kvconfig" ] && cp "$HOME/.config/Kvantum/kvantum.kvconfig" "$target_dir/Kvantum/"
    [ -f "$HOME/.config/environment.d/qt.conf" ] && cp "$HOME/.config/environment.d/qt.conf" "$target_dir/environment.d/"
    echo "✅ Configuraciones de KDE Plasma exportadas a $target_dir"
}

# Scripts de dotfiles
alias theme-switch='$DOTFILES_DIR/scripts/theme-switcher.sh'
alias wall-next='$DOTFILES_DIR/scripts/change-wallpaper.sh'
alias wall-download='$DOTFILES_DIR/scripts/download-wallpapers.sh'
alias monitors='$DOTFILES_DIR/scripts/manage-monitors.sh'
alias verso='$DOTFILES_DIR/scripts/daily-verse.sh'
alias salmo='$DOTFILES_DIR/scripts/daily-verse.sh salmo'
alias proverbio='$DOTFILES_DIR/scripts/daily-verse.sh proverbio'
alias verso-notif='$DOTFILES_DIR/scripts/daily-verse.sh random notify'

# Configuración personal no versionada
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
