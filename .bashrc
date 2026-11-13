#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$HOME/.local/bin:$HOME/Dotfiles/bin:$PATH"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Compatibilidad de binarios en Ubuntu/Debian
command -v batcat &>/dev/null && ! command -v bat &>/dev/null && alias bat='batcat'
command -v fdfind &>/dev/null && ! command -v fd &>/dev/null && alias fd='fdfind'
command -v git-delta &>/dev/null && ! command -v delta &>/dev/null && alias delta='git-delta'

# Starship prompt
command -v starship &>/dev/null && eval "$(starship init bash)"

# Kiro integration
[[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro &>/dev/null && \
    . "$(kiro --locate-shell-integration-path bash)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Cargo/Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL" ] && export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOME/.spicetify:$PATH"
