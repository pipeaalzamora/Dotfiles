# 🌐 Aliases de Desarrollo Fullstack

Esta guía documenta los atajos y utilidades diseñadas para acelerar el desarrollo diario en el frontend, backend, APIs y bases de datos.

---

## 📌 Tabla Rápida de Atajos

| Alias / Función | Comando Equivalente | Área / Propósito |
| :--- | :--- | :--- |
| `pn` | `pnpm` | Gestor de paquetes rápido y eficiente en disco |
| `pni` | `pnpm install` | Instalar dependencias del proyecto |
| `pnd` | `pnpm dev` | Iniciar servidor de desarrollo (Next.js, Vite, Nest) |
| `pnb` | `pnpm build` | Compilar proyecto para producción |
| `pnx` | `pnpm dlx` | Ejecutar binario temporal sin instalarlo |
| `b` | `bun` | Runtime ultra-rápido de JavaScript/TypeScript |
| `bd` | `bun dev` | Iniciar dev server con Bun |
| `bx` | `bunx` | Ejecutor de paquetes de Bun (equivalente a npx) |
| `ni` | `npm install` | Instalar paquetes vía NPM tradicional |
| `nr` | `npm run` | Ejecutar scripts del package.json con NPM |
| `pg` | `psql` | Cliente interactivo de PostgreSQL |
| `rcli` | `redis-cli` | Cliente interactivo para Redis / caché |
| `sq` | `sqlite3` | Cliente de bases de datos SQLite |
| `http` | `httpie` | Cliente CLI moderno para probar APIs REST |
| `port <num>` | Función | Identificar qué proceso escucha en un puerto |
| `ports` | `ss -tulanp` | Listar todos los puertos abiertos en el sistema |
| `serve` | `python3 -m http.server` | Servir archivos estáticos en HTTP puerto 8000 |

---

## 🔍 Detalle y Ejemplos Prácticos

### 1. Flujo PNPM (`pn`, `pni`, `pnd`, `pnb`, `pnx`)
PNPM ahorra gigabytes de espacio mediante enlaces duros y es el estándar moderno en monorrepos y aplicaciones Fullstack.

* **Iniciar un proyecto y levantar dev server:**
  ```bash
  # Clonar un repositorio Next.js o Vite
  pni        # Instala todas las dependencias a máxima velocidad
  pnd        # Levanta el servidor local en http://localhost:3000
  ```
* **Compilar para producción:**
  ```bash
  pnb        # Ejecuta el build optimizado
  ```
* **Ejecutar herramientas sin instalarlas globalmente:**
  ```bash
  pnx create-next-app@latest mi-app
  pnx prisma studio
  ```
* **Recomendación:** Usa siempre PNPM en lugar de NPM para evitar duplicar carpetas `node_modules` en tu disco.

---

### 2. Flujo Bun (`b`, `bd`, `bx`)
Bun es ideal para scripts de servidor, APIs ultrarrápidas y reemplazo directo de Node en tareas intensivas.

* **Ejecutar archivos TypeScript directamente sin compilar:**
  ```bash
  b run server.ts
  ```
* **Iniciar proyectos configurados con Bun:**
  ```bash
  bd         # Ejecuta 'bun dev'
  ```
* **Ejecución rápida:**
  ```bash
  bx prettier --write .
  ```
* **Recomendación:** Úsalo cuando necesites arrancar servidores en milisegundos o correr scripts de backend en TypeScript sin configurar `ts-node` ni `tsc`.

---

### 3. Diagnóstico de Puertos y Procesos: `port <número>`
¿Cuántas veces un servidor no arranca porque el puerto `3000`, `5000` o `8080` ya está en uso?

* **Ejemplo práctico:**
  ```bash
  port 3000
  ```
* **Salida esperada:**
  Muestra el PID y nombre del proceso (por ejemplo `node` o `docker-proxy`) que está bloqueando el puerto.
* **Para liberar el puerto:**
  ```bash
  kill -9 <PID>
  ```
* **Recomendación:** Antes de cambiar de puerto en tus archivos `.env`, usa `port <puerto>` para auditar y terminar procesos huérfanos.

---

### 4. Conexión a Bases de Datos: `pg`, `rcli`, `sq`
* **PostgreSQL (`pg`):**
  ```bash
  pg -U postgres -h localhost -d app_db
  ```
* **Redis (`rcli`):**
  ```bash
  rcli ping
  # Responde: PONG
  rcli monitor
  ```
* **SQLite (`sq`):**
  ```bash
  sq dev.db
  ```
* **Recomendación:** Evita abrir interfaces pesadas solo para verificar tablas o claves en Redis; estos clientes CLI nativos responden al instante.

---

### 5. Pruebas de API REST: `http` (HTTPie)
HTTPie es una alternativa legible y con colores a `curl` para interactuar con APIs REST.

* **Petición GET:**
  ```bash
  http GET localhost:3000/api/users
  ```
* **Petición POST con JSON automático:**
  ```bash
  http POST localhost:3000/api/login email=user@demo.com password=secret
  ```
* **Enviar Headers:**
  ```bash
  http GET localhost:3000/api/profile "Authorization: Bearer mi_token"
  ```
* **Recomendación:** Ideal para depurar endpoints durante el desarrollo backend sin depender de Postman o navegadores.

---

### 6. Servidor Estático Rápido: `serve`
* **Comando:** `python3 -m http.server`
* **Ejemplo:**
  ```bash
  cd ./dist
  serve 8080
  ```
* **Recomendación:** Muy útil para previsualizar compilaciones estáticas de React/Vue/Astro o compartir archivos en tu red local.
