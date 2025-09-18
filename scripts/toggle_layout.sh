#!/bin/bash
# ~/.config/hypr/scripts/toggle_layout.sh

CONFIG_FILE="$HOME/.cache/dotfiles/layout.conf"

# Verificar si existe el archivo, si no, crearlo
if [ ! -f "$CONFIG_FILE" ]; then
  echo "\$layout = dwindle" >"$CONFIG_FILE"
fi

# Leer el layout actual
CURRENT_LAYOUT=$(grep "layout =" "$CONFIG_FILE" | sed 's/.*layout = //')

# Intercambiar
if [ "$CURRENT_LAYOUT" = "master" ]; then
  sed -i 's/layout = master/layout = dwindle/' "$CONFIG_FILE"
  hyprctl keyword general:layout dwindle
  notify-send --app-name Disposicion "🪟 Layout" "Disposición tipo: DWINDLE"
elif [ "$CURRENT_LAYOUT" = "dwindle" ]; then
  sed -i 's/layout = dwindle/layout = master/' "$CONFIG_FILE"
  hyprctl keyword general:layout master
  notify-send --app-name Disposicion -u normal "🪟 Layout" "Disposición tipo: MASTER"
fi
