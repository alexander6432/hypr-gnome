#!/bin/bash
if pgrep -x "waybar" >/dev/null; then
  pkill waybar
else
  waybar -c ~/.config/waybar/cubic/config.jsonc -s ~/.config/waybar/cubic/style.css &
fi
