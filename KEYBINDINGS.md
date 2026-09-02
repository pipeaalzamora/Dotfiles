# ⌨️ Guía Completa de Atajos de Teclado (Keybindings)

> [!NOTE]
> **Aclaración sobre la tecla `Meta`:**  
> La tecla **`Meta`** corresponde a la **tecla de Inicio / tecla Windows (`⊞ Win`)** o tecla `Super` en teclados tradicionales de PC, o `Command (⌘)` en teclados Mac.

---

## 🎨 1. Personalización Visual y Temas

| Atajo de Teclado | Comando Equivalente | ¿Qué hace? |
| :--- | :--- | :--- |
| **`Meta + Shift + T`** | `theme-switch` | Abre el menú de **Rofi** para cambiar instantáneamente entre los 6 temas globales (Catppuccin Mocha, Latte, Tokyo Night, Nord, Dracula, Gruvbox). |
| **`Meta + Alt + W`** | `wall-next` | Rota aleatoriamente el fondo de pantalla actual (soporta imágenes 4K y videos animados en bucle con `mpvpaper`). |

---

## 🚀 2. Lanzadores y Herramientas del Sistema

| Atajo de Teclado | Acción | ¿Qué hace? |
| :--- | :--- | :--- |
| **`Meta + Return`** (Enter) | Lanzar Terminal | Abre la terminal acelerada por GPU **Kitty** con tema y transparencia. |
| **`Meta + P`** | `monitors` | Abre el selector de perfiles multi-monitor (solo principal, solo externo, extender, duplicar). |
| **`Meta + Space`** o **`Alt + Space`** | KRunner | Abre el buscador del sistema de KDE Plasma (búsqueda de archivos, cálculo rápido, apps). |
| **`Meta + Shift + S`** | Captura de Pantalla | Inicia la captura de pantalla con selección de área rectangular mediante **Spectacle**. |
| **`Meta + W`** | Visión General (Overview) | Muestra todas las ventanas abiertas en cuadrícula para cambiar de app rápidamente. |

---

## 🪟 3. Gestión de Ventanas y Escritorios (KWin)

| Atajo de Teclado | Acción | ¿Qué hace? |
| :--- | :--- | :--- |
| **`Meta + C`** | Cerrar Ventana | Cierra limpiamente la aplicación activa actual. |
| **`Meta + Shift + Q`** | Forzar Cierre | Mata el proceso de la ventana colgada o congelada. |
| **`Meta + F`** | Maximizar | Alterna entre maximizar o restaurar el tamaño de la ventana. |
| **`Meta + H`** | Mosaico Izquierda (Tile Left) | Ajusta la ventana a la mitad izquierda de la pantalla. |
| **`Meta + L`** | Mosaico Derecha (Tile Right) | Ajusta la ventana a la mitad derecha de la pantalla. |
| **`Meta + K`** | Mosaico Superior (Tile Up) | Ajusta la ventana a la mitad superior de la pantalla. |
| **`Meta + J`** | Mosaico Inferior (Tile Down) | Ajusta la ventana a la mitad inferior de la pantalla. |
| **`Meta + 1`** a **`Meta + 4`** | Cambiar Escritorio | Salta directamente al escritorio virtual 1, 2, 3 o 4. |

---

## 🐱 4. Terminal Kitty

| Atajo de Teclado | Acción | ¿Qué hace? |
| :--- | :--- | :--- |
| **`Ctrl + C`** | Copiar | Copia el texto seleccionado al portapapeles global del sistema. |
| **`Ctrl + V`** | Pegar | Pega el contenido del portapapeles en la consola. |
| **`Ctrl + Shift + C`** | Interrumpir Señal | Envía `SIGINT` (Ctrl+C clásico de UNIX) para detener procesos o scripts en ejecución. |
| **`Shift + T`** | Nueva Pestaña | Abre una nueva pestaña en la misma ruta del directorio actual. |
| **`Shift + W`** | Cerrar Pestaña | Cierra la pestaña activa de Kitty. |
| **`Ctrl + Shift + Derecha`** | Siguiente Pestaña | Se desplaza a la siguiente pestaña de la terminal. |
| **`Ctrl + Shift + Izquierda`**| Pestaña Anterior | Se desplaza a la pestaña previa de la terminal. |

---

## 📝 5. Editor de Código Neovim (Tecla Líder: `Espacio`)

| Modo | Atajo | Acción / Descripción |
| :---: | :--- | :--- |
| **Normal** | **`<Espacio> + f + f`** | Buscar archivos por nombre con Telescope y FZF. |
| **Normal** | **`<Espacio> + f + g`** | Buscar texto/código en todo el proyecto (Live Grep). |
| **Normal** | **`<Espacio> + f + b`** | Listar y cambiar entre buffers/archivos abiertos. |
| **Normal** | **`<Espacio> + e`** | Abrir o cerrar el explorador de archivos lateral (**Neo-tree**). |
| **Normal** | **`<Espacio> + w`** | Guardar archivo actual (`:w`). |
| **Normal** | **`<Espacio> + q`** | Cerrar panel o ventana actual (`:q`). |
| **Normal** | **`Ctrl + h / j / k / l`** | Navegar entre paneles divididos (Izquierda / Abajo / Arriba / Derecha). |
| **Visual** | **`J`** / **`K`** | Mover líneas seleccionadas hacia arriba o hacia abajo. |

---

## 📜 6. Shell Zsh, Navegación y Herramientas CLI

| Comando / Atajo | Herramienta | ¿Qué hace? |
| :--- | :--- | :--- |
| **`j <carpeta>`** | Zoxide | Salta instantáneamente a cualquier directorio frecuente por coincidencia de nombre. |
| **`Ctrl + R`** | FZF | Búsqueda difusa e interactiva en el historial de comandos ejecutados. |
| **`y`** | Yazi | Abre el explorador de archivos en terminal con preview de imágenes y videos. |
| **`lg`** | Lazygit | Abre la interfaz TUI para gestionar ramas, commits y diffs de Git. |
| **`bp`** | Btop | Monitor de recursos en tiempo real (CPU, RAM, GPU AMD, discos, red). |
| **`l` / `ll` / `la`** | LSD | Listado moderno de archivos con iconos y colores. |
| **`cat <archivo>`** | Bat | Muestra el contenido del archivo con resaltado de sintaxis y tema activo. |
| **`upd`** | Update-All | Actualiza todo el sistema en 1 paso (pacman, AUR yay, npm, rustup, pipx). |
| **`krestart`** | KDE Plasma | Reinicia limpiamente el panel y widgets mediante systemd. |
| **`monitors`** | KScreen | Selector interactivo de perfiles multi-monitor (principal, externo, extender, duplicar). |
| **`dots-export-kde`** | Dotfiles | Exporta las configuraciones activas de KDE hacia tu repositorio local. |
