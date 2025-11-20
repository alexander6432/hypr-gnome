#!/bin/bash
# ~/.local/bin/niri-keys-search

grep 'hotkey-overlay-title' ~/.config/niri/config.kdl | \
    sed 's/^\s*//' | \
    sed 's/hotkey-overlay-title=//g' | \
    sed 's/"//g' | \
    sed 's/allow-when-locked=true//g' | \
    sed 's/allow-when-locked=false//g' | \
    sed 's/repeat=true//g' | \
    sed 's/repeat=false//g' | \
    sed 's/{.*//' | \
    sed 's/  \+/ /g' | \
    awk '{
        # Encuentra donde termina el keybind (primer espacio)
        match($0, /^[^ ]+/)
        keybind = substr($0, 1, RLENGTH)
        desc = substr($0, RLENGTH+1)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", desc)
        printf "%-30s %s\n", keybind, desc
    }' | \
    fzf --prompt="🔍 Buscar atajo: " \
        --height=70% \
        --border=rounded \
        --preview-window=hidden \
        --header='Busca por tecla o descripción'
