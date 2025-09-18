#!/bin/bash
bat=$(cat /sys/class/power_supply/BAT1/capacity)
status=$(cat /sys/class/power_supply/BAT1/status)
icon="󰂑"

if [ "$status" = "Discharging" ]; then
  if [ $bat -ge 90 ]; then
    icon="󰂂"
  elif [ $bat -ge 80 ]; then
    icon="󰂁"
  elif [ $bat -ge 70 ]; then
    icon="󰂀"
  elif [ $bat -ge 60 ]; then
    icon="󰁿"
  elif [ $bat -ge 50 ]; then
    icon="󰁾"
  elif [ $bat -ge 40 ]; then
    icon="󰁽"
  elif [ $bat -ge 30 ]; then
    icon="󰁼"
  elif [ $bat -ge 20 ]; then
    icon="󰁻"
  elif [ $bat -ge 10 ]; then
    icon="󰁺"
  else
    icon="󰂎"
  fi
elif [ "$status" = "Charging" ]; then
  if [ $bat -ge 90 ]; then
    icon="󰂋"
  elif [ $bat -ge 80 ]; then
    icon="󰂊"
  elif [ $bat -ge 70 ]; then
    icon="󰢞"
  elif [ $bat -ge 60 ]; then
    icon="󰂉"
  elif [ $bat -ge 50 ]; then
    icon="󰢝"
  elif [ $bat -ge 40 ]; then
    icon="󰂈"
  elif [ $bat -ge 30 ]; then
    icon="󰂇"
  elif [ $bat -ge 20 ]; then
    icon="󰂆"
  elif [ $bat -ge 10 ]; then
    icon="󰢜"
  else
    icon="󰢟"
  fi
elif [ "$status" = "Full" ]; then
  icon="󰁹"
else
  icon="󰂑"
fi

echo "$icon $bat%"
