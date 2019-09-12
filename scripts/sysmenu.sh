#! /bin/bash

SEL=$(echo -e "Reboot\nlock\nsuspend\nShutdown\nreload\nLogout\n" | dmenu -p "System: ")

case "$SEL" in
Reboot) systemctl reboot ;;
lock) slock ;;
"suspend") systemctl suspend && slock ;;
Shutdown) systemctl poweroff ;;
#"reload") pkill dwm ;;
#Logout) pkill X ;;
esac
