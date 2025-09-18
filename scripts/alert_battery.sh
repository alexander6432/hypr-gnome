#!/bin/bash

while true; do
  bat=$(cat /sys/class/power_supply/BAT1/capacity)
  status=$(cat /sys/class/power_supply/BAT1/status)

  if [ "$status" = "Discharging" ]; then
    if [ "$bat" -le 10 ]; then
      notify-send "🪫 Batería crítica" "Nivel: $bat%" -u critical
      sleep 5
    elif [ "$bat" -le 30 ]; then
      notify-send --app-name Alerta_Bateria -u critical -u normal "🪫  Batería baja" "Nivel: $bat%" -u normal
      sleep 300
    else
      sleep 120
    fi

  elif [ "$status" = "Charging" ]; then
    if [ "$bat" -ge 95 ]; then
      notify-send --app-name Alerta_Bateria -u low "⚡ Batería casi llena" "Nivel: $bat%" -u normal
      sleep 600
    elif [ "$bat" -ge 85 ]; then
      notify-send --app-name Alerta_Bateria -u normal"⚡ Cargando" "Nivel: $bat%" -u low
      sleep 600
    else
      sleep 300
    fi

  elif [ "$status" = "Full" ]; then
    notify-send --app-name Alerta_Bateria -u low "🔋 Batería llena" "Puedes desconectar el cargador" -u normal
    sleep 60

  else
    notify-send --app-name Alerta_Bateria -u critical "⚠️ Estado desconocido" "No se puede leer el estado de la batería" -u normal
    sleep 300
  fi
done
