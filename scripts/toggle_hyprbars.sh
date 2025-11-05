#!/usr/bin/env bash

if hyprctl plugin list | grep -q "hyprbars"; then
  hyprctl plugin unload "/var/cache/hyprpm/alex/hyprland-plugins/hyprbars.so"
else
  hyprctl plugin load "/var/cache/hyprpm/alex/hyprland-plugins/hyprbars.so"
fi
