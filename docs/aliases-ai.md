# 🤖 Aliases de AI Engineering & Data

Esta guía documenta los atajos y herramientas diseñadas para flujos de trabajo de **Inteligencia Artificial**, pipelines de **Machine Learning**, ejecución local de **LLMs** y gestión de entornos Python de alto rendimiento.

---

## 📌 Tabla Rápida de Atajos

| Alias / Comando | Equivalente | Propósito Principal |
| :--- | :--- | :--- |
| `uvr` | `uv run` | Ejecutar scripts o herramientas en entornos aislados con uv |
| `uva` | `uv add` | Añadir dependencias a un proyecto Python (bloqueo automático) |
| `uvp` | `uv pip` | Comandos compatibles con pip pero 10x a 100x más veloces |
| `uvs` | `uv sync` | Sincronizar el entorno virtual con el lockfile `uv.lock` |
| `py` | `python3` | Intérprete interactivo de Python 3 |
| `pip` | `pip3` | Gestor estándar de paquetes de Python |
| `ol` | `ollama` | Motor de ejecución local de Modelos de Lenguaje (LLMs) |
| `olr` | `ollama run` | Descargar y chatear con un modelo localmente |
| `oll` | `ollama list` | Listar modelos descargados en el sistema |
| `olp` | `ollama pull` | Descargar pesos de un modelo en segundo plano |
| `nv` | `watch -n 1 nvidia-smi` | Monitoreo continuo de GPU en tiempo real (VRAM, Watts, %) |

---

## 🔍 Detalle y Ejemplos Prácticos

### 1. Ecosistema [uv](https://astral.sh/uv) (Astral)
`uv` es el gestor moderno de Python escrito en Rust. Resuelve dependencias y crea entornos virtuales en milisegundos, reemplazando a `pip`, `poetry` y `virtualenv`.

#### A. Inicializar un Proyecto de IA:
```bash
# Crear un proyecto con uv
uv init mi-agente-ia
cd mi-agente-ia

# Añadir librerías de IA y LangChain (se instalan al instante)
uva langchain langchain-community langchain-openai chromadb
```

#### B. Ejecutar scripts sin activar manualmente el venv (`uvr`):
```bash
uvr main.py
```
*`uv run` detecta el entorno virtual automáticamente y ejecuta el código en él sin necesidad de hacer `source .venv/bin/activate`.*

#### C. Probar herramientas o scripts con dependencias al vuelo:
```bash
# Ejecutar un script que requiere pandas y duckdb sin instalarlo en tu entorno global
uv run --with pandas --with duckdb python -c "import duckdb; print(duckdb.__version__)"
```

#### D. Instalar en entornos existentes (`uvp`):
```bash
# Si tienes un virtualenv tradicional activo:
uvp install torch transformers datasets accelerate
```
*`uv pip` instala PyTorch y librerías masivas de Hugging Face en una fracción del tiempo de pip tradicional.*

---

### 2. Ecosistema [Ollama](https://ollama.com) (`ol`, `olr`, `oll`, `olp`)
Ollama permite ejecutar modelos de lenguaje de código abierto de manera 100% local, privada y optimizada en GPU o CPU.

#### A. Descargar y chatear con un modelo (`olr`):
```bash
# Probar Llama 3.2 o DeepSeek R1 localmente
olr llama3.2
olr deepseek-r1:8b
olr qwen2.5-coder:7b
```

#### B. Listar modelos disponibles en tu disco (`oll`):
```bash
oll
# Muestra: NAME, ID, SIZE, MODIFIED
```

#### C. Descargar modelos pesados sin bloquear la terminal (`olp`):
```bash
olp mistral
olp phi3
```

#### D. Consumir la API de Ollama desde tu código:
Ollama expone automáticamente un servidor compatible con la API de OpenAI en `http://localhost:11434/v1`:
```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")
response = client.chat.completions.create(
    model="llama3.2",
    messages=[{"role": "user", "content": "¿Cómo optimizar un pipeline RAG?"}]
)
print(response.choices[0].message.content)
```

---

### 3. Monitoreo de GPU en Tiempo Real: `nv`
Si cuentas con una tarjeta gráfica NVIDIA (compatible con CUDA), el alias `nv` ejecuta:
```bash
nv
```
* **Qué hace:** Ejecuta `watch -n 1 nvidia-smi`, refrescando cada segundo el uso de VRAM (memoria de video), porcentaje de computo CUDA, temperatura y consumo energético.
* **Recomendación:** Mantén una pequeña ventana o panel de terminal con `nv` abierto mientras realizas fine-tuning, inferencias de modelos o pruebas locales con Ollama/vLLM para vigilar si te acercas al límite de VRAM (*Out Of Memory - OOM*).

---

### 4. Gestión Segura de Credenciales y API Keys
Para no exponer credenciales en repositorios Git, tus dotfiles leen automáticamente el archivo privado `~/.zshrc.local`.

Copia la plantilla y define tus claves:
```bash
cp ~/.dotfiles_backup/.. ~/.zshrc.local   # O edita ~/.zshrc.local directamente
nano ~/.zshrc.local
```

Configuración recomendada:
```bash
# Modelos en la nube
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GEMINI_API_KEY="..."
export GROQ_API_KEY="gsk_..."
export HUGGINGFACE_TOKEN="hf_..."

# Servidor local de Ollama (si corre en otra IP o contenedor)
export OLLAMA_HOST="http://localhost:11434"
```
*Al recargar tu terminal con `exec zsh`, todas tus herramientas de IA tendrán acceso inmediato a estas variables de entorno de forma segura.*
