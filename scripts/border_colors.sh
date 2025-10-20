#!/bin/bash
# Script para cambiar colores según submapa

CONFIG_FILE="$HOME/.cache/dotfiles/colors_hyprland.conf"

# Función para obtener el valor rgba de una variable
get_color() {
  local varname="$1"
  grep "^\$${varname}[[:space:]]*=" "$CONFIG_FILE" | awk '{print $3}' | tr -d '[:space:]'
}

# Comprobar argumento con case
case "$1" in
ventanas)
  active_border="$(get_color primary_hue120)"
  title="🪟 Submaps"
  message="Entrando de Submapa de Ventanas"
  ;;
grupos)
  active_border="$(get_color primary_hue240)"
  title="🔀 Submaps"
  message="Entrando de Submapa de Grupos"
  ;;
*)
  echo "Uso: $0 [ventanas|grupos]"
  exit 1
  ;;
esac

# Aplicar colores a Hyprland
hyprctl keyword general:border_size 4
hyprctl keyword general:col.active_border "$active_border"
hyprctl keyword decoration:shadow:enabled false
hyprctl keyword decoration:shadow:color "$active_border"
hyprctl keyword decoration:shadow:range 8
hyprctl keyword decoration:shadow:render_power 8
hyprctl keyword decoration:rounding 0
hyprctl keyword decoration:inactive_opacity 0.75
hyprctl keyword decoration:active_opacity 0.9
hyprctl keyword decoration:rounding 8
hyprctl keyword decoration:rounding_power 4

hyprctl keyword group:col.border_active "$active_border"
hyprctl keyword group:col.border_locked_active "$active_border"
hyprctl keyword group:groupbar:gradient_rounding 4

# Notificación
notify-send --app-name Submaps -u normal "$title" "$message"
