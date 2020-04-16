pkgs: rec {
  python-with-my-packages = pkgs.python3.withPackages (python-packages: with python-packages; [
    virtualenvwrapper
    evdev
  ]); 

  nmfd = pkgs.stdenv.mkDerivation rec {
    name = "nmfd-${version}";
    version = "1.1.3";
    src = pkgs.fetchFromGitHub {
      owner = "Ameliorate";
      repo = "nmfd";
      rev = "v${version}";
      sha256 = "1gk3kz9m8547yn9w7cr4a3nlg5pq7z86mksv2ayrmvcicm6m0ifc";
    };

    makeFlags = [ "INSTALL_PATH=$(out)/bin/" "MANUAL_PATH=$(out)/share/man/man1" ];

    preBuild = ''
        mkdir -p $out/bin
        mkdir -p $out/share/man/man1
    '';
  };

  syscmd = pkgs.writeShellScriptBin "syscmd" ''
    SEL=$(echo -e "lock\nReboot\nsuspend\nShutdown\nPassword\nreload\nLogout" | ${pkgs.dmenu}/bin/dmenu -p "System: ")

    case "$SEL" in
    Reboot) ${pkgs.libudev}/bin/systemctl reboot ;;
    lock) ${pkgs.i3lock}/bin/i3lock -c 000000 -f ;;
    "suspend") ${pkgs.libudev}/bin/systemctl suspend && ${pkgs.i3lock}/bin/i3lock -c 000000 -f ;;
    Shutdown) ${pkgs.libudev}/bin/systemctl poweroff ;;
    Password) ${pkgs.st}/bin/st -t 'LastPass Login' -g 80x20 -c lpasslogin ${pkgs.lastpass-cli}/bin/lpass login ameilorate2@gmail.com ;;
    "reload") ${pkgs.procps}/bin/pkill dwm && nohup ${dwm}/bin/dwm >/dev/null ;;
    Logout) ${pkgs.procps}/bin/pkill falsewm ;;
    esac
  '';

  dwm = let
    hideVacantTags = pkgs.fetchurl {
      url = "https://dwm.suckless.org/patches/hide_vacant_tags/dwm-hide_vacant_tags-6.2.diff";
      sha256 = "716d43cda73744abbe12c1ecd20fd55769c2a36730a57d0a12c09c06854b7fa8";
    };
  in pkgs.dwm.overrideAttrs (oldattrs: {
    patches = [
      hideVacantTags
    ];

    postPatch = ''
      cp "${./dwm-config.h}" config.def.h
    '';
  });

  falsewm = pkgs.writeShellScriptBin "falsewm" ''
    while true
    do
      sleep infinity
    done
  '';

  hacksh = import ./hacksh.nix pkgs;

  dmenumount = (import ./dmenumount.nix pkgs).dmenumount;
  dmenuumount = (import ./dmenumount.nix pkgs).dmenuumount;
}
