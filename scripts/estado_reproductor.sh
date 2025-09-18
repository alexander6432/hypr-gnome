#!/bin/bash

# Obtener estado, lista de reproductores y pista
estado=$(playerctl status 2>/dev/null)
reproductor=$(playerctl -l 2>/dev/null | awk -F. '{print $1}')
artista=$(playerctl metadata --format "{{ artist }}" 2>/dev/null)
pista=$(playerctl metadata --format "{{ title }}" 2>/dev/null)

# Manejar todos los posibles estados
case "$estado" in
"Playing")
  estado="Reproduciendo"
  [ -z "$pista" ] && pista="Desconocida"
  [ -z "$artista" ] && artista="Desconocido"
  [ -z "$reproductor" ] && reproductor="Desconocido"
  ;;
"Paused")
  estado="Pausado"
  [ -z "$pista" ] && pista="Desconocida"
  [ -z "$artista" ] && artista="Desconocido"
  [ -z "$reproductor" ] && reproductor="Desconocido"
  ;;
"Stopped")
  estado="Detenido"
  pista="N/A"
  artista="N/A"
  reproductor="N/A"
  ;;
"No players found")
  estado="No hay reproductor activo"
  pista="N/A"
  artista="N/A"
  reproductor="N/A"
  ;;
"No player could handle this command")
  estado="Comando no soportado"
  pista="N/A"
  artista="N/A"
  reproductor="N/A"
  ;;
*)
  # Cualquier otro estado inesperado
  estado="Desconocido"
  [ -z "$pista" ] && pista="N/A"
  [ -z "$artista" ] && artista="N/A"
  [ -z "$reproductor" ] && reproductor="N/A"
  ;;
esac

# Mostrar información con salidas controladas
if [ "$estado" = "No hay reproductor activo" ] ||
  [ "$estado" = "Comando no soportado" ] ||
  [ "$estado" = "Desconocido" ]; then
  echo " No hay reproductor activo."
  exit 1
elif [ "$estado" = "Detenido" ]; then
  echo " Reproductor detenido."
  exit 1
fi

#Mostrar icono del reproductor
if [ "$reproductor" = "chromium" ]; then
  reproductor=" "
elif [ "$reproductor" = "firefox" ]; then
  reproductor="󰈹 "
elif [ "$reproductor" = "vlc" ]; then
  reproductor="󰕼 "
elif [ "$reproductor" = "spotify" ]; then
  reproductor=" "
elif [ "$reproductor" = "TelegramDesktop" ]; then
  reproductor=" "
else
  reproductor=$(echo "$reproductor" | sed 's/^\(.\)/\U\1/') # Capitalizar primera letra
fi

#Mostrar icono del estado
if [ "$estado" = "Reproduciendo" ]; then
  estado=" "
elif [ "$estado" = "Pausado" ]; then
  estado=" "
elif [ "$estado" = "Detenido" ]; then
  estado=" "
else
  estado="❓ $estado"
fi

# Recortar largo de artista y pista, añadir "..." si se corta
max_artista=25
max_pista=30
[[ ${#artista} -gt $max_artista ]] && artista="${artista:0:$max_artista}..."
[[ ${#pista} -gt $max_pista ]] && pista="${pista:0:$max_pista}..."

# Salida final en formato compacto
echo "$reproductor $estado  󰠃 $artista"
echo "  $pista"
