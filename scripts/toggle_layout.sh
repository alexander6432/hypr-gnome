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
bindd = \$mainMod CTRL,  H, Abrir Próxima Ventana hacia la Izquierda (Dwindle), layoutmsg, preselect l
bindd = \$mainMod CTRL,  L, Abrir Próxima Ventana hacia la Derecha (Dwindle),   layoutmsg, preselect r
bindd = \$mainMod CTRL,  K, Abrir Próxima Ventana hacia Arriba (Dwindle),       layoutmsg, preselect u
bindd = \$mainMod CTRL,  J, Abrir Próxima Ventana hacia Abajo (Dwindle),        layoutmsg, preselect d

bindd = \$mainMod,       S, Alterna disposición de Ventanas (Dwindle),  togglesplit
bindd = \$mainMod SHIFT, S, Intercambia Posición de Ventanas (Dwindle), swapsplit
bindd = \$mainMod,       A, Pseudoflotante (Dwindle),                    pseudo
EOF
}

write_master_binds() {
  cat <<EOF
bindd = \$mainMod,       S, Intercambia Ventana con la Siguiente(Master), layoutmsg, swapnext loop
bindd = \$mainMod SHIFT, S, Enfocar Siguiente Ventana(Master),            layoutmsg, cyclenext loop
bindd = \$mainMod,       A, Intercambia Ventana con la Master(Master),    layoutmsg, swapwithmaster master

bindd = \$mainMod SHIFT, A, Cambiar Orientación de Ventanas Esclavas(Master), layoutmsg, orientationnext
bindd = \$mainMod, up,   Incrementar Dimensión de Ventana Master(Master),     layoutmsg, mfact +0.05
bindd = \$mainMod, down, Disminuir Dimensión de Ventana Master(Master),       layoutmsg, mfact -0.05
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
    echo "########################"
    echo "# KEYBINDINGS DYNAMICS #"
    echo "########################"
    echo
    echo "# Keybindings dinámicos iniciales (Dwindle)"
    write_dwindle_binds
  } >"$BINDS_FILE"
fi

# ============================
# Función para generar binds
# ============================

generate_binds() {
  local mode="$1"
  {
    echo "########################"
    echo "# KEYBINDINGS DYNAMICS #"
    echo "########################"
    echo
    echo "# Keybindings dinámicos ($mode)"
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
