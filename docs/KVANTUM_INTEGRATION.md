# Integración de Kvantum en KDE Plasma

## ¿Qué es Kvantum y cómo funciona?

### La estructura

```
Kvantum es un sistema de CAPAS:

┌─────────────────────────────────────────────────────────────┐
│                    APLICACIONES Qt                          │
│         (Kate, Dolphin, Konsole, KDE Plasma, etc)          │
└──────────────────────────────────────┬──────────────────────┘
                                       │
                    ¿Cómo me veo visual?
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────┐
│            KDE PLASMA (Application Style)                   │
│                                                              │
│  Opciones: Breeze, Oxygen, Kvantum, QtCurve, Plastique    │
│                                                              │
│  ← AQUÍ es donde seleccionas "Kvantum"                     │
└──────────────────────────────────────┬──────────────────────┘
                                       │
          ¿Qué estilo debería usar?
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   KVANTUM MANAGER                           │
│                                                              │
│  Tema seleccionado: Catppuccin-Mocha-Blue                  │
│                                                              │
│  └─ Archivos: ~/.config/Kvantum/Catppuccin-Mocha-Blue/   │
│     ├─ Catppuccin-Mocha-Blue.kvconfig (configuración)     │
│     └─ Catppuccin-Mocha-Blue.svg (gráficos SVG)           │
└──────────────────────────────────────┬──────────────────────┘
                                       │
                      Renderizar tema
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    PANTALLA VISUAL                          │
│                                                              │
│  Botones, ventanas, barras con el estilo del tema          │
└─────────────────────────────────────────────────────────────┘
```

### El flujo de configuración

```
1. INSTALAR TEMA
   └─ bash install-catppuccin-kvantum.sh
   └─ Descarga y copia archivos a ~/.config/Kvantum/

2. ACTIVAR KVANTUM (Este es el paso que faltaba)
   └─ bash enable-kvantum.sh
   └─ Configura KDE para usar Kvantum como Application Style
   └─ Modifica: ~/.config/kdeglobals → widgetStyle = "kvantum"

3. SELECCIONAR TEMA
   └─ Abre Kvantum Manager
   └─ Selecciona el tema instalado
   └─ Hace clic en "Apply"
   └─ El archivo ~/.config/Kvantum/kvantum.conf se actualiza

4. APLICAR A SISTEMA
   └─ Las aplicaciones Qt leen la configuración
   └─ Se renderizan con el tema seleccionado
```

## ¿Por qué necesitas "activar" Kvantum?

### Sin activación:
- Kvantum está instalado pero **inactivo**
- Los temas están en `~/.config/Kvantum/` pero **se ignoran**
- KDE sigue usando Breeze (el estilo por defecto)
- Kvantum Manager funciona pero los cambios **no se aplican**

### Con activación:
- KDE Plasma sabe que debe usar Kvantum
- Los temas instalados **se aplican al sistema**
- Todos los cambios en Kvantum Manager se **ven inmediatamente**
- Las aplicaciones Qt se renderizan con el tema seleccionado

## Cómo funciona la activación

### Método 1: Script automático (RECOMENDADO)

```bash
bash ~/dotfiles/scripts/enable-kvantum.sh
```

**¿Qué hace?**
- Ejecuta: `kwriteconfig5 --file ~/.config/kdeglobals --group General --key "widgetStyle" "kvantum"`
- Esto configura KDE Plasma para usar Kvantum
- Es completamente reversible

### Método 2: GUI (KDE System Settings)

1. Abre **System Settings**
2. Ve a **Appearance** (Apariencia)
3. Selecciona **Application Style** (Estilo de Aplicación)
4. En el menú desplegable, elige **Kvantum**
5. Se abrirá Kvantum Manager automáticamente
6. Selecciona un tema y aplica

### Método 3: Editar config manualmente

```bash
# Abrir archivo de configuración
nano ~/.config/kdeglobals

# Buscar la sección [General]
# Cambiar o agregar:
[General]
widgetStyle=kvantum
```

## Archivos involucrados

```
~/.config/
├── kdeglobals                    ← Configuración general de KDE
│   └─ [General] widgetStyle=kvantum
│
└── Kvantum/
    ├── kvantum.conf             ← Configuración de Kvantum
    │   └─ theme=Catppuccin-Mocha-Blue
    │
    └── Catppuccin-Mocha-Blue/   ← Tema instalado
        ├─ Catppuccin-Mocha-Blue.kvconfig
        └─ Catppuccin-Mocha-Blue.svg
```

## Diagrama de flujo completo

```
INSTALACIÓN Y ACTIVACIÓN:

┌─────────────────────────────────────┐
│  1. Ejecutar instalador de tema     │
│  bash install-catppuccin-kvantum.sh│
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  2. Archivos se copian a:           │
│  ~/.config/Kvantum/Tema/            │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  3. Ejecutar activador (IMPORTANTE) │
│  bash enable-kvantum.sh             │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  4. KDE Plasma se configura para:   │
│  widgetStyle=kvantum (en kdeglobals)│
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  5. Abrir Kvantum Manager           │
│  kvantummanager                     │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  6. Seleccionar tema y Apply        │
└────────────────┬────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  7. ¡Tema aplicado al sistema!      │
│  Todas las apps Qt lo ven           │
└─────────────────────────────────────┘
```

## Pasos recomendados para usar Catppuccin

```bash
# Paso 1: Instalar tema
bash ~/dotfiles/scripts/install-catppuccin-kvantum.sh

# Paso 2: Activar Kvantum (IMPORTANTE)
bash ~/dotfiles/scripts/enable-kvantum.sh

# Paso 3: Abrir Kvantum Manager
kvantummanager

# Paso 4: En Kvantum Manager:
#   - Selecciona "Catppuccin-Mocha-Blue"
#   - Haz clic en "Apply"

# ¡Listo! Tu sistema ahora usa Catppuccin Kvantum
```

## Verificación

### Comprobar que Kvantum está activado:

```bash
# Leer la configuración actual
kreadconfig5 --file ~/.config/kdeglobals --group General --key widgetStyle

# Debería mostrar:
# kvantum
```

### Listar temas instalados:

```bash
ls ~/.config/Kvantum/ | grep -v "^kvantum"
```

### Ver tema actualmente seleccionado:

```bash
kreadconfig5 --file ~/.config/Kvantum/kvantum.conf --key theme
```

## Troubleshooting

### "No veo cambios después de aplicar el tema"

1. Verifica que Kvantum está activado:
   ```bash
   bash ~/dotfiles/scripts/enable-kvantum.sh
   ```

2. Reinicia las aplicaciones:
   ```bash
   killall -9 plasmashell && plasmashell &
   ```

3. O reinicia sesión de KDE

### "Kvantum Manager dice 'Apply' pero nada cambia"

- Kvantum probablemente no está activado como Application Style
- Ejecuta el script `enable-kvantum.sh`
- Verifica en System Settings → Application Style que dice "Kvantum"

### "Veo 'Kvantum' en Application Style pero los temas no están en Kvantum Manager"

- Verifica que los temas están en `~/.config/Kvantum/`
- Comprueba que la estructura es correcta:
  ```
  ~/.config/Kvantum/NombreTema/
  ├── NombreTema.kvconfig
  └── NombreTema.svg
  ```
- Si no, reinstala el tema

## Resumen rápido

| Paso | Qué | Comando |
|------|-----|---------|
| 1 | Instalar tema | `bash install-catppuccin-kvantum.sh` |
| 2 | **Activar Kvantum** | `bash enable-kvantum.sh` |
| 3 | Abrir manager | `kvantummanager` |
| 4 | Seleccionar y aplicar | (en la GUI) |

**La clave es el Paso 2**: Sin activar Kvantum, los temas no se aplican aunque estén instalados.

## Referencias

- [Kvantum GitHub](https://github.com/tsujan/Kvantum)
- [Catppuccin Kvantum](https://github.com/catppuccin/kvantum)
- [KDE Application Styles](https://docs.kde.org/stable/en/kcontrol/style/index.html)
