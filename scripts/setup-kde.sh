#!/bin/bash
# ============================================================
# Script de Automatización y Personalización para KDE Plasma
# Repositorio: pipeaalzamora/Dotfiles
# ============================================================

set -e

# Rutas principales
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config"

echo "🎨 Iniciando configuración automatizada de KDE Plasma..."

# ------------------------------------------------------------
# PASO 1: Instalación de paquetes visuales y motores de temas
# Explicación: Instala Kvantum (para transparencias Qt) y los 
# paquetes de temas Catppuccin Mocha desde los repositorios y AUR.
# ------------------------------------------------------------
echo "📦 [Paso 1/4] Instalando Kvantum y temas de Catppuccin..."

if command -v yay &>/dev/null; then
    yay -S --needed --noconfirm \
        kvantum \
        kvantum-theme-catppuccin-git \
        catppuccin-kde-theme-mocha-git \
        papirus-icon-theme
else
    echo "⚠️  AUR helper (yay) no detectado. Instala los paquetes manualmente."
fi

# ------------------------------------------------------------
# PASO 2: Creación de Enlaces Simbólicos (Symlinks)
# Explicación: Copia/Vincula los archivos guardados en el repo 
# directamente a ~/.config/ para sobreescribir los valores por defecto.
# ------------------------------------------------------------
echo "🔗 [Paso 2/4] Enlazando archivos de configuración..."

mkdir -p "$CONFIG_DIR"

KDE_CONFIGS=("kdeglobals" "kglobalshortcutsrc" "kwinrc")

for config in "${KDE_CONFIGS[@]}"; do
    if [ -f "$DOTFILES_DIR/.config/$config" ]; then
        # Crear copia de respaldo si el archivo original existe
        [ -f "$CONFIG_DIR/$config" ] && cp "$CONFIG_DIR/$config" "$CONFIG_DIR/$config.bak"
        ln -sf "$DOTFILES_DIR/.config/$config" "$CONFIG_DIR/$config"
        echo "   -> Enlazado: ~/.config/$config"
    fi
done

# Enlazar carpeta de Kvantum
if [ -d "$DOTFILES_DIR/.config/Kvantum" ]; then
    rm -rf "$CONFIG_DIR/Kvantum"
    ln -sf "$DOTFILES_DIR/.config/Kvantum" "$CONFIG_DIR/Kvantum"
    echo "   -> Enlazada carpeta: ~/.config/Kvantum"
fi

# ------------------------------------------------------------
# PASO 3: Aplicación de variables de entorno y temas globales
# Explicación: Fuerza a Qt a utilizar Kvantum como motor gráfico 
# y aplica el esquema global mediante la utilidad nativa de Plasma.
# ------------------------------------------------------------
echo "⚙️  [Paso 3/4] Aplicando temas en el sistema..."

# Definir Kvantum como el motor QT en las variables del usuario
if ! grep -q "QT_STYLE_OVERRIDE=kvantum" "$HOME/.pam_environment" 2>/dev/null; then
    echo "QT_STYLE_OVERRIDE DEFAULT=kvantum" >> "$HOME/.pam_environment"
fi

# Aplicar el tema global a través del CLI de Plasma
if command -v plasma-apply-lookandfeel &>/dev/null; then
    plasma-apply-lookandfeel -a Catppuccin-Mocha-Dark || true
fi

# Configurar el tema activo dentro de Kvantum
if command -v kvantummanager &>/dev/null; then
    kvantummanager --set Catppuccin-Mocha-Dark || true
fi

# ------------------------------------------------------------
# PASO 4: Recargar el entorno gráfico
# Explicación: Reinicia el panel (plasmashell) y KWin para 
# refrescar las sombras, bordes de ventanas y atajos sin reiniciar el sistema.
# ------------------------------------------------------------
echo "🔄 [Paso 4/4] Recargando componentes visuales de KDE..."

if pgrep -x "plasmashell" > /dev/null; then
    kquitapp6 plasmashell 2>/dev/null || true
    kstart plasmashell >/dev/null 2>&1 &
    echo "   -> Plasmashell reiniciado correctamente."
fi

echo "✨ ¡Entorno de KDE Plasma configurado con éxito!"