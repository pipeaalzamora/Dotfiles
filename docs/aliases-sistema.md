# ⚙️ Aliases de Sistema, Navegación y Productividad

Esta guía documenta los atajos de terminal, navegación difusa con **Fzf**, utilidades de inspección de hardware, visualizadores de archivos y comandos del sistema.

---

## 📌 Tabla Rápida de Atajos

| Alias / Función | Comando Equivalente | Propósito Principal |
| :--- | :--- | :--- |
| `ls` | `lsd` | Listado moderno de archivos con iconos y colores |
| `la` | `lsd -A` | Listar todos los archivos incluyendo ocultos |
| `ll` | `lsd -lah` | Listado detallado con permisos, tamaños legibles y fechas |
| `l` | `lsd -CF` | Listado rápido en columnas |
| `lh` | `lsd -lh` | Listado detallado sin archivos ocultos |
| `j <dir>` | `z <dir>` | Salto inteligente a directorios frecuentes (Zoxide) |
| `cat` / `bat` | `$BAT_CMD` | Visualizador con resaltado de sintaxis y números de línea |
| `fd` | `$FD_CMD` | Búsqueda ultra-rápida de archivos (reemplazo de find) |
| `bp` / `top` | `btop` | Monitor interactivo de recursos del sistema |
| `df` | `df -h` | Espacio libre en discos y particiones |
| `free` | `free -h` | Memoria RAM y Swap usada y disponible |
| `du` | `dust` (o `du -h`) | Visualizador de carpetas que más espacio ocupan en disco |
| `ps` | `procs` | Listado enriquecido de procesos en ejecución |
| `cls` / `c` | `clear` | Limpiar pantalla de la terminal |
| `myip` | `curl -s ifconfig.me` | Ver tu dirección IP pública actual |
| `ports` | `ss -tulanp` | Listar sockets y puertos en escucha en el sistema |
| `port <num>` | Función | Identificar el proceso que escucha en un puerto |
| `tree` | `tree -C` | Árbol de directorios con colores |
| `vim` / `vi` | `nvim` | Editor Neovim |
| `json` | `fx` | Visor y manipulador interactivo de archivos JSON |
| `y` | Función | Abrir gestor de archivos **Yazi** y sincronizar el directorio al salir |
| `mkcd <dir>` | Función | Crear directorio y entrar inmediatamente a él |
| `ff <nombre>` | Función | Buscar archivo por nombre con `fd` |
| `fif <texto>` | Función | Buscar texto dentro de archivos con `ripgrep` |
| `backup <file>` | Función | Crear copia rápida con timestamp de un archivo |
| `sysinfo` | Función | Resumen rápido de specs del sistema (RAM, disco, uptime) |
| `weather [ciudad]`| Función | Pronóstico del tiempo en terminal |
| `cheat <tema>` | Función | Hoja de trucos interactiva de cualquier comando |
| `Ctrl + F` | `fzf-file` | Búsqueda difusa de archivo con vista previa en vivo |
| `Ctrl + G` | `fzf-cd` | Búsqueda difusa de carpeta y cambio de directorio |

---

## 🔍 Detalle y Ejemplos Prácticos

### 1. Navegación Inteligente: `j` (Zoxide) y `lsd`
Zoxide recuerda los directorios que visitas con frecuencia y calcula el mejor destino.

* **Saltar a cualquier proyecto sin escribir la ruta completa:**
  ```bash
  # En lugar de escribir: cd ~/Documents/Proyectos/Backend/mi-api
  j mi-api
  j dotfiles
  ```
* **Listado enriquecido con `ls` y `ll`:**
  ```bash
  ls      # Muestra iconos por tipo de archivo (.ts, .py, .dockerfile, etc.)
  ll      # Muestra permisos, tamaño y fecha legible
  ```
* **Recomendación:** Deja de usar `cd ../../../` para moverte entre repositorios; `j` te lleva a cualquier proyecto en una sola palabra.

---

### 2. Atajos Difusos con Fzf: `Ctrl + F` y `Ctrl + G`
* **`Ctrl + F` (Buscar archivos con preview):**
  Presiona `Ctrl + F` en cualquier carpeta. Aparecerá un buscador difuso interactivo. Mientras navegas con las flechas, verás el contenido del archivo resaltado con `bat` en el panel lateral. Presiona `Enter` para autocompletar la ruta.
* **`Ctrl + G` (Buscar carpetas):**
  Presiona `Ctrl + G`, escribe parte del nombre de una subcarpeta profunda y presiona `Enter` para saltar a ella de inmediato.

---

### 3. Navegador de Terminal: `y` (Yazi)
Yazi es un explorador de archivos para terminal extremadamente veloz escrito en Rust.

* **Ejemplo:**
  ```bash
  y
  ```
* **Comportamiento especial del alias:**
  Cuando sales de Yazi presionando `q`, la terminal se posiciona automáticamente en el último directorio en el que navegaste dentro de Yazi.
* **Recomendación:** Muy cómodo para explorar proyectos con estructuras de carpetas profundas sin tener que escribir comandos `cd` repetidamente.

---

### 4. Búsqueda Instantánea: `ff` y `fif`
* **Buscar archivos por nombre (`ff`):**
  ```bash
  ff docker-compose.yml
  ff "*.test.ts"
  ```
* **Buscar texto dentro de código (`fif` - ripgrep):**
  ```bash
  fif "DATABASE_URL"
  fif "createAgent"
  ```
  *Busca en todo el proyecto ignorando automáticamente `.git` y respetando `.gitignore` a velocidad extrema.*

---

### 5. Copia de Seguridad Instantánea: `backup <archivo>`
* **Ejemplo:**
  ```bash
  backup nginx.conf
  # Crea inmediatamente: nginx.conf.backup.20261113_200500
  ```
* **Recomendación:** Úsalo antes de modificar archivos de configuración críticos del sistema o de producción (`.env`, `docker-compose.yml`, configs en `/etc`).

---

### 6. Inspección de Recursos: `bp` (Btop) y `du` (Dust)
* **Monitor de hardware `bp`:**
  ```bash
  bp
  ```
  *Muestra interfaz gráfica en terminal con uso de núcleos de CPU, consumo de memoria por proceso, estado de discos y tráfico de red.*
* **Auditoría de espacio en disco con `du`:**
  ```bash
  du
  ```
  *Genera un gráfico en árbol mostrando visualmente qué carpetas y archivos consumen más espacio en disco.*

---

### 7. Hojas de Trucos Rápidas: `cheat <comando>`
* **Ejemplo:**
  ```bash
  cheat tar
  cheat curl
  cheat docker
  ```
* **Qué hace:** Consulta `cheat.sh` y te muestra ejemplos concisos de los flags y opciones más usadas de cualquier comando sin tener que leer páginas man extensas.

---

### 8. Creación Rápida de Directorios: `mkcd <carpeta>`
* **Ejemplo:**
  ```bash
  mkcd servicios/auth-service/src
  # Crea la estructura completa y hace 'cd' directo a 'src'
  ```
