# Variables de entorno globales
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
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$CARGO_HOME/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8 --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8 --color=info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,spinner:#f5e0dc,header:#f38ba8'

# Bat
export BAT_THEME="Catppuccin-mocha"

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Less
export LESS='-R --use-color -Dd+r$Du+b'
export LESSHISTFILE=-

# Man pages con colores
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
