#!/bin/bash

layout=$(awk '/^\$layout/ {print $3}' ~/.cache/dotfiles/layout.conf)

case "$layout" in
"master")
  echo ""
  ;;
"dwindle")
  echo ""
  ;;
*)
  echo ""
  ;;
esac
