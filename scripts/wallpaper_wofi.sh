#!/bin/bash

# Configuración
WALLPAPER_DIR="$HOME/Imágenes/wallpapers/"
TRANSITION_OPTS="--transition-type grow --transition-fps 60 --transition-duration 2.0"
INIT_SLEEP=0.5

# Función para mostrar mensajes de error y salir
error_exit() {
  notify-send --app-name Wallpaper -u critical "❌ Error" "$1"
  echo "Error: $1" >&2
  exit 1
}

# Función para generar el menú de wallpapers
menu() {
  if command -v fd >/dev/null 2>&1; then
    fd -e jpg -e jpeg -e png -e gif -e webp . "$WALLPAPER_DIR" | sort | sed 's/^/img:/'
  else
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) 2>/dev/null | sort | sed 's/^/img:/'
  fi
}

# Función principal
main() {
  # Verificar que el directorio de wallpapers existe
  if [ ! -d "$WALLPAPER_DIR" ]; then
    error_exit "El directorio $WALLPAPER_DIR no existe"
  fi

  # Verificar que haya wallpapers disponibles
  if [ -z "$(menu)" ]; then
    error_exit "No hay wallpapers disponibles en $WALLPAPER_DIR"
  fi

  # Asegurar que swww esté corriendo
  if ! pgrep -x swww-daemon >/dev/null; then
    echo "Iniciando swww-daemon..."
    if ! swww init 2>/dev/null; then
      error_exit "No se pudo inicializar swww-daemon"
    fi
    sleep "$INIT_SLEEP"
  fi

  # Mostrar el selector de wallpapers
  choice=$(menu | wofi -c ~/.config/wofi/wallpaper)

  # Procesar la selección
  selected_wallpaper="${choice#img:}"

  if [ -n "$selected_wallpaper" ] && [ -f "$selected_wallpaper" ]; then
    echo "Aplicando wallpaper: $(basename "$selected_wallpaper")"

    # Cambiar fondo con transición
    if swww img "$selected_wallpaper" $TRANSITION_OPTS 2>/dev/null; then
      # Actualizar colores con Matugen (opcional, no bloqueante)
      if command -v matugen >/dev/null 2>&1; then
        matugen image "$selected_wallpaper" >/dev/null 2>&1 &
      fi

      # Notificación de éxito
      notify-send --app-name Wallpaper -u normal "🎨 Wallpaper cambiado" "$(basename "$selected_wallpaper")"
      echo "Wallpaper aplicado exitosamente"
    else
      error_exit "No se pudo aplicar el wallpaper"
    fi
  elif [ -n "$selected_wallpaper" ]; then
    error_exit "El archivo seleccionado no existe: $selected_wallpaper"
  else
    echo "No se seleccionó ningún wallpaper."
    exit 0
  fi
}

# Verificar dependencias críticas
check_dependencies() {
  local missing_deps=()

  command -v swww >/dev/null 2>&1 || missing_deps+=("swww")
  command -v wofi >/dev/null 2>&1 || missing_deps+=("wofi")
  command -v notify-send --app-name Wallpaper -u normal >/dev/null 2>&1 || missing_deps+=("libnotify/notify-send")

  if [ ${#missing_deps[@]} -gt 0 ]; then
    echo "Error: Faltan las siguientes dependencias:" >&2
    printf "  - %s\n" "${missing_deps[@]}" >&2
    exit 1
  fi
}

# Punto de entrada
check_dependencies
main "$@"
