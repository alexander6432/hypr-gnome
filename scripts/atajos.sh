#!/bin/bash

hyprctl binds | awk '
function modmask_to_names(mask,   names, i, result) {
    split("", names)
    if (and(mask, 128)) names[length(names)+1] = "ALTGR"
    if (and(mask, 64))  names[length(names)+1] = "SUPER"
    if (and(mask, 32))  names[length(names)+1] = "SCROLL"
    if (and(mask, 16))  names[length(names)+1] = "NUM"
    if (and(mask, 8))   names[length(names)+1] = "ALT"
    if (and(mask, 4))   names[length(names)+1] = "CTRL"
    if (and(mask, 2))   names[length(names)+1] = "CAPS"
    if (and(mask, 1))   names[length(names)+1] = "SHIFT"
    result = ""
    for (i = 1; i <= length(names); i++) {
        result = result names[i] " + "
    }
    return result
}

function format_key(k,   parts) {
    # Traducir scroll
    if (k == "mouse_up")   return "Scroll 󱕑"
    if (k == "mouse_down") return "Scroll 󱕐"
    if (k == "Tab") return "󰌒"
    if (k == "space") return "󱁐"
    if (k == "return") return "󰌑"
    if (k == "left") return ""
    if (k == "right") return ""
    if (k == "up") return ""
    if (k == "down") return ""
    if (k == "escape") return "󱊷"
    if (k == "F1") return "󱊫"
    if (k == "F2") return "󱊬"
    if (k == "PRINT") return "Impr Pant"
    if (k == "XF86AudioRaiseVolume") return ""
    if (k == "XF86AudioLowerVolume") return ""
    if (k == "XF86AudioMute") return ""
    if (k == "XF86AudioPause") return ""
    if (k == "XF86AudioPlay") return ""
    if (k == "XF86AudioStop") return ""
    if (k == "XF86AudioPrev") return "󰒮"
    if (k == "XF86AudioNext") return "󰒭"
    if (k == "XF86AudioMicMute") return ""
    if (k == "XF86MonBrightnessUp") return "󰃠"
    if (k == "XF86MonBrightnessDown") return "󰃞"

    # Traducir clicks
    if (k ~ /^mouse:[0-9]+$/) {
        split(k, parts, ":")
        if (parts[2] == 272) return " Izquie."
        if (parts[2] == 273) return " Derecho"
        if (parts[2] == 274) return " Medio"
        return "Mouse " parts[2]
    }

    # Limpiar prefijo XF86
    gsub(/^XF86/, "", k)
    return k
}

BEGIN {
    BOLD="\033[1m"
    RESET="\033[0m"
    BLUE="\033[34m"
    GREEN="\033[32m"
    CYAN="\033[36m"
    YELLOW="\033[33m"

    # Encabezado
    printf BOLD BLUE "%-15s %-9s %-76s\n" RESET, "TECLA LíDER", "TECLA", "DESCRIPCIÓN"
    printf "%s\n", "󰣇 ===  ===  === 󰣇 ===  ===  === 󰣇 ===  ===  === 󰣇 ===  ===  === 󰣇 ===  ===  === 󰣇 ===  ===  === 󰣇 "
}

/^bind/ {
    getline; modmask = $2
    getline; submap = $2
    getline; key = $2
    getline; keycode = $2
    getline; catchall = $2
    getline; desc = substr($0, index($0, $2))

    modnames = modmask_to_names(modmask)

    key_display = (key != "" ? key : (keycode != "" ? "KEYCODE_" keycode : catchall))
    key_display = format_key(key_display)

    # Imprimir línea con colores
    printf GREEN "%-16s" RESET, modnames
    printf CYAN "%-10s" RESET, key_display
    printf YELLOW "%-76s\n" RESET, desc
}
' | fzf --ansi --reverse --prompt="Buscar atajo: " --preview-window=down:3
