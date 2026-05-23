# Dotfiles — Ubuntu

Setup personal para Ubuntu 24.04+ con tema **Catppuccin Mocha** en todo el stack.

---

## Instalación

```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

El instalador es interactivo: te pregunta qué componentes quieres instalar y te explica para qué sirve cada uno antes de instalarlo.

Después de instalar, cierra sesión y vuelve a entrar para que Zsh tome efecto.

---

## Scripts

| Script | Uso |
|--------|-----|
| `install.sh` | Instalación interactiva completa |
| `scripts/update-all` | Actualizar todo (alias `upd` en terminal) |
| `scripts/check-dependencies` | Verificar qué herramientas están instaladas |

---

## Herramientas incluidas

| Herramienta | Reemplaza | Descripción |
|-------------|-----------|-------------|
| `lsd` | `ls` | Listado con iconos y colores |
| `bat` | `cat` | Visor con syntax highlighting |
| `fd` | `find` | Búsqueda de archivos rápida |
| `ripgrep` | `grep` | Búsqueda en contenido de archivos |
| `zoxide` | `cd` | Navegación inteligente por historial |
| `fzf` | — | Fuzzy finder interactivo |
| `dust` | `du` | Uso de disco visual |
| `procs` | `ps` | Procesos con colores |
| `delta` | diff | Diffs con syntax highlighting |
| `lazygit` | git TUI | Interfaz visual para git en terminal |
| `yazi` | ranger | File manager en terminal |
| `tealdeer` | man | Ejemplos prácticos de comandos |
| `btop` | htop | Monitor del sistema |
| `vivid` | — | Colores para LS_COLORS |
| `fx` | jq | JSON viewer interactivo |

---

## Aliases y funciones

```zsh
j <dir>              # zoxide — saltar a directorio frecuente
ll                   # lsd -lah
lg                   # lazygit
bp                   # btop
glog                 # git log --oneline --graph
y                    # yazi (file manager, cd al salir)
upd                  # actualizar sistema completo
dots                 # cd ~/dotfiles

mkcd <dir>           # crear directorio y entrar
ff <pattern>         # buscar archivos con fd
fif <pattern>        # buscar en contenido con rg
weather [ciudad]     # clima desde wttr.in
cheat <comando>      # cheatsheet desde cheat.sh
sysinfo              # info del sistema
backup <archivo>     # backup rápido con timestamp
newproject <nombre>  # crear proyecto con git init
```

### Keybindings

| Atajo | Acción |
|-------|--------|
| `Ctrl+F` | FZF — abrir archivo en nvim |
| `Ctrl+G` | FZF — cambiar directorio |
| `Ctrl+B` | FZF — cambiar rama git |

---

## Estructura

```
dotfiles/
├── install.sh           # instalador interactivo
├── .zshrc               # aliases, funciones, plugins
├── .zprofile            # variables de entorno (login)
├── .bashrc              # bash fallback
├── .gitconfig           # git global + delta
├── .gitignore_global    # ignores globales
├── .ripgreprc           # config de ripgrep
├── .editorconfig        # indentación por tipo de archivo
├── .config/
│   ├── starship.toml    # prompt Catppuccin Mocha
│   ├── kitty/           # terminal
│   ├── btop/            # monitor del sistema
│   ├── lazygit/         # git TUI
│   ├── lsd/             # ls mejorado
│   ├── zathura/         # PDF viewer
│   ├── fd/              # find mejorado
│   └── yt-dlp/          # descargador de videos
└── scripts/
    ├── update-all       # actualización completa
    └── check-dependencies
```

---

## Notas

- En Ubuntu, `bat` se llama `batcat` y `fd` se llama `fdfind` — los dotfiles lo detectan automáticamente.
- El `.zprofile` maneja solo variables de entorno. El `.zshrc` maneja solo lo interactivo.
- Para sincronizar cambios usa `lg` (lazygit) desde `~/dotfiles`.
