# 📦 hyprland-Gnome

Es una configuración básica de arch con hyprland, tratandose de apegarse con herramientas con base
GTK, al igual de facilitar el uso de la terminal usado fish como shell tan pronto se instale sin
configuraciónes complejas aunque solo tiene una configuración muy básica, asi que no será un
problema cambiar de shell por el que más prefieras y configurandolo tú mismo.  
NOTA: no tengo un script de instalación automática, pero si tienes conocimientos de archlinux
puedes instalarlo sin problemas tomando en cuenta siguientes Paquetes.  

#### SUPER + F1

Este comando permite ejecutar un script que permite para buscar los Comandos disponibles.
*OJO el comando esta sujeto al uso de wezterm, si prefieres otro Terminal es cuestion de
modificarlo en el archivo ~/.config/hypr/config/keybinding.conf*  

![Wofi](/capturas/Captura.png)  
![Pantalla de bloqueo](/capturas/Pantalla_de_Bloqueo.png)  
![Wallpapers](/capturas/Wallpaper.png)  

## Paquetes instalados(algunos son opcionales)

#### paru o yay

Es importante tener aun AUR helper como `paru` o `yay` para instalar los paquetes de AUR, ya que
ciertas funciones de Hyprland y sus complementos dependen de ellos.

### Paquetes AUR

`matugen-bin` para dar sorporte de el cambio de colores al el entorno (hyprland bordes),  
kitty(que a su vez da el color a starship, fastfetch, yazi).  
`noctalia-shell` un shell completo para hyprland.  

### Paquetes de repositorios oficiales

`git` para gestionar repositorios de Git.  
`hypridle` para gestionar el estado de inactividad de Hyprland.  
`hyprland` principal gestor de ventanas.  
`hyprshot` para capturas de pantalla.  
`wlsunset` para ajustar la calidez(luz azul) en pantalla.  
`nwg-look` para cambiar el tema de iconos y cursores en Hyprland de GTK.  
`polkit-gnome` para gestionar permisos de usuario en Hyprland.  
`xdg-desktop-portal-hyprland` para integrar aplicaciones GTK con Hyprland.  
`adw-gtk-theme` para el tema de GTK con noctalia-shell.
`qt5ct` para configurar aplicaciones QT en Hyprland con noctalia-shell.
`qt6ct` para configurar aplicaciones QT en Hyprland con noctalia-shell.
`hyprland-qt-support` para mejorar la compatibilidad de aplicaciones QT en Hyprland.

#### Otros Comandos útiles

* `SUPER + ENTER` Para abrir la terminal  
* `SUPER + G`(Desactivado por inestabilidad con pligins) Para Entrar en el Modo de Grupos(Este modo me permite agrupar ventanas y
moverlas juntas) y para salir de este con la tecla `Esc`  
* `SUPER + W` Para entrar en el Modo Ventanas(Este modo me permite mover y redimensionar
ventanas) y para salir de este con la tecla `Esc`  
*NOTA: Al entrar al los modos Grupos/Ventanas el resto de comandos no aplican hasta salir de dicho
Modo*  

#### Solo es para cambiar el valor de swappiness

 crear el archivo **/etc/sysctl.d/99-swappiness.conf**  
 con el *contenido vm.swappiness=10*  
 (reitero es opcional y solo si tienes swap y cuidar un poquito mas la SSD)

##### NOTA

Estas notas son tal vez sean de poca ayuda, sobre todo por que es un proyecto personal, mas que
para compartirlo, pero si te sirve de algo, me alegra mucho, y si tienes alguna duda o sugerencia,
hazmelo saber.  
