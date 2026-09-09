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

---

## 💡 Personalización

- **Temas & Apariencia:** Sistema Settings de KDE
- **Fondos:** `plasma-apply-wallpaperimage`
- **Git:** `dotfiles git`
- **Monitores:** KDE System Settings → Display and Monitor

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
