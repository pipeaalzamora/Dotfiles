# 🐧 Dotfiles & Environment Setup (Ubuntu)

[![Platform](https://img.shields.io/badge/Platform-Ubuntu%2026.10%20%7C%20LTS-E95420?style=flat-square&logo=ubuntu&logoColor=white)]()
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh-green?style=flat-square)]()
[![Stack](https://img.shields.io/badge/Stack-Fullstack%20%7C%20AI%20Engineer%20%7C%20DevOps-blueviolet?style=flat-square)]()
[![Status](https://img.shields.io/badge/Status-Activo%20%7C%20Optimizado-orange?style=flat-square)]()

Configuración automatizada de terminal, herramientas de desarrollo y dotfiles optimizada exclusivamente para **Ubuntu (26.10 y versiones LTS)**, orientada al perfil de **Fullstack Developer**, **AI Engineer** y **DevOps / Cloud Architecture**.

---

## 🚀 Instrucciones de Instalación

### Paso 1: Instalar prerrequisitos básicos
Asegúrate de contar con `git` y `curl` instalados en tu sistema:
```bash
sudo apt update && sudo apt install -y git curl
```

### Paso 2: Clonar el repositorio en tu `$HOME`
```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/Dotfiles
cd ~/Dotfiles
```

### Paso 3: Ejecutar el instalador principal
```bash
chmod +x install.sh
./install.sh
```
*El script creará automáticamente los enlaces simbólicos hacia tu `$HOME`, respaldará configuraciones existentes, resolverá la compatibilidad de binarios en Ubuntu (`batcat` → `bat`, `fdfind` → `fd`) y te preguntará si deseas instalar todos los programas recomendados.*

### Paso 4: Recargar la terminal
```bash
exec zsh
```

---

## 📦 ¿Qué Programas Instala y Configura?

El instalador desatendido (`dotfiles programs` o durante `install.sh`) configura las siguientes suites de herramientas:

### 1. Sistema, Terminal & CLI Moderno
* **Shell & Prompt:** Zsh, Oh My Zsh, Starship Prompt (minimalista y configurable).
* **Terminal & Multiplexor:** Kitty, Zellij.
* **Editores de Texto:** Neovim (configuración en Lua), Kate.
* **Herramientas de Búsqueda y Navegación:** `lsd` (ls moderno), `bat` (cat enriquecido), `fd` (búsqueda rápida), `fzf` (buscador difuso interactivo), `ripgrep` (`rg`), `zoxide` (salto de directorios inteligente).
* **Navegadores y TUIs:** `yazi` (gestor de archivos en terminal), `lazygit` (control de versiones visual).
* **Monitoreo & Utilidades:** `btop` (monitor de recursos en tiempo real), `fastfetch`, `jq`, `tealdeer` (`tldr`), `tree`, `wl-clipboard` (portapapeles Wayland), `build-essential`.

### 2. Fullstack Development Stack
* **Runtimes:** Node.js, Go (`golang-go`), Rust (`rustc`, `cargo`).
* **Editores Modernos:** **Zed Editor** (editor colaborativo ultra-veloz en Rust), Neovim.
* **Gestores de Paquetes:** `npm`, **`pnpm`**, **`Bun`** (runtime y ejecutor TS/JS ultra-rápido).
* **Bases de Datos & APIs:** Clientes CLI para PostgreSQL (`postgresql-client`), Redis (`redis-tools`), SQLite3 (`sqlite3`), y **HTTPie** (`http`) para pruebas rápidas de APIs REST.
* **Diagnóstico de Redes:** `lsof`, utilidades de puertos e inspección con `iproute2` (`ss`).

### 3. AI Engineering & Data
* **Python Moderno:** Python 3, `python3-venv`, `pipx` (cumpliendo con PEP 668).
* **Gestor Ultra-Rápido [uv](https://astral.sh/uv):** Reemplazo de alto rendimiento en Rust para pip, virtualenv y poetry (resuelve e instala librerías de IA en segundos).
* **Modelos Locales con [Ollama](https://ollama.com):** Motor para ejecutar y probar LLMs (Llama 3, DeepSeek, Qwen, Mistral) localmente en terminal o GPU.
* **Monitoreo GPU:** **`nvtop`** (monitor interactivo de GPU para procesos de IA y render) y atajo `nv` (`watch -n 1 nvidia-smi`).
* **Herramientas de IA y Terminal:** **Antigravity CLI** (`agy`), **Kiro** (terminal inteligente con IA) y plantilla segura en `~/.zshrc.local` para tokens de OpenAI, Anthropic, Gemini, Groq y Hugging Face.

### 4. DevOps, Contenedores & Cloud
* **Contenedores:** Docker Engine (`docker.io`), Docker Compose v2 (`docker-compose-v2`).
* **Configuración de Permisos:** Adición automática de tu usuario al grupo `docker` (ejecución sin `sudo`).
* **TUIs de Gestión:** **`lazydocker`** (administrador interactivo de contenedores, logs y volúmenes).
* **Kubernetes:** `kubectl`, **`k9s`** (TUI interactiva de clusters y pods), `helm`, `kubectx` y `kubens` (cambio ágil de contextos y namespaces).

### 5. Multimedia, Productividad & Periféricos
* **Productividad & Notas:** **Joplin Desktop** (notas markdown cifradas vía Snap).
* **Descargas & Torrents:** **qBittorrent** (cliente torrent nativo), **JDownloader 2** (gestor de descargas vía Snap).
* **Grabación & Streaming:** **OBS Studio** (estudio de grabación y streaming).
* **Periféricos Logitech:** **Piper** y **Solaar** (control de DPI, botones, perfiles y batería de ratones/teclados Lightspeed y Unifying).
* **Salud de Discos:** **GSmartControl** y `smartmontools` (diagnóstico SMART y salud de SSD/NVMe/HDD).
* **Audio & Efectos:** EasyEffects (ecualización y reducción de ruido para micrófonos), Cava (visualizador de espectro de audio).
* **Multimedia & Diseño:** FFmpeg, VLC, `yt-dlp`, Feh, Kate, Lunacy (Snap).

---

## 📚 Documentación de Aliases y Ejemplos de Uso

Cada categoría de aliases cuenta con su propia guía detallada con tablas, sintaxis, ejemplos de flujos de trabajo reales y recomendaciones de cuándo utilizarlos:

| Categoría | Documento | Contenido Principal |
| :--- | :--- | :--- |
| 🌿 **Git & Lazygit** | [docs/aliases-git.md](docs/aliases-git.md) | `gs`, `gaa`, `gc`, `gca`, `gp`, `gpl`, `gcb`, `glog`, `lg`, buscador difuso `Ctrl+B` |
| 🌐 **Fullstack & DB** | [docs/aliases-fullstack.md](docs/aliases-fullstack.md) | `pn`, `pnd`, `pni`, `b`, `bd`, `bx`, `pg`, `rcli`, `sq`, `http`, función `port <puerto>` |
| 🤖 **AI Engineering** | [docs/aliases-ai.md](docs/aliases-ai.md) | `uvr`, `uva`, `uvp`, `uvs`, `olr`, `oll`, `olp`, `nv` (GPU live), gestión de API keys |
| ☁️ **DevOps & Cloud** | [docs/aliases-devops.md](docs/aliases-devops.md) | `d`, `dc`, `dlogs`, `dprune`, `ld` (lazydocker), `k`, `kgp`, `klogs`, `kexec`, `k9s`, `tf` |
| ⚙️ **Sistema & Navegación** | [docs/aliases-sistema.md](docs/aliases-sistema.md) | `ls`, `ll`, `j` (zoxide), `y` (yazi), `bp` (btop), `ff`, `fif`, `backup`, `Ctrl+F`, `Ctrl+G` |

---

## ⚡ Comandos del CLI `dotfiles`

El repositorio incluye un gestor unificado ejecutable desde cualquier ubicación:

```bash
dotfiles <comando>
```

* `dotfiles doctor`: Realiza un diagnóstico completo verificando la presencia de las herramientas de Fullstack, IA, DevOps y CLI.
* `dotfiles programs`: Ejecuta el instalador automatizado de paquetes para Ubuntu.
* `dotfiles update`: Actualiza en un solo paso paquetes APT (con limpieza de huérfanos), Snaps, Flatpaks, extensiones de Zsh, paquetes globales de NPM, toolchain de Rust, herramientas de pipx y `uv`.
* `dotfiles help`: Muestra el menú de ayuda y opciones disponibles.
