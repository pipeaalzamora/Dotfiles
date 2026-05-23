# Dotfiles — Ubuntu

Setup personal para Ubuntu 24.04+ con tema **Catppuccin Mocha** en todo el stack.

---

## Instalación

```bash
git clone <tu-repo> ~/dotfiles
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
ff <pattern>        # buscar archivos con fd
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
