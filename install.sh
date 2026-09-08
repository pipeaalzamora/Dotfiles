#!/usr/bin/env bash
# Instalador principal de Dotfiles - Arch Linux / EndeavourOS
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ask_yes_no() {
    local answer
    read -r -p "$1 [S/n]: " answer
    [[ -z "$answer" || "$answer" =~ ^[SsYy]$ ]]
}

install_flatpak_app() {
    local app_id="$1"
    local app_name="$2"

    if ! command -v flatpak &>/dev/null; then
        echo "📦 Instalando Flatpak para $app_name..."
        sudo pacman -S --needed --noconfirm flatpak
    fi

    if ! flatpak remotes --system 2>/dev/null | awk '{print $1}' | grep -qx 'flathub'; then
        echo "🌐 Agregando repositorio Flathub..."
        sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi

    echo "📦 Instalando $app_name desde Flathub..."
    flatpak install --system --noninteractive flathub "$app_id"
}

install_packages() {
    echo "📦 Instalando dependencias base, Ark y formatos comprimidos..."
    sudo pacman -Syu --needed --noconfirm \
        git curl wget \
        ark zip unzip unrar p7zip tar gzip bzip2 xz zstd lrzip lzop
}

link_config() {
    local source="$1" target="$2"
    mkdir -p "$(dirname "$target")"
    if [ -L "$target" ] && [ "$(readlink -f "$target" 2>/dev/null || true)" = "$(readlink -f "$source")" ]; then
        return 0
    fi
    rm -rf "$target"
    ln -s "$source" "$target"
}

install_packages

for file in .zshrc .zprofile .gitconfig; do
    [ -e "$DOTFILES_DIR/$file" ] && link_config "$DOTFILES_DIR/$file" "$HOME/$file"
done

for item in kitty dolphinrc kdeglobals kglobalshortcutsrc kwinrc gtk-3.0 gtk-4.0 Kvantum; do
    [ -e "$DOTFILES_DIR/.config/$item" ] && link_config "$DOTFILES_DIR/.config/$item" "$HOME/.config/$item"
done

chmod +x "$DOTFILES_DIR/scripts/"*.sh 2>/dev/null || true

if ask_yes_no "¿Aplicar ahora el perfil KDE/Dolphin Catppuccin Mocha Yellow (negro y naranjo)?"; then
    "$DOTFILES_DIR/scripts/setup-kde.sh"
fi

echo ""
echo "── Productividad y Creación ──"
if ask_yes_no "¿Instalar Joplin (notas Markdown, tareas y sincronización cifrada)?"; then
    install_flatpak_app "net.cozic.joplin_desktop" "Joplin"
fi

if ask_yes_no "¿Instalar Drift (editor de video open source tipo CapCut)?"; then
    install_flatpak_app "org.cutwire.Drift" "Drift"
fi

echo "✅ Dotfiles instalados. Ark está integrado con Dolphin para Extraer y Comprimir ZIP, RAR, 7z y tar."
