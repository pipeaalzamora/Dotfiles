# Dotfiles — Arch Linux / EndeavourOS

Entorno de terminal moderno, rápido y estético configurado con la paleta de colores **Catppuccin Mocha**.

---

## ⚡ Instalación Rápida

### One-Liner (Clonar e Iniciar Instalador)

```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles && cd ~/dotfiles && chmod +x install.sh scripts/* && ./install.sh
```

El instalador es completamente interactivo: pregunta paso a paso qué componentes deseas instalar y crea copias de respaldo automáticas (`~/dotfiles_backup_YYYYMMDD_HHMMSS`) antes de enlazar archivos.

---

## 🛠️ Herramientas y Componentes

| Categoría | Herramienta | Utilidad |
| :--- | :--- | :--- |
| **Shell & Prompt** | `Zsh` + `Starship` | Prompt contextual de alto rendimiento con plugins de autosuggestions y highlighting. |
| **Terminal & Multiplexer** | `Kitty` + `Zellij` | Terminal acelerado por GPU y multiplexor con paneles divididos y sesiones. |
| **Navegación & Búsqueda** | `zoxide`, `fzf`, `fd`, `ripgrep` | Salto inteligente entre carpetas (`j <dir>`) y búsquedas ultra rápidas de archivos/código. |
| **Git & Diffs** | `lazygit`, `git-delta` | TUI completa para Git (`lg`) y diffs side-by-side con resaltado de sintaxis. |
| **Monitor & Utilidades** | `btop`, `fastfetch`, `yazi`, `bat`, `lsd` | Monitoreo visual de recursos (`bp`), explorador de archivos con preview y reemplazos enriquecidos para `ls` y `cat`. |
| **Runtime & Versiones** | `mise` / `asdf` | Control de versiones fijadas para Node.js, Go y Python mediante `.tool-versions`. |

---

## 📁 Estructura del Repositorio

```text
Dotfiles/
├── .config/
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
├── scripts/
│   ├── check-dependencies  # Validador de comandos instalados
│   ├── setup-amd-gpu.sh    # Script opcional para parámetros amdgpu en GRUB
│   └── update-all          # Actualizador centralizado del sistema y paquetes
├── .editorconfig           # Reglas de formato de código
├── .gitconfig              # Configuración global de Git + delta
├── .gitignore_global       # Archivos ignorados globalmente
├── .ripgreprc              # Flags de búsqueda para ripgrep
├── .tool-versions          # Versiones globales de Node, Go, Python
├── .zprofile               # Variables de entorno para login
├── .zshrc                  # Aliases, funciones y configuración interactiva
├── .zshrc.local.example    # Plantilla para configuraciones privadas
└── install.sh              # Script instalador principal
```

---

## 🔒 Configuración Personal y Privada

Todo ajuste específico de tu máquina o datos confidenciales (tokens, rutas privadas, funciones especiales) va en `~/.zshrc.local`.

```bash
cp .zshrc.local.example ~/.zshrc.local
```

`.zshrc` carga este archivo automáticamente al final de cada sesión interactiva y está protegido en `.gitignore` para evitar filtraciones en git.

---

## 🚀 Scripts de Mantenimiento

- **Actualizar todo**: ejecuta `upd` o `./scripts/update-all` para refrescar repositorios pacman, AUR y herramientas CLI.
- **Chequear dependencias**: `./scripts/check-dependencies` reporta el estado de cada comando configurado.
- **Optimización GPU AMD**: `./scripts/setup-amd-gpu.sh` configura el soporte amdgpu para familias GCN 3.0 (Fiji / R9 Fury).
