# Dotfiles — Arch Linux / EndeavourOS

Entorno de terminal y escritorio moderno, rápido y estético configurado con la paleta de colores **Catppuccin Mocha** para **Arch Linux** y **KDE Plasma 6**.

---

## ⚡ Instalación Rápida

### One-Liner (Clonar e Iniciar Instalador)

```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles && cd ~/dotfiles && chmod +x install.sh scripts/* && ./install.sh
```

El instalador es completamente interactivo: pregunta paso a paso qué componentes deseas instalar, explica en detalle la función de cada personalización y crea copias de respaldo automáticas (`~/dotfiles_backup_YYYYMMDD_HHMMSS`) antes de enlazar archivos.

> 📖 **Consulta la [Guía Completa de Atajos de Teclado (KEYBINDINGS.md)](KEYBINDINGS.md)** para conocer todos los atajos de KDE, Neovim, Kitty y Zsh.

---

## 🛠️ Herramientas y Componentes

| Categoría | Herramienta | Utilidad |
| :--- | :--- | :--- |
| **Escritorio & Qt** | `Kvantum` + `Klassy` | Motor de temas SVG para transparencias reales y decoraciones de ventana con esquinas redondeadas en Plasma 6. |
| **Shell & Prompt** | `Zsh` + `Starship` | Prompt contextual de alto rendimiento con plugins de autosuggestions y highlighting. |
| **Editor de Código** | `Neovim` (Lua + Lazy) | Entorno modal completo con LSP, Treesitter, Telescope, Neo-tree y tema Catppuccin Mocha. |
| **Terminal & Multiplexer** | `Kitty` + `Zellij` | Terminal acelerado por GPU y multiplexor con paneles divididos y sesiones. |
| **Lanzador & Búsqueda** | `rofi-wayland`, `zoxide`, `fzf`, `fd`, `ripgrep` | Lanzador modal con tema Catppuccin, salto inteligente (`j <dir>`) y búsquedas instantáneas. |
| **Audio & PipeWire** | `EasyEffects` | Presets de ecualización de claridad y supresión de ruido por IA (RNNoise) en micrófono. |
| **Snapshots & Respaldo**| `Btrfs` + `Snapper` + `Konsave` | Puntos de restauración automáticos antes de cada actualización en GRUB y perfiles de KDE. |
| **Integración GTK** | `gtk-3.0` / `gtk-4.0` | Forzado de modo oscuro, tema de iconos Papirus-Dark y cursores consistentes para aplicaciones GTK. |
| **Monitor & Utilidades** | `btop`, `fastfetch`, `yazi`, `bat`, `lsd` | Monitoreo visual de recursos (`bp`), explorador de archivos con preview y reemplazos enriquecidos para `ls` y `cat`. |

---

## 📁 Estructura del Repositorio

```text
Dotfiles/
├── .config/
│   ├── environment.d/      # Variables de entorno systemd (QT_STYLE_OVERRIDE=kvantum)
│   ├── Kvantum/            # Configuración y temas de Kvantum (Catppuccin Mocha)
│   ├── kdeglobals          # Colores globales, fuentes e iconos de KDE Plasma
│   ├── kglobalshortcutsrc  # Atajos de teclado globales de KDE Plasma
│   ├── kwinrc              # Reglas de ventanas, efectos y desenfoque (blur)
│   ├── easyeffects/        # Presets de audio (claridad de sonido y supresión de ruido en micrófono)
│   ├── fontconfig/         # Renderizado nítido de fuentes y fallbacks Nerd Font
│   ├── nvim/               # Configuración modular de Neovim en Lua con Lazy.nvim
│   ├── gtk-3.0/ & gtk-4.0/ # Coherencia de temas oscuros, iconos y cursores para GTK
│   ├── rofi/               # Lanzador Rofi-Wayland con tema Catppuccin Mocha
│   ├── fastfetch/          # Resumen del sistema con iconos y colores Mocha
│   ├── yazi/               # Administrador de archivos en terminal (tema Mocha)
│   ├── bat/                # Visualizador de código con tema Catppuccin Mocha
│   ├── btop/               # Monitor del sistema
│   ├── fd/                 # Reglas de búsqueda ignoradas
│   ├── kitty/              # Terminal Kitty (Mocha)
│   ├── lazygit/            # Git visual TUI
│   ├── lsd/                # ls moderno
│   ├── starship.toml       # Prompt Starship
│   ├── yt-dlp/             # Configuración de descargas
│   ├── zathura/            # Visor PDF minimalista
│   └── zellij/             # Terminal multiplexer (Catppuccin)
├── .github/
│   └── workflows/
│       └── lint.yml        # CI automatizado con ShellCheck
├── .githooks/
│   └── pre-commit          # Hook de validación de sintaxis antes de cada commit
├── scripts/
│   ├── check-dependencies  # Validador de comandos instalados
│   ├── install-programs.sh # Instalador de aplicaciones y herramientas Open Source
│   ├── install-themes.sh   # Instalador exhaustivo de temas visuales, fuentes, SDDM, GRUB, iconos
│   ├── theme-switcher.sh   # Selector interactivo multi-tema para Rofi y Terminal
│   ├── change-wallpaper.sh # Cambiador dinámico de fondos de pantalla (estáticos y videos)
│   ├── download-wallpapers.sh # Descargador de colecciones de fondos Catppuccin 4K y videos
│   ├── setup-kde.sh        # Automatización de KDE Plasma 6 (Kvantum, Klassy, atajos)
│   ├── setup-btrfs-snapshots.sh # Configuración de Snapper + snap-pac + GRUB-Btrfs
│   ├── manage-kde-profile.sh # Guardar/Restaurar perfil de escritorio completo con Konsave
│   ├── setup-amd-gpu.sh    # Script opcional para parámetros amdgpu en GRUB
│   └── update-all          # Actualizador centralizado del sistema (pacman/yay/npm/rust/pipx)
├── .editorconfig           # Reglas de formato de código
├── .gitconfig              # Configuración global de Git + delta
├── .gitignore_global       # Archivos ignorados globalmente
├── .ripgreprc              # Flags de búsqueda para ripgrep
├── .tool-versions          # Versiones globales de Node, Go, Python
├── .zprofile               # Variables de entorno para login
├── .zshrc                  # Aliases, funciones y configuración interactiva
├── .zshrc.local.example    # Plantilla para configuraciones privadas
└── install.sh              # Script instalador interactivo principal
```

---

## 🎨 Atajos y Gestión de KDE Plasma 6

| Atajo de Teclado | Acción | Descripción |
| :--- | :--- | :--- |
| **`Meta + Shift + T`** | `theme-switch` | Abre el menú interactivo en Rofi para cambiar entre 6 temas (Catppuccin, Tokyo Night, Nord, Dracula, Gruvbox, Latte). |
| **`Meta + Alt + W`** | `wall-next` | Rota aleatoriamente el fondo de pantalla (soporta imágenes 4K y videos en bucle con `mpvpaper`). |
| **`Meta + Return`** | Lanzar Kitty | Abre la terminal acelerada por GPU Kitty. |
| **`Meta + Shift + S`** | Captura de Pantalla | Inicia la herramienta de recorte rectangular de Spectacle. |
| **`Meta + C`** / **`Meta + F`** | Ventanas | Cierra la ventana activa (`Meta+C`) o la maximiza (`Meta+F`). |

### Comandos útiles en terminal:
* `theme-switch`: Abre el selector de temas desde la consola.
* `wall-next` / `wall-download`: Cambia de wallpaper o descarga la colección.
* `krestart`: Reinicia el panel y widgets de forma limpia vía systemd.
* `kwin-reload`: Recarga las reglas y efectos de KWin al vuelo con D-Bus.
* `dots-export-kde`: Exporta tus configuraciones activas de KDE hacia tu carpeta de dotfiles.
* `./scripts/manage-kde-profile.sh save / restore`: Guarda y restaura snapshots completos de tu escritorio con Konsave.

---

## 🔒 Configuración Personal y Privada

Todo ajuste específico de tu máquina o datos confidenciales (tokens, rutas privadas, funciones especiales) va en `~/.zshrc.local`.

```bash
cp .zshrc.local.example ~/.zshrc.local
```

`.zshrc` carga este archivo automáticamente al final de cada sesión interactiva y está protegido en `.gitignore` para evitar filtraciones en git.
