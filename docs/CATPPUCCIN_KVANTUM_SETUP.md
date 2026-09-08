# Catppuccin Kvantum - Guía Rápida

## Instalación Rápida

### 1. Instalar tema específico (interactivo)

```bash
bash ~/dotfiles/scripts/install-catppuccin-kvantum.sh
```

Te pedirá:
- **Sabor**: Latte, Frappé, Macchiato, Mocha (elige Mocha para oscuro)
- **Acento**: Blue, Purple, Pink, Green, Yellow, Red, etc.

### 2. Activar Kvantum en KDE

```bash
bash ~/dotfiles/scripts/enable-kvantum.sh
```

Soporta Plasma 5 y Plasma 7 automáticamente.

### 3. Aplicar el tema

```bash
kvantummanager
```

- Selecciona el tema que instalaste
- Haz clic en "Apply"

## Instalar todos los temas

Si quieres tener todos los 40 temas disponibles:

```bash
bash ~/dotfiles/scripts/install-all-catppuccin-kvantum.sh
```

## Sabores Disponibles

| Sabor | Descripción |
|-------|-------------|
| **Mocha** 🌿 | Oscuro y profundo (RECOMENDADO) |
| **Macchiato** 🌺 | Suave y oscuro |
| **Frappé** 🪴 | Neutro y cálido |
| **Latte** 🌻 | Claro y fresco |

## Verificación

### Ver si Kvantum está activado

```bash
kreadconfig6 --file ~/.config/kdeglobals --group General --key widgetStyle
# Debe mostrar: kvantum
```

### Ver tema seleccionado

```bash
kreadconfig6 --file ~/.config/Kvantum/kvantum.conf --key theme
```

## Revertir cambios

Volver al estilo por defecto:

```bash
kwriteconfig6 --file ~/.config/kdeglobals --group General --key widgetStyle "breeze"
```

## Más información

Consulta: `~/dotfiles/docs/KVANTUM_INTEGRATION.md`
