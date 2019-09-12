{ config, pkgs, ... }:

let
  unstable = import <unstable> { config = { 
    allowUnfree = true; 
  }; };

  unstable-small = import <unstable-small> { config = { allowUnfree = true; }; };

  lpkgs = import ./lpkgs.nix pkgs;

  laptop = false;
in {
  imports = [ 
    ./hardware-configuration.nix
    ./i3.nix
    "${<home-manager>}/nixos"
  ];

  home-manager.users.amelorate = import ./home-manager.nix { pkgs = pkgs; isLaptop = laptop; };

  boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

#  boot.loader.grub = {
#    enable = true;
#    device = "/dev/sda";
#    efiSupport = true;
#    splashImage = ./grubwallpaper.png;
#  };

#  boot.plymouth = {
#    enable = true;
#  };

  environment.shells = [
    pkgs.fish
    pkgs.bashInteractive
  ];

  environment.systemPackages = import ./packages.nix { 
    inherit pkgs unstable unstable-small lpkgs;
    isLaptop = laptop;
  };


  environment.variables = {
  _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  fonts = {
    enableGhostscriptFonts = true;
    fonts = [
      pkgs.meslo-lg
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-emoji
      pkgs.liberation_ttf
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.mplus-outline-fonts
      pkgs.dina-font
      pkgs.proggyfonts
      pkgs.source-code-pro
      pkgs.undefined-medium
    ];
  };

  fileSystems."/".device =     pkgs.lib.mkForce "/dev/disk/by-label/root";
  fileSystems."/boot".device = pkgs.lib.mkForce "/dev/disk/by-label/BOOT";
  fileSystems."/home".device = pkgs.lib.mkForce "/dev/disk/by-label/home";

  fileSystems."/mnt/hdd".device = if !laptop then "/dev/sdb1" else "";

  hardware.cpu.intel.updateMicrocode = true;

  hardware.opengl.driSupport32Bit = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.extraConfig = 
  ''
    load-module module-echo-cancel source_name=<alsa_input.pci-0000_00_1b.0.analog-stereo>
  '';

  hardware.steam-hardware.enable = true;

  networking.hostName = if !laptop then "amel-nix-desk-1" else "amel-nix-lap-1";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix = {
    buildCores = 0;
    maxJobs = 4;
    trustedUsers = [ "root" "@wheel" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.adb.enable = true;

  programs.command-not-found.enable = true;

  programs.fish.enable = true;

  programs.java.enable = true;

  programs.vim.defaultEditor = true;

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    bind = "localhost";
    ensureUsers = [
      { ensurePermissions = { "*.*" = "ALL PRIVILEGES"; }; name = "amelorate"; }
    ];
  };

  services.resolved.enable = true;
  services.resolved.fallbackDns = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];

  services.printing.enable = !laptop;

  services.udisks2.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";

  services.xserver.videoDrivers = if !laptop then [ "nvidia" ] else [ "intel" ];

  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "breeze";
  };

  services.xserver.xrandrHeads = if !laptop then [
    { output = "HDMI-0"; primary = true; }
    "DVI-I-1"
  ] else [];

  services.xserver.dpi = 83;

  services.xserver.windowManager.i3 = {
    enable = false; # !!!!!!!!!!
  };

  services.xserver.desktopManager.session = let sxconfig = pkgs.writeText "keybinds" (import ./keybinds.nix { inherit lpkgs pkgs unstable unstable-small; }); in [ { 
    manage = "desktop";
    name = "dwm";
    start = ''
      systemctl start "sxhkd@$DISPLAY.service" &
      systemctl start "dwmstatus@$DISPLAY.service" &
      ${lpkgs.hacksh.server}/bin/hackshserver &
      ${pkgs.feh}/bin/feh --bg-fill ~/Pictures/bebe.png &
      ${pkgs.mpd}/bin/mpd &
      ${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent &
      ${pkgs.qutebrowser}/bin/qutebrowser &
      ${unstable-small.discord}/bin/Discord &
      ${lpkgs.dwm}/bin/dwm &
      ${lpkgs.falsewm}/bin/falsewm &
      waitPID=$!
    '';
  } ];

  systemd.units."sxhkd@.service" = let
    sxconfig = pkgs.writeText "keybinds" (import ./keybinds.nix { inherit lpkgs pkgs unstable unstable-small; });
    script = pkgs.writeShellScriptBin "sxhkd-run" "SHELL=${lpkgs.hacksh.client}/bin/hackshclient ${pkgs.sxhkd}/bin/sxhkd -c ${sxconfig}";
  in {
    text = ''
      [Unit]
      Description=Simple X Hotkey Daemon

      [Service]
      Environment=DISPLAY=%i
      ExecStart=${script}/bin/sxhkd-run
      User=amelorate
    '';
  };

  systemd.units."dwmstatus@.service" = let 
    dwmstatuscfg = pkgs.writeText "dwm-status-config.json" (builtins.toJSON (import ./dwm-status.nix));
    script = pkgs.writeShellScriptBin "dwm-status-run" "${pkgs.dwm-status}/bin/dwm-status ${dwmstatuscfg}";
  in {
    text = ''
      [Unit]
      Description=DWM Status Monitor

      [Service]
      Environment=DISPLAY=%i
      ExecStart=${script}/bin/dwm-status-run
      User=amelorate
    '';
  };

  # These commented lines are what I want it to work, but eversmart nixos escapes the @ symbols, of course.
  #systemd.services."sxhkd@.service" = let 
  #  sxconfig = pkgs.writeText "keybinds" (import ./keybinds.nix { inherit lpkgs pkgs unstable unstable-small; });
  #in {
  #  description = "Simple X Hotkey Daemon";
  #  script = "${pkgs.sxhkd}/bin/sxhkd -c ${sxconfig}";
  #  environment.DISPLAY = "%i";
  #  
  #  serviceConfig.User = "amelorate";
  #};

  #systemd.services."dwmstatus@.service" = let 
  #  dwmstatuscfg = pkgs.writeText "dwm-status-config.json" (builtins.toJSON (import ./dwm-status.nix));
  #in {
  #  description = "DWM Status Monitor";
  #  script = "${pkgs.dwm-status}/bin/dwm-status ${dwmstatuscfg}";
  #  environment.DISPLAY = "%i";
  #  
  #  serviceConfig.User = "amelorate";
  #};

  security.wrappers.slock.source = "${pkgs.slock.out}/bin/slock";

  security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" && /^(sxhkd)|(dwmstatus)@/.test(action.lookup("unit")) && /\.service$/.test(action.lookup("unit"))) {
          return "yes";
        }
      });
  '';

  sound.enable = true;

  time.timeZone = "America/Los_Angeles";

  virtualisation.virtualbox.host.enable = false;

  users = {
    extraUsers = {
      amelorate = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
        shell = pkgs.fish;
        initialHashedPassword = "$6$rounds=1000000$Pkx6HnOMgd$uFfMABBXPcompNpFIe4O6cYcpY05uwwGC.DI.VzDRgju7SX2PJKR0CCFY3OBLkYScSMC4mZAJShPCqn5.L0Yw.";
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
