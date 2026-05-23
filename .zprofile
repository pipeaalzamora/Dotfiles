# Variables de entorno globales (solo se carga al login)
# =====================================================

# Locale
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Editores
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'

# Desarrollo
export GOPATH="$HOME/go"
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

# PATH
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$CARGO_HOME/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="$PATH:/usr/local/go/bin"

# Bat — compatible Ubuntu (batcat) y otros (bat)
if command -v batcat &>/dev/null; then
    export BAT_CMD="batcat"
elif command -v bat &>/dev/null; then
    export BAT_CMD="bat"
else
    export BAT_CMD="cat"
fi
export BAT_THEME="Catppuccin-mocha"

# fd — compatible Ubuntu (fdfind) y otros (fd)
if command -v fdfind &>/dev/null; then
    export FD_CMD="fdfind"
elif command -v fd &>/dev/null; then
    export FD_CMD="fd"
else
    export FD_CMD="find"
fi

# FZF
export FZF_DEFAULT_COMMAND="$FD_CMD --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8 --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8 --color=info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,spinner:#f5e0dc,header:#f38ba8'

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Less
export PAGER='less'
export LESS='-R'
export LESSHISTFILE=-

# Man pages con bat
export MANPAGER="sh -c 'col -bx | $BAT_CMD -l man -p'"
export MANROFFOPT="-c"

# Dotfiles
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
