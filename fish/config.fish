set fish_greeting #Escribe cualquier cosa aquí

if status is-interactive
end

zoxide init fish | source

function gen-ssh
    read -P "Ingresa tu correo: " email
    ssh-keygen -t ed25519 -C "$email"
end

function update-grub
    sudo os-prober
    and sudo grub-mkconfig -o /boot/grub/grub.cfg
end

function update-mirrors
    echo "🔄 Actualizando mirrors..."
    sudo reflector --country MX,US \
        --age 24 --latest 20 --protocol https --number 10 \
        --sort rate --save /etc/pacman.d/mirrorlist
    and echo "✅ Mirrors actualizados"
    and sudo pacman -Syyu
    and echo "📦 Sistema actualizado con éxito"
end

function jazz
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

if string match -q "*Hyprland*" "$XDG_SESSION_DESKTOP"; or string match -q "*sway*" "$XDG_SESSION_DESKTOP"
    set -gx STARSHIP_CONFIG ~/.config/hyprship.toml
else
    set -gx STARSHIP_CONFIG ~/.config/starship.toml
end

starship init fish | source
