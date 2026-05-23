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
<<<<<<< HEAD
./install.sh
||||||| 4cc8a55
chmod +x scripts/*

./scripts/install-packages   # instala todo (pacman + yay + AUR)
./scripts/install-dotfiles   # crea symlinks en $HOME
./scripts/setup-dev-env      # Node, Go, Rust, Python
chsh -s $(which zsh)         # cambiar shell
=======
chmod +x scripts/*

./scripts/install-packages   # instala todo (pacman + yay + AUR)
./scripts/install-dotfiles   # crea symlinks en $HOME
./scripts/setup-dev-env      # Node, Go, Rust, Python
chsh -s $(which zsh)
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
```

<<<<<<< HEAD
El script te pregunta qué componentes quieres instalar, explicando cada uno.
||||||| 4cc8a55
Cierra sesión y vuelve a entrar para que `$SHELL` tome efecto.
=======
> Cierra sesión y vuelve a entrar para que `$SHELL` tome efecto.

---

## Compatibilidad Ubuntu vs Arch

Los dotfiles detectan automáticamente el sistema y ajustan los comandos:

| Herramienta | Ubuntu | Arch | Solución |
|---|---|---|---|
| `bat` | `batcat` | `bat` | Detectado automáticamente con `$_bat_cmd` |
| `fd` | `fdfind` | `fd` | Detectado automáticamente con `$_fd_cmd` |
| `dust` | instalar via Cargo | AUR | Alias con fallback a `du -h` |
| `procs` | instalar via Cargo | AUR | Alias con fallback a `ps aux` |
| `vivid` | instalar via Cargo | AUR | `LS_COLORS` solo si está instalado |
| Nerd Fonts | descargar manualmente | repos oficiales | Ver sección Fuentes |

### Instalar herramientas opcionales en Ubuntu (via Cargo)

```bash
# Instalar Rust si no está
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Instalar herramientas
cargo install du-dust procs vivid
```
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172

---

## Scripts

<<<<<<< HEAD
| Script | Uso |
|--------|-----|
| `install.sh` | Instalación interactiva completa |
| `scripts/update-all` | Actualizar todo (`upd` desde terminal) |
| `scripts/check-dependencies` | Verificar qué está instalado |
||||||| 4cc8a55
| Script               | Cuándo usarlo                                                          |
| -------------------- | ---------------------------------------------------------------------- |
| `install-packages`   | Máquina nueva — instala todos los paquetes                             |
| `install-dotfiles`   | Máquina nueva o al clonar en otro equipo — crea los symlinks           |
| `setup-dev-env`      | Máquina nueva — instala runtimes de desarrollo                         |
| `setup-newsboat`     | Configura newsboat con feeds de Arch, KDE y Linux (es/en)              |
| `backup-dotfiles`    | Antes de cambios grandes — backup manual                               |
| `sync-dotfiles`      | Cuando quieres commitear y pushear cambios                             |
| `update-all`         | Actualización completa del sistema (o ejecuta `upd` desde la terminal) |
| `check-dependencies` | Verificar qué herramientas están instaladas                            |

> **En servidores**: solo ejecuta `install-dotfiles`. No necesitas `install-packages` ni `setup-dev-env`.
=======
| Script               | Cuándo usarlo                                                          |
| -------------------- | ---------------------------------------------------------------------- |
| `install-packages`   | Arch — instala todos los paquetes (pacman + yay + AUR)                 |
| `install-dotfiles`   | Máquina nueva o al clonar en otro equipo — crea los symlinks           |
| `setup-dev-env`      | Máquina nueva — instala runtimes de desarrollo (Node, Go, Rust, Python)|
| `setup-newsboat`     | Configura newsboat con feeds de Linux (es/en)                          |
| `backup-dotfiles`    | Antes de cambios grandes — backup manual                               |
| `sync-dotfiles`      | Cuando quieres commitear y pushear cambios                             |
| `update-all`         | Actualización completa del sistema (o ejecuta `upd` desde la terminal) |
| `check-dependencies` | Verificar qué herramientas están instaladas                            |

> **En servidores / VPS**: solo ejecuta `install-dotfiles`. No necesitas `install-packages` ni `setup-dev-env`.
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172

---

## Herramientas CLI

<<<<<<< HEAD
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

||||||| 4cc8a55
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

=======
**Máquina de desarrollo completa (Ubuntu)**

```
sudo apt install ... → stow . → setup-dev-env
```

**Máquina de desarrollo completa (Arch)**

```
install-packages → install-dotfiles → setup-dev-env
```

**Servidor / VPS**

```
install-dotfiles   (solo symlinks, sin instalar paquetes)
```

>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
---

<<<<<<< HEAD
## Aliases principales
||||||| 4cc8a55
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
| `newsboat`   | —              | Lector de RSS/Atom en terminal       |

### Aliases útiles
=======
## Herramientas incluidas

### CLI

| Herramienta  | Reemplaza a    | Ubuntu             | Arch              | Descripción                          |
| ------------ | -------------- | ------------------ | ----------------- | ------------------------------------ |
| `lsd`        | `ls`           | `apt install lsd`  | `pacman -S lsd`   | Listado con iconos y colores         |
| `bat`        | `cat`          | `batcat` (apt)     | `bat` (pacman)    | Visor con syntax highlighting        |
| `fd`         | `find`         | `fdfind` (apt)     | `fd` (pacman)     | Búsqueda de archivos rápida          |
| `ripgrep`    | `grep`         | `apt install`      | `pacman -S`       | Búsqueda en contenido de archivos    |
| `zoxide`     | `cd`           | script install     | `pacman -S`       | Navegación inteligente por historial |
| `dust`       | `du`           | Cargo              | AUR               | Uso de disco visual                  |
| `procs`      | `ps`           | Cargo              | AUR               | Procesos con colores y búsqueda      |
| `delta`      | diff de git    | `apt install`      | `pacman -S`       | Diffs con syntax highlighting        |
| `lazygit`    | `git` (TUI)    | binario GitHub     | AUR               | Interfaz visual para git             |
| `yazi`       | ranger/nnn     | binario GitHub     | AUR               | File manager en terminal             |
| `tealdeer`   | `man` (rápido) | Cargo              | AUR               | Ejemplos prácticos de comandos       |
| `vivid`      | —              | Cargo              | AUR               | Genera `LS_COLORS` con temas         |
| `fx`         | jq (visual)    | binario/npm        | AUR               | JSON viewer interactivo              |
| `newsboat`   | —              | `apt install`      | `pacman -S`       | Lector de RSS/Atom en terminal       |

### Aliases útiles
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172

```zsh
j <dir>     # zoxide — saltar a directorio frecuente
ll          # lsd -lah
lg          # lazygit
bp          # btop
glog        # git log --oneline --graph
y           # yazi (file manager, cd al salir)
upd         # actualizar sistema completo
<<<<<<< HEAD
||||||| 4cc8a55
rrf         # rm -rf (explícito, para cuando realmente lo necesitas)
=======
rrf         # rm -rf (explícito, para cuando realmente lo necesitas)
bat         # funciona en Ubuntu y Arch (alias automático)
fd          # funciona en Ubuntu y Arch (alias automático)
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
```

## Funciones

```zsh
mkcd <dir>          # crear directorio y entrar
ff <pattern>        # buscar archivos con fd/fdfind
fif <pattern>       # buscar en contenido con rg
<<<<<<< HEAD
fzf-file            # Ctrl+F — abrir archivo en nvim
fzf-cd              # Ctrl+G — cambiar directorio
fzf-git-branch      # Ctrl+B — cambiar rama git
weather [ciudad]    # clima desde wttr.in
||||||| 4cc8a55
weather [ciudad]    # clima desde wttr.in
=======
weather [ciudad]    # clima desde wttr.in (default: Santiago, CL)
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
cheat <comando>     # cheatsheet desde cheat.sh
<<<<<<< HEAD
sysinfo             # info del sistema
backup <archivo>    # backup rápido con timestamp
newproject <nombre> # crear proyecto con git init
||||||| 4cc8a55
extract <archivo>   # descomprimir cualquier formato
y                   # yazi con cd al salir
=======
extract <archivo>   # descomprimir cualquier formato
y                   # yazi con cd al salir
sysinfo             # resumen del sistema
backup <archivo>    # copia de seguridad con timestamp
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
```

---

## Estructura

```
dotfiles/
<<<<<<< HEAD
├── install.sh              # instalador interactivo
├── .zshrc                  # aliases, funciones, plugins (interactivo)
├── .zprofile               # variables de entorno (login)
├── .bashrc                 # bash fallback
├── .gitconfig              # git global + delta
├── .gitignore_global       # ignores globales
||||||| 4cc8a55
├── .zshrc                  # config principal de zsh
├── .bashrc                 # bash (fallback)
├── .zprofile               # variables de entorno (login shell)
├── .gitconfig              # git global
├── .gitignore_global       # ignores globales de git
=======
├── .zshrc                  # config principal de zsh (multi-distro)
├── .bashrc                 # bash (fallback)
├── .zprofile               # variables de entorno (login shell)
├── .gitconfig              # git global
├── .gitignore_global       # ignores globales de git
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
├── .ripgreprc              # config de ripgrep
├── .editorconfig           # indentación por tipo de archivo
├── .stow-local-ignore      # archivos ignorados por stow
├── .config/
<<<<<<< HEAD
||||||| 4cc8a55
│   ├── kitty/              # terminal
│   ├── nvim/               # editor
=======
│   ├── kitty/              # terminal
│   ├── nvim/               # editor (Lazy.nvim)
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
│   ├── starship.toml       # prompt
│   ├── kitty/              # terminal
│   ├── btop/               # monitor
│   ├── lazygit/            # git TUI
│   ├── lsd/                # ls mejorado
<<<<<<< HEAD
│   ├── zathura/            # PDF viewer
||||||| 4cc8a55
│   ├── bat/                # cat mejorado
│   ├── zathura/            # PDF viewer
│   ├── dunst/              # notificaciones
│   ├── rofi/               # launcher (X11)
│   ├── picom/              # compositor (X11)
=======
│   ├── bat/                # cat mejorado (tema Catppuccin)
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
│   ├── fd/                 # find mejorado
│   └── yt-dlp/             # youtube downloader
└── scripts/
<<<<<<< HEAD
    ├── update-all          # actualización completa
    └── check-dependencies  # verificar instalación
||||||| 4cc8a55
    ├── install-packages
    ├── install-dotfiles
    ├── setup-dev-env
    ├── backup-dotfiles
    ├── sync-dotfiles
    ├── update-all
    └── check-dependencies
```

---

## Newsboat (RSS en terminal)

```bash
./scripts/setup-newsboat   # configura feeds y crea ~/.newsboat/urls
newsboat                   # o simplemente: nb
```

Feeds incluidos: Arch Linux, KDE/Plasma, DesdeLinux, SoloConLinux, MuyLinux, Ubunlog, Linux Adictos, Proyecto TicTac, Phoronix, It's FOSS, OMG!Linux, Tecmint, LWN.net.

Para añadir más feeds edita `~/.newsboat/urls`:

```
https://ejemplo.com/feed  "Nombre del feed"
=======
    ├── install-packages    # Arch: pacman + yay + AUR
    ├── install-dotfiles    # crea symlinks con stow
    ├── setup-dev-env       # Node, Go, Rust, Python
    ├── backup-dotfiles     # backup manual
    ├── sync-dotfiles       # commit + push
    ├── update-all          # actualización completa
    └── check-dependencies  # verificar herramientas instaladas
```

---

## Fuentes (Nerd Fonts)

### Ubuntu

```bash
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts

# JetBrains Mono Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip && rm JetBrainsMono.zip

# Meslo LG Nerd Font (recomendada para Starship)
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip Meslo.zip && rm Meslo.zip

fc-cache -fv
```

### Arch Linux

```bash
sudo pacman -S ttf-jetbrains-mono-nerd ttf-meslo-nerd
```

---

## Newsboat (RSS en terminal)

```bash
./scripts/setup-newsboat   # configura feeds y crea ~/.newsboat/urls
newsboat                   # o simplemente: nb
```

Feeds incluidos: Arch Linux, KDE/Plasma, DesdeLinux, SoloConLinux, MuyLinux, Ubunlog, Linux Adictos, Phoronix, It's FOSS, OMG!Linux, Tecmint, LWN.net.

Para añadir más feeds edita `~/.newsboat/urls`:

```
https://ejemplo.com/feed  "Nombre del feed"
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
```

---

## Notas

<<<<<<< HEAD
- `bat` = `batcat` en Ubuntu, `fd` = `fdfind` — el .zshrc lo detecta automáticamente
- Tema Catppuccin Mocha consistente en todas las herramientas
- El `.zprofile` maneja exports, el `.zshrc` solo lo interactivo (sin duplicación)
- Para sincronizar dotfiles usa `lg` (lazygit) desde `~/dotfiles`
||||||| 4cc8a55
- `rm` está mapeado a `rm -i` (interactivo). Para borrado forzado usa `rrf`.
- `cd` clásico está intacto. Usa `j` para zoxide.
- El recordatorio de actualización aparece si llevas más de 24h sin ejecutar `upd`.
- `tealdeer`: ejecuta `tldr --update` la primera vez para descargar la base de datos.
- Las fuentes Nerd están en los repos oficiales de Arch (`ttf-jetbrains-mono-nerd`, `ttf-meslo-nerd`).
=======
- `rm` está mapeado a `rm -i` (interactivo). Para borrado forzado usa `rrf`.
- `cd` clásico está intacto. Usa `j` para zoxide.
- `bat` y `fd` se resuelven automáticamente (`batcat`/`fdfind` en Ubuntu, `bat`/`fd` en Arch).
- El recordatorio de actualización aparece si llevas más de 24h sin ejecutar `upd`.
- `tealdeer`: ejecuta `tldr --update` la primera vez para descargar la base de datos.
- `dust`, `procs` y `vivid` tienen fallbacks si no están instalados — instálalos con `cargo install` para activarlos.
>>>>>>> caa102d9198c573d25a1bb9ca1d93a112d3f6172
