#!/bin/bash
# Configuración
WALLPAPER_DIR="$HOME/Imágenes/wallpapers/"
TRANSITION_OPTS=(
  --transition-type fade
  --transition-step 60
  --transition-duration 3.0
  --transition-fps 60
  --transition-angle 90
  --transition-pos center
  --transition-bezier ".54,0,.34,.99"
  --transition-wave "20,20"
)
INIT_SLEEP=0.5
CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper_list.cache"
CACHE_LIFETIME=3600 # 1 hora en segundos

# Función para mostrar mensajes de error y salir
error_exit() {
  notify-send --app-name Wallpaper -u critical "❌ Error" "$1"
  echo "Error: $1" >&2
  exit 1
}

# Función para generar lista de wallpapers (optimizada con cache)
generate_wallpaper_list() {
  if command -v fd >/dev/null 2>&1; then
    fd -e jpg -e jpeg -e png -e gif -e webp . "$WALLPAPER_DIR" | sort
  else
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) | sort
  fi
}

# Función para obtener wallpapers (con cache)
menu() {
  local cache_valid=false

  # Verificar si existe cache válido
  if [ -f "$CACHE_FILE" ]; then
    local cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)))
    if [ "$cache_age" -lt "$CACHE_LIFETIME" ]; then
      cache_valid=true
    fi
  fi

  # Usar cache o regenerar
  if [ "$cache_valid" = true ]; then
    cat "$CACHE_FILE"
  else
    mkdir -p "$(dirname "$CACHE_FILE")"
    generate_wallpaper_list | tee "$CACHE_FILE"
  fi
}

# Verificar dependencias críticas (optimizado)
check_dependencies() {
  local missing_deps=()

  for cmd in swww wofi notify-send; do
    command -v "$cmd" >/dev/null 2>&1 || missing_deps+=("$cmd")
  done

  if [ ${#missing_deps[@]} -gt 0 ]; then
    echo "Error: Faltan las siguientes dependencias:" >&2
    printf "  - %s\n" "${missing_deps[@]}" >&2
    exit 1
  fi
}

# Verificar swww-daemon (optimizado)
ensure_swww_running() {
  if ! pgrep -x swww-daemon >/dev/null; then
    echo "Iniciando swww-daemon..."
    swww-daemon &
    sleep "$INIT_SLEEP"

    # Verificar que inició correctamente
    local retries=5
    while [ $retries -gt 0 ]; do
      if pgrep -x swww-daemon >/dev/null; then
        return 0
      fi
      sleep 0.2
      ((retries--))
    done

    error_exit "No se pudo inicializar swww-daemon"
  fi
}

# Aplicar wallpaper (función separada para claridad)
apply_wallpaper() {
  local wallpaper="$1"

  # Cambiar fondo con transición
  if swww img "$wallpaper" "${TRANSITION_OPTS[@]}"; then
    # Actualizar colores con Matugen (en background, no bloqueante)
    if command -v matugen >/dev/null 2>&1; then
      (matugen image "$wallpaper" >/dev/null 2>&1 &)
    fi

    # Notificación de éxito
    notify-send --app-name Wallpaper -u normal "🎨 Wallpaper cambiado" "$(basename "$wallpaper")"
    echo "Wallpaper aplicado: $(basename "$wallpaper")"
    return 0
  else
    error_exit "No se pudo aplicar el wallpaper"
  fi
}

# Función principal
main() {
  # Verificar que el directorio existe
  [ -d "$WALLPAPER_DIR" ] || error_exit "El directorio $WALLPAPER_DIR no existe"

  # Generar lista de wallpapers
  local wallpaper_list
  wallpaper_list=$(menu)

  # Verificar que hay wallpapers disponibles
  [ -n "$wallpaper_list" ] || error_exit "No hay wallpapers disponibles en $WALLPAPER_DIR"

  # Asegurar que swww esté corriendo
  ensure_swww_running

  # Mostrar selector (prefijo img: agregado aquí para no afectar cache)
  local choice
  choice=$(echo "$wallpaper_list" | sed 's/^/img:/' | wofi -c ~/.config/wofi/wallpaper)

  # Procesar selección
  local selected_wallpaper="${choice#img:}"

  if [ -z "$selected_wallpaper" ]; then
    echo "No se seleccionó ningún wallpaper."
    exit 0
  fi

  if [ -f "$selected_wallpaper" ]; then
    apply_wallpaper "$selected_wallpaper"
  else
    error_exit "El archivo seleccionado no existe: $selected_wallpaper"
  fi
}

# Punto de entrada
check_dependencies
main "$@"
