#!/bin/bash
# ~/.config/hypr/scripts/smart-bindings.sh

get_current_layout() {
  hyprctl getoption general:layout -j | jq -r '.str'
}

case "$(get_current_layout)" in
"master")
  case "$1" in
  "togglesplit") hyprctl dispatch layoutmsg swapnext loop ;;
  "swapsplit") hyprctl dispatch layoutmsg cyclenext loop ;;
  "pseudo") hyprctl dispatch layoutmsg swapwithmaster master ;;
  esac
  ;;
"dwindle")
  case "$1" in
  "togglesplit") hyprctl dispatch togglesplit ;;
  "swapsplit") hyprctl dispatch swapsplit ;;
  "pseudo") hyprctl dispatch pseudo ;;
  esac
  ;;
esac
