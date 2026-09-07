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

## 🚦 Guía Paso a Paso: ¿Qué Instalar Primero y Qué es Opcional?

Para que tu sistema quede perfectamente configurado sin sobrecargarlo innecesariamente, sigue este orden recomendado:

### 1️⃣ Fase 1: Núcleo del Sistema (Obligatorio)
Son los componentes fundamentales para que la terminal y los scripts funcionen correctamente:
* **Paso 1 del instalador (Actualización + Base + AUR yay):** Sincroniza repositorios e instala `git`, `curl`, `base-devel` y el gestor de AUR `yay`.
* **Paso 2 (Shell Zsh + Oh My Zsh):** Instala Zsh y los plugins esenciales (`zsh-autosuggestions`, `zsh-syntax-highlighting`).
* **Paso 3 (Starship Prompt):** Prompt rápido en Rust que muestra ramas de Git, versiones y entorno.
* **Paso 5 (Nerd Fonts - MesloLGS & JetBrains Mono):** **Fundamental.** Si no instalas las fuentes Nerd Fonts, verás iconos rotos o cuadrados vacíos en la terminal, Starship y los exploradores de archivos.

---

### 2️⃣ Fase 2: Experiencia de Escritorio y KDE Plasma (Altamente Recomendado)
Si estás en KDE Plasma 6 con Wayland, esta fase transforma el aspecto visual y la ergonomía:
* **Personalización de KDE Plasma 6 (`scripts/setup-kde.sh`):**
  * *Kvantum Engine:* Transparencias y desenfoque (blur) real en Dolphin y aplicaciones Qt.
  * *Klassy:* Bordes de ventana con esquinas redondeadas y botones modernos.
  * *Lanzadores `.desktop` y Atajos:* Configura `Meta+Return` (Kitty), `Meta+Shift+S` (Captura), `Meta+Shift+T` (Selector de temas), `Meta+Alt+W` (Wallpapers) y `Meta+P` (Monitores).
* **Terminal Kitty (`kitty`):** Emulador acelerado por GPU con soporte de imágenes y transparencia nativa.
* **Rofi-Wayland:** Menú lanzador modal ultrarrápido adaptado a Wayland.
* **EasyEffects (Audio PipeWire):** Incluye presets listos para usar: cancelación de ruido en micrófono por IA (RNNoise) y ecualización de claridad sonora.
* **Snapshots Btrfs (`scripts/setup-btrfs-snapshots.sh`):** *(Solo si usas partición Btrfs)* Puntos de restauración automáticos antes de cada actualización con pacman/yay accesibles desde el menú de GRUB.

---

### 3️⃣ Fase 3: Utilidades Modernas de Terminal (Opcional según tu flujo)
Herramientas CLI escritas en Rust/Go que reemplazan herramientas clásicas de Linux:
* **Recomendadas para el día a día:**
  * `lsd`: Reemplazo moderno de `ls` con colores e iconos.
  * `bat`: Reemplazo de `cat` con sintaxis resaltada y números de línea.
  * `zoxide`: Salto inteligente entre carpetas frecuentes con `j <carpeta>`.
  * `fzf`: Búsqueda interactiva de archivos e historial con `Ctrl+R`.
  * `yazi`: Explorador de archivos en consola con preview de imágenes y videos.
  * `lazygit`: Interfaz TUI para Git (`lg`).
  * `btop`: Monitor de recursos del sistema (`bp`).
* **Específicas / Opcionales:**
  * `zellij`: Multiplexor de terminal moderno (alternativa a tmux).
  * `dust`, `procs`, `fx`, `tealdeer`, `yt-dlp`, `zathura`.

---

### 4️⃣ Fase 4: Entornos de Desarrollo (Según tus lenguajes)
Instala únicamente los lenguajes y herramientas que utilices activamente:
* **Neovim:** Editor de código modular configurado en Lua con Lazy.nvim, LSP, Treesitter y Neo-tree.
* **NVM / Node.js & Bun:** Para desarrollo frontend, backend y TypeScript.
* **Python + pipx + poetry:** Entorno limpio para scripts y proyectos en Python.
* **Go / Rust (rustup):** Compiladores y herramientas oficiales.
* **Docker / Podman:** Para contenedores y virtualización.

---

### 5️⃣ Fase 5: Personalización Visual Avanzada y Aplicaciones Extra
* **Suite Multi-Tema (`scripts/install-themes.sh`):**
  * Instala paquetes de iconos (Papirus, Tela, Nordzy), cursores (Catppuccin, Bibata, Capitaine), temas para SDDM (pantalla de inicio de sesión) y GRUB.
  * Descarga colecciones de fondos de pantalla en 4K estáticos y videos en bucle (`scripts/download-wallpapers.sh`).
* **Instalador de Programas Abiertos (`scripts/install-programs.sh`):**
  * Navegadores (Firefox, Brave), IDEs (VS Code, Kiro), Bases de datos (DBeaver, Beekeeper), Multimedia (VLC, MPV), Comunicación (Telegram, Discord, Slack) y Notas (Obsidian, Joplin).
* **Hardware AMD Antiguo (`scripts/setup-amd-gpu.sh`):**
  * Habilita parámetros `amdgpu` en GRUB para tarjetas gráficas AMD GCN anteriores que requieran Vulkan y soporte Wayland.

---

## 🎨 Atajos y Gestión de KDE Plasma 6

| Atajo de Teclado | Acción | Descripción |
| :--- | :--- | :--- |
| **`Meta + Shift + T`** | `theme-switch` | Abre el menú interactivo en Rofi para alternar entre 6 temas (Catppuccin Mocha, Latte, Tokyo Night, Nord, Dracula, Gruvbox). |
| **`Meta + Alt + W`** | `wall-next` | Rota aleatoriamente el fondo de pantalla (imágenes 4K y videos animados con `mpvpaper`). |
| **`Meta + P`** | `monitors` | Abre el selector de perfiles de pantallas (pantalla principal, externa, extender a derecha/izquierda, duplicar). |
| **`Meta + Return`** | Lanzar Kitty | Abre la terminal acelerada por GPU Kitty. |
| **`Meta + Shift + S`** | Captura de Pantalla | Inicia la herramienta de recorte rectangular de Spectacle. |
| **`Meta + C`** / **`Meta + F`** | Ventanas | Cierra la ventana activa (`Meta+C`) o la maximiza (`Meta+F`). |

### Comandos útiles en terminal:
* `theme-switch`: Selector dinámico de temas desde la consola.
* `wall-next` / `wall-download`: Cambia de wallpaper o descarga la colección de fondos.
* `monitors`: Gestor interactivo multi-monitor con KScreen.
* `krestart`: Reinicia el panel y widgets de KDE limpiamente vía systemd.
* `kwin-reload`: Recarga las reglas y efectos de KWin al vuelo con D-Bus.
* `dots-export-kde`: Exporta tus configuraciones activas de KDE hacia tu carpeta de dotfiles.
* `manage-kde-profile.sh save / restore`: Guarda y restaura snapshots completos de tu escritorio con Konsave.
* `upd`: Actualiza todo el sistema (pacman, AUR, npm, rustup, pipx) en un solo paso.
* `check-dependencies`: Comprueba el estado y versión de todas las herramientas instaladas.

---

## 🔒 Configuración Personal y Privada

Todo ajuste específico de tu máquina o datos confidenciales (tokens, rutas privadas, funciones especiales) va en `~/.zshrc.local`.

```bash
cp .zshrc.local.example ~/.zshrc.local
```

`.zshrc` carga este archivo automáticamente al final de cada sesión interactiva y está protegido en `.gitignore` para evitar filtraciones en git.
