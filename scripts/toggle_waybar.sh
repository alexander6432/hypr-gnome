#!/bin/bash
if pgrep -x "waybar" >/dev/null; then
  killall waybar
else
  waybar -c ~/.config/waybar/islas/config.jsonc -s ~/.config/waybar/islas/style.css &
fi
