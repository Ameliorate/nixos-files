{pkgs, lpkgs, unstable, unstable-small}: ''
  # menu
  super+p
    ${pkgs.dmenu}/bin/dmenu_run
  super+o
    ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop
  super+z
    ${lpkgs.syscmd}/bin/syscmd
  Print
    ${pkgs.maim}/bin/maim -s | tee ~/Pictures/Screenshots/$(date -u +"%F_%T").png | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png

  # laptop
  XF86MonBrightness{Up,Down}
    ${pkgs.xorg.xbacklight}/bin/xbacklight -{inc,dec} 10

  # applications
  super+shift+Return
    ${pkgs.xfce.terminal}/bin/xfce4-terminal
  super+backslash
    ${pkgs.qutebrowser}/bin/qutebrowser
  XF86Calculator
    ${pkgs.st}/bin/st -c calculator -t j -g 80x40+650+250 -f undefined-medium:pixelsize=12 -e ${pkgs.j}/bin/jconsole

  # music
  super+Home
    ${pkgs.mpc_cli}/bin/mpc stop
  super+{End,Delete}
    ${pkgs.mpc_cli}/bin/mpc {next,prev}
  super+Insert
    ${pkgs.mpc_cli}/bin/mpc toggle
  super+{Prior,Next}
    ${pkgs.mpc_cli}/bin/mpc volume {+,-}5
  super+shift+{Prior,Next}
    ${pkgs.mpc_cli}/bin/mpc volume {+,-}2

  # audio
  XF86Audio{Raise,Lower}Volume
    ${pkgs.alsaUtils}/bin/amixer set 'Master' 5%{+,-}
  shift+XF86Audio{Raise,Lower}Volume
    ${pkgs.alsaUtils}/bin/amixer set 'Master' 2%{+,-}

  # other
  {alt,ctrl}+Caps_Lock
    ${pkgs.xdotool}/bin/xdotool key{down,up} shift

''
