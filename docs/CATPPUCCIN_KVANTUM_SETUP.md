# Configuración de Catppuccin con Kvantum

## ¿Qué es Catppuccin?

Catppuccin es una paleta de colores pastel hermosa diseñada para resaltar la sintaxis y crear temas coherentes en todo tu sistema. Tiene 4 sabores (flavors):

- **Latte** 🌻 - Claro y fresco
- **Frappé** 🪴 - Neutro y cálido
- **Macchiato** 🌺 - Suave y oscuro
- **Mocha** 🌿 - Profundo y oscuro

Cada sabor tiene 10 acentos de color diferentes.

## ¿Qué es Kvantum?

Kvantum es un motor de temas para aplicaciones Qt (como KDE Plasma). Los temas de Kvantum definen la apariencia de botones, ventanas, barras de desplazamiento y otros elementos de la interfaz.

## Instalación Rápida

### Opción 1: Instalar un tema específico (Interactivo)

```bash
bash ~/dotfiles/scripts/install-catppuccin-kvantum.sh
```

Esto te permitirá:
1. Seleccionar el sabor (Latte, Frappé, Macchiato, Mocha)
2. Seleccionar el acento de color
3. Instalar automáticamente el tema

### Opción 2: Instalar TODOS los temas

```bash
bash ~/dotfiles/scripts/install-all-catppuccin-kvantum.sh
```

Esto instalará los 40 temas disponibles (4 sabores × 10 acentos).

## Aplicar el Tema

### Mediante Kvantum Manager (GUI)

```bash
kvantummanager
```

1. Abre "Kvantum Manager"
2. En la lista de la izquierda, selecciona el tema `Catppuccin-*`
3. Haz clic en el botón "Apply"

### Mediante KDE Plasma System Settings

1. Abre **System Settings** (Configuración del Sistema)
2. Ve a **Appearance** (Apariencia)
3. Selecciona **Application Style** (Estilo de Aplicación)
4. Elige **Kvantum** en el menú desplegable
5. Se abrirá Kvantum Manager, selecciona tu tema y aplica

### Manualmente (Editar config)

Si prefieres configurar directamente:

```bash
# Editar la configuración de Kvantum
nano ~/.config/Kvantum/kvantum.conf
```

Y establece:

```ini
theme=Catppuccin-Mocha-Blue
```

(Reemplaza `Mocha-Blue` con tu combinación sabor-acento)

## Temas Disponibles

### Sabores × Acentos

Después de instalar, tendrás acceso a estos temas:

**Mocha** (Recomendado para oscuro):
- Catppuccin-Mocha-Rosewater
- Catppuccin-Mocha-Flamingo
- Catppuccin-Mocha-Pink
- Catppuccin-Mocha-Mauve
- Catppuccin-Mocha-Red
- Catppuccin-Mocha-Maroon
- Catppuccin-Mocha-Peach
- Catppuccin-Mocha-Yellow
- Catppuccin-Mocha-Green
- Catppuccin-Mocha-Teal
- Catppuccin-Mocha-Sky
- Catppuccin-Mocha-Sapphire
- Catppuccin-Mocha-Blue
- Catppuccin-Mocha-Lavender

**Macchiato**, **Frappé**, **Latte** - Idem con sus respectivos nombres

## Integración Completa

Para una experiencia completa de Catppuccin en tu sistema:

### 1. **Starship** (Ya configurado ✓)
El prompt ya usa la paleta Catppuccin Mocha en `~/.config/starship.toml`

### 2. **Kvantum** (Este setup)
Themes para aplicaciones Qt

### 3. **Otros temas recomendados**
- **KDE Plasma Theme**: Catppuccin-Mocha
- **Color Scheme**: Catppuccin-Mocha
- **Icons**: Papirus-Dark (compatible)
- **Konsole**: Catppuccin-Mocha

Para instalar otros temas de Catppuccin:

```bash
# KDE Plasma Theme
git clone https://github.com/catppuccin/kde.git ~/.local/share/plasma/desktoptheme/

# Color schemes
git clone https://github.com/catppuccin/kde.git ~/.local/share/color-schemes/
```

## Troubleshooting

### El tema no aparece en Kvantum Manager

Verifica que los archivos estén en la ubicación correcta:

```bash
ls ~/.config/Kvantum/
```

Los temas deben verse como:
```
Catppuccin-Mocha-Blue/
├── Catppuccin-Mocha-Blue.kvconfig
└── Catppuccin-Mocha-Blue.svg
```

### El tema aplicado no se ve

1. Reinicia las aplicaciones Qt
2. Si es necesario, reinicia KDE Plasma:
   - `killall plasmashell && plasmashell &`
3. Verifica que Kvantum Manager esté activado en System Settings

### Compatibilidad

- Requiere: Kvantum >= 0.20
- Compatible con: KDE Plasma 5.x, 6.x
- Probado en: Arch Linux, EndeavourOS

## Referencias

- [Catppuccin Organization](https://github.com/catppuccin)
- [Catppuccin Kvantum Repository](https://github.com/catppuccin/kvantum)
- [Kvantum Documentation](https://github.com/tsujan/Kvantum)

## Tips

- **Mocha** es ideal para entornos oscuros
- **Latte** es perfecto si prefieres un tema claro
- **Macchiato** es un buen punto medio
- Los acentos **Blue** y **Sapphire** son los más populares

Combina con la configuración de Starship incluida en tu dotfiles para una experiencia visual coherente ✨
