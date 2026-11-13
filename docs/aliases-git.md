# 🌿 Aliases de Git y Control de Versiones

Esta guía documenta los atajos y funciones configuradas para optimizar el flujo de trabajo diario con **Git** y **Lazygit**.

---

## 📌 Tabla Rápida de Atajos

| Alias / Función | Comando Equivalente | Propósito Principal |
| :--- | :--- | :--- |
| `gs` | `git status` | Ver estado de archivos modificados |
| `ga` | `git add` | Preparar archivos específicos al stage |
| `gaa` | `git add .` | Preparar todos los cambios del directorio |
| `gc` | `git commit -m` | Crear commit con mensaje en línea |
| `gca` | `git commit -am` | Preparar y commitear archivos ya rastreados |
| `gp` | `git push` | Subir commits al repositorio remoto |
| `gpl` | `git pull` | Descargar cambios del repositorio remoto |
| `gd` | `git diff` | Ver diferencias de código sin commitear |
| `gb` | `git branch` | Listar ramas locales |
| `gco` | `git checkout` | Cambiar de rama o restaurar archivo |
| `gcb` | `git checkout -b` | Crear y cambiar a una nueva rama |
| `glog` | `git log --oneline --graph` | Historial visual compacto de commits |
| `lg` | `lazygit` | Interfaz visual (TUI) completa en terminal |
| `delta` | `git-delta` | Paginador con resaltado de sintaxis para diffs |
| `fzf-git-branch` | `Ctrl + B` | Selector interactivo difuso de ramas con Fzf |
| `newproject` | Función interactiva | Inicializar carpeta, git y estructura de proyecto |

---

## 🔍 Detalle y Ejemplos Prácticos

### 1. `gs` — Consultar Estado
* **Comando:** `git status`
* **Ejemplo:**
  ```bash
  gs
  ```
* **Recomendación:** Ejecútalo antes de añadir cambios para confirmar qué archivos fueron editados o creados.

---

### 2. `gaa` y `gc` — Ciclo de Commit Rápido
* **Comandos:** `git add .` y `git commit -m "<mensaje>"`
* **Ejemplo:**
  ```bash
  gaa
  gc "feat: agregar endpoint de autenticación JWT"
  ```
* **Recomendación:** Úsalo cuando hayas revisado tus cambios y desees registrar el trabajo de forma inmediata con un mensaje convencional (Conventional Commits).

---

### 3. `gca` — Commit Directo de Archivos Modificados
* **Comando:** `git commit -am "<mensaje>"`
* **Ejemplo:**
  ```bash
  gca "fix: corregir tipografía en vista de perfil"
  ```
* **Recomendación:** Ideal para cambios rápidos en archivos ya versionados sin necesidad de llamar a `git add` previamente. No incluye archivos nuevos sin rastrear.

---

### 4. `gcb` y `gco` — Creación y Cambio de Ramas
* **Comandos:** `git checkout -b <rama>` y `git checkout <rama>`
* **Ejemplo:**
  ```bash
  # Crear y entrar a una rama de feature
  gcb feature/llm-streaming

  # Volver a la rama principal
  gco main
  ```
* **Recomendación:** Crea siempre ramas independientes para cada tarea o corrección de bugs antes de escribir código.

---

### 5. `fzf-git-branch` (`Ctrl + B`) — Cambio Interactivo de Rama
* **Comando:** Búsqueda interactiva con Fzf + checkout automático.
* **Ejemplo:**
  1. Presiona `Ctrl + B` en tu terminal.
  2. Escribe parte del nombre de la rama (ej. `streaming`).
  3. Presiona `Enter` y te cambiará a dicha rama inmediatamente.
* **Recomendación:** Esencial en repositorios grandes con decenas de ramas remotas y locales.

---

### 6. `glog` — Árbol Visual de Commits
* **Comando:** `git log --oneline --graph`
* **Ejemplo:**
  ```bash
  glog
  ```
* **Recomendación:** Permite inspeccionar rápidamente bifurcaciones, merges y los últimos commits sin saturar la terminal.

---

### 7. `lg` — Lazygit (TUI Definitiva de Git)
* **Comando:** `lazygit`
* **Ejemplo:**
  ```bash
  lg
  ```
* **Recomendación:** Úsalo para resolver conflictos de merge complejos, hacer commits parciales por líneas (*staging hunk-by-hunk*), rebase interactivo y visualización de stash sin salir de la terminal.

---

### 8. `newproject <nombre>` — Andamiaje de Nuevos Proyectos
* **Comando:** Función personalizada que crea la carpeta, directorios `src/` y `docs/`, archivo `.gitignore` e inicializa el repositorio Git.
* **Ejemplo:**
  ```bash
  newproject agente-rag
  # Crea la carpeta ~/agente-rag con src, docs, .gitignore y git init
  ```
* **Recomendación:** Ideal para prototipar microservicios, experimentos de IA o scripts sin repetir pasos manuales.
