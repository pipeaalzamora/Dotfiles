# 🐧 Dotfiles & Environment Setup

[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Unix-blue?style=flat-square)]()
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh-green?style=flat-square)]()
[![Status](https://img.shields.io/badge/Status-Activo%20%7C%20Optimizado-orange?style=flat-square)]()

## 📌 Descripción del Proyecto

Este repositorio contiene mis configuraciones personales (**dotfiles**) y scripts de automatización para entornos de desarrollo basados en **Linux y Unix**. Está diseñado para garantizar la portabilidad, la velocidad de ejecución y un flujo de trabajo altamente optimizado en la terminal, ideal para arquitecturas cloud, contenedores y desarrollo backend/full-stack.

---

## 🛠️ Componentes y Herramientas del Entorno

### 💻 Shell & Terminal:
* **Shell Principal:** Configuración avanzada para **Zsh / Bash** con un prompt limpio y eficiente.
* **Aliases de Productividad:** Atajos personalizados para control de versiones (Git), gestión de contenedores (Docker / Docker Compose) y navegación rápida de directorios.
* **Plugins & Utilidades:** Integración con herramientas orientadas a maximizar la eficiencia diaria en la línea de comandos.

### ⚙️ Configuraciones Clave:
* **Git Config:** Configuraciones globales optimizadas, manejo de credenciales y alias personalizados para flujos de trabajo ágiles.
* **Editores y Entornos:** Ajustes modulares para editores de texto y entornos livianos de terminal.
* **Automatización Linux:** Scripts orientados a la administración avanzada de sistemas operativos Linux (Ubuntu, Debian, CentOS)[cite: 2].

---

## 📂 Estructura del Repositorio

```text
├── .config/            # Configuraciones de aplicaciones (Neovim, Tmux, etc.)
├── bash/               # Configuración y scripts para Bash
├── zsh/                # Configuración de Zsh, prompts y plugins
├── git/                # Archivos de configuración global de Git (.gitconfig)
├── scripts/            # Scripts de automatización e instalación de paquetes
└── install.sh          # Script principal de despliegue y enlaces simbólicos

🚀 Pasos de Instalación:

    Clona el repositorio en tu directorio home:
    Bash

    git clone [https://github.com/pipeaalzamora/Dotfiles.git](https://github.com/pipeaalzamora/Dotfiles.git) ~/.dotfiles
    cd ~/.dotfiles

    Otorga permisos de ejecución al script de despliegue:
    Bash

    chmod +x install.sh

    Ejecuta el script de instalación:(Este script se encarga de crear los enlaces simbólicos o symlinks desde este directorio hacia tu $HOME, respaldando configuraciones previas si existen).
    Bash

    ./install.sh

    Recarga la configuración de tu terminal:
    Bash

    source ~/.zshrc   # O source ~/.bashrc si utilizas Bash


