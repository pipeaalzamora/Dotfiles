#!/usr/bin/env bash
# ============================================================
# Configuración y optimización para GPU AMD (GCN 3.0 / Fiji)
# ============================================================
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}==>${NC} Verificando hardware gráfico..."

if lspci | grep -qiE "fiji|r9 fury|radeon R9 Fury"; then
    echo -e "${GREEN}==>${NC} GPU AMD R9 Fury (Fiji) detectada."
    if [ -f /etc/default/grub ]; then
        if ! grep -q "amdgpu.cik_support=1" /etc/default/grub; then
            echo -e "${YELLOW}==>${NC} Aplicando soporte amdgpu en GRUB para Vulkan y Wayland..."
            sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="radeon.cik_support=0 amdgpu.cik_support=1 /' /etc/default/grub
            sudo grub-mkconfig -o /boot/grub/grub.cfg
            echo -e "${GREEN}==>${NC} GRUB actualizado exitosamente."
        else
            echo -e "${GREEN}==>${NC} Parámetros amdgpu ya configurados en GRUB."
        fi
    fi
else
    echo -e "${YELLOW}==>${NC} No se detectó GPU AMD Fiji en este equipo."
fi
