# 🎨 Dotfiles pipeaalzamora

Entorno moderno para **Arch Linux / EndeavourOS** con tema **Catppuccin Mocha**, shell Zsh optimizado y herramientas CLI de última generación.

---

## ⚡ Instalación Rápida

```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

El script `setup.sh` hace TODO automáticamente: valida, instala, configura y aplica.

---

## 📂 Estructura

```
~/dotfiles/
├── setup.sh                 # 🚀 INSTALADOR ÚNICO
├── install.sh              # Instalador original
├── configure-git.sh        # Configura Git interactivamente
├── push-dotfiles.sh        # Automatiza push a GitHub
│
├── .zshrc                  # Shell (65 alias + 14 funciones)
├── .zprofile               # Perfil de shell
├── .gitconfig              # Git configurado
├── .gitignore_global       # Gitignore global
│
├── .config/
│   ├── starship.toml       # Prompt personalizado
│   ├── kitty/              # Terminal emulator
│   ├── nvim/               # Neovim configurado
│   ├── lazygit/            # Git visual
│   ├── btop/               # Monitor de recursos
│   ├── yazi/               # File manager
│   ├── zathura/            # PDF viewer
│   ├── kdeglobals          # KDE tema
│   ├── kglobalshortcutsrc  # KDE atajos
│   └── Kvantum/            # Motor gráfico
│
├── scripts/                # Utilidades opcionales
├── data/                   # Datos (biblia, etc)
└── .local/share/           # Lanzadores y widgets KDE
```

---

## 🚀 Flujo de Instalación

El script `setup.sh` automáticamente:

1. **Valida** - Verifica que todos los archivos estén presentes
2. **Instala** - Pregunta qué instalar (interactivo)
3. **Aplica** - Crea symlinks y configura servicios
4. **Listo** - Muestra próximos pasos

---

## 📌 Primeros Pasos

1. **Reinicia sesión**
   ```bash
   exit  # o Ctrl+D
   ```

2. **Verifica instalación**
   ```bash
   ~/dotfiles/scripts/check-dependencies
   ```

3. **Personaliza KDE (opcional)**
   ```bash
   ~/dotfiles/scripts/setup-kde.sh
   ```

4. **Descarga wallpapers 4K (opcional)**
   ```bash
   ~/dotfiles/scripts/download-wallpapers.sh
   ```

5. **Lee los atajos de teclado**
   ```bash
   cat ~/dotfiles/KEYBINDINGS.md
   ```

---

## 🎨 Catppuccin Mocha

Tema coherente aplicado en: Terminal, Shell, Prompt, Neovim, Lazygit, Bat, KDE Plasma, GTK, Kvantum.

**Paleta de colores:**
```
Rosewater: #f5e0dc  |  Red: #f38181      |  Green: #a6e3a1
Flamingo:  #f2cdcd  |  Maroon: #eba0ac   |  Teal: #94e2d5
Pink:      #f5c2e7  |  Peach: #fab387    |  Sky: #89dceb
Mauve:     #cba6f7  |  Yellow: #f9e2af   |  Sapphire: #74c7ec
```

---

## 🆘 Problemas Comunes

**"El shell sigue siendo bash"**
```bash
chsh -s /usr/bin/zsh && exit
```

**"Los comandos lsd, bat, etc. no se encuentran"**
```bash
sudo pacman -S lsd bat ripgrep fd fzf zoxide btop yazi
```

**"KDE no cambió de tema"**
```bash
~/dotfiles/scripts/setup-kde.sh
```

**"Descarga incompleta"**
```bash
rm -rf ~/dotfiles
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles
cd ~/dotfiles && ./setup.sh
```

---

## 📚 Documentación

- **KEYBINDINGS.md** - Todos los atajos de teclado
- **.zshrc** - Alias y funciones disponibles
- **.gitconfig** - Configuración de Git
- **setup.sh** - Ver el script para entender qué instala

---

## ✨ Qué Obtienes

✅ **Terminal ultrarrápida** - Zsh + Starship + Kitty + Catppuccin Mocha
✅ **Herramientas CLI modernas** - lsd, bat, ripgrep, fzf, btop, yazi, lazygit, etc.
✅ **Desarrollo listo** - Neovim, Git, Node.js, Python, Rust, Go configurados
✅ **KDE Plasma personalizado** - Tema coherente, atajos, efectos visuales
✅ **65 alias + 14 funciones** - Productividad al máximo
✅ **Instalación automática** - Seguro con backups

---

## 🔗 Enlaces

- [Catppuccin](https://catppuccin.com/)
- [Arch Linux](https://archlinux.org/)
- [Zsh](https://www.zsh.org/)
- [Neovim](https://neovim.io/)
- [Starship](https://starship.rs/)
- [KDE Plasma](https://kde.org/plasma/)

---

## 📝 Autor

**@pipeaalzamora** - Configuración personal para Arch Linux / EndeavourOS

---

## 🎉 ¡Empezar Ya!

```bash
git clone https://github.com/pipeaalzamora/Dotfiles.git ~/dotfiles && \
cd ~/dotfiles && \
chmod +x setup.sh && \
./setup.sh
```

¡Disfruta tu nuevo entorno! 🚀
