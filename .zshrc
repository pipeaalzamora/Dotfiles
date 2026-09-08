# Alias robustos para el selector de temas
if [ -x "$DOTFILES_DIR/scripts/theme-switcher.sh" ]; then
    alias theme-switch="$DOTFILES_DIR/scripts/theme-switcher.sh"
    alias theme-orange="$DOTFILES_DIR/scripts/theme-switcher.sh '🔥 Catppuccin Black & Orange'"
    alias theme="$DOTFILES_DIR/scripts/theme.sh"
fi
