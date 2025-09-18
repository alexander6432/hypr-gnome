#!/bin/bash

# Verifica si rofi está ejecutándose
if pgrep -x wofi >/dev/null; then
  # Si rofi está ejecutándose, ciérralo
  pkill -x wofi
else
  # Si no está ejecutándose, ábrelo
  wofi -n
fi
