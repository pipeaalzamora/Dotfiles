# ⚡ Pipe's Dotfiles

> Entorno de desarrollo optimizado, modular y reproducible para Linux (KDE Plasma, Zsh, gestión de GPU AMD y snapshots Btrfs).

Este repositorio centraliza mis configuraciones personales, utilidades CLI y scripts de aprovisionamiento para estaciones de trabajo orientadas al desarrollo full-stack, DevOps y alto rendimiento en terminal.

---

## 🛠️ Stack Tecnológico

| Componente | Herramienta / Configuración |
|---|---|
| **Shell** | [Zsh](https://www.zsh.org/) con configuración modular y soporte para `.zshrc.local` |
| **Entorno de Escritorio** | KDE Plasma (perfiles, gestión de monitores y temas dinámicos) |
| **Control de Versiones** | Git + Githooks automatizados + configuración global |
| **Version Manager** | `.tool-versions` (Node.js, Go, Python, etc.) |
| **Búsqueda & Navegación** | ripgrep (`.ripgreprc`), fzf, utilidades modernas de terminal |
| **Resiliencia & Sistema** | Btrfs snapshots automatizados y optimización para GPU AMD |

---

## 📂 Estructura del Repositorio

```text
Dotfiles/
├── .config/                  # Configuraciones XDG de aplicaciones
├── .githooks/                # Hooks de Git preconfigurados
├── scripts/                  # Colección de scripts y utilidades modulares
│   ├── check-dependencies    # Verificador de requisitos del sistema
│   ├── update-all            # Actualizador unificado del sistema y paquetes
│   ├── install-programs.sh   # Instalador desatendido de software base
│   ├── install-themes.sh     # Gestor de temas y estética
│   ├── theme-switcher.sh     # Selector rápido de tema claro/oscuro
│   ├── setup-kde.sh          # Automatización de atajos y paneles KDE
│   ├── setup-btrfs-snapshots.sh # Configuración de Snapper/Btrfs
│   ├── setup-amd-gpu.sh      # Ajustes específicos para controladores AMD
│   ├── manage-monitors.sh    # Perfiles de monitores y resolución
│   └── change-wallpaper.sh   # Gestor de fondos de pantalla
├── .bashrc / .zshrc          # Configuración de shells y alias
├── .editorconfig             # Estándar de formato para editores de código
├── .gitconfig                # Alias y directrices de Git
├── .tool-versions            # Versiones fijadas de lenguajes de desarrollo
├── configure-git.sh          # Script interactivo de identidad Git
├── install.sh                # Instalador principal del entorno
├── setup.sh                  # Orquestador de configuración inicial
└── KEYBINDINGS.md            # Referencia rápida de atajos de teclado
```

---

## 🚀 Instalación

### Requisitos previos

- Sistema operativo Linux (optimizado para distribuciones basadas en Arch / Debian / Fedora con soporte systemd).
- `git` y `curl` instalados.

### 1. Clonar el repositorio

```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/Dotfiles
cd ~/Dotfiles
```

### 2. Ejecutar la instalación guiada

```bash
chmod +x install.sh
./install.sh
```

El asistente creará los enlaces simbólicos correspondientes, respaldará cualquier configuración previa en caso de colisión y ofrecerá instalar dependencias base.

### 3. Configuración personal (opcional)

Copia la plantilla local para definir variables y secretos específicos de tu máquina sin comprometerlos en Git:

```bash
cp .zshrc.local.example ~/.zshrc.local
```

Configura tu identidad de Git de forma asistida:

```bash
./configure-git.sh
```

---

## ⚙️ Uso y Mantenimiento Diario

- **Actualizar todo el sistema y herramientas:**
  ```bash
  ./scripts/update-all
  ```
- **Cambiar tema del escritorio:**
  ```bash
  ./scripts/theme-switcher.sh
  ```
- **Verificar dependencias faltantes:**
  ```bash
  ./scripts/check-dependencies
  ```
- **Consultar atajos de teclado:**
  Revisa la guía detallada en [KEYBINDINGS.md](KEYBINDINGS.md).

---

## 🛡️ Licencia y Buenas Prácticas

Distribuido para uso personal y referencia comunitaria. Antes de ejecutar scripts que alteren particiones (como `setup-btrfs-snapshots.sh`) o controladores de GPU (`setup-amd-gpu.sh`), verifica la compatibilidad con tu hardware.
