# ============================================================
# Perfil de inicio de Zsh
# Variables de entorno, PATH y locale
# ============================================================

# Locale: debe existir en `locale -a`. Evitar LC_ALL persistente.
export LANG="es_CL.UTF-8"
export LC_CTYPE="es_CL.UTF-8"
unset LC_ALL

# Directorio de dotfiles: instalación habitual en Documentos.
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Documentos/Dotfiles}"

# Directorios locales de usuario
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Flatpak expone sus lanzadores de usuario en esta ruta cuando existe.
if [ -d "$HOME/.local/share/flatpak/exports/bin" ]; then
    export PATH="$HOME/.local/share/flatpak/exports/bin:$PATH"
fi
