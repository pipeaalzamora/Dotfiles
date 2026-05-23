# Dotfiles — Ubuntu & Arch Linux

Setup personal con tema **Catppuccin Mocha** en todo el stack.  
Compatible con **Ubuntu 26.04 LTS**, Arch Linux, Zorin OS y derivados.

> La detección del OS es automática — los dotfiles se adaptan solos sin configuración extra.

---

## Features

- **Shell**: Zsh + Oh My Zsh + Starship prompt
- **Terminal**: Kitty (X11 y Wayland, detección automática)
- **Editor**: Neovim (Lazy.nvim)
- **Tema**: Catppuccin Mocha en kitty, nvim, btop, lazygit, bat, lsd, starship, delta y zsh-syntax-highlighting
- **CLI moderno**: lsd, bat, fd, ripgrep, fzf, zoxide, yazi, lazygit, delta, vivid, dust, procs, tealdeer, bat-extras, newsboat
- **Dev**: NVM (Node), Bun, Go, Rust, Python (pipx)

---

## Instalación rápida

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
chmod +x scripts/*

./scripts/install-packages   # instala todo (pacman + yay + AUR)
./scripts/install-dotfiles   # crea symlinks en $HOME
./scripts/setup-dev-env      # Node, Go, Rust, Python
chsh -s $(which zsh)
```

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

---

## Scripts

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

---

## Perfiles de uso

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

---

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

```zsh
j <dir>     # zoxide — saltar a directorio por historial
ll          # lsd -lah
lg          # lazygit
bp          # btop
nb          # newsboat — lector RSS
upd         # actualizar sistema completo
rrf         # rm -rf (explícito, para cuando realmente lo necesitas)
bat         # funciona en Ubuntu y Arch (alias automático)
fd          # funciona en Ubuntu y Arch (alias automático)
```

### Funciones

```zsh
mkcd <dir>          # crear directorio y entrar
ff <pattern>        # buscar archivos con fd/fdfind
fif <pattern>       # buscar en contenido con rg
weather [ciudad]    # clima desde wttr.in (default: Santiago, CL)
cheat <comando>     # cheatsheet desde cheat.sh
extract <archivo>   # descomprimir cualquier formato
y                   # yazi con cd al salir
sysinfo             # resumen del sistema
backup <archivo>    # copia de seguridad con timestamp
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
├── .zshrc                  # config principal de zsh (multi-distro)
├── .bashrc                 # bash (fallback)
├── .zprofile               # variables de entorno (login shell)
├── .gitconfig              # git global
├── .gitignore_global       # ignores globales de git
├── .ripgreprc              # config de ripgrep
├── .editorconfig           # indentación por tipo de archivo
├── .stow-local-ignore      # archivos ignorados por stow
├── .config/
│   ├── kitty/              # terminal
│   ├── nvim/               # editor (Lazy.nvim)
│   ├── starship.toml       # prompt
│   ├── btop/               # monitor del sistema
│   ├── lazygit/            # git TUI
│   ├── lsd/                # ls mejorado
│   ├── bat/                # cat mejorado (tema Catppuccin)
│   ├── fd/                 # find mejorado
│   └── yt-dlp/             # youtube downloader
└── scripts/
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
```

---

## Notas

- `rm` está mapeado a `rm -i` (interactivo). Para borrado forzado usa `rrf`.
- `cd` clásico está intacto. Usa `j` para zoxide.
- `bat` y `fd` se resuelven automáticamente (`batcat`/`fdfind` en Ubuntu, `bat`/`fd` en Arch).
- El recordatorio de actualización aparece si llevas más de 24h sin ejecutar `upd`.
- `tealdeer`: ejecuta `tldr --update` la primera vez para descargar la base de datos.
- `dust`, `procs` y `vivid` tienen fallbacks si no están instalados — instálalos con `cargo install` para activarlos.
