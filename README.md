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

## 🚦 Orden de Ejecución de Scripts: Paso a Paso

Sigue este orden exacto para instalar y configurar tu entorno sin conflictos:

### 1️⃣ Paso 1 (Obligatorio) — Instalador Principal
```bash
./install.sh
```
* **¿Qué hace?:** Es el instalador interactivo central. Actualiza repositorios, instala `yay` (AUR), configura Zsh con Oh My Zsh, Starship, las fuentes **Nerd Fonts** (obligatorias para que los iconos no se vean rotos), herramientas CLI y crea todos los enlaces simbólicos (`symlinks`) y lanzadores `.desktop`.
* **Prioridad:** **100% Obligatorio.** Todo lo demás depende de este paso.

---

### 2️⃣ Paso 2 (Altamente Recomendado) — KDE Plasma 6
```bash
./scripts/setup-kde.sh
```
* **¿Qué hace?:** Aplica la estética visual Catppuccin Mocha a KDE Plasma: motor **Kvantum** (transparencias y efecto blur real), decoraciones de ventana **Klassy** (esquinas redondeadas), cursores, iconos Papirus y enlaza los atajos de teclado globales.
* **Nota:** `install.sh` te preguntará si deseas ejecutarlo automáticamente en el Paso 8, pero puedes correrlo manualmente cuando quieras reaplicar la configuración.
* **Prioridad:** **Obligatorio si usas KDE Plasma 6.**

---

### 3️⃣ Paso 3 (Recomendado) — Fondos de Pantalla 4K
```bash
./scripts/download-wallpapers.sh
```
* **¿Qué hace?:** Descarga la colección curada de wallpapers estáticos 4K en `~/Imágenes/Wallpapers/Catppuccin`.
* **Por qué ejecutarlo:** Permite que el atajo **`Meta + Alt + W`** (`wall-next`) tenga imágenes listas para rotar aleatoriamente desde el primer momento.
* **Prioridad:** **Recomendado.**

---

### 4️⃣ Paso 4 (Opcional) — Suite Multi-Tema Completa
```bash
./scripts/install-themes.sh
```
* **¿Qué hace?:** Si quieres alternar entre varios estilos con el atajo **`Meta + Shift + T`** (`theme-switch`), este script instala los paquetes para: **Tokyo Night**, **Nord**, **Dracula**, **Gruvbox** y **Catppuccin Latte**, además de packs de iconos (Papirus, Tela, Nordzy), cursores (Bibata, Capitaine) y temas para la pantalla de login (**SDDM**) y gestor de arranque (**GRUB**).
* **Prioridad:** **Opcional.** Solo si te gusta cambiar de tema frecuentemente.

---

### 5️⃣ Paso 5 (Condicional / Según tu Hardware)
Ejecuta estos scripts únicamente si aplican a tu equipo o flujo:

* **Si tu sistema usa Btrfs:**
  ```bash
  ./scripts/setup-btrfs-snapshots.sh
  ```
  *Crea copias de seguridad instantáneas antes de cada actualización y añade entradas en el menú de GRUB para arrancar en un punto anterior si el sistema falla.*

* **Si necesitas programas de uso diario (Navegadores, IDEs, Apps):**
  ```bash
  ./scripts/install-programs.sh
  ```
  *Instalador interactivo de software abierto: Firefox, Brave, VS Code, Kiro, DBeaver, Docker, MPV, VLC, Telegram, Obsidian, etc.*

* **Si tienes una GPU AMD GCN antigua (Fiji / R9 Fury / Hawaii / Bonaire):**
  ```bash
  ./scripts/setup-amd-gpu.sh
  ```
  *Aplica los parámetros `amdgpu` en GRUB necesarios para compatibilidad total con Wayland y Vulkan (RADV).*

---

### 6️⃣ Paso 6 (Verificación y Mantenimiento)
* **Comprobar que todo quedó instalado:**
  ```bash
  check-dependencies
  ```
* **Actualizar todo el sistema y herramientas en 1 solo paso:**
  ```bash
  upd
  ```

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
* `verso` / `salmo` / `proverbio`: Muestra versículos de bendición y sabiduría (Reina Valera 1960) en la terminal o lanza notificación con `verso-notif`.
* `krestart`: Reinicia el panel y widgets de KDE limpiamente vía systemd.
* `kwin-reload`: Recarga las reglas y efectos de KWin al vuelo con D-Bus.
* `dots-export-kde`: Exporta tus configuraciones activas de KDE hacia tu carpeta de dotfiles.
* `manage-kde-profile.sh save / restore`: Guarda y restaura snapshots completos de tu escritorio con Konsave.
* `upd`: Actualiza todo el sistema (pacman, AUR, npm, rustup, pipx) en un solo paso.
* `check-dependencies`: Comprueba el estado y versión de todas las herramientas instaladas.
* **Widget en KDE Plasma 6:** Incluye el widget plasmoid nativo *"Versículo Bíblico (RVR 1960)"* listo para agregar al escritorio o panel desde el menú de widgets de KDE.

---

## 🔒 Configuración Personal y Privada

Todo ajuste específico de tu máquina o datos confidenciales (tokens, rutas privadas, funciones especiales) va en `~/.zshrc.local`.

```bash
cp .zshrc.local.example ~/.zshrc.local
```

`.zshrc` carga este archivo automáticamente al final de cada sesión interactiva y está protegido en `.gitignore` para evitar filtraciones en git.
