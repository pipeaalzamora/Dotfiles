# Dotfiles CLI - Guía de Uso

> El sistema de dotfiles de Pipe's está consolidado en un único script maestro `dotfiles` para una experiencia más unificada y fácil de usar.

## 🚀 Inicio Rápido

```bash
# Ver todos los comandos disponibles
dotfiles help

# Instalar y configurar todo
dotfiles install

# Actualizar el sistema
dotfiles update

# Cambiar tema
dotfiles theme

# Ver versículos de la Biblia
dotfiles verse
```

## 📋 Comandos Principales

### `dotfiles install`
Ejecuta la instalación y aprovisionamiento completo del sistema.

```bash
dotfiles install
```

**Qué hace:**
- Instala dependencias del sistema
- Crea enlaces simbólicos (symlinks) para archivos de configuración
- Configura servicios systemd
- Instala lanzadores .desktop
- Activa Git hooks

---

### `dotfiles update`
Actualiza todos los paquetes y gestores del sistema.

```bash
dotfiles update
```

**Qué actualiza:**
- Paquetes del sistema (pacman, apt, dnf, zypper según distro)
- Gestores de paquetes (yay, paru, etc.)
- Flatpak
- Oh My Zsh
- Repositorios Git

---

### `dotfiles doctor`
Verifica la salud de dependencias y enlaces del sistema.

```bash
dotfiles doctor
```

**Qué verifica:**
- Git
- Zsh
- Curl
- Ripgrep
- Tmux
- Bat
- FZF
- Zoxide
- Lazygit

---

## 🎨 Gestión de Interfaz

### `dotfiles theme`
Gestiona temas claro/oscuro y aplicaciones.

```bash
# Ver menú interactivo de temas
dotfiles theme

# Temas disponibles:
# - orange / naranjo / black-orange (Catppuccin Mocha Negro y Naranjo)
# - mocha (Catppuccin Mocha)
# - latte / light (Catppuccin Latte - Claro)
# - select / switch (Menú interactivo)
```

**Personaliza:**
- Tema de color KDE Plasma
- Iconos de aplicaciones
- Cursores del ratón
- Fondo de pantalla
- Tema Kvantum

---

### `dotfiles wallpaper`
Cambia el fondo de pantalla de forma aleatoria.

```bash
dotfiles wallpaper
```

**Requisitos:**
- Los fondos deben estar en `~/.local/share/wallpapers/`
- Si no existen, puedes descargarlos con: `dotfiles wallpaper download` (si está disponible)

---

### `dotfiles monitors`
Gestor de monitores con perfiles de pantalla.

```bash
dotfiles monitors
```

**Perfiles disponibles:**
- Solo pantalla principal
- Solo pantalla externa
- Extender (ambas pantallas lado a lado)
- Duplicar (espejo)

---

## ⚙️ Configuración del Sistema

### `dotfiles desktop`
Configura KDE Plasma 6 con tema Catppuccin.

```bash
dotfiles desktop
```

**Configura:**
- Tema de color Catppuccin Mocha
- Iconos Papirus Dark
- Cursor Catppuccin Mocha
- Fuentes Noto Sans
- Efectos visuales

---

### `dotfiles system`
Configura hardware según lo detectado automáticamente.

```bash
dotfiles system
```

**Detecta y configura:**
- **GPU AMD Fiji:** Instalación de drivers y configuración en GRUB
- **Btrfs:** Configuración de Snapper + snap-pac + grub-btrfs para snapshots automáticos

---

### `dotfiles profiles`
Gestiona perfiles completos de KDE Plasma.

```bash
# Ver opciones
dotfiles profiles
```

**Opciones:**
- `save` / `export` - Guardar perfil actual
- `restore` / `import` / `apply` - Restaurar perfil guardado

> **Requisito:** Necesita `konsave` instalado

---

## 📦 Instaladores

### `dotfiles programs`
Instalador interactivo de programas útiles.

```bash
dotfiles programs
```

**Categorías:**
- Sistema
- Desarrollo
- Multimedia
- Visor de imágenes
- Editor de código

---

### `dotfiles themes`
Instalador interactivo de temas y cursores.

```bash
dotfiles themes
```

**Instala:**
- Temas Kvantum Catppuccin
- Iconos (Papirus, Gruvbox, etc.)
- Cursores (Catppuccin Mocha, Breeze, etc.)

---

### `dotfiles git`
Configura Git globalmente de forma interactiva.

```bash
dotfiles git
```

**Configura:**
- Nombre de usuario
- Correo electrónico
- Editor por defecto
- Credential helper (para GitHub)

---

## 🛠️ Utilidades

### `dotfiles verse`
Muestra versículos aleatorios de la Biblia (RVR1960).

```bash
# Versículo aleatorio
dotfiles verse

# Por categoría específica
dotfiles verse salmo        # Salmos
dotfiles verse proverbio    # Proverbios

# Con notificación del sistema
dotfiles verse random notify
```

---

## 📌 Aliases Rápidos

Se incluyen aliases convenientes en tu `.zshrc`:

```bash
upd                    # dotfiles update
theme-switch           # dotfiles theme
wall-next              # dotfiles wallpaper
monitors               # dotfiles monitors
verso                  # dotfiles verse
salmo                  # dotfiles verse salmo
proverbio              # dotfiles verse proverbio
verso-notif            # dotfiles verse random notify
dots                   # cd $DOTFILES_DIR
```

---

## 🔧 Entorno de Desarrollo

El sistema incluye configuración para:

- **Shell:** Zsh + Oh My Zsh + Plugins
- **Prompt:** Starship (git integrado)
- **Editor:** Neovim personalizado
- **Terminal:** Kitty con tema Catppuccin Mocha
- **Herramientas CLI:**
  - `fzf` - Búsqueda fuzzy
  - `zoxide` - Navegación inteligente
  - `ripgrep` - Búsqueda de texto ultra-rápida
  - `bat` - `cat` con syntax highlighting
  - `lsd` - `ls` mejorado
  - `btop` - Monitor de recursos
  - `lazygit` - Git TUI

---

## 📂 Estructura de Directorios

```
Dotfiles/
├── bin/
│   └── dotfiles              ← Script maestro (punto de entrada)
├── scripts/
│   ├── lib/
│   │   └── utils.sh          ← Funciones compartidas
│   ├── theme-switcher.sh     ← Cambio de temas
│   ├── change-wallpaper.sh   ← Fondos de pantalla
│   ├── manage-monitors.sh    ← Gestión de monitores
│   ├── daily-verse.sh        ← Versículos bíblicos
│   ├── update.sh             ← Actualización del sistema
│   ├── install-programs.sh   ← Instalación de programas
│   ├── install-themes.sh     ← Instalación de temas
│   ├── setup-kde.sh          ← Configuración de KDE
│   ├── manage-kde-profile.sh ← Gestión de perfiles
│   ├── setup-amd-gpu.sh      ← Configuración GPU AMD
│   └── setup-btrfs-snapshots.sh ← Configuración Btrfs
├── .config/
│   ├── nvim/                 ← Configuración Neovim
│   ├── kitty/                ← Configuración Kitty
│   ├── starship.toml         ← Configuración Starship
│   ├── zellij/               ← Configuración Zellij
│   └── ... (otras configuraciones)
├── .zshrc                    ← Configuración Zsh principal
├── .zprofile                 ← Perfil de inicio Zsh
├── .gitconfig                ← Configuración Git global
└── DOTFILES_CLI.md           ← Esta documentación
```

---

## 🚀 Primeros Pasos

### 1. Clonar el repositorio

```bash
cd ~
git clone https://github.com/tuusuario/Dotfiles.git Dotfiles
cd Dotfiles
```

### 2. Ejecutar la instalación

```bash
dotfiles install
```

### 3. Reiniciar la sesión

```bash
exit
# Vuelve a loguear normalmente
```

### 4. Verificar que todo funciona

```bash
dotfiles doctor
```

### 5. Personalizar (opcional)

```bash
# Cambiar tema
dotfiles theme

# Configurar Git
dotfiles git

# Instalar programas adicionales
dotfiles programs
```

---

## ❓ Resolución de Problemas

### El comando `dotfiles` no se encuentra

**Solución:** Asegúrate de que `bin/` está en tu `PATH`:

```bash
export PATH="$HOME/Dotfiles/bin:$PATH"
# O agrega esta línea a tu .zshrc/.bashrc
```

### Un script dice que falta una dependencia

**Solución:** Ejecuta el instalador completo:

```bash
dotfiles install
```

O instala la dependencia manualmente:

```bash
dotfiles programs  # Para instalar programas
dotfiles themes    # Para instalar temas
```

### Los alias no funcionan

**Solución:** Recarga tu shell:

```bash
exec zsh
```

---

## 📝 Notas

- **Portabilidad:** Todo está centralizado en `bin/dotfiles`, así que puedes mover fácilmente tus dotfiles a otra máquina
- **Seguridad:** Los scripts son modulares y bien estructurados. Puedes revisar `bin/dotfiles` para ver exactamente qué hace cada comando
- **Extensibilidad:** Es fácil agregar nuevos scripts en `scripts/` y exponerlos como subcomandos en `bin/dotfiles`

---

## 🎯 Resumen de Cambios Recientes

✅ **Consolidación de scripts:** Todos los scripts individuales ahora se acceden a través del maestro `dotfiles`  
✅ **Aliases simplificados:** Usan `dotfiles` en lugar de rutas largas  
✅ **Experiencia unificada:** Un punto de entrada único y consistente  
✅ **Mejor mantenimiento:** Cambios centralizados en `bin/dotfiles`

---

¡Disfruta tus dotfiles! 🎉
