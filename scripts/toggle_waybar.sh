#!/bin/bash
if pgrep -x "waybar" >/dev/null; then
  killall waybar
else
  waybar -c ~/.config/waybar/cubic/config.jsonc -s ~/.config/waybar/cubic/style.css &
fi
