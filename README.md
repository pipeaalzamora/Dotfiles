# Dotfiles — Arch Linux

Setup personal para Arch Linux con tema **Catppuccin Mocha** en todo el stack.

---

## Features

- **Shell**: Zsh + Oh My Zsh + Starship prompt
- **Terminal**: Kitty (X11 y Wayland, detección automática)
- **Editor**: Neovim (Lazy.nvim)
- **Tema**: Catppuccin Mocha en kitty, nvim, btop, lazygit, zathura, bat, lsd, starship, delta y zsh-syntax-highlighting
- **CLI moderno**: lsd, bat, fd, ripgrep, fzf, zoxide, yazi, lazygit, delta, vivid, dust, procs, tealdeer, bat-extras
- **Dev**: NVM (Node), Bun, Go, Rust, Python (pipx)

---

## Instalación rápida

```bash
git clone <tu-repo> ~/dotfiles
cd ~/dotfiles
chmod +x scripts/*

./scripts/install-packages   # instala todo (pacman + yay + AUR)
./scripts/install-dotfiles   # crea symlinks en $HOME
./scripts/setup-dev-env      # Node, Go, Rust, Python
chsh -s $(which zsh)         # cambiar shell
```

Cierra sesión y vuelve a entrar para que `$SHELL` tome efecto.

---

## Scripts

| Script               | Cuándo usarlo                                                          |
| -------------------- | ---------------------------------------------------------------------- |
| `install-packages`   | Máquina nueva — instala todos los paquetes                             |
| `install-dotfiles`   | Máquina nueva o al clonar en otro equipo — crea los symlinks           |
| `setup-dev-env`      | Máquina nueva — instala runtimes de desarrollo                         |
| `backup-dotfiles`    | Antes de cambios grandes — backup manual                               |
| `sync-dotfiles`      | Cuando quieres commitear y pushear cambios                             |
| `update-all`         | Actualización completa del sistema (o ejecuta `upd` desde la terminal) |
| `check-dependencies` | Verificar qué herramientas están instaladas                            |

> **En servidores**: solo ejecuta `install-dotfiles`. No necesitas `install-packages` ni `setup-dev-env`.

---

## Perfiles de uso

**Máquina de desarrollo completa**

```
install-packages → install-dotfiles → setup-dev-env
```

**Servidor / VPS**

```
install-dotfiles   (solo symlinks, sin instalar paquetes)
```

**Segundo equipo personal**

```
install-packages → install-dotfiles → setup-dev-env
```

---

## Herramientas incluidas

### CLI

| Herramienta  | Reemplaza a    | Descripción                          |
| ------------ | -------------- | ------------------------------------ |
| `lsd`        | `ls`           | Listado con iconos y colores         |
| `bat`        | `cat`          | Visor con syntax highlighting        |
| `fd`         | `find`         | Búsqueda de archivos rápida          |
| `ripgrep`    | `grep`         | Búsqueda en contenido de archivos    |
| `zoxide`     | `cd`           | Navegación inteligente por historial |
| `dust`       | `du`           | Uso de disco visual                  |
| `procs`      | `ps`           | Procesos con colores y búsqueda      |
| `delta`      | diff de git    | Diffs con syntax highlighting        |
| `lazygit`    | `git` (TUI)    | Interfaz visual para git             |
| `yazi`       | ranger/nnn     | File manager en terminal             |
| `tealdeer`   | `man` (rápido) | Ejemplos prácticos de comandos       |
| `bat-extras` | —              | `batman`, `batdiff`, `batgrep`       |
| `vivid`      | —              | Genera `LS_COLORS` con temas         |
| `fx`         | jq (visual)    | JSON viewer interactivo              |

### Aliases útiles

```zsh
j <dir>     # zoxide — saltar a directorio por historial
ll          # lsd -lah
lg          # lazygit
bp          # btop
upd         # actualizar sistema completo
rrf         # rm -rf (explícito, para cuando realmente lo necesitas)
```

### Funciones

```zsh
mkcd <dir>          # crear directorio y entrar
ff <pattern>        # buscar archivos con fd
fif <pattern>       # buscar en contenido con rg
weather [ciudad]    # clima desde wttr.in
cheat <comando>     # cheatsheet desde cheat.sh
extract <archivo>   # descomprimir cualquier formato
y                   # yazi con cd al salir
```

### Keybindings (terminal)

| Atajo    | Acción                      |
| -------- | --------------------------- |
| `Ctrl+F` | FZF — abrir archivo en nvim |
| `Ctrl+G` | FZF — cambiar directorio    |
| `Ctrl+B` | FZF — cambiar rama de git   |

---

## Estructura del repo

```
dotfiles/
├── .zshrc                  # config principal de zsh
├── .bashrc                 # bash (fallback)
├── .zprofile               # variables de entorno (login shell)
├── .gitconfig              # git global
├── .gitignore_global       # ignores globales de git
├── .ripgreprc              # config de ripgrep
├── .editorconfig           # indentación por tipo de archivo
├── .config/
│   ├── kitty/              # terminal
│   ├── nvim/               # editor
│   ├── starship.toml       # prompt
│   ├── btop/               # monitor del sistema
│   ├── lazygit/            # git TUI
│   ├── lsd/                # ls mejorado
│   ├── bat/                # cat mejorado
│   ├── zathura/            # PDF viewer
│   ├── dunst/              # notificaciones
│   ├── rofi/               # launcher (X11)
│   ├── picom/              # compositor (X11)
│   ├── fd/                 # find mejorado
│   └── yt-dlp/             # youtube downloader
└── scripts/
    ├── install-packages
    ├── install-dotfiles
    ├── setup-dev-env
    ├── backup-dotfiles
    ├── sync-dotfiles
    ├── update-all
    └── check-dependencies
```

---

## Notas

- `rm` está mapeado a `rm -i` (interactivo). Para borrado forzado usa `rrf`.
- `cd` clásico está intacto. Usa `j` para zoxide.
- El recordatorio de actualización aparece si llevas más de 24h sin ejecutar `upd`.
- `tealdeer`: ejecuta `tldr --update` la primera vez para descargar la base de datos.
- Las fuentes Nerd están en los repos oficiales de Arch (`ttf-jetbrains-mono-nerd`, `ttf-meslo-nerd`).
