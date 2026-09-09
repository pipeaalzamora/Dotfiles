# ⚡ Dotfiles

Configuraciones minimalistas y scripts esenciales para Linux.

---

## 🚀 Instalación Rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/Dotfiles
cd ~/Dotfiles

# 2. Instalar todo de cero
dotfiles install

# 3. Recargar shell
exec zsh
```

---

## 📋 Comandos Disponibles

```bash
dotfiles install      # Instala todo (enlaces, paquetes, configuración)
dotfiles update       # Actualiza paquetes del sistema
dotfiles doctor       # Verifica dependencias
dotfiles programs     # Instala programas esenciales
dotfiles git          # Configura Git
dotfiles system       # Configura Btrfs (si lo tienes)
dotfiles help         # Muestra ayuda
```

---

## 📂 Estructura

```
Dotfiles/
├── bin/dotfiles          ← Comando maestro
├── scripts/              ← Scripts esenciales
├── .zshrc                ← Configuración Zsh
├── .gitconfig            ← Configuración Git
└── install.sh            ← Instalador principal
```

---

## 🎯 Características

✅ **Simple** - Solo lo necesario  
✅ **Rápido** - Sin automatización innecesaria  
✅ **Mantenible** - Código limpio  
✅ **Manual** - Personalización según quieras  
✅ **Widget de Versículos** - Widget para Plasma 6  

---

## 💡 Personalización

- **Temas & Apariencia:** Sistema Settings de KDE
- **Fondos:** `plasma-apply-wallpaperimage`
- **Git:** `dotfiles git`
- **Monitores:** KDE System Settings → Display and Monitor
- **Widget de Versículos:** Botón derecho → Añadir widget → "Verse Widget"

---

## 📖 Widget de Versículos

Widget para KDE Plasma 6 que muestra versículos aleatorios de la Biblia RVR 1960.

**Instalación:**
1. Botón derecho en panel o escritorio
2. "Añadir widget..."
3. Buscar "Verse Widget"

El widget está en: `~/.local/share/plasma/plasmoids/org.kde.plasma.versewidget/`  
Datos en: `~/Dotfiles/data/bible-rvr1960.json`

---

## ❓ Si Algo Falla

```bash
# Verifica dependencias
dotfiles doctor

# Reinstala todo
dotfiles install
```

---

📖 Ver más: `GUIA_RAPIDA.md`
