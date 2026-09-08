#!/usr/bin/env bash
# ============================================================
# Instalador de soporte de archivos comprimidos para KDE/Dolphin
# Instala Ark y motores ZIP, RAR, 7z, tar, gzip, bzip2, xz y zstd
# ============================================================
set -euo pipefail

if ! command -v pacman &>/dev/null; then
    echo "Este script requiere Arch Linux / EndeavourOS."
    exit 1
fi

echo "📦 Instalando Ark y soporte para archivos comprimidos..."
sudo pacman -S --needed --noconfirm \
    ark \
    unzip \
    zip \
    unrar \
    p7zip \
    tar \
    gzip \
    bzip2 \
    xz \
    zstd \
    lrzip \
    lzop

echo "✅ Ark configurado para Dolphin."
echo "   Soporte disponible: ZIP, RAR, 7z, tar, tar.gz, tar.bz2, tar.xz, zst, lrz y lzo."
echo "   En Dolphin: clic derecho sobre un archivo → Extraer / Comprimir."
