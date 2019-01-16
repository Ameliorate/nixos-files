{ config, pkgs, ... }:

let 
  laptop = false;
in {
  home-manager.users.amelorate = {
    xsession.windowManager.i3 = {
      enable = true;
      extraConfig = 
      ''
        set $mode_system System (l) lock, (e) logout, (n) switch user, (s) suspend, (Shift+r) reboot, (Shift+s) shutdown, (r) reload (Alt+r) restart i3
        set $mod Mod4

        workspace "1" output "HDMI-0"
        workspace "2" output "DVI-I-1"
        workspace "3" output "HDMI-0"
        workspace "4" output "DVI-I-1"
        workspace "5" output "HDMI-0"
        workspace "6" output "DVI-I-1"
        workspace "7" output "HDMI-0"
        workspace "8" output "DVI-I-1"
        workspace "9" output "HDMI-0"
        workspace "10" output "DVI-I-1"
        workspace "11" output "HDMI-0"
        workspace "12" output "DVI-I-1"
      '';
      config = {
        bars = [
          {
            mode = "dock";
            position = "top";
            statusCommand = "${pkgs.i3status}/bin/i3status";
          }
        ];
        keybindings = {
          "$mod+Return" = "exec ${pkgs.xfce.terminal}/bin/xfce4-terminal";
          "$mod+Shift+Return" = "exec ${pkgs.xfce.thunar}/bin/thunar";
          "$mod+backslash" = "exec ${pkgs.qutebrowser}/bin/qutebrowser";
          "$mod+Shift+backslash" = "exec ${pkgs.firefox}/bin/firefox";
          "$mod+q" = "kill";
          "$mod+d" = "exec --no-startup-id ${pkgs.dmenu}/bin/dmenu_run";
          "$mod+f" = "exec --no-startup-id ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop";
          "Print" = "exec --no-startup-id ${pkgs.maim}/bin/maim -s | tee ~/Pictures/Screenshots/$(date -u +\"%F_%T\").png | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
          "XF86MonBrightnessUp" = "exec --no-startup-id xbacklight -inc 10";
          "XF86MonBrightnessDown" = "exec --no-startup-id xbacklight -dec 10";

          "$mod+Home"   = "exec --no-startup-id mpc stop";
          "$mod+End"    = "exec --no-startup-id mpc next";
          "$mod+Delete" = "exec --no-startup-id mpc prev";
          "$mod+Insert" = "exec --no-startup-id mpc toggle";
          "$mod+Prior"  = "exec --no-startup-id mpc volume +5";
          "$mod+Next"   = "exec --no-startup-id mpc volume -5";
          "$mod+Shift+Prior"  = "exec --no-startup-id mpc volume +2";
          "$mod+Shift+Next"   = "exec --no-startup-id mpc volume -2";

          "XF86AudioRaiseVolume" = "exec --no-startup-id amixer set 'Master' 5%+";
          "Shift+XF86AudioRaiseVolume" = "exec --no-startup-id amixer set 'Master' 2%+";
          "XF86AudioLowerVolume" = "exec --no-startup-id amixer set 'Master' 5%-";
          "Shift+XF86AudioLowerVolume" = "exec --no-startup-id amixer set 'Master' 2%-";

          "$mod+Shift+r" = "split h";
          "$mod+Shift+v" = "split v";
          "$mod+Shift+x" = "fullscreen toggle";
          "$mod+Shift+s" = "layout stacking";
          "$mod+Shift+w" = "layout tabbed";
          "$mod+Shift+e" = "layout toggle split";
          "$mod+Shift+space" = "floating toggle";
          "$mod+space" = "focus mode_toggle"; # Switch between focusing floating and normal windows.
          "$mod+p" = "focus parent";
          "$mod+c" = "focus child";

          "$mod+h" = "focus left";
          "$mod+j" = "focus down";
          "$mod+k" = "focus up";
          "$mod+l" = "focus right";

          "$mod+Shift+h" = "move left";
          "$mod+Shift+j" = "move down";
          "$mod+Shift+k" = "move up";
          "$mod+Shift+l" = "move right";

          "$mod+grave" = "workspace 0";
          "$mod+1" = "workspace 1";
          "$mod+2" = "workspace 2";
          "$mod+3" = "workspace 3";
          "$mod+4" = "workspace 4";
          "$mod+5" = "workspace 5";
          "$mod+6" = "workspace 6";
          "$mod+7" = "workspace 7";
          "$mod+8" = "workspace 8";
          "$mod+9" = "workspace 9";
          "$mod+0" = "workspace 10";
          "$mod+minus" = "workspace 11";
          "$mod+equal" = "workspace 12";

          "$mod+comma" = "workspace prev_on_output";
          "$mod+period" = "workspace next_on_output";

          "$mod+Shift+1" = "move container to workspace 1";
          "$mod+Shift+2" = "move container to workspace 2";
          "$mod+Shift+3" = "move container to workspace 3";
          "$mod+Shift+4" = "move container to workspace 4";
          "$mod+Shift+5" = "move container to workspace 5";
          "$mod+Shift+6" = "move container to workspace 6";
          "$mod+Shift+7" = "move container to workspace 7";
          "$mod+Shift+8" = "move container to workspace 8";
          "$mod+Shift+9" = "move container to workspace 9";
          "$mod+Shift+0" = "move contianer to workspace 10";
          "$mod+Shift+minus" = "move container to workspace 11";
          "$mod+Shift+equal" = "move container to workspace 12";

          "$mod+r" = "mode \"resize\"";
          "$mod+z" = "mode \"$mode_system\"";
          "$mod+w" = "mode \"w\"";
        };
        modes = {
          resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";
            "Return" = "mode \"default\"";
            "Escape" = "mode \"default\"";
          };
          "$mode_system" = {
            "l" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -c 000000, mode \"default\"";
            "s" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -c 000000 && systemctl suspend, mode \"default\"";
            "Shift+r" = "exec --no-startup-id systemctl reboot, mode \"default\"";
            "Shift+s" = "exec --no-startup-id systemctl poweroff -i, mode \"default\"";
            "Shift+e" = "exit, mode \"default\"";
            "r" = "reload, mode \"default\"";
            "Mod1+r" = "restart, mode \"default\"";
            "n" = "exec --no-startup-id \"qdbus --system org.freedesktop.DisplayManager /org/freedesktop/DisplayManager/Seat0 org.freedesktop.DisplayManager.Seat.SwitchToGreeter\", exec --no-startup-id ${pkgs.i3lock}/bin/i3locl -c 000000 ,mode \"default\"";
            "k" = "exec \"xfce4-terminal --title='LastPass Login' --command='lpass login ameilorate2@gmail.com' --hide-menubar --hide-toolbar --geometry 80x20 --role='pop-up'\", mode \"default\"";
            "Return" = "mode \"default\"";
            "Escape" = "mode \"default\"";
          };
          w = {
            "Escape" = "mode \"default\"";
            "Return" = "mode \"default\"";
            "q" = "workspace q; mode \"default\"";
            "Shift+q" = "move container to workspace q; mode \"default\"";
            "w" = "workspace w; mode \"default\"";
            "Shift+w" = "move container to workspace w; mode \"default\"";
            "e" = "workspace e; mode \"default\"";
            "Shift+e" = "move container to workspace e; mode \"default\"";
            "r" = "workspace r; mode \"default\"";
            "Shift+r" = "move container to workspace r; mode \"default\"";
            "t" = "workspace t; mode \"default\"";
            "Shift+t" = "move container to workspace t; mode \"default\"";
            "y" = "workspace y; mode \"default\"";
            "Shift+y" = "move container to workspace y; mode \"default\"";
            "u" = "workspace u; mode \"default\"";
            "Shift+u" = "move container to workspace u; mode \"default\"";
            "i" = "workspace i; mode \"default\"";
            "Shift+i" = "move container to workspace i; mode \"default\"";
            "o" = "workspace o; mode \"default\"";
            "Shift+o" = "move container to workspace o; mode \"default\"";
            "p" = "workspace p; mode \"default\"";
            "Shift+p" = "move container to workspace p; mode \"default\"";
            "a" = "workspace a; mode \"default\"";
            "Shift+a" = "move container to workspace a; mode \"default\"";
            "s" = "workspace s; mode \"default\"";
            "Shift+s" = "move container to workspace s; mode \"default\"";
            "d" = "workspace d; mode \"default\"";
            "Shift+d" = "move container to workspace d; mode \"default\"";
            "f" = "workspace f; mode \"default\"";
            "Shift+f" = "move container to workspace f; mode \"default\"";
            "g" = "workspace g; mode \"default\"";
            "Shift+g" = "move container to workspace g; mode \"default\"";
            "h" = "workspace h; mode \"default\"";
            "Shift+h" = "move container to workspace h; mode \"default\"";
            "j" = "workspace j; mode \"default\"";
            "Shift+j" = "move container to workspace j; mode \"default\"";
            "k" = "workspace k; mode \"default\"";
            "Shift+k" = "move container to workspace k; mode \"default\"";
            "l" = "workspace l; mode \"default\"";
            "Shift+l" = "move container to workspace l; mode \"default\"";
            "z" = "workspace z; mode \"default\"";
            "Shift+z" = "move container to workspace z; mode \"default\"";
            "x" = "workspace x; mode \"default\"";
            "Shift+x" = "move container to workspace x; mode \"default\"";
            "c" = "workspace c; mode \"default\"";
            "Shift+c" = "move container to workspace c; mode \"default\"";
            "v" = "workspace v; mode \"default\"";
            "Shift+v" = "move container to workspace v; mode \"default\"";
            "b" = "workspace b; mode \"default\"";
            "Shift+b" = "move container to workspace b; mode \"default\"";
            "n" = "workspace n; mode \"default\"";
            "Shift+n" = "move container to workspace n; mode \"default\"";
            "m" = "workspace m; mode \"default\"";
            "Shift+m" = "move container to workspace m; mode \"default\"";
          };
        };
        startup = [
          { command = "qutebrowser"; }
          { command = "Discord"; }
          #{ command = "oneko -tofocus -speed 35"; }
          { command = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent"; notification = false; }
          (if !laptop then { command = "mpd"; notification = false; } else null)
        ];
        floating.criteria = [
          { window_role = "pop-up"; }
          { window_role = "task_dialog"; }
          { title = "Preferences$"; }
          { title = "^Steam - Update News$"; }
          { title = "^Steam Guard"; }
        ];
        floating.modifier = "Mod4";
        assigns = {
          "2" = [{ class = "^discord$"; }];
        };
        focus.newWindow = "none";
      };
    };

    home.file."i3bar" = {
      target = ".config/i3status/config";
      text =
      ''
        general {
          output_format = "i3bar"
          colors = true
          interval = 5
        }

        order += "volume master"
        order += "disk /"
        order += "disk /home"
        ${if laptop then "order += \"wireless _first_\"" else ""}
        ${if laptop then "order += \"battery 0\"" else ""}
        order += "tztime local"

        volume master {
          device = "pulse"
          format = "vol:%volume"
          format_muted = "vol:mute"
        }

        wireless _first_ {
          format_up = "W: (%quality at %essid) %ip"
          format_down = "W: down"
        }

        battery 0 {
          last_full_capacity = true
          integer_battery_capacity = true
          format = "%status %percentage %remaining"
        }

        tztime local {
          format = "%a %b %d-%m-%y %I:%M %p"
        }

        disk "/" {
          format = "/%avail"
        }

        disk "/home" {
          format = "/home/%avail"
        }
      '';
    };
  };
}
