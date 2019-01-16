{ pkgs, isLaptop }:

{ 
  programs.git = {
    enable = true;
    userName = "Amelorate";
    userEmail = "ameilorate2@gmail.com";
    ignores = [ "*~" ];
  };

  programs.vim = {
    enable = true;
    plugins = [ "rust-vim" "vim-nix" "syntastic"];
    settings = {
      number = true;
      background = "dark";
    };
    extraConfig =
      ''
        filetype plugin indent on
        syntax on
        set cursorline
        set clipboard=unnamedplus
        let g:rustfmt_autosave = 1
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 1
      '';
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Arc";
        package = pkgs.arc-icon-theme;
      };
      theme = {
        name = "Adwaita";
        package = pkgs.gnome3.gnome_themes_standard;
      };
    };

  home.file."mpd" = if !isLaptop then {
    target = ".config/mpd/mpd.conf";
    text =
      ''
        db_file            "~/.config/mpd/database"
        log_file           "~/.config/mpd/log"
        music_directory    "/mnt/hdd/music"
        playlist_directory "~/.config/mpd/playlists"
        pid_file           "~/.config/mpd/pid"
        state_file         "~/.config/mpd/state"
        sticker_file       "~/.config/mpd/sticker.sql"

        follow_outside_symlinks	"yes"
        follow_inside_symlinks  "yes"

        audio_output {
        type "pulse"
        name "Music Player Daemon"
        }
      '';
    } else {};

  home.file."fish" = {
    target = ".config/fish";
    source = ./fish;
    recursive = true;
  };
}
