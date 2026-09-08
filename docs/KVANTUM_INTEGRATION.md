# Kvantum Integration - KDE Plasma 7

## ¿Qué es Kvantum?

Kvantum es un motor de temas para aplicaciones Qt (independiente de KDE).

## ¿Por qué necesita "activación"?

Kvantum es independiente de KDE Plasma. Necesita ser configurado como **Application Style** para que KDE use sus temas.

### Sin activación:
- Temas instalados pero inactivos
- KDE usa Breeze (por defecto)

### Con activación:
- KDE sabe que debe usar Kvantum
- Los temas se aplican correctamente

## Instalación y Activación

### 1. Instalar tema

```bash
bash ~/dotfiles/scripts/install-catppuccin-kvantum.sh
```

Elige sabor (Mocha, Latte, Frappé, Macchiato) y acento (Blue, Purple, Pink, etc).

### 2. Activar Kvantum

```bash
bash ~/dotfiles/scripts/enable-kvantum.sh
```

Este script modifica `~/.config/kdeglobals` para activar Kvantum como Application Style.

Soporta KDE Plasma 5 (kwriteconfig5) y Plasma 7 (kwriteconfig6).

### 3. Seleccionar y aplicar el tema

```bash
kvantummanager
```

- Selecciona el tema instalado
- Haz clic en "Apply"

## Verificación

### ¿Está Kvantum activado?

```bash
kreadconfig6 --file ~/.config/kdeglobals --group General --key widgetStyle
# Debería mostrar: kvantum
```

### ¿Cuál tema está seleccionado?

```bash
kreadconfig6 --file ~/.config/Kvantum/kvantum.conf --key theme
# Debería mostrar: Catppuccin-Mocha-Blue (o similar)
```

## Flujo Técnico

```
Aplicación Qt → ¿Cuál es mi estilo?
              → ~/.config/kdeglobals [widgetStyle=kvantum]
              → ~/.config/Kvantum/kvantum.conf [theme=...]
              → ~/.config/Kvantum/Tema/Tema.svg
              → Se renderiza con ese tema
```

## Troubleshooting

### Los temas no se ven después de aplicar

1. Verifica que Kvantum está activado:
   ```bash
   bash ~/dotfiles/scripts/enable-kvantum.sh
   ```

2. Reinicia Plasma:
   ```bash
   killall -9 plasmashell && plasmashell &
   ```

### Kvantum Manager está vacío

Asegúrate de que los temas están en `~/.config/Kvantum/`:

```bash
ls ~/.config/Kvantum/
```

Estructura esperada:
```
~/.config/Kvantum/NombreTema/
├── NombreTema.kvconfig
└── NombreTema.svg
```

### Volver al estilo por defecto

```bash
kwriteconfig6 --file ~/.config/kdeglobals --group General --key widgetStyle "breeze"
```

## Sabores Catppuccin disponibles

- **Mocha** (recomendado) — Oscuro y profundo
- **Macchiato** — Suave y oscuro
- **Frappé** — Neutro y cálido
- **Latte** — Claro y fresco

Cada uno con múltiples acentos: Blue, Purple, Pink, Green, etc.

## Scripts

- `install-catppuccin-kvantum.sh` — Instala un tema (interactivo)
- `install-all-catppuccin-kvantum.sh` — Instala todos los 40 temas
- `enable-kvantum.sh` — Activa Kvantum en KDE
