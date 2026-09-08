# ⚡ Pipe's Dotfiles


Este repositorio centraliza mis configuraciones personales, utilidades CLI y scripts de aprovisionamiento para estaciones de trabajo orientadas al desarrollo full-stack, DevOps y alto rendimiento en terminal.

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
