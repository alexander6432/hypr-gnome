#!/usr/bin/env bash
# ~/.config/hypr/scripts/toggle_layout.sh

CACHE_DIR="$HOME/.cache/dotfiles"
CONFIG_FILE="$CACHE_DIR/layout.conf"
BINDS_FILE="$CACHE_DIR/binds.conf"

mkdir -p "$CACHE_DIR"

# ============================
# Plantillas de Keybindings
# ============================

write_dwindle_binds() {
  cat <<EOF
source = ~/.config/hypr/hyprland/keybindings/dwindle.conf
EOF
}

write_master_binds() {
  cat <<EOF
source = ~/.config/hypr/hyprland/keybindings/master.conf
EOF
}

# ============================
# Inicialización de archivos
# ============================

# Crear archivo de layout si no existe
if [ ! -f "$CONFIG_FILE" ]; then
  echo "layout = dwindle" >"$CONFIG_FILE"
fi

# Crear archivo de binds si no existe (por defecto: dwindle)
if [ ! -f "$BINDS_FILE" ]; then
  {
    echo "# Keybindings dinámicos iniciales (Dwindle)"
    echo
    write_dwindle_binds
  } >"$BINDS_FILE"
fi

# ============================
# Función para generar binds
# ============================

generate_binds() {
  local mode="$1"
  {
    echo "# Keybindings dinámicos ($mode)"
    echo
    case "$mode" in
    dwindle) write_dwindle_binds ;;
    master) write_master_binds ;;
    esac
  } >"$BINDS_FILE"
}

# ============================
# Lógica de alternancia
# ============================

# Leer layout actual
CURRENT_LAYOUT=$(grep "layout =" "$CONFIG_FILE" | sed 's/.*layout = //')

if [ "$CURRENT_LAYOUT" = "master" ]; then
  sed -i 's/layout = master/layout = dwindle/' "$CONFIG_FILE"
  hyprctl keyword general:layout dwindle
  generate_binds "dwindle"
  notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: DWINDLE"
elif [ "$CURRENT_LAYOUT" = "dwindle" ]; then
  sed -i 's/layout = dwindle/layout = master/' "$CONFIG_FILE"
  hyprctl keyword general:layout master
  generate_binds "master"
  notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: MASTER"
fi
