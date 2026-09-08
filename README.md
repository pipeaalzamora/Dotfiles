# 🚀 Dotfiles Arch Linux / EndeavourOS con Catppuccin Mocha

Entorno de terminal y escritorio moderno, rápido y estético configurado con la paleta de colores **Catppuccin Mocha** para **Arch Linux** y **KDE Plasma 6**.

---

## ⚡ Instalación Rápida (Una Línea)

```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles && cd ~/dotfiles && chmod +x setup.sh && ./setup.sh
```

**O paso a paso:**
```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

---

## 📦 ¿Qué Trae Este Setup?

### 🎨 Tema Visual
- **Catppuccin Mocha** - Paleta de colores coherente en todas las aplicaciones
- **Nerd Fonts** - Iconos hermosos en terminal (MesloLGS + JetBrains Mono)
- **KDE Plasma 6** - Personalización completa con Kvantum y decoraciones Klassy
- **GTK & Qt** - Tema oscuro consistente en todas las apps

### 🖥️ Terminal & Shell
- **Zsh** - Shell moderno + Oh My Zsh + 2 plugins esenciales
- **Starship Prompt** - Prompt ultrarrápido con información de git
- **Kitty Terminal** - Emulador acelerado por GPU con transparencias
- **Historial y Autocompletado** - Sugerencias en tiempo real

### 🛠️ Herramientas CLI Modernas
| Herramienta | Reemplaza | Características |
|---|---|---|
| **lsd** | `ls` | Colores, iconos, vista árbol |
| **bat** | `cat` | Resaltado de sintaxis, números de línea |
| **ripgrep (rg)** | `grep` | Búsqueda ultrarrápida en código |
| **fd** | `find` | Búsqueda simple y rápida |
| **fzf** | - | Fuzzy finder interactivo |
| **zoxide** | `cd` | Navegación inteligente entre carpetas |
| **btop** | `top` | Monitor de recursos con gráficos |
| **yazi** | `mc` | File manager en terminal (función `y`) |
| **lazygit** | - | Interfaz visual para git (alias `lg`) |
| **delta** | `git diff` | Diff lado a lado con colores |
| **tealdeer** | `man` | Ejemplos prácticos de comandos |
| **jq** | - | Procesador interactivo de JSON |

### 💻 Desarrollo
- **Neovim** - Editor de código personalizado con LSP y autocompletado
- **Git** - Configuración global con alias útiles
- **Node.js** - NVM para cambiar versiones fácilmente
- **Python** - pipx, poetry, pip configurados
- **Rust** - Rustup y cargo listos
- **Go** - Compilador oficial
- **Bun** - Runtime JS ultrarrápido (opcional)

### 🎵 Audio
- **EasyEffects + Presets** - Ecualización de audio + filtro de ruido para micrófono

### 🎮 Extras
- **yt-dlp** - Descargador de videos/audio (alias `ydl`)
- **zathura** - Visor PDF minimalista con teclas Vim
- **zellij** - Multiplexor de terminal (alternativa a tmux)
- **Rofi** - Launcher de aplicaciones (Meta+Space)
- **newsboat** - Lector de RSS/feeds

---

## ⌨️ Atajos de Teclado Personalizados

### Terminal (Zsh/Bash)
```bash
Ctrl+R              # Buscar en historial (fzf integrado)
Ctrl+L              # Limpiar pantalla
Ctrl+A              # Inicio de línea
Ctrl+E              # Final de línea
Alt+.               # Última palabra del comando anterior
Ctrl+_              # Deshacer últimas ediciones
```

### Navegación (zoxide + lsd)
```bash
j directorio        # Saltar a carpeta frecuente (inteligente)
ji                  # Saltar interactivo (fzf)
cd -                # Carpeta anterior
ls                  # Funciona como: lsd (con iconos)
la                  # lsd -la (todo incluido archivos ocultos)
tree                # Vista en árbol (función personalizada)
```

### Git (lazygit)
```bash
lg                  # Abre interfaz visual de git (lazygit)
git add .           # Stage de cambios
git commit -m ""    # Commit
git push origin     # Push a rama actual
git status          # Ver cambios
```

### Neovim
```bash
nvim archivo.txt    # Abrir archivo
:w                  # Guardar
:q                  # Salir
:wq                 # Guardar y salir
/patrón             # Buscar
:%s/viejo/nuevo/g   # Reemplazar global
```

### Monitor de Procesos
```bash
bp                  # Abre btop (monitor interactivo)
procs patrón        # Ver procesos de patrón específico
```

### Explorador de Archivos
```bash
y                   # Abre yazi (file manager)
```

### KDE Plasma 6 (Atajos Globales)

**Meta (Super/Windows Key)**
```
Meta+Space          # Rofi Launcher (buscar aplicaciones)
Meta+Enter          # Abre terminal (Kitty)
Meta+Alt+W          # Cambiar wallpaper aleatorio
Meta+Alt+T          # Abre selector de tema
Meta+Alt+M          # Gestor de monitores
Meta+Alt+B          # Cambiar brillo
Meta+Alt+V          # Daily Verse (versículo del día en español)
Meta+Tab            # Cambiar entre ventanas
Meta+Esc            # Pantalla de bloqueo
```

**Window Management (KDE/KWin)**
```
Meta+Left           # Maximizar a la izquierda (50%)
Meta+Right          # Maximizar a la derecha (50%)
Meta+Up             # Maximizar ventana
Meta+Down           # Minimizar ventana
Meta+F              # Fullscreen
Meta+Q              # Cerrar ventana
```

**Workspaces**
```
Meta+F1...F4        # Cambiar workspace (1-4)
Meta+Shift+F1...F4  # Mover ventana a workspace
```

**Otras Aplicaciones**
```
Ctrl+Alt+T          # Terminal (Kitty)
Ctrl+Alt+E          # Editor (Neovim/VS Code si existe)
Ctrl+Alt+F          # Firefox
Ctrl+Alt+C          # Calibre (gestor de libros)
```

---

## 🎯 Funciones Personalizadas (Alias & Functions)

```bash
# Información del Sistema
fastfetch           # Información rápida del sistema
screenfetch         # Información con arte ASCII

# Desarrollo
cdp                 # cd al proyecto actual
repos               # Listar repositorios git
pull-all            # Pull en todos los repos

# Archivos
mkcd dir            # Crear directorio y entrar
rmf                 # rm seguro (con confirmación)
cp -i               # copy interactivo (no sobrescribir)

# Búsqueda y Filtrado
rg "patrón"         # Ripgrep (búsqueda en código)
fd "patrón"         # fd (búsqueda de archivos)
fzf                 # Fuzzy finder interactivo

# Sistema
update              # Actualizar sistema (pacman + yay)
clean               # Limpiar caché de pacman
disk                # Ver uso de disco
mem                 # Ver uso de memoria
```

---

## 📂 Estructura de Archivos

```
~/dotfiles/
├── setup.sh                 # 🚀 INSTALADOR ÚNICO (TODO EN UNO)
├── install.sh              # Instalador original (usado por setup.sh)
├── README.md               # Este archivo
├── KEYBINDINGS.md          # Atajos detallados (referencia)
│
├── .zshrc                  # Configuración de shell
├── .zprofile               # Perfil de shell
├── .gitconfig              # Configuración de git
├── .gitignore_global       # Gitignore global
├── .editorconfig           # Editor config
│
├── .config/
│   ├── starship.toml       # Prompt configuration
│   ├── kitty/              # Emulador de terminal
│   ├── nvim/               # Neovim config
│   ├── lazygit/            # Git visual UI
│   ├── btop/               # Monitor de recursos
│   ├── yazi/               # File manager
│   ├── zathura/            # PDF viewer
│   ├── kdeglobals          # KDE theme
│   ├── kglobalshortcutsrc  # KDE shortcuts
│   ├── Kvantum/            # Kvantum theme
│   └── ... (más herramientas)
│
├── scripts/
│   ├── check-dependencies  # Verificar qué está instalado
│   ├── install-programs.sh # Instalador de programas extra
│   ├── install-themes.sh   # Instalador de temas
│   ├── setup-kde.sh        # Personalización KDE
│   ├── download-wallpapers.sh # Descargar wallpapers
│   └── ... (más scripts útiles)
│
├── data/
│   └── bible-rvr1960.json  # Datos bíblicos
│
└── .local/share/
    ├── applications/       # Lanzadores .desktop
    └── plasma/plasmoids/   # Widgets KDE
```

---

## 🔧 Flujo de Instalación

**El script `setup.sh` hace AUTOMÁTICAMENTE:**

```
1. ✅ VALIDA
   └─ Verifica que todos los archivos están presentes
   └─ Detecta tu sistema (Arch/EndeavourOS)

2. ✅ INSTALA (Interactivo)
   └─ Te pregunta qué componentes quieres
   └─ Actualiza repositorios
   └─ Instala paquetes con pacman/yay
   └─ Configura herramientas

3. ✅ APLICA (Automático)
   └─ Crea symlinks de configuración
   └─ Detecta qué herramientas tienes
   └─ Enlaza archivos en paralelo
   └─ Configura servicios systemd
   └─ Activa Git hooks
   └─ Crea backups de config antigua

4. ✅ LISTO
   └─ Te muestra los próximos pasos
   └─ Puedes reiniciar sesión
```

---

## 📝 Primeros Pasos Después de Instalar

### 1. Reinicia Sesión
```bash
exit  # o Ctrl+D
# Vuelve a loguear
```

### 2. Verifica Dependencias
```bash
~/dotfiles/scripts/check-dependencies
```

### 3. Si Usas KDE (Personalización Extra)
```bash
~/dotfiles/scripts/setup-kde.sh
```

### 4. Descarga Wallpapers 4K (Opcional)
```bash
~/dotfiles/scripts/download-wallpapers.sh
```

### 5. Lee los Atajos Completos
```bash
cat ~/dotfiles/KEYBINDINGS.md | less
```

---

## 🎨 Tema Catppuccin Mocha

El tema **Catppuccin Mocha** está aplicado en:
- ✅ Terminal (Kitty)
- ✅ Shell (Zsh Syntax Highlighting)
- ✅ Prompt (Starship)
- ✅ Neovim (syntax, UI)
- ✅ Lazygit (UI)
- ✅ Bat (Syntax Highlighting)
- ✅ KDE Plasma (Global)
- ✅ GTK 3.0 / 4.0
- ✅ Kvantum
- ✅ EasyEffects

**Paleta de colores Catppuccin Mocha:**
```
Rosewater: #f5e0dc
Flamingo:  #f2cdcd
Pink:      #f5c2e7
Mauve:     #cba6f7
Red:       #f38181
Maroon:    #eba0ac
Peach:     #fab387
Yellow:    #f9e2af
Green:     #a6e3a1
Teal:      #94e2d5
Sky:       #89dceb
Sapphire:  #74c7ec
Blue:      #89b4fa
Lavender:  #b4befe
```

---

## 🆘 Solución de Problemas

### "El shell sigue siendo bash"
```bash
chsh -s /usr/bin/zsh
exit  # Reinicia sesión
```

### "Los comandos lsd, bat, etc. no se encuentran"
```bash
# Reinstala tools
~/dotfiles/scripts/install-programs.sh

# O manualmente
sudo pacman -S lsd bat ripgrep fd fzf zoxide btop yazi
```

### "KDE no cambió de tema"
```bash
# Ejecuta personalización de KDE
~/dotfiles/scripts/setup-kde.sh

# O reinicia KDE
kquitapp5 plasmashell; kstart5 plasmashell
```

### "Neovim no funciona correctamente"
```bash
# Actualiza Neovim
sudo pacman -S neovim

# O instala desde source (si es muy viejo)
~/dotfiles/scripts/install-programs.sh
```

### "Descarga incompleta"
```bash
rm -rf ~/dotfiles
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles
cd ~/dotfiles && chmod +x setup.sh && ./setup.sh
```

---

## 📊 Requisitos Mínimos

- **OS:** Arch Linux o EndeavourOS
- **Espacio:** ~2 GB (con wallpapers)
- **RAM:** 2 GB mínimo
- **Internet:** Conexión estable
- **Git:** Instalado (`sudo pacman -S git`)
- **Curl:** Instalado (`sudo pacman -S curl`)

---

## 🚀 Comandos Útiles Post-Instalación

```bash
# Actualizar todo
update              # Script personalizado para pacman + yay

# Información del sistema
fastfetch
screenfetch
neofetch

# Verificar qué está instalado
~/dotfiles/scripts/check-dependencies

# Cambiar wallpaper
~/dotfiles/scripts/change-wallpaper.sh
wall-next           # Alias para cambiar wallpaper aleatorio

# Gestionar monitores
~/dotfiles/scripts/manage-monitors.sh

# Cambiar tema
~/dotfiles/scripts/theme-switcher.sh

# Actualizar Zsh (Oh My Zsh)
upgrade_oh_my_zsh

# Instalar herramientas adicionales
~/dotfiles/scripts/install-programs.sh
```

---

## 📚 Archivos de Referencia

- **KEYBINDINGS.md** - Listado completo de atajos de teclado
- **.zshrc** - Todas las funciones y alias
- **.gitconfig** - Configuración de git
- **setup.sh** - Script de instalación (ver para entender qué hace)

---

## ✨ Características Destacadas

1. **Instalación Unificada** - Todo en un solo comando/script
2. **Totalmente Interactivo** - Tú decides qué instalar
3. **Configuración Automática** - Los symlinks se crean solos
4. **Seguro** - Crea backups antes de cambiar nada
5. **Modular** - Puedes ejecutar scripts individuales después
6. **Documentado** - Cada opción tiene descripción clara
7. **Tema Coherente** - Catppuccin Mocha en todas partes
8. **Performance** - Herramientas modernas y rápidas

---

## 🔗 Enlaces Útiles

- **Catppuccin:** https://catppuccin.com/
- **Arch Linux:** https://archlinux.org/
- **Oh My Zsh:** https://ohmyz.sh/
- **Neovim:** https://neovim.io/
- **Starship:** https://starship.rs/
- **KDE Plasma:** https://kde.org/plasma/

---

## 📝 Licencia & Créditos

Configuración personal para Arch Linux / EndeavourOS.
Inspirado en comunidades de ricing y configuración de Linux.

**Autor:** @pipeaalzamora
**Repositorio:** https://github.com/pipeaalzamora/Dotfiles

---

## 🎉 ¡Listo Para Empezar!

```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

**¡Disfruta tu nuevo entorno! 🚀**
