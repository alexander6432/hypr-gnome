#!/bin/bash
# ~/.config/hypr/scripts/toggle_layout.sh

CACHE_DIR="$HOME/.cache/dotfiles"
CONFIG_FILE="$CACHE_DIR/layout.conf"
BINDS_FILE="$CACHE_DIR/binds.conf"

mkdir -p "$CACHE_DIR"

# Crear archivo de estado si no existe
if [ ! -f "$CONFIG_FILE" ]; then
  echo "layout = dwindle" >"$CONFIG_FILE"
fi

# Crear binds.conf si no existe (inicializar en dwindle, por ejemplo)
if [ ! -f "$BINDS_FILE" ]; then
  cat >"$BINDS_FILE" <<EOF
# Keybindings dinámicos iniciales (dwindle)
########################
# KEYBINDINGS DYNAMICS #
########################

bindd = \$mainMod CTRL,  H, Abrir Próxima Ventana hacia la Izquierda, layoutmsg, preselect l
bindd = \$mainMod CTRL,  L, Abrir Próxima Ventana hacia la Derecha,   layoutmsg, preselect r
bindd = \$mainMod CTRL,  K, Abrir Próxima Ventana hacia Arriba,       layoutmsg, preselect u
bindd = \$mainMod CTRL,  J, Abrir Próxima Ventana hacia Abajo,        layoutmsg, preselect d

bindd = \$mainMod,       S, Alterna disposición de Ventanas(Dwindle),  togglesplit
bindd = \$mainMod SHIFT, S, Intercambia Posición de Ventanas(Dwindle), swapsplit
bindd = \$mainMod,       A, Psedoflotante(Dwindle),                    pseudo

EOF
fi

# Leer layout actual
CURRENT_LAYOUT=$(grep "layout =" "$CONFIG_FILE" | sed 's/.*layout = //')

# Función para generar keybindings
generate_binds() {
  local mode="$1"
  cat >"$BINDS_FILE" <<EOF
########################
# KEYBINDINGS DYNAMICS #
########################

# ($mode)

EOF

  if [ "$mode" = "dwindle" ]; then
    cat >>"$BINDS_FILE" <<EOF
bindd = \$mainMod CTRL,  H, Abrir Próxima Ventana hacia la Izquierda, layoutmsg, preselect l
bindd = \$mainMod CTRL,  L, Abrir Próxima Ventana hacia la Derecha,   layoutmsg, preselect r
bindd = \$mainMod CTRL,  K, Abrir Próxima Ventana hacia Arriba,       layoutmsg, preselect u
bindd = \$mainMod CTRL,  J, Abrir Próxima Ventana hacia Abajo,        layoutmsg, preselect d

bindd = \$mainMod,       S, Alterna disposición de Ventanas(Dwindle),  togglesplit
bindd = \$mainMod SHIFT, S, Intercambia Posición de Ventanas(Dwindle), swapsplit
bindd = \$mainMod,       A, Psedoflotante(Dwindle),                    pseudo
EOF
  elif [ "$mode" = "master" ]; then
    cat >>"$BINDS_FILE" <<EOF
#Cambian en funcion si la distribución de las ventanas en master
bindd = \$mainMod,       S, Intercambia Ventana con la Siguiente(Master), layoutmsg, swapnext loop
bindd = \$mainMod SHIFT, S, Enfocar Siguiente Ventana(Master),            layoutmsg, cyclenext loop
bindd = \$mainMod,       A, Intercambia Ventana con la Master(Master),    layoutmsg, swapwithmaster master

bindd = \$mainMod SHIFT, A, Cambiar Orientación de Ventanas Esclavas(Master), layoutmsg, orientationnext

bindd = \$mainMod, up,   Incrementar Dimensión de Ventana Master(Master), layoutmsg, mfact +0.05
bindd = \$mainMod, down, Disminuir Dimensión de Ventana Master(Master),   layoutmsg, mfact -0.05

EOF
  fi
}

# Intercambiar layouts
if [ "$CURRENT_LAYOUT" = "master" ]; then
  sed -i 's/layout = master/layout = dwindle/' "$CONFIG_FILE"
  hyprctl keyword general:layout dwindle
  generate_binds "dwindle"
  hyprctl reload
  notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: DWINDLE"
elif [ "$CURRENT_LAYOUT" = "dwindle" ]; then
  sed -i 's/layout = dwindle/layout = master/' "$CONFIG_FILE"
  hyprctl keyword general:layout master
  generate_binds "master"
  hyprctl reload
  notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: MASTER"
fi
