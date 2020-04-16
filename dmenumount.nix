pkgs: {
  dmenumount = pkgs.writeShellScriptBin "dmenumount" ''
    # Gives a dmenu prompt to mount unmounted drives and Android phones. If
    # they're in /etc/fstab, they'll be mounted automatically. Otherwise, you'll
    # be prompted to give a mountpoint from already existsing directories. If you
    # input a novel directory, it will prompt you to create that directory.
    
    getmount() { \
    	[ -z "$chosen" ] && exit 1
    	mp="$(find $1 2>/dev/null | ${pkgs.dmenu}/bin/dmenu -i -p "Type in mount point.")"
    	[ "$mp" = "" ] && exit 1
    	if [ ! -d "$mp" ]; then
    		mkdiryn=$(printf "No\\nYes" | ${pkgs.dmenu}/bin/dmenu -i -p "$mp does not exist. Create it?")
    		[ "$mkdiryn" = "Yes" ] && (mkdir -p "$mp" || sudo -A mkdir -p "$mp")
    	fi
    	}
    
    mountusb() { \
    	chosen="$(echo "$usbdrives" | ${pkgs.dmenu}/bin/dmenu -i -p "Mount which drive?" | awk '{print $1}')"
    	sudo -A mount "$chosen" 2>/dev/null && ${pkgs.libnotify}/bin/notify-send "💻 USB mounting" "$chosen mounted." && exit 0
    	alreadymounted=$(lsblk -nrpo "name,type,mountpoint" | awk '$2=="part"&&$3!~/\/boot|\/home$|SWAP/&&length($3)>1{printf "-not \\( -path *%s -prune \\) \\ \n",$3}')
    	getmount "/mnt /media /mount /home -maxdepth 5 -type d $alreadymounted"
    	partitiontype="$(lsblk -no "fstype" "$chosen")"
    	case "$partitiontype" in
    		"vfat") sudo -A mount -t vfat "$chosen" "$mp" -o rw,umask=0000;;
    		*) sudo -A mount "$chosen" "$mp"; user="$(whoami)"; ug="$(groups | awk '{print $1}')"; sudo -A chown "$user":"$ug" "$mp";;
    	esac
    	${pkgs.libnotify}/bin/notify-send "💻 USB mounting" "$chosen mounted to $mp."
    	}
    
    mountandroid() { \
    	chosen=$(echo "$anddrives" | ${pkgs.dmenu}/bin/dmenu -i -p "Which Android device?" | cut -d : -f 1)
    	getmount "$HOME -maxdepth 3 -type d"
    	simple-mtpfs --device "$chosen" "$mp"
    	${pkgs.libnotify}/bin/notify-send "🤖 Android Mounting" "Android device mounted to $mp."
    	}
    
    asktype() { \
    	case $(printf "USB\\nAndroid" | ${pkgs.dmenu}/bin/dmenu -i -p "Mount a USB drive or Android device?") in
    		USB) mountusb ;;
    		Android) mountandroid ;;
    	esac
    	}
    
    # anddrives=$(simple-mtpfs -l 2>/dev/null)
    # simple missing dependency thing
    usbdrives="$(lsblk -rpo "name,type,size,mountpoint" | awk '$2=="part"&&$4==""{printf "%s (%s)\n",$1,$3}')"
    
    if [ -z "$usbdrives" ]; then
    	[ -z "$anddrives" ] && echo "No USB drive or Android device detected" && exit
    	echo "Android device(s) detected."
    	mountandroid
    else
    	if [ -z "$anddrives" ]; then
    		echo "USB drive(s) detected."
    		mountusb
    	else
    		echo "Mountable USB drive(s) and Android device(s) detected."
    		asktype
    	fi
    fi
  '';

  dmenuumount = pkgs.writeShellScriptBin "dmenuumount" ''
    # A dmenu prompt to unmount drives.
    # Provides you with mounted partitions, select one to unmount.
    # Drives mounted at /, /boot and /home will not be options to unmount.
    
    unmountusb() {
    	[ -z "$drives" ] && exit
    	chosen=$(echo "$drives" | ${pkgs.dmenu}/bin/dmenu -i -p "Unmount which drive?" | awk '{print $1}')
    	[ -z "$chosen" ] && exit
    	sudo -A umount "$chosen" && ${pkgs.libnotify}/bin/notify-send "💻 USB unmounting" "$chosen unmounted."
    	}
    
    unmountandroid() { \
    	chosen=$(awk '/simple-mtpfs/ {print $2}' /etc/mtab | ${pkgs.dmenu}/bin/dmenu -i -p "Unmount which device?")
    	[ -z "$chosen" ] && exit
    	sudo -A umount -l "$chosen" && ${pkgs.libnotify}/bin/notify-send "🤖 Android unmounting" "$chosen unmounted."
    	}
    
    asktype() { \
    	case "$(printf "USB\\nAndroid" | ${pkgs.dmenu}/bin/dmenu -i -p "Unmount a USB drive or Android device?")" in
    		USB) unmountusb ;;
    		Android) unmountandroid ;;
    	esac
    	}
    
    drives=$(lsblk -nrpo "name,type,size,mountpoint" | awk '$2=="part"&&$4!~/\/boot|\/home$|SWAP/&&length($4)>1{printf "%s (%s)\n",$4,$3}')
    
    if ! grep simple-mtpfs /etc/mtab; then
    	[ -z "$drives" ] && echo "No drives to unmount." &&  exit
    	echo "Unmountable USB drive detected."
    	unmountusb
    else
    	if [ -z "$drives" ]
    	then
    		echo "Unmountable Android device detected."
    	       	unmountandroid
    	else
    		echo "Unmountable USB drive(s) and Android device(s) detected."
    		asktype
    	fi
    fi
    
  '';
}
