# ☁️ Aliases de DevOps, Contenedores & Cloud

Esta guía documenta los atajos y herramientas interactivas configuradas para la gestión de **Docker**, **Kubernetes**, **Infraestructura como Código (IaC)** y administración de clusters.

---

## 📌 Tabla Rápida de Atajos

| Alias / Comando | Equivalente | Propósito Principal |
| :--- | :--- | :--- |
| `d` | `docker` | Comando base de Docker |
| `dc` | `docker compose` | Orquestación de múltiples contenedores |
| `dps` | `docker ps` | Listar contenedores en ejecución |
| `dimg` | `docker images` | Listar imágenes descargadas en local |
| `dlogs` | `docker logs -f` | Seguir el log de un contenedor en tiempo real |
| `dprune` | `docker system prune -af --volumes` | Limpieza profunda de Docker (imágenes, volúmenes huérfanos) |
| `ld` | `lazydocker` | TUI visual completa para Docker en terminal |
| `k` | `kubectl` | CLI principal de Kubernetes |
| `kgp` | `kubectl get pods` | Listar pods en el namespace actual |
| `kgs` | `kubectl get svc` | Listar servicios y puertos expuestos |
| `kgd` | `kubectl get deployments` | Listar despliegues de la aplicación |
| `klogs` | `kubectl logs -f` | Seguir logs de un pod en tiempo real |
| `kexec` | `kubectl exec -it` | Abrir terminal interactiva dentro de un contenedor en un pod |
| `kns` | `kubens` | Cambiar interactivamente de namespace en K8s |
| `kctx` | `kubectx` | Cambiar interactivamente de cluster o contexto K8s |
| `k9s` | `k9s` | Consola TUI interactiva para clusters Kubernetes |
| `tf` | `terraform` | CLI de Terraform para IaC |
| `tfp` | `terraform plan` | Generar y revisar el plan de infraestructura |
| `tfa` | `terraform apply` | Aplicar cambios de infraestructura en el cloud |

---

## 🔍 Detalle y Ejemplos Prácticos

### 1. Docker y Docker Compose (`d`, `dc`, `dlogs`, `dprune`)
En Ubuntu, Docker Compose v2 está integrado como subcomando nativo.

* **Levantar un stack de servicios (ej. PostgreSQL + Redis + Backend):**
  ```bash
  dc up -d
  ```
* **Ver logs de un contenedor específico:**
  ```bash
  dlogs mi-api-backend
  ```
* **Detener y limpiar los contenedores del proyecto:**
  ```bash
  dc down
  ```
* **Limpieza radical de disco con `dprune`:**
  ```bash
  dprune
  ```
  *Recomendación:* Ejecuta `dprune` semanalmente o cuando tu disco se llene. Elimina imágenes sin etiqueta, capas intermedias de build y volúmenes no asociados a ningún contenedor activo.

---

### 2. `ld` — Lazydocker (Administración Visual en Terminal)
* **Comando:** `lazydocker`
* **Ejemplo:**
  ```bash
  ld
  ```
* **Qué permite hacer:**
  - Ver todos los contenedores, imágenes y volúmenes con gráficos de CPU y RAM por contenedor en tiempo real.
  - Reiniciar, pausar, ver logs y entrar a la shell de cualquier contenedor con una sola tecla.
  - Inspeccionar variables de entorno y mapeos de puertos al instante.
* **Recomendación:** Deja de escribir `docker logs <id>` o `docker inspect`; `ld` te ahorra minutos valiosos en cada sesión de desarrollo.

---

### 3. Kubernetes con `k` y atajos clave
* **Listar pods con detalles y nodos:**
  ```bash
  kgp
  kgp -A               # En todos los namespaces
  kgp -w               # Modo watch (monitorear creación/muerte de pods)
  ```
* **Revisar servicios y URLs internas:**
  ```bash
  kgs
  ```
* **Entrar a una shell interactiva dentro de un pod:**
  ```bash
  kexec mi-pod-xyz -- /bin/bash
  # o con sh si el contenedor es liviano (Alpine):
  kexec mi-pod-xyz -- /bin/sh
  ```
* **Seguir logs de un pod en tiempo real:**
  ```bash
  klogs mi-pod-xyz
  ```

---

### 4. `kns` y `kctx` — Cambio Rápido de Contexto y Namespace
* **Cambiar de namespace sin flags repetitivos:**
  ```bash
  kns production
  # A partir de este momento, todos los comandos 'k' operarán sobre el namespace 'production'
  ```
* **Volver al namespace anterior:**
  ```bash
  kns -
  ```
* **Cambiar de cluster o entorno cloud:**
  ```bash
  kctx staging-cluster
  ```
* **Recomendación:** Imprescindible para evitar escribir `--namespace=...` o cometer errores aplicando configuraciones en el entorno equivocado.

---

### 5. `k9s` — El Navegador Interactivo de Kubernetes
* **Comando:** `k9s`
* **Ejemplo:**
  ```bash
  k9s
  ```
* **Qué permite hacer:**
  - Navegar entre Pods, Deployments, ConfigMaps, Secrets, Ingresses y Nodos con filtros de búsqueda rápida (`/`).
  - Ver logs con auto-scroll (`l`), describir recursos (`d`), reiniciar pods (`Ctrl+D`) o abrir shells (`s`).
  - Inspeccionar el uso real de CPU/RAM de los pods gracias a Metrics Server.
* **Recomendación:** La herramienta más productiva para cualquier ingeniero DevOps o SRE que interactúe con Kubernetes diariamente.

---

### 6. Terraform / OpenTofu (`tf`, `tfp`, `tfa`)
* **Validar y previsualizar cambios:**
  ```bash
  tfp
  ```
* **Aplicar cambios en la nube:**
  ```bash
  tfa
  ```
* **Recomendación:** Ejecuta siempre `tfp` antes de `tfa` para revisar detalladamente qué recursos se crearán, modificarán o destruirán en AWS/GCP/Azure.
