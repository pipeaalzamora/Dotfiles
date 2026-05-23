<<<<<<< HEAD
# Dotfiles — Ubuntu
||||||| 4cc8a55
# Dotfiles — Arch Linux
=======
# Dotfiles — Ubuntu & Arch Linux
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172

<<<<<<< HEAD
Setup personal para Ubuntu 24.04+ con tema **Catppuccin Mocha** en todo el stack.
||||||| 4cc8a55
Setup personal para Arch Linux con tema **Catppuccin Mocha** en todo el stack.
=======
Setup personal con tema **Catppuccin Mocha** en todo el stack.  
Compatible con **Ubuntu 26.04 LTS**, Arch Linux, Zorin OS y derivados.

> La detección del OS es automática — los dotfiles se adaptan solos sin configuración extra.
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172

---

<<<<<<< HEAD
## Instalación
||||||| 4cc8a55
## Features

- **Shell**: Zsh + Oh My Zsh + Starship prompt
- **Terminal**: Kitty (X11 y Wayland, detección automática)
- **Editor**: Neovim (Lazy.nvim)
- **Tema**: Catppuccin Mocha en kitty, nvim, btop, lazygit, zathura, bat, lsd, starship, delta y zsh-syntax-highlighting
- **CLI moderno**: lsd, bat, fd, ripgrep, fzf, zoxide, yazi, lazygit, delta, vivid, dust, procs, tealdeer, bat-extras, newsboat
- **Dev**: NVM (Node), Bun, Go, Rust, Python (pipx)

---

## Instalación rápida
=======
## Features

- **Shell**: Zsh + Oh My Zsh + Starship prompt
- **Terminal**: Kitty (X11 y Wayland, detección automática)
- **Editor**: Neovim (Lazy.nvim)
- **Tema**: Catppuccin Mocha en kitty, nvim, btop, lazygit, bat, lsd, starship, delta y zsh-syntax-highlighting
- **CLI moderno**: lsd, bat, fd, ripgrep, fzf, zoxide, yazi, lazygit, delta, vivid, dust, procs, tealdeer, bat-extras, newsboat
- **Dev**: NVM (Node), Bun, Go, Rust, Python (pipx)

---

## Instalación rápida
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172

### Ubuntu 26.04 LTS

```bash
# 1. Clonar dotfiles
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Instalar dependencias base
sudo apt update && sudo apt upgrade -y
sudo apt install -y zsh git curl wget stow build-essential \
    neovim bat fd-find ripgrep fzf btop lsd git-delta fastfetch

# 3. Crear symlinks necesarios para Ubuntu
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
ln -sf $(which fdfind) ~/.local/bin/fd

# 4. Aplicar dotfiles con Stow
stow .

# 5. Cambiar shell a Zsh
chsh -s $(which zsh)
```

> Cierra sesión y vuelve a entrar para que `$SHELL` tome efecto.

### Arch Linux

```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

El script te pregunta qué componentes quieres instalar, explicando cada uno.

---

## Scripts

| Script | Uso |
|--------|-----|
| `install.sh` | Instalación interactiva completa |
| `scripts/update-all` | Actualizar todo (`upd` desde terminal) |
| `scripts/check-dependencies` | Verificar qué está instalado |

---

## Herramientas CLI

| Herramienta | Reemplaza | Descripción |
|-------------|-----------|-------------|
| `lsd` | `ls` | Listado con iconos y colores |
| `bat` | `cat` | Visor con syntax highlighting |
| `fd` | `find` | Búsqueda de archivos rápida |
| `ripgrep` | `grep` | Búsqueda en contenido |
| `zoxide` | `cd` | Navegación inteligente |
| `fzf` | — | Fuzzy finder interactivo |
| `dust` | `du` | Uso de disco visual |
| `procs` | `ps` | Procesos con colores |
| `delta` | diff | Diffs con highlighting |
| `lazygit` | git TUI | Interfaz visual para git |
| `yazi` | ranger | File manager en terminal |
| `tealdeer` | man | Ejemplos prácticos de comandos |
| `btop` | htop | Monitor del sistema |
| `vivid` | — | Colores para LS_COLORS |
| `fx` | jq | JSON viewer interactivo |

---

## Aliases principales

```zsh
j <dir>     # zoxide — saltar a directorio frecuente
ll          # lsd -lah
lg          # lazygit
bp          # btop
glog        # git log --oneline --graph
y           # yazi (file manager, cd al salir)
upd         # actualizar sistema completo
```

## Funciones

```zsh
mkcd <dir>          # crear directorio y entrar
ff <pattern>        # buscar archivos con fd/fdfind
fif <pattern>       # buscar en contenido con rg
fzf-file            # Ctrl+F — abrir archivo en nvim
fzf-cd              # Ctrl+G — cambiar directorio
fzf-git-branch      # Ctrl+B — cambiar rama git
weather [ciudad]    # clima desde wttr.in
cheat <comando>     # cheatsheet desde cheat.sh
sysinfo             # info del sistema
backup <archivo>    # backup rápido con timestamp
newproject <nombre> # crear proyecto con git init
```

---

## Estructura

```
dotfiles/
├── install.sh              # instalador interactivo
├── .zshrc                  # aliases, funciones, plugins (interactivo)
├── .zprofile               # variables de entorno (login)
├── .bashrc                 # bash fallback
├── .gitconfig              # git global + delta
├── .gitignore_global       # ignores globales
├── .ripgreprc              # config de ripgrep
├── .editorconfig           # indentación por tipo de archivo
├── .stow-local-ignore      # archivos ignorados por stow
├── .config/
│   ├── starship.toml       # prompt
│   ├── kitty/              # terminal
│   ├── btop/               # monitor
│   ├── lazygit/            # git TUI
│   ├── lsd/                # ls mejorado
│   ├── zathura/            # PDF viewer
│   ├── fd/                 # find mejorado
│   └── yt-dlp/             # youtube downloader
└── scripts/
    ├── update-all          # actualización completa
    └── check-dependencies  # verificar instalación
```

---

## Notas

- `bat` = `batcat` en Ubuntu, `fd` = `fdfind` — el .zshrc lo detecta automáticamente
- Tema Catppuccin Mocha consistente en todas las herramientas
- El `.zprofile` maneja exports, el `.zshrc` solo lo interactivo (sin duplicación)
- Para sincronizar dotfiles usa `lg` (lazygit) desde `~/dotfiles`
